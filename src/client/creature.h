/*
 * Copyright (c) 2010-2022 OTClient <https://github.com/edubart/otclient>
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

#pragma once

#include <framework/core/declarations.h>
#include <framework/core/timer.h>
#include <framework/graphics/cachedtext.h>
#include "mapview.h"
#include "outfit.h"
#include "thing.h"

struct PreyMonster
{
public:
    std::string name;
    Outfit outfit;
};

// @bindclass
class Creature : public Thing
{
public:
    static double speedA;
    static double speedB;
    static double speedC;

    Creature();
    ~Creature();

    static bool hasSpeedFormula();

    void onCreate();

    void onAppear() override;
    void onDisappear() override;

    void draw(const Point& dest, bool drawThings = true, const LightViewPtr& lightView = nullptr) override;
    void draw(const Rect& destRect, uint8_t size, bool center = false);
    void drawLight(const Point& dest, const LightViewPtr& lightView) override;

    void internalDraw(Point dest, const Color& color = Color::white);
    void drawInformation(const MapPosInfo& mapRect, const Point& dest, int drawFlags);

    void setId(uint32_t id) override { m_id = id; }
    void setMasterId(uint32_t id) { m_masterId = id; }
    void setName(const std::string_view name);
    void setHealthPercent(uint8_t healthPercent);
    void setDirection(Otc::Direction direction);
    void setOutfit(const Outfit& outfit);
    void setLight(const Light& light) { m_light = light; }
    void setSpeed(uint16_t speed);
    void setBaseSpeed(uint16_t baseSpeed);
    void setSkull(uint8_t skull);
    void setShield(uint8_t shield);
    void setEmblem(uint8_t emblem);
    void setType(uint8_t type);
    void setIcon(uint8_t icon);
    void setSkullTexture(const std::string& filename);
    void setShieldTexture(const std::string& filename, bool blink);
    void setEmblemTexture(const std::string& filename);
    void setTypeTexture(const std::string& filename);
    void setIconTexture(const std::string& filename);
    void setPassable(bool passable) { m_passable = passable; }
    void setMountShader(const std::string_view name);
    void setStaticWalking(uint16_t v);

    void onStartAttachEffect(const AttachedEffectPtr& effect) override;
    void onDispatcherAttachEffect(const AttachedEffectPtr& effect) override;
    void onStartDetachEffect(const AttachedEffectPtr& effect) override;

    void addTimedSquare(uint8_t color);
    void removeTimedSquare() { m_showTimedSquare = false; }
    void showStaticSquare(const Color& color) { m_showStaticSquare = true; m_staticSquareColor = color; }
    void hideStaticSquare() { m_showStaticSquare = false; }

    // walk related
    void turn(Otc::Direction direction);
    void jump(int height, int duration);
    void allowAppearWalk() { m_allowAppearWalk = true; }
    virtual void walk(const Position& oldPos, const Position& newPos);
    virtual void stopWalk();

    bool isDrawingOutfitColor() const { return m_drawOutfitColor; }
    void setDrawOutfitColor(const bool draw) { m_drawOutfitColor = draw; }

    int getDisplacementX() const override;
    int getDisplacementY() const override;
    int getExactSize(int layer = 0, int xPattern = 0, int yPattern = 0, int zPattern = 0, int animationPhase = 0) override;

    float getStepProgress() { return m_walkTimer.ticksElapsed() / m_stepCache.duration; }
    float getStepTicksLeft() { return static_cast<float>(m_stepCache.getDuration(m_lastStepDirection)) - m_walkTimer.ticksElapsed(); }

    uint8_t getSkull() { return m_skull; }
    uint8_t getShield() { return m_shield; }
    uint8_t getEmblem() { return m_emblem; }
    uint8_t getType() { return m_type; }
    uint8_t getIcon() { return m_icon; }
    uint8_t getHealthPercent() { return m_healthPercent; }

    uint16_t getSpeed() { return m_speed; }
    uint16_t getBaseSpeed() { return m_baseSpeed; }
    uint16_t getStepDuration(bool ignoreDiagonal = false, Otc::Direction dir = Otc::InvalidDirection);

    uint32_t getId() override { return m_id; }
    uint32_t getMasterId() { return m_masterId; }
    std::string getName() { return m_name.getText(); }

    Point getDrawOffset() { return Point(-1, -1) * getDrawElevation() + m_walkOffset; }
    int getDrawElevation();

    Otc::Direction getDirection() { return m_direction; }
    Outfit getOutfit() { return m_outfit; }
    const Light& getLight() const override;
    bool hasLight() const override { return Thing::hasLight() || getLight().intensity > 0; }
    bool hasMountShader() const { return m_mountShaderId > 0; }

    Point getDisplacement() const override;
    Point getWalkOffset() { return m_walkOffset; }
    PointF getJumpOffset() { return m_jumpOffset; }
    Position getLastStepFromPosition() const { return m_lastStepFromPosition; }
    Position getLastStepToPosition() const { return m_lastStepToPosition; }
    bool isTimedSquareVisible() { return m_showTimedSquare; }
    Color getTimedSquareColor() { return m_timedSquareColor; }
    bool isStaticSquareVisible() { return m_showStaticSquare; }
    Color getStaticSquareColor() { return m_staticSquareColor; }

    ticks_t getWalkTicksElapsed() { return m_walkTimer.ticksElapsed(); }

    bool isPassable() const { return m_passable; }
    bool isWalking() { return m_walking; }
    bool isRemoved() { return m_removed; }
    bool isInvisible() { return m_outfit.isEffect() && m_outfit.getAuxId() == 13; }
    bool isDead() { return m_healthPercent <= 0; }
    bool isFullHealth() { return m_healthPercent == 100; }
    bool canBeSeen() { return !isInvisible() || isPlayer(); }
    bool isCreature() override { return true; }
    bool isCovered() { return m_isCovered; }

    bool isSummon() override;
#ifdef PROGRESSBAR
    uint8_t getProgressbarPercent() { return m_progressbarPercent; }
    void setProgressbar(uint32_t duration, bool ltr);
    void updateProgressbar(uint32_t duration, bool ltr);
#endif

    void setCovered(bool covered);

    bool isDisabledWalkAnimation() { return m_disableWalkAnimation > 0; }
    void setDisableWalkAnimation(bool v) {
        if (v) ++m_disableWalkAnimation; else {
            if (m_disableWalkAnimation <= 1) m_disableWalkAnimation = 0;
            else --m_disableWalkAnimation;
        }
    }

    void setTyping(bool typing);
    void sendTyping();
    bool getTyping() { return m_typing; }
    void setTypingIconTexture(const std::string& filename);
    void setBounce(uint8_t minHeight, uint8_t height, uint16_t speed) { m_bounce = { minHeight, height , speed }; }

    void setWidgetInformation(const UIWidgetPtr& info);
    UIWidgetPtr getWidgetInformation() { return m_widgetInformation; }

#ifndef BOT_PROTECTION
    void setText(const std::string& text, const Color& color);
    std::string getText();
    void clearText() { setText("", Color::white); }
    bool canShoot(int distance);
#endif

protected:
    virtual void updateWalkOffset(uint8_t totalPixelsWalked);
    virtual void updateWalk(bool isPreWalking = false);
    virtual void terminateWalk();

    ThingType* getThingType() const override;
    ThingType* getMountThingType() const;

    void onDeath();
    void onPositionChange(const Position& newPos, const Position& oldPos) override;

    bool m_walking{ false };
    Point m_walkOffset;
    Otc::Direction m_direction{ Otc::South };

    Timer m_walkTimer;

private:
    void nextWalkUpdate();
    void updateJump();
    void updateShield();
    void updateWalkingTile();
    void updateWalkAnimation();
    void resetWalkAnimationPhase(bool toSchedule = false);

    uint16_t getCurrentAnimationPhase(bool mount = false);

    struct CachedStep
    {
        uint16_t speed{ 0 };
        uint16_t groundSpeed{ 0 };

        uint16_t duration{ 0 };
        uint16_t walkDuration{ 0 };
        uint16_t diagonalDuration{ 0 };

        uint16_t getDuration(Otc::Direction dir) const { return Position::isDiagonal(dir) ? diagonalDuration : duration; }
    };

    UIWidgetPtr m_widgetInformation;

    TilePtr m_walkingTile;

    TexturePtr m_skullTexture;
    TexturePtr m_shieldTexture;
    TexturePtr m_emblemTexture;
    TexturePtr m_typeTexture;
    TexturePtr m_iconTexture;
    TexturePtr m_typingIconTexture;

    ScheduledEventPtr m_walkUpdateEvent;
    ScheduledEventPtr m_walkFinishAnimEvent;
    ScheduledEventPtr m_outfitColorUpdateEvent;

    EventPtr m_disappearEvent;

    CachedText m_name;
    CachedStep m_stepCache;

    Position m_lastStepFromPosition;
    Position m_lastStepToPosition;
    Position m_oldPosition;

    Timer m_footTimer;
    Timer m_outfitColorTimer;

    Outfit m_outfit;
    Light m_light;

    Color m_timedSquareColor{ Color::white };
    Color m_staticSquareColor{ Color::white };
    Color m_informationColor{ Color::white };

    struct
    {
        uint8_t minHeight{ 0 };
        uint8_t height{ 0 };
        uint16_t speed{ 0 };
    } m_bounce;

    // jump related
    Timer m_jumpTimer;
    PointF m_jumpOffset;
    float m_jumpHeight{ 0 };
    float m_jumpDuration{ 0 };

    uint32_t m_id{ 0 };
    uint32_t m_masterId{ 0 };

    uint16_t m_calculatedStepSpeed{ 0 };
    uint16_t m_speed{ 0 };
    uint16_t m_baseSpeed{ 0 };
    uint16_t m_walkingAnimationSpeed{ 0 };

    uint8_t m_type;
    uint8_t m_healthPercent{ 101 };
#ifdef PROGRESSBAR
    uint8_t m_progressbarPercent;
    ScheduledEventPtr m_progressbarUpdateEvent;
    Timer m_progressbarTimer;
#endif
    uint8_t m_skull{ Otc::SkullNone };
    uint8_t m_icon{ Otc::NpcIconNone };
    uint8_t m_shield{ Otc::ShieldNone };
    uint8_t m_emblem{ Otc::EmblemNone };

    // walk related
    uint8_t m_walkAnimationPhase{ 0 };
    uint8_t m_walkedPixels{ 0 };

    uint8_t m_exactSize{ 0 };

    uint8_t m_disableWalkAnimation{ 0 };

    // Mount Shader
    uint8_t m_mountShaderId{ 0 };

    Otc::Direction m_walkTurnDirection{ Otc::InvalidDirection };
    Otc::Direction m_lastStepDirection{ Otc::InvalidDirection };

    bool m_shieldBlink{ false };
    bool m_passable{ false };
    bool m_allowAppearWalk{ false };
    bool m_showTimedSquare{ false };
    bool m_showStaticSquare{ false };

    bool m_removed{ true };
    bool m_drawOutfitColor{ true };
    bool m_showShieldTexture{ true };
    bool m_typing{ false };
    bool m_isCovered{ false };

#ifndef BOT_PROTECTION
    StaticTextPtr m_text;
#endif
};

// @bindclass
class Npc : public Creature
{
public:
    bool isNpc() override { return true; }
};

// @bindclass
class Monster : public Creature
{
public:
    bool isMonster() override { return true; }
};
