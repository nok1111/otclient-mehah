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

#include "missile.h"
#include "game.h"
#include "gameconfig.h"
#include "map.h"
#include "thingtypemanager.h"
#include "tile.h"
#include <client/client.h>
#include <framework/core/eventdispatcher.h>
#include <framework/graphics/shadermanager.h>

void Missile::draw(const Point& dest, const bool drawThings, const LightViewPtr& lightView)
{
    if (!canDraw() || isHided())
        return;

    // Position interpolation uses m_animationTimer, which must never be reset
    // by the frame animation logic, otherwise the missile stops moving.
    const float fraction = m_duration > 0 ? m_animationTimer.ticksElapsed() / m_duration : 1;

    // Sprite animation frames loop infinitely while the missile is sliding,
    // using a separate timer (m_frameTimer) so the position is unaffected.
    // The loop only wraps around after all phases have been shown.
    int animationPhase = 0;
    if (canAnimate() && getAnimationPhases() > 1) {
        if (g_game.getFeature(Otc::GameEnhancedAnimations)) {
            const auto* animator = getThingType()->getIdleAnimator();
            if (animator)
                animationPhase = animator->getPhaseAt(m_frameTimer);
        } else {
            const int ticks = g_gameConfig.getMissileTicksPerFrame();
            animationPhase = static_cast<int>(m_frameTimer.ticksElapsed() / ticks) % getAnimationPhases();
        }
    }

    if (g_drawPool.getCurrentType() == DrawPoolType::MAP) {
        g_drawPool.setDrawOrder(DrawOrder::FOURTH);
        if (drawThings && g_client.getMissileAlpha() < 1.f)
            g_drawPool.setOpacity(g_client.getMissileAlpha(), true);
    }

    if (hasShader())
        g_drawPool.setShaderProgram(g_shaders.getShaderById(m_shaderId), true/*, shaderAction*/);

    getThingType()->draw(dest + m_delta * fraction * g_drawPool.getScaleFactor(), 0, m_numPatternX, m_numPatternY, 0, animationPhase, Color::white, drawThings, lightView);
    g_drawPool.resetDrawOrder();
}

void Missile::setPath(const Position& fromPosition, const Position& toPosition)
{
    m_position = fromPosition;
    m_delta = Point(toPosition.x - fromPosition.x, toPosition.y - fromPosition.y);

    const float deltaLength = m_delta.length();
    if (deltaLength == 0) {
        g_dispatcher.addEvent([self = asMissile()] {
            g_map.removeThing(self);
        });
        return;
    }

    setDirection(fromPosition.getDirectionFromPosition(toPosition));

    m_duration = (g_gameConfig.getMissileTicksPerFrame() * 2) * std::sqrt(deltaLength);
    m_delta *= g_gameConfig.getSpriteSize();
    m_animationTimer.restart();
    m_frameTimer.restart();
    m_distance = fromPosition.distance(toPosition);

    // schedule removal
    g_dispatcher.scheduleEvent([self = asMissile()] { g_map.removeThing(self); }, m_duration);
}

void Missile::setDirection(const Otc::Direction dir) {
    m_direction = dir;

    if (m_direction == Otc::NorthWest) {
        m_numPatternX = 0;
        m_numPatternY = 0;
    } else if (m_direction == Otc::North) {
        m_numPatternX = 1;
        m_numPatternY = 0;
    } else if (m_direction == Otc::NorthEast) {
        m_numPatternX = 2;
        m_numPatternY = 0;
    } else if (m_direction == Otc::East) {
        m_numPatternX = 2;
        m_numPatternY = 1;
    } else if (m_direction == Otc::SouthEast) {
        m_numPatternX = 2;
        m_numPatternY = 2;
    } else if (m_direction == Otc::South) {
        m_numPatternX = 1;
        m_numPatternY = 2;
    } else if (m_direction == Otc::SouthWest) {
        m_numPatternX = 0;
        m_numPatternY = 2;
    } else if (m_direction == Otc::West) {
        m_numPatternX = 0;
        m_numPatternY = 1;
    } else {
        m_numPatternX = 1;
        m_numPatternY = 1;
    }
}

void Missile::setId(uint32_t id)
{
    if (!g_things.isValidDatId(id, ThingCategoryMissile))
        id = 0;

    m_clientId = id;
}

ThingType* Missile::getThingType() const {
    return g_things.getRawThingType(m_clientId, ThingCategoryMissile);
}