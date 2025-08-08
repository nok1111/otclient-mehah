--[[
    register(id, name, thingId, thingType, config)
    config = {
        speed, disableWalkAnimation, shader, drawOnUI, opacity
        duration, loop, transform, hideOwner, size{width, height}
        offset{x, y, onTop}, dirOffset[dir]{x, y, onTop},
        light { color, intensity}, drawOrder(only for tiles),
        bounce{minHeight, height, speed},
        pulse{minHeight, height, speed},
        fade{start, end, speed}

        onAttach, onDetach
    }
]]
--
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
        local e = Effect.create()
        e:setId(7)
        owner:getTile():addThing(e)
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(50)
        oldOwner:getTile():addThing(e)
    end
})

AttachedEffectManager.register(6, 'Lake Monster', 34, ThingCategoryEffect, {
    speed = 5,
    transform = true,
    hideOwner = true,
    duration = 1500,
    -- loop = 1,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(54)
        oldOwner:getTile():addThing(e)
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
        local e = Effect.create()
        e:setId(50)
        oldOwner:getTile():addThing(e)
    end
})

AttachedEffectManager.register(11, 'Bat', 307, ThingCategoryCreature, {
    speed = 0.5,
    offset = { 0, 0 },
    bounce = { 20, 20, 2000 }
})

AttachedEffectManager.register(12, 'stun jump', 32, ThingCategoryEffect, {

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

AttachedEffectManager.register(13, 'travel form', 217, ThingCategoryCreature, {
    hideOwner = true,
    duration = 15000,
    speed = 1,
    offset = { 0, 0 },
    bounce = { 10, 20, 11000 },
    onAttach = function(effect, owner)
        local e = Effect.create()
        e:setId(647)
        owner:getTile():addThing(e)
        
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(647)
        oldOwner:getTile():addThing(e)
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
        local e = Effect.create()
        e:setId(353)
        owner:getTile():addThing(e)
        
        
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(353)
        oldOwner:getTile():addThing(e)
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
    duration = 15000,
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
        local e = Effect.create()
        e:setId(662)
        owner:getTile():addThing(e)
        
        
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(662)
        oldOwner:getTile():addThing(e)
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
        local e = Effect.create()
        e:setId(647)
        owner:getTile():addThing(e)
        
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(647)
        oldOwner:getTile():addThing(e)
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
    offset = { 0, 0 }
})

AttachedEffectManager.register(64, 'fear', 170, ThingCategoryEffect, {
    loop = 1,
    offset = { 0, 0 }
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
        local e = Effect.create()
        e:setId(497)
        owner:getTile():addThing(e)
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(497)
        oldOwner:getTile():addThing(e)
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
        local e = Effect.create()
        e:setId(841)
        owner:getTile():addThing(e)
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(841)
        oldOwner:getTile():addThing(e)
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
    duration = 3000,
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
    duration = 5000,
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
    duration = 5000,
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
        local e = Effect.create()
        e:setId(7)
        oldOwner:getTile():addThing(e)
    end
})

AttachedEffectManager.register(98, 'zen sphere', 837, ThingCategoryEffect, {
    speed = 1,
    opacity = 0.7,
    duration = 8000,
    offset = { -10, -10, true },
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(54)
        oldOwner:getTile():addThing(e)
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
        local e = Effect.create()
        e:setId(60)
        owner:getTile():addThing(e)
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(60)
        oldOwner:getTile():addThing(e)
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
        local e = Effect.create()
        e:setId(18)
        oldOwner:getTile():addThing(e)
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
        local e = Effect.create()
        e:setId(18)
        oldOwner:getTile():addThing(e)
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
        local e = Effect.create()
        e:setId(66)
        owner:getTile():addThing(e)
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(66)
        oldOwner:getTile():addThing(e)
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
    opacity = 0.8,
    duration = 2000,
    speed = 1,
    offset = { -5, -5, true},
    
    onAttach = function(effect, owner)
        owner:setShader('frost armor')
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(44)
        if oldOwner and oldOwner:getTile() then
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