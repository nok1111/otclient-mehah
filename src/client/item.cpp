/*
 * Copyright (c) 2010-2024 OTClient <https://github.com/edubart/otclient>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "item.h"
#include "container.h"
#include "creature.h"
#include "game.h"
#include "gameconfig.h"
#include "spritemanager.h"
#include "thing.h"
#include "thingtypemanager.h"
#include "tile.h"

#include <framework/core/clock.h>
#include <framework/core/filestream.h>
#include <framework/graphics/drawpoolmanager.h>
#include <framework/graphics/painter.h>
#include <framework/graphics/shadermanager.h>
#include <algorithm>
#include <cmath>
#ifdef FRAMEWORK_EDITOR
#include <framework/core/binarytree.h>
#endif

#ifdef FRAMEWORK_EDITOR
#include <framework/core/binarytree.h>
#endif

ItemPtr Item::create(const int id)
{
    const auto& item = std::make_shared<Item>();
    item->setId(id);

    return item;
}

// Heuristic filter: which items should cast a drop shadow.
// Goal: only "structural / volumetric" items (walls, pillars, trees, furniture,
// statues, big props) — skip ground, decals, on-top overlays, wall-attached
// items and splashes/fluids that visually have no body.
bool Item::shouldCastShadow()
{
    // Hard rejects: surface or non-physical things
    if (isGround() || isGroundBorder())   return false;
    if (isSplash() || isFluidContainer()) return false;
    if (isTopEffect())                    return false;
    if (isOnTop())                        return false; // signs/decals above stuff
    // Wall-attached props (paintings, torches, banners): hang on a vertical
    // surface, drop shadow under them looks wrong.
    if (isHangable() || isHookSouth() || isHookEast()) return false;
    // Translucent: explicit author opt-out for thin/transparent objects
    // (fences, low railings, glass, bushes, webs, curtains).
    if (isTranslucent()) return false;

    // Positive criteria: tall / blocking. Note: walls have isOnBottom()==true
    // (stack priority 2, drawn before creatures), so we do NOT reject onBottom
    // outright — we let the positive criteria below promote them.
    if (hasElevation())   return true; // tables, chairs, beds, raisable furniture
    if (isNotWalkable())  return true; // walls, pillars, trees, statues, barrels, doors

    // Remaining on-bottom items (walkable, no elevation) are carpets / decals → skip.
    return false;
}

void Item::drawDropShadow(const int animationPhase, const Point& dest, const bool drawThings)
{
    const int shadowAlpha = Creature::getShadowAlpha();
    if (shadowAlpha <= 0) return;

    const int shadowType = Creature::getShadowType();
    const float scale = g_drawPool.getScaleFactor();

    if (shadowType == 0) {
        // MIRROR: stretched silhouette streak toward SE. Mirrors creature path.
        constexpr float DIR_X = 0.55f;
        constexpr float DIR_Y = 0.85f;
        constexpr int   LEN   = 22;
        constexpr int   STEPS = 7;
        const float stepLen = (LEN * scale) / static_cast<float>(STEPS);
        for (int i = 1; i <= STEPS; ++i) {
            const float t = static_cast<float>(i) / static_cast<float>(STEPS);
            const float fade = 1.0f - t;
            int a = static_cast<int>(shadowAlpha * fade / static_cast<float>(STEPS) * 3.2f);
            if (a > 255) a = 255;
            if (a <= 0) continue;
            const Point off(
                static_cast<int>(DIR_X * stepLen * i),
                static_cast<int>(DIR_Y * stepLen * i)
            );
            internalDraw(animationPhase, dest + off, Color(0, 0, 0, a), drawThings, true);
        }
    } else {
        // BLOB: flat dark ellipse centered under the item's footprint.
        const int sprSize = g_gameConfig.getSpriteSize();
        const Point feet(
            dest.x + static_cast<int>(sprSize * 0.5f * scale),
            dest.y + static_cast<int>(sprSize * 0.95f * scale)
        );
        constexpr int W = 26;
        constexpr int H = 8;
        constexpr int LAYERS = 3;
        for (int layer = 0; layer < LAYERS; ++layer) {
            const float k = 1.0f - static_cast<float>(layer) / static_cast<float>(LAYERS);
            const int w = static_cast<int>(W * scale * k);
            const int h = (std::max)(2, static_cast<int>(H * scale * k));
            int a = static_cast<int>((shadowAlpha / static_cast<float>(LAYERS)) * (1.1f + 0.9f * (1.0f - k)));
            if (a > 255) a = 255;
            if (a <= 0 || w <= 0) continue;
            g_drawPool.addFilledRect(
                Rect(feet.x - w / 2, feet.y - h / 2, w, h),
                Color(0, 0, 0, a)
            );
        }
    }
}

// Light core: a small bright additive-looking dot drawn over light-emitting
// items, using the item's own light color. Combined with the bloom shader the
// item visually "glows" instead of just being a flat sprite.
void Item::drawLightCore(const Point& dest)
{
    auto* type = getThingType();
    if (!type || !type->hasLight()) return;

    const Light& light = type->getLight();
    if (light.intensity == 0) return;

    const float intensityCfg = Creature::getLightCoreIntensity() / 100.f;
    if (intensityCfg <= 0.f) return;

    const float scale = g_drawPool.getScaleFactor();

    // Source color (Tibia 8-bit indexed). Tint white if 0/default.
    Color baseColor = (light.color == 0) ? Color::white : Color::from8bit(light.color);

    // Warm-color flicker: if R dominates B notably, modulate brightness.
    // Cool/blue/green lights stay steady.
    float brightness = 1.f;
    if (static_cast<int>(baseColor.r()) > static_cast<int>(baseColor.b()) + 30) {
        // Mix two sinusoids of different periods for organic flame feel.
        const float t = g_clock.millis() / 1000.f;
        brightness = 0.85f + 0.15f * (std::sin(t * 7.3f) * 0.6f + std::sin(t * 12.1f) * 0.4f);
    }

    // Size scales with light.intensity (Tibia practical range 1-8, but clamp).
    const float intF = std::min<float>(light.intensity, 10) / 10.f;
    const int coreSize = static_cast<int>((4.f + 12.f * intF) * scale);
    if (coreSize <= 0) return;

    // Final alpha: combine config intensity, light intensity and flicker.
    int a = static_cast<int>(255 * intensityCfg * (0.55f + 0.45f * intF) * brightness);
    if (a > 255) a = 255;
    if (a <= 0) return;

    const Color coreColor(baseColor.r(), baseColor.g(), baseColor.b(), static_cast<uint8_t>(a));

    // Center on the sprite tile.
    const int sprSize = g_gameConfig.getSpriteSize();
    const Point center(
        dest.x + static_cast<int>(sprSize * 0.5f * scale) - coreSize / 2,
        dest.y + static_cast<int>(sprSize * 0.5f * scale) - coreSize / 2
    );

    // Stacked layers fake a soft radial gradient: outer big & dim, inner small & bright.
    for (int layer = 0; layer < 3; ++layer) {
        const float k = 1.f - layer * 0.30f; // 1.0, 0.7, 0.4
        const int w = static_cast<int>(coreSize * (0.4f + layer * 0.4f)); // 0.4, 0.8, 1.2
        const int la = static_cast<int>(a * k);
        if (la <= 0 || w <= 0) continue;
        const Color c(baseColor.r(), baseColor.g(), baseColor.b(), static_cast<uint8_t>(la));
        g_drawPool.addFilledRect(
            Rect(center.x + (coreSize - w) / 2, center.y + (coreSize - w) / 2, w, w),
            c
        );
    }
}

void Item::draw(const Point& dest, const bool drawThings, const LightViewPtr& lightView)
{
    if (!canDraw(m_color) || isHided())
        return;

    // determine animation phase
    const int animationPhase = calculateAnimationPhase();

    // Drop shadow (phase 2): only "important" structural items.
    // Drawn BEFORE the item sprite so it sits visually beneath.
    if (Creature::isDrawingShadows() && Creature::isDrawingItemShadows() && shouldCastShadow()) {
        drawDropShadow(animationPhase, dest, drawThings);
    }

    internalDraw(animationPhase, dest, m_color, drawThings, false, lightView);

    // Light core: drawn AFTER the sprite so the bright dot sits on top.
    if (Creature::isDrawingLightCores()) {
        drawLightCore(dest);
    }

    if (isMarked())
        internalDraw(animationPhase, dest, getMarkedColor(), drawThings, true);
    else if (isHighlighted())
        internalDraw(animationPhase, dest, getHighlightColor(), drawThings, true);
}

void Item::internalDraw(const int animationPhase, const Point& dest, const Color& color, const bool drawThings, const bool replaceColorShader, const LightViewPtr& lightView)
{
    if (replaceColorShader)
        g_drawPool.setShaderProgram(g_painter->getReplaceColorShader(), true);
    else {
        // Example of how to send a UniformValue to shader
        /*const auto& shaderAction = [=]()-> void {
            m_shader->bind();
            m_shader->setUniformValue(ShaderManager::ITEM_ID_UNIFORM, static_cast<int>(getId()));
        };*/

        drawAttachedEffect(dest, lightView, false); // On Bottom
        if (hasShader())
            g_drawPool.setShaderProgram(g_shaders.getShaderById(m_shaderId), true/*, shaderAction*/);
    }

    getThingType()->draw(dest, 0, m_numPatternX, m_numPatternY, m_numPatternZ, animationPhase, color, drawThings, lightView);
    g_drawPool.resetShaderProgram();

    if (!replaceColorShader) {
        drawAttachedEffect(dest, lightView, true); // On Top
        drawAttachedParticlesEffect(dest);
    }
}

void Item::drawLight(const Point& dest, const LightViewPtr& lightView) {
    if (!lightView) return;
    getThingType()->draw(dest, 0, m_numPatternX, m_numPatternY, m_numPatternZ, 0, Color::white, false, lightView);
    drawAttachedLightEffect(dest, lightView);
}

void Item::setPosition(const Position& position, const uint8_t stackPos)
{
    Thing::setPosition(position, stackPos);
}

int Item::getSubType()
{
    if (isSplash() || isFluidContainer())
        return m_countOrSubType;

    return g_game.getClientVersion() > 862 ? 0 : 1;
}

ItemPtr Item::clone()
{
    auto item = std::make_shared<Item>();
    *(item.get()) = *this;

    if (item->m_data) {
        item->m_data = nullptr;

        // Copy Vector
        item->getData()->attachedEffects = m_data->attachedEffects;
        item->getData()->attachedParticles = m_data->attachedParticles;
        item->getData()->attachedWidgets = m_data->attachedWidgets;
    }

    return item;
}

void Item::updatePatterns()
{
    m_numPatternX = m_numPatternY =
        m_numPatternZ = 0;

    // Avoid crashes with invalid items
    if (!isValid())
        return;

    const int numPatternX = getNumPatternX();
    const int numPatternY = getNumPatternY();

    if (isStackable() && numPatternX == 4 && numPatternY == 2) {
        if (m_countOrSubType <= 0) {
            m_numPatternX = 0;
            m_numPatternY = 0;
        } else if (m_countOrSubType < 5) {
            m_numPatternX = m_countOrSubType - 1;
            m_numPatternY = 0;
        } else if (m_countOrSubType < 10) {
            m_numPatternX = 0;
            m_numPatternY = 1;
        } else if (m_countOrSubType < 25) {
            m_numPatternX = 1;
            m_numPatternY = 1;
        } else if (m_countOrSubType < 50) {
            m_numPatternX = 2;
            m_numPatternY = 1;
        } else {
            m_numPatternX = 3;
            m_numPatternY = 1;
        }
    } else if (isHangable()) {
        const auto& tile = getTile();
        if (tile) {
            if (tile->mustHookSouth())
                m_numPatternX = numPatternX >= 2 ? 1 : 0;
            else if (tile->mustHookEast())
                m_numPatternX = numPatternX >= 3 ? 2 : 0;
        }
    } else if (isSplash() || isFluidContainer()) {
        int color = m_countOrSubType;
        if (g_game.getFeature(Otc::GameNewFluids)) {
            switch (m_countOrSubType) {
                case Otc::FluidNone:
                    color = Otc::FluidTransparent;
                    break;
                case Otc::FluidWater:
                    color = Otc::FluidBlue;
                    break;
                case Otc::FluidMana:
                    color = Otc::FluidPurple;
                    break;
                case Otc::FluidBeer:
                    color = Otc::FluidOrange;
                    break;
                case Otc::FluidOil:
                    color = Otc::FluidOrange;
                    break;
                case Otc::FluidBlood:
                    color = Otc::FluidRed;
                    break;
                case Otc::FluidSlime:
                    color = Otc::FluidGreen;
                    break;
                case Otc::FluidMud:
                    color = Otc::FluidOrange;
                    break;
                case Otc::FluidLemonade:
                    color = Otc::FluidYellow;
                    break;
                case Otc::FluidMilk:
                    color = Otc::FluidWhite;
                    break;
                case Otc::FluidWine:
                    color = Otc::FluidPurple;
                    break;
                case Otc::FluidHealth:
                    color = Otc::FluidRed;
                    break;
                case Otc::FluidUrine:
                    color = Otc::FluidYellow;
                    break;
                case Otc::FluidRum:
                    color = Otc::FluidOrange;
                    break;
                case Otc::FluidFruitJuice:
                    color = Otc::FluidYellow;
                    break;
                case Otc::FluidCoconutMilk:
                    color = Otc::FluidWhite;
                    break;
                case Otc::FluidTea:
                    color = Otc::FluidOrange;
                    break;
                case Otc::FluidMead:
                    color = Otc::FluidOrange;
                    break;
                case Otc::FluidInk:
                    color = Otc::FluidBlack;
                    break;
                case Otc::FluidCandy:
                    color = Otc::FluidPink;
                    break;
                case Otc::FluidChocolate:
                    color = Otc::FluidBrown;
                    break;
                default:
                    color = Otc::FluidTransparent;
                    break;
            }
        }

        m_numPatternX = (color % 4) % numPatternX;
        m_numPatternY = (color / 4) % numPatternY;
    } else {
        m_numPatternX = m_position.x % std::max<int>(1, numPatternX);
        m_numPatternY = m_position.y % std::max<int>(1, numPatternY);
        m_numPatternZ = m_position.z % std::max<int>(1, getNumPatternZ());
    }
}

int Item::calculateAnimationPhase()
{
    if (!hasAnimationPhases() || !canAnimate()) return 0;

    if (getIdleAnimator()) return getIdleAnimator()->getPhase();

    if (m_async) {
        return (g_clock.millis() % (g_gameConfig.getItemTicksPerFrame() * getAnimationPhases())) / g_gameConfig.getItemTicksPerFrame();
    }

    if (g_clock.millis() - m_lastPhase >= g_gameConfig.getItemTicksPerFrame()) {
        m_phase = (m_phase + 1) % getAnimationPhases();
        m_lastPhase = g_clock.millis();
    }

    return m_phase;
}

void Item::setId(uint32_t id)
{
    if (!g_things.isValidDatId(id, ThingCategoryItem))
        id = 0;

#ifdef FRAMEWORK_EDITOR
    m_serverId = g_things.findItemTypeByClientId(id)->getServerId();
#endif

    m_clientId = id;

    // Shader example on only items that can be marketed.
    /*
    if (isMarketable()) {
        m_shaderId = g_shaders.getShader("Outfit - Outline")->getId();
    }
    */
}

ThingType* Item::getThingType() const {
    return g_things.getRawThingType(m_clientId, ThingCategoryItem);
}

#ifdef FRAMEWORK_EDITOR

std::string Item::getName()
{
    return g_things.findItemTypeByClientId(m_clientId)->getName();
}

ItemPtr Item::createFromOtb(int id)
{
    const auto& item = std::make_shared<Item>();
    item->setOtbId(id);

    return item;
}

void Item::setOtbId(uint16_t id)
{
    if (!g_things.isValidOtbId(id))
        id = 0;

    const auto& itemType = g_things.getItemType(id);
    m_serverId = id;

    id = itemType->getClientId();
    if (!g_things.isValidDatId(id, ThingCategoryItem))
        id = 0;

    m_clientId = id;
}

void Item::unserializeItem(const BinaryTreePtr& in)
{
    try {
        while (in->canRead()) {
            ItemAttr attrib = static_cast<ItemAttr>(in->getU8());
            if (attrib == 0)
                break;

            switch (attrib) {
                case ATTR_COUNT:
                case ATTR_RUNE_CHARGES:
                    setCount(in->getU8());
                    break;
                case ATTR_CHARGES:
                    setCount(in->getU16());
                    break;
                case ATTR_HOUSEDOORID:
                case ATTR_SCRIPTPROTECTED:
                case ATTR_DUALWIELD:
                case ATTR_DECAYING_STATE:
                    m_attribs.set(attrib, in->getU8());
                    break;
                case ATTR_ACTION_ID:
                case ATTR_UNIQUE_ID:
                case ATTR_DEPOT_ID:
                    m_attribs.set(attrib, in->getU16());
                    break;
                case ATTR_CONTAINER_ITEMS:
                case ATTR_ATTACK:
                case ATTR_EXTRAATTACK:
                case ATTR_DEFENSE:
                case ATTR_EXTRADEFENSE:
                case ATTR_ARMOR:
                case ATTR_ATTACKSPEED:
                case ATTR_HITCHANCE:
                case ATTR_DURATION:
                case ATTR_WRITTENDATE:
                case ATTR_SLEEPERGUID:
                case ATTR_SLEEPSTART:
                case ATTR_ATTRIBUTE_MAP:
                    m_attribs.set(attrib, in->getU32());
                    break;
                case ATTR_TELE_DEST:
                {
                    const uint16_t x = in->getU16();
                    const uint16_t y = in->getU16();
                    const uint8_t z = in->getU8();
                    m_attribs.set(attrib, Position{ x, y, z });
                    break;
                }
                case ATTR_NAME:
                case ATTR_TEXT:
                case ATTR_DESC:
                case ATTR_ARTICLE:
                case ATTR_WRITTENBY:
                    m_attribs.set(attrib, in->getString());
                    break;
                default:
                    throw Exception("invalid item attribute {}", attrib);
            }
        }
    } catch (const stdext::exception& e) {
        g_logger.error("Failed to unserialize OTBM item: {}", e.what());
    }
}

void Item::serializeItem(const OutputBinaryTreePtr& out)
{
    out->startNode(OTBM_ITEM);
    out->addU16(getServerId());

    out->addU8(ATTR_COUNT);
    out->addU8(getCount());

    out->addU8(ATTR_CHARGES);
    out->addU16(getCountOrSubType());

    const auto& dest = getTeleportDestination();
    if (dest.isValid()) {
        out->addU8(ATTR_TELE_DEST);
        out->addPos(dest.x, dest.y, dest.z);
    }

    if (isDepot()) {
        out->addU8(ATTR_DEPOT_ID);
        out->addU16(getDepotId());
    }

    if (isHouseDoor()) {
        out->addU8(ATTR_HOUSEDOORID);
        out->addU8(getDoorId());
    }

    const auto aid = getActionId();
    const auto uid = getUniqueId();
    if (aid) {
        out->addU8(ATTR_ACTION_ID);
        out->addU16(aid);
    }

    if (uid) {
        out->addU8(ATTR_UNIQUE_ID);
        out->addU16(uid);
    }

    const auto& text = getText();
    if (g_things.getItemType(m_serverId)->isWritable() && !text.empty()) {
        out->addU8(ATTR_TEXT);
        out->addString(text);
    }

    const auto& desc = getDescription();
    if (!desc.empty()) {
        out->addU8(ATTR_DESC);
        out->addString(desc);
    }

    out->endNode();
    for (const auto& i : m_containerItems)
        i->serializeItem(out);
}

#endif

/* vim: set ts=4 sw=4 et :*/