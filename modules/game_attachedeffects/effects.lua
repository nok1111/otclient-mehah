--[[
    register(id, name, thingId, thingType, config)
    config = {
        speed, disableWalkAnimation, shader, drawOnUI, opacity
        duration, loop, transform, hideOwner, size{width, height}
        offset{x, y, onTop}, dirOffset[dir]{x, y, onTop},
        light { color, intensity}, drawOrder(only for tiles),
        bounce{minHeight, height, speed}
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

AttachedEffectManager.register(2, 'Bat Wings', 307, ThingCategoryCreature, {
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
	
    onAttach = function(effect, owner)
        local e = Effect.create()
        e:setId(18)
        owner:getTile():addThing(e)
		
		
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(18)
        oldOwner:getTile():addThing(e)
    end
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

AttachedEffectManager.register(17, 'overcharged', 60, ThingCategoryEffect, {
	opacity = 0.75,
	duration = 8000,
	speed = 1.4,
	offset = { 0, 0, true},
	
    onAttach = function(effect, owner)
        local e = Effect.create()
        e:setId(394)
        owner:getTile():addThing(e)
		
		
    end,
    onDetach = function(effect, oldOwner)
        local e = Effect.create()
        e:setId(38)
        oldOwner:getTile():addThing(e)
    end
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