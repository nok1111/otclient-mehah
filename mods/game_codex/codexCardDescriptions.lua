
-- Card Descriptions Database (Client-side)
-- This file contains all card metadata for UI display
-- Server only sends IDs, levels, and mechanical data

Codex.cardDescriptions = {
	[1] = {
		name = "The Salamander",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "salamander",
		descriptions = {
			[1] = "Strikes arc between foes - 3% chance to chain to 1 nearby enemy for 60% damage",
			[2] = "Strikes arc between foes - 3.7% chance to chain to 1 nearby enemy for 60% damage",
			[3] = "Strikes arc between foes - 4.4% chance to chain to 1 nearby enemy for 60% damage",
			[4] = "Strikes arc between foes - 5.1% chance to chain to 1 nearby enemy for 60% damage",
			[5] = "Strikes arc between foes - 5.8% chance to chain to 2 nearby enemies for 60% damage",
			[6] = "Strikes arc between foes - 6.5% chance to chain to 2 nearby enemies for 60% damage",
			[7] = "Strikes arc between foes - 7.2% chance to chain to 2 nearby enemies for 60% damage",
			[8] = "Strikes arc between foes - 7.9% chance to chain to 2 nearby enemies for 60% damage",
			[9] = "Strikes arc between foes - 8.6% chance to chain to 2 nearby enemies for 60% damage",
			[10] = "Strikes arc between foes - 9.3% chance to chain to 3 nearby enemies for 60% damage"
		}
	},
	[2] = {
		name = "Blood Echo",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "bloodecho",
		descriptions = {
			[1] = "Every wound you inflict echoes back as vitality - restore 2% of damage dealt as HP",
			[2] = "Every wound you inflict echoes back as vitality - restore 2.67% of damage dealt as HP",
			[3] = "Every wound you inflict echoes back as vitality - restore 3.34% of damage dealt as HP",
			[4] = "Every wound you inflict echoes back as vitality - restore 4.01% of damage dealt as HP",
			[5] = "Every wound you inflict echoes back as vitality - restore 4.68% of damage dealt as HP",
			[6] = "Every wound you inflict echoes back as vitality - restore 5.35% of damage dealt as HP",
			[7] = "Every wound you inflict echoes back as vitality - restore 6.02% of damage dealt as HP",
			[8] = "Every wound you inflict echoes back as vitality - restore 6.69% of damage dealt as HP",
			[9] = "Every wound you inflict echoes back as vitality - restore 7.36% of damage dealt as HP",
			[10] = "Every wound you inflict echoes back as vitality - restore 8.03% of damage dealt as HP"
		}
	},
	[3] = {
		name = "Critical Surge",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "criticalsurge",
		descriptions = {
			[1] = "Sharpen your killer instinct - gain +4% Critical Hit Chance",
			[2] = "Sharpen your killer instinct - gain +8% Critical Hit Chance",
			[3] = "Sharpen your killer instinct - gain +10% Critical Hit Chance",
			[4] = "Sharpen your killer instinct - gain +12% Critical Hit Chance",
			[5] = "Sharpen your killer instinct - gain +15% Critical Hit Chance",
			[6] = "Sharpen your killer instinct - gain +18% Critical Hit Chance",
			[7] = "Sharpen your killer instinct - gain +20% Critical Hit Chance",
			[8] = "Sharpen your killer instinct - gain +24% Critical Hit Chance",
			[9] = "Sharpen your killer instinct - gain +26% Critical Hit Chance",
			[10] = "Sharpen your killer instinct - gain +30% Critical Hit Chance"
		}
	},
	[4] = {
		name = "Executioner",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "executioner",
		descriptions = {
			[1] = "Each kill fuels your momentum - reduce all cooldowns by 100ms on kill",
			[2] = "Each kill fuels your momentum - reduce all cooldowns by 150ms on kill",
			[3] = "Each kill fuels your momentum - reduce all cooldowns by 200ms on kill",
			[4] = "Each kill fuels your momentum - reduce all cooldowns by 300ms on kill",
			[5] = "Each kill fuels your momentum - reduce all cooldowns by 500ms on kill",
			[6] = "Each kill fuels your momentum - reduce all cooldowns by 600ms on kill",
			[7] = "Each kill fuels your momentum - reduce all cooldowns by 800ms on kill",
			[8] = "Each kill fuels your momentum - reduce all cooldowns by 1000ms on kill",
			[9] = "Each kill fuels your momentum - reduce all cooldowns by 1200ms on kill",
			[10] = "Each kill fuels your momentum - reduce all cooldowns by 1500ms on kill"
		}
	},
	[5] = {
		name = "Golem",
		rarity = "common",
		trigger = "onDamageTaken",
		cardFrame = "golem",
		descriptions = {
			[1] = "Your skin hardens like living stone - reduce all damage taken by 4%",
			[2] = "Your skin hardens like living stone - reduce all damage taken by 5%",
			[3] = "Your skin hardens like living stone - reduce all damage taken by 6%",
			[4] = "Your skin hardens like living stone - reduce all damage taken by 8%",
			[5] = "Your skin hardens like living stone - reduce all damage taken by 10%",
			[6] = "Your skin hardens like living stone - reduce all damage taken by 12%",
			[7] = "Your skin hardens like living stone - reduce all damage taken by 14%",
			[8] = "Your skin hardens like living stone - reduce all damage taken by 16%",
			[9] = "Your skin hardens like living stone - reduce all damage taken by 18%",
			[10] = "Your skin hardens like living stone - reduce all damage taken by 20%"
		}
	},
	[6] = {
		name = "Water Elemental",
		rarity = "epic",
		trigger = "onDamageTaken",
		cardFrame = "water elemental",
		descriptions = {
			[1] = "Pain fuels your arcane reserves - 10% of damage taken is converted into mana",
			[2] = "Pain fuels your arcane reserves - 12% of damage taken is converted into mana",
			[3] = "Pain fuels your arcane reserves - 14% of damage taken is converted into mana",
			[4] = "Pain fuels your arcane reserves - 15% of damage taken is converted into mana",
			[5] = "Pain fuels your arcane reserves - 16% of damage taken is converted into mana",
			[6] = "Pain fuels your arcane reserves - 18% of damage taken is converted into mana",
			[7] = "Pain fuels your arcane reserves - 20% of damage taken is converted into mana",
			[8] = "Pain fuels your arcane reserves - 22% of damage taken is converted into mana",
			[9] = "Pain fuels your arcane reserves - 24% of damage taken is converted into mana",
			[10] = "Pain fuels your arcane reserves - 25% of damage taken is converted into mana"
		}
	},
	[7] = {
		name = "Ravenous Beast",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "ravenous beast",
		descriptions = {
			[1] = "The closer to death, the fiercer you become - deal +10% damage when below 25% HP",
			[2] = "The closer to death, the fiercer you become - deal +12% damage when below 28% HP",
			[3] = "The closer to death, the fiercer you become - deal +14% damage when below 30% HP",
			[4] = "The closer to death, the fiercer you become - deal +16% damage when below 32% HP",
			[5] = "The closer to death, the fiercer you become - deal +18% damage when below 34% HP",
			[6] = "The closer to death, the fiercer you become - deal +20% damage when below 36% HP",
			[7] = "The closer to death, the fiercer you become - deal +22% damage when below 38% HP",
			[8] = "The closer to death, the fiercer you become - deal +24% damage when below 40% HP",
			[9] = "The closer to death, the fiercer you become - deal +26% damage when below 42% HP",
			[10] = "The closer to death, the fiercer you become - deal +30% damage when below 45% HP"
		}
	},
	[8] = {
		name = "The Phoenix",
		rarity = "legendary",
		trigger = "onDeath",
		cardFrame = "the phoenix",
		descriptions = {
			[1] = "Rise from the ashes - cheat death and revive with 20% HP (180 min cooldown)",
			[2] = "Rise from the ashes - cheat death and revive with 25% HP (170 min cooldown)",
			[3] = "Rise from the ashes - cheat death and revive with 30% HP (160 min cooldown)",
			[4] = "Rise from the ashes - cheat death and revive with 35% HP (150 min cooldown)",
			[5] = "Rise from the ashes - cheat death and revive with 40% HP (140 min cooldown)",
			[6] = "Rise from the ashes - cheat death and revive with 50% HP (130 min cooldown)",
			[7] = "Rise from the ashes - cheat death and revive with 60% HP (120 min cooldown)",
			[8] = "Rise from the ashes - cheat death and revive with 70% HP (110 min cooldown)",
			[9] = "Rise from the ashes - cheat death and revive with 80% HP (100 min cooldown)",
			[10] = "Rise from the ashes - cheat death and revive with 90% HP (90 min cooldown)"
		}
	},
	[9] = {
		name = "The Witch",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "the witch",
		descriptions = {
			[1] = "Your mana pool deepens your arcane mastery - gain +2 magic level per 1000 max mana",
			[2] = "Your mana pool deepens your arcane mastery - gain +2 magic level per 950 max mana",
			[3] = "Your mana pool deepens your arcane mastery - gain +2 magic level per 950 max mana",
			[4] = "Your mana pool deepens your arcane mastery - gain +2 magic level per 900 max mana",
			[5] = "Your mana pool deepens your arcane mastery - gain +2 magic level per 850 max mana",
			[6] = "Your mana pool deepens your arcane mastery - gain +2 magic level per 800 max mana",
			[7] = "Your mana pool deepens your arcane mastery - gain +2 magic level per 750 max mana",
			[8] = "Your mana pool deepens your arcane mastery - gain +2 magic level per 700 max mana",
			[9] = "Your mana pool deepens your arcane mastery - gain +2 magic level per 650 max mana",
			[10] = "Your mana pool deepens your arcane mastery - gain +2 magic level per 600 max mana"
		}
	},
	[10] = {
		name = "The Behemoth",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "the behemoth",
		descriptions = {
			[1] = "Become an unstoppable colossus - grow 5% larger, gain +20% max HP and 5% life leech",
			[2] = "Become an unstoppable colossus - grow 10% larger, gain +25% max HP and 6% life leech",
			[3] = "Become an unstoppable colossus - grow 15% larger, gain +30% max HP and 7% life leech",
			[4] = "Become an unstoppable colossus - grow 20% larger, gain +35% max HP and 8% life leech",
			[5] = "Become an unstoppable colossus - grow 25% larger, gain +40% max HP and 10% life leech",
			[6] = "Become an unstoppable colossus - grow 30% larger, gain +45% max HP and 12% life leech",
			[7] = "Become an unstoppable colossus - grow 35% larger, gain +50% max HP and 14% life leech",
			[8] = "Become an unstoppable colossus - grow 40% larger, gain +55% max HP and 16% life leech",
			[9] = "Become an unstoppable colossus - grow 45% larger, gain +60% max HP and 18% life leech",
			[10] = "Become an unstoppable colossus - grow 50% larger, gain +65% max HP and 20% life leech"
		}
	},
	[11] = {
		name = "Guns Lover",
		rarity = "legendary",
		trigger = "onSpell",
		cardFrame = "guns lover",
		descriptions = {
			[1] = "Lock and load - gain +10% attack speed. Ranged attacks have a 5% chance to unleash a bullet barrage",
			[2] = "Lock and load - gain +12% attack speed. Ranged attacks have a 6% chance to unleash a bullet barrage",
			[3] = "Lock and load - gain +14% attack speed. Ranged attacks have a 8% chance to unleash a bullet barrage",
			[4] = "Lock and load - gain +16% attack speed. Ranged attacks have a 10% chance to unleash a bullet barrage",
			[5] = "Lock and load - gain +18% attack speed. Ranged attacks have a 12% chance to unleash a bullet barrage",
			[6] = "Lock and load - gain +20% attack speed. Ranged attacks have a 14% chance to unleash a bullet barrage",
			[7] = "Lock and load - gain +22% attack speed. Ranged attacks have a 16% chance to unleash a bullet barrage",
			[8] = "Lock and load - gain +24% attack speed. Ranged attacks have a 18% chance to unleash a bullet barrage",
			[9] = "Lock and load - gain +26% attack speed. Ranged attacks have a 20% chance to unleash a bullet barrage",
			[10] = "Lock and load - gain +28% attack speed. Ranged attacks have a 25% chance to unleash a bullet barrage"
		}
	},
	[12] = {
		name = "Goliath",
		rarity = "rare",
		trigger = "onSpell",
		cardFrame = "goliath",
		descriptions = {
			[1] = "Refuse to fall - when below 20% HP, every spell cast restores 1% of your max HP",
			[2] = "Refuse to fall - when below 20% HP, every spell cast restores 2% of your max HP",
			[3] = "Refuse to fall - when below 20% HP, every spell cast restores 3% of your max HP",
			[4] = "Refuse to fall - when below 20% HP, every spell cast restores 4% of your max HP",
			[5] = "Refuse to fall - when below 21% HP, every spell cast restores 5% of your max HP",
			[6] = "Refuse to fall - when below 22% HP, every spell cast restores 6% of your max HP",
			[7] = "Refuse to fall - when below 24% HP, every spell cast restores 7% of your max HP",
			[8] = "Refuse to fall - when below 26% HP, every spell cast restores 8% of your max HP",
			[9] = "Refuse to fall - when below 28% HP, every spell cast restores 9% of your max HP",
			[10] = "Refuse to fall - when below 30% HP, every spell cast restores 10% of your max HP"
		}
	},
	[13] = {
		name = "The Gunner",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "gunner",
		descriptions = {
			[1] = "Steady aim, deadly precision - gain +2% attack speed and +2% critical chance",
			[2] = "Steady aim, deadly precision - gain +4% attack speed and +4% critical chance",
			[3] = "Steady aim, deadly precision - gain +6% attack speed and +6% critical chance",
			[4] = "Steady aim, deadly precision - gain +8% attack speed and +8% critical chance",
			[5] = "Steady aim, deadly precision - gain +10% attack speed and +10% critical chance",
			[6] = "Steady aim, deadly precision - gain +12% attack speed and +12% critical chance",
			[7] = "Steady aim, deadly precision - gain +14% attack speed and +14% critical chance",
			[8] = "Steady aim, deadly precision - gain +16% attack speed and +16% critical chance",
			[9] = "Steady aim, deadly precision - gain +18% attack speed and +18% critical chance",
			[10] = "Steady aim, deadly precision - gain +20% attack speed and +20% critical chance"
		}
	},
	[14] = {
		name = "Soul Leech",
		rarity = "epic",
		trigger = "onKill",
		cardFrame = "soul leech",
		descriptions = {
			[1] = "Devour the essence of fallen enemies - restore 5% of your max HP and Mana on each kill",
			[2] = "Devour the essence of fallen enemies - restore 6% of your max HP and Mana on each kill",
			[3] = "Devour the essence of fallen enemies - restore 7% of your max HP and Mana on each kill",
			[4] = "Devour the essence of fallen enemies - restore 8% of your max HP and Mana on each kill",
			[5] = "Devour the essence of fallen enemies - restore 9% of your max HP and Mana on each kill",
			[6] = "Devour the essence of fallen enemies - restore 10% of your max HP and Mana on each kill",
			[7] = "Devour the essence of fallen enemies - restore 11% of your max HP and Mana on each kill",
			[8] = "Devour the essence of fallen enemies - restore 12% of your max HP and Mana on each kill",
			[9] = "Devour the essence of fallen enemies - restore 13% of your max HP and Mana on each kill",
			[10] = "Devour the essence of fallen enemies - restore 14% of your max HP and Mana on each kill"
		}
	},
	[15] = {
		name = "Carnage Presence",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "carnage presence",
		descriptions = {
			[1] = "Slain foes erupt in destruction - 5% chance on kill to trigger an explosion for 15% of target's max HP",
			[2] = "Slain foes erupt in destruction - 7% chance on kill to trigger an explosion for 16% of target's max HP",
			[3] = "Slain foes erupt in destruction - 9% chance on kill to trigger an explosion for 17% of target's max HP",
			[4] = "Slain foes erupt in destruction - 11% chance on kill to trigger an explosion for 18% of target's max HP",
			[5] = "Slain foes erupt in destruction - 13% chance on kill to trigger an explosion for 19% of target's max HP",
			[6] = "Slain foes erupt in destruction - 15% chance on kill to trigger an explosion for 20% of target's max HP",
			[7] = "Slain foes erupt in destruction - 17% chance on kill to trigger an explosion for 21% of target's max HP",
			[8] = "Slain foes erupt in destruction - 19% chance on kill to trigger an explosion for 22% of target's max HP",
			[9] = "Slain foes erupt in destruction - 21% chance on kill to trigger an explosion for 24% of target's max HP",
			[10] = "Slain foes erupt in destruction - 25% chance on kill to trigger an explosion for 25% of target's max HP"
		}
	},
	[16] = {
		name = "Blood is Fuel",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "bloodisfuel",
		descriptions = {
			[1] = "Sacrifice your blood to empower your spells - spells cost 2% max HP but deal +4% bonus damage",
			[2] = "Sacrifice your blood to empower your spells - spells cost 3% max HP but deal +5% bonus damage",
			[3] = "Sacrifice your blood to empower your spells - spells cost 4% max HP but deal +6% bonus damage",
			[4] = "Sacrifice your blood to empower your spells - spells cost 5% max HP but deal +7% bonus damage",
			[5] = "Sacrifice your blood to empower your spells - spells cost 6% max HP but deal +8% bonus damage",
			[6] = "Sacrifice your blood to empower your spells - spells cost 7% max HP but deal +9% bonus damage",
			[7] = "Sacrifice your blood to empower your spells - spells cost 8% max HP but deal +10% bonus damage",
			[8] = "Sacrifice your blood to empower your spells - spells cost 8% max HP but deal +11% bonus damage",
			[9] = "Sacrifice your blood to empower your spells - spells cost 8% max HP but deal +12% bonus damage",
			[10] = "Sacrifice your blood to empower your spells - spells cost 8% max HP but deal +15% bonus damage"
		}
	},
	[17] = {
		name = "The Necromancer",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "the necromancer",
		descriptions = {
			[1] = "Bend death to your will - slain enemies rise to fight for you for 2s, then detonate for 5% of their max HP",
			[2] = "Bend death to your will - slain enemies rise to fight for you for 3s, then detonate for 6% of their max HP",
			[3] = "Bend death to your will - slain enemies rise to fight for you for 4s, then detonate for 7% of their max HP",
			[4] = "Bend death to your will - slain enemies rise to fight for you for 5s, then detonate for 8% of their max HP",
			[5] = "Bend death to your will - slain enemies rise to fight for you for 6s, then detonate for 9% of their max HP",
			[6] = "Bend death to your will - slain enemies rise to fight for you for 7s, then detonate for 10% of their max HP",
			[7] = "Bend death to your will - slain enemies rise to fight for you for 8s, then detonate for 11% of their max HP",
			[8] = "Bend death to your will - slain enemies rise to fight for you for 9s, then detonate for 12% of their max HP",
			[9] = "Bend death to your will - slain enemies rise to fight for you for 10s, then detonate for 13% of their max HP",
			[10] = "Bend death to your will - slain enemies rise to fight for you for 10s, then detonate for 14% of their max HP"
		}
	},
	[18] = {
		name = "Glass Cannon",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "glass cannon",
		descriptions = {
			[1] = "Abandon defense for devastation - deal +5% damage, but suffer +5% damage taken",
			[2] = "Abandon defense for devastation - deal +8% damage, but suffer +8% damage taken",
			[3] = "Abandon defense for devastation - deal +11% damage, but suffer +11% damage taken",
			[4] = "Abandon defense for devastation - deal +14% damage, but suffer +14% damage taken",
			[5] = "Abandon defense for devastation - deal +17% damage, but suffer +17% damage taken",
			[6] = "Abandon defense for devastation - deal +20% damage, but suffer +20% damage taken",
			[7] = "Abandon defense for devastation - deal +23% damage, but suffer +23% damage taken",
			[8] = "Abandon defense for devastation - deal +26% damage, but suffer +26% damage taken",
			[9] = "Abandon defense for devastation - deal +29% damage, but suffer +29% damage taken",
			[10] = "Abandon defense for devastation - deal +32% damage, but suffer +32% damage taken"
		}
	},
	[19] = {
		name = "Megalodon",
		rarity = "common",
		trigger = "onKill",
		cardFrame = "megalodon",
		descriptions = {
			[1] = "Your kills strike terror into nearby foes - 10% chance on kill to send enemies into panic for 1s",
			[2] = "Your kills strike terror into nearby foes - 15% chance on kill to send enemies into panic for 1s",
			[3] = "Your kills strike terror into nearby foes - 20% chance on kill to send enemies into panic for 2s",
			[4] = "Your kills strike terror into nearby foes - 25% chance on kill to send enemies into panic for 2s",
			[5] = "Your kills strike terror into nearby foes - 30% chance on kill to send enemies into panic for 2s",
			[6] = "Your kills strike terror into nearby foes - 35% chance on kill to send enemies into panic for 2s",
			[7] = "Your kills strike terror into nearby foes - 40% chance on kill to send enemies into panic for 3s",
			[8] = "Your kills strike terror into nearby foes - 45% chance on kill to send enemies into panic for 3s",
			[9] = "Your kills strike terror into nearby foes - 50% chance on kill to send enemies into panic for 3s",
			[10] = "Your kills strike terror into nearby foes - 55% chance on kill to send enemies into panic for 3s"
		}
	},
	[20] = {
		name = "The Hydra",
		rarity = "legendary",
		trigger = "onDamageTaken",
		cardFrame = "the hydra",
		descriptions = {
			[1] = "Venomous strikes seep into the battlefield - 1% chance to poison nearby enemies and restore 1% max HP",
			[2] = "Venomous strikes seep into the battlefield - 2% chance to poison nearby enemies and restore 2% max HP",
			[3] = "Venomous strikes seep into the battlefield - 3% chance to poison nearby enemies and restore 3% max HP",
			[4] = "Venomous strikes seep into the battlefield - 4% chance to poison nearby enemies and restore 4% max HP",
			[5] = "Venomous strikes seep into the battlefield - 5% chance to poison nearby enemies and restore 5% max HP",
			[6] = "Venomous strikes seep into the battlefield - 6% chance to poison nearby enemies and restore 6% max HP",
			[7] = "Venomous strikes seep into the battlefield - 7% chance to poison nearby enemies and restore 7% max HP",
			[8] = "Venomous strikes seep into the battlefield - 8% chance to poison nearby enemies and restore 8% max HP",
			[9] = "Venomous strikes seep into the battlefield - 9% chance to poison nearby enemies and restore 9% max HP",
			[10] = "Venomous strikes seep into the battlefield - 10% chance to poison nearby enemies and restore 10% max HP"
		}
	},
	[21] = {
		name = "The Hammersword",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "hammersword",
		descriptions = {
			[1] = "Each melee strike builds raw power - gain +1% damage per stack. At 5 stacks, unleash a devastating shockwave",
			[2] = "Each melee strike builds raw power - gain +2% damage per stack. At 5 stacks, unleash a devastating shockwave",
			[3] = "Each melee strike builds raw power - gain +3% damage per stack. At 5 stacks, unleash a devastating shockwave",
			[4] = "Each melee strike builds raw power - gain +4% damage per stack. At 5 stacks, unleash a devastating shockwave",
			[5] = "Each melee strike builds raw power - gain +5% damage per stack. At 5 stacks, unleash a devastating shockwave",
			[6] = "Each melee strike builds raw power - gain +6% damage per stack. At 5 stacks, unleash a devastating shockwave",
			[7] = "Each melee strike builds raw power - gain +7% damage per stack. At 5 stacks, unleash a devastating shockwave",
			[8] = "Each melee strike builds raw power - gain +8% damage per stack. At 5 stacks, unleash a devastating shockwave",
			[9] = "Each melee strike builds raw power - gain +9% damage per stack. At 5 stacks, unleash a devastating shockwave",
			[10] = "Each melee strike builds raw power - gain +10% damage per stack. At 5 stacks, unleash a devastating shockwave"
		}
	},
	[22] = {
		name = "Final Symphony",
		rarity = "epic",
		trigger = "onLowHP",
		cardFrame = "final symphony",
		descriptions = {
			[1] = "On the edge of death, every strike resonates with destructive force - below 20% HP, attacks release shockwaves",
			[2] = "On the edge of death, every strike resonates with destructive force - below 23% HP, attacks release shockwaves",
			[3] = "On the edge of death, every strike resonates with destructive force - below 26% HP, attacks release shockwaves",
			[4] = "On the edge of death, every strike resonates with destructive force - below 29% HP, attacks release shockwaves",
			[5] = "On the edge of death, every strike resonates with destructive force - below 32% HP, attacks release shockwaves",
			[6] = "On the edge of death, every strike resonates with destructive force - below 35% HP, attacks release shockwaves",
			[7] = "On the edge of death, every strike resonates with destructive force - below 38% HP, attacks release shockwaves",
			[8] = "On the edge of death, every strike resonates with destructive force - below 41% HP, attacks release shockwaves",
			[9] = "On the edge of death, every strike resonates with destructive force - below 44% HP, attacks release shockwaves",
			[10] = "On the edge of death, every strike resonates with destructive force - below 47% HP, attacks release shockwaves"
		}
	},
	[23] = {
		name = "Mechagolem",
		rarity = "common",
		trigger = "onDamageTaken",
		cardFrame = "mechagolem",
		descriptions = {
			[1] = "Your mechanical shell retaliates - 5% chance to reflect 5% of damage taken as energy damage",
			[2] = "Your mechanical shell retaliates - 6% chance to reflect 6% of damage taken as energy damage",
			[3] = "Your mechanical shell retaliates - 7% chance to reflect 7% of damage taken as energy damage",
			[4] = "Your mechanical shell retaliates - 8% chance to reflect 8% of damage taken as energy damage",
			[5] = "Your mechanical shell retaliates - 9% chance to reflect 9% of damage taken as energy damage",
			[6] = "Your mechanical shell retaliates - 10% chance to reflect 10% of damage taken as energy damage",
			[7] = "Your mechanical shell retaliates - 11% chance to reflect 11% of damage taken as energy damage",
			[8] = "Your mechanical shell retaliates - 12% chance to reflect 12% of damage taken as energy damage",
			[9] = "Your mechanical shell retaliates - 13% chance to reflect 13% of damage taken as energy damage",
			[10] = "Your mechanical shell retaliates - 14% chance to reflect 14% of damage taken as energy damage"
		}
	},
	[24] = {
		name = "The Slime",
		rarity = "epic",
		trigger = "onDamageTaken",
		cardFrame = "slime",
		descriptions = {
			[1] = "Absorb the impact and regenerate - 1% of damage taken converts into healing over time",
			[2] = "Absorb the impact and regenerate - 2% of damage taken converts into healing over time",
			[3] = "Absorb the impact and regenerate - 3% of damage taken converts into healing over time",
			[4] = "Absorb the impact and regenerate - 4% of damage taken converts into healing over time",
			[5] = "Absorb the impact and regenerate - 5% of damage taken converts into healing over time",
			[6] = "Absorb the impact and regenerate - 6% of damage taken converts into healing over time",
			[7] = "Absorb the impact and regenerate - 7% of damage taken converts into healing over time",
			[8] = "Absorb the impact and regenerate - 8% of damage taken converts into healing over time",
			[9] = "Absorb the impact and regenerate - 9% of damage taken converts into healing over time",
			[10] = "Absorb the impact and regenerate - 10% of damage taken converts into healing over time"
		}
	},
	[25] = {
		name = "The Child",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the child",
		descriptions = {
			[1] = "A curious mind learns faster - gain +1% bonus experience from all monsters",
			[2] = "A curious mind learns faster - gain +2% bonus experience from all monsters",
			[3] = "A curious mind learns faster - gain +3% bonus experience from all monsters",
			[4] = "A curious mind learns faster - gain +4% bonus experience from all monsters",
			[5] = "A curious mind learns faster - gain +5% bonus experience from all monsters",
			[6] = "A curious mind learns faster - gain +6% bonus experience from all monsters",
			[7] = "A curious mind learns faster - gain +7% bonus experience from all monsters",
			[8] = "A curious mind learns faster - gain +8% bonus experience from all monsters",
			[9] = "A curious mind learns faster - gain +9% bonus experience from all monsters",
			[10] = "A curious mind learns faster - gain +10% bonus experience from all monsters"
		}
	},
	[26] = {
		name = "Undine",
		rarity = "rare",
		trigger = "onHeal",
		cardFrame = "undine",
		descriptions = {
			[1] = "The waters bless your healing touch - 5% chance for your heals to surge with double potency",
			[2] = "The waters bless your healing touch - 10% chance for your heals to surge with double potency",
			[3] = "The waters bless your healing touch - 15% chance for your heals to surge with double potency",
			[4] = "The waters bless your healing touch - 20% chance for your heals to surge with double potency",
			[5] = "The waters bless your healing touch - 25% chance for your heals to surge with double potency",
			[6] = "The waters bless your healing touch - 30% chance for your heals to surge with double potency",
			[7] = "The waters bless your healing touch - 35% chance for your heals to surge with double potency",
			[8] = "The waters bless your healing touch - 40% chance for your heals to surge with double potency",
			[9] = "The waters bless your healing touch - 45% chance for your heals to surge with double potency",
			[10] = "The waters bless your healing touch - 50% chance for your heals to surge with double potency"
		}
	},
	[27] = {
		name = "The Elf",
		rarity = "common",
		trigger = "onHeal",
		cardFrame = "the elf",
		descriptions = {
			[1] = "Nature's harmony flows through you - every heal also restores 1% of your max mana",
			[2] = "Nature's harmony flows through you - every heal also restores 2% of your max mana",
			[3] = "Nature's harmony flows through you - every heal also restores 3% of your max mana",
			[4] = "Nature's harmony flows through you - every heal also restores 4% of your max mana",
			[5] = "Nature's harmony flows through you - every heal also restores 5% of your max mana",
			[6] = "Nature's harmony flows through you - every heal also restores 6% of your max mana",
			[7] = "Nature's harmony flows through you - every heal also restores 7% of your max mana",
			[8] = "Nature's harmony flows through you - every heal also restores 8% of your max mana",
			[9] = "Nature's harmony flows through you - every heal also restores 9% of your max mana",
			[10] = "Nature's harmony flows through you - every heal also restores 10% of your max mana"
		}
	},
	[28] = {
		name = "Archangel",
		rarity = "common",
		trigger = "onHeal",
		cardFrame = "archangel",
		descriptions = {
			[1] = "Your divine healing scorches the wicked - healing allies smites nearby enemies for 5% of the healing done",
			[2] = "Your divine healing scorches the wicked - healing allies smites nearby enemies for 8% of the healing done",
			[3] = "Your divine healing scorches the wicked - healing allies smites nearby enemies for 10% of the healing done",
			[4] = "Your divine healing scorches the wicked - healing allies smites nearby enemies for 12% of the healing done",
			[5] = "Your divine healing scorches the wicked - healing allies smites nearby enemies for 14% of the healing done",
			[6] = "Your divine healing scorches the wicked - healing allies smites nearby enemies for 16% of the healing done",
			[7] = "Your divine healing scorches the wicked - healing allies smites nearby enemies for 18% of the healing done",
			[8] = "Your divine healing scorches the wicked - healing allies smites nearby enemies for 20% of the healing done",
			[9] = "Your divine healing scorches the wicked - healing allies smites nearby enemies for 22% of the healing done",
			[10] = "Your divine healing scorches the wicked - healing allies smites nearby enemies for 24% of the healing done"
		}
	},
	[29] = {
		name = "Blood Link",
		rarity = "common",
		trigger = "onHeal",
		cardFrame = "blood link",
		descriptions = {
			[1] = "Your life force resonates with allies - healing echoes to a nearby party member for 10% of the amount healed",
			[2] = "Your life force resonates with allies - healing echoes to a nearby party member for 15% of the amount healed",
			[3] = "Your life force resonates with allies - healing echoes to a nearby party member for 20% of the amount healed",
			[4] = "Your life force resonates with allies - healing echoes to a nearby party member for 25% of the amount healed",
			[5] = "Your life force resonates with allies - healing echoes to a nearby party member for 30% of the amount healed",
			[6] = "Your life force resonates with allies - healing echoes to a nearby party member for 35% of the amount healed",
			[7] = "Your life force resonates with allies - healing echoes to a nearby party member for 40% of the amount healed",
			[8] = "Your life force resonates with allies - healing echoes to a nearby party member for 45% of the amount healed",
			[9] = "Your life force resonates with allies - healing echoes to a nearby party member for 50% of the amount healed",
			[10] = "Your life force resonates with allies - healing echoes to a nearby party member for 55% of the amount healed"
		}
	},
	[30] = {
		name = "The Naga",
		rarity = "epic",
		trigger = "onHeal",
		cardFrame = "the naga",
		descriptions = {
			[1] = "Your restorative magic corrupts nearby foes - healing unleashes venom for 3s, dealing 5% of healing per second",
			[2] = "Your restorative magic corrupts nearby foes - healing unleashes venom for 3s, dealing 7% of healing per second",
			[3] = "Your restorative magic corrupts nearby foes - healing unleashes venom for 3s, dealing 9% of healing per second",
			[4] = "Your restorative magic corrupts nearby foes - healing unleashes venom for 3s, dealing 11% of healing per second",
			[5] = "Your restorative magic corrupts nearby foes - healing unleashes venom for 3s, dealing 13% of healing per second",
			[6] = "Your restorative magic corrupts nearby foes - healing unleashes venom for 3s, dealing 15% of healing per second",
			[7] = "Your restorative magic corrupts nearby foes - healing unleashes venom for 3s, dealing 17% of healing per second",
			[8] = "Your restorative magic corrupts nearby foes - healing unleashes venom for 3s, dealing 19% of healing per second",
			[9] = "Your restorative magic corrupts nearby foes - healing unleashes venom for 3s, dealing 21% of healing per second",
			[10] = "Your restorative magic corrupts nearby foes - healing unleashes venom for 3s, dealing 23% of healing per second"
		}
	},
	[31] = {
		name = "The Dragon",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "the dragon",
		descriptions = {
			[1] = "Build Dragon's Fury with each strike (max 5). At full stacks, unleash a devastating fire wave dealing 150% damage",
			[2] = "Build Dragon's Fury with each strike (max 5). At full stacks, unleash a devastating fire wave dealing 175% damage",
			[3] = "Build Dragon's Fury with each strike (max 5). At full stacks, unleash a devastating fire wave dealing 200% damage",
			[4] = "Build Dragon's Fury with each strike (max 5). At full stacks, unleash a devastating fire wave dealing 225% damage",
			[5] = "Build Dragon's Fury with each strike (max 5). At full stacks, unleash a devastating fire wave dealing 250% damage",
			[6] = "Build Dragon's Fury with each strike (max 5). At full stacks, unleash a devastating fire wave dealing 275% damage",
			[7] = "Build Dragon's Fury with each strike (max 5). At full stacks, unleash a devastating fire wave dealing 300% damage",
			[8] = "Build Dragon's Fury with each strike (max 5). At full stacks, unleash a devastating fire wave dealing 325% damage",
			[9] = "Build Dragon's Fury with each strike (max 5). At full stacks, unleash a devastating fire wave dealing 350% damage",
			[10] = "Build Dragon's Fury with each strike (max 5). At full stacks, unleash a devastating fire wave dealing 400% damage"
		}
	},
	[32] = {
		name = "Pyromancer",
		rarity = "common",
		trigger = "onSpell",
		cardFrame = "pyromancer",
		descriptions = {
			[1] = "Your spells ignite the ground beneath your enemies - 5% chance to conjure a scorching fire field for 4s",
			[2] = "Your spells ignite the ground beneath your enemies - 6% chance to conjure a scorching fire field for 4s",
			[3] = "Your spells ignite the ground beneath your enemies - 7% chance to conjure a scorching fire field for 4s",
			[4] = "Your spells ignite the ground beneath your enemies - 8% chance to conjure a scorching fire field for 4s",
			[5] = "Your spells ignite the ground beneath your enemies - 9% chance to conjure a scorching fire field for 4s",
			[6] = "Your spells ignite the ground beneath your enemies - 10% chance to conjure a scorching fire field for 4s",
			[7] = "Your spells ignite the ground beneath your enemies - 11% chance to conjure a scorching fire field for 4s",
			[8] = "Your spells ignite the ground beneath your enemies - 12% chance to conjure a scorching fire field for 4s",
			[9] = "Your spells ignite the ground beneath your enemies - 13% chance to conjure a scorching fire field for 4s",
			[10] = "Your spells ignite the ground beneath your enemies - 15% chance to conjure a scorching fire field for 4s"
		}
	},
	[33] = {
		name = "Dragon Lord",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "dragon lord",
		descriptions = {
			[1] = "Command the dragon bloodline - for each dragon card equipped: +1% crit, +3% max HP, +3% max MP, +1% damage",
			[2] = "Command the dragon bloodline - for each dragon card equipped: +2% crit, +4% max HP, +4% max MP, +2% damage",
			[3] = "Command the dragon bloodline - for each dragon card equipped: +3% crit, +5% max HP, +5% max MP, +3% damage",
			[4] = "Command the dragon bloodline - for each dragon card equipped: +4% crit, +6% max HP, +6% max MP, +4% damage",
			[5] = "Command the dragon bloodline - for each dragon card equipped: +5% crit, +7% max HP, +7% max MP, +5% damage",
			[6] = "Command the dragon bloodline - for each dragon card equipped: +6% crit, +8% max HP, +8% max MP, +6% damage",
			[7] = "Command the dragon bloodline - for each dragon card equipped: +7% crit, +9% max HP, +9% max MP, +7% damage",
			[8] = "Command the dragon bloodline - for each dragon card equipped: +8% crit, +10% max HP, +10% max MP, +8% damage",
			[9] = "Command the dragon bloodline - for each dragon card equipped: +9% crit, +11% max HP, +11% max MP, +9% damage",
			[10] = "Command the dragon bloodline - for each dragon card equipped: +10% crit, +12% max HP, +12% max MP, +10% damage"
		}
	},
	[34] = {
		name = "Essence Reaver",
		rarity = "common",
		trigger = "passive",
		cardFrame = "essence reaver",
		descriptions = {
			[1] = "Extract hidden power from your fallen prey - +5% chance to harvest essences from monsters and elites",
			[2] = "Extract hidden power from your fallen prey - +7% chance to harvest essences from monsters and elites",
			[3] = "Extract hidden power from your fallen prey - +9% chance to harvest essences from monsters and elites",
			[4] = "Extract hidden power from your fallen prey - +11% chance to harvest essences from monsters and elites",
			[5] = "Extract hidden power from your fallen prey - +13% chance to harvest essences from monsters and elites",
			[6] = "Extract hidden power from your fallen prey - +15% chance to harvest essences from monsters and elites",
			[7] = "Extract hidden power from your fallen prey - +18% chance to harvest essences from monsters and elites",
			[8] = "Extract hidden power from your fallen prey - +21% chance to harvest essences from monsters and elites",
			[9] = "Extract hidden power from your fallen prey - +24% chance to harvest essences from monsters and elites",
			[10] = "Extract hidden power from your fallen prey - +28% chance to harvest essences from monsters and elites"
		}
	},
	[35] = {
		name = "Frost Dragon",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "frost dragon",
		descriptions = {
			[1] = "Unleash the frozen wrath - 6% chance to engulf enemies in a blizzard for 20% ice damage and -10% speed",
			[2] = "Unleash the frozen wrath - 8% chance to engulf enemies in a blizzard for 25% ice damage and -15% speed",
			[3] = "Unleash the frozen wrath - 10% chance to engulf enemies in a blizzard for 30% ice damage and -20% speed",
			[4] = "Unleash the frozen wrath - 12% chance to engulf enemies in a blizzard for 35% ice damage and -25% speed",
			[5] = "Unleash the frozen wrath - 14% chance to engulf enemies in a blizzard for 40% ice damage and -30% speed",
			[6] = "Unleash the frozen wrath - 16% chance to engulf enemies in a blizzard for 45% ice damage and -35% speed",
			[7] = "Unleash the frozen wrath - 18% chance to engulf enemies in a blizzard for 50% ice damage and -40% speed",
			[8] = "Unleash the frozen wrath - 20% chance to engulf enemies in a blizzard for 55% ice damage and -45% speed",
			[9] = "Unleash the frozen wrath - 23% chance to engulf enemies in a blizzard for 60% ice damage and -50% speed",
			[10] = "Unleash the frozen wrath - 26% chance to engulf enemies in a blizzard for 70% ice damage and -55% speed"
		}
	},
	[36] = {
		name = "Blossom Dragon",
		rarity = "epic",
		trigger = "onHealingSpell",
		cardFrame = "blossom dragon",
		descriptions = {
			[1] = "Nature's duality blooms - every 4th healing spell erupts in a 3x3 energy blast and restores 5% max HP",
			[2] = "Nature's duality blooms - every 4th healing spell erupts in a 3x3 energy blast (90%) and restores 6% max HP",
			[3] = "Nature's duality blooms - every 4th healing spell erupts in a 3x3 energy blast (100%) and restores 7% max HP",
			[4] = "Nature's duality blooms - every 4th healing spell erupts in a 3x3 energy blast (110%) and restores 8% max HP",
			[5] = "Nature's duality blooms - every 4th healing spell erupts in a 3x3 energy blast (120%) and restores 9% max HP",
			[6] = "Nature's duality blooms - every 4th healing spell erupts in a 3x3 energy blast (130%) and restores 10% max HP",
			[7] = "Nature's duality blooms - every 4th healing spell erupts in a 3x3 energy blast (140%) and restores 11% max HP",
			[8] = "Nature's duality blooms - every 4th healing spell erupts in a 3x3 energy blast (150%) and restores 12% max HP",
			[9] = "Nature's duality blooms - every 4th healing spell erupts in a 3x3 energy blast (160%) and restores 13% max HP",
			[10] = "Nature's duality blooms - every 4th healing spell erupts in a 3x3 energy blast (180%) and restores 15% max HP"
		}
	},
	[37] = {
		name = "Scorpion",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "scorpion",
		descriptions = {
			[1] = "Your strikes carry lethal venom - 20% chance to inject deadly poison dealing 50% damage per second for 5s",
			[2] = "Your strikes carry lethal venom - 20% chance to inject deadly poison dealing 60% damage per second for 5s",
			[3] = "Your strikes carry lethal venom - 20% chance to inject deadly poison dealing 70% damage per second for 5s",
			[4] = "Your strikes carry lethal venom - 20% chance to inject deadly poison dealing 80% damage per second for 5s",
			[5] = "Your strikes carry lethal venom - 20% chance to inject deadly poison dealing 90% damage per second for 5s",
			[6] = "Your strikes carry lethal venom - 20% chance to inject deadly poison dealing 100% damage per second for 5s",
			[7] = "Your strikes carry lethal venom - 20% chance to inject deadly poison dealing 110% damage per second for 5s",
			[8] = "Your strikes carry lethal venom - 20% chance to inject deadly poison dealing 120% damage per second for 5s",
			[9] = "Your strikes carry lethal venom - 20% chance to inject deadly poison dealing 130% damage per second for 5s",
			[10] = "Your strikes carry lethal venom - 20% chance to inject deadly poison dealing 140% damage per second for 5s"
		}
	},
	[38] = {
		name = "The Viper",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "the viper",
		descriptions = {
			[1] = "Your earth and poison magic strike with serpentine fangs - bonus poison damage scaling with level (x0.22)",
			[2] = "Your earth and poison magic strike with serpentine fangs - bonus poison damage scaling with level (x0.22)",
			[3] = "Your earth and poison magic strike with serpentine fangs - bonus poison damage scaling with level (x0.22)",
			[4] = "Your earth and poison magic strike with serpentine fangs - bonus poison damage scaling with level (x0.22)",
			[5] = "Your earth and poison magic strike with serpentine fangs - bonus poison damage scaling with level (x0.22)",
			[6] = "Your earth and poison magic strike with serpentine fangs - bonus poison damage scaling with level (x0.22)",
			[7] = "Your earth and poison magic strike with serpentine fangs - bonus poison damage scaling with level (x0.22)",
			[8] = "Your earth and poison magic strike with serpentine fangs - bonus poison damage scaling with level (x0.22)",
			[9] = "Your earth and poison magic strike with serpentine fangs - bonus poison damage scaling with level (x0.22)",
			[10] = "Your earth and poison magic strike with serpentine fangs - bonus poison damage scaling with level (x0.22)"
		}
	},
	[39] = {
		name = "Zeus",
		rarity = "common",
		trigger = "onSpell",
		cardFrame = "zeus",
		descriptions = {
			[1] = "Channel the storm god's wrath - every 10th spell calls down lightning on all nearby enemies for 120% energy damage",
			[2] = "Channel the storm god's wrath - every 10th spell calls down lightning on all nearby enemies for 135% energy damage",
			[3] = "Channel the storm god's wrath - every 10th spell calls down lightning on all nearby enemies for 150% energy damage",
			[4] = "Channel the storm god's wrath - every 10th spell calls down lightning on all nearby enemies for 165% energy damage",
			[5] = "Channel the storm god's wrath - every 10th spell calls down lightning on all nearby enemies for 180% energy damage",
			[6] = "Channel the storm god's wrath - every 10th spell calls down lightning on all nearby enemies for 200% energy damage",
			[7] = "Channel the storm god's wrath - every 10th spell calls down lightning on all nearby enemies for 220% energy damage",
			[8] = "Channel the storm god's wrath - every 10th spell calls down lightning on all nearby enemies for 240% energy damage",
			[9] = "Channel the storm god's wrath - every 10th spell calls down lightning on all nearby enemies for 260% energy damage",
			[10] = "Channel the storm god's wrath - every 10th spell calls down lightning on all nearby enemies for 300% energy damage"
		}
	},
	[40] = {
		name = "Svarog",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "svarog",
		descriptions = {
			[1] = "The forge god empowers your flames - each kill grants +3% fire damage (max 3 stacks, fades after 10s without a kill)",
			[2] = "The forge god empowers your flames - each kill grants +3.5% fire damage (max 3 stacks, fades after 10s without a kill)",
			[3] = "The forge god empowers your flames - each kill grants +4% fire damage (max 3 stacks, fades after 10s without a kill)",
			[4] = "The forge god empowers your flames - each kill grants +4.5% fire damage (max 4 stacks, fades after 10s without a kill)",
			[5] = "The forge god empowers your flames - each kill grants +5% fire damage (max 4 stacks, fades after 10s without a kill)",
			[6] = "The forge god empowers your flames - each kill grants +5.5% fire damage (max 4 stacks, fades after 10s without a kill)",
			[7] = "The forge god empowers your flames - each kill grants +6% fire damage (max 4 stacks, fades after 10s without a kill)",
			[8] = "The forge god empowers your flames - each kill grants +6.5% fire damage (max 4 stacks, fades after 10s without a kill)",
			[9] = "The forge god empowers your flames - each kill grants +7% fire damage (max 4 stacks, fades after 10s without a kill)",
			[10] = "The forge god empowers your flames - each kill grants +7.5% fire damage (max 5 stacks, fades after 10s without a kill)"
		}
	},
	[41] = {
		name = "Veles",
		rarity = "epic",
		trigger = "onHit",
		cardFrame = "veles",
		descriptions = {
			[1] = "The earth god answers your call - 8% chance on earth damage to summon a line of devastating earth spikes",
			[2] = "The earth god answers your call - 10% chance on earth damage to summon a line of devastating earth spikes",
			[3] = "The earth god answers your call - 12% chance on earth damage to summon a line of devastating earth spikes",
			[4] = "The earth god answers your call - 14% chance on earth damage to summon a line of devastating earth spikes",
			[5] = "The earth god answers your call - 16% chance on earth damage to summon a line of devastating earth spikes",
			[6] = "The earth god answers your call - 18% chance on earth damage to summon a line of devastating earth spikes",
			[7] = "The earth god answers your call - 20% chance on earth damage to summon a line of devastating earth spikes",
			[8] = "The earth god answers your call - 23% chance on earth damage to summon a line of devastating earth spikes",
			[9] = "The earth god answers your call - 26% chance on earth damage to summon a line of devastating earth spikes",
			[10] = "The earth god answers your call - 30% chance on earth damage to summon a line of devastating earth spikes"
		}
	},
	[42] = {
		name = "Yacy",
		rarity = "epic",
		trigger = "onHealingSpell",
		cardFrame = "yacy",
		descriptions = {
			[1] = "Balance between light and shadow - healing spells release 50% AoE damage, damage spells restore 3% of max mana to nearby allies",
			[2] = "Balance between light and shadow - healing spells release 55% AoE damage, damage spells restore 3% of max mana to nearby allies",
			[3] = "Balance between light and shadow - healing spells release 60% AoE damage, damage spells restore 3% of max mana to nearby allies",
			[4] = "Balance between light and shadow - healing spells release 65% AoE damage, damage spells restore 3% of max mana to nearby allies",
			[5] = "Balance between light and shadow - healing spells release 70% AoE damage, damage spells restore 3% of max mana to nearby allies",
			[6] = "Balance between light and shadow - healing spells release 75% AoE damage, damage spells restore 3% of max mana to nearby allies",
			[7] = "Balance between light and shadow - healing spells release 80% AoE damage, damage spells restore 3% of max mana to nearby allies",
			[8] = "Balance between light and shadow - healing spells release 85% AoE damage, damage spells restore 3% of max mana to nearby allies",
			[9] = "Balance between light and shadow - healing spells release 90% AoE damage, damage spells restore 3% of max mana to nearby allies",
			[10] = "Balance between light and shadow - healing spells release 95% AoE damage, damage spells restore 3% of max mana to nearby allies"
		}
	},
	[43] = {
		name = "Quetzalcoatl",
		rarity = "legendary",
		trigger = "onCrit",
		cardFrame = "quetzalcoatl",
		descriptions = {
			[1] = "Critical hits summon the feathered serpent's wrath - launch 1 homing missile at nearby enemies (2s cooldown)",
			[2] = "Critical hits summon the feathered serpent's wrath - launch 2 homing missiles at nearby enemies (2s cooldown)",
			[3] = "Critical hits summon the feathered serpent's wrath - launch 3 homing missiles at nearby enemies (2s cooldown)",
			[4] = "Critical hits summon the feathered serpent's wrath - launch 4 homing missiles at nearby enemies (2s cooldown)",
			[5] = "Critical hits summon the feathered serpent's wrath - launch 5 homing missiles at nearby enemies (2s cooldown)",
			[6] = "Critical hits summon the feathered serpent's wrath - launch 6 homing missiles at nearby enemies (2s cooldown)",
			[7] = "Critical hits summon the feathered serpent's wrath - launch 7 homing missiles at nearby enemies (2s cooldown)",
			[8] = "Critical hits summon the feathered serpent's wrath - launch 8 homing missiles at nearby enemies (2s cooldown)",
			[9] = "Critical hits summon the feathered serpent's wrath - launch 9 homing missiles at nearby enemies (2s cooldown)",
			[10] = "Critical hits summon the feathered serpent's wrath - launch 10 homing missiles at nearby enemies (2s cooldown)"
		}
	},
	[44] = {
		name = "The Obelisk",
		rarity = "common",
		trigger = "onStandStill",
		cardFrame = "the obelisk",
		descriptions = {
			[1] = "Root yourself like an ancient monolith - standing still for 3s reduces physical damage taken by 8%",
			[2] = "Root yourself like an ancient monolith - standing still for 3s reduces physical damage taken by 10%",
			[3] = "Root yourself like an ancient monolith - standing still for 3s reduces physical damage taken by 12%",
			[4] = "Root yourself like an ancient monolith - standing still for 3s reduces physical damage taken by 14%",
			[5] = "Root yourself like an ancient monolith - standing still for 3s reduces physical damage taken by 16%",
			[6] = "Root yourself like an ancient monolith - standing still for 3s reduces physical damage taken by 18%",
			[7] = "Root yourself like an ancient monolith - standing still for 3s reduces physical damage taken by 20%",
			[8] = "Root yourself like an ancient monolith - standing still for 3s reduces physical damage taken by 23%",
			[9] = "Root yourself like an ancient monolith - standing still for 3s reduces physical damage taken by 26%",
			[10] = "Root yourself like an ancient monolith - standing still for 3s reduces physical damage taken by 30%"
		}
	},
	[45] = {
		name = "The Bull",
		rarity = "common",
		trigger = "onDash",
		cardFrame = "the bull",
		descriptions = {
			[1] = "Charge with seismic fury - your dash and teleport spells leave an earthquake trail dealing 120% of your level as earth damage",
			[2] = "Charge with seismic fury - your dash and teleport spells leave an earthquake trail dealing 135% of your level as earth damage",
			[3] = "Charge with seismic fury - your dash and teleport spells leave an earthquake trail dealing 150% of your level as earth damage",
			[4] = "Charge with seismic fury - your dash and teleport spells leave an earthquake trail dealing 165% of your level as earth damage",
			[5] = "Charge with seismic fury - your dash and teleport spells leave an earthquake trail dealing 180% of your level as earth damage",
			[6] = "Charge with seismic fury - your dash and teleport spells leave an earthquake trail dealing 200% of your level as earth damage",
			[7] = "Charge with seismic fury - your dash and teleport spells leave an earthquake trail dealing 220% of your level as earth damage",
			[8] = "Charge with seismic fury - your dash and teleport spells leave an earthquake trail dealing 240% of your level as earth damage",
			[9] = "Charge with seismic fury - your dash and teleport spells leave an earthquake trail dealing 260% of your level as earth damage",
			[10] = "Charge with seismic fury - your dash and teleport spells leave an earthquake trail dealing 300% of your level as earth damage"
		}
	},
	[46] = {
		name = "The Dwarf",
		rarity = "common",
		trigger = "onDamageTaken",
		cardFrame = "the dwarf",
		descriptions = {
			[1] = "Dwarven resilience kicks in - when HP drops below 40%, instantly recover 15% max HP and gain a burst of speed for 5s (60s cooldown)",
			[2] = "Dwarven resilience kicks in - when HP drops below 40%, instantly recover 20% max HP and gain a burst of speed for 5s (60s cooldown)",
			[3] = "Dwarven resilience kicks in - when HP drops below 40%, instantly recover 25% max HP and gain a burst of speed for 5s (60s cooldown)",
			[4] = "Dwarven resilience kicks in - when HP drops below 40%, instantly recover 30% max HP and gain a burst of speed for 5s (60s cooldown)",
			[5] = "Dwarven resilience kicks in - when HP drops below 40%, instantly recover 35% max HP and gain a burst of speed for 5s (60s cooldown)",
			[6] = "Dwarven resilience kicks in - when HP drops below 40%, instantly recover 40% max HP and gain a burst of speed for 5s (60s cooldown)",
			[7] = "Dwarven resilience kicks in - when HP drops below 40%, instantly recover 45% max HP and gain a burst of speed for 5s (60s cooldown)",
			[8] = "Dwarven resilience kicks in - when HP drops below 40%, instantly recover 50% max HP and gain a burst of speed for 5s (60s cooldown)",
			[9] = "Dwarven resilience kicks in - when HP drops below 40%, instantly recover 55% max HP and gain a burst of speed for 5s (60s cooldown)",
			[10] = "Dwarven resilience kicks in - when HP drops below 40%, instantly recover 60% max HP and gain a burst of speed for 5s (60s cooldown)"
		}
	},
	[47] = {
		name = "The Skeleton",
		rarity = "common",
		trigger = "onDamageTaken",
		cardFrame = "the skeleton",
		descriptions = {
			[1] = "Your bones absorb the blow - 3% chance to nullify a physical attack, reducing it to just 1 damage (15s cooldown)",
			[2] = "Your bones absorb the blow - 4% chance to nullify a physical attack, reducing it to just 1 damage (15s cooldown)",
			[3] = "Your bones absorb the blow - 5% chance to nullify a physical attack, reducing it to just 1 damage (15s cooldown)",
			[4] = "Your bones absorb the blow - 6% chance to nullify a physical attack, reducing it to just 1 damage (15s cooldown)",
			[5] = "Your bones absorb the blow - 7% chance to nullify a physical attack, reducing it to just 1 damage (15s cooldown)",
			[6] = "Your bones absorb the blow - 8% chance to nullify a physical attack, reducing it to just 1 damage (15s cooldown)",
			[7] = "Your bones absorb the blow - 9% chance to nullify a physical attack, reducing it to just 1 damage (15s cooldown)",
			[8] = "Your bones absorb the blow - 10% chance to nullify a physical attack, reducing it to just 1 damage (15s cooldown)",
			[9] = "Your bones absorb the blow - 12% chance to nullify a physical attack, reducing it to just 1 damage (15s cooldown)",
			[10] = "Your bones absorb the blow - 15% chance to nullify a physical attack, reducing it to just 1 damage (15s cooldown)"
		}
	},
	[48] = {
		name = "The Soldier",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the soldier",
		descriptions = {
			[1] = "Disciplined combat training - gain +10 shielding skill and +5% critical strike chance",
			[2] = "Disciplined combat training - gain +15 shielding skill and +6% critical strike chance",
			[3] = "Disciplined combat training - gain +20 shielding skill and +7% critical strike chance",
			[4] = "Disciplined combat training - gain +25 shielding skill and +8% critical strike chance",
			[5] = "Disciplined combat training - gain +30 shielding skill and +9% critical strike chance",
			[6] = "Disciplined combat training - gain +35 shielding skill and +10% critical strike chance",
			[7] = "Disciplined combat training - gain +40 shielding skill and +11% critical strike chance",
			[8] = "Disciplined combat training - gain +45 shielding skill and +12% critical strike chance",
			[9] = "Disciplined combat training - gain +50 shielding skill and +13% critical strike chance",
			[10] = "Disciplined combat training - gain +60 shielding skill and +15% critical strike chance"
		}
	},
	[49] = {
		name = "The Sargent",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "the sargent",
		descriptions = {
			[1] = "Rally your squad - reduce party exp penalty by 3%. On kill, your entire party recovers 1% HP and Mana",
			[2] = "Rally your squad - reduce party exp penalty by 6%. On kill, your entire party recovers 1.5% HP and Mana",
			[3] = "Rally your squad - reduce party exp penalty by 9%. On kill, your entire party recovers 2% HP and Mana",
			[4] = "Rally your squad - reduce party exp penalty by 12%. On kill, your entire party recovers 2.5% HP and Mana",
			[5] = "Rally your squad - reduce party exp penalty by 15%. On kill, your entire party recovers 3% HP and Mana",
			[6] = "Rally your squad - reduce party exp penalty by 18%. On kill, your entire party recovers 3.5% HP and Mana",
			[7] = "Rally your squad - reduce party exp penalty by 21%. On kill, your entire party recovers 4% HP and Mana",
			[8] = "Rally your squad - reduce party exp penalty by 24%. On kill, your entire party recovers 4.5% HP and Mana",
			[9] = "Rally your squad - reduce party exp penalty by 27%. On kill, your entire party recovers 5% HP and Mana",
			[10] = "Rally your squad - reduce party exp penalty by 30%. On kill, your entire party recovers 5.5% HP and Mana"
		}
	},
	[50] = {
		name = "Cyborg",
		rarity = "epic",
		trigger = "onDamageTaken",
		cardFrame = "cyborg",
		descriptions = {
			[1] = "Automated defense protocol - 1% chance to fire a retaliatory energy laser when struck by melee attacks",
			[2] = "Automated defense protocol - 2% chance to fire a retaliatory energy laser when struck by melee attacks",
			[3] = "Automated defense protocol - 3% chance to fire a retaliatory energy laser when struck by melee attacks",
			[4] = "Automated defense protocol - 4% chance to fire a retaliatory energy laser when struck by melee attacks",
			[5] = "Automated defense protocol - 5% chance to fire a retaliatory energy laser when struck by melee attacks",
			[6] = "Automated defense protocol - 6% chance to fire a retaliatory energy laser when struck by melee attacks",
			[7] = "Automated defense protocol - 7% chance to fire a retaliatory energy laser when struck by melee attacks",
			[8] = "Automated defense protocol - 8% chance to fire a retaliatory energy laser when struck by melee attacks",
			[9] = "Automated defense protocol - 9% chance to fire a retaliatory energy laser when struck by melee attacks",
			[10] = "Automated defense protocol - 10% chance to fire a retaliatory energy laser when struck by melee attacks"
		}
	},
	[51] = {
		name = "Mecha T-Rex",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "mecha t-rex",
		descriptions = {
			[1] = "Prehistoric mechanical fury - melee attacks deal devastating area damage, amplified by +10% per equipped robot or jurassic card",
			[2] = "Prehistoric mechanical fury - melee attacks deal devastating area damage, amplified by +12% per equipped robot or jurassic card",
			[3] = "Prehistoric mechanical fury - melee attacks deal devastating area damage, amplified by +14% per equipped robot or jurassic card",
			[4] = "Prehistoric mechanical fury - melee attacks deal devastating area damage, amplified by +16% per equipped robot or jurassic card",
			[5] = "Prehistoric mechanical fury - melee attacks deal devastating area damage, amplified by +18% per equipped robot or jurassic card",
			[6] = "Prehistoric mechanical fury - melee attacks deal devastating area damage, amplified by +20% per equipped robot or jurassic card",
			[7] = "Prehistoric mechanical fury - melee attacks deal devastating area damage, amplified by +23% per equipped robot or jurassic card",
			[8] = "Prehistoric mechanical fury - melee attacks deal devastating area damage, amplified by +26% per equipped robot or jurassic card",
			[9] = "Prehistoric mechanical fury - melee attacks deal devastating area damage, amplified by +30% per equipped robot or jurassic card",
			[10] = "Prehistoric mechanical fury - melee attacks deal devastating area damage, amplified by +35% per equipped robot or jurassic card"
		}
	},
	[52] = {
		name = "Twisted Mecha",
		rarity = "rare",
		trigger = "onDamageTaken",
		cardFrame = "twisted mecha",
		descriptions = {
			[1] = "Overcharged circuits - take +30% energy damage, but every 10th spell unleashes a devastating chain lightning",
			[2] = "Overcharged circuits - take +25% energy damage, but every 10th spell unleashes a devastating chain lightning",
			[3] = "Overcharged circuits - take +20% energy damage, but every 10th spell unleashes a devastating chain lightning",
			[4] = "Overcharged circuits - take +18% energy damage, but every 10th spell unleashes a devastating chain lightning",
			[5] = "Overcharged circuits - take +16% energy damage, but every 10th spell unleashes a devastating chain lightning",
			[6] = "Overcharged circuits - take +14% energy damage, but every 10th spell unleashes a devastating chain lightning",
			[7] = "Overcharged circuits - take +12% energy damage, but every 10th spell unleashes a devastating chain lightning",
			[8] = "Overcharged circuits - take +10% energy damage, but every 10th spell unleashes a devastating chain lightning",
			[9] = "Overcharged circuits - take +8% energy damage, but every 10th spell unleashes a devastating chain lightning",
			[10] = "Overcharged circuits - take +6% energy damage, but every 10th spell unleashes a devastating chain lightning"
		}
	},
	[53] = {
		name = "Bad Circuit",
		rarity = "common",
		trigger = "onDamageTaken",
		cardFrame = "bad circuit",
		descriptions = {
			[1] = "System malfunction triggers a failsafe - 4% chance to activate total immunity for 1.5s when hit (12s cooldown)",
			[2] = "System malfunction triggers a failsafe - 5% chance to activate total immunity for 1.5s when hit (12s cooldown)",
			[3] = "System malfunction triggers a failsafe - 6% chance to activate total immunity for 1.5s when hit (12s cooldown)",
			[4] = "System malfunction triggers a failsafe - 7% chance to activate total immunity for 1.5s when hit (12s cooldown)",
			[5] = "System malfunction triggers a failsafe - 8% chance to activate total immunity for 1.5s when hit (12s cooldown)",
			[6] = "System malfunction triggers a failsafe - 9% chance to activate total immunity for 1.5s when hit (12s cooldown)",
			[7] = "System malfunction triggers a failsafe - 10% chance to activate total immunity for 1.5s when hit (12s cooldown)",
			[8] = "System malfunction triggers a failsafe - 11% chance to activate total immunity for 1.5s when hit (12s cooldown)",
			[9] = "System malfunction triggers a failsafe - 13% chance to activate total immunity for 1.5s when hit (12s cooldown)",
			[10] = "System malfunction triggers a failsafe - 15% chance to activate total immunity for 1.5s when hit (12s cooldown)"
		}
	},
	[54] = {
		name = "The Opportunist",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "the opportunist",
		descriptions = {
			[1] = "Strike first, strike hardest - deal +8% bonus damage against targets at 90% HP or above",
			[2] = "Strike first, strike hardest - deal +10% bonus damage against targets at 90% HP or above",
			[3] = "Strike first, strike hardest - deal +12% bonus damage against targets at 90% HP or above",
			[4] = "Strike first, strike hardest - deal +14% bonus damage against targets at 90% HP or above",
			[5] = "Strike first, strike hardest - deal +16% bonus damage against targets at 90% HP or above",
			[6] = "Strike first, strike hardest - deal +18% bonus damage against targets at 90% HP or above",
			[7] = "Strike first, strike hardest - deal +20% bonus damage against targets at 90% HP or above",
			[8] = "Strike first, strike hardest - deal +23% bonus damage against targets at 90% HP or above",
			[9] = "Strike first, strike hardest - deal +26% bonus damage against targets at 90% HP or above",
			[10] = "Strike first, strike hardest - deal +30% bonus damage against targets at 90% HP or above"
		}
	},
	[55] = {
		name = "Raiju",
		rarity = "epic",
		trigger = "onHit",
		cardFrame = "raiju",
		descriptions = {
			[1] = "Channel the thunder beast - gain +10% attack speed. Physical attacks shock targets for 1% of their max HP as energy damage (30s cooldown)",
			[2] = "Channel the thunder beast - gain +15% attack speed. Physical attacks shock targets for 1.5% of their max HP as energy damage (30s cooldown)",
			[3] = "Channel the thunder beast - gain +20% attack speed. Physical attacks shock targets for 2% of their max HP as energy damage (30s cooldown)",
			[4] = "Channel the thunder beast - gain +25% attack speed. Physical attacks shock targets for 2.5% of their max HP as energy damage (30s cooldown)",
			[5] = "Channel the thunder beast - gain +30% attack speed. Physical attacks shock targets for 3% of their max HP as energy damage (30s cooldown)",
			[6] = "Channel the thunder beast - gain +35% attack speed. Physical attacks shock targets for 3.5% of their max HP as energy damage (30s cooldown)",
			[7] = "Channel the thunder beast - gain +40% attack speed. Physical attacks shock targets for 4% of their max HP as energy damage (30s cooldown)",
			[8] = "Channel the thunder beast - gain +45% attack speed. Physical attacks shock targets for 4.5% of their max HP as energy damage (30s cooldown)",
			[9] = "Channel the thunder beast - gain +50% attack speed. Physical attacks shock targets for 5% of their max HP as energy damage (30s cooldown)",
			[10] = "Channel the thunder beast - gain +55% attack speed. Physical attacks shock targets for 5.5% of their max HP as energy damage (30s cooldown)"
		}
	},
	[56] = {
		name = "The Fairy",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "the fairy",
		descriptions = {
			[1] = "Dance through danger with ethereal grace - gain +8% movement speed and +5% dodge chance",
			[2] = "Dance through danger with ethereal grace - gain +10% movement speed and +6% dodge chance",
			[3] = "Dance through danger with ethereal grace - gain +12% movement speed and +7% dodge chance",
			[4] = "Dance through danger with ethereal grace - gain +14% movement speed and +8% dodge chance",
			[5] = "Dance through danger with ethereal grace - gain +16% movement speed and +9% dodge chance",
			[6] = "Dance through danger with ethereal grace - gain +18% movement speed and +10% dodge chance",
			[7] = "Dance through danger with ethereal grace - gain +20% movement speed and +11% dodge chance",
			[8] = "Dance through danger with ethereal grace - gain +23% movement speed and +12% dodge chance",
			[9] = "Dance through danger with ethereal grace - gain +26% movement speed and +14% dodge chance",
			[10] = "Dance through danger with ethereal grace - gain +30% movement speed and +16% dodge chance"
		}
	},
	[57] = {
		name = "Centaur",
		rarity = "common",
		trigger = "passive",
		cardFrame = "centaur",
		descriptions = {
			[1] = "Gallop into battle with relentless momentum - gain +5% movement speed and +5% attack speed",
			[2] = "Gallop into battle with relentless momentum - gain +6% movement speed and +6% attack speed",
			[3] = "Gallop into battle with relentless momentum - gain +7% movement speed and +7% attack speed",
			[4] = "Gallop into battle with relentless momentum - gain +8% movement speed and +8% attack speed",
			[5] = "Gallop into battle with relentless momentum - gain +9% movement speed and +9% attack speed",
			[6] = "Gallop into battle with relentless momentum - gain +10% movement speed and +10% attack speed",
			[7] = "Gallop into battle with relentless momentum - gain +11% movement speed and +11% attack speed",
			[8] = "Gallop into battle with relentless momentum - gain +12% movement speed and +12% attack speed",
			[9] = "Gallop into battle with relentless momentum - gain +14% movement speed and +14% attack speed",
			[10] = "Gallop into battle with relentless momentum - gain +16% movement speed and +16% attack speed"
		}
	},
	[58] = {
		name = "Lone Wolf",
		rarity = "epic",
		trigger = "onKill",
		cardFrame = "dire wolf",
		descriptions = {
			[1] = "Thrive in solitude - when adventuring alone, kills restore 3% HP and Mana and grant +2% bonus experience",
			[2] = "Thrive in solitude - when adventuring alone, kills restore 3.5% HP and Mana and grant +2.5% bonus experience",
			[3] = "Thrive in solitude - when adventuring alone, kills restore 4% HP and Mana and grant +3% bonus experience",
			[4] = "Thrive in solitude - when adventuring alone, kills restore 4.5% HP and Mana and grant +3.5% bonus experience",
			[5] = "Thrive in solitude - when adventuring alone, kills restore 5% HP and Mana and grant +4% bonus experience",
			[6] = "Thrive in solitude - when adventuring alone, kills restore 5.5% HP and Mana and grant +4.5% bonus experience",
			[7] = "Thrive in solitude - when adventuring alone, kills restore 6% HP and Mana and grant +5% bonus experience",
			[8] = "Thrive in solitude - when adventuring alone, kills restore 6.5% HP and Mana and grant +5.5% bonus experience",
			[9] = "Thrive in solitude - when adventuring alone, kills restore 7% HP and Mana and grant +6% bonus experience",
			[10] = "Thrive in solitude - when adventuring alone, kills restore 7.5% HP and Mana and grant +6.5% bonus experience"
		}
	},
	[59] = {
		name = "The Greed",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the greed",
		descriptions = {
			[1] = "Fortune favors the greedy - while in a party, siphon +8% of your allies' earned experience",
			[2] = "Fortune favors the greedy - while in a party, siphon +11% of your allies' earned experience",
			[3] = "Fortune favors the greedy - while in a party, siphon +14% of your allies' earned experience",
			[4] = "Fortune favors the greedy - while in a party, siphon +17% of your allies' earned experience",
			[5] = "Fortune favors the greedy - while in a party, siphon +20% of your allies' earned experience",
			[6] = "Fortune favors the greedy - while in a party, siphon +23% of your allies' earned experience",
			[7] = "Fortune favors the greedy - while in a party, siphon +26% of your allies' earned experience",
			[8] = "Fortune favors the greedy - while in a party, siphon +30% of your allies' earned experience",
			[9] = "Fortune favors the greedy - while in a party, siphon +35% of your allies' earned experience",
			[10] = "Fortune favors the greedy - while in a party, siphon +40% of your allies' earned experience"
		}
	},
	[60] = {
		name = "Barry the Hunter",
		rarity = "common",
		trigger = "passive",
		cardFrame = "barry the hunter",
		descriptions = {
			[1] = "A hunter's strength fuels precision - gain +1% distance skill for every 700 max HP",
			[2] = "A hunter's strength fuels precision - gain +1.5% distance skill for every 700 max HP",
			[3] = "A hunter's strength fuels precision - gain +2% distance skill for every 700 max HP",
			[4] = "A hunter's strength fuels precision - gain +2.5% distance skill for every 700 max HP",
			[5] = "A hunter's strength fuels precision - gain +3% distance skill for every 700 max HP",
			[6] = "A hunter's strength fuels precision - gain +3.5% distance skill for every 700 max HP",
			[7] = "A hunter's strength fuels precision - gain +4% distance skill for every 700 max HP",
			[8] = "A hunter's strength fuels precision - gain +4.5% distance skill for every 700 max HP",
			[9] = "A hunter's strength fuels precision - gain +5% distance skill for every 700 max HP",
			[10] = "A hunter's strength fuels precision - gain +6% distance skill for every 700 max HP"
		}
	},
	[61] = {
		name = "The Apprentice",
		rarity = "common",
		trigger = "onKill",
		cardFrame = "the apprentice",
		descriptions = {
			[1] = "Every kill is a lesson learned - 3% chance to gain 1 Codex Knowledge on each kill",
			[2] = "Every kill is a lesson learned - 3.1% chance to gain 2 Codex Knowledge on each kill",
			[3] = "Every kill is a lesson learned - 3.2% chance to gain 3 Codex Knowledge on each kill",
			[4] = "Every kill is a lesson learned - 3.3% chance to gain 4 Codex Knowledge on each kill",
			[5] = "Every kill is a lesson learned - 3.4% chance to gain 5 Codex Knowledge on each kill",
			[6] = "Every kill is a lesson learned - 3.5% chance to gain 6 Codex Knowledge on each kill",
			[7] = "Every kill is a lesson learned - 3.6% chance to gain 7 Codex Knowledge on each kill",
			[8] = "Every kill is a lesson learned - 3.7% chance to gain 8 Codex Knowledge on each kill",
			[9] = "Every kill is a lesson learned - 3.8% chance to gain 9 Codex Knowledge on each kill",
			[10] = "Every kill is a lesson learned - 4.2% chance to gain 11 Codex Knowledge on each kill"
		}
	},
	[62] = {
		name = "Envy",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "envy",
		descriptions = {
			[1] = "Covet the power of others - when an ally scores a kill, 8% chance to absorb 8% of one of their skills",
			[2] = "Covet the power of others - when an ally scores a kill, 10% chance to absorb 10% of one of their skills",
			[3] = "Covet the power of others - when an ally scores a kill, 12% chance to absorb 12% of one of their skills",
			[4] = "Covet the power of others - when an ally scores a kill, 14% chance to absorb 14% of one of their skills",
			[5] = "Covet the power of others - when an ally scores a kill, 16% chance to absorb 16% of one of their skills",
			[6] = "Covet the power of others - when an ally scores a kill, 18% chance to absorb 18% of one of their skills",
			[7] = "Covet the power of others - when an ally scores a kill, 20% chance to absorb 20% of one of their skills",
			[8] = "Covet the power of others - when an ally scores a kill, 23% chance to absorb 23% of one of their skills",
			[9] = "Covet the power of others - when an ally scores a kill, 26% chance to absorb 26% of one of their skills",
			[10] = "Covet the power of others - when an ally scores a kill, 30% chance to absorb 30% of one of their skills"
		}
	},
	[63] = {
		name = "The Magician",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the magician",
		descriptions = {
			[1] = "Arcane mastery sharpens your mind - gain +2 magic level",
			[2] = "Arcane mastery sharpens your mind - gain +3 magic level",
			[3] = "Arcane mastery sharpens your mind - gain +4 magic level",
			[4] = "Arcane mastery sharpens your mind - gain +5 magic level",
			[5] = "Arcane mastery sharpens your mind - gain +6 magic level",
			[6] = "Arcane mastery sharpens your mind - gain +7 magic level",
			[7] = "Arcane mastery sharpens your mind - gain +8 magic level",
			[8] = "Arcane mastery sharpens your mind - gain +9 magic level",
			[9] = "Arcane mastery sharpens your mind - gain +10 magic level",
			[10] = "Arcane mastery sharpens your mind - gain +12 magic level"
		}
	},
	[64] = {
		name = "The Druid",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the druid",
		descriptions = {
			[1] = "Your card collection deepens your mana reserves - gain +2% max mana for each active card in your deck",
			[2] = "Your card collection deepens your mana reserves - gain +3% max mana for each active card in your deck",
			[3] = "Your card collection deepens your mana reserves - gain +4% max mana for each active card in your deck",
			[4] = "Your card collection deepens your mana reserves - gain +5% max mana for each active card in your deck",
			[5] = "Your card collection deepens your mana reserves - gain +6% max mana for each active card in your deck",
			[6] = "Your card collection deepens your mana reserves - gain +7% max mana for each active card in your deck",
			[7] = "Your card collection deepens your mana reserves - gain +8% max mana for each active card in your deck",
			[8] = "Your card collection deepens your mana reserves - gain +9% max mana for each active card in your deck",
			[9] = "Your card collection deepens your mana reserves - gain +10% max mana for each active card in your deck",
			[10] = "Your card collection deepens your mana reserves - gain +12% max mana for each active card in your deck"
		}
	},
	[65] = {
		name = "Magic Cannon",
		rarity = "epic",
		trigger = "onAttackSpell",
		cardFrame = "magic cannon",
		descriptions = {
			[1] = "The farther you cast, the faster you reload - offensive spells reduce cooldowns by 150ms per tile of distance",
			[2] = "The farther you cast, the faster you reload - offensive spells reduce cooldowns by 165ms per tile of distance",
			[3] = "The farther you cast, the faster you reload - offensive spells reduce cooldowns by 180ms per tile of distance",
			[4] = "The farther you cast, the faster you reload - offensive spells reduce cooldowns by 195ms per tile of distance",
			[5] = "The farther you cast, the faster you reload - offensive spells reduce cooldowns by 210ms per tile of distance",
			[6] = "The farther you cast, the faster you reload - offensive spells reduce cooldowns by 225ms per tile of distance",
			[7] = "The farther you cast, the faster you reload - offensive spells reduce cooldowns by 240ms per tile of distance",
			[8] = "The farther you cast, the faster you reload - offensive spells reduce cooldowns by 255ms per tile of distance",
			[9] = "The farther you cast, the faster you reload - offensive spells reduce cooldowns by 270ms per tile of distance",
			[10] = "The farther you cast, the faster you reload - offensive spells reduce cooldowns by 285ms per tile of distance"
		}
	},
	[66] = {
		name = "The Sage",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the sage",
		descriptions = {
			[1] = "Wisdom transforms vitality into arcane power - gain +30% of your max HP as bonus max mana",
			[2] = "Wisdom transforms vitality into arcane power - gain +40% of your max HP as bonus max mana",
			[3] = "Wisdom transforms vitality into arcane power - gain +50% of your max HP as bonus max mana",
			[4] = "Wisdom transforms vitality into arcane power - gain +60% of your max HP as bonus max mana",
			[5] = "Wisdom transforms vitality into arcane power - gain +70% of your max HP as bonus max mana",
			[6] = "Wisdom transforms vitality into arcane power - gain +80% of your max HP as bonus max mana",
			[7] = "Wisdom transforms vitality into arcane power - gain +90% of your max HP as bonus max mana",
			[8] = "Wisdom transforms vitality into arcane power - gain +100% of your max HP as bonus max mana",
			[9] = "Wisdom transforms vitality into arcane power - gain +110% of your max HP as bonus max mana",
			[10] = "Wisdom transforms vitality into arcane power - gain +120% of your max HP as bonus max mana"
		}
	},
	[67] = {
		name = "The Elixir",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "the elixir",
		descriptions = {
			[1] = "Alchemical mastery enhances every brew - potions heal +5% more",
			[2] = "Alchemical mastery enhances every brew - potions heal +7% more",
			[3] = "Alchemical mastery enhances every brew - potions heal +9% more",
			[4] = "Alchemical mastery enhances every brew - potions heal +11% more",
			[5] = "Alchemical mastery enhances every brew - potions heal +13% more",
			[6] = "Alchemical mastery enhances every brew - potions heal +15% more",
			[7] = "Alchemical mastery enhances every brew - potions heal +17% more",
			[8] = "Alchemical mastery enhances every brew - potions heal +19% more",
			[9] = "Alchemical mastery enhances every brew - potions heal +22% more",
			[10] = "Alchemical mastery enhances every brew - potions heal +25% more"
		}
	},
	[68] = {
		name = "The Pulse",
		rarity = "rare",
		trigger = "onStandStill",
		cardFrame = "the pulse",
		descriptions = {
			[1] = "Channel divine energy while stationary - emit a 2x2 holy shockwave every 3s dealing 60 base damage",
			[2] = "Channel divine energy while stationary - emit a 2x2 holy shockwave every 3s dealing 70 base damage",
			[3] = "Channel divine energy while stationary - emit a 2x2 holy shockwave every 3s dealing 80 base damage",
			[4] = "Channel divine energy while stationary - emit a 2x2 holy shockwave every 3s dealing 90 base damage",
			[5] = "Channel divine energy while stationary - emit a 2x2 holy shockwave every 3s dealing 100 base damage",
			[6] = "Channel divine energy while stationary - emit a 2x2 holy shockwave every 3s dealing 110 base damage",
			[7] = "Channel divine energy while stationary - emit a 2x2 holy shockwave every 3s dealing 120 base damage",
			[8] = "Channel divine energy while stationary - emit a 2x2 holy shockwave every 3s dealing 130 base damage",
			[9] = "Channel divine energy while stationary - emit a 2x2 holy shockwave every 3s dealing 140 base damage",
			[10] = "Channel divine energy while stationary - emit a 2x2 holy shockwave every 3s dealing 160 base damage"
		}
	},
	[69] = {
		name = "Cannibal",
		rarity = "common",
		trigger = "onKill",
		cardFrame = "cannibal",
		descriptions = {
			[1] = "Feed on the fallen - each kill grants +8% crit for 5 min. Slaying a player gives a 5% chance to fully restore your health",
			[2] = "Feed on the fallen - each kill grants +10% crit for 5 min. Slaying a player gives a 6% chance to fully restore your health",
			[3] = "Feed on the fallen - each kill grants +12% crit for 5 min. Slaying a player gives a 7% chance to fully restore your health",
			[4] = "Feed on the fallen - each kill grants +14% crit for 5 min. Slaying a player gives a 8% chance to fully restore your health",
			[5] = "Feed on the fallen - each kill grants +16% crit for 5 min. Slaying a player gives a 9% chance to fully restore your health",
			[6] = "Feed on the fallen - each kill grants +18% crit for 5 min. Slaying a player gives a 10% chance to fully restore your health",
			[7] = "Feed on the fallen - each kill grants +20% crit for 5 min. Slaying a player gives a 11% chance to fully restore your health",
			[8] = "Feed on the fallen - each kill grants +23% crit for 5 min. Slaying a player gives a 12% chance to fully restore your health",
			[9] = "Feed on the fallen - each kill grants +26% crit for 5 min. Slaying a player gives a 13% chance to fully restore your health",
			[10] = "Feed on the fallen - each kill grants +30% crit for 5 min. Slaying a player gives a 15% chance to fully restore your health"
		}
	},
	[70] = {
		name = "The Vampire",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "the vampire",
		descriptions = {
			[1] = "Drain your enemies' lifeblood - gain +2% life leech, with a 5% chance to Bite for double healing",
			[2] = "Drain your enemies' lifeblood - gain +3% life leech, with a 7% chance to Bite for double healing",
			[3] = "Drain your enemies' lifeblood - gain +4% life leech, with a 9% chance to Bite for double healing",
			[4] = "Drain your enemies' lifeblood - gain +5% life leech, with a 11% chance to Bite for double healing",
			[5] = "Drain your enemies' lifeblood - gain +6% life leech, with a 13% chance to Bite for double healing",
			[6] = "Drain your enemies' lifeblood - gain +7% life leech, with a 15% chance to Bite for double healing",
			[7] = "Drain your enemies' lifeblood - gain +8% life leech, with a 18% chance to Bite for double healing",
			[8] = "Drain your enemies' lifeblood - gain +10% life leech, with a 21% chance to Bite for double healing",
			[9] = "Drain your enemies' lifeblood - gain +12% life leech, with a 24% chance to Bite for double healing",
			[10] = "Drain your enemies' lifeblood - gain +15% life leech, with a 28% chance to Bite for double healing"
		}
	},
	[71] = {
		name = "Triforce",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "triforce",
		descriptions = {
			[1] = "The power of the Triforce flows through you - gain +2 to sword, distance, and magic level",
			[2] = "The power of the Triforce flows through you - gain +3 to sword, distance, and magic level",
			[3] = "The power of the Triforce flows through you - gain +4 to sword, distance, and magic level",
			[4] = "The power of the Triforce flows through you - gain +5 to sword, distance, and magic level",
			[5] = "The power of the Triforce flows through you - gain +6 to sword, distance, and magic level",
			[6] = "The power of the Triforce flows through you - gain +7 to sword, distance, and magic level",
			[7] = "The power of the Triforce flows through you - gain +8 to sword, distance, and magic level",
			[8] = "The power of the Triforce flows through you - gain +9 to sword, distance, and magic level",
			[9] = "The power of the Triforce flows through you - gain +10 to sword, distance, and magic level",
			[10] = "The power of the Triforce flows through you - gain +12 to sword, distance, and magic level"
		}
	},
	[72] = {
		name = "Superior",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "superior",
		descriptions = {
			[1] = "Ascend beyond mortal limits - gain +10% to all combat skills",
			[2] = "Ascend beyond mortal limits - gain +11% to all combat skills",
			[3] = "Ascend beyond mortal limits - gain +12% to all combat skills",
			[4] = "Ascend beyond mortal limits - gain +13% to all combat skills",
			[5] = "Ascend beyond mortal limits - gain +14% to all combat skills",
			[6] = "Ascend beyond mortal limits - gain +15% to all combat skills",
			[7] = "Ascend beyond mortal limits - gain +16% to all combat skills",
			[8] = "Ascend beyond mortal limits - gain +17% to all combat skills",
			[9] = "Ascend beyond mortal limits - gain +18% to all combat skills",
			[10] = "Ascend beyond mortal limits - gain +22% to all combat skills"
		}
	},
	[73] = {
		name = "Vengance",
		rarity = "rare",
		trigger = "onDamageTaken",
		cardFrame = "vengance",
		descriptions = {
			[1] = "Pain fuels rage - each hit taken stacks +1% damage dealt and received (max 10 stacks, lasts 5s)",
			[2] = "Pain fuels rage - each hit taken stacks +1% damage dealt and received (max 11 stacks, lasts 5s)",
			[3] = "Pain fuels rage - each hit taken stacks +1% damage dealt and received (max 12 stacks, lasts 5s)",
			[4] = "Pain fuels rage - each hit taken stacks +1% damage dealt and received (max 13 stacks, lasts 5s)",
			[5] = "Pain fuels rage - each hit taken stacks +1% damage dealt and received (max 14 stacks, lasts 5s)",
			[6] = "Pain fuels rage - each hit taken stacks +1% damage dealt and received (max 15 stacks, lasts 5s)",
			[7] = "Pain fuels rage - each hit taken stacks +1% damage dealt and received (max 16 stacks, lasts 5s)",
			[8] = "Pain fuels rage - each hit taken stacks +1% damage dealt and received (max 18 stacks, lasts 5s)",
			[9] = "Pain fuels rage - each hit taken stacks +1% damage dealt and received (max 20 stacks, lasts 5s)",
			[10] = "Pain fuels rage - each hit taken stacks +1% damage dealt and received (max 22 stacks, lasts 5s)"
		}
	},
	[74] = {
		name = "Snowball",
		rarity = "common",
		trigger = "onKill",
		cardFrame = "snowball",
		descriptions = {
			[1] = "The avalanche grows - 30% chance for a 3x3 frost explosion on kill. Permanently stack +0.1% ice damage per kill (max 100, resets on death). Area expands at high stacks",
			[2] = "The avalanche grows - 35% chance for a 3x3 frost explosion on kill. Permanently stack +0.2% ice damage per kill (max 110, resets on death). Area expands at high stacks",
			[3] = "The avalanche grows - 40% chance for a 3x3 frost explosion on kill. Permanently stack +0.3% ice damage per kill (max 120, resets on death). Area expands at high stacks",
			[4] = "The avalanche grows - 45% chance for a 3x3 frost explosion on kill. Permanently stack +0.4% ice damage per kill (max 130, resets on death). Area expands at high stacks",
			[5] = "The avalanche grows - 50% chance for a 3x3 frost explosion on kill. Permanently stack +0.5% ice damage per kill (max 140, resets on death). Area expands at high stacks",
			[6] = "The avalanche grows - 55% chance for a 3x3 frost explosion on kill. Permanently stack +0.6% ice damage per kill (max 150, resets on death). Area expands at high stacks",
			[7] = "The avalanche grows - 60% chance for a 3x3 frost explosion on kill. Permanently stack +0.7% ice damage per kill (max 160, resets on death). Area expands at high stacks",
			[8] = "The avalanche grows - 65% chance for a 3x3 frost explosion on kill. Permanently stack +0.8% ice damage per kill (max 170, resets on death). Area expands at high stacks",
			[9] = "The avalanche grows - 70% chance for a 3x3 frost explosion on kill. Permanently stack +0.9% ice damage per kill (max 180, resets on death). Area expands at high stacks",
			[10] = "The avalanche grows - 80% chance for a 3x3 frost explosion on kill. Permanently stack +1% ice damage per kill (max 200, resets on death). Area expands at high stacks"
		}
	},
	[75] = {
		name = "Union",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "union",
		descriptions = {
			[1] = "Strength in diversity - gain +2% max HP and Mana for each unique vocation in your party",
			[2] = "Strength in diversity - gain +3% max HP and Mana for each unique vocation in your party",
			[3] = "Strength in diversity - gain +4% max HP and Mana for each unique vocation in your party",
			[4] = "Strength in diversity - gain +5% max HP and Mana for each unique vocation in your party",
			[5] = "Strength in diversity - gain +6% max HP and Mana for each unique vocation in your party",
			[6] = "Strength in diversity - gain +7% max HP and Mana for each unique vocation in your party",
			[7] = "Strength in diversity - gain +8% max HP and Mana for each unique vocation in your party",
			[8] = "Strength in diversity - gain +9% max HP and Mana for each unique vocation in your party",
			[9] = "Strength in diversity - gain +10% max HP and Mana for each unique vocation in your party",
			[10] = "Strength in diversity - gain +12% max HP and Mana for each unique vocation in your party"
		}
	},
	[76] = {
		name = "All for One",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "all for one",
		descriptions = {
			[1] = "United we conquer - gain +1% to all skills for each nearby party member",
			[2] = "United we conquer - gain +2% to all skills for each nearby party member",
			[3] = "United we conquer - gain +3% to all skills for each nearby party member",
			[4] = "United we conquer - gain +4% to all skills for each nearby party member",
			[5] = "United we conquer - gain +5% to all skills for each nearby party member",
			[6] = "United we conquer - gain +6% to all skills for each nearby party member",
			[7] = "United we conquer - gain +7% to all skills for each nearby party member",
			[8] = "United we conquer - gain +8% to all skills for each nearby party member",
			[9] = "United we conquer - gain +9% to all skills for each nearby party member",
			[10] = "United we conquer - gain +10% to all skills for each nearby party member"
		}
	},
	[77] = {
		name = "The Minotaur",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "the minotaur",
		descriptions = {
			[1] = "Turn your defense into a weapon - melee attacks gain +120% bonus physical damage scaling with your shielding skill",
			[2] = "Turn your defense into a weapon - melee attacks gain +135% bonus physical damage scaling with your shielding skill",
			[3] = "Turn your defense into a weapon - melee attacks gain +150% bonus physical damage scaling with your shielding skill",
			[4] = "Turn your defense into a weapon - melee attacks gain +165% bonus physical damage scaling with your shielding skill",
			[5] = "Turn your defense into a weapon - melee attacks gain +180% bonus physical damage scaling with your shielding skill",
			[6] = "Turn your defense into a weapon - melee attacks gain +200% bonus physical damage scaling with your shielding skill",
			[7] = "Turn your defense into a weapon - melee attacks gain +220% bonus physical damage scaling with your shielding skill",
			[8] = "Turn your defense into a weapon - melee attacks gain +240% bonus physical damage scaling with your shielding skill",
			[9] = "Turn your defense into a weapon - melee attacks gain +260% bonus physical damage scaling with your shielding skill",
			[10] = "Turn your defense into a weapon - melee attacks gain +300% bonus physical damage scaling with your shielding skill"
		}
	},
	[78] = {
		name = "The Griffin",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "the griffin",
		descriptions = {
			[1] = "Soar with predatory swiftness - gain +2% movement speed. Physical attacks deal bonus damage scaling with your speed",
			[2] = "Soar with predatory swiftness - gain +4% movement speed. Physical attacks deal bonus damage scaling with your speed",
			[3] = "Soar with predatory swiftness - gain +6% movement speed. Physical attacks deal bonus damage scaling with your speed",
			[4] = "Soar with predatory swiftness - gain +8% movement speed. Physical attacks deal bonus damage scaling with your speed",
			[5] = "Soar with predatory swiftness - gain +10% movement speed. Physical attacks deal bonus damage scaling with your speed",
			[6] = "Soar with predatory swiftness - gain +12% movement speed. Physical attacks deal bonus damage scaling with your speed",
			[7] = "Soar with predatory swiftness - gain +14% movement speed. Physical attacks deal bonus damage scaling with your speed",
			[8] = "Soar with predatory swiftness - gain +16% movement speed. Physical attacks deal bonus damage scaling with your speed",
			[9] = "Soar with predatory swiftness - gain +18% movement speed. Physical attacks deal bonus damage scaling with your speed",
			[10] = "Soar with predatory swiftness - gain +20% movement speed. Physical attacks deal bonus damage scaling with your speed"
		}
	},
	[79] = {
		name = "Giant Slayer",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "giant slayer",
		descriptions = {
			[1] = "The bigger they are, the harder they fall - deal up to +16.5% bonus damage based on HP difference vs your target",
			[2] = "The bigger they are, the harder they fall - deal up to +18% bonus damage based on HP difference vs your target",
			[3] = "The bigger they are, the harder they fall - deal up to +19.5% bonus damage based on HP difference vs your target",
			[4] = "The bigger they are, the harder they fall - deal up to +21% bonus damage based on HP difference vs your target",
			[5] = "The bigger they are, the harder they fall - deal up to +22.5% bonus damage based on HP difference vs your target",
			[6] = "The bigger they are, the harder they fall - deal up to +24% bonus damage based on HP difference vs your target",
			[7] = "The bigger they are, the harder they fall - deal up to +25.5% bonus damage based on HP difference vs your target",
			[8] = "The bigger they are, the harder they fall - deal up to +27% bonus damage based on HP difference vs your target",
			[9] = "The bigger they are, the harder they fall - deal up to +28.5% bonus damage based on HP difference vs your target",
			[10] = "The bigger they are, the harder they fall - deal up to +30% bonus damage based on HP difference vs your target"
		}
	},
	[80] = {
		name = "Chainless",
		rarity = "epic",
		trigger = "onSpell",
		cardFrame = "chainless",
		descriptions = {
			[1] = "Master the spell combo - cast 3 different attack spells in sequence to empower your next spell with +10% bonus damage",
			[2] = "Master the spell combo - cast 3 different attack spells in sequence to empower your next spell with +12% bonus damage",
			[3] = "Master the spell combo - cast 3 different attack spells in sequence to empower your next spell with +14% bonus damage",
			[4] = "Master the spell combo - cast 3 different attack spells in sequence to empower your next spell with +16% bonus damage",
			[5] = "Master the spell combo - cast 3 different attack spells in sequence to empower your next spell with +18% bonus damage",
			[6] = "Master the spell combo - cast 3 different attack spells in sequence to empower your next spell with +20% bonus damage",
			[7] = "Master the spell combo - cast 3 different attack spells in sequence to empower your next spell with +23% bonus damage",
			[8] = "Master the spell combo - cast 3 different attack spells in sequence to empower your next spell with +26% bonus damage",
			[9] = "Master the spell combo - cast 3 different attack spells in sequence to empower your next spell with +30% bonus damage",
			[10] = "Master the spell combo - cast 3 different attack spells in sequence to empower your next spell with +35% bonus damage"
		}
	},
	[81] = {
		name = "Leviathan",
		rarity = "rare",
		trigger = "onStandStill",
		cardFrame = "leviathan",
		descriptions = {
			[1] = "Become an immovable fortress - standing still for 2.5s generates a protective shield equal to 10% of your max HP",
			[2] = "Become an immovable fortress - standing still for 2.5s generates a protective shield equal to 12% of your max HP",
			[3] = "Become an immovable fortress - standing still for 2.5s generates a protective shield equal to 14% of your max HP",
			[4] = "Become an immovable fortress - standing still for 2.5s generates a protective shield equal to 16% of your max HP",
			[5] = "Become an immovable fortress - standing still for 2.5s generates a protective shield equal to 18% of your max HP",
			[6] = "Become an immovable fortress - standing still for 2.5s generates a protective shield equal to 20% of your max HP",
			[7] = "Become an immovable fortress - standing still for 2.5s generates a protective shield equal to 23% of your max HP",
			[8] = "Become an immovable fortress - standing still for 2.5s generates a protective shield equal to 26% of your max HP",
			[9] = "Become an immovable fortress - standing still for 2.5s generates a protective shield equal to 30% of your max HP",
			[10] = "Become an immovable fortress - standing still for 2.5s generates a protective shield equal to 35% of your max HP"
		}
	},
	[82] = {
		name = "Nautilus",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "nautilus",
		descriptions = {
			[1] = "Encased in a living shell - gain a shield worth 30% max HP every 6s, but permanently lose 50% movement speed",
			[2] = "Encased in a living shell - gain a shield worth 35% max HP every 6s, but permanently lose 50% movement speed",
			[3] = "Encased in a living shell - gain a shield worth 40% max HP every 6s, but permanently lose 50% movement speed",
			[4] = "Encased in a living shell - gain a shield worth 45% max HP every 6s, but permanently lose 50% movement speed",
			[5] = "Encased in a living shell - gain a shield worth 50% max HP every 6s, but permanently lose 50% movement speed",
			[6] = "Encased in a living shell - gain a shield worth 55% max HP every 6s, but permanently lose 50% movement speed",
			[7] = "Encased in a living shell - gain a shield worth 60% max HP every 6s, but permanently lose 50% movement speed",
			[8] = "Encased in a living shell - gain a shield worth 65% max HP every 6s, but permanently lose 50% movement speed",
			[9] = "Encased in a living shell - gain a shield worth 70% max HP every 6s, but permanently lose 50% movement speed",
			[10] = "Encased in a living shell - gain a shield worth 75% max HP every 6s, but permanently lose 50% movement speed"
		}
	},
	[83] = {
		name = "Shielded to the teeth",
		rarity = "rare",
		trigger = "onShield",
		cardFrame = "armored to the teeth",
		descriptions = {
			[1] = "Your barrier hardens your defenses - gaining a shield also grants +10% block chance for 5s",
			[2] = "Your barrier hardens your defenses - gaining a shield also grants +12% block chance for 5s",
			[3] = "Your barrier hardens your defenses - gaining a shield also grants +14% block chance for 5s",
			[4] = "Your barrier hardens your defenses - gaining a shield also grants +16% block chance for 5s",
			[5] = "Your barrier hardens your defenses - gaining a shield also grants +18% block chance for 5s",
			[6] = "Your barrier hardens your defenses - gaining a shield also grants +20% block chance for 5s",
			[7] = "Your barrier hardens your defenses - gaining a shield also grants +23% block chance for 5s",
			[8] = "Your barrier hardens your defenses - gaining a shield also grants +26% block chance for 5s",
			[9] = "Your barrier hardens your defenses - gaining a shield also grants +30% block chance for 5s",
			[10] = "Your barrier hardens your defenses - gaining a shield also grants +35% block chance for 5s"
		}
	},
	[84] = {
		name = "The Pope",
		rarity = "common",
		trigger = "onShieldDamage",
		cardFrame = "thepope",
		descriptions = {
			[1] = "Divine protection mends your wounds - when your shield absorbs damage, heal for 10% of the absorbed amount",
			[2] = "Divine protection mends your wounds - when your shield absorbs damage, heal for 12% of the absorbed amount",
			[3] = "Divine protection mends your wounds - when your shield absorbs damage, heal for 14% of the absorbed amount",
			[4] = "Divine protection mends your wounds - when your shield absorbs damage, heal for 16% of the absorbed amount",
			[5] = "Divine protection mends your wounds - when your shield absorbs damage, heal for 18% of the absorbed amount",
			[6] = "Divine protection mends your wounds - when your shield absorbs damage, heal for 20% of the absorbed amount",
			[7] = "Divine protection mends your wounds - when your shield absorbs damage, heal for 23% of the absorbed amount",
			[8] = "Divine protection mends your wounds - when your shield absorbs damage, heal for 26% of the absorbed amount",
			[9] = "Divine protection mends your wounds - when your shield absorbs damage, heal for 30% of the absorbed amount",
			[10] = "Divine protection mends your wounds - when your shield absorbs damage, heal for 35% of the absorbed amount"
		}
	},
	[85] = {
		name = "Wrecking Ball",
		rarity = "common",
		trigger = "onDash",
		cardFrame = "wreckingball",
		descriptions = {
			[1] = "Crash through with unstoppable force - dashing generates a shield equal to 10% of your max HP for 5s",
			[2] = "Crash through with unstoppable force - dashing generates a shield equal to 12% of your max HP for 5s",
			[3] = "Crash through with unstoppable force - dashing generates a shield equal to 14% of your max HP for 5s",
			[4] = "Crash through with unstoppable force - dashing generates a shield equal to 16% of your max HP for 5s",
			[5] = "Crash through with unstoppable force - dashing generates a shield equal to 18% of your max HP for 5s",
			[6] = "Crash through with unstoppable force - dashing generates a shield equal to 20% of your max HP for 5s",
			[7] = "Crash through with unstoppable force - dashing generates a shield equal to 23% of your max HP for 5s",
			[8] = "Crash through with unstoppable force - dashing generates a shield equal to 26% of your max HP for 5s",
			[9] = "Crash through with unstoppable force - dashing generates a shield equal to 30% of your max HP for 5s",
			[10] = "Crash through with unstoppable force - dashing generates a shield equal to 35% of your max HP for 5s"
		}
	},
	[86] = {
		name = "Bubble Gun",
		rarity = "epic",
		trigger = "onCrit",
		cardFrame = "bubbles gun",
		descriptions = {
			[1] = "Every critical hit encases you in a bubble barrier - gain a shield equal to 30% of your crit damage for 5s",
			[2] = "Every critical hit encases you in a bubble barrier - gain a shield equal to 33% of your crit damage for 5s",
			[3] = "Every critical hit encases you in a bubble barrier - gain a shield equal to 36% of your crit damage for 5s",
			[4] = "Every critical hit encases you in a bubble barrier - gain a shield equal to 39% of your crit damage for 5s",
			[5] = "Every critical hit encases you in a bubble barrier - gain a shield equal to 42% of your crit damage for 5s",
			[6] = "Every critical hit encases you in a bubble barrier - gain a shield equal to 45% of your crit damage for 5s",
			[7] = "Every critical hit encases you in a bubble barrier - gain a shield equal to 48% of your crit damage for 5s",
			[8] = "Every critical hit encases you in a bubble barrier - gain a shield equal to 51% of your crit damage for 5s",
			[9] = "Every critical hit encases you in a bubble barrier - gain a shield equal to 54% of your crit damage for 5s",
			[10] = "Every critical hit encases you in a bubble barrier - gain a shield equal to 57% of your crit damage for 5s"
		}
	},
	[87] = {
		name = "The Dancer",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "the dancer",
		descriptions = {
			[1] = "A lethal dance of blade and shadow - +10% crit. Crits grant 1% dodge for 3s, dodges grant 1% crit for 3s",
			[2] = "A lethal dance of blade and shadow - +10% crit. Crits grant 2% dodge for 3s, dodges grant 2% crit for 3s",
			[3] = "A lethal dance of blade and shadow - +10% crit. Crits grant 3% dodge for 3s, dodges grant 3% crit for 3s",
			[4] = "A lethal dance of blade and shadow - +10% crit. Crits grant 4% dodge for 3s, dodges grant 4% crit for 3s",
			[5] = "A lethal dance of blade and shadow - +10% crit. Crits grant 5% dodge for 3s, dodges grant 5% crit for 3s",
			[6] = "A lethal dance of blade and shadow - +10% crit. Crits grant 6% dodge for 3s, dodges grant 6% crit for 3s",
			[7] = "A lethal dance of blade and shadow - +10% crit. Crits grant 7% dodge for 3s, dodges grant 7% crit for 3s",
			[8] = "A lethal dance of blade and shadow - +10% crit. Crits grant 8% dodge for 3s, dodges grant 8% crit for 3s",
			[9] = "A lethal dance of blade and shadow - +10% crit. Crits grant 9% dodge for 3s, dodges grant 9% crit for 3s",
			[10] = "A lethal dance of blade and shadow - +10% crit. Crits grant 10% dodge for 3s, dodges grant 10% crit for 3s"
		}
	},
	[88] = {
		name = "Demonic Pact",
		rarity = "epic",
		trigger = "onKill",
		cardFrame = "demonic pact",
		descriptions = {
			[1] = "Your pact empowers the damned - each kill grants all your summons a shield equal to 10% of their max HP for 5s",
			[2] = "Your pact empowers the damned - each kill grants all your summons a shield equal to 12% of their max HP for 5s",
			[3] = "Your pact empowers the damned - each kill grants all your summons a shield equal to 14% of their max HP for 5s",
			[4] = "Your pact empowers the damned - each kill grants all your summons a shield equal to 16% of their max HP for 5s",
			[5] = "Your pact empowers the damned - each kill grants all your summons a shield equal to 18% of their max HP for 5s",
			[6] = "Your pact empowers the damned - each kill grants all your summons a shield equal to 20% of their max HP for 5s",
			[7] = "Your pact empowers the damned - each kill grants all your summons a shield equal to 23% of their max HP for 5s",
			[8] = "Your pact empowers the damned - each kill grants all your summons a shield equal to 26% of their max HP for 5s",
			[9] = "Your pact empowers the damned - each kill grants all your summons a shield equal to 30% of their max HP for 5s",
			[10] = "Your pact empowers the damned - each kill grants all your summons a shield equal to 35% of their max HP for 5s"
		}
	},
	[89] = {
		name = "Gaia",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "gaia",
		descriptions = {
			[1] = "The earth mother blesses your touch - +10% healing power. Every heal also generates a shield worth 10% of the heal for 5s",
			[2] = "The earth mother blesses your touch - +12% healing power. Every heal also generates a shield worth 12% of the heal for 5s",
			[3] = "The earth mother blesses your touch - +14% healing power. Every heal also generates a shield worth 14% of the heal for 5s",
			[4] = "The earth mother blesses your touch - +16% healing power. Every heal also generates a shield worth 16% of the heal for 5s",
			[5] = "The earth mother blesses your touch - +18% healing power. Every heal also generates a shield worth 18% of the heal for 5s",
			[6] = "The earth mother blesses your touch - +20% healing power. Every heal also generates a shield worth 20% of the heal for 5s",
			[7] = "The earth mother blesses your touch - +22% healing power. Every heal also generates a shield worth 23% of the heal for 5s",
			[8] = "The earth mother blesses your touch - +24% healing power. Every heal also generates a shield worth 26% of the heal for 5s",
			[9] = "The earth mother blesses your touch - +26% healing power. Every heal also generates a shield worth 30% of the heal for 5s",
			[10] = "The earth mother blesses your touch - +30% healing power. Every heal also generates a shield worth 35% of the heal for 5s"
		}
	},
	[90] = {
		name = "Kiss of Heavens",
		rarity = "rare",
		trigger = "onDefensiveSpell",
		cardFrame = "kiss of heavens",
		descriptions = {
			[1] = "Heaven's grace descends upon you - defensive spells have a 12% chance to heal 5% max HP and stun nearby enemies for 3s",
			[2] = "Heaven's grace descends upon you - defensive spells have a 14% chance to heal 6% max HP and stun nearby enemies for 3s",
			[3] = "Heaven's grace descends upon you - defensive spells have a 16% chance to heal 7% max HP and stun nearby enemies for 3s",
			[4] = "Heaven's grace descends upon you - defensive spells have a 18% chance to heal 8% max HP and stun nearby enemies for 3s",
			[5] = "Heaven's grace descends upon you - defensive spells have a 20% chance to heal 9% max HP and stun nearby enemies for 3s",
			[6] = "Heaven's grace descends upon you - defensive spells have a 23% chance to heal 10% max HP and stun nearby enemies for 3s",
			[7] = "Heaven's grace descends upon you - defensive spells have a 26% chance to heal 11% max HP and stun nearby enemies for 3s",
			[8] = "Heaven's grace descends upon you - defensive spells have a 30% chance to heal 12% max HP and stun nearby enemies for 3s",
			[9] = "Heaven's grace descends upon you - defensive spells have a 35% chance to heal 14% max HP and stun nearby enemies for 3s",
			[10] = "Heaven's grace descends upon you - defensive spells have a 40% chance to heal 16% max HP and stun nearby enemies for 3s"
		}
	},

	-- Card 91: Crazy to Shoot (onBowAttack & onWandAttack + onCrit)
	[91] = {
		name = "Crazy to Shoot",
		rarity = "epic",	
		trigger = "onCrit",
		cardFrame = "crazy to shoot",
		descriptions = {
			[1] = "Trigger-happy frenzy - ranged attacks have a 12% chance to stack +1% crit (max 10%). Crits have a 12% chance to stack +1% attack speed (max 10%)",
			[2] = "Trigger-happy frenzy - ranged attacks have a 14% chance to stack +1% crit (max 12%). Crits have a 14% chance to stack +1% attack speed (max 12%)",
			[3] = "Trigger-happy frenzy - ranged attacks have a 16% chance to stack +1% crit (max 14%). Crits have a 16% chance to stack +1% attack speed (max 14%)",
			[4] = "Trigger-happy frenzy - ranged attacks have a 18% chance to stack +1% crit (max 16%). Crits have a 18% chance to stack +1% attack speed (max 16%)",
			[5] = "Trigger-happy frenzy - ranged attacks have a 20% chance to stack +1% crit (max 18%). Crits have a 20% chance to stack +1% attack speed (max 18%)",
			[6] = "Trigger-happy frenzy - ranged attacks have a 23% chance to stack +1% crit (max 20%). Crits have a 23% chance to stack +1% attack speed (max 20%)",
			[7] = "Trigger-happy frenzy - ranged attacks have a 26% chance to stack +1% crit (max 23%). Crits have a 26% chance to stack +1% attack speed (max 23%)",
			[8] = "Trigger-happy frenzy - ranged attacks have a 30% chance to stack +1% crit (max 26%). Crits have a 30% chance to stack +1% attack speed (max 26%)",
			[9] = "Trigger-happy frenzy - ranged attacks have a 35% chance to stack +1% crit (max 30%). Crits have a 35% chance to stack +1% attack speed (max 30%)",
			[10] = "Trigger-happy frenzy - ranged attacks have a 40% chance to stack +1% crit (max 35%). Crits have a 40% chance to stack +1% attack speed (max 35%)"
		}
	},

	-- Card 92: Blood Pool (onHit - melee only, handled by unified_passives.lua)
	[92] = {
		name = "Blood Pool",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "blood pool",	
		descriptions = {
			[1] = "Bathe in the blood of your enemies - melee hits have a 12% chance to grant +5% attack speed and life leech for 5s (5s cooldown)",
			[2] = "Bathe in the blood of your enemies - melee hits have a 14% chance to grant +6% attack speed and life leech for 5s (5s cooldown)",
			[3] = "Bathe in the blood of your enemies - melee hits have a 16% chance to grant +7% attack speed and life leech for 5s (5s cooldown)",
			[4] = "Bathe in the blood of your enemies - melee hits have a 18% chance to grant +8% attack speed and life leech for 5s (5s cooldown)",
			[5] = "Bathe in the blood of your enemies - melee hits have a 20% chance to grant +9% attack speed and life leech for 5s (5s cooldown)",
			[6] = "Bathe in the blood of your enemies - melee hits have a 23% chance to grant +10% attack speed and life leech for 5s (5s cooldown)",
			[7] = "Bathe in the blood of your enemies - melee hits have a 26% chance to grant +11% attack speed and life leech for 5s (5s cooldown)",
			[8] = "Bathe in the blood of your enemies - melee hits have a 30% chance to grant +12% attack speed and life leech for 5s (5s cooldown)",
			[9] = "Bathe in the blood of your enemies - melee hits have a 35% chance to grant +14% attack speed and life leech for 5s (5s cooldown)",
			[10] = "Bathe in the blood of your enemies - melee hits have a 40% chance to grant +16% attack speed and life leech for 5s (5s cooldown)"
		},
	},

	-- Card 93: Bullet Rain (onBowAttack/onWandAttack - AoE damage scaled by attack speed)
	[93] = {
		name = "Bullet Rain",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "bullet rain",
		descriptions = {
			[1] = "Unleash a hail of projectiles - ranged attacks have a 10% chance for a 2x2 AoE blast (30% damage + 3% per attack speed%)",
			[2] = "Unleash a hail of projectiles - ranged attacks have a 12% chance for a 2x2 AoE blast (30% damage + 3% per attack speed%)",
			[3] = "Unleash a hail of projectiles - ranged attacks have a 14% chance for a 2x2 AoE blast (30% damage + 3% per attack speed%)",
			[4] = "Unleash a hail of projectiles - ranged attacks have a 16% chance for a 2x2 AoE blast (30% damage + 3% per attack speed%)",
			[5] = "Unleash a hail of projectiles - ranged attacks have a 18% chance for a 2x2 AoE blast (30% damage + 3% per attack speed%)",
			[6] = "Unleash a hail of projectiles - ranged attacks have a 20% chance for a 2x2 AoE blast (30% damage + 3% per attack speed%)",
			[7] = "Unleash a hail of projectiles - ranged attacks have a 22% chance for a 2x2 AoE blast (30% damage + 3% per attack speed%)",
			[8] = "Unleash a hail of projectiles - ranged attacks have a 24% chance for a 2x2 AoE blast (30% damage + 3% per attack speed%)",
			[9] = "Unleash a hail of projectiles - ranged attacks have a 26% chance for a 2x2 AoE blast (30% damage + 3% per attack speed%)",
			[10] = "Unleash a hail of projectiles - ranged attacks have a 28% chance for a 2x2 AoE blast (30% damage + 3% per attack speed%)"
		}
	},

	-- Card 94: Sniper (onBowAttack/onWandAttack - missile damage scaled by distance)
	[94] = {
		name = "Sniper",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "sniper",
		descriptions = {
			[1] = "Precision from afar - ranged attacks have a 15% chance to fire a bonus missile, damage scales with distance (level x0.30 x tiles)",
			[2] = "Precision from afar - ranged attacks have a 17% chance to fire a bonus missile, damage scales with distance (level x0.35 x tiles)",
			[3] = "Precision from afar - ranged attacks have a 19% chance to fire a bonus missile, damage scales with distance (level x0.40 x tiles)",
			[4] = "Precision from afar - ranged attacks have a 21% chance to fire a bonus missile, damage scales with distance (level x0.45 x tiles)",
			[5] = "Precision from afar - ranged attacks have a 23% chance to fire a bonus missile, damage scales with distance (level x0.50 x tiles)",
			[6] = "Precision from afar - ranged attacks have a 25% chance to fire a bonus missile, damage scales with distance (level x0.55 x tiles)",
			[7] = "Precision from afar - ranged attacks have a 27% chance to fire a bonus missile, damage scales with distance (level x0.60 x tiles)",
			[8] = "Precision from afar - ranged attacks have a 29% chance to fire a bonus missile, damage scales with distance (level x0.65 x tiles)",
			[9] = "Precision from afar - ranged attacks have a 31% chance to fire a bonus missile, damage scales with distance (level x0.70 x tiles)",
			[10] = "Precision from afar - ranged attacks have a 33% chance to fire a bonus missile, damage scales with distance (level x0.75 x tiles)"
		}
	},

	-- Card 95: Doom (onAttack - death damage triggers crit + death damage buff)
	[95] = {
		name = "Doom",
		rarity = "epic",
		trigger = "onHit",
		cardFrame = "doom",
		descriptions = {
			[1] = "Embrace the void - dealing death damage has a 15% chance to empower you with +2% crit and +10% death damage for 5s",
			[2] = "Embrace the void - dealing death damage has a 17% chance to empower you with +3% crit and +12% death damage for 5s",
			[3] = "Embrace the void - dealing death damage has a 19% chance to empower you with +4% crit and +14% death damage for 5s",
			[4] = "Embrace the void - dealing death damage has a 21% chance to empower you with +5% crit and +16% death damage for 5s",
			[5] = "Embrace the void - dealing death damage has a 23% chance to empower you with +6% crit and +18% death damage for 5s",
			[6] = "Embrace the void - dealing death damage has a 25% chance to empower you with +7% crit and +20% death damage for 5s",
			[7] = "Embrace the void - dealing death damage has a 27% chance to empower you with +8% crit and +23% death damage for 5s",
			[8] = "Embrace the void - dealing death damage has a 29% chance to empower you with +9% crit and +26% death damage for 5s",
			[9] = "Embrace the void - dealing death damage has a 31% chance to empower you with +10% crit and +30% death damage for 5s",
			[10] = "Embrace the void - dealing death damage has a 33% chance to empower you with +12% crit and +35% death damage for 5s"
		}
	},

	-- Card 96: Candle of Atonement (Passive bonuses + holy damage shield)
	[96] = {
		name = "Candle of Atonement",
		rarity = "common",
		trigger = "passive",
		cardFrame = "candleofattonenment",
		descriptions = {
			[1] = "Sacred flame guides your path - +10% healing and shielding. Holy damage generates a shield equal to 10% of damage dealt (2s, 10s CD)",
			[2] = "Sacred flame guides your path - +12% healing and shielding. Holy damage generates a shield equal to 12% of damage dealt (2s, 10s CD)",
			[3] = "Sacred flame guides your path - +14% healing and shielding. Holy damage generates a shield equal to 14% of damage dealt (2s, 10s CD)",
			[4] = "Sacred flame guides your path - +16% healing and shielding. Holy damage generates a shield equal to 16% of damage dealt (2s, 10s CD)",
			[5] = "Sacred flame guides your path - +18% healing and shielding. Holy damage generates a shield equal to 18% of damage dealt (2s, 10s CD)",
			[6] = "Sacred flame guides your path - +20% healing and shielding. Holy damage generates a shield equal to 20% of damage dealt (2s, 10s CD)",
			[7] = "Sacred flame guides your path - +23% healing and shielding. Holy damage generates a shield equal to 23% of damage dealt (2s, 10s CD)",
			[8] = "Sacred flame guides your path - +26% healing and shielding. Holy damage generates a shield equal to 26% of damage dealt (2s, 10s CD)",
			[9] = "Sacred flame guides your path - +30% healing and shielding. Holy damage generates a shield equal to 30% of damage dealt (2s, 10s CD)",
			[10] = "Sacred flame guides your path - +35% healing and shielding. Holy damage generates a shield equal to 35% of damage dealt (2s, 10s CD)"
		}
	},

	-- Card 97: Dark Commander (onDeath - summon death causes AoE damage)
	[97] = {
		name = "Dark Commander",
		rarity = "common",
		trigger = "passive",
		cardFrame = "dark commander",
		descriptions = {
			[1] = "Your fallen servants detonate in dark fury - when a summon dies, it explodes dealing 10% of its max HP as AoE damage",
			[2] = "Your fallen servants detonate in dark fury - when a summon dies, it explodes dealing 12% of its max HP as AoE damage",
			[3] = "Your fallen servants detonate in dark fury - when a summon dies, it explodes dealing 14% of its max HP as AoE damage",
			[4] = "Your fallen servants detonate in dark fury - when a summon dies, it explodes dealing 16% of its max HP as AoE damage",
			[5] = "Your fallen servants detonate in dark fury - when a summon dies, it explodes dealing 18% of its max HP as AoE damage",
			[6] = "Your fallen servants detonate in dark fury - when a summon dies, it explodes dealing 20% of its max HP as AoE damage",
			[7] = "Your fallen servants detonate in dark fury - when a summon dies, it explodes dealing 23% of its max HP as AoE damage",
			[8] = "Your fallen servants detonate in dark fury - when a summon dies, it explodes dealing 26% of its max HP as AoE damage",
			[9] = "Your fallen servants detonate in dark fury - when a summon dies, it explodes dealing 30% of its max HP as AoE damage",
			[10] = "Your fallen servants detonate in dark fury - when a summon dies, it explodes dealing 35% of its max HP as AoE damage"
		}
	},

	-- Card 98: The Hero (onKill - gain fame points)
	[98] = {
		name = "The Hero",
		rarity = "common",
		trigger = "onKill",
		cardFrame = "the hero",
		descriptions = {
			[1] = "Your legend grows with every conquest - earn +10% bonus fame points when slaying monsters level 2 or higher",
			[2] = "Your legend grows with every conquest - earn +12% bonus fame points when slaying monsters level 2 or higher",
			[3] = "Your legend grows with every conquest - earn +14% bonus fame points when slaying monsters level 2 or higher",
			[4] = "Your legend grows with every conquest - earn +16% bonus fame points when slaying monsters level 2 or higher",
			[5] = "Your legend grows with every conquest - earn +18% bonus fame points when slaying monsters level 2 or higher",
			[6] = "Your legend grows with every conquest - earn +20% bonus fame points when slaying monsters level 2 or higher",
			[7] = "Your legend grows with every conquest - earn +23% bonus fame points when slaying monsters level 2 or higher",
			[8] = "Your legend grows with every conquest - earn +26% bonus fame points when slaying monsters level 2 or higher",
			[9] = "Your legend grows with every conquest - earn +30% bonus fame points when slaying monsters level 2 or higher",
			[10] = "Your legend grows with every conquest - earn +35% bonus fame points when slaying monsters level 2 or higher"
		}
	},

	-- Card 99: Fire Circus (onSpell - orbital fire rings)
	[99] = {
		name = "Fire Circus",
		rarity = "rare",
		trigger = "onAttackSpell",
		cardFrame = "fire circus",
		descriptions = {
			[1] = "Set the arena ablaze - attack spells have a 12% chance to summon 5 orbiting fire rings dealing 20% damage each for 6s",
			[2] = "Set the arena ablaze - attack spells have a 14% chance to summon 5 orbiting fire rings dealing 25% damage each for 6s",
			[3] = "Set the arena ablaze - attack spells have a 16% chance to summon 5 orbiting fire rings dealing 30% damage each for 6s",
			[4] = "Set the arena ablaze - attack spells have a 18% chance to summon 5 orbiting fire rings dealing 35% damage each for 6s",
			[5] = "Set the arena ablaze - attack spells have a 20% chance to summon 5 orbiting fire rings dealing 40% damage each for 6s",
			[6] = "Set the arena ablaze - attack spells have a 23% chance to summon 5 orbiting fire rings dealing 45% damage each for 6s",
			[7] = "Set the arena ablaze - attack spells have a 26% chance to summon 5 orbiting fire rings dealing 50% damage each for 6s",
			[8] = "Set the arena ablaze - attack spells have a 30% chance to summon 5 orbiting fire rings dealing 55% damage each for 6s",
			[9] = "Set the arena ablaze - attack spells have a 35% chance to summon 5 orbiting fire rings dealing 60% damage each for 6s",
			[10] = "Set the arena ablaze - attack spells have a 40% chance to summon 5 orbiting fire rings dealing 70% damage each for 6s"
		}
	},

	-- Card 100: Carnival (onKill - explosive balloon summon)
	[100] = {
		name = "Carnival",
		rarity = "legendary",
		trigger = "onKill",
		cardFrame = "carnival",
		descriptions = {
			[1] = "The show must go on - gain +1 magic level. Kills have a 15% chance to spawn an explosive balloon (50% AoE damage, scales with magic level, 3s)",
			[2] = "The show must go on - gain +2 magic level. Kills have a 18% chance to spawn an explosive balloon (60% AoE damage, scales with magic level, 3s)",
			[3] = "The show must go on - gain +3 magic level. Kills have a 21% chance to spawn an explosive balloon (70% AoE damage, scales with magic level, 3s)",
			[4] = "The show must go on - gain +4 magic level. Kills have a 24% chance to spawn an explosive balloon (80% AoE damage, scales with magic level, 3s)",
			[5] = "The show must go on - gain +5 magic level. Kills have a 27% chance to spawn an explosive balloon (90% AoE damage, scales with magic level, 3s)",
			[6] = "The show must go on - gain +6 magic level. Kills have a 30% chance to spawn an explosive balloon (100% AoE damage, scales with magic level, 3s)",
			[7] = "The show must go on - gain +7 magic level. Kills have a 33% chance to spawn an explosive balloon (110% AoE damage, scales with magic level, 3s)",
			[8] = "The show must go on - gain +8 magic level. Kills have a 36% chance to spawn an explosive balloon (120% AoE damage, scales with magic level, 3s)",
			[9] = "The show must go on - gain +9 magic level. Kills have a 40% chance to spawn an explosive balloon (130% AoE damage, scales with magic level, 3s)",
			[10] = "The show must go on - gain +10 magic level. Kills have a 45% chance to spawn an explosive balloon (150% AoE damage, scales with magic level, 3s)"
		}
	},

	-- Card 101: The Clown (onAttack - clones throwing pies)
	[101] = {
		name = "The Clown",
		rarity = "rare",
		trigger = "onAttackSpell",
		cardFrame = "clown",
		descriptions = {
			[1] = "Chaos is the punchline - attacks have a 5% chance to summon 1 mischievous clone hurling explosive pies",
			[2] = "Chaos is the punchline - attacks have a 7% chance to summon 1 mischievous clone hurling explosive pies",
			[3] = "Chaos is the punchline - attacks have a 9% chance to summon 2 mischievous clones hurling explosive pies",
			[4] = "Chaos is the punchline - attacks have a 11% chance to summon 2 mischievous clones hurling explosive pies",
			[5] = "Chaos is the punchline - attacks have a 13% chance to summon 3 mischievous clones hurling explosive pies",
			[6] = "Chaos is the punchline - attacks have a 15% chance to summon 3 mischievous clones hurling explosive pies",
			[7] = "Chaos is the punchline - attacks have a 17% chance to summon 4 mischievous clones hurling explosive pies",
			[8] = "Chaos is the punchline - attacks have a 19% chance to summon 4 mischievous clones hurling explosive pies",
			[9] = "Chaos is the punchline - attacks have a 22% chance to summon 5 mischievous clones hurling explosive pies",
			[10] = "Chaos is the punchline - attacks have a 25% chance to summon 6 mischievous clones hurling explosive pies"
		}
	},

	-- Card 102: Dark Monk (onAttack - death damage buff)
	[102] = {
		name = "Dark Monk",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "dark monk",
		descriptions = {
			[1] = "Forbidden martial arts infuse your strikes with darkness - physical attacks have a 1% chance to gain +1 death damage for 10s",
			[2] = "Forbidden martial arts infuse your strikes with darkness - physical attacks have a 2% chance to gain +2 death damage for 10s",
			[3] = "Forbidden martial arts infuse your strikes with darkness - physical attacks have a 3% chance to gain +3 death damage for 10s",
			[4] = "Forbidden martial arts infuse your strikes with darkness - physical attacks have a 4% chance to gain +4 death damage for 10s",
			[5] = "Forbidden martial arts infuse your strikes with darkness - physical attacks have a 5% chance to gain +5 death damage for 10s",
			[6] = "Forbidden martial arts infuse your strikes with darkness - physical attacks have a 6% chance to gain +6 death damage for 10s",
			[7] = "Forbidden martial arts infuse your strikes with darkness - physical attacks have a 7% chance to gain +7 death damage for 10s",
			[8] = "Forbidden martial arts infuse your strikes with darkness - physical attacks have a 8% chance to gain +8 death damage for 10s",
			[9] = "Forbidden martial arts infuse your strikes with darkness - physical attacks have a 9% chance to gain +9 death damage for 10s",
			[10] = "Forbidden martial arts infuse your strikes with darkness - physical attacks have a 10% chance to gain +10 death damage for 10s"
		}
	},

	-- Card 103: The Priest (onHeal - holy charges for spell damage boost)
	[103] = {
		name = "The Priest",
		rarity = "legendary",
		trigger = "onHeal",
		cardFrame = "the priest",
		descriptions = {
			[1] = "Devotion empowers destruction - each heal builds a holy charge. At 3 charges, your next spell surges with +15% bonus damage",
			[2] = "Devotion empowers destruction - each heal builds a holy charge. At 3 charges, your next spell surges with +18% bonus damage",
			[3] = "Devotion empowers destruction - each heal builds a holy charge. At 3 charges, your next spell surges with +21% bonus damage",
			[4] = "Devotion empowers destruction - each heal builds a holy charge. At 3 charges, your next spell surges with +24% bonus damage",
			[5] = "Devotion empowers destruction - each heal builds a holy charge. At 3 charges, your next spell surges with +27% bonus damage",
			[6] = "Devotion empowers destruction - each heal builds a holy charge. At 3 charges, your next spell surges with +30% bonus damage",
			[7] = "Devotion empowers destruction - each heal builds a holy charge. At 3 charges, your next spell surges with +33% bonus damage",
			[8] = "Devotion empowers destruction - each heal builds a holy charge. At 3 charges, your next spell surges with +36% bonus damage",
			[9] = "Devotion empowers destruction - each heal builds a holy charge. At 3 charges, your next spell surges with +42% bonus damage",
			[10] = "Devotion empowers destruction - each heal builds a holy charge. At 3 charges, your next spell surges with +48% bonus damage"
		}
	},

	-- Card 104: Backtoashes (onKill - death missiles to nearby enemies)
	[104] = {
		name = "Backtoashes",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "backtoashes",
		descriptions = {
			[1] = "From ashes they shall burn - kills have a 5% chance to unleash 2 death missiles at all nearby enemies",
			[2] = "From ashes they shall burn - kills have a 6% chance to unleash 2 death missiles at all nearby enemies",
			[3] = "From ashes they shall burn - kills have a 7% chance to unleash 3 death missiles at all nearby enemies",
			[4] = "From ashes they shall burn - kills have a 8% chance to unleash 3 death missiles at all nearby enemies",
			[5] = "From ashes they shall burn - kills have a 9% chance to unleash 4 death missiles at all nearby enemies",
			[6] = "From ashes they shall burn - kills have a 10% chance to unleash 4 death missiles at all nearby enemies",
			[7] = "From ashes they shall burn - kills have a 11% chance to unleash 5 death missiles at all nearby enemies",
			[8] = "From ashes they shall burn - kills have a 12% chance to unleash 5 death missiles at all nearby enemies",
			[9] = "From ashes they shall burn - kills have a 14% chance to unleash 6 death missiles at all nearby enemies",
			[10] = "From ashes they shall burn - kills have a 16% chance to unleash 6 death missiles at all nearby enemies"
		}
	}
}
