SpelllistSettings = {
    ['Default'] = {
        iconFile = '/images/game/spells/defaultspells',
        iconSize = {
            width = 32,
            height = 32
        },
        spellListWidth = 210,
        spellWindowWidth = 550,
        spellOrder = {
		'Rend', 
		'Dragons Call', 
		'Fire Within', 
		'Brutal Swing', 
		'Charge', 
		'Dragon Aura', 
		'Challenging Spear', 
		'Whirlwind', 
		'Dragon Shrine', 
		'Roar', 
		'Phoenix Wrath', 
		--templar
		'Divine Punishment', 
		'Penitence', 
		'Holy Ground', 
		'Sacred Ground',
		'Crusader Strike', 
		'Divine Storm',
		'Smite', 
		'Light Beam', 
		'Summon Guardian of Light',
		'Kings Blessing',
		
		--Magician
		'Energy Blast', 
		'Fire Blast', 
		'Ice Nova', 
		'Teleport', 
		'Mana Distortion', 
		'Mana Flow', 
		'Hand of God', 
		'Frost Wave',  
		'Arcane Missiles', 
		'Blizzard',
		
		--warlock
		'Zombie Wall', 
		'Curse', 
		'Fear', 
		'Shadow Strike', 
		'Summon Void Archer', 
		'Summon Void Healer', 
		'Summon Void Guard', 
		'Blood Pact', 
		'Party Vitality', 
		'Blood Wall', 
		'Dark Plague', 
        'Soul Rain',
        'Void Creep',
		'Void Recall',	
		
		--nightblade
		'Stealth', 
		'Mutilate', 
		'Backstab', 
		'Dark Ambush',
		'Shadow Hunt',
        'Shadowstep', 		
		'Fan of Knives', 
		'Shadow Form', 
		'Dark Rupture', 
		'Void Execution', 
		'Blood Blades', 
		
		--stellar
		'Cosmic Force',
		'Regrowth',
		'Aery Wrath',
		'Star Fall',
		'Falling Star',
		'Rain Fall', 
		'Heal Party',
		'Grow',
		'Lunar Beam',
		'Aery Strikes',
		'Full Moon',
		
		--soul weave
		'Soul Fists',
		'Soul Barrage',
		'Anger Release',
		'Spectral Wave',
		'Underworld Gaze',
		'Hollow Blade',
		'Veil of Anguish',
		'Absolute Denial',
		'Soul Link',
		'Void Slumber',
		'Drain Soul',
		
		--Druid
		'Earth Dance',
		'Terra Strike',
		'Living Seeds',
		'Life Bloom',
		'Rejuvenation',
		'Seed Germination',
		'Travel Form',
		'Carnivorous Vile',
		'Living Ground',
		'Thorns',
		'Piercing Wave',
		'Bear Form',
		'Bless of the Forest',
		'Wrath of Nature',
		
		--Light Dancer
		'Charged Strike',
		'Static Charge',
		'Light Dash',
		'Lightning Orb',
		'Swift Elusion',
		'Chain of Lightning',
		'Lightning Spear',
		'Overcharge',
		'Magnetic Field',
		'Magnetic Orb',
		
		--Archer
		'Flaming Shot',
		'Beer Barrel',
		'Explosive Shots',
		'Wind Barrel',
		'Condemn Shot',
		'Nail Bomb',
		'Healing Barrel',
		'Arrow Rain',
		'Frost Barrel',
		'Destructive Shot', 
		'Aspect Mastery',
		
		--healing spells
		'Minor Heal', 
		'Strong Heal', 
		'Great Heal', 
		
		
		--mastery
		'Shield Wall', 
		'Protection', 
		'Shield Bash', 		 

		'Hells Core', 
		'Quick Chains',
		'Magic Shield', 
     	'Blood Rage',
		--etc
		'Find Person', 
		'Food', 
		'Magic Rope',  
		'Heal Friend', 
		'Haste', 
		
		'Invisibility', 
		'Levitate', 
		'Light', 
		'Protect Party', 
		'Mass Healing', 
		'Strong Haste',
		'Taunt',
		'Kings Call'
					  
					  }
    } --[[,
  ['Custom'] =  {
    iconFile = '/images/game/spells/custom',
    iconSize = {width = 32, height = 32},
    spellOrder = {
      'Chain Lighting'
      ,'Chain Healing'
      ,'Divine Chain'
      ,'Berserk Chain'
      ,'Cheat death'
      ,'Brutal Charge'
      ,'Empower Summons'
      ,'Summon Doppelganger'
    }
  }]]
}

SpellInfo = {
    ['Default'] = {
       
    -- DRAGON Knight
    ['Rend'] = {
        id = 1,
        words = 'rend',
        exhaustion = 3000,
        premium = false,
        type = 'Instant',
        icon = 'bloodaxe',
        mana = 20,
        level = 8,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Deals physical damage to the target and all surrounding enemies. '
    },
    ['Dragons Call'] = {
        id = 2,
        words = 'Dragons Call',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'fireearth',
        mana = 85,
        level = 100,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Call the dragon soul upon an enemy dealing massive damage.'
    },
    ['Fire Within'] = {
        id = 3,
        words = 'Fire Within',
        exhaustion = 20000,
        premium = false,
        type = 'Instant',
        icon = 'firesoul',
        mana = 75,
        level = 70,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Expels fire waves that deal fire damage around the caster. '
    },
    ['Brutal Swing'] = {
        id = 4,
        words = 'Brutal Swing',
        exhaustion = 6000,
        premium = false,
        type = 'Instant',
        icon = 'bloodaxe',
        mana = 55,
        level = 18,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Deals a brutal strike based on the direction and weapon used. Heals the caster based on the damage done. '
    },
    ['Charge'] = {
        id = 5,
        words = 'Charge',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'charge',
        mana = 70,
        level = 40,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Charge at high speed into your target dealing physical damage upon landing. '
    },
    ['Dragon Aura'] = {
        id = 6,
        words = 'Dragon Aura',
        exhaustion = 20000,
        premium = false,
        type = 'Instant',
        icon = 'dragonstance',
        mana = 75,
        level = 50,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'The caster gains the dragon\'s aura dealing fire damage over time to all enemies near the player. Caster will also heal on every orb rotation. '
    },
    ['Challenging Spear'] = {
        id = 7,
        words = 'Challenging Spear',
        exhaustion = 5000,
        premium = false,
        type = 'Instant',
        icon = 'pending',
        mana = 30,
        level = 20,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Throw a spear at the target dealing damage and taunting it for a short duration. '
    },
    ['Whirlwind'] = {
        id = 8,
        words = 'whirlwind',
        exhaustion = 5000,
        premium = false,
        type = 'Instant',
        icon = 'firetornado',
        mana = 85,
        level = 30,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Creates a fire whirlwind around the caster. Affected targets will also burn. '
    },
    ['Dragon Shrine'] = {
        id = 9,
        words = 'Dragon Shrine',
        exhaustion = 20000,
        premium = false,
        type = 'Instant',
        icon = 'dragonshrine',
        mana = 325,
        level = 150,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Pull all enemies around the target dealing a moderate amount of damage. '
    },
    ['Roar'] = {
        id = 10,
        words = 'Roar',
        exhaustion = 8000,
        premium = false,
        type = 'Instant',
        icon = 'roar',
        mana = 20,
        level = 60,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Repels all enemies surrounding the target, if an enemy hits a wall it will get stunned. '
    },
    ['Phoenix Wrath'] = {
        id = 11,
        words = 'Phoenix Wrath',
        exhaustion = 17000,
        premium = false,
        type = 'Instant',
        icon = 'dragonbreath',
        mana = 115,
        level = 125,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Call the phoenix breath dealing fire damage to all enemies in front of the caster direction. '
    },

    -- TEMPLAR
    ['Divine Punishment'] = {
        id = 20,
        words = 'Divine Punishment',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'divine_punishment',
        mana = 200,
        level = 100,
        soul = 1,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {2},
        description = 'Open the heavens gate to punish an enemy dealing massive damage in a 1x1 area to your target.'
    },
    ['Penitence'] = {
        id = 21,
        words = 'Penitence',
        exhaustion = 7000,
        premium = false,
        type = 'Instant',
        icon = 'penitence',
        mana = 60,
        level = 25,
        soul = 1,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {2},
        description = 'Hits multiple enemies and taunts them for a few seconds. '
    },
    ['Holy Ground'] = {
        id = 22,
        words = 'Holy Ground',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'holyarea',
        mana = 75,
        level = 50,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {2},
        description = 'Place a holy ground beneath the player dealing holy damage over time to all enemies inside. (shares cooldown with sacred ground) '
    },
    ['Sacred Ground'] = {
        id = 17,
        words = 'Sacred Ground',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'sacredarea',
        mana = 100,
        level = 40,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {2},
        description = 'Place a sacred ground healing all players inside the area. (shares cooldown with holy ground) '
    },
    ['Crusader Strike'] = {
        id = 23,
        words = 'Crusader Strike',
        exhaustion = 6000,
        premium = false,
        type = 'Instant',
        icon = 'holysword',
        mana = 50,
        level = 18,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {2},
        description = 'Deals physical damage at close range. '
    },
    ['Divine Storm'] = {
        id = 24,
        words = 'Divine Storm',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'divineclock',
        mana = 150,
        level = 70,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {2},
        description = 'Deals AoE damage to all nearby enemies and heals the player for a small amount. '
    },

    ['Smite'] = {
        id = 28,
        words = 'Smite',
        exhaustion = 3000,
        premium = false,
        type = 'Instant',
        icon = 'smite',
        mana = 20,
        level = 8,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {2},
        description = 'Smite the player dealing holy damage. '
    },
    ['Light Beam'] = {
        id = 29,
        words = 'Light Beam',
        exhaustion = 12000,
        premium = false,
        type = 'Instant',
        icon = 'holyslash',
        mana = 130,
        level = 30,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {2},
        description = 'Deals holy damage multiple times based on the players direction.'
    },
    ['Summon Guardian of Light'] = {
        id = 30,
        words = 'Summon Guardian',
        exhaustion = 100000,
        premium = false,
        type = 'Instant',
        icon = 'guardianoflight',
        mana = 250,
        level = 90,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {2},
        description = 'Summons a seraphine that heals the summoner and all nearby party members.'
    },
    ['Kings Blessing'] = {
        id = 31,
        words = 'Kings Blessing',
        exhaustion = 1000,
        premium = false,
        type = 'Instant',
        icon = 'holycross',
        mana = 50,
        level = 60,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {2},
        description = 'Bless the player and all party members by increasing all offensive skills by 10% for 20 minutes.'
    },

    -- MAGICIAN

    ['Energy Blast'] = {
        id = 41,
        words = 'Energy Blast',
        exhaustion = 4000,
        premium = false,
        type = 'Instant',
        icon = 'energybeam1',
        mana = 0,
        level = 10,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {1},
        description = 'Shoots an energy attack dealing magic damage and restoring 4% of the user\'s total mana.'
    },
    ['Fire Blast'] = {
        id = 42,
        words = 'Fire Blast',
        exhaustion = 3000,
        premium = false,
        type = 'Instant',
        icon = 'fireshot',
        mana = 25,
        level = 8,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {1},
        description = 'Shoots a fireball that explodes upon reaching the target dealing magic damage.'
    },
    ['Ice Nova'] = {
        id = 44,
        words = 'Ice Nova',
        exhaustion = 25000,
        premium = false,
        type = 'Instant',
        icon = 'frostaura',
        mana = 180,
        level = 20,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {1},
        description = 'Shoots multiple ice attacks at the same time dealing magic damage.'
    },

    ['Teleport'] = {
        id = 52,
        words = 'Teleport',
        exhaustion = 12000,
        premium = false,
        type = 'Instant',
        icon = 'travel',
        mana = 150,
        level = 60,
        soul = 0,
        group = {
            [3] = 3000
        },
        parameter = false,
        vocations = {1},
        description = 'Teleports the caster a few tiles forward based on direction.'
    },
    ['Mana Distortion'] = {
        id = 46,
        words = 'Mana Distortion',
        exhaustion = 120000,
        premium = false,
        type = 'Instant',
        icon = 'electrticity',
        mana = 0,
        level = 80,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {1},
        description = 'Distort your mana to create a magic field in the ground that gives mana and magic power.'
    },
    ['Mana Flow'] = {
        id = 47,
        words = 'Mana Flow',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'bluehand',
        mana = 0,
        level = 40,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {1},
        description = 'Restores players mana by percentage in a short amount of time.'
    },
    ['Hand of God'] = {
        id = 48,
        words = 'Hand of God',
        exhaustion = 5000,
        premium = false,
        type = 'Instant',
        icon = 'firefist',
        mana = 120,
        level = 30,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {1},
        description = 'Summon the fire gods hand to deal massive fire damage to the target and enemies nearby.'
    },
    ['Frost Wave'] = {
        id = 49,
        words = 'Frost Wave',
        exhaustion = 13000,
        premium = false,
        type = 'Instant',
        icon = 'frostice',
        mana = 200,
        level = 70,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {1},
        description = 'Deals a high amount of ice damage and freezes all the enemies for 4 seconds. '
    },

    ['Arcane Missiles'] = {
        id = 51,
        words = 'Arcane Missiles',
        exhaustion = 6000,
        premium = false,
        type = 'Instant',
        icon = 'energymissiles',
        mana = 80,
        level = 18,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {1},
        description = 'Shoots arcane missiles dealing magic damage. The amount of missiles increases with your total magic level. '
    },
    ['Blizzard'] = {
        id = 53,
        words = 'Blizzard',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'tornado',
        mana = 200,
        level = 50,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {1},
        description = 'Deals elemental damage to all nearby enemies around the selected target. '
    },
    ['Hells Core'] = {
        id = 304,
        words = 'Hells Core',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'meteor',
        mana = 400,
        level = 100,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {1},
        description = 'Call down meteors at your position dealing damage to all nearby enemies. '
    },

    -- Warlock
    ['Void Recall'] = {
        id = 60,
        words = 'void recall',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'ghost',
        mana = 300,
        level = 100,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Summon skeletons that fight at your side. Max: 4.'
    },
    ['Zombie Wall'] = {
        id = 61,
        words = 'Zombie Wall',
        exhaustion = 20000,
        premium = false,
        type = 'Instant',
        icon = 'zombiewall',
        mana = 50,
        level = 40,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Place an undead wall in front of the caster.'
    },
    ['Curse'] = {
        id = 62,
        words = 'Curse',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'shadoweye',
        mana = 35,
        level = 8,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Curse the target dealing death damage over time. '
    },
    ['Fear'] = {
        id = 63,
        words = 'Fear',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'fear',
        mana = 150,
        level = 60,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Fears the target. Feared enemies are unable to move or cast by themselves.'
    },
    ['Shadow Strike'] = {
        id = 64,
        words = 'Shadow Strike',
        exhaustion = 5000,
        premium = false,
        type = 'Instant',
        icon = 'shadowbolts',
        mana = 110,
        level = 30,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Strikes the target with death damage. '
    },
    ['Summon Void Archer'] = {
        id = 69,
        words = 'Summon Void Archer',
        exhaustion = 10000,
        premium = false,
        type = 'Instant',
        icon = 'voidarcher',
        mana = 150,
        level = 30,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Summon a void archer for 5 minutes that deals damage from distance. the ammount of summons you can manage increases with your level to a max of 4 at a time. '
    },
    ['Summon Void Healer'] = {
        id = 35,
        words = 'Summon Void Healer',
        exhaustion = 5000,
        premium = false,
        type = 'Instant',
        icon = 'voidhealer',
        mana = 300,
        level = 70,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Summon a void healer that heals you and your summons. It will always heal the lowest health target. the ammount of summons you can manage increases with your level to a max of 4 at a time. '
    },
    ['Summon Void Guard'] = {
        id = 68,
        words = 'Summon Void Guard',
        exhaustion = 4000,
        premium = false,
        type = 'Instant',
        icon = 'voidguard',
        mana = 480,
        level = 100,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Summon a void guard that can handle high amounts of damage. the ammount of summons you can manage increases with your level to a max of 4 at a time. '
    },
	
    ['Blood Pact'] = {
        id = 66,
        words = 'Blood Pact',
        exhaustion = 20000,
        premium = false,
        type = 'Instant',
        icon = 'blood_pact',
        mana = 0,
        level = 90,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Sacrifice some of your health in exchange for mana. You can\'t die while casting this. '
    },
    ['Party Vitality'] = {
        id = 67,
        words = 'Party Vitality',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'party_vitality',
        mana = 100,
        level = 60,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Increases your and party total max health by 20% for 20 minutes.'
    },
    ['Blood Wall'] = {
        id = 70,
        words = 'Blood Wall',
        exhaustion = 20000,
        premium = false,
        type = 'Instant',
        icon = 'bloodpact',
        mana = 0,
        level = 90,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'In exchange for some of your health you will gain a 50% increased shielding and max health buff.'
    },
    ['Dark Plague'] = {
        id = 71,
        words = 'Dark plague',
        exhaustion = 22000,
        premium = false,
        type = 'Instant',
        icon = 'bats',
        mana = 300,
        level = 100,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Deals poison damage to all nearby enemies around your target for several seconds.'
    },

    ['Void Creep'] = {
        id = 73,
        words = 'creep',
        exhaustion = 6000,
        premium = false,
        type = 'Instant',
        icon = 'minion',
        mana = 60,
        level = 18,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Summon a void creep that explodes when reaching his target. '
    },
    ['Soul Rain'] = {
        id = 74,
        words = 'Soul Rain',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'shadowexplode',
        mana = 200,
        level = 50,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {5},
        description = 'Deals damage to all nearby enemies around the selected target. '
    },

    -- NIGHTBLADE
    ['Stealth'] = {
        id = 80,
        words = 'Stealth',
        exhaustion = 60000,
        premium = false,
        type = 'Instant',
        icon = 'stealth',
        mana = 110,
        level = 40,
        soul = 0,
        group = {
            [3] = 5000
        },
        parameter = false,
        vocations = {3},
        description = 'Enter stealth mode for 2.5 seconds, while stealth you become immune to all incoming damage.'
    },
    ['Shadowstep'] = {
        id = 83,
        words = 'Shadowstep',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'jump',
        mana = 125,
        level = 90,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {3},
        description = 'Turn into shadows to teleport into your target and stunning them for 1.8 seconds. '
    },
    ['Mutilate'] = {
        id = 81,
        words = 'Mutilate',
        exhaustion = 3000,
        premium = false,
        type = 'Instant',
        icon = 'markofdeath',
        mana = 35,
        level = 8,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {3},
        description = 'Mutilate the target dealing damage multiple times. '
    },
    ['Backstab'] = {
        id = 84,
        words = 'Backstab',
        exhaustion = 7000,
        premium = false,
        type = 'Instant',
        icon = 'backstab',
        mana = 60,
        level = 15,
        soul = 0,
        group = {
            [1] = 0
        },
        parameter = false,
        vocations = {3},
        description = 'Stuns the target for 1.8 seconds and deals physical damage. '
    },
    ['Shadow Hunt'] = {
        id = 82,
        words = 'Shadow Hunt',
        exhaustion = 6000,
        premium = false,
        type = 'Instant',
        icon = 'bats',
        mana = 60,
        level = 18,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {3},
        description = 'Hunt the target with crows dealing consecutive amounts of magic damage. '
    },
    ['Dark Ambush'] = {
        id = 85,
        words = 'Dark Ambush',
        exhaustion = 22000,
        premium = false,
        type = 'Instant',
        icon = 'daggers',
        mana = 250,
        level = 70,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {3},
        description = 'Exterminates all enemies in your sight. '
    },
    ['Shadow Form'] = {
        id = 87,
        words = 'Shadow Form',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'void',
        mana = 65,
        level = 60,
        soul = 0,
        group = {
            [2] = 3000
        },
        parameter = false,
        vocations = {3},
        description = 'enter the shadow form wich heals yourself for a moderate period of time. '
		},
	['Fan of Knives'] = {
    id = 86,
    words = 'Fan of knives',
    exhaustion = 5000,
    premium = false,
    type = 'Instant',
    icon = 'shadowblade',
    mana = 100,
    level = 50,
    soul = 0,
    group = {
        [1] = 1000
    },
    parameter = false,
    vocations = {3},
    description = 'Strike and poison all enemies around yourself with physical damage and earth damage based on proximity. '
	},
	['Dark Rupture'] = {
		id = 88,
		words = 'Dark Rupture',
		exhaustion = 6000,
		premium = false,
		type = 'Instant',
		icon = 'shadowexplode',
		mana = 45,
		level = 30,
		soul = 0,
		group = {
			[1] = 1000
		},
		parameter = false,
		vocations = {3},
		description = 'Strike your target with a death attack, if the target is stunned damage will be significantly increased.'
	},
	['Void Execution'] = {
		id = 89,
		words = 'Void Execution',
		exhaustion = 22000,
		premium = false,
		type = 'Instant',
		icon = 'execution',
		mana = 200,
		level = 100,
		soul = 0,
		group = {
			[1] = 1000
		},
		parameter = false,
		vocations = {3},
		description = 'Call death and executes any target that is below 25%. [TRUE DAMAGE]'
	},
	['Blood Blades'] = {
		id = 90,
		words = 'Blood Blades',
		exhaustion = 25000,
		premium = false,
		type = 'Instant',
		icon = 'firedagger',
		mana = 0,
		level = 35,
		soul = 0,
		group = {
			[1] = 1000,
			[1] = 2000
		},
		parameter = false,
		vocations = {3},
		description = 'Heals the target every time it hits with melee attacks by a small percent.'
	},

								
		
	--Stellar
		['Cosmic Force'] = {
		id = 100,
		words = 'Cosmic Force',
		exhaustion = 3000,
		premium = false,
		type = 'Instant',
		icon = 'naturefist',
		mana = 30,
		level = 8,
		soul = 0,
		group = {
			[1] = 1000
		},
		parameter = false,
		vocations = {6},
		description = 'Call the earth spirits to shoot an earth attack into your target. '
	},
	['Regrowth'] = {
		id = 101,
		words = 'Regrowth',
		exhaustion = 2000,
		premium = false,
		type = 'Instant',
		icon = 'healhand',
		mana = 65,
		level = 40,
		soul = 0,
		group = {
			[2] = 1000
		},
		parameter = false,
		vocations = {6},
		description = 'Heals the caster with healing winds. '
	},
	['Aery Wrath'] = {
		id = 102,
		words = 'Aery Wrath',
		exhaustion = 10000,
		premium = false,
		type = 'Instant',
		icon = 'aery_wrath',
		mana = 45,
		level = 18,
		soul = 0,
		group = {
			[1] = 1000
		},
		parameter = false,
		vocations = {6},
		description = 'Call aery into battle hitting all enemies around the main target. '
	},
	['Star Fall'] = {
		id = 103,
		words = 'Star Fall',
		exhaustion = 7000,
		premium = false,
		type = 'Instant',
		icon = 'star_fall',
		mana = 0,
		level = 50,
		soul = 0,
		group = {
			[1] = 1000
		},
		parameter = false,
		vocations = {6},
		description = 'Call down one star dealing energy damage to the target and nearby enemies. (this spell does not consume mana) '
	},

		
		['Falling Star'] = {
        id = 104,
        words = 'Falling Star',
        exhaustion = 7000,
        premium = false,
        type = 'Instant',
        icon = 'falling_star',
        mana = 95,
		level = 30,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {6},
        description = 'Call down one star dealing earth damage and stunning the target. '
    },
    ['Rain Fall'] = {
        id = 105,
        words = 'Rain Fall',
        exhaustion = 20000,
        premium = false,
        type = 'Instant',
        icon = 'nightwolf',
        mana = 100,
        level = 25,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {6},
        description = 'Bring a healing rain at your location, healing all players inside the radius. '
    },
    ['Heal Party'] = {
        id = 106,
        words = 'Heal Party',
        exhaustion = 4000,
        premium = false,
        type = 'Instant',
        icon = 'ultimatehealing',
        mana = 150,
        level = 28,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {6},
        description = 'Heal all party members close to the caster. '
    },
    ['Aery Strikes'] = {
        id = 109,
        words = 'Aery Strikes',
        exhaustion = 8000,
        premium = false,
        type = 'Instant',
        icon = 'shadowbolts',
        mana = 135,
        level = 70,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {6},
        description = 'Call aery into battle hitting all enemies around the main target. '
    },
    ['Lunar Beam'] = {
        id = 108,
        words = 'Lunar Beam',
        exhaustion = 13000,
        premium = false,
        type = 'Instant',
        icon = 'energybeam1',
        mana = 185,
        level = 60,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {6},
        description = 'Deals energy damage to all enemies in front of the caster direction. '
    },
    ['Full Moon'] = {
        id = 111,
        words = 'Full Moon',
        exhaustion = 45000,
        premium = false,
        type = 'Instant',
        icon = 'moon',
        mana = 300,
        level = 100,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {6},
        description = 'Procs Your passive (stellar alignment) continuously. '
    },
    ['Grow'] = {
        id = 107,
        words = 'Grow',
        exhaustion = 25000,
        premium = false,
        type = 'Instant',
        icon = 'nature',
        mana = 100,
        level = 60,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {6, 8},
        description = 'Grow multiple earth columns that can block paths.'
    },

    -- Soul Weaver
    ['Soul Fists'] = {
        id = 120,
        words = 'Soul Fists',
        exhaustion = 3000,
        premium = false,
        type = 'Instant',
        icon = 'energyhand',
        mana = 35,
        level = 8,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Fist your target with your gathered souls, the damage is applied for every stored soul. '
    },
    ['Soul Barrage'] = {
        id = 121,
        words = 'Soul Barrage',
        exhaustion = 6000,
        premium = false,
        type = 'Instant',
        icon = 'deathhand',
        mana = 75,
        level = 30,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Blast nearby targets with your gathered souls, the damage is applied for every stored soul. '
    },
    ['Anger Release'] = {
        id = 122,
        words = 'Anger Release',
        exhaustion = 12000,
        premium = false,
        type = 'Instant',
        icon = 'firehand',
        mana = 70,
        level = 55,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Gather and release the anger of souls dealing death damage to all surrounding enemies. '
    },
    ['Spectral Wave'] = {
        id = 124,
        words = 'Spectral Wave',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'icearrow',
        mana = 75,
        level = 50,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Call from death a spectral wave of creatures that deals damage to all enemies in front of the caster direction. '
    },
    ['Underworld Gaze'] = {
        id = 125,
        words = 'Underworld Gaze',
        exhaustion = 16000,
        premium = false,
        type = 'Instant',
        icon = 'holyhand',
        mana = 90,
        level = 70,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Deals AoE damage around the caster fearing for 3 seconds all efected enemies. '
    },
    ['Hollow Blade'] = {
        id = 126,
        words = 'Hollow Blade',
        exhaustion = 4000,
        premium = false,
        type = 'Instant',
        icon = 'bloodhand',
        mana = 20,
        level = 18,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Strike the target with a hollow blade this spell has a 100% chance to generate 1 soul charge and healing the caster by 8% max health.'
    },
    ['Veil of Anguish'] = {
        id = 127,
        words = 'Veil of Anguish',
        exhaustion = 7000,
        premium = false,
        type = 'Instant',
        icon = 'spikes',
        mana = 30,
        level = 40,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Increase physical damage reflection by 10% of your total max health for 20 seconds.'
    },
    ['Absolute Denial'] = {
        id = 128,
        words = 'Absolute Denial',
        exhaustion = 20000,
        premium = false,
        type = 'Instant',
        icon = 'void',
        mana = 120,
        level = 60,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Creates a hollow attack around the target that deals minor damage but heals the target based on the number of enemies reached. '
    },
    ['Soul Link'] = {
        id = 129,
        words = 'Soul Link',
        exhaustion = 50000,
        premium = false,
        type = 'Instant',
        icon = 'poisonhand',
        mana = 0,
        level = 90,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Swap your current max health with your target. (only works on non-elite monsters)'
    },
    ['Drain Soul'] = {
        id = 130,
        words = 'Drain Soul',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'shadowbolts',
        mana = 150,
        level = 100,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Drain the soul of all surrounding enemies healing for each enemy affected.'
    },
    ['Void Slumber'] = {
        id = 131,
        words = 'Void Slumber',
        exhaustion = 10000,
        premium = false,
        type = 'Instant',
        icon = 'ghost',
        mana = 80,
        level = 70,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {7},
        description = 'Gather all nearby souls from dead enemies and summon them as soul voids to fight by your side.'
    },

    -- Druid
    ['Terra Strike'] = {
        id = 140,
        words = 'Terra Strike',
        exhaustion = 3000,
        premium = false,
        type = 'Instant',
        icon = 'earthattack2',
        mana = 30,
        level = 8,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Shoots an earth strike to the target. '
    },
    ['Living Seeds'] = {
        id = 141,
        words = 'Living Seeds',
        exhaustion = 35000,
        premium = false,
        type = 'Instant',
        icon = 'greenwind',
        mana = 150,
        level = 46,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Creates 2 living seeds in your inventory. These seeds can be placed in the ground as summons. '
    },
    ['Life Bloom'] = {
        id = 142,
        words = 'Life Bloom',
        exhaustion = 6000,
        premium = false,
        type = 'Instant',
        icon = 'icehand',
        mana = 70,
        level = 25,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Restore caster\'s and all party members\' health every second. '
    },
    ['Rejuvenation'] = {
        id = 143,
        words = 'Rejuvenation',
        exhaustion = 5000,
        premium = false,
        type = 'Instant',
        icon = 'healhand',
        mana = 100,
        level = 40,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Strong self-heal that restores health over time for 6 seconds. '
    },
    ['Seed Germination'] = {
        id = 144,
        words = 'Seed Germination',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'icehand2',
        mana = 75,
        level = 18,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Place a corrupted seed into the target that spreads over time dealing earth damage. '
    },
    ['Travel Form'] = {
        id = 145,
        words = 'Travel Form',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'haste',
        mana = 60,
        level = 25,
        soul = 0,
        group = {
            [3] = 2000
        },
        parameter = false,
        vocations = {8},
        description = 'Turn yourself into your travel form increasing dramatically your movement speed, while in this form you are unable to cast any spells.'
    },
    ['Carnivorous Vile'] = {
        id = 146,
        words = 'Carnivorous Vile',
        exhaustion = 5500,
        premium = false,
        type = 'Instant',
        icon = 'plant2',
        mana = 85,
        level = 30,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Cast a carnivorous plant into the target dealing earth damage, damage will critical strike if the target is poisoned. '
    },
    ['Living Ground'] = {
        id = 147,
        words = 'Living Ground',
        exhaustion = 10000,
        premium = false,
        type = 'Instant',
        icon = 'energythunder2',
        mana = 200,
        level = 60,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Creates a restoring ground that heals all players affected. [Target MxHP]'
    },
    ['Thorns'] = {
        id = 148,
        words = 'Thorns',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'nature',
        mana = 50,
        level = 60,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Place thorns in all party members reflecting all melee damage by 10% for 20 minutes.'
    },
    ['Piercing Wave'] = {
        id = 149,
        words = 'Piercing Wave',
        exhaustion = 12000,
        premium = false,
        type = 'Instant',
        icon = 'earthattack',
        mana = 115,
        level = 42,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Pierce through enemies with a thorns wave stunning and bleeding all enemies affected. '
    },
    ['Bear Form'] = {
        id = 150,
        words = 'Bear Form',
        exhaustion = 20000,
        premium = false,
        type = 'Instant',
        icon = 'roar',
        mana = 60,
        level = 45,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Turn yourself into your bear form increasing dramatically your max health and regeneration but reducing your speed, while in this form you are only able to cast healing spells.'
    },
    ['Bless of the Forest'] = {
        id = 151,
        words = 'Bless of the Forest',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'flower',
        mana = 50,
        level = 20,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Bless all your party members by increasing Health and mana restoration: 1% every 2 seconds for 20 minutes.'
    },
    ['Wrath of Nature'] = {
        id = 152,
        words = 'Wrath of Nature',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'naturewrath',
        mana = 420,
        level = 100,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Call the wrath of nature into all enemies around your target dealing energy damage. '
    },

    ['Earth Dance'] = {
        id = 110,
        words = 'Earth Dance',
        exhaustion = 16000,
        premium = false,
        type = 'Instant',
        icon = 'plant2',
        mana = 180,
        level = 60,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {8},
        description = 'Call the earth spirits to create an avalanche of rocks that collides into enemy targets. '
    },

    -- Light Dancer
    ['Charged Strike'] = {
        id = 160,
        words = 'Charged Strike',
        exhaustion = 4000,
        premium = false,
        type = 'Instant',
        icon = 'swordslash',
        mana = 25,
        level = 8,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {9},
        description = 'Strike the target with an electric slash dealing energy damage, if the target is affected by static charge this effect will be powered twice. '
    },
    ['Static Charge'] = {
        id = 161,
        words = 'Static Charge',
        exhaustion = 2200,
        premium = false,
        type = 'Instant',
        icon = 'strongfrost',
        mana = 0,
        level = 15,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {9},
        description = 'Apply static charge into the target and all nearby enemies. [LVL]'
    },
    ['Light Dash'] = {
        id = 162,
        words = 'Light Dash',
        exhaustion = 6000,
        premium = false,
        type = 'Instant',
        icon = 'travel',
        mana = 65,
        level = 18,
        soul = 0,
        group = {
            [1] = 0
        },
        parameter = false,
        vocations = {9},
        description = 'Dash into the targeted enemy dealing energy damage, if the target is affected by static charge this effect will be powered and also stun the target by 1.8 seconds. '
    },
    ['Lightning Orb'] = {
        id = 163,
        words = 'Lightning Orb',
        exhaustion = 10000,
        premium = false,
        type = 'Instant',
        icon = 'energyrush2',
        mana = 100,
        level = 80,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {9},
        description = 'Summon a lighting orb that slows and deals energy damage around the target. '
    },
    ['Swift Elusion'] = {
        id = 164,
        words = 'Swift Elusion',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'swordstance',
        mana = 0,
        level = 70,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {9},
        description = 'Expels high amounts of energy from the caster which deals energy damage (this effect can also apply on-hit effects). '
    },
    ['Chain of Lightning'] = {
        id = 165,
        words = 'Chain of Lightning',
        exhaustion = 3000,
        premium = false,
        type = 'Instant',
        icon = 'intensehealing',
        mana = 120,
        level = 50,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {9},
        description = 'deal damage to the target chaining in a electric wave all near enemies. '
    },
    ['Lightning Spear'] = {
        id = 166,
        words = 'Lightning Spear',
        exhaustion = 12000,
        premium = false,
        type = 'Instant',
        icon = 'frostmissile',
        mana = 85,
        level = 30,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {9},
        description = 'Throws an energy spear into the target dealing high energy damage and applying static charge. '
    },
    ['Overcharge'] = {
        id = 167,
        words = 'Overcharge',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'energythunder',
        mana = 115,
        level = 45,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {9},
        description = 'Enter overcharge mode which increases all your offensive skills by 20% but receiving damage for the duration.'
    },
    ['Magnetic Field'] = {
        id = 168,
        words = 'Magnetic Field',
        exhaustion = 35000,
        premium = false,
        type = 'Instant',
        icon = 'energyattack',
        mana = 175,
        level = 90,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {9},
        description = 'Place a magnetic field in the ground which applies static charge and disabling all enemies movement.'
    },
    ['Magnetic Orb'] = {
        id = 169,
        words = 'Magnetic Orb',
        exhaustion = 26000,
        premium = false,
        type = 'Instant',
        icon = 'energyball',
        mana = 190,
        level = 100,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {9},
        description = 'Create a Magnetic Orb in the target location that will follow and damage all nearby enemies. (this will not affect players) '
    },

    -- Archer
    ['Flaming Shot'] = {
        id = 180,
        words = 'Flaming Shot',
        exhaustion = 3000,
        premium = false,
        type = 'Instant',
        icon = '159',
        mana = 30,
        level = 8,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {10},
        description = 'Shoot a flaming shot to the target dealing fire damage and burning the target (based on your ml), if the target is affected by beer barrel this spell will be powered and deal target max health damage.'
    },
    ['Beer Barrel'] = {
        id = 181,
        words = 'Beer Barrel',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'barrel',
        mana = 0,
        level = 15,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
		vocations = {10},
		description = 'throws a beer barrel to the enemy target that spreads to all nearby enemies.'
    },
	['Wind Barrel'] = {
    id = 183,
    words = 'Wind Barrel',
    exhaustion = 5000,
    premium = false,
    type = 'Instant',
    icon = 'deathattack',
    mana = 40,
    level = 40,
    soul = 0,
    group = {
        [3] = 1000
    },
    parameter = false,
    vocations = {10},
    description = 'Creates a wind barrel that explodes after a short time duration increasing your movement speed drastically.'
	},
	['Healing Barrel'] = {
		id = 186,
		words = 'Healing Barrel',
		exhaustion = 8000,
		premium = false,
		type = 'Instant',
		icon = 'icicle',
		mana = 120,
		level = 60,
		soul = 0,
		group = {
			[2] = 1000
		},
		parameter = false,
		vocations = {10},
		description = 'Creates a healing barrel that explodes after a short time duration healing all players in the area.'
	},
	['Arrow Rain'] = {
		id = 187,
		words = 'Arrow Rain',
		exhaustion = 15000,
		premium = false,
		type = 'Instant',
		icon = 'arrowbarrage',
		mana = 130,
		level = 50,
		soul = 0,
		group = {
			[1] = 1000
		},
		parameter = false,
		vocations = {10},
		description = 'Casts an arrow rain into the target dealing physical damage to all enemies in the area. '
	},
	['Nail Bomb'] = {
		id = 185,
		words = 'Nail Bomb',
		exhaustion = 10000,
		premium = false,
		type = 'Instant',
		icon = 'firestom',
		mana = 90,
		level = 30,
		soul = 0,
		group = {
			[1] = 1000
		},
		parameter = false,
		vocations = {10},
		description = 'Throws a nail bomb that instantly explodes dealing high amounts of physical damage. '
	},
	['Explosive Shots'] = {
		id = 182,
		words = 'Explosive Shots',
		exhaustion = 15000,
		premium = false,
		type = 'Instant',
		icon = 'explosive_shots',
		mana = 90,
		level = 18,
		soul = 0,
		group = {
			[1] = 1000
		},
		parameter = false,
		vocations = {10},
		description = 'Shoots 4 rounds of explosive shots dealing AoE damage to the target location. If the target is affected by beer barrel this spell will be powered and deal target max health damage. '
	},
	['Condemn Shot'] = {
		id = 184,
		words = 'Condemn Shot',
		exhaustion = 25000,
		premium = false,
		type = 'Instant',
		icon = 'arrowbreak',
		mana = 60,
		level = 28,
		soul = 0,
		group = {
			[3] = 1000
		},
		parameter = false,
		vocations = {10},
		description = 'Repels your target away from the caster. '
	},
	['Destructive Shot'] = {
		id = 189,
		words = 'Destructive Shot',
		exhaustion = 22000,
		premium = false,
		type = 'Instant',
		icon = 'destructive_shot',
		mana = 250,
		level = 90,
		soul = 0,
		group = {
			[1] = 1000,
			[1] = 2000
		},
		parameter = false,
		vocations = {10},
		description = 'charge a destructive shot that deals high amount of damage. (while casting the player will be unable to move or cast any other spell). '
	},

	    
    ['Frost Barrel'] = {
        id = 188,
        words = 'Frost Barrel',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'firearrow',
        mana = 150,
        level = 70,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {10},
        description = 'Creates a frost barrel that explodes after a short time duration freezing all enemies in the area.'
    },
    ['Aspect Mastery'] = {
        id = 123,
        words = 'Aspect Mastery',
        exhaustion = 22000,
        premium = false,
        type = 'Instant',
        icon = 'aspect_mastery',
        mana = 150,
        level = 100,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {10},
        description = 'Change between demolition stance and beast mode. Demolition mode: allows the user to deal AoE damage on hit. Beast Mode: allows the user to summon a wolf that evolves into a war wolf later on to assist you in combat.'
    },

    ['Minor Heal'] = {
        id = 200,
        words = 'Minor Heal',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'ultimatehealing',
        mana = 20,
        level = 1,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
        description = 'Basic healing spell, heals the caster for a small amount. '
    },
    ['Strong Heal'] = {
        id = 201,
        words = 'Strong Heal',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'ultimatehealing',
        mana = 65,
        level = 25,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
        description = 'Basic healing spell, heals the caster for a moderate amount. '
    },
    ['Great Heal'] = {
        id = 202,
        words = 'Great Heal',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'ultimatehealing',
        mana = 120,
        level = 50,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = false,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
        description = 'Basic healing spell, heals the caster for a significant amount. '
    },

    -- MASTERY
    ['Taunt'] = {
        id = 324,
        words = 'taunt',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'roar',
        mana = 75,
        level = 22,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {2, 4, 7, 8},
        description = 'Taunt all enemies around the caster. Unlocked at defense 30.'
    },
    ['Shield Wall'] = {
        id = 300,
        words = 'shield wall',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'shield2',
        mana = 0,
        level = 27,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {2, 4, 7},
        description = 'Increases your max health and defense for a short period of time.'
    },
    ['Protection'] = {
        id = 301,
        words = 'protection',
        exhaustion = 50000,
        premium = false,
        type = 'Instant',
        icon = 'shield',
        mana = 50,
        level = 50,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {2, 4, 7},
        description = 'Immune to all damage for 3 seconds.'
    },
    ['Shield Bash'] = {
        id = 302,
        words = 'shield bash',
        exhaustion = 15000,
        premium = false,
        type = 'Instant',
        icon = 'kick',
        mana = 65,
        level = 25,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {2, 4, 7},
        description = 'Stuns your target, this skill requires a shield. Unlocked at defense 22.'
    },

    ['Quick Chains'] = {
        id = 305,
        words = 'Quick Chains',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'chains',
        mana = 250,
        level = 47,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {4},
        description = 'Unlocked at dexterity 65.'
    },
    ['Blood Rage'] = {
        id = 306,
        words = 'Blood Rage',
        exhaustion = 30000,
        premium = false,
        type = 'Instant',
        icon = 'firestance',
        mana = 85,
        level = 30,
        soul = 0,
        group = {
            [1] = 1000
        },
        parameter = false,
        vocations = {4, 9},
        description = 'Unlocked at strength 27.'
    },
    ['Magic Shield'] = {
        id = 307,
        words = 'Magic Shield',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'manashield',
        mana = 0,
        level = 17,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {1, 6, 8, 10},
        description = 'Unlocked at intelligence 25.'
    },
    ['Find Person'] = {
        id = 308,
        words = 'exiva',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'other',
        mana = 20,
        level = 8,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = true,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    },
    ['Food'] = {
        id = 309,
        words = 'exevo pan',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'other',
        mana = 15,
        level = 10,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
        description = 'Unlocked at Faith 10.'
    },
    ['Haste'] = {
        id = 311,
        words = 'utani hur',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'haste',
        mana = 60,
        level = 14,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    },
    ['Heal Friend'] = {
        id = 312,
        words = 'exura sio',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'ultimatehealing',
        mana = 140,
        level = 18,
        soul = 0,
        group = {
            [2] = 1000
        },
        parameter = true,
        vocations = {6, 8},
        description = 'Unlocked at faith 20 and intelligence 24.'
    },
    ['Invisibility'] = {
        id = 313,
        words = 'Invisibility',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'other',
        mana = 440,
        level = 35,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {6, 8},
        description = 'Unlocked at faith 50.'
    },
    ['Levitate'] = {
        id = 314,
        words = 'exani hur',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'other',
        mana = 50,
        level = 15,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = true,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    },
    ['Light'] = {
        id = 315,
        words = 'utevo lux',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'other',
        mana = 20,
        level = 8,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    },
    ['Magic Rope'] = {
        id = 317,
        words = 'exani tera',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'other',
        mana = 20,
        level = 8,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    },
    ['Mass Healing'] = {
        id = 318,
        words = 'exura gran mas res',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'ultimatehealing',
        mana = 150,
        level = 36,
        soul = 0,
        group = {
            [4] = 2000
        },
        parameter = false,
        vocations = {6, 8},
        description = 'Unlocked at faith 60.'
    },
    ['Protect Party'] = {
        id = 319,
        words = 'utamo mas sio',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'partyshield',
        mana = 90,
        level = 32,
        soul = 0,
        group = {
            [4] = 2000
        },
        parameter = false,
        vocations = {6, 8},
        description = 'Unlocked at faith 55.'
    },
    ['Strong Haste'] = {
        id = 322,
        words = 'utani gran hur',
        exhaustion = 2000,
        premium = false,
        type = 'Instant',
        icon = 'haste',
        mana = 100,
        level = 40,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
        description = 'Unlocked at Faith 20'
    },
    ['Kings Call'] = {
        id = 325,
        words = 'kings call',
        exhaustion = 3600000,
        premium = false,
        type = 'Instant',
        icon = 'holycross',
        mana = 0,
        level = 8,
        soul = 0,
        group = {
            [3] = 1000
        },
        parameter = false,
        vocations = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
        description = 'Summoned by your king\'s command, Kings Call instantly teleports you to your hometown. A spell of royal privilege, granted to those bearing the Kings Scroll.'
    }


       



    } 
}

-- ['const_name'] =       {client_id, TFS_id}
-- Conversion from TFS icon id to the id used by client (icons.png order)
SpellIcons = {
--[[
    ['terraburst'] = {client_id_do not change, _XML_SPELLS_ID__},

]]
   ['bluehand']           = {13, 47},
  ['healingdot']         = {14, 123},
  ['potionheal']         = {6,  158},
  ['strongpotionheal']   = {7, 157},
  ['partyshield']        = {8, 319},
  ['partyaura']          = {9, 155},
  ['greenwind']          = {10, 141},
  ['pending']            = {11, 7},
  ['execution']          = {12, 89},
  ['auraclock']          = {15, 24},
  ['auraclock2']         = {16, 150},
  ['hearths']            = {17, 149},
  ['energymissiles']     = {18, 51},
  ['frostmissile']       = {19, 166},
  ['frostaura']          = {20, 44},
  ['energybeam1']        = {21, 29},
  ['frostice']           = {22, 49},
  ['meteor']             = {23, 304},
  ['fireshot']           = {24, 42},
  ['elementalblast']     = {25, 141},
  ['thunderhammer']      = {26, 140},
  ['electrticity']       = {27, 46},
  ['ignite']             = {28, 138},

  ['energyball']         = {29, 169},
  ['travel']             = {30, 52},
  ['energyattack']       = {31, 168},
  ['firefist']           = {32, 48},
  ['tornado']            = {33, 53},
  ['strongfrost']        = {34, 161},
  ['earthattack']        = {35, 149},
  ['earthattack2']       = {36, 140},
  ['elf']                = {37, 127},
  ['deathattack']        = {38, 183},
  ['energyball1']        = {41, 125},
  ['divinecaldera']      = {40, 124},
  ['energyrush']         = {42, 163},
  ['divinemissile']      = {39, 122},
  ['energyrush2']        = {43, 164},
  ['eternalfire']        = {44, 120},
  ['icehand']            = {45, 142},
  ['icehand2']           = {46, 144},
  ['plant1']             = {47, 146},
  ['plant2']             = {48, 110},
  ['firearrow']          = {49, 188},
  ['icicle']             = {50, 186},
  ['energythunder']      = {51, 167},
  ['energythunder2']     = {52, 147},
  ['holyhand']           = {53, 125},
  ['deathhand']          = {54, 121},
  ['firehand']           = {55, 122},
  ['energyhand']         = {56, 120},
  ['bloodhand']          = {57, 126},
  ['poisonhand']         = {58, 129},
  ['icearrow']           = {59, 124},
  ['holycross']          = {60, 31},

  ['dragonshrine']       = {61, 9},
  ['firebolt']           = {62,  94},
  ['firetornado']        = {63,  8},
  ['dragonbreath']       = {64, 11},
  ['dragonstance']       = {65,  6},
  ['fireearth']          = {66,  2},
  ['bloodaxe']           = {67,  1},
  ['charge']             = {68,  5},
  ['firesoul']           = {69,  3},
  ['firestance']         = {70,  306},
  ['swordstance']        = {71,  164},
  ['nightwolf']          = {72,  105},
  ['holyarea']           = {73,  22},
  ['holysword']          = {74,  23},
  ['divineclock']        = {75, 24},
  ['sacredarea']         = {76,  17},
  ['penitence']          = {77, 21},
  ['holysmite']          = {78,  78},
  ['holyshot']           = {79,  77},
  ['markofdeath']        = {80,  81},
  ['holyslash']          = {81, 29},

  ['smite']              = {82,  28},
  ['shadowblade']        = {83,  86},

  ['arrowbarrage']       = {84,  187},

  ['barrel']             = {85,  181},
  ['daggers']            = {86,  85},
  ['arrowshots']         = {87,  182},
  ['partyshield']        = {88,  319},

  ['firedagger']         = {89, 90},
  ['backstab']           = {90,  84},
  ['arrowbreak']         = {91, 184},
  ['poisonshot']         = {92,  48},

  ['stealth']            = {93,  80},
  ['jump']               = {94, 83},
  ['arrowshot1']         = {95,  183},
  ['shadowexplode']      = {96,  74},

  ['zombiewall']         = {97, 61},
  ['shadowbarrage']      = {98, 38},

  ['minion']             = {99,  73},

  ['shadoweye']          = {100, 62},
  ['fear']               = {101,  63},
  ['bats']               = {103,  71},
  ['bloodpact']          = {104,  66},
  ['shadowskull']        = {105,  29},
  ['ghost']              = {106,  131},
  ['bloodmush']          = {107,  27},
  ['shadowbolts']        = {108,  64},
  ['nature']             = {109,  107},
  ['flower']             = {110,  151},
  ['chains']             = {111,  305},
  ['naturefist']         = {112,  100},
  ['frog']               = {113,  21},
  ['spikes']             = {114,  127},
  ['healhand']           = {115,  101},
  ['moon']               = {116,  111},
  ['thunders']           = {117,  161},
  ['roar']               = {118,  10},
  ['void']               = {119,  128},
  ['firestom']           = {120,  185},
  ['swordslash']         = {121,  160},
  ['hunterstance']       = {122,  12},
  ['kick']               = {123, 302},
  ['shield2']            = {124, 300},
  ['naturewrath']        = {125, 152},
  ['other']              = {126,  8},
  ['lightmagicmissile']  = {126,  7},
  ['haste']              = {102, 145},
  ['manashield']         = {3,  307},
  ['shield']             = {2,  301},
  ['ultimatehealing']    = {1,   200},
  ['intensehealing']     = {5,   165},
  ['lighthealing']       = {4,   312},
  
  ['guardianoflight']    = {151, 30},
  ['voidarcher']         = {162, 69},
  ['voidhealer']         = {163, 35},
  ['voidguard']          = {164, 68},
  ['blood_pact']         = {161, 66},
  ['party_vitality']     = {160, 67},
  ['aery_wrath']         = {163, 102},
  ['star_fall']          = {155, 103},
  ['falling_star']       = {154, 104},
  ['explosive_shots']    = {158, 182},
  ['destructive_shot']   = {157, 189},
  ['aspect_mastery']     = {156, 123},
  ['divine_punishment']  = {150, 20}
}

VocationNames = {
    [0] = 'None',
    [1] = 'Magician',
    [2] = 'Templar',
    [3] = 'Nightblade',
    [4] = 'Dragon Knight',
    [5] = 'Warlock',
    [6] = 'Stellar',
    [7] = 'Soul Weaver',
    [8] = 'Druid',
	[9] = 'Light Dancer',
	[10] = 'Archer',
}

SpellGroups = {
    [1] = 'Attack',
    [2] = 'Healing',
    [3] = 'Support',
    [4] = 'Special',
    [5] = 'Crippling',
    [6] = 'Focus',
    [7] = 'Ultimate Strikes',
    [8] = 'Great Beams',
    [9] = 'Bursts of Nature'
}

Spells = {}

function Spells.getClientId(spellName)
    print("getClientId: spellName =", spellName)
    local profile = Spells.getSpellProfileByName(spellName)

    local id = SpellInfo[profile][spellName].icon
    if not tonumber(id) and SpellIcons[id] then
        return SpellIcons[id][1]
    end
    return tonumber(id)
end


function Spells.getSpellByClientId(id)
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.id == id then
                return spell, profile, k
            end
        end
    end
    return nil
end

function Spells.getServerId(spellName)
    print("getServerId: spellName =", spellName)
    local profile = Spells.getSpellProfileByName(spellName)

    local id = SpellInfo[profile][spellName].icon
    if not tonumber(id) and SpellIcons[id] then
        return SpellIcons[id][2]
    end
    return tonumber(id)
end


function Spells.getSpellByName(name)
    print("getSpellByName: name =", name)
    local profile = Spells.getSpellProfileByName(name)
    if profile then
        return SpellInfo[profile][name]
    end
    print("getSpellByName: spell not found", name)
    return nil
end


function Spells.getSpellByWords(words)
    local words = words:lower():trim()
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.words == words then
                return spell, profile, k
            end
        end
    end
    return nil
end

function Spells.getSpellByIcon(iconId)
    print("getSpellByIcon: iconId =", iconId)
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.id == iconId then
                print("Found spell for iconId in profile:", profile, "spell:", spell)
                return spell, profile, k
            end
        end
    end
    print("spell not found for iconId:", iconId)
    return nil
end


function Spells.getSpellIconIds()
    local ids = {}
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            table.insert(ids, spell.id)
        end
    end
    return ids
end

function Spells.getSpellProfileById(id)
    print("getSpellProfileById: id =", id)
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.id == id then
                print("Found spell id in profile:", profile)
                return profile
            end
        end
    end
    print("spell id not found:", id)
    return nil
end


function Spells.getSpellProfileByWords(words)
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if spell.words == words then
                return profile
            end
        end
    end
    return nil
end

function Spells.getSpellProfileByName(spellName)
    print("getSpellProfileByName: spellName =", spellName)
    for profile, data in pairs(SpellInfo) do
        print("Checking profile:", profile)
        if table.findbykey(data, spellName:trim(), true) then
            print("Found spellName in profile:", profile)
            return profile
        end
    end
    print("spellName not found:", spellName)
    return nil
end


function Spells.getSpellsByVocationId(vocId)
    local spells = {}
    for profile, data in pairs(SpellInfo) do
        for k, spell in pairs(data) do
            if table.contains(spell.vocations, vocId) then
                table.insert(spells, spell)
            end
        end
    end
    return spells
end

function Spells.filterSpellsByGroups(spells, groups)
    local filtered = {}
    for v, spell in pairs(spells) do
        local spellGroups = Spells.getGroupIds(spell)
        if table.equals(spellGroups, groups) then
            table.insert(filtered, spell)
        end
    end
    return filtered
end

function Spells.getGroupIds(spell)
    local groups = {}
    for k, _ in pairs(spell.group) do
        table.insert(groups, k)
    end
    return groups
end

function Spells.getImageClip(id, profile)
    return (((id - 1) % 12) * SpelllistSettings[profile].iconSize.width) .. ' ' ..
               ((math.ceil(id / 12) - 1) * SpelllistSettings[profile].iconSize.height) .. ' ' ..
               SpelllistSettings[profile].iconSize.width .. ' ' .. SpelllistSettings[profile].iconSize.height
end

function Spells.getIconFileByProfile(profile)
    return SpelllistSettings[profile]['iconFile']
end
