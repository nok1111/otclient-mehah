--[[
    register(id, name, thingId, thingType, config)
    config = {
        speed, disableWalkAnimation, shader, drawOnUI, opacity
        duration, loop, transform, hideOwner, size{width, height}
        offset{x, y, onTop}, dirOffset[dir]{x, y, onTop},
        light { color, intensity}, drawOrder(only for tiles),
        bounce{minHeight, height, speed},
        pulse{minHeight, height, speed},
        fade{start, end, speed},
        lineMode, lineColor, lineWidth,
        distanceMode          -- when true, draws the effect moving from owner to each target
                                -- sent via creature:attachDistanceEffectWithTargets(effectId, {targets})

        onAttach, onDetach
    }
]]
--

local function safeAddTileEffect(owner, effectId)
    if not owner then return end
    local tile = owner:getTile()
    if not tile then return end
    local e = Effect.create()
    e:setId(effectId)
    tile:addThing(e)
end

AttachedEffectManager.register(1, 'Spoke Lighting', 12, ThingCategoryEffect, {
    speed = 0.5,
    onAttach = function(effect, owner)
        print('onAttach: ', effect:getId(), owner:getName())
    end,
    onDetach = function(effect, oldOwner)
        print('onDetach: ', effect:getId(), oldOwner:getName())
    end
})

AttachedEffectManager.register(2, 'Bat Wings', 2198, ThingCategoryCreature, {
    speed = 5,
    duration = 2000,
    disableWalkAnimation = true,
    shader = 'Outfit - Rainbow',
    dirOffset = {
        [North] = { 0, -10, true },
        [East] = { 5, -5 },
        [South] = { -5, 0 },
        [West] = { -10, -5, true }
    },
    onAttach = function(effect, owner)
        owner:setBounce(0, 10, 1000)
        effect:setBounce(0, 10, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setBounce(0, 0)
    end
})

AttachedEffectManager.register(3, 'Angel Light', 605, ThingCategoryEffect, {
    opacity = 0.8,
    drawOnUI = false
})

AttachedEffectManager.register(4, 'Four Angel Light', 0, 0, {
    onAttach = function(effect, owner)
        local angelLight = g_attachedEffects.getById(3)
        local angelLight1 = angelLight:clone()
        local angelLight2 = angelLight:clone()
        local angelLight3 = angelLight:clone()
        local angelLight4 = angelLight:clone()

        angelLight1:setOffset(-50, 50, true)
        angelLight2:setOffset(50, 50, true)
        angelLight3:setOffset(50, -50, true)
        angelLight4:setOffset(-50, -50, true)

        effect:attachEffect(angelLight1)
        effect:attachEffect(angelLight2)
        effect:attachEffect(angelLight3)
        effect:attachEffect(angelLight4)
    end
})

AttachedEffectManager.register(5, 'Transform', 40, ThingCategoryCreature, {
    transform = true,
    duration = 5000,
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(6, 'Lake Monster', 34, ThingCategoryEffect, {
    speed = 5,
    transform = true,
    hideOwner = true,
    duration = 1500,
    size = { 128, 128 },
    -- loop = 1,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 54)
    end
})

AttachedEffectManager.register(7, 'Pentagram Aura', '/images/game/effects/pentagram', ThingExternalTexture, {
    size = { 128, 128 },
    offset = { 50, 45 }
})

AttachedEffectManager.register(8, 'Ki', '/images/game/effects/ki', ThingExternalTexture, {
    size = { 140, 110 },
    offset = { 60, 75, true },
    pulse = { 0, 50, 3000 },
    --fade = { 0, 100, 1000 },
})

AttachedEffectManager.register(9, 'Thunder', '/images/game/effects/thunder', ThingExternalTexture, {
    loop = 1,
    offset = { 215, 230 }
})


AttachedEffectManager.register(10, 'Dynamic Effect', 0, 0, {
    duration = 500,
    speed = 1,
    onAttach = function(effect, owner)
        local spriteSize = g_gameConfig.getSpriteSize()
        local length = 3

        local missile = AttachedEffect.create(38, ThingCategoryMissile)
        missile:setDuration(effect:getDuration() * 0.5)
        missile:setDirection(5)
        missile:setOffset(spriteSize * length, 0)
        missile:setBounce(0, 15, 1000)
        missile:move(Position.translated(owner:getPosition(), -length, 0), owner:getPosition())
        effect:attachEffect(missile)

        missile = AttachedEffect.create(38, ThingCategoryMissile)
        missile:setDuration(effect:getDuration() * 0.5)
        missile:setDirection(3)
        missile:setOffset(-(spriteSize * length), 0)
        missile:setBounce(0, 15, 1000)
        missile:move(Position.translated(owner:getPosition(), length, 0), owner:getPosition())

        effect:attachEffect(missile)
        
        
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(11, 'Bat', 307, ThingCategoryCreature, {
    speed = 0.5,
    offset = { 0, 0 },
    bounce = { 20, 20, 2000 }
})

AttachedEffectManager.register(12, 'earthquake jump', 256, ThingCategoryEffect, {

    duration = 1000,
    disableWalkAnimation = true,
    offset = { 0, 0, false },

    onAttach = function(effect, owner)
        owner:setBounce(12, 32, 2000)
       -- effect:setBounce(40, 45, 15000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setBounce(0, 0)
    end
})

AttachedEffectManager.register(13, 'travel form', 217, ThingCategoryCreature, {
    hideOwner = true,
    duration = 15000,
    speed = 1,
    offset = { 0, 0 },
    bounce = { 10, 20, 11000 },
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 647)
        
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 647)
    end
})

AttachedEffectManager.register(14, 'animated1', '/images/game/effects/animated', ThingExternalTexture, {
    size = { 128, 128 },
    offset = { 50, 45 }
})

AttachedEffectManager.register(15, 'shadow form', 1565, ThingCategoryCreature, {
    hideOwner = true,
    duration = 4000,
    speed = 1,
    bounce = { 5, 7, 11000 },
    disableWalkAnimation = true,
    shader = 'Outfit - Rainbow',
})

AttachedEffectManager.register(16, 'blood blades', 353, ThingCategoryEffect, {
    hideOwner = false,
    duration = 8000,
    shader = 'Red Glow',
    speed = 1,
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 353)
        
        
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 353)
    end
})

AttachedEffectManager.register(17, 'overcharged', 495, ThingCategoryEffect, {
    opacity = 1,
    duration = 8000,
    speed = 1.4,
    offset = { 0, 0, true},
})

AttachedEffectManager.register(18, 'mana flow', 510, ThingCategoryEffect, {
    opacity = 1,
    duration = 8000,
    speed = 1.4,
    offset = { -29, -22, true}
    
})

AttachedEffectManager.register(19, 'mana flow (mana distortion)', 510, ThingCategoryEffect, {
    opacity = 1,
    duration = 850,
    speed = 1.4,
    offset = { -29, -22, true}
    
})

AttachedEffectManager.register(20, 'taunted', 200, ThingCategoryEffect, {
    opacity = 1,
    duration = 600,
    speed = 3.4,
    offset = { -15, -15, true},
    bounce = { 15, 15, 1000 },
    
})

AttachedEffectManager.register(21, 'shield slam', 609, ThingCategoryEffect, {
    opacity = 1,
    duration = 2200,
    speed = 1,
    offset = { -15, -28, true},
    
    onAttach = function(effect, owner)
        local angelLight = g_attachedEffects.getById(22)
        local angelLight1 = angelLight:clone()
        effect:attachEffect(angelLight1)

    end
    
})

AttachedEffectManager.register(22, 'ground break', 660, ThingCategoryEffect, {
    opacity = 1,
    duration = 2500,
    speed = 0.7,
    offset = { -104, -92, false},
    
})

AttachedEffectManager.register(23, 'stuned', 32, ThingCategoryEffect, {
    opacity = 1,
    duration = 1200,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(24, 'shild wall', 583, ThingCategoryEffect, {
    opacity = 1,
    duration = 15000,
    speed = 1.5,
    offset = { -18, -23, false},
    
})

AttachedEffectManager.register(25, 'might buff', '/images/game/effects/amight', ThingExternalTexture, {
    opacity = 0.7,
    duration = 600,
    speed = 0.7,
    size = { 35, 35 },
    offset = { 0, 0, true },
    bounce = { 15, 70, 2800 },

})

AttachedEffectManager.register(26, 'might Aura', '/images/game/effects/animated2', ThingExternalTexture, {
    size = { 64, 64 },
    offset = { 13, 14 }
})

AttachedEffectManager.register(27, 'vortex (water wave)', 242, ThingCategoryEffect, {
    duration = 3000,
    size = { 128, 128 },
    offset = { -22, -32 }
})

AttachedEffectManager.register(28, 'stun jump', 32, ThingCategoryEffect, {

    duration = 3000,
    disableWalkAnimation = true,

    onAttach = function(effect, owner)
        owner:setBounce(10, 15, 500)
        effect:setBounce(20, 23, 2000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setBounce(0, 0)
    end
})

AttachedEffectManager.register(29, 'holy form', 2288, ThingCategoryCreature, {
    hideOwner = true,
    duration = 15000,
    speed = 1,
    bounce = { 5, 7, 11000 },
    disableWalkAnimation = true,
    
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 662)
        
        
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 662)
    end
})

AttachedEffectManager.register(30, 'holy 4 Light', 0, 0, {

    duration = 15000,
    onAttach = function(effect, owner)
        local angelLight = g_attachedEffects.getById(3)
        local angelLight1 = angelLight:clone()
        local angelLight2 = angelLight:clone()
        local angelLight3 = angelLight:clone()
        local angelLight4 = angelLight:clone()

        angelLight1:setOffset(-50, 50, true)
        angelLight2:setOffset(50, 50, true)
        angelLight3:setOffset(50, -50, true)
        angelLight4:setOffset(-50, -50, true)

        effect:attachEffect(angelLight1)
        effect:attachEffect(angelLight2)
        effect:attachEffect(angelLight3)
        effect:attachEffect(angelLight4)
    end
})

AttachedEffectManager.register(31, 'quest marker', 669, ThingCategoryEffect, {
    speed = 0.7,
    size = { 5, 5 },
    offset = { 35, 35, true },
    bounce = { 0, 5, 10000 },
    --shader = 'Rainbow',
})

AttachedEffectManager.register(32, 'might Aura', '/images/game/effects/red_spin', ThingExternalTexture, {
    size = { 68, 68 },
    offset = { 13, 14, false }
})

AttachedEffectManager.register(33, 'disco ball', '/images/game/effects/disco_ball', ThingExternalTexture, {
    speed = 0.7,
    size = { 40, 40 },
    offset = { 60, 60, true },
    --shader = 'Rainbow',
})

AttachedEffectManager.register(34, 'black arrows', '/images/game/effects/arrows_black', ThingExternalTexture, {
    size = { 90, 90 },
    offset = { 30, 30, false }
})

AttachedEffectManager.register(35, 'green circle', '/images/game/effects/green', ThingExternalTexture, {
    size = { 90, 90 },
    offset = { 30, 30, false }
})

AttachedEffectManager.register(36, 'purple sharingan', '/images/game/effects/purple_sharingan', ThingExternalTexture, {
    size = { 90, 90 },
    offset = { 30, 30, false }
})

AttachedEffectManager.register(37, 'purple square', '/images/game/effects/purplesquare', ThingExternalTexture, {
    size = { 55, 55 },
    offset = { 15, 15, false }
})

AttachedEffectManager.register(38, 'red circle', '/images/game/effects/red_circle', ThingExternalTexture, {
    size = { 90, 90 },
    offset = { 30, 30, false }
})

AttachedEffectManager.register(39, 'monsters ground break', 660, ThingCategoryEffect, {
    loop = 1,
    speed = 0.7,
    offset = { -104, -92, false},
    
})

AttachedEffectManager.register(40, 'inlove', 36, ThingCategoryEffect, {
    speed = 0.7,
    duration = 9000,
    size = { 40, 40 },
    offset = { 32, 32, true },
    bounce = { 0, 5, 10000 },
    --shader = 'Rainbow',
})

AttachedEffectManager.register(41, 'fire 1', 758, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(42, 'ice 1', 759, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(43, 'holy 1', 760, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(44, 'fire 2', 755, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(45, 'ice 2', 756, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(46, 'life 2', 757, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(47, 'fire_ice 2', 761, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(48, 'fire_life 2', 762, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(49, 'ice_life 2', 763, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(50, 'fire 1', 760, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(51, 'fire 1', 760, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(52, 'fire 1', 760, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(53, 'fire 1', 760, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(54, 'fire 1', 760, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(55, 'fire 1', 760, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { -21, -21, false},
    
})


AttachedEffectManager.register(56, 'fire 1', 764, ThingCategoryEffect, {
    size = { 40, 40 },
    speed = 1.2,
    offset = { 15, -40, false},
    duration = 3000,
    
})

AttachedEffectManager.register(60, 'cyclone stun jump', 32, ThingCategoryEffect, {

    duration = 750,
    disableWalkAnimation = true,

    onAttach = function(effect, owner)
        owner:setBounce(0, 120, 2200)
        effect:setBounce(0, 120, 2200)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setBounce(0, 0)
    end
})

AttachedEffectManager.register(61, 'cyclone bounce', 0, 0, {
    duration = 15000,
    speed = 1,
    offset = { 0, 0 },
    bounce = { 10, 20, 11000 },
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 647)
        
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 647)
    end
})

AttachedEffectManager.register(62, 'stuned cyclone', 32, ThingCategoryEffect, {
    opacity = 2,
    duration = 2000,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(63, 'blood wall', 266, ThingCategoryEffect, {
    loop = 1,
    offset = { 0, 0, true }
})

AttachedEffectManager.register(64, 'fear', 170, ThingCategoryEffect, {
    loop = 1,
    offset = { 0, 0, true }
})

AttachedEffectManager.register(65, 'magic echo', 598, ThingCategoryEffect, {
    loop = 1,
    opacity = 2,
    speed = 1,
    offset = { -70, -60, false},
    
})

AttachedEffectManager.register(66, 'stuned judment', 32, ThingCategoryEffect, {
    opacity = 2,
    duration = 2000,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(67, 'floor judment', 644, ThingCategoryEffect, {
    loop = 1,
    opacity = 1,
    speed = 0.83,
    offset = { -32, -32, false},
    
})

AttachedEffectManager.register(68, 'shockwave ground', '/images/game/effects/shockwave ground', ThingExternalTexture, {
    loop = 1,
    speed = 1.0,
    offset = { 80, 80, false},
    size = { 180, 180 },
    
})

AttachedEffectManager.register(69, 'shockwave aura', '/images/game/effects/shockwave aura', ThingExternalTexture, {
    loop = 1,
    opacity = 1,
    speed = 0.83,
    offset = { 80, 80, false},
    size = { 180, 180 },
    
})

AttachedEffectManager.register(70, 'blackout', 32, ThingCategoryEffect, {
    opacity = 2,
    duration = 4000,
    speed = 1,
    offset = { 22, 22, true},

    onAttach = function(effect, owner)
        owner:setShader('Blackout')
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setShader('Outfit - Default')
    end
    
})

AttachedEffectManager.register(71, 'deathbringer', 318, ThingCategoryEffect, {
    loop = 1,
    duration = 2000,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(72, 'Protection', 268, ThingCategoryEffect, {
    duration = 3500,
    speed = 1,
    offset = { 0, 0, true},
    
})

AttachedEffectManager.register(73, 'Dragon Aura', 540, ThingCategoryEffect, {
    duration = 18000,
    speed = 1,
    offset = { 0, 0, true},
    
})
AttachedEffectManager.register(74, 'Dragon aura spin', 755, ThingCategoryEffect, {
    duration = 18000,
    size = { 40, 40 },
    speed = 1.8,
    offset = { -21, -21, false},
    
})
AttachedEffectManager.register(75, 'Draconic rage', 663, ThingCategoryEffect, {
    duration = 15000,
    size = { 40, 40 },
    speed = 1.8,
    offset = { -21, -21, true},
    
})

AttachedEffectManager.register(76, 'dragon Wings', 2135, ThingCategoryCreature, {
    speed = 1,
    duration = 7000,
    disableWalkAnimation = true,
    shader = 'Red Glow',
    dirOffset = {
        [North] = { -13, -23, true },
        [East] = { 12, -19 },
        [South] = { -10, 14 },
        [West] = { -16, -16, true }
    },
})

AttachedEffectManager.register(77, 'dragon form', 2274, ThingCategoryCreature, {
    transform = true,
    duration = 5000,
    shader = 'Monster Might',
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 497)
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 497)
    end
})

AttachedEffectManager.register(78, 'chains 1', 825, ThingCategoryEffect, {
    loop = 1,
    speed = 1.8,
    offset = { -128, -128, true},
    
})

AttachedEffectManager.register(79, 'chains 2', 826, ThingCategoryEffect, {
    loop = 1,
    speed = 1.8,
    offset = { -128, -128, true},
    
})  

AttachedEffectManager.register(80, 'chains 3', 827, ThingCategoryEffect, {
    loop = 1,
    speed = 1.8,
    offset = { -128, -128, true},
    
})
 
AttachedEffectManager.register(81, 'chains 4', 828, ThingCategoryEffect, {
    loop = 1,
    speed = 1.8,
    offset = { -128, -128, true},
    
})

AttachedEffectManager.register(82, 'fire', 590, ThingCategoryEffect, {
    duration = 1000,
    speed = 1,
    offset = { 0, 0, true},
    
})

AttachedEffectManager.register(83, 'dragon soul', 782, ThingCategoryEffect, {
    loop = 1,
    duration = 1000,
    speed = 1,
    shader = 'Monster Might',
    offset = { 0, 0, true},
    
})

AttachedEffectManager.register(84, 'dragon soul circle', '/images/game/effects/red_spin', ThingExternalTexture, {
    loop = 1,
    shader = 'Monster Might',
    size = { 90, 90 },
    offset = { 30, 30, false }
})

AttachedEffectManager.register(85, 'haunt', 838, ThingCategoryEffect, {
    duration = 10000,
    speed = 1,
    offset = { -10, -10, false }
})

AttachedEffectManager.register(86, 'star fall', 661, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -32, -32, false }
})

AttachedEffectManager.register(87, 'dark aura', 795, ThingCategoryEffect, {
    speed = 1,
    offset = { 0, 0, true },
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 841)
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 841)
    end
})

AttachedEffectManager.register(88, 'holy fire', 835, ThingCategoryEffect, {
    loop = 1,
    speed = 2,
    offset = { 0, 0, true},
    
})

AttachedEffectManager.register(89, 'moon light', 503, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    shader = 'Galaxy',
    offset = { -10, -5, true},
    
})

AttachedEffectManager.register(90, 'cosmic effect', 566, ThingCategoryEffect, {
    loop = 1,
    opacity = 0.8,
    drawOnUI = false
})

AttachedEffectManager.register(91, 'cosmic force', 0, 0, {
    duration = 650,
    onAttach = function(effect, owner)
        local cosmicEffect = g_attachedEffects.getById(90)
        local cosmicEffect1 = cosmicEffect:clone()
        local cosmicEffect2 = cosmicEffect:clone()
        local cosmicEffect3 = cosmicEffect:clone()
        local cosmicEffect4 = cosmicEffect:clone()

        cosmicEffect1:setOffset(-25, 25, true)
        cosmicEffect2:setOffset(25, 25, true)
        cosmicEffect3:setOffset(25, -25, true)
        cosmicEffect4:setOffset(-25, -25, true)

        effect:attachEffect(cosmicEffect1)
        effect:attachEffect(cosmicEffect2)
        effect:attachEffect(cosmicEffect3)
        effect:attachEffect(cosmicEffect4)
    end
})

AttachedEffectManager.register(92, 'fire fist', 2895, ThingCategoryCreature, {
    speed = 1.5,
    duration = 4000,
    disableWalkAnimation = false,
    --shader = 'Outfit - Rainbow',
    dirOffset = {
        [North] = { -35, 0, false }, 
        [East] = { -80, -38, true },
        [South] = { -39, -96, true },
        [West] = { 0, -50, false }
    }
})

AttachedEffectManager.register(93, 'life fist', 2896, ThingCategoryCreature, {
    speed = 1.5,
    duration = 4000,
    disableWalkAnimation = false,
    --shader = 'Outfit - Rainbow',
    dirOffset = {
        [North] = { -35, 0, false }, 
        [East] = { -80, -38, true },
        [South] = { -39, -96, true },
        [West] = { 0, -50, false }
    }
})

AttachedEffectManager.register(94, 'ice fist', 2897, ThingCategoryCreature, {
    speed = 1.5,
    duration = 4000,
    disableWalkAnimation = false,
    --shader = 'Outfit - Rainbow',
    dirOffset = {
        [North] = { -35, 0, false }, 
        [East] = { -80, -38, true },
        [South] = { -39, -96, true },
        [West] = { 0, -50, false }
    }
})

AttachedEffectManager.register(95, 'adaptive ice', 847, ThingCategoryEffect, {
    loop = 1,
    speed = 0.5,
    offset = { -33, -33, true},
    
})

AttachedEffectManager.register(96, 'adaptive life', 846, ThingCategoryEffect, {
    loop = 1,
    speed = 0.7,
    offset = { -33, -33, true},
    
})
    
AttachedEffectManager.register(97, 'turtle rush', 2198, ThingCategoryCreature, {
    transform = true,
    duration = 2000,
    -- loop = 1,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 7)
    end
})

AttachedEffectManager.register(98, 'zen sphere', 837, ThingCategoryEffect, {
    speed = 1,
    opacity = 0.7,
    duration = 8000,
    offset = { -10, -10, true },
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 54)
    end
})

AttachedEffectManager.register(100, 'mystic punch 1', 814, ThingCategoryEffect, {
    speed = 0.4,
    loop = 1,
    offset = { -10, -10, true },
})

AttachedEffectManager.register(101, 'mystic punch 2', 815, ThingCategoryEffect, {
    speed = 0.4,
    loop = 1,
    offset = { -10, -10, true },
})

AttachedEffectManager.register(102, 'mystic punch 3', 816, ThingCategoryEffect, {
    speed = 0.4,
    loop = 1,
    offset = { -10, -10, true },
})

AttachedEffectManager.register(103, 'mystic punch 4', 817, ThingCategoryEffect, {
    speed = 0.4,
    loop = 1,
    offset = { -10, -10, true },
})

AttachedEffectManager.register(104, 'mountain stance', 249, ThingCategoryEffect, {
    speed = 1,
    duration = 10000,
    offset = { 0, 0, false },
})

AttachedEffectManager.register(105, 'mountain stance', 249, ThingCategoryEffect, {
    speed = 0.8,
    duration = 10000,
    offset = { 11, 11, false },
})


AttachedEffectManager.register(106, 'mountain stance 2', 249, ThingCategoryEffect, {
    speed = 0.6,
    duration = 10000,
    offset = { 22, 22, true },
})

AttachedEffectManager.register(107, 'solar blessing', 836, ThingCategoryEffect, {
    speed = 2,
    loop = 1,
    offset = { 5, 10, true },
})

AttachedEffectManager.register(108, 'solar blessing ground', 614, ThingCategoryEffect, {
    speed = 1,
    duration = 8000,
    offset = { -15, -13, false },
})

AttachedEffectManager.register(109, 'rock punch', 845, ThingCategoryEffect, {
    speed = 0.65,
    loop = 1,
    offset = { -32, -32, true },
})

AttachedEffectManager.register(110, 'life punch', 846, ThingCategoryEffect, {
    speed = 0.45,
    loop = 1,
    offset = { -32, -32, true },
})

AttachedEffectManager.register(111, 'fire punch', 849, ThingCategoryEffect, {
    speed = 0.45,
    loop = 1,
    offset = { -32, -32, true },
})

AttachedEffectManager.register(112, 'ice punch', 847, ThingCategoryEffect, {
    speed = 0.45,
    loop = 1,
    offset = { -32, -32, true },
})

AttachedEffectManager.register(113, 'Mystic punch', 848, ThingCategoryEffect, {
    speed = 0.45,
    loop = 1,
    offset = { -32, -32, true },
})

AttachedEffectManager.register(114, 'Insect swarm', 503, ThingCategoryEffect, {
    speed = 1,
    duration = 9000,
    offset = { -15, -15, true },
})

AttachedEffectManager.register(115, 'carnivorous vile', 446, ThingCategoryEffect, {
    speed = 1.3,
    loop = 1,
    offset = { -32, -32, true },
})

AttachedEffectManager.register(116, 'piercing wave stun', 32, ThingCategoryEffect, {
    opacity = 1,
    duration = 3000,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(117, 'ice shatter', 807, ThingCategoryEffect, {
    opacity = 0.85,
    loop = 1,
    speed = 1.1,
    offset = { -19, -17, true},
})

AttachedEffectManager.register(118, 'ice shatter break', 328, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -19, -17, true},
})

AttachedEffectManager.register(119, 'frost cage', 545, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -32, -32, false},
})

AttachedEffectManager.register(120, 'frost armor', 493, ThingCategoryEffect, {
    opacity = 1,
    duration = 8000,
    speed = 1,
    offset = { -5, 0, true},
    --shader = 'frost armor',

    onAttach = function(effect, owner)
        owner:setShader('Outfit - ice')     
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setShader('Outfit - Default')
    end
})

AttachedEffectManager.register(121, 'frost armor initial', 53, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { 0, 0, true},
    shader = 'frost armor',
})

AttachedEffectManager.register(122, 'carnivorous vile empower', 446, ThingCategoryEffect, {
    speed = 1.3,
    loop = 1,
    offset = { -32, -32, true },
    shader = 'Red Glow',
})

AttachedEffectManager.register(123, 'frost armor aura', 616, ThingCategoryEffect, {
    opacity = 1,
    duration = 8000,
    speed = 1.3,
    offset = { -64, -64, false},
    shader = 'frost armor',
})

AttachedEffectManager.register(124, 'frost armor aura 2', '/images/game/effects/animated2', ThingExternalTexture, {
    size = { 150, 150 },
    opacity = 0.7,
    duration = 3000,
    offset = { 64, 64, false },
    shader = 'frost armor',
})

AttachedEffectManager.register(125, 'life bloom', 454, ThingCategoryEffect, {
    loop = 1,
    offset = { 5, -15, true },
})

AttachedEffectManager.register(126, 'focus healing', 459, ThingCategoryEffect, {
    loop = 1,
    offset = { -25, -25, true },
})

AttachedEffectManager.register(127, 'focus healing', 381, ThingCategoryEffect, {
    loop = 1,
    speed = 0.4,
    offset = { -5, -5, true },
})

AttachedEffectManager.register(128, 'magnetic orb', 550, ThingCategoryEffect, {
    hideOwner = true,
    speed = 1.5,
    offset = {-32, -32, true },
    --bounce = { 20, 20, 2000 },

    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 60)
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 60)
    end
})

AttachedEffectManager.register(129, 'fire within aura new', 893, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -64, -32, true },
})

AttachedEffectManager.register(130, 'whirlwind new', 1124, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -64, -85, true },
})

AttachedEffectManager.register(131, 'dragons call ground', 894, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -50, -25, false },
})

AttachedEffectManager.register(132, 'divine storm', 859, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -100, -111, false },
})

AttachedEffectManager.register(133, 'divine storm 2', 1115, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -64, -64, false },
    shader = 'Golden',
})

AttachedEffectManager.register(134, 'shadowstep1', 1070, ThingCategoryEffect, {
    loop = 1,
    speed = 1.5,
    offset = { -32, -32, true },
})

AttachedEffectManager.register(135, 'backstab', 1019, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -32, -32, true },
})

AttachedEffectManager.register(136, 'mutilate', 1082, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -82, -78, true },
    shader = 'Monster Might',
})

AttachedEffectManager.register(137, 'mutilate shadow', 1082, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -82, -78, true },
    shader = 'Blackout',
})

AttachedEffectManager.register(138, 'mutilate shadow', 1090, ThingCategoryEffect, {
    duration = 3100,
    hideOwner = true,
    speed = 0.75,
    offset = { -90, -60, true },
})

AttachedEffectManager.register(139, 'dark rupture', 987, ThingCategoryEffect, {
    loop = 1,
    speed = 1.5,
    offset = { -24, -22, true },
})
AttachedEffectManager.register(140, 'dark rupture red', 987, ThingCategoryEffect, {
    loop = 1,
    speed = 1.5,
    offset = { -24, -22, true },
    shader = 'Monster Might',
})

AttachedEffectManager.register(141, 'blood', 995, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -24, -22, true },
})

AttachedEffectManager.register(142, 'Falling star', 874, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -85, -30, true },
})

AttachedEffectManager.register(143, 'stuned falling star', 32, ThingCategoryEffect, {
    opacity = 1,
    duration = 3000,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(144, 'elusive blade', 871, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -90, -64, true},
    
})

AttachedEffectManager.register(145, 'elusive blade twice', 873, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -80, -48, true},
    
})

AttachedEffectManager.register(146, 'elusive dance', 881, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -60, -55, true},
    
})

AttachedEffectManager.register(147, 'short circuit', 1140, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 0.7,
    offset = { -60, -55, true},
    
})

AttachedEffectManager.register(148, 'parry', 548, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1.4,
    offset = { 0, 0, true},
    
})

AttachedEffectManager.register(149, 'parry 2', 695, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { 0, 0, true},
    
})

AttachedEffectManager.register(150, 'magnetic shield', 878, ThingCategoryEffect, {
    opacity = 1,
    duration = 5000,
    speed = 1,
    offset = { -22, -22, true},
    
})

AttachedEffectManager.register(151, 'elusive dance evolve', 865, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -60, -65, false},
    
})

AttachedEffectManager.register(152, 'shadow light', 1022, ThingCategoryEffect, {
    opacity = 0.8,
    drawOnUI = false,
    offset = { -50, -25, false},
})

AttachedEffectManager.register(153, 'shadow form 3', 1008, ThingCategoryEffect, {
    opacity = 1,
    duration = 4000,
    speed = 1,
    offset = { -15, -15, false},
    shader = 'Blackout',
    
})

AttachedEffectManager.register(154, 'shadow form 2', 2903, ThingCategoryCreature, {
    hideOwner = false,
    duration = 4000,
    speed = 1,
    bounce = { 5, 7, 11000 },
   -- disableWalkAnimation = true,
    dirOffset = {
        [North] = { -50, -50, true },
        [East] = { -50, -50, true },
        [South] = { -50, -50, true },
        [West] = { -50, -50, true }
    },
    
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 18)
    end
})

AttachedEffectManager.register(155, 'lucella transform', 1760, ThingCategoryCreature, {
    hideOwner = true,
    speed = 1,
    bounce = { 5, 7, 11000 },
   -- disableWalkAnimation = true,
    dirOffset = {
        [North] = { -50, -50, true },
        [East] = { -50, -50, true },
        [South] = { -50, -50, true },
        [West] = { -50, -50, true }
    },
    
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 18)
    end
})

AttachedEffectManager.register(156, 'elixir of ghosts', 48, ThingCategoryCreature, {
    hideOwner = true,
    speed = 1,
    duration = 2500,
    bounce = { 5, 8, 8000 },
   -- disableWalkAnimation = true,
    dirOffset = {
        [North] = { 0, 0, true },
        [East] = { 0, 0, true },
        [South] = { 0, 0, true },
        [West] = { 0, 0, true }
    },
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 66)
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 66)
    end
})


AttachedEffectManager.register(157, 'nightfiend jump', 1070, ThingCategoryEffect, {
    hideOwner = true,
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -25, -25, true},
})

AttachedEffectManager.register(158, 'saranor purple aura', 917, ThingCategoryEffect, {
    opacity = 0.7,
    duration = 6000,
    speed = 1,
    offset = { -50, -34, true},
})

AttachedEffectManager.register(159, 'tempest coin 1', 829, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -64, -64, true},
})
AttachedEffectManager.register(160, 'tempest coin 2', 830, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -64, -64, true},
})
AttachedEffectManager.register(161, 'tempest coin 3', 831, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -64, -64, true},
})
AttachedEffectManager.register(162, 'tempest coin 4', 832, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -64, -64, true},
})    
AttachedEffectManager.register(163, 'explosive shot', 950, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -34, -40, true},
})    

  
AttachedEffectManager.register(164, 'frost barrel ice', 842, ThingCategoryEffect, {
    opacity = 0.65,
    duration = 2000,
    speed = 1,
    offset = { -15, -15, true},
    
    onAttach = function(effect, owner)
        owner:setShader('frost armor')
    end,
    onDetach = function(effect, oldOwner)
        if oldOwner and oldOwner:getTile() then
            local e = Effect.create()
            e:setId(44)
            oldOwner:getTile():addThing(e)
            oldOwner:setShader('Outfit - Default')
        end
    end
})    

AttachedEffectManager.register(165, 'wind barrel', 780, ThingCategoryEffect, {
    opacity = 1,
    duration = 6000,
    speed = 1,
    offset = { 0, 0, true},
}) 

AttachedEffectManager.register(166, 'wind barrel attached', 1143, ThingCategoryEffect, {
    hideOwner = true,
    speed = 1,
    offset = { -96, -96, false},
}) 

AttachedEffectManager.register(167, 'explosive barrel', 1144, ThingCategoryEffect, {
    hideOwner = true,
    speed = 1,
    offset = { -96, -96, false},
}) 

AttachedEffectManager.register(168, 'destructive shot ground', 875, ThingCategoryEffect, {
    opacity = 1,
    duration = 2000,
    speed = 1,
    offset = { -32, -32, false},
    shader = 'Blackout',
}) 

AttachedEffectManager.register(169, 'destructive shot aura', 875, ThingCategoryEffect, {
    opacity = 1,
    duration = 2000,
    speed = 1,
    offset = { -32, -32, false},
    shader = 'Blackout',
}) 

AttachedEffectManager.register(170, 'destructive shot aim', 558, ThingCategoryEffect, {
    opacity = 0.8,
    loop = 1,
    speed = 0.9,
    offset = { -2, -2, true},
    shader = 'Blackout',
}) 

AttachedEffectManager.register(171, 'destructive shot explode', 1054, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -32, -64, true},
}) 

AttachedEffectManager.register(172, 'boots of timewalking', 598, ThingCategoryEffect, {
    duration = 4000,
    opacity = 1,
    speed = 1,
    offset = { -70, -60, false},
    
})

AttachedEffectManager.register(173, 'boots of levitation', 629, ThingCategoryEffect, {
    speed = 1,
    duration = 3000,
    disableWalkAnimation = true,
    offset = { 0, 0, false},
    onAttach = function(effect, owner)
        owner:setBounce(13, 15, 1400)
        effect:setBounce(1, 2, 10000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setBounce(0, 0)
    end
})

AttachedEffectManager.register(174, 'boots of of the void', 2955, ThingCategoryCreature, {
    duration = 2000,
    disableWalkAnimation = true,
    opacity = 1,
    speed = 1,
    dirOffset = {
        [North] = { 0, 0, true },
        [East] = { 0, 0, true},
        [South] = { 0, 0, true},
        [West] = { 0, 0, true}
    },
    
})

AttachedEffectManager.register(175, 'boots of void aura (NOT USED)', 1127, ThingCategoryEffect, {
    loop = 1,
    opacity = 1,
    speed = 1,
    offset = { -58, -64, false},
    
})

AttachedEffectManager.register(176, 'boots of void aura 2', 1020, ThingCategoryEffect, {
    loop = 1,
    opacity = 1,
    speed = 1,
    offset = { -58, -64, false},
    
})

AttachedEffectManager.register(177, 'boots of the dreamer 1', 1081, ThingCategoryEffect, {
    loop = 1,
    opacity = 1,
    speed = 1,
    offset = { -22, -15, true},
    
})

AttachedEffectManager.register(178, 'boots of the dreamer 2', 1077, ThingCategoryEffect, {
    loop = 1,
    opacity = 1,
    speed = 1,
    offset = { -54, -30, false}, 
    
})


AttachedEffectManager.register(179, '[Vampiric]', 2911, ThingCategoryCreature, {
    opacity = 1,
    speed = 1,
    offset = { -38, -38, true},

    onAttach = function(effect, owner)       
        owner:setScaleFactor(1.4, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 1000)
    end
    
})

AttachedEffectManager.register(180, '[Sacred]', 2906, ThingCategoryCreature, {
    opacity = 1,
    speed = 2.5,
    offset = { -38, -38, true},
    onAttach = function(effect, owner)       
        owner:setScaleFactor(1.4, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 1000)
    end
    
})

AttachedEffectManager.register(181, '[Arcane]', 2908, ThingCategoryCreature, {
    opacity = 1,
    speed = 2.5,
    offset = { -38, -38, true},
    onAttach = function(effect, owner)       
        owner:setScaleFactor(1.4, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 1000)
    end
    
})

AttachedEffectManager.register(182, '[Corrosive]', 2907, ThingCategoryCreature, {
    opacity = 1,
    speed = 2.5,
    offset = { -38, -38, true},
    onAttach = function(effect, owner)       
        owner:setScaleFactor(1.4, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 1000)
    end    
})

AttachedEffectManager.register(183, '[Frostbound]', 2905, ThingCategoryCreature, {
    opacity = 1,
    speed = 2.5,
    offset = { -38, -38, true},
    shader = "frost armor",
    onAttach = function(effect, owner)       
        owner:setScaleFactor(1.4, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 1000)
    end    
})

AttachedEffectManager.register(184, '[Plagued]', 2907, ThingCategoryCreature, {
    opacity = 1,
    speed = 2.5,
    offset = { -38, -38, true},
    onAttach = function(effect, owner)       
        owner:setScaleFactor(1.4, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 1000)
    end    
})

AttachedEffectManager.register(185, '[Burning]', 2902, ThingCategoryCreature, {
    opacity = 1,
    speed = 2.5,
    offset = { -38, -38, true},
    onAttach = function(effect, owner)       
        owner:setScaleFactor(1.4, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 1000)
    end    
})

AttachedEffectManager.register(186, '[Reaper]', 2904, ThingCategoryCreature, {
    opacity = 1,
    speed = 2.5,
    offset = { -38, -38, true},
    onAttach = function(effect, owner)       
        owner:setScaleFactor(1.4, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 1000)
    end    
})

AttachedEffectManager.register(187, '[Darkness]', 2903, ThingCategoryCreature, {
    opacity = 1,
    speed = 2.5,
    offset = { -38, -38, true},
    onAttach = function(effect, owner)       
        owner:setScaleFactor(1.4, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 1000)
    end    
})

AttachedEffectManager.register(188, 'plagued aoe summon effect', 910, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 2.5,
    offset = { -20, -20, true},
})

AttachedEffectManager.register(189, '[vampiric]', '/images/game/effects/red_spin', ThingExternalTexture, {
    size = { 220, 220 },
    offset = { 95, 90, false },
    duration = 3000,
    shader = "red glow",
})

AttachedEffectManager.register(190, '[Frostbound]', 842, ThingCategoryEffect, {
    opacity = 0.8,
    duration = 2000,
    speed = 1,
    offset = { -5, -5, true},
    
    onAttach = function(effect, owner)
        owner:setShader('frost armor')
    end,
    onDetach = function(effect, oldOwner)
        if oldOwner and oldOwner:getTile() then
            local e = Effect.create()
            e:setId(44)
            oldOwner:getTile():addThing(e)
            oldOwner:setShader('Outfit - Default')
        end
    end
})  

AttachedEffectManager.register(191, 'spider web', 1146, ThingCategoryEffect, {
    opacity = 1,
    duration = 2000,
    speed = 0.7,
    offset = { -20, -20, true},
})


AttachedEffectManager.register(192, 'vortex (water wave) 2', 242, ThingCategoryEffect, {
    duration = 1000,
    disableWalkAnimation = true,
    size = { 128, 128 },
    offset = { -22, -32, false },
    onAttach = function(effect, owner)
        owner:setBounce(13, 15, 1400)
        effect:setBounce(1, 2, 10000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setBounce(0, 0)
    end
})

AttachedEffectManager.register(193, 'vortex stun', 32, ThingCategoryEffect, {
    opacity = 1,
    duration = 1000,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(194, 'water torrent', 923 , ThingCategoryEffect, {
    duration = 500,
    speed = 1,
    offset = { -96, -96, true},
})

AttachedEffectManager.register(195, 'thunder leap stun', 32, ThingCategoryEffect, {
    opacity = 1,
    duration = 1000,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(196, 'thunder leap ground effect', 646 , ThingCategoryEffect, {
    loop = 1,
    opacity = 1,
    speed = 0.4,
    offset = { -32, -32, false},
})

AttachedEffectManager.register(197, 'thunder leap ground effect 2', '/images/game/effects/shockwave ground', ThingExternalTexture, {
    loop = 1,
    speed = 1.0,
    offset = { 50, 50, false},
    size = { 128, 128 },
    
})

AttachedEffectManager.register(198, 'thunder leap ground aura', '/images/game/effects/shockwave aura', ThingExternalTexture, {
    loop = 1,
    opacity = 1,
    speed = 0.83,
    offset = { 50, 50, false},
    size = { 128, 128 },
    
})

AttachedEffectManager.register(199, 'healing prisma 1', 1142 , ThingCategoryEffect, {
    loop = 1,
    opacity = 1,
    speed = 1,
    offset = { -80, -80, true},
})

AttachedEffectManager.register(200, 'healing prisma 2', 1050 , ThingCategoryEffect, {
    loop = 1,
    opacity = 1,
    speed = 1,
    offset = { -64, -64, false},
})

AttachedEffectManager.register(201, 'fire tornado', 935 , ThingCategoryEffect, {
    hideOwner = true,
    duration = 4000,
    opacity = 1,
    speed = 1,
    offset = { -48, -5, true}, 
})

AttachedEffectManager.register(202, 'opelus', 1028 , ThingCategoryEffect, {
    loop = 1,
    opacity = 1,
    speed = 0.7,
    offset = { -60, -60, false}, 
})

AttachedEffectManager.register(203, 'blood aura 1', 1156 , ThingCategoryEffect, {
    opacity = 1,
    duration = 8000,
    speed = 1.3,
    offset = { -80, -78, false},
    shader = 'Red Glow',

    onAttach = function(effect, owner)
        owner:setShader('Red Glow')     
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setShader('Outfit - Default')
    end
})

AttachedEffectManager.register(204, 'shadowstep stun', 32, ThingCategoryEffect, {
    opacity = 1,
    duration = 500,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(205, 'charge stun', 32, ThingCategoryEffect, {
    opacity = 1,
    duration = 1000,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(206, 'light-dash stun', 32, ThingCategoryEffect, {
    opacity = 1,
    duration = 1800,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(207, 'frost wave', 842, ThingCategoryEffect, {
    opacity = 0.65,
    duration = 3500,
    speed = 1,
    offset = { -15, -15, true},
    
    onAttach = function(effect, owner)
        owner:setShader('frost armor')
    end,
    onDetach = function(effect, oldOwner)
        if oldOwner and oldOwner:getTile() then
            local e = Effect.create()
            e:setId(44)
            oldOwner:getTile():addThing(e)
            oldOwner:setShader('Outfit - Default')
        end
    end
})  

AttachedEffectManager.register(208, 'damaged', 0, 0, {
    opacity = 1,
    duration = 200,
    onAttach = function(effect, owner)
     owner:setShader('Damaged')
    end,
    onDetach = function(effect, oldOwner)
     oldOwner:setShader('Outfit - Default')
    end
})  

AttachedEffectManager.register(209, 'frost quiver damage', 967 , ThingCategoryEffect, {
    loop = 1,
    opacity = 1,
    speed = 1,
    offset = { -18, -18, true}, 
})

AttachedEffectManager.register(210, 'momentum aura', 1167 , ThingCategoryEffect, {
    duration = 6000,
    opacity = 1,
    speed = 1,
    offset = { -32, -32, false}, 
})

AttachedEffectManager.register(211, 'falcon aura slow', 885 , ThingCategoryEffect, {
    loop = 1,
    opacity = 0.65,
    speed = 1,
    offset = { -64, -64, false}, 
})

AttachedEffectManager.register(212, 'falcon aura on player', 922 , ThingCategoryEffect, {
    loop = 1,
    opacity = 0.65,
    speed = 1,
    offset = { -96, -128, false}, 
})

AttachedEffectManager.register(213, 'dragon aura', 2902, ThingCategoryCreature, {
    opacity = 0.55,
    speed = 2.0,
    duration = 17000,
    offset = { -38, -38, true},
    
})
AttachedEffectManager.register(214, 'ice clones', 0, 0, {
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 44)
        owner:setShader('frost armor')
    end,
    onDetach = function(effect, oldOwner)
        if oldOwner and oldOwner:getTile() then
            local e = Effect.create()
            e:setId(44)
            oldOwner:getTile():addThing(e)
            oldOwner:setShader('Outfit - Default')
        end
    end
})  

AttachedEffectManager.register(215, 'frostbloom', 1171, ThingCategoryEffect, {
    opacity = 1,
    duration = 5000,
    speed = 1,
    offset = { -19, -15, true},
    shader = 'frost armor',
    
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 44)

    end,
    onDetach = function(effect, oldOwner)
        if oldOwner and oldOwner:getTile() then
            local e = Effect.create()
            e:setId(44)
            oldOwner:getTile():addThing(e)
        end
    end
})  

AttachedEffectManager.register(216, 'thunderfist electricity', 495, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1.4,
    offset = { 0, 0, true},
})

AttachedEffectManager.register(217, 'mountain stance', 952, ThingCategoryEffect, {
    opacity = 1,
    duration = 6000,
    speed = 1.0,
    offset = { -15, -15, true}, 
})

AttachedEffectManager.register(218, 'hand of god', 237, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1.0,
    offset = { 15, 5, true}, 
})

AttachedEffectManager.register(219, 'hand of god ground break', 661, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -32, -32, false }
})

AttachedEffectManager.register(220, 'hand of god ground break', 668, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -64, -64, false }
})

AttachedEffectManager.register(221, 'blood pact', 977, ThingCategoryEffect, {
    loop = 1,
    speed = 1.8,
    offset = { -20, -5, true }
})

AttachedEffectManager.register(222, 'lotus kick 1', 1075, ThingCategoryEffect, {
    loop = 1,
    speed = 1.0,
    offset = { -40, -40, false }
})

AttachedEffectManager.register(223, 'lotus kick 2', 1078, ThingCategoryEffect, {
    loop = 1,
    speed = 1.0,
    offset = { -40, -40, true }
})

AttachedEffectManager.register(224, 'lotus kick 3', 1079, ThingCategoryEffect, {
    loop = 1,
    speed = 1.0,
    offset = { -40, -40, true }
})


AttachedEffectManager.register(225, 'slash left', '/images/game/effects/slash1', ThingExternalTexture, {
    loop = 1,
    speed = 1.0,
    size = { 130, 130 },
    offset = { 90, 60, true }
})

AttachedEffectManager.register(226, 'slash north', '/images/game/effects/slash2', ThingExternalTexture, {
    loop = 1,
    speed = 1.0,
    size = { 130, 130 },
    offset = { 65, 90, true }
})

AttachedEffectManager.register(227, 'slash right', '/images/game/effects/slash3', ThingExternalTexture, {
    loop = 1,
    speed = 1.0,
    size = { 130, 130 },
    offset = { 20, 60, true }
})

AttachedEffectManager.register(228, 'slash south', '/images/game/effects/slash4', ThingExternalTexture, {
    loop = 1,
    speed = 1.0,
    size = { 130, 130 },
    offset = { 60, 20, true }
})

AttachedEffectManager.register(229, 'bless of the forest', 364, ThingCategoryEffect, {
    loop = 1,
    speed = 1.5,
    offset = { -32, -32, false }
})

AttachedEffectManager.register(230, 'party kings', 877, ThingCategoryEffect, {
    loop = 1,
    speed = 1.0,
    offset = { -24, -50, true }
})

AttachedEffectManager.register(231, 'astral infusion', 953, ThingCategoryEffect, {
    loop = 1,
    speed = 1.0,
    offset = { -25, -10, true },

    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 12)

    end,
    onDetach = function(effect, oldOwner)
        if oldOwner and oldOwner:getTile() then
            local e = Effect.create()
            e:setId(12)
            oldOwner:getTile():addThing(e)
        end
    end
})

AttachedEffectManager.register(232, 'crane stance', 1158, ThingCategoryEffect, {
    loop = 1,
    speed = 1.0,
    offset = { -20, -15, false }
})

AttachedEffectManager.register(233, 'exorcism left', '/images/game/effects/exorcismleft', ThingExternalTexture, {
    loop = 1,
    speed = 1.0,
    size = { 270, 160 },
    offset = { 215, 70, false }
})

AttachedEffectManager.register(234, 'exorcism north', '/images/game/effects/exorcismnorth', ThingExternalTexture, {
    loop = 1,
    speed = 1.0,
    size = { 160, 270 },
    offset = { 65, 215, false }
})

AttachedEffectManager.register(235, 'exorcism right', '/images/game/effects/exorcismright', ThingExternalTexture, {
    loop = 1,
    speed = 1.0,
    size = { 270, 160 },
    offset = { 30, 60, false }
})

AttachedEffectManager.register(236, 'exorcism south', '/images/game/effects/exorcismsouth', ThingExternalTexture, {
    loop = 1,
    speed = 1.0,
    size = { 160, 270 },
    offset = { 70, 30, false }
})

AttachedEffectManager.register(237, 'party vitality', 875, ThingCategoryEffect, {
    loop = 2,
    speed = 0.7,
    offset = { -32, -32, false }
})

AttachedEffectManager.register(238, 'assasination effect', 864, ThingCategoryEffect, {
    duration = 3100,
    hideOwner = true,
    speed = 0.75,
    offset = { -55, -50, true },
})

AttachedEffectManager.register(239, 'waypoints', 0, 0, {

    onAttach = function(effect, owner)
        owner:setShader('Test')
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setShader('Outfit - Default')
    end

})

AttachedEffectManager.register(240, 'waypoints bounce', 0, 0, {
    onAttach = function(effect, owner)
        owner:setBounce(0, 10, 1000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setBounce(0, 0, 0)
    end
})

AttachedEffectManager.register(241, 'www', '/images/game/effects/animated', ThingExternalTexture, {
    size = { 400, 400 },
    offset = { 50, 45 }
})

AttachedEffectManager.register(242, 'npc area blue', 667, ThingCategoryEffect, {
    speed = 0.75,
    offset = { -96, -96, true },
})

AttachedEffectManager.register(243, 'npc area green', 667, ThingCategoryEffect, {
    speed = 0.75,
    offset = { -96, -96, true },
})

AttachedEffectManager.register(244, 'npc area red', 1182, ThingCategoryEffect, {
    speed = 0.75,
    offset = { -96, -96, true },
})

AttachedEffectManager.register(245, 'npc area inactive', 665, ThingCategoryEffect, {
    speed = 0.75,
    offset = { -96, -96, true },
})

AttachedEffectManager.register(246, 'ground break heat wave', 660, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -75, -60, false},
    
})

AttachedEffectManager.register(247, 'time bomb', 668, ThingCategoryEffect, {
    loop = 1,
    speed = 0.32,
    offset = { -64, -64, false }
})

AttachedEffectManager.register(248, 'exp effect', 1116, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -32, -32, true }

})

AttachedEffectManager.register(249, 'mountain stance', 952, ThingCategoryEffect, {
    loop = 1,
    speed = 1.0,
    offset = { -15, -15, true}, 
})

-- SIZE CHANGE EFFECTS (Testing)
-- SIZE INCREMENT EFFECTS (Permanent - 0.015 increments)


AttachedEffectManager.register(250, 'Miniaturize', 0, 0, {
    duration = 8000,
    onAttach = function(effect, owner)
        owner:setScaleFactor(0.5, 300)
        
        safeAddTileEffect(owner, 53)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 300)
        
        safeAddTileEffect(oldOwner, 54)
    end
})

AttachedEffectManager.register(251, 'Growing Rage', 590, ThingCategoryEffect, {

    onAttach = function(effect, owner)
        
        owner:setScaleFactor(1.2, 650)
        owner:setShader('Monster Might')
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        oldOwner:setShader('Outfit - Default')
    end
})

AttachedEffectManager.register(252, 'Titan Form', 497, ThingCategoryEffect, {
    duration = 15000,
    speed = 1,
    offset = { 0, 0, true },
    shader = 'Monster Might',
    onAttach = function(effect, owner)
        
        owner:setScaleFactor(2.0, 1000)
        
        safeAddTileEffect(owner, 497)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 1000)
        
        safeAddTileEffect(oldOwner, 497)
    end
})

AttachedEffectManager.register(253, 'Tiny Creature (dwarf)', 0, 0, {
    duration = 5000,
    onAttach = function(effect, owner)
        owner:setScaleFactor(0.75, 400)
       -- owner:setBounce(10, 5, 2000)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 400)
        --oldOwner:setBounce(0, 0)
    end
})
AttachedEffectManager.register(254, 'Size +5%', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.05, 500)
        
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(255, 'Size +10%', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.10, 500)
        
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(256, 'Size +15%', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.15, 500)
        
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(257, 'Size +20%', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.20, 500)
        
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(258, 'Size +25%', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.25, 500)
        
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(259, 'Size +30%', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.30, 500)
        
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(260, 'Size +35%', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.35, 500)
        
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(261, 'Size +40%', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.40, 500)
        
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(262, 'Size +45%', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.45, 500)
        
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(263, 'Size +50%', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.50, 500)
        
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        
        safeAddTileEffect(oldOwner, 50)
    end
})

-- EFFECT SIZE EXAMPLES (Visual effect size, not creature size)
AttachedEffectManager.register(264, 'Fire Mini', 590, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { 16, 16, true },
    size = { 32, 32 }  -- Pequeño 32x32
})

AttachedEffectManager.register(265, 'Fire Normal', 590, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { 0, 0, true }
    -- Sin size = tamaño original del sprite (~64x64)
})

AttachedEffectManager.register(266, 'Fire Large', 590, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -32, -32, true },
    size = { 128, 128 }  -- Grande 128x128 (2x)
})

AttachedEffectManager.register(267, 'Fire Giant', 590, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -64, -64, true },
    size = { 192, 192 }  -- Gigante 192x192 (3x)
})

AttachedEffectManager.register(268, 'Fire Massive', 590, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -96, -96, true },
    size = { 256, 256 }  -- Masivo 256x256 (4x)
})

AttachedEffectManager.register(269, 'Fire Beam Horizontal', 590, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -96, 0, true },
    size = { 256, 64 }  -- Beam horizontal ancho
})

AttachedEffectManager.register(270, 'Fire Beam Vertical', 590, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { 0, -96, true },
    size = { 64, 256 }  -- Beam vertical alto
})

AttachedEffectManager.register(271, 'Angel Light Tiny', 3, ThingCategoryEffect, {
    loop = 1,
    speed = 0.65,
    offset = { 8, 8, true },
    size = { 24, 24 }  -- Luz angelical pequeña
})

AttachedEffectManager.register(272, 'Angel Light Huge', 3, ThingCategoryEffect, {
    loop = 1,
    speed = 0.65,
    offset = { -64, -64, true },
    size = { 160, 160 }  -- Luz angelical enorme
})

AttachedEffectManager.register(273, 'Energy Aura Wide', 497, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -80, -40, true },
    size = { 200, 100 }  -- Aura ancha y baja
})

-- ═══════════════════════════════════════════════════════════════
-- ⚡ EFECTOS ÉPICOS - DESLUMBRANTES ⚡
-- ═══════════════════════════════════════════════════════════════

-- 🎯 ORBITAL STRIKE - Missiles convergiendo desde todas direcciones
AttachedEffectManager.register(280, 'Orbital Strike', 0, 0, {
    duration = 2000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 5
        local missiles = 12  -- 12 missiles formando un círculo completo
        
        for i = 0, missiles - 1 do
            local angle = (360 / missiles) * i
            local rad = math.rad(angle)
            local startX = pos.x + math.floor(math.cos(rad) * radius)
            local startY = pos.y + math.floor(math.sin(rad) * radius)
            
            local missile = AttachedEffect.create(38, ThingCategoryMissile)
            missile:setDuration(2000)
            missile:setBounce(0, 20, 500)  -- Bounce para efecto de impacto
            missile:setOpacity(0.9)
            
            -- Mover desde la posición calculada hacia el owner
            missile:move({x = startX, y = startY, z = pos.z}, pos)
            effect:attachEffect(missile)
        end
        
        -- Efecto de explosión central al final
        local centralExplosion = AttachedEffect.create(7, ThingCategoryEffect)
        centralExplosion:setDuration(1000)
        centralExplosion:setOpacity(0)
        centralExplosion:setFade(0, 100, 1800)  -- Aparece gradualmente
        centralExplosion:setPulse(80, 120, 400)  -- Pulsa al aparecer
        effect:attachEffect(centralExplosion)
    end
})

-- 🔥 PHOENIX WINGS - Alas de fuego con partículas ascendentes
AttachedEffectManager.register(281, 'Phoenix Wings', 590, ThingCategoryEffect, {
    duration = 3000,
    loop = -1,
    speed = 0.8,
    onAttach = function(effect, owner)
        local spriteSize = g_gameConfig.getSpriteSize()
        
        -- Ala izquierda
        local leftWing = AttachedEffect.create(590, ThingCategoryEffect)
        leftWing:setDuration(3000)
        leftWing:setOffset(-spriteSize * 1.5, -spriteSize * 0.5)
        leftWing:setBounce(0, 8, 2000)  -- Aleteo suave
        leftWing:setOpacity(0.85)
        effect:attachEffect(leftWing)
        
        -- Ala derecha
        local rightWing = AttachedEffect.create(590, ThingCategoryEffect)
        rightWing:setDuration(3000)
        rightWing:setOffset(spriteSize * 1.5, -spriteSize * 0.5)
        rightWing:setBounce(0, 8, 2000)
        rightWing:setOpacity(0.85)
        effect:attachEffect(rightWing)
        
        -- Partículas de fuego ascendentes
        for i = 1, 6 do
            local particle = AttachedEffect.create(590, ThingCategoryEffect)
            particle:setDuration(1500)
            particle:setOffset((i - 3.5) * 10, 20)
            particle:setBounce(20, 60, 1200)  -- Ascienden
            particle:setFade(100, 0, 1500)  -- Desaparecen arriba
            particle:setOpacity(0.6)
            effect:attachEffect(particle)
        end
    end
})

-- ⭐ DIVINE ASCENSION - Luz divina con anillos giratorios
AttachedEffectManager.register(282, 'Divine Ascension', 3, ThingCategoryEffect, {
    duration = 4000,
    loop = -1,
    speed = 0.5,
    onAttach = function(effect, owner)
        -- Pilar de luz central
        local pillar = AttachedEffect.create(3, ThingCategoryEffect)
        pillar:setDuration(4000)
        pillar:setOffset(0, -32, true)
        pillar:setPulse(90, 110, 1000)
        pillar:setOpacity(0.9)
        effect:attachEffect(pillar)
        
        -- Anillo base
        local baseRing = AttachedEffect.create(497, ThingCategoryEffect)
        baseRing:setDuration(4000)
        baseRing:setOffset(0, 10, true)
        baseRing:setBounce(0, 5, 2000)
        baseRing:setOpacity(0.7)
        effect:attachEffect(baseRing)
        
        -- Partículas orbitales (simulando rotación)
        for i = 0, 7 do
            local angle = (360 / 8) * i
            local rad = math.rad(angle)
            local distance = 40
            local orbitalX = math.floor(math.cos(rad) * distance)
            local orbitalY = math.floor(math.sin(rad) * distance)
            
            local particle = AttachedEffect.create(3, ThingCategoryEffect)
            particle:setDuration(2000)
            particle:setOffset(orbitalX, orbitalY, true)
            particle:setFade(0, 100, 2000)
            particle:setPulse(50, 100, 1000)
            particle:setOpacity(0.6)
            effect:attachEffect(particle)
        end
    end
})

-- 👤 SHADOW CLONE - Múltiples copias sombrías
AttachedEffectManager.register(283, 'Shadow Clone', 50, ThingCategoryEffect, {
    duration = 2500,
    permanent = false,
    onAttach = function(effect, owner)
        local spriteSize = g_gameConfig.getSpriteSize()
        local positions = {
            {-spriteSize, -spriteSize},      -- Arriba-izquierda
            {spriteSize, -spriteSize},       -- Arriba-derecha
            {-spriteSize, spriteSize},       -- Abajo-izquierda
            {spriteSize, spriteSize},        -- Abajo-derecha
            {-spriteSize * 1.5, 0},          -- Izquierda
            {spriteSize * 1.5, 0},           -- Derecha
        }
        
        for i, pos in ipairs(positions) do
            local clone = AttachedEffect.create(50, ThingCategoryEffect)
            clone:setDuration(2500)
            clone:setOffset(pos[1], pos[2], true)
            clone:setOpacity(0)
            clone:setFade(0, 70, 800)  -- Aparecen
            clone:setBounce(0, 5, 1500)
            effect:attachEffect(clone)
            
            -- Segunda onda de clones más lejos
            local clone2 = AttachedEffect.create(50, ThingCategoryEffect)
            clone2:setDuration(2000)
            clone2:setOffset(pos[1] * 1.8, pos[2] * 1.8, true)
            clone2:setOpacity(0)
            clone2:setFade(0, 40, 1200)
            clone2:setPulse(50, 100, 800)
            effect:attachEffect(clone2)
        end
    end
})

-- ⚡ ELEMENTAL STORM - Tormenta de todos los elementos
AttachedEffectManager.register(284, 'Elemental Storm', 0, 0, {
    duration = 5000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- Fuego - Círculo de llamas
        for i = 0, 7 do
            local angle = (360 / 8) * i
            local rad = math.rad(angle)
            local distance = 3
            local fireX = pos.x + math.floor(math.cos(rad) * distance)
            local fireY = pos.y + math.floor(math.sin(rad) * distance)
            
            local fireMissile = AttachedEffect.create(38, ThingCategoryMissile)
            fireMissile:setDuration(3000)
            fireMissile:setBounce(0, 15, 1000)
            fireMissile:move({x = fireX, y = fireY, z = pos.z}, pos)
            effect:attachEffect(fireMissile)
        end
        
        -- Energía - Rayos desde arriba
        for i = -2, 2 do
            local lightning = AttachedEffect.create(497, ThingCategoryEffect)
            lightning:setDuration(2000)
            lightning:setOffset(i * 20, -60, true)
            lightning:setBounce(60, 10, 1500)  -- Caen
            lightning:setFade(100, 0, 2000)
            lightning:setOpacity(0.8)
            effect:attachEffect(lightning)
        end
        
        -- Luz divina central
        local divine = AttachedEffect.create(3, ThingCategoryEffect)
        divine:setDuration(5000)
        divine:setOpacity(0)
        divine:setFade(0, 100, 1000)
        divine:setPulse(80, 120, 800)
        effect:attachEffect(divine)
        
        -- Oscuridad pulsante
        local darkness = AttachedEffect.create(50, ThingCategoryEffect)
        darkness:setDuration(5000)
        darkness:setOffset(0, 0, true)
        darkness:setPulse(50, 150, 1200)
        darkness:setOpacity(0.4)
        effect:attachEffect(darkness)
    end
})

-- 🌀 TIME WARP - Distorsión temporal
AttachedEffectManager.register(285, 'Time Warp', 497, ThingCategoryEffect, {
    duration = 3500,
    loop = -1,
    speed = 0.3,
    onAttach = function(effect, owner)
        -- Anillos concéntricos que se expanden
        for ring = 1, 5 do
            local ripple = AttachedEffect.create(497, ThingCategoryEffect)
            ripple:setDuration(3000)
            ripple:setOffset(0, 0, true)
            ripple:setOpacity(0)
            ripple:setFade(0, 80 - (ring * 10), 800 + (ring * 200))  -- Aparecen en secuencia
            ripple:setPulse(100 - (ring * 5), 100 + (ring * 20), 2000)  -- Se expanden
            effect:attachEffect(ripple)
        end
        
        -- Partículas flotantes erráticas
        for i = 1, 12 do
            local particle = AttachedEffect.create(3, ThingCategoryEffect)
            particle:setDuration(2500)
            local angle = (360 / 12) * i
            local rad = math.rad(angle)
            local px = math.floor(math.cos(rad) * 30)
            local py = math.floor(math.sin(rad) * 30)
            particle:setOffset(px, py, true)
            particle:setBounce(0, 20, 1500)  -- Flotan arriba y abajo
            particle:setPulse(60, 100, 800)
            particle:setOpacity(0.7)
            effect:attachEffect(particle)
        end
    end
})

-- 🕳️ BLACK HOLE - Vacío absorbente
AttachedEffectManager.register(286, 'Black Hole', 50, ThingCategoryEffect, {
    duration = 4000,
    loop = -1,
    speed = 1.2,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- Núcleo oscuro pulsante
        local core = AttachedEffect.create(50, ThingCategoryEffect)
        core:setDuration(4000)
        core:setOffset(0, 0, true)
        core:setPulse(120, 80, 1000)  -- Se contrae (reverse pulse)
        core:setOpacity(0.95)
        effect:attachEffect(core)
        
        -- Anillo de energía giratorio
        local energyRing = AttachedEffect.create(497, ThingCategoryEffect)
        energyRing:setDuration(4000)
        energyRing:setOffset(0, 0, true)
        energyRing:setPulse(110, 90, 1500)
        energyRing:setOpacity(0.6)
        effect:attachEffect(energyRing)
        
        -- Partículas siendo absorbidas hacia el centro
        for i = 0, 15 do
            local angle = (360 / 16) * i
            local rad = math.rad(angle)
            local distance = 6
            local startX = pos.x + math.floor(math.cos(rad) * distance)
            local startY = pos.y + math.floor(math.sin(rad) * distance)
            
            -- Missile que se mueve hacia el centro
            local particle = AttachedEffect.create(38, ThingCategoryMissile)
            particle:setDuration(2500)
            particle:setOpacity(0.7)
            particle:setFade(100, 0, 2500)  -- Desaparece al llegar al centro
            particle:move({x = startX, y = startY, z = pos.z}, pos)
            effect:attachEffect(particle)
        end
    end
})

-- ⚡ CELESTIAL JUDGEMENT - Rayo divino desde el cielo
AttachedEffectManager.register(287, 'Celestial Judgement', 0, 0, {
    duration = 3000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local spriteSize = g_gameConfig.getSpriteSize()
        
        -- Marca en el suelo (preparación)
        local mark = AttachedEffect.create(497, ThingCategoryEffect)
        mark:setDuration(1000)
        mark:setOffset(0, 0, true)
        mark:setPulse(80, 120, 800)
        mark:setFade(0, 100, 500)
        effect:attachEffect(mark)
        
        -- Rayo descendente (después de 1 segundo)
        local beam = AttachedEffect.create(3, ThingCategoryEffect)
        beam:setDuration(2000)
        beam:setOffset(0, -spriteSize * 3, true)
        beam:setOpacity(0)
        beam:setFade(0, 100, 200)  -- Aparece instantáneamente
        beam:setBounce(spriteSize * 3, 0, 400)  -- Desciende rápido
        effect:attachEffect(beam)
        
        -- Explosión al impactar
        local explosion = AttachedEffect.create(7, ThingCategoryEffect)
        explosion:setDuration(1500)
        explosion:setOffset(0, 0, true)
        explosion:setOpacity(0)
        explosion:setFade(0, 100, 1000)
        explosion:setPulse(80, 150, 500)
        effect:attachEffect(explosion)
        
        -- Ondas de choque
        for i = 1, 3 do
            local shockwave = AttachedEffect.create(497, ThingCategoryEffect)
            shockwave:setDuration(2000)
            shockwave:setOffset(0, 0, true)
            shockwave:setOpacity(0)
            shockwave:setFade(0, 70 - (i * 15), 800 + (i * 300))
            shockwave:setPulse(100, 100 + (i * 30), 1500)
            effect:attachEffect(shockwave)
        end
    end
})

-- 🌊 TSUNAMI WAVE - Ola gigante convergente
AttachedEffectManager.register(288, 'Tsunami Wave', 0, 0, {
    duration = 3000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local distance = 7
        
        -- Olas desde 4 direcciones cardinales
        local directions = {
            {x = 0, y = -distance, name = "Norte"},
            {x = 0, y = distance, name = "Sur"},
            {x = -distance, y = 0, name = "Oeste"},
            {x = distance, y = 0, name = "Este"}
        }
        
        for _, dir in ipairs(directions) do
            -- Ola principal
            local wave = AttachedEffect.create(38, ThingCategoryMissile)
            wave:setDuration(2500)
            wave:setBounce(0, 25, 800)  -- Ola alta
            wave:setOpacity(0.85)
            wave:move({x = pos.x + dir.x, y = pos.y + dir.y, z = pos.z}, pos)
            effect:attachEffect(wave)
            
            -- Espuma de la ola
            local foam = AttachedEffect.create(497, ThingCategoryEffect)
            foam:setDuration(2000)
            foam:setOpacity(0)
            foam:setFade(0, 60, 1500)
            foam:setBounce(0, 15, 1200)
            effect:attachEffect(foam)
        end
        
        -- Explosión central al chocar
        local splash = AttachedEffect.create(7, ThingCategoryEffect)
        splash:setDuration(1500)
        splash:setOpacity(0)
        splash:setFade(0, 100, 2000)
        splash:setPulse(80, 140, 600)
        effect:attachEffect(splash)
    end
})

-- 🌟 SUPERNOVA - Explosión estelar masiva
AttachedEffectManager.register(289, 'Supernova', 3, ThingCategoryEffect, {
    duration = 5000,
    permanent = false,
    onAttach = function(effect, owner)
        -- Núcleo colapsando
        local core = AttachedEffect.create(3, ThingCategoryEffect)
        core:setDuration(1500)
        core:setOffset(0, 0, true)
        core:setPulse(150, 50, 1000)  -- Se contrae
        core:setOpacity(1.0)
        effect:attachEffect(core)
        
        -- Explosión masiva
        local blast = AttachedEffect.create(7, ThingCategoryEffect)
        blast:setDuration(3500)
        blast:setOffset(0, 0, true)
        blast:setOpacity(0)
        blast:setFade(0, 100, 1200)
        blast:setPulse(50, 200, 2000)  -- Se expande masivamente
        effect:attachEffect(blast)
        
        -- Partículas expulsadas en todas direcciones
        for i = 0, 23 do
            local angle = (360 / 24) * i
            local rad = math.rad(angle)
            local distance = 8
            local targetX = owner:getPosition().x + math.floor(math.cos(rad) * distance)
            local targetY = owner:getPosition().y + math.floor(math.sin(rad) * distance)
            
            local debris = AttachedEffect.create(38, ThingCategoryMissile)
            debris:setDuration(3000)
            debris:setOpacity(0.8)
            debris:setFade(100, 0, 3000)  -- Se desvanecen
            debris:setBounce(0, 15, 1500)
            debris:move(owner:getPosition(), {x = targetX, y = targetY, z = owner:getPosition().z})
            effect:attachEffect(debris)
        end
        
        -- Ondas de choque expansivas
        for wave = 1, 5 do
            local shockwave = AttachedEffect.create(497, ThingCategoryEffect)
            shockwave:setDuration(4000)
            shockwave:setOffset(0, 0, true)
            shockwave:setOpacity(0)
            shockwave:setFade(0, 80 - (wave * 12), 500 + (wave * 400))
            shockwave:setPulse(100, 100 + (wave * 50), 3000)
            effect:attachEffect(shockwave)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 💀 EFECTOS MAMALONES PARTE 2 💀
-- ═══════════════════════════════════════════════════════════════

-- 🌪️ VORTEX OF SOULS - Vórtice de almas giratorio
AttachedEffectManager.register(290, 'Vortex of Souls', 0, 0, {
    duration = 4000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- Núcleo oscuro del vórtice
        local core = AttachedEffect.create(50, ThingCategoryEffect)
        core:setDuration(4000)
        core:setOffset(0, 0, true)
        core:setPulse(100, 130, 1500)
        core:setOpacity(0.8)
        effect:attachEffect(core)
        
        -- 3 capas de almas girando a diferentes velocidades
        for layer = 1, 3 do
            local numSouls = 6 + (layer * 2)  -- 8, 10, 12 almas por capa
            local radius = layer * 1.5
            
            for i = 0, numSouls - 1 do
                local angle = (360 / numSouls) * i
                local rad = math.rad(angle)
                local soulX = pos.x + math.floor(math.cos(rad) * radius)
                local soulY = pos.y + math.floor(math.sin(rad) * radius)
                
                local soul = AttachedEffect.create(50, ThingCategoryEffect)
                soul:setDuration(2500 - (layer * 200))
                soul:setOpacity(0.5 + (layer * 0.1))
                soul:setFade(0, 70, 1000)
                soul:setBounce(0, 10, 1500 - (layer * 100))
                soul:move({x = soulX, y = soulY, z = pos.z}, pos)
                effect:attachEffect(soul)
            end
        end
        
        -- Energía ascendente del centro
        for i = 1, 4 do
            local energy = AttachedEffect.create(497, ThingCategoryEffect)
            energy:setDuration(2000)
            energy:setOffset((i - 2.5) * 15, 0, true)
            energy:setBounce(0, 80, 1800)  -- Asciende alto
            energy:setFade(100, 0, 2000)
            energy:setOpacity(0.6)
            effect:attachEffect(energy)
        end
    end
})

-- ⚔️ BLADE STORM - Tormenta de espadas giratorias
AttachedEffectManager.register(291, 'Blade Storm', 0, 0, {
    duration = 3500,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- 12 espadas formando círculo y girando
        for blade = 0, 11 do
            local angle = (360 / 12) * blade
            local rad = math.rad(angle)
            local distance = 4
            
            -- Posición inicial (afuera)
            local startX = pos.x + math.floor(math.cos(rad) * distance)
            local startY = pos.y + math.floor(math.sin(rad) * distance)
            
            -- Posición final (cerca del centro)
            local endAngle = math.rad(angle + 180)  -- Gira media vuelta
            local endX = pos.x + math.floor(math.cos(endAngle) * 1.5)
            local endY = pos.y + math.floor(math.sin(endAngle) * 1.5)
            
            local sword = AttachedEffect.create(38, ThingCategoryMissile)
            sword:setDuration(3500)
            sword:setDirection(blade % 8)  -- Dirección rotando
            sword:setOpacity(0.9)
            sword:setBounce(0, 10, 1000)
            sword:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(sword)
        end
        
        -- Destello central al final
        local flash = AttachedEffect.create(7, ThingCategoryEffect)
        flash:setDuration(1500)
        flash:setOpacity(0)
        flash:setFade(0, 100, 3000)
        flash:setPulse(80, 150, 500)
        effect:attachEffect(flash)
    end
})

-- 🔮 PRISMATIC BURST - Explosión prismática de colores
AttachedEffectManager.register(292, 'Prismatic Burst', 0, 0, {
    duration = 3000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- Núcleo comprimiéndose
        local core = AttachedEffect.create(3, ThingCategoryEffect)
        core:setDuration(1000)
        core:setPulse(150, 50, 900)  -- Se comprime
        core:setOpacity(1.0)
        effect:attachEffect(core)
        
        -- Múltiples explosiones de diferentes colores (simulado con efectos)
        local effects = {3, 7, 497, 590, 50}  -- Diferentes IDs para simular colores
        
        for _, effectId in ipairs(effects) do
            local burst = AttachedEffect.create(effectId, ThingCategoryEffect)
            burst:setDuration(2500)
            burst:setOpacity(0)
            burst:setFade(0, 80, 800)
            burst:setPulse(50, 180, 2000)
            effect:attachEffect(burst)
        end
        
        -- 20 partículas saliendo en todas direcciones
        for i = 0, 19 do
            local angle = (360 / 20) * i
            local rad = math.rad(angle)
            local distance = 6
            local targetX = pos.x + math.floor(math.cos(rad) * distance)
            local targetY = pos.y + math.floor(math.sin(rad) * distance)
            
            local particle = AttachedEffect.create(38, ThingCategoryMissile)
            particle:setDuration(2500)
            particle:setOpacity(0.8)
            particle:setFade(100, 0, 2500)
            particle:setBounce(0, 20, 1200)
            particle:move(pos, {x = targetX, y = targetY, z = pos.z})
            effect:attachEffect(particle)
        end
    end
})

-- 🌩️ CHAIN LIGHTNING - Rayos en cadena
AttachedEffectManager.register(293, 'Chain Lightning', 0, 0, {
    duration = 2500,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local spriteSize = g_gameConfig.getSpriteSize()
        
        -- Rayo principal cayendo
        local mainBolt = AttachedEffect.create(497, ThingCategoryEffect)
        mainBolt:setDuration(800)
        mainBolt:setOffset(0, -spriteSize * 2, true)
        mainBolt:setBounce(spriteSize * 2, 0, 400)
        mainBolt:setOpacity(1.0)
        effect:attachEffect(mainBolt)
        
        -- Rayos secundarios en cadena (8 direcciones)
        for dir = 0, 7 do
            local angle = dir * 45
            local rad = math.rad(angle)
            local chainDist = 2
            local chainX = pos.x + math.floor(math.cos(rad) * chainDist)
            local chainY = pos.y + math.floor(math.sin(rad) * chainDist)
            
            local chainBolt = AttachedEffect.create(497, ThingCategoryEffect)
            chainBolt:setDuration(1500)
            chainBolt:setOpacity(0)
            chainBolt:setFade(0, 90, 600)
            chainBolt:move(pos, {x = chainX, y = chainY, z = pos.z})
            effect:attachEffect(chainBolt)
        end
        
        -- Chispas eléctricas flotantes
        for spark = 1, 10 do
            local sparkEffect = AttachedEffect.create(497, ThingCategoryEffect)
            sparkEffect:setDuration(2000)
            sparkEffect:setOffset((spark - 5) * 10, -20 - (spark * 5), true)
            sparkEffect:setBounce(0, 30, 1000)
            sparkEffect:setFade(100, 0, 2000)
            sparkEffect:setOpacity(0.7)
            effect:attachEffect(sparkEffect)
        end
    end
})

-- 💎 CRYSTAL PRISON - Prisión de cristal formándose
AttachedEffectManager.register(294, 'Crystal Prison', 0, 0, {
    duration = 3500,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- Base de cristal
        local base = AttachedEffect.create(497, ThingCategoryEffect)
        base:setDuration(3500)
        base:setOffset(0, 10, true)
        base:setOpacity(0)
        base:setFade(0, 80, 1000)
        base:setPulse(80, 100, 2000)
        effect:attachEffect(base)
        
        -- 6 pilares de cristal emergiendo desde el suelo
        for pillar = 0, 5 do
            local angle = (360 / 6) * pillar
            local rad = math.rad(angle)
            local distance = 1.5
            local pillarX = math.floor(math.cos(rad) * distance) * 20
            local pillarY = math.floor(math.sin(rad) * distance) * 20
            
            local crystal = AttachedEffect.create(3, ThingCategoryEffect)
            crystal:setDuration(3000)
            crystal:setOffset(pillarX, pillarY + 40, true)
            crystal:setBounce(40, 0, 1500)  -- Emerge desde abajo
            crystal:setOpacity(0)
            crystal:setFade(0, 85, 1000 + (pillar * 100))
            effect:attachEffect(crystal)
        end
        
        -- Cúpula superior formándose
        local dome = AttachedEffect.create(3, ThingCategoryEffect)
        dome:setDuration(2500)
        dome:setOffset(0, -60, true)
        dome:setBounce(60, -20, 2000)  -- Desciende desde arriba
        dome:setOpacity(0)
        dome:setFade(0, 70, 1500)
        dome:setPulse(80, 110, 1500)
        effect:attachEffect(dome)
        
        -- Destellos de cristalización
        for flash = 1, 8 do
            local sparkle = AttachedEffect.create(7, ThingCategoryEffect)
            sparkle:setDuration(2000)
            sparkle:setOffset((flash - 4.5) * 15, -10 - (flash * 3), true)
            sparkle:setOpacity(0)
            sparkle:setFade(0, 60, 500 + (flash * 200))
            sparkle:setPulse(50, 100, 800)
            effect:attachEffect(sparkle)
        end
    end
})

-- 🩸 BLOOD RITUAL - Ritual sangriento
AttachedEffectManager.register(295, 'Blood Ritual', 0, 0, {
    duration = 4500,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- Círculo ritual base (oscuro)
        local circle = AttachedEffect.create(50, ThingCategoryEffect)
        circle:setDuration(4500)
        circle:setOffset(0, 0, true)
        circle:setPulse(90, 120, 2000)
        circle:setOpacity(0)
        circle:setFade(0, 75, 1000)
        effect:attachEffect(circle)
        
        -- Runas alrededor del círculo (6 puntos)
        for rune = 0, 5 do
            local angle = (360 / 6) * rune
            local rad = math.rad(angle)
            local distance = 2.5
            local runeX = pos.x + math.floor(math.cos(rad) * distance)
            local runeY = pos.y + math.floor(math.sin(rad) * distance)
            
            -- Runa apareciendo
            local runeEffect = AttachedEffect.create(7, ThingCategoryEffect)
            runeEffect:setDuration(3500)
            runeEffect:setOpacity(0)
            runeEffect:setFade(0, 80, 500 + (rune * 300))
            runeEffect:setPulse(80, 110, 1500)
            runeEffect:move({x = runeX, y = runeY, z = pos.z}, pos)
            effect:attachEffect(runeEffect)
        end
        
        -- Energía oscura ascendente desde las runas
        for stream = 0, 5 do
            local angle = (360 / 6) * stream
            local rad = math.rad(angle)
            local streamX = math.floor(math.cos(rad) * 40)
            local streamY = math.floor(math.sin(rad) * 40)
            
            local energy = AttachedEffect.create(50, ThingCategoryEffect)
            energy:setDuration(3000)
            energy:setOffset(streamX, streamY + 30, true)
            energy:setBounce(30, -40, 2500)  -- Asciende hacia el centro
            energy:setFade(0, 70, 1500)
            energy:setOpacity(0.6)
            effect:attachEffect(energy)
        end
        
        -- Explosión final de energía oscura
        local burst = AttachedEffect.create(50, ThingCategoryEffect)
        burst:setDuration(2000)
        burst:setOpacity(0)
        burst:setFade(0, 100, 3500)
        burst:setPulse(80, 160, 800)
        effect:attachEffect(burst)
    end
})

-- 🌀 GRAVITY WELL - Pozo gravitacional
AttachedEffectManager.register(296, 'Gravity Well', 0, 0, {
    duration = 5000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- Centro del pozo (distorsión espacial)
        local well = AttachedEffect.create(50, ThingCategoryEffect)
        well:setDuration(5000)
        well:setOffset(0, 0, true)
        well:setPulse(110, 90, 1200)  -- Pulso de succión
        well:setOpacity(0.9)
        effect:attachEffect(well)
        
        -- Anillos gravitacionales pulsantes
        for ring = 1, 4 do
            local gravRing = AttachedEffect.create(497, ThingCategoryEffect)
            gravRing:setDuration(4000)
            gravRing:setOffset(0, 0, true)
            gravRing:setOpacity(0)
            gravRing:setFade(0, 60 - (ring * 10), 800 + (ring * 200))
            gravRing:setPulse(100 + (ring * 10), 100 - (ring * 5), 2000)
            effect:attachEffect(gravRing)
        end
        
        -- Materia siendo absorbida (16 partículas)
        for matter = 0, 15 do
            local angle = (360 / 16) * matter
            local rad = math.rad(angle)
            local distance = 5
            local matterX = pos.x + math.floor(math.cos(rad) * distance)
            local matterY = pos.y + math.floor(math.sin(rad) * distance)
            
            local particle = AttachedEffect.create(38, ThingCategoryMissile)
            particle:setDuration(3500)
            particle:setOpacity(0.7)
            particle:setFade(80, 0, 3500)
            particle:setBounce(0, 15, 1500)
            particle:move({x = matterX, y = matterY, z = pos.z}, pos)
            effect:attachEffect(particle)
        end
        
        -- Destello al centro cuando la materia llega
        local impactFlash = AttachedEffect.create(7, ThingCategoryEffect)
        impactFlash:setDuration(3000)
        impactFlash:setOpacity(0)
        impactFlash:setFade(0, 100, 3000)
        impactFlash:setPulse(50, 120, 500)
        effect:attachEffect(impactFlash)
    end
})

-- 👻 SPECTRAL DANCE - Danza espectral
AttachedEffectManager.register(297, 'Spectral Dance', 0, 0, {
    duration = 4000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- 4 espectros danzando en círculo
        for ghost = 0, 3 do
            local angle = (360 / 4) * ghost
            local rad = math.rad(angle)
            local distance = 2
            
            -- Posición inicial
            local startX = pos.x + math.floor(math.cos(rad) * distance)
            local startY = pos.y + math.floor(math.sin(rad) * distance)
            
            -- Posición opuesta (para el movimiento circular)
            local endAngle = math.rad(angle + 90)
            local endX = pos.x + math.floor(math.cos(endAngle) * distance)
            local endY = pos.y + math.floor(math.sin(endAngle) * distance)
            
            local specter = AttachedEffect.create(50, ThingCategoryEffect)
            specter:setDuration(3000)
            specter:setOpacity(0)
            specter:setFade(0, 60, 1000)
            specter:setBounce(0, 15, 2000)  -- Flotando
            specter:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(specter)
        end
        
        -- Rastro espectral
        for trail = 1, 12 do
            local trailEffect = AttachedEffect.create(50, ThingCategoryEffect)
            trailEffect:setDuration(2500)
            trailEffect:setOffset((trail - 6.5) * 10, (trail % 2) * 15, true)
            trailEffect:setOpacity(0)
            trailEffect:setFade(0, 40, 1000 + (trail * 100))
            trailEffect:setPulse(60, 100, 1500)
            effect:attachEffect(trailEffect)
        end
    end
})

-- 🔥❄️ ELEMENTAL FUSION - Fusión de fuego y hielo
AttachedEffectManager.register(298, 'Elemental Fusion', 0, 0, {
    duration = 3500,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- Lado de fuego (izquierda)
        for fire = 0, 3 do
            local fireEffect = AttachedEffect.create(590, ThingCategoryEffect)
            fireEffect:setDuration(3000)
            fireEffect:setOffset(-40 - (fire * 10), (fire - 1.5) * 20, true)
            fireEffect:setBounce(0, 20, 1500)
            fireEffect:setOpacity(0.8)
            fireEffect:setFade(0, 90, 800)
            effect:attachEffect(fireEffect)
        end
        
        -- Lado de hielo (derecha) - simulado con efectos azules
        for ice = 0, 3 do
            local iceEffect = AttachedEffect.create(3, ThingCategoryEffect)
            iceEffect:setDuration(3000)
            iceEffect:setOffset(40 + (ice * 10), (ice - 1.5) * 20, true)
            iceEffect:setBounce(0, 20, 1500)
            iceEffect:setOpacity(0.8)
            iceEffect:setFade(0, 90, 800)
            effect:attachEffect(iceEffect)
        end
        
        -- Colisión en el centro
        local collision = AttachedEffect.create(7, ThingCategoryEffect)
        collision:setDuration(2500)
        collision:setOpacity(0)
        collision:setFade(0, 100, 1500)
        collision:setPulse(70, 150, 800)
        effect:attachEffect(collision)
        
        -- Explosión de vapor/energía
        for steam = 0, 11 do
            local angle = (360 / 12) * steam
            local rad = math.rad(angle)
            local distance = 4
            local steamX = pos.x + math.floor(math.cos(rad) * distance)
            local steamY = pos.y + math.floor(math.sin(rad) * distance)
            
            local steamEffect = AttachedEffect.create(497, ThingCategoryEffect)
            steamEffect:setDuration(2500)
            steamEffect:setOpacity(0.7)
            steamEffect:setFade(100, 0, 2500)
            steamEffect:move(pos, {x = steamX, y = steamY, z = pos.z})
            effect:attachEffect(steamEffect)
        end
    end
})

-- 💀⚡ DEATH'S TOUCH - Toque de la muerte
AttachedEffectManager.register(299, 'Deaths Touch', 0, 0, {
    duration = 3000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local spriteSize = g_gameConfig.getSpriteSize()
        
        -- Mano esquelética descendiendo
        local hand = AttachedEffect.create(50, ThingCategoryEffect)
        hand:setDuration(2000)
        hand:setOffset(0, -spriteSize * 3, true)
        hand:setBounce(spriteSize * 3, 0, 1200)  -- Desciende
        hand:setOpacity(0)
        hand:setFade(0, 90, 600)
        effect:attachEffect(hand)
        
        -- Aura de muerte al contacto
        local deathAura = AttachedEffect.create(50, ThingCategoryEffect)
        deathAura:setDuration(2500)
        deathAura:setOpacity(0)
        deathAura:setFade(0, 100, 1000)
        deathAura:setPulse(80, 140, 1000)
        effect:attachEffect(deathAura)
        
        -- Almas escapando en espiral
        for soul = 0, 7 do
            local angle = (360 / 8) * soul
            local rad = math.rad(angle)
            local distance = 3
            local soulX = pos.x + math.floor(math.cos(rad) * distance)
            local soulY = pos.y + math.floor(math.sin(rad) * distance)
            
            local soulEffect = AttachedEffect.create(50, ThingCategoryEffect)
            soulEffect:setDuration(2500)
            soulEffect:setOpacity(0.6)
            soulEffect:setFade(100, 0, 2500)
            soulEffect:setBounce(0, 40, 1800)  -- Ascienden
            soulEffect:move(pos, {x = soulX, y = soulY, z = pos.z})
            effect:attachEffect(soulEffect)
        end
        
        -- Grietas oscuras
        for crack = 0, 3 do
            local angle = crack * 90
            local rad = math.rad(angle)
            local crackX = math.floor(math.cos(rad) * 30)
            local crackY = math.floor(math.sin(rad) * 30)
            
            local crackEffect = AttachedEffect.create(50, ThingCategoryEffect)
            crackEffect:setDuration(2000)
            crackEffect:setOffset(crackX, crackY, true)
            crackEffect:setOpacity(0)
            crackEffect:setFade(0, 70, 800 + (crack * 200))
            effect:attachEffect(crackEffect)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 🌀 EFECTOS ORBITALES 🌀
-- ═══════════════════════════════════════════════════════════════

-- 🔮 ORBITING MISSILES - 4 missiles orbitando
AttachedEffectManager.register(300, 'Orbiting Missiles 4', 0, 0, {
    duration = 4000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2
        local numMissiles = 4
        
        for i = 0, numMissiles - 1 do
            local angle = (360 / numMissiles) * i
            local rad = math.rad(angle)
            
            -- Posición inicial
            local startX = pos.x + math.floor(math.cos(rad) * radius)
            local startY = pos.y + math.floor(math.sin(rad) * radius)
            
            -- Posición final (90 grados adelante para simular órbita)
            local endAngle = math.rad(angle + 90)
            local endX = pos.x + math.floor(math.cos(endAngle) * radius)
            local endY = pos.y + math.floor(math.sin(endAngle) * radius)
            
            local missile = AttachedEffect.create(38, ThingCategoryMissile)
            missile:setDuration(4000)
            missile:setDirection(i * 2)
            missile:setOpacity(0.9)
            missile:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(missile)
        end
    end
})

-- ⚡ ORBITING MISSILES - 8 missiles orbitando rápido
AttachedEffectManager.register(301, 'Orbiting Missiles 8', 0, 0, {
    duration = 3000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2.5
        local numMissiles = 8
        
        for i = 0, numMissiles - 1 do
            local angle = (360 / numMissiles) * i
            local rad = math.rad(angle)
            
            local startX = pos.x + math.floor(math.cos(rad) * radius)
            local startY = pos.y + math.floor(math.sin(rad) * radius)
            
            local endAngle = math.rad(angle + 90)
            local endX = pos.x + math.floor(math.cos(endAngle) * radius)
            local endY = pos.y + math.floor(math.sin(endAngle) * radius)
            
            local missile = AttachedEffect.create(38, ThingCategoryMissile)
            missile:setDuration(3000)
            missile:setDirection(i % 8)
            missile:setOpacity(0.85)
            missile:setBounce(0, 8, 1500)
            missile:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(missile)
        end
    end
})

-- 🔥 FIRE ORBIT - Bolas de fuego orbitando
AttachedEffectManager.register(302, 'Fire Orbit', 0, 0, {
    duration = 4500,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2
        local numOrbs = 6
        
        for i = 0, numOrbs - 1 do
            local angle = (360 / numOrbs) * i
            local rad = math.rad(angle)
            
            local startX = pos.x + math.floor(math.cos(rad) * radius)
            local startY = pos.y + math.floor(math.sin(rad) * radius)
            
            local endAngle = math.rad(angle + 120)
            local endX = pos.x + math.floor(math.cos(endAngle) * radius)
            local endY = pos.y + math.floor(math.sin(endAngle) * radius)
            
            local fireOrb = AttachedEffect.create(590, ThingCategoryEffect)
            fireOrb:setDuration(4500)
            fireOrb:setOpacity(0.8)
            fireOrb:setPulse(90, 110, 1000)
            fireOrb:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(fireOrb)
        end
    end
})

-- ⭐ DIVINE ORBIT - Luces divinas orbitando
AttachedEffectManager.register(303, 'Divine Orbit', 0, 0, {
    duration = 5000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2.5
        local numLights = 5
        
        for i = 0, numLights - 1 do
            local angle = (360 / numLights) * i
            local rad = math.rad(angle)
            
            local startX = pos.x + math.floor(math.cos(rad) * radius)
            local startY = pos.y + math.floor(math.sin(rad) * radius)
            
            local endAngle = math.rad(angle + 72)
            local endX = pos.x + math.floor(math.cos(endAngle) * radius)
            local endY = pos.y + math.floor(math.sin(endAngle) * radius)
            
            local light = AttachedEffect.create(3, ThingCategoryEffect)
            light:setDuration(5000)
            light:setOpacity(0.7)
            light:setPulse(85, 115, 1200)
            light:setFade(0, 90, 1000)
            light:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(light)
        end
    end
})

-- 💀 SHADOW ORBIT - Sombras orbitando
AttachedEffectManager.register(304, 'Shadow Orbit', 0, 0, {
    duration = 4000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2
        local numShadows = 6
        
        for i = 0, numShadows - 1 do
            local angle = (360 / numShadows) * i
            local rad = math.rad(angle)
            
            local startX = pos.x + math.floor(math.cos(rad) * radius)
            local startY = pos.y + math.floor(math.sin(rad) * radius)
            
            local endAngle = math.rad(angle + 60)
            local endX = pos.x + math.floor(math.cos(endAngle) * radius)
            local endY = pos.y + math.floor(math.sin(endAngle) * radius)
            
            local shadow = AttachedEffect.create(50, ThingCategoryEffect)
            shadow:setDuration(4000)
            shadow:setOpacity(0.6)
            shadow:setFade(0, 75, 800)
            shadow:setBounce(0, 10, 2000)
            shadow:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(shadow)
        end
    end
})

-- 🌀 DOUBLE ORBIT - Doble órbita (interna y externa)
AttachedEffectManager.register(305, 'Double Orbit', 0, 0, {
    duration = 5000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- Órbita interna (4 missiles)
        local innerRadius = 1.5
        for i = 0, 3 do
            local angle = (360 / 4) * i
            local rad = math.rad(angle)
            
            local startX = pos.x + math.floor(math.cos(rad) * innerRadius)
            local startY = pos.y + math.floor(math.sin(rad) * innerRadius)
            
            local endAngle = math.rad(angle + 90)
            local endX = pos.x + math.floor(math.cos(endAngle) * innerRadius)
            local endY = pos.y + math.floor(math.sin(endAngle) * innerRadius)
            
            local innerMissile = AttachedEffect.create(38, ThingCategoryMissile)
            innerMissile:setDuration(3000)
            innerMissile:setOpacity(0.9)
            innerMissile:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(innerMissile)
        end
        
        -- Órbita externa (8 efectos)
        local outerRadius = 3
        for i = 0, 7 do
            local angle = (360 / 8) * i
            local rad = math.rad(angle)
            
            local startX = pos.x + math.floor(math.cos(rad) * outerRadius)
            local startY = pos.y + math.floor(math.sin(rad) * outerRadius)
            
            local endAngle = math.rad(angle + 45)
            local endX = pos.x + math.floor(math.cos(endAngle) * outerRadius)
            local endY = pos.y + math.floor(math.sin(endAngle) * outerRadius)
            
            local outerEffect = AttachedEffect.create(497, ThingCategoryEffect)
            outerEffect:setDuration(5000)
            outerEffect:setOpacity(0.7)
            outerEffect:setPulse(90, 110, 1500)
            outerEffect:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(outerEffect)
        end
    end
})

-- 💫 SPIRAL ORBIT - Órbita en espiral expandiéndose
AttachedEffectManager.register(306, 'Spiral Orbit', 0, 0, {
    duration = 4000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local numParticles = 12
        
        for i = 0, numParticles - 1 do
            local angle = (360 / numParticles) * i
            local rad = math.rad(angle)
            
            -- Radio inicial pequeño
            local startRadius = 1.5 + (i * 0.1)
            local startX = pos.x + math.floor(math.cos(rad) * startRadius)
            local startY = pos.y + math.floor(math.sin(rad) * startRadius)
            
            -- Radio final más grande
            local endAngle = math.rad(angle + 90)
            local endRadius = 2.5 + (i * 0.1)
            local endX = pos.x + math.floor(math.cos(endAngle) * endRadius)
            local endY = pos.y + math.floor(math.sin(endAngle) * endRadius)
            
            local particle = AttachedEffect.create(497, ThingCategoryEffect)
            particle:setDuration(4000)
            particle:setOpacity(0.6 + (i * 0.02))
            particle:setFade(0, 80, 1000)
            particle:setPulse(80, 120, 1200)
            particle:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(particle)
        end
    end
})

-- ⚔️ BLADE CIRCLE - Círculo de espadas rotando
AttachedEffectManager.register(307, 'Blade Circle', 0, 0, {
    duration = 3500,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2.5
        local numBlades = 8
        
        for i = 0, numBlades - 1 do
            local angle = (360 / numBlades) * i
            local rad = math.rad(angle)
            
            local startX = pos.x + math.floor(math.cos(rad) * radius)
            local startY = pos.y + math.floor(math.sin(rad) * radius)
            
            local endAngle = math.rad(angle + 45)
            local endX = pos.x + math.floor(math.cos(endAngle) * radius)
            local endY = pos.y + math.floor(math.sin(endAngle) * radius)
            
            local blade = AttachedEffect.create(38, ThingCategoryMissile)
            blade:setDuration(3500)
            blade:setDirection(i % 8)
            blade:setOpacity(0.95)
            blade:setBounce(0, 5, 1500)
            blade:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(blade)
        end
    end
})

-- 🌟 COSMIC ORBIT - Órbita cósmica con múltiples capas
AttachedEffectManager.register(308, 'Cosmic Orbit', 0, 0, {
    duration = 6000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        
        -- 3 anillos de diferentes tamaños y velocidades
        local rings = {
            {radius = 1.5, particles = 4, duration = 3000, effectId = 3},
            {radius = 2.5, particles = 6, duration = 4500, effectId = 497},
            {radius = 3.5, particles = 8, duration = 6000, effectId = 590}
        }
        
        for ringIdx, ring in ipairs(rings) do
            for i = 0, ring.particles - 1 do
                local angle = (360 / ring.particles) * i
                local rad = math.rad(angle)
                
                local startX = pos.x + math.floor(math.cos(rad) * ring.radius)
                local startY = pos.y + math.floor(math.sin(rad) * ring.radius)
                
                -- Ángulo de rotación depende del anillo
                local rotationAngle = 60 + (ringIdx * 30)
                local endAngle = math.rad(angle + rotationAngle)
                local endX = pos.x + math.floor(math.cos(endAngle) * ring.radius)
                local endY = pos.y + math.floor(math.sin(endAngle) * ring.radius)
                
                local particle = AttachedEffect.create(ring.effectId, ThingCategoryEffect)
                particle:setDuration(ring.duration)
                particle:setOpacity(0.5 + (ringIdx * 0.15))
                particle:setPulse(85, 115, 1000 + (ringIdx * 200))
                particle:setFade(0, 70 + (ringIdx * 10), 800)
                particle:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
                effect:attachEffect(particle)
            end
        end
    end
})

-- 🌀 REVERSE ORBIT - Órbita en reversa (hacia dentro)
AttachedEffectManager.register(309, 'Reverse Orbit', 0, 0, {
    duration = 4000,
    loop = -1,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local numMissiles = 6
        
        for i = 0, numMissiles - 1 do
            local angle = (360 / numMissiles) * i
            local rad = math.rad(angle)
            
            -- Empieza afuera
            local startRadius = 3
            local startX = pos.x + math.floor(math.cos(rad) * startRadius)
            local startY = pos.y + math.floor(math.sin(rad) * startRadius)
            
            -- Termina cerca del centro (órbita inversa)
            local endAngle = math.rad(angle - 90)
            local endRadius = 1.5
            local endX = pos.x + math.floor(math.cos(endAngle) * endRadius)
            local endY = pos.y + math.floor(math.sin(endAngle) * endRadius)
            
            local missile = AttachedEffect.create(38, ThingCategoryMissile)
            missile:setDuration(4000)
            missile:setDirection((numMissiles - i) % 8)
            missile:setOpacity(0.9)
            missile:setFade(100, 70, 2000)
            missile:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
            effect:attachEffect(missile)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 🌍 EFECTOS ESTILO MUNDO (CIRCULAR CONTINUO) 🌍
-- ═══════════════════════════════════════════════════════════════

-- 🔄 CIRCULAR ORBIT 5 - 5 missiles orbitando 10 segundos (vuelta completa)
AttachedEffectManager.register(310, 'Circular Orbit 5', 0, 0, {
    duration = 10000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2
        local numMissiles = 5
        local segmentDuration = 625  -- Duración de cada segmento (90°)
        local numCycles = 4  -- 4 vueltas completas en 10 segundos
        
        -- Cada missile completa vueltas divididas en 4 segmentos de 90°
        for cycle = 0, numCycles - 1 do
            for segment = 0, 3 do  -- 4 segmentos por vuelta
                for i = 0, numMissiles - 1 do
                    local baseAngle = (360 / numMissiles) * i
                    local startAngle = baseAngle + (segment * 90)
                    local endAngle = startAngle + 90
                    
                    local startRad = math.rad(startAngle)
                    local startX = pos.x + math.floor(math.cos(startRad) * radius)
                    local startY = pos.y + math.floor(math.sin(startRad) * radius)
                    
                    local endRad = math.rad(endAngle)
                    local endX = pos.x + math.floor(math.cos(endRad) * radius)
                    local endY = pos.y + math.floor(math.sin(endRad) * radius)
                    
                    local missile = AttachedEffect.create(38, ThingCategoryMissile)
                    missile:setDuration(segmentDuration)
                    missile:setDirection(i % 8)
                    missile:setOpacity(0.95)
                    missile:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
                    effect:attachEffect(missile)
                end
            end
        end
    end
})

-- 🔄 CIRCULAR ORBIT 6 - 6 missiles orbitando 10 segundos (vuelta completa)
AttachedEffectManager.register(311, 'Circular Orbit 6', 0, 0, {
    duration = 10000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2.5
        local numMissiles = 6
        local segmentDuration = 625
        local numCycles = 4
        
        for cycle = 0, numCycles - 1 do
            for segment = 0, 3 do
                for i = 0, numMissiles - 1 do
                    local baseAngle = (360 / numMissiles) * i
                    local startAngle = baseAngle + (segment * 90)
                    local endAngle = startAngle + 90
                    
                    local startRad = math.rad(startAngle)
                    local startX = pos.x + math.floor(math.cos(startRad) * radius)
                    local startY = pos.y + math.floor(math.sin(startRad) * radius)
                    
                    local endRad = math.rad(endAngle)
                    local endX = pos.x + math.floor(math.cos(endRad) * radius)
                    local endY = pos.y + math.floor(math.sin(endRad) * radius)
                    
                    local missile = AttachedEffect.create(38, ThingCategoryMissile)
                    missile:setDuration(segmentDuration)
                    missile:setDirection(i % 8)
                    missile:setOpacity(0.95)
                    missile:setBounce(0, 5, 1200)
                    missile:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
                    effect:attachEffect(missile)
                end
            end
        end
    end
})

-- 🔄 FAST CIRCULAR ORBIT - Órbita circular rápida (6 segundos, 4 vueltas)
AttachedEffectManager.register(312, 'Fast Circular Orbit', 0, 0, {
    duration = 6000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2
        local numMissiles = 5
        local segmentDuration = 375  -- Más rápido
        local numCycles = 4
        
        for cycle = 0, numCycles - 1 do
            for segment = 0, 3 do
                for i = 0, numMissiles - 1 do
                    local baseAngle = (360 / numMissiles) * i
                    local startAngle = baseAngle + (segment * 90)
                    local endAngle = startAngle + 90
                    
                    local startRad = math.rad(startAngle)
                    local startX = pos.x + math.floor(math.cos(startRad) * radius)
                    local startY = pos.y + math.floor(math.sin(startRad) * radius)
                    
                    local endRad = math.rad(endAngle)
                    local endX = pos.x + math.floor(math.cos(endRad) * radius)
                    local endY = pos.y + math.floor(math.sin(endRad) * radius)
                    
                    local missile = AttachedEffect.create(38, ThingCategoryMissile)
                    missile:setDuration(segmentDuration)
                    missile:setDirection(i % 8)
                    missile:setOpacity(0.9)
                    missile:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
                    effect:attachEffect(missile)
                end
            end
        end
    end
})

-- 🔄 SLOW CIRCULAR ORBIT - Órbita circular lenta (15 segundos, 4 vueltas)
AttachedEffectManager.register(313, 'Slow Circular Orbit', 0, 0, {
    duration = 15000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2.5
        local numMissiles = 6
        local segmentDuration = 937  -- Más lento
        local numCycles = 4
        
        for cycle = 0, numCycles - 1 do
            for segment = 0, 3 do
                for i = 0, numMissiles - 1 do
                    local baseAngle = (360 / numMissiles) * i
                    local startAngle = baseAngle + (segment * 90)
                    local endAngle = startAngle + 90
                    
                    local startRad = math.rad(startAngle)
                    local startX = pos.x + math.floor(math.cos(startRad) * radius)
                    local startY = pos.y + math.floor(math.sin(startRad) * radius)
                    
                    local endRad = math.rad(endAngle)
                    local endX = pos.x + math.floor(math.cos(endRad) * radius)
                    local endY = pos.y + math.floor(math.sin(endRad) * radius)
                    
                    local missile = AttachedEffect.create(38, ThingCategoryMissile)
                    missile:setDuration(segmentDuration)
                    missile:setDirection(i % 8)
                    missile:setOpacity(0.85)
                    missile:setPulse(90, 110, 1500)
                    missile:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
                    effect:attachEffect(missile)
                end
            end
        end
    end
})

-- 🔥 FIRE CIRCULAR ORBIT - Órbita de fuego 10 segundos (4 vueltas)
AttachedEffectManager.register(314, 'Fire Circular Orbit', 0, 0, {
    duration = 10000,
    permanent = false,
    
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local radius = 2
        local numOrbs = 6
        local segmentDuration = 625
        local numCycles = 4
        
        for cycle = 0, numCycles - 1 do
            for segment = 0, 3 do
                for i = 0, numOrbs - 1 do
                    local baseAngle = (360 / numOrbs) * i
                    local startAngle = baseAngle + (segment * 90)
                    local endAngle = startAngle + 90
                    
                    local startRad = math.rad(startAngle)
                    local startX = pos.x + math.floor(math.cos(startRad) * radius)
                    local startY = pos.y + math.floor(math.sin(startRad) * radius)
                    
                    local endRad = math.rad(endAngle)
                    local endX = pos.x + math.floor(math.cos(endRad) * radius)
                    local endY = pos.y + math.floor(math.sin(endRad) * radius)
                    
                    local fireOrb = AttachedEffect.create(885, ThingCategoryEffect)
                    fireOrb:setDuration(segmentDuration)
                    fireOrb:setOpacity(0.8)
                    fireOrb:setPulse(20, 35, 1000)
                    fireOrb:move({x = startX, y = startY, z = pos.z}, {x = endX, y = endY, z = pos.z})
                    effect:attachEffect(fireOrb)
                end
            end
        end
    end
})

AttachedEffectManager.register(315, 'executioner', 218, ThingCategoryEffect, {
    loop = 2,
    speed = 1,
    offset = { 0, 0, true },
})

AttachedEffectManager.register(316, 'water elemental', 241, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    opacity = 0.8,
    offset = { 0, 0, true },
    onAttach = function(effect, owner)
        owner:setShader('magnetic')
    end,
    onDetach = function(effect, oldOwner)
        if oldOwner and oldOwner:getTile() then
            oldOwner:setShader('Outfit - Default')
        end
    end
})

AttachedEffectManager.register(317, 'phoenix reborn 1', 859, ThingCategoryEffect, {
    loop = 1,
    speed = 0.5,
    offset = { -100, -111, false },
    onAttach = function(effect, owner)
        owner:setShader('Lava')
    end,
    onDetach = function(effect, oldOwner)
        if oldOwner and oldOwner:getTile() then
            oldOwner:setShader('Outfit - Default')
        end
    end
})

AttachedEffectManager.register(318, 'phoenix reborn 2', 893, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -64, -48, true },
})

AttachedEffectManager.register(319, 'soul leech', 1069, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    opacity = 0.8,
    offset = { -32, -28, false },
})

AttachedEffectManager.register(320, 'goliath heal', 977, ThingCategoryEffect, {
    loop = 1,
    speed = 1.8,
    offset = { -20, -5, true },
    onAttach = function(effect, owner)
        owner:setShader('Red Glow')
    end,
    onDetach = function(effect, oldOwner)
        if oldOwner and oldOwner:getTile() then
            oldOwner:setShader('Outfit - Default')
        end
    end
})

AttachedEffectManager.register(321, 'falcon aura slow', 885 , ThingCategoryEffect, {
    duration = 700,
    opacity = 0.85,
    speed = 1.9,
    offset = { -64, -64, false}, 
})

AttachedEffectManager.register(322, 'obelisk', 876 , ThingCategoryEffect, {
    opacity = 0.85,
    speed = 1.3,
    offset = { -32, -32, false}, 
})

AttachedEffectManager.register(323, 'obelisk', 921 , ThingCategoryEffect, {
    loop = 1,
    opacity = 0.85,
    speed = 0.7,
    offset = { -32, -32, false}, 
})

AttachedEffectManager.register(324, 'the hydra', 910, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -27, -20, true},
})

AttachedEffectManager.register(325, 'hammersword', 1167, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -24, -24, false},
    pulse = {32, 64, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(326, 'mechagolem', 794, ThingCategoryEffect, {
    opacity = 1,
    duration = 1000,
    loop = 1,
    speed = 1,
    offset = { 5, 5, true},
    pulse = {15, 20, 500},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(327, 'final symphony', 1167, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    shader = "Golden",
    offset = { -24, -24, false},
    pulse = {32, 64, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(328, 'slime', 283, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    opacity = 0.8,
    offset = { 0, 0, false },
    onAttach = function(effect, owner)
        owner:setShader('slime')
    end,
    onDetach = function(effect, oldOwner)
        if oldOwner and oldOwner:getTile() then
            oldOwner:setShader('Outfit - Default')
        end
    end
})

AttachedEffectManager.register(329, 'the dragon (north)', 1186, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -85, 32, false},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(330, 'the dragon (south)', 1184, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -90, -110, true},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(331, 'the dragon (izquierda)', 1187, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { 5, -95, false},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(332, 'the dragon (derecha)', 1185, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -115, -90, true},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(333, 'archangel smite', 1004, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -55, -14, true},
    
})

AttachedEffectManager.register(334, 'frost dragon', 934, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1.6,
    offset = { -35, -20, true},
    
})

AttachedEffectManager.register(335, 'blossom dragon 1', 1168, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -60, -60, false},
    
})

AttachedEffectManager.register(336, 'blossom dragon 3', 1142, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 0.9,
    offset = { -90, -90, true},
    
})

AttachedEffectManager.register(337, 'blossom dragon 2', 1141, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1.4,
    offset = { -20, 0, true},
})

AttachedEffectManager.register(338, 'scorpion', 1126, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1.4,
    offset = { -55, -80, true},
    pulse = {0, 1, 1200},
})

AttachedEffectManager.register(339, 'viper', 1188, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 0.9,
    shader = "Corrupted",
    offset = { 5, 5, true},
    pulse = {32, 55, 500},
})


AttachedEffectManager.register(340, 'zeus', 1169, ThingCategoryEffect, {

    duration = 1200,
    disableWalkAnimation = true,
    offset = { -32, -32, false},
    pulse = {1, 10, 5000},

    onAttach = function(effect, owner)
        owner:setBounce(40, 45, 2200)
        --effect:setBounce(0, 120, 2200)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setBounce(0, 0)
    end
})

AttachedEffectManager.register(341, 'Svarog 1', 1061, ThingCategoryEffect, {
    opacity = 1,
    speed = 0.9,
    duration = 10000,
    --shader = "Corrupted",
    offset = { -26, -26, false},
    --pulse = {32, 55, 500},
     onAttach = function(effect, owner)
        safeAddTileEffect(owner, 590)
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 590)
    end
})
AttachedEffectManager.register(342, 'Svarog 2', 1061, ThingCategoryEffect, {
    opacity = 0.4,
    speed = 0.9,
    duration = 10000,
    --shader = "Corrupted",
    offset = { -26, -26, true},
    --pulse = {32, 55, 500},
})


AttachedEffectManager.register(343, 'veles (north)', 822, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { 10, 32, false},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})
AttachedEffectManager.register(344, 'veles (north)', 822, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -30, 32, false},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(345, 'veles (south)', 823, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { 10, -100, true},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(346, 'veles (south)', 823, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -30, -110, true},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(347, 'veles (izquierda)', 824, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { 5, -45, false},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(348, 'veles (derecha)', 821, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -115, -45, true},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(349, 'yacy heal', 1039, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -64, -64, false},
    --pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(350, 'yacy damage', 1035, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -64, -64, false},
   -- pulse = {2, 5, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(351, 'Transform', 298, ThingCategoryCreature, {
    transform = true,
    duration = 1000,
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 27)
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 338)
    end
})

AttachedEffectManager.register(352, 'trex-stomp', 936, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -25, -25, true},
    pulse = {10, 12, 1200},  -- Pulsa de 85% a 120% cada 1.2 segundos
})

AttachedEffectManager.register(353, 'trex-stomp 2', 1168, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -60, -60, false},
    
})

AttachedEffectManager.register(354, 'raiju damage', 962, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -60, -64, true},
    pulse = {1, 4, 1200},
    onAttach = function(effect, owner)
        owner:setShader('Blackout')
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setShader('Outfit - Default')
    end

    
})

AttachedEffectManager.register(355, 'fairy sparkles', 186, ThingCategoryEffect, {
    opacity = 0.8,
    duration = 8000,
    speed = 1.2,
    offset = { -15, 15, true},
})

AttachedEffectManager.register(356, 'fairy wind', 185, ThingCategoryEffect, {
    opacity = 0.9,
    speed = 0.5,
    offset = { 10, 10, true},
})

AttachedEffectManager.register(357, 'fairy pink aura', 184, ThingCategoryEffect, {
    speed = 1.5,
    disableWalkAnimation = true,
    shader = 'Rainbow',
    offset = { -10, -7, false},
    onAttach = function(effect, owner)
        owner:setBounce(0, 10, 1000)
        owner:setShader('Rainbow')
        effect:setBounce(0, 2, 500)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setBounce(0, 0)
        oldOwner:setShader('Outfit - Default')
    end
})

AttachedEffectManager.register(358, 'the pulse', 875 , ThingCategoryEffect, {
    opacity = 0.85,
    speed = 1.3,
    shader = "Golden",
    offset = { -32, -32, false}, 
})

AttachedEffectManager.register(359, 'leviathan', 240 , ThingCategoryEffect, {
    loop = 1,
    opacity = 0.85,
    speed = 0.85,
    offset = { -25, -25, true}, 
})

AttachedEffectManager.register(360, 'the necromancer', 301, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    onAttach = function(effect, owner)
        if not owner then return end
        owner:setShader('Ghost')
        safeAddTileEffect(owner, 7)
    end,
})

AttachedEffectManager.register(361, 'sniper', 1171, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -23, -15, true},
    
})  

AttachedEffectManager.register(362, 'sniper 2', 992, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -50, -22, true},
    
})  

-- Card 99: Fire Circus - 5 Orbital Fire Rings (con rotación real)
AttachedEffectManager.register(363, 'Fire Circus', 0, 0, {
    duration = 6000,
    permanent = false,
    onAttach = function(effect, owner)
        local pos = owner:getPosition()
        local spriteSize = g_gameConfig.getSpriteSize()
        local radius = 2  -- 2 tiles de radio
        
        -- 12 posiciones orbitales
        local orbitalPositions = {
            {0, -2},  {1, -2},  {2, -1},  {2,  0},
            {2,  1},  {1,  2},  {0,  2},  {-1, 2},
            {-2, 1},  {-2, 0},  {-2, -1}, {-1, -2}
        }
        
        -- 5 anillos con diferentes offsets iniciales
        local ringOffsets = {0, 2, 5, 7, 10}
        
        -- Crear rotación continua usando move() con loop
        -- Cada missile recorre un segmento y lo repite con loop
        for ringIndex, ringOffset in ipairs(ringOffsets) do
            -- Crear 12 segmentos de movimiento (puntos del círculo)
            for i = 1, #orbitalPositions do
                local currentIdx = ((i - 1 + ringOffset) % #orbitalPositions) + 1
                local nextIdx = (currentIdx % #orbitalPositions) + 1
                
                local fromOffset = orbitalPositions[currentIdx]
                local toOffset = orbitalPositions[nextIdx]
                
                -- Posiciones absolutas para el movimiento
                local fromPos = {
                    x = pos.x + fromOffset[1],
                    y = pos.y + fromOffset[2],
                    z = pos.z
                }
                local toPos = {
                    x = pos.x + toOffset[1],
                    y = pos.y + toOffset[2],
                    z = pos.z
                }
                
                -- Crear missile con movimiento
                local missile = AttachedEffect.create(178, ThingCategoryMissile)
                missile:setOpacity(0.85)
                missile:setLoop(60)  -- Repetir 60 veces (~6 segundos)
                missile:move(fromPos, toPos)
                
                effect:attachEffect(missile)
            end
        end
        
        -- Efecto visual en el suelo (estático)
        local groundRing = AttachedEffect.create(760, ThingCategoryEffect)
        groundRing:setDuration(6000)
        groundRing:setOffset(-spriteSize, -spriteSize, false)
        groundRing:setOpacity(0.7)
        effect:attachEffect(groundRing)
        
        -- Llamarada central al activar
        local centerFlare = AttachedEffect.create(36, ThingCategoryEffect)
        centerFlare:setDuration(800)
        centerFlare:setOffset(0, 0, true)
        effect:attachEffect(centerFlare)
    end
})

AttachedEffectManager.register(364, 'guns lover', 805, ThingCategoryEffect, {--941
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -32, -32, true},
    
})  

AttachedEffectManager.register(365, 'Transform clown', 273, ThingCategoryCreature, {
    transform = true,
    --duration = 5000,
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(366, 'Transform balloon', 2929, ThingCategoryCreature, {
    transform = true,
    --duration = 5000,
    onAttach = function(effect, owner)
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        safeAddTileEffect(oldOwner, 50)
    end
})

AttachedEffectManager.register(367, 'back to ashes', 917, ThingCategoryEffect, {
    opacity = 0.7,
    speed = 1,
    offset = { -50, -34, true},
})

AttachedEffectManager.register(368, 'Codex Infusion', 2950, ThingCategoryCreature, {
    opacity = 0.85,
    speed = 1,
    offset = { -50, -35, true},
})

AttachedEffectManager.register(369, 'Fame Infusion', 2951, ThingCategoryCreature, {

    opacity = 1,
    speed = 1,
    offset = { -35, -35, true},
})

AttachedEffectManager.register(370, 'Shadow Swords', 2954, ThingCategoryCreature, {

    opacity = 1,
    speed = 1,
    offset = { -53, -50, false},
})

AttachedEffectManager.register(371, 'Void World', 958, ThingCategoryEffect, {
    opacity = 1,
    speed = 1,
    offset = { -64, -64, false},
})

AttachedEffectManager.register(372, 'Sparks', 959, ThingCategoryEffect, {
    opacity = 0.85,
    speed = 1,
    offset = { -20, -32, true},
})

AttachedEffectManager.register(373, 'cursed', 963, ThingCategoryEffect, {

    opacity = 1,
    speed = 1,
    offset = { -64, -64, false},
})

AttachedEffectManager.register(374, 'Mana flow', 982, ThingCategoryEffect, {

    opacity = 1,
    speed = 1,
    offset = { -64, -32, false},
})


AttachedEffectManager.register(375, 'Guardian Wings', 2912, ThingCategoryCreature, {
    speed = 1,

    disableWalkAnimation = false,
    dirOffset = {
        [North] = { 0, -10, true }, 
        [East] = { 0, 0 }, --derecha
        [South] = { 0, -3 },
        [West] = { -5, -5, true } --izquierda
    },
})

AttachedEffectManager.register(376, 'Frozen Wings', 2913, ThingCategoryCreature, {
    speed = 1,

    disableWalkAnimation = false,
    dirOffset = {
        [North] = { 0, -10, true }, 
        [East] = { 0, 0 }, --derecha
        [South] = { 0, -3 },
        [West] = { -5, -5, true } --izquierda
    },
})

AttachedEffectManager.register(377, 'Emerald Wings', 2914, ThingCategoryCreature, {
    speed = 1,

    disableWalkAnimation = false,
    dirOffset = {
        [North] = { 0, -10, true }, 
        [East] = { 0, 0 }, --derecha
        [South] = { 0, -3 },
        [West] = { -5, -5, true } --izquierda
    },
})

AttachedEffectManager.register(378, 'Crystal Wings', 2915, ThingCategoryCreature, {
    speed = 1,

    disableWalkAnimation = false,
    dirOffset = {
        [North] = { 0, -10, true }, 
        [East] = { 0, 0 }, --derecha
        [South] = { 0, -3 },
        [West] = { -5, -5, true } --izquierda
    },
})

AttachedEffectManager.register(379, 'Ruby Wings', 2916, ThingCategoryCreature, {
    speed = 1,

    disableWalkAnimation = false,
    dirOffset = {
        [North] = { 0, -10, true }, 
        [East] = { 0, 0 }, --derecha
        [South] = { 0, -3 },
        [West] = { -5, -5, true } --izquierda
    },
})

AttachedEffectManager.register(380, 'Infernal Wings', 2917, ThingCategoryCreature, {
    speed = 1,

    disableWalkAnimation = false,
    dirOffset = {
        [North] = { -5, -10, true }, 
        [East] = { -10, -10 }, --derecha
        [South] = { -10, -10 },
        [West] = { -5, -5, true } --izquierda
    },
})

AttachedEffectManager.register(381, 'Halo', 2939, ThingCategoryCreature, {
    speed = 1,

    disableWalkAnimation = false,
    dirOffset = {
        [North] = { -2, 0, true }, 
        [East] = { -2, -2 }, --derecha
        [South] = { -8, 0 },
        [West] = { -5, -7, true } --izquierda
    },
})

AttachedEffectManager.register(382, 'party balloons', 2929, ThingCategoryCreature, {
    speed = 1,

    disableWalkAnimation = false,
    dirOffset = {
        [North] = { 0, 0, true }, 
        [East] = { 0, 0 }, --derecha
        [South] = { 0, 0 },
        [West] = { 0, 0, true } --izquierda
    },
})

AttachedEffectManager.register(383, 'Dark Wings', 2320, ThingCategoryCreature, {
    speed = 1,

    disableWalkAnimation = false,
    dirOffset = {
        [North] = { 0, -10, true }, 
        [East] = { 0, 0 }, --derecha
        [South] = { -6, -3 },
        [West] = { -5, -5, true } --izquierda
    },
})

AttachedEffectManager.register(384, 'might Aura', '/images/game/effects/red_spin', ThingExternalTexture, {

    size = { 68, 68 },
    offset = { 13, 8, false }
})

AttachedEffectManager.register(385, 'disco ball', '/images/game/effects/disco_ball', ThingExternalTexture, {

    speed = 0.7,
    size = { 40, 40 },
    offset = { 32, 32, true },
    --shader = 'Rainbow',
})

AttachedEffectManager.register(386, 'black arrows', '/images/game/effects/arrows_black', ThingExternalTexture, {

    size = { 90, 90 },
    offset = { 30, 30, false }
})

AttachedEffectManager.register(387, 'green circle', '/images/game/effects/green', ThingExternalTexture, {

    size = { 90, 90 },
    offset = { 30, 30, false }
})

AttachedEffectManager.register(388, 'Spin effect', '/images/game/effects/purple_sharingan', ThingExternalTexture, {

    speed = 0.45,
    size = { 90, 90 },
    offset = { 30, 30, false }
})

AttachedEffectManager.register(389, 'purple square', '/images/game/effects/purplesquare', ThingExternalTexture, {

    size = { 55, 55 },
    offset = { 5, 5, false }
})

AttachedEffectManager.register(390, 'red circle', '/images/game/effects/red_circle', ThingExternalTexture, {

    size = { 90, 90 },
    offset = { 22, 21, false }
})

AttachedEffectManager.register(391, 'black arrows', '/images/game/effects/arrows_black', ThingExternalTexture, {

    size = { 90, 90 },
    shader = "Outfit - Rainbow",
    offset = { 30, 30, false }
})

AttachedEffectManager.register(392, 'overcharged', 2160, ThingCategoryCreature, {
    opacity = 1,
    speed = 1,
    offset = { 0, 0, true},
})

AttachedEffectManager.register(393, 'racing match outfit', 2186, ThingCategoryCreature, {
    transform = true,
    duration = 2000,

})

AttachedEffectManager.register(394, 'racing match outfit', 2204, ThingCategoryCreature, {
    transform = true,
    duration = 2000,

    shader = 'Outfit - Rainbow',
    dirOffset = {
        [North] = { -5, -20, true },
        [East] = { -20, -5 },
        [South] = { -10, -20 },
        [West] = { -20, -5, true }
    },

})

AttachedEffectManager.register(395, 'pomelo explosion', 1132, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1.0,
    offset = { -128, -128, true},
})

AttachedEffectManager.register(396, 'stuned', 32, ThingCategoryEffect, {
    opacity = 1,
    duration = 5000,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(397, 'marked charge', 56, ThingCategoryEffect, {
    opacity = 1,
    duration = 5000,
    speed = 1,
    offset = { 22, 22, true},
    
})

AttachedEffectManager.register(398, 'Growing Rage', 590, ThingCategoryEffect, {

    onAttach = function(effect, owner)
        
        owner:setScaleFactor(1.5, 650)
        owner:setShader('Monster Might')
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        oldOwner:setShader('Outfit - Default')
    end
})

AttachedEffectManager.register(399, 'Shadow Empower', 791, ThingCategoryEffect, {
    onAttach = function(effect, owner)
        owner:setShader('Galaxy')  -- o el shader morado que tengas
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setShader('Outfit - Default')
    end
})

AttachedEffectManager.register(400, 'parasite', 1013, ThingCategoryEffect, {
    opacity = 1,
    duration = 7000,
    speed = 1,
    offset = { -64, -64, false},
    
})

AttachedEffectManager.register(401, 'parasite', 899, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 1,
    offset = { -55, -32, true},
    
})

-- =============================================================
-- Vulcanys, The Forge Tyrant - Boss Phase Scales (Pyrotheca)
-- =============================================================

AttachedEffectManager.register(600, 'Vulcanys Phase 1', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.0, 500)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
    end
})

AttachedEffectManager.register(601, 'Vulcanys Phase 2', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.4, 800)
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
    end
})

AttachedEffectManager.register(602, 'Vulcanys Phase 3', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.8, 800)
        owner:setShader('Red Flames')
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        oldOwner:setShader('Outfit - Default')
    end
})

AttachedEffectManager.register(603, 'Vulcanys Phase 4', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(2.3, 1000)
        owner:setShader('Red Flames')
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        oldOwner:setShader('Outfit - Default')
    end
})

AttachedEffectManager.register(604, 'Vulcanys Phase 5 (Enrage)', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(3.0, 1200)
        owner:setShader('Red Flames')
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        oldOwner:setShader('Outfit - Default')
    end
})

AttachedEffectManager.register(605, 'Vulcanys Chain Seal', 1227, ThingCategoryEffect, {
    duration = 5000,
    speed = 1,
    offset = { 0, -16, true }
})

-- =============================================================
-- Drakkomir, the Blackstone Chieftain - Boss Phases (Blackstone Depths)
-- =============================================================

AttachedEffectManager.register(610, 'Drakkomir Empowered (Phase 2)', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.3, 800)
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
    end
})

AttachedEffectManager.register(611, 'Drakkomir Enrage (Phase 3)', 0, 0, {
    permanent = true,
    onAttach = function(effect, owner)
        owner:setScaleFactor(1.6, 1000)
        owner:setShader('Blueveins')
        safeAddTileEffect(owner, 7)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setScaleFactor(1.0, 500)
        oldOwner:setShader('Outfit - Default')
    end
})

AttachedEffectManager.register(612, 'blade tempest', 864, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -64, -64, false },
  --  shader = 'Blueveins',
})

AttachedEffectManager.register(613, 'crimson lotus', 1142, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 0.9,
    offset = { -90, -90, true},
    shader = 'Ashes',
    
})

AttachedEffectManager.register(614, 'triple slash', 1106, ThingCategoryEffect, {
    loop = 1,
    speed = 1,
    offset = { -64, -32, false }
})

AttachedEffectManager.register(615, 'crinsom sigil', 900 , ThingCategoryEffect, {
    duration = 12000,
    opacity = 0.85,
    speed = 1.3,
    offset = { -64, -64, false}, 
    shader = 'Fire Spiral',
})

AttachedEffectManager.register(616, 'crimson threads', 0, 0, {
    duration = 4000,
    lineMode = true,
    lineColor = { r = 180, g = 20, b = 20, a = 255 },
    lineWidth = 3,
    fade = { 0, 100, 2000 },
    onTop = true,
})

-- =============================================================
-- Bard Class Effects
-- =============================================================

AttachedEffectManager.register(620, 'Dark Crescendo Aura', 0, 0, {
    duration = 5000,
    opacity = 1.0,
    speed = 0.8,
   -- shader = 'Fire Spiral',
    onAttach = function(effect, owner)
        owner:setPulse(0, 15, 800)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setPulse(0, 0)
    end
})

AttachedEffectManager.register(621, 'Grand Finale Aura', 0, 0, {
    duration = 2000,
    opacity = 1.0,
    speed = 1.0,
   -- shader = 'Outfit - Rainbow',
    onAttach = function(effect, owner)
        owner:setPulse(0, 20, 400)
        owner:setBounce(0, 12, 600)
    end,
    onDetach = function(effect, oldOwner)
        oldOwner:setPulse(0, 0)
        oldOwner:setBounce(0, 0)
    end
})
--1307 tambien podriamos usarlo
AttachedEffectManager.register(630, 'Sonic Pulse', 876, ThingCategoryEffect, {
    duration = 800,
    opacity = 1.0,
    speed = 2.0,
    size = { 64, 64 },
    offset = { 0, 0, true },
    pulse = { 0, 30, 400 },
    fade = { 0, 100, 600 },
    onTop = true,
})

AttachedEffectManager.register(631, 'Dissonant Strike', 1088, ThingCategoryEffect, {
    duration = 1000,
    opacity = 1.0,
    speed = 1.5,
    size = { 80, 80 },
    offset = { 0, 0, true },
    pulse = { 0, 25, 300 },
    bounce = { 0, 15, 500 },
    onTop = true,
})

AttachedEffectManager.register(632, 'Echoing Wave', 1167, ThingCategoryEffect, {
    duration = 600,
    opacity = 1.0,
    speed = 1.8,
    size = { 64, 64 },
    offset = { 0, 0, true },
    pulse = { 0, 20, 300 },
    fade = { 0, 100, 400 },
    onTop = true,
})

AttachedEffectManager.register(633, 'Healing Melody', 1320, ThingCategoryEffect, {
    loop =1,
    opacity = 1.0,
    speed = 1.0,
    offset = { 0, 0, true },
    onTop = true,
    onAttach = function(effect, owner)
        local inner = AttachedEffect.create(1171, ThingCategoryEffect)
        inner:setDuration(effect:getDuration())
        inner:setOffset(0, 0)
        inner:setOpacity(0.8)
        effect:attachEffect(inner)
    end,
})

AttachedEffectManager.register(634, 'broken floor', 1321, ThingCategoryEffect, {
    opacity = 1,
    loop = 1,
    speed = 0.9,
    offset = { -64, -64, true},
    shader = 'Zaphire',
    
})

-- 32x32 escala a 64x64
AttachedEffectManager.register(635, 'Ice Lance Distance', 106, ThingCategoryMissile, {
    distanceMode = true,
    loop = 1,
    size = { 96, 96 },
    opacity = 1.0,
    offset = { 0, 25, true },
    onTop = true,
})

-- 32x32 escala a 64x64
AttachedEffectManager.register(700, 'Ice Lance Distance', 38, ThingCategoryMissile, {
    distanceMode = true,
    loop = 1,
    size = { 64, 64 },
    opacity = 1.0,
    offset = { 0, 0, true },
    onTop = true,
})
 
-- Attached effect normal con sprite escalado
AttachedEffectManager.register(701, 'Big Aura', 605, ThingCategoryEffect, {
    size = { 96, 96 },
    opacity = 0.8,
    onTop = true,
})


-- =========================================================
-- Melody Auras (640-644)
-- Orbiting particle effects for each Bard melody
-- =========================================================

local orbitEvents = {}

local function createOrbitAura(id, name, spriteId, config)
    AttachedEffectManager.register(id, name, spriteId, ThingCategoryEffect, {
        opacity = config.opacity or 0.8,
        speed = 1.0,
        size = { config.size or 32, config.size or 32 },
        offset = { 0, 0, true },
        onTop = true,
        onAttach = function(effect, owner)
            local radius = config.radius or 30
            local orbitSpeed = config.orbitSpeed or 360
            local orbCount = config.orbs or 1
            local tickMs = config.tickMs or 30
            local key = tostring(effect)

            local orbs = {}
            if orbCount == 1 then
                orbs[1] = effect
            else
                for i = 1, orbCount do
                    local orb = AttachedEffect.create(spriteId, ThingCategoryEffect)
                    orb:setDuration(effect:getDuration())
                    orb:setOpacity(config.opacity or 0.7)
                    orb:setSize({ width = config.size or 24, height = config.size or 24 })
                    orb:setOnTop(true)
                    orbs[i] = { effect = orb, baseAngle = (360 / orbCount) * (i - 1) }
                    effect:attachEffect(orb)
                end
            end

            local angle = 0
            local function orbit()
                angle = angle + (orbitSpeed * tickMs / 1000)
                if angle >= 360 then angle = angle - 360 end
                for i, orb in ipairs(orbs) do
                    local baseAngle = (orbCount == 1) and 0 or orb.baseAngle
                    local a = math.rad(angle + baseAngle)
                    local x = math.floor(math.cos(a) * radius + 0.5)
                    local y = math.floor(math.sin(a) * radius + 0.5)
                    if orbCount == 1 then
                        orb:setOffset(x, y)
                    else
                        orb.effect:setOffset(x, y)
                    end
                end
            end

            orbit()
            orbitEvents[key] = cycleEvent(orbit, tickMs)
        end,
        onDetach = function(effect, oldOwner)
            local key = tostring(effect)
            if orbitEvents[key] then
                orbitEvents[key]:cancel()
                orbitEvents[key] = nil
            end
        end,
    })
end

-- 640: Cheerful Melody - 1 orb, green, slow & wide
createOrbitAura(640, 'Cheerful Melody Aura', 19, {
    radius = 32, orbitSpeed = 180, orbs = 1, size = 32, opacity = 0.98, tickMs = 30,
})

-- 641: Pensive Melody - 2 orbs, blue, medium
createOrbitAura(641, 'Pensive Melody Aura', 24, {
    radius = 28, orbitSpeed = 240, orbs = 2, size = 28, opacity = 0.98, tickMs = 30,
})

-- 642: Menacing Melody - 3 orbs, red, fast & tight
createOrbitAura(642, 'Menacing Melody Aura', 20, {
    radius = 35, orbitSpeed = 420, orbs = 3, size = 24, opacity = 0.98, tickMs = 30,
})

-- 643: Cathartic Melody - 2 orbs, dark, slow pulse
createOrbitAura(643, 'Cathartic Melody Aura', 23, {
    radius = 30, orbitSpeed = 200, orbs = 2, size = 30, opacity = 0.98, tickMs = 30,
})

-- 644: Epic Melody - 1 orb, bright, fast
createOrbitAura(644, 'Epic Melody Aura', 22, {
    radius = 38, orbitSpeed = 540, orbs = 1, size = 32, opacity = 0.98, tickMs = 30,
})

-- =============================================================
-- Grand Finale Effects
-- =============================================================

-- 1118: Apocalypse Crescendo - damage burst on enemies
AttachedEffectManager.register(645, 'Apocalypse Crescendo Hit', 1118, ThingCategoryEffect, {
    loop = 1,
    opacity = 1.0,
    speed = 0.8,
    size = { 0, 0 },
    offset = { -50, -28, true },
    onTop = true,
})

-- 1244: Elysian Symphony effect 1 on allies
AttachedEffectManager.register(646, 'Elysian Symphony Aura 1', 1244, ThingCategoryEffect, {
    loop = 1,
    opacity = 1.0,
    speed = 1.0,
    size = { 48, 48 },
    offset = { 0, 0, true },
    onTop = true,
})

-- 1247: Elysian Symphony effect 2 on allies
AttachedEffectManager.register(647, 'Elysian Symphony Aura 2', 1247, ThingCategoryEffect, {
    loop = 1,
    opacity = 1.0,
    speed = 1.0,
    size = { 48, 48 },
    offset = { 0, 0, true },
    onTop = true,
})

-- 1118: Apocalypse Crescendo - damage burst on enemies
AttachedEffectManager.register(648, 'Apocalypse Crescendo AURA', 989, ThingCategoryEffect, {
    loop = 1,
    opacity = 1.0,
    speed = 0.8,
    size = { 0, 0 },
    offset = { -64, -64, false },
   -- onTop = true,
})

-- =============================================================
-- Warden Elemental Mark Auras
-- =============================================================

AttachedEffectManager.register(659, 'Warden Earth Aura', 1314, ThingCategoryEffect, {
    shader = 'Outfit - Warden Earth Aura',
    opacity = 0.7,
    speed = 0.7,
    offset = { -18, -20, true }
})

AttachedEffectManager.register(660, 'Warden Frost Aura', 1314, ThingCategoryEffect, {
    shader = 'Outfit - Warden Frost Aura',
    opacity = 0.7,
    speed = 0.7,
    offset = { -18, -20, true }
})

-- =============================================================
-- Distance effects (travel from caster to each target)
-- Sent from the server with: creature:attachDistanceEffectWithTargets(effectId, {targetId1, targetId2, ...})
-- =============================================================
AttachedEffectManager.register(700, 'Ice Lance Distance', 38, ThingCategoryMissile, {
    distanceMode = true,
    -- duration = 400,         -- optional: ms per shot; if 0 it is computed from the farthest distance
    loop = 1,                 -- number of shots per target (-1 = infinite)
    size = { 64, 64 },        -- scales the sprite to 64x64 pixels
    opacity = 1.0,
    offset = { 0, 0, true },  -- x, y, onTop
    onTop = true,
    -- pulse = { 0, 15, 300 },
    -- fade = { 0, 100, 400 },
    -- shader = 'Red Glow',
})

