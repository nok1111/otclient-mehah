PassiveSkills.nodeInfo = {
	["1:0"] = {
		name = "Arcane Attunement",
		description = "You are attuned to all elements. Increases max mana by 2% and all magic damage by 1%.",
		effect = {
			{type = "condition", name = "MaxMana", value = 2},
			{type = "condition", name = "ElementalDamage", value = 1},
		},
	},
	["1:1"] = {
		name = "Ember Spark",
		description = "+1% fire damage per level.",
		effect = {
			{type = "storage", name = "EmberSurge", value = 1},
		},
	},
	["1:2"] = {
		name = "Searing Mind",
		description = "+1% critical hit chance per level.",
		effect = {
			{type = "storage", name = "CriticalChance", value = 1},
		},
	},
	["1:3"] = {
		name = "Fork: Flame Path",
		description = "Choose a fire specialization.",
	},
	["1:4"] = {
		name = "Wildfire",
		description = "Fire damage has a 3% chance per level to spread burning to nearby enemies.",
		effect = {
			{type = "storage", name = "Wildfire", value = 3},
		},
	},
	["1:5"] = {
		name = "Concentrated Flame",
		description = "Single-target fire spells deal 4% additional damage per level.",
		effect = {
			{type = "storage", name = "ConcentratedFlame", value = 4},
		},
	},
	["1:6"] = {
		name = "Pyromaniac",
		description = "Fire damage has a 5% chance per level to trigger a burning explosion on the target.",
		effect = {
			{type = "storage", name = "Pyromaniac", value = 1},
		},
	},
	["1:7"] = {
		name = "Hand of God",
		description = "Unlocks the spell Hand of God.",
		effect = {
			{type = "spell", name = "Hand of God"},
		},
	},
	["1:8"] = {
		name = "Blazing Decree",
		description = "+2% fire damage per level.",
		effect = {
			{type = "storage", name = "BlazingDecree", value = 2},
		},
	},
	["1:9"] = {
		name = "Inferno Mastery",
		description = "Burning effects deal 5% more damage per level.",
		effect = {
			{type = "storage", name = "InfernoMastery", value = 5},
		},
	},
	["1:10"] = {
		name = "Pyromancer",
		description = "Fire spells have a 15% chance to inflict a burning mark that explodes after 3 seconds.",
		effect = {
			{type = "storage", name = "PyromancerKeystone", value = 15},
		},
	},
	["1:11"] = {
		name = "Glacial Empowerment",
		description = "+1% ice damage per level.",
		effect = {
			{type = "storage", name = "IceDamage", value = 1},
		},
	},
	["1:12"] = {
		name = "Frozen Core",
		description = "+2% max health per level.",
		effect = {
			{type = "storage", name = "MaxHealth", value = 2},
		},
	},
	["1:13"] = {
		name = "Fork: Frost Path",
		description = "Choose a frost specialization.",
	},
	["1:14"] = {
		name = "Permafrost",
		description = "Ice damage has a 10% chance to slow the target by 10% per level.",
		effect = {
			{type = "storage", name = "PermafrostSlow", value = 10},
		},
	},
	["1:15"] = {
		name = "Ice Shards",
		description = "Ice damage has a 5% chance per level to launch shards at nearby enemies.",
		effect = {
			{type = "storage", name = "IceShardsProc", value = 5},
		},
	},
	["1:16"] = {
		name = "Frost Wave",
		description = "Unlocks the spell Frost Wave.",
		effect = {
			{type = "spell", name = "Frost Wave"},
		},
	},
	["1:17"] = {
		name = "Wand Specialist",
		description = "+3% wand damage per level.",
		effect = {
			{type = "storage", name = "WandDamage", value = 3},
		},
	},
	["1:18"] = {
		name = "Frost Shards Barrage",
		description = "+2% ice damage and Ice Barrage deals 5% more damage per level.",
		effect = {
			{type = "storage", name = "IceBarrage", value = 5},
		},
	},
	["1:19"] = {
		name = "Winter's Grasp",
		description = "Frost spells have a 5% chance per level to freeze the target for 1.5 seconds.",
		effect = {
			{type = "storage", name = "WintersGraspMastery", value = 5},
		},
	},
	["1:20"] = {
		name = "Cryomancer",
		description = "Ice damage against slowed enemies deals 15% more damage.",
		effect = {
			{type = "storage", name = "CryomancerKeystone", value = 15},
		},
	},
	["1:21"] = {
		name = "Mana Infusion",
		description = "+2% max mana per level.",
		effect = {
			{type = "storage", name = "MaxMana", value = 2},
		},
	},
	["1:22"] = {
		name = "Scholar's Wit",
		description = "+2% magic level per level.",
		effect = {
			{type = "storage", name = "MagicLevel", value = 2},
		},
	},
	["1:23"] = {
		name = "Fork: Arcane Path",
		description = "Choose an arcane specialization.",
	},
	["1:24"] = {
		name = "Spellweaver",
		description = "Spells deal 2% additional damage per level.",
		effect = {
			{type = "storage", name = "Spellweaver", value = 2},
		},
	},
	["1:25"] = {
		name = "Arcane Missiles",
		description = "Unlocks the spell Arcane Missiles. Energy Blast grants 1 charge of Arcane Surge, stacking up to 6 charges. Each charge increases the number of Arcane Missiles fired.",
		effect = {
			{type = "spell", name = "Arcane Missiles"},
		},
	},
	["1:26"] = {
		name = "Riftwalker",
		description = "Increases teleport distance by 1 tile and grants 10% magic level for 5 seconds after teleporting.",
		effect = {
			{type = "storage", name = "TeleportDistance", value = 1},
		},
	},
	["1:27"] = {
		name = "Arcane Barrage",
		description = "Arcane spells deal 3% additional damage per level.",
		effect = {
			{type = "storage", name = "ArcaneBarrage", value = 3},
		},
	},
	["1:28"] = {
		name = "Archmage Mastery",
		description = "All spells cost 1% less mana per level (max 5).",
		effect = {
			{type = "storage", name = "ArchmageMastery", value = 1},
		},
	},
	["1:29"] = {
		name = "Mana Surge",
		description = "Casting spells restores 2% of max mana per level.",
		effect = {
			{type = "storage", name = "ManaSurge", value = 2},
		},
	},
	["1:30"] = {
		name = "Arcanist",
		description = "Spending mana grants a stack of Arcane Momentum, increasing spell damage by 2% per stack for 6 seconds. Stacks up to 5 times.",
		effect = {
			{type = "storage", name = "ArcanistKeystone", value = 2},
		},
	},
	["1:31"] = {
		name = "Elemental Fusion",
		description = "While a target is burning, your ice damage is increased by 10%. While a target is frozen, your fire damage is increased by 10%.",
		effect = {
			{type = "storage", name = "ElementalFusion", value = 10},
		},
	},
	["1:32"] = {
		name = "Mana Furnace",
		description = "Spending mana increases fire damage by 10% for 5 seconds.",
		effect = {
			{type = "storage", name = "ManaFurnace", value = 10},
		},
	},
	["1:33"] = {
		name = "Frozen Arcana",
		description = "Ice spells restore 2% of your max mana on hit.",
		effect = {
			{type = "storage", name = "FrozenArcana", value = 2},
		},
	},
	["2:0"] = {
		name = "Sacred Resolve",
		description = "Dedicate yourself to the holy cause. Increases max health and mana by 2%.",
		effect = {
			{type = "condition", name = "Max Health", value = 2},
			{type = "condition", name = "Max Mana", value = 2},
		},
	},
	["2:1"] = {
		name = "Unyielding Strength",
		description = "Increase physical damage done by 3% per level.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 3},
		},
	},
	["2:2"] = {
		name = "Consecrated Strikes",
		description = "Every 4 melee hits has a 20% chance per level to trigger a consecrated strike dealing extra holy damage.",
		effect = {
			{type = "storage", name = "ConsecratedStrikes", value = 20},
		},
	},
	["2:3"] = {
		name = "Path of Retribution",
		description = "Choose your path of judgment.",
	},
	["2:4"] = {
		name = "Righteous Focus",
		description = "Your Judgement grants 4% critical strike chance per level for 3 seconds.",
		effect = {
			{type = "storage", name = "RighteousFocus", value = 4},
		},
	},
	["2:5"] = {
		name = "Lawbringer's Shock",
		description = "Your Judgement has a 5% chance per level to stun the target for 2 seconds.",
		effect = {
			{type = "storage", name = "JudmentStun", value = 5},
		},
	},
	["2:6"] = {
		name = "Final Verdict",
		description = "Holy strike deals an additional 5% damage per level to enemies below 50% health.",
		effect = {
			{type = "storage", name = "FinalVeredict", value = 5},
		},
	},
	["2:7"] = {
		name = "Blessed Judgment",
		description = "Judgement now heals 2% of your max health per level.",
		effect = {
			{type = "storage", name = "BlessedJudgment", value = 2},
		},
	},
	["2:8"] = {
		name = "Divine Punishment",
		description = "Learn the spell Divine Punishment.",
		effect = {
			{type = "spell", name = "Divine Punishment"},
		},
	},
	["2:11"] = {
		name = "Blessed Fortitude",
		description = "Increases max health by 3% per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["2:12"] = {
		name = "Consecrated Protection",
		description = "Reduce all damage taken while standing on holy ground by 2% per level.",
		effect = {
			{type = "storage", name = "ConsecratedProtection", value = 2},
		},
	},
	["2:13"] = {
		name = "Stalwart Discipline",
		description = "Choose your defensive doctrine.",
	},
	["2:14"] = {
		name = "Sanctified Power",
		description = "Increase the damage of your holy ground by 8% per level.",
		effect = {
			{type = "storage", name = "SanctifiedPower", value = 8},
		},
	},
	["2:15"] = {
		name = "Echoing Command",
		description = "Your Taunt deals Holy damage equal to 2% of your max health per level and applies a shield for 4 seconds equal to 30% of your max health.",
		effect = {
			{type = "storage", name = "EchoingCommand", value = 2},
		},
	},
	["2:16"] = {
		name = "Aegis of Faith",
		description = "Increase block chance by 2% per level.",
		effect = {
			{type = "condition", name = "Block Chance", value = 2},
		},
	},
	["2:17"] = {
		name = "Taunting Presence",
		description = "Reduce cooldowns by 2% per level.",
		effect = {
			{type = "condition", name = "Cooldown Reduction", value = 2},
		},
	},
	["2:18"] = {
		name = "Bulwark of the Martyr",
		description = "Increases max health by 2% per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 2},
		},
	},
	["2:19"] = {
		name = "Guardian of Light",
		description = "Learn the spell Guardian of Light.",
		effect = {
			{type = "spell", name = "Guardian of Light"},
		},
	},
	["2:20"] = {
		name = "Sacred Ground",
		description = "Learn the spell Sacred Ground.",
		effect = {
			{type = "spell", name = "Sacred Ground"},
		},
	},
	["2:21"] = {
		name = "Well of Power",
		description = "Increases max mana by 2% per level.",
		effect = {
			{type = "condition", name = "Max Mana", value = 2},
		},
	},
	["2:22"] = {
		name = "Radiant Focus",
		description = "Light beam damage increased by 12% per level.",
		effect = {
			{type = "storage", name = "RadiantFocus", value = 12},
		},
	},
	["2:23"] = {
		name = "Sacred Calling",
		description = "Choose your path of sacred healing.",
	},
	["2:24"] = {
		name = "Blessed Impact",
		description = "Holy strike has a 10% chance per level to trigger a holy light which heals you scaling with 10% of your max mana.",
		effect = {
			{type = "storage", name = "BlessedImpact", value = 10},
		},
	},
	["2:25"] = {
		name = "Judgment of Wisdom",
		description = "Judgement restores 3% of your total mana per level and applies a shield for the same amount for 3 seconds.",
		effect = {
			{type = "storage", name = "JudmentRestore", value = 3},
		},
	},
	["2:26"] = {
		name = "Enlightened Punishment",
		description = "Judgement and Exorcism deal 1% of your total mana as extra damage per level.",
		effect = {
			{type = "storage", name = "JudmentManaExtraDamage", value = 1},
		},
	},
	["2:27"] = {
		name = "Holy Ascendancy",
		description = "Increase all holy damage by 2% per level.",
		effect = {
			{type = "condition", name = "Holy Damage", value = 2},
		},
	},
	["2:28"] = {
		name = "Sacred Resonance",
		description = "Increases max mana by 2% per level.",
		effect = {
			{type = "condition", name = "Max Mana", value = 2},
		},
	},
	["2:29"] = {
		name = "Angelic Form",
		description = "Learn the spell Angelic Form.",
		effect = {
			{type = "spell", name = "Angelic Form"},
		},
	},
	["2:30"] = {
		name = "Righteous Bulwark",
		description = "Your faith hardens your strikes. Increases holy damage by 5% while you have unlocked Lawbringer's Shock and Sanctified Power.",
		effect = {
			{type = "condition", name = "Holy Damage", value = 5},
		},
	},
	["2:31"] = {
		name = "Sacred Sentinel",
		description = "The light sustains both body and soul. Increases max health and mana by 3% while you have unlocked Echoing Command and Judgment of Wisdom.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
			{type = "condition", name = "Max Mana", value = 3},
		},
	},
	["2:32"] = {
		name = "Kings Blessing",
		description = "Learn the spell King's Blessing.",
		effect = {
			{type = "spell", name = "Kings Blessing"},
		},
	},
	["3:0"] = {
		name = "Core",
		description = "",
	},
	["3:1"] = {
		name = "Veiled Might",
		description = "Increase physical damage done by 6% per level",
		effect = {
			{type = "condition", name = "Physical Damage", value = 6},
		},
	},
	["3:2"] = {
		name = "Assassin's Mastery",
		description = "Lethal Dagger now deals 5% (per level) extra physical damage and has a chance of 20% (per level) to apply a bleed to the target",
		effect = {
			{type = "storage", name = "AssassinsMastery", value = 20},
		},
	},
	["3:3"] = {
		name = "Scent of Blood",
		description = "Deal 3% (per level) extra damage to bleeding targets",
		effect = {
			{type = "storage", name = "ScentOfBlood", value = 3},
		},
	},
	["3:4"] = {
		name = "Virulent Rupture",
		description = "Dark rupture has a 15% (per level) chance to spill corrupted blood over nearby targets applying the same bleeding effects at 35% effectiveness.",
		effect = {
			{type = "storage", name = "VirulentRupture", value = 15},
		},
	},
	["3:5"] = {
		name = "Blood Drinker",
		description = "Increases the amount of life leech by 1% (per level)",
		effect = {
			{type = "condition", name = "Life Leech", value = 1},
		},
	},
	["3:6"] = {
		name = "Assassination",
		description = "Learn spell Assassination",
		effect = {
			{type = "spell", name = "Assassination"},
		},
	},
	["3:7"] = {
		name = "Quickstep",
		description = "Increases Dodge Chance by 2% per level",
		effect = {
			{type = "condition", name = "Dodge", value = 2},
		},
	},
	["3:8"] = {
		name = "Frenzied Blades",
		description = "Increases attack speed by 2% per level",
		effect = {
			{type = "condition", name = "Attack Speed", value = 2},
		},
	},
	["3:9"] = {
		name = "Blackout",
		description = "Learn spell Blackout",
		effect = {
			{type = "spell", name = "Blackout"},
		},
	},
	["3:10"] = {
		name = "Death's Approach",
		description = "lethal dagger has a 12% (per level) chance to teleport you to your marked target and deal an aditional extra deathdamage",
		effect = {
			{type = "storage", name = "DeathApproach", value = 12},
		},
	},
	["3:11"] = {
		name = "Killing Instinct",
		description = "Increases critical chance by 2% per level",
		effect = {
			{type = "condition", name = "Critcial Chance", value = 2},
		},
	},
	["3:12"] = {
		name = "Stealth",
		description = "Increases stealth duration by 1 second per level",
		effect = {
			{type = "storage", name = "StealthDuration", value = 1},
		},
	},
	["3:13"] = {
		name = "Butcher's Art",
		description = "Increases mutilate damage by 3% per level",
		effect = {
			{type = "storage", name = "ButchersArt", value = 3},
		},
	},
	["3:14"] = {
		name = "Dark Transmutation",
		description = "Transforms Mutilate damage into Death Damage and increases Death Damage done  by 8% per level",
		effect = {
			{type = "storage", name = "DarkTransmutation", value = 1},
			{type = "condition", name = "Death Damage", value = 8},
		},
	},
	["3:15"] = {
		name = "Shadow Reflection",
		description = "Lethal dagger now has a chance 12% per level to create a  shadow version of yourself wich deals death damage for 6 seconds.",
		effect = {
			{type = "storage", name = "ShadowReflection", value = 12},
		},
	},
	["3:16"] = {
		name = "Deathwind",
		description = "Transforms Fan of Knives damage into Death Damage and increases its over time damage effect  by 4% per level",
		effect = {
			{type = "storage", name = "Deathwind", value = 4},
		},
	},
	["3:17"] = {
		name = "Deathbringer",
		description = "Your melee attacks have a 3% (per level) chance to deal extra death damage on hit.",
		effect = {
			{type = "storage", name = "Deathbringer", value = 3},
		},
	},
	["3:18"] = {
		name = "Void Execution",
		description = "Learn spell Void Execution",
		effect = {
			{type = "spell", name = "Void Execution"},
		},
	},
	["4:0"] = {
		name = "Core",
		description = "",
	},
	["4:1"] = {
		name = "Scaled Rupture",
		description = "Increase Rend damage by 3% (per level)",
		effect = {
			{type = "storage", name = "ScaledRupture", value = 3},
		},
	},
	["4:2"] = {
		name = "Colossal Blows",
		description = "Increase physical damage done by 2% per level",
		effect = {
			{type = "condition", name = "Physical Damage", value = 2},
		},
	},
	["4:3"] = {
		name = "Shockwave",
		description = "Learn spell Shockwave",
		effect = {
			{type = "spell", name = "Shockwave"},
		},
	},
	["4:4"] = {
		name = "Lifeblood Strike",
		description = "Increase the health gain from your brutal swing by 10% (per level)",
		effect = {
			{type = "storage", name = "LifebloodStrike", value = 10},
		},
	},
	["4:5"] = {
		name = "Heartseeker",
		description = "Increase critical strike chance by 2% (per level)",
		effect = {
			{type = "condition", name = "Critical Strike", value = 2},
		},
	},
	["4:6"] = {
		name = "Bloodlust",
		description = "Learn spell Bloodlust",
		effect = {
			{type = "spell", name = "Bloodlust"},
		},
	},
	["4:7"] = {
		name = "Goliath",
		description = "Increase max health by 4% (per level)",
		effect = {
			{type = "condition", name = "MaxHealthPercent", value = 4},
		},
	},
	["4:8"] = {
		name = "Bloodthirst",
		description = "Increases life leech by 2% (per level)",
		effect = {
			{type = "condition", name = "Life Leech", value = 2},
		},
	},
	["4:9"] = {
		name = "Dragon Heart",
		description = "Dragon aura now heals the caster, and increases its healing effectiveness by 5% (per level)",
		effect = {
			{type = "storage", name = "DragonHeart", value = 5},
		},
	},
	["4:10"] = {
		name = "Fire Within",
		description = "Learn spell Fire Within",
		effect = {
			{type = "spell", name = "Fire Within"},
		},
	},
	["4:11"] = {
		name = "Survival Instincts",
		description = "Auto attacks heals you per missing health, the heal is increased 1% per missing % health (per level)",
		effect = {
			{type = "storage", name = "SurvivalInstincts", value = 1},
		},
	},
	["4:12"] = {
		name = "Draconic Chains",
		description = "Learn spell Draconic Chains",
		effect = {
			{type = "spell", name = "Draconic Chains"},
		},
	},
	["4:13"] = {
		name = "Ember Touch",
		description = "Auto attacks apply have a 2% (per level) chance to apply a burning effect for 2 seconds (increased per level)",
		effect = {
			{type = "storage", name = "EmberTouch", value = 2},
		},
	},
	["4:14"] = {
		name = "Berserker's Tempo",
		description = "Increases attack speed by 5% (per level)",
		effect = {
			{type = "condition", name = "Attack Speed", value = 5},
		},
	},
	["4:15"] = {
		name = "Rebound Strike",
		description = "brutal swing has a 10% (per level) chance to heal you for 8% of your max health",
		effect = {
			{type = "storage", name = "ReboundStrike", value = 10},
		},
	},
	["4:16"] = {
		name = "Flame Eater",
		description = "Increase the damage done to burning targets by 2% (per level)",
		effect = {
			{type = "storage", name = "FlameEater", value = 2},
		},
	},
	["4:17"] = {
		name = "Phoenix Wrath",
		description = "Learn spell Phoenix Wrath",
		effect = {
			{type = "spell", name = "Phoenix Wrath"},
		},
	},
	["4:18"] = {
		name = "Emberhide",
		description = "Increase elemental resistance by 2% (per level)",
		effect = {
			{type = "storage", name = "Emberhide", value = 2},
		},
	},
	["4:19"] = {
		name = "Dragon Soul",
		description = "Learn spell Dragon Soul",
		effect = {
			{type = "spell", name = "Dragon Soul"},
		},
	},
	["4:20"] = {
		name = "Bloodline",
		description = "Increases the healing of Dragon Soul by 5% (per level)",
		effect = {
			{type = "storage", name = "Bloodline", value = 5},
		},
	},
	["5:0"] = {
		name = "Core",
		description = "",
	},
	["5:1"] = {
		name = "Immortal Flesh",
		description = "Increase you max health by 3% (per level)",
		effect = {
			{type = "condition", name = "MaxHealthPercent", value = 3},
		},
	},
	["5:2"] = {
		name = "Dark Aura",
		description = "Learn spell Dark Aura",
		effect = {
			{type = "spell", name = "Dark Aura"},
		},
	},
	["5:3"] = {
		name = "Lingering Darkness",
		description = "Increase the duration of Dark Aura by 0.5 seconds (per level)",
		effect = {
			{type = "storage", name = "LingeringDarkness", value = 5},
		},
	},
	["5:4"] = {
		name = "Malefic Persistence",
		description = "Increases the duration of Curse by 0.5 second (per level) \nIncreases curse damage by 3% (per level)",
		effect = {
			{type = "storage", name = "MaleficPersistencedamage", value = 3},
			{type = "storage", name = "MaleficPersistenceDuration", value = 5},
		},
	},
	["5:5"] = {
		name = "Malediction",
		description = "Learn spell Malediction",
		effect = {
			{type = "spell", name = "Malediction"},
		},
	},
	["5:6"] = {
		name = "Plague Detonation",
		description = "When Malediction is applied to a target, it has a 20% (per level) chance to explode and send malefic pestilence to nearby enemies",
		effect = {
			{type = "storage", name = "PlagueDetonation", value = 20},
		},
	},
	["5:7"] = {
		name = "Dark Plague",
		description = "Learn spell Dark Plague",
		effect = {
			{type = "spell", name = "Dark Plague"},
		},
	},
	["5:8"] = {
		name = "Lasting Blight",
		description = "Increase malediction, curse and dark plague duration by 0.5 seconds per level",
		effect = {
			{type = "storage", name = "LastingBlight", value = 5},
		},
	},
	["5:9"] = {
		name = "Soulstorm",
		description = "drain soul now also affect an additional nearby cursed enemies around your targets. (+1 additional enemy per level)",
		effect = {
			{type = "storage", name = "Soulstorm", value = 1},
		},
	},
	["5:10"] = {
		name = "Soulstorm Echoes",
		description = "Increases the number of times Drain Soul damages its targets by 1 per level.",
		effect = {
			{type = "storage", name = "SoulstormTicks", value = 1},
		},
	},
	["5:11"] = {
		name = "Demonic Bulwark",
		description = "Increase the max health of your summons by an aditional 18% per level",
		effect = {
			{type = "storage", name = "DemonicBulwark", value = 18},
		},
	},
	["5:12"] = {
		name = "Legion Mastery",
		description = "Increase the maximum number of Servants you can control by 1 (per level) and increase your chance to successfully summon by 100% per level.",
		effect = {
			{type = "storage", name = "LegionMasteryNumber", value = 1},
			{type = "storage", name = "LegionMasteryChance", value = 1},
		},
	},
	["5:13"] = {
		name = "Infernal Command",
		description = "Increases the damage of your summons by 4% (per level).",
		effect = {
			{type = "storage", name = "InfernalCommand", value = 4},
		},
	},
	["5:14"] = {
		name = "Void Mender",
		description = "Learn Spell Summon Void Mender",
		effect = {
			{type = "spell", name = "Summon Void Mender"},
		},
	},
	["5:15"] = {
		name = "Abyssal Refund",
		description = "Your void mender now restores a part of your mana every time it heals a target \nIncrease the healing efficiency by 7% (per level).",
		effect = {
			{type = "storage", name = "AbyssalRefund", value = 7},
		},
	},
	["5:16"] = {
		name = "Void Guard",
		description = "Learn Spell Summon Void Guard",
		effect = {
			{type = "spell", name = "Summon Void Guard"},
		},
	},
	["5:17"] = {
		name = "Pactmaster's Gift",
		description = "Increase the mana transfer from blood pact by 12% per level",
		effect = {
			{type = "storage", name = "PactmasterGift", value = 12},
		},
	},
	["5:18"] = {
		name = "Sanguine Shield",
		description = "Increases the effectiveness of Blood Wall by 12% per level\n\n\nThis node does not require a previous node to be unlocked",
		effect = {
			{type = "storage", name = "BloodWall", value = 12},
		},
	},
	["5:19"] = {
		name = "Zombie Wall",
		description = "Learn Spell Zombie Wall\n\n\nThis node does not require a previous node to be unlocked",
		effect = {
			{type = "spell", name = "Zombie Wall"},
		},
	},
	["6:0"] = {
		name = "Core",
		description = "",
	},
	["6:1"] = {
		name = "Cosmic Focus",
		description = "Increase the energy damage done by 2% per level",
		effect = {
			{type = "condition", name = "Energy Damage", value = 2},
		},
	},
	["6:2"] = {
		name = "Astral Burn",
		description = "Starfall now applies a damaging condition to the target wich deal energy damage for 1 seconds per level",
		effect = {
			{type = "storage", name = "AstralBurn", value = 1},
		},
	},
	["6:3"] = {
		name = "Falling Stars",
		description = "Dealing energy damage has a 2% (per level) chance to trigger a starfall on the target",
		effect = {
			{type = "storage", name = "FallingStars", value = 2},
		},
	},
	["6:4"] = {
		name = "Holy Flare",
		description = "Learn Spell Holy Flare",
		effect = {
			{type = "spell", name = "Holy Flare"},
		},
	},
	["6:5"] = {
		name = "Aery's Rapidfire",
		description = "Increase Aery's Strikes shots by 1 per level",
		effect = {
			{type = "storage", name = "AeryRapidfire", value = 1},
		},
	},
	["6:6"] = {
		name = "Celestial Insight",
		description = "Increases your Magic Level by 2 points per level",
		effect = {
			{type = "condition", name = "MagicLevel", value = 2},
		},
	},
	["6:7"] = {
		name = "Full Moon",
		description = "Learn Spell Full Moon",
		effect = {
			{type = "spell", name = "Full Moon"},
		},
	},
	["6:8"] = {
		name = "Starwell",
		description = "Increases max mana by 4% per level",
		effect = {
			{type = "condition", name = "MaxManaPercent", value = 4},
		},
	},
	["6:9"] = {
		name = "Divine Restoration",
		description = "Increases Healling effectivenessby 6% per level \nReduce the mana cost of moon light by 3% per level",
		effect = {
			{type = "condition", name = "HealingEffectiveness", value = 6},
			{type = "storage", name = "MoonLightManaCost", value = 3},
		},
	},
	["6:10"] = {
		name = "Moonshower",
		description = "Increase the healing of rain fall by 6% (per level)\nincrease the duration of rainfall by 1 second (per level)",
		effect = {
			{type = "storage", name = "RainFallHealing", value = 6},
			{type = "storage", name = "RainFallDuration", value = 1},
		},
	},
	["6:11"] = {
		name = "Luminous Bond",
		description = "Increase the passive healing of Aery by 6% (per level)",
		effect = {
			{type = "storage", name = "LuminousBond", value = 6},
		},
	},
	["6:12"] = {
		name = "Guiding Constellation",
		description = "Cosmic Force now restores 3% of your max mana per level",
		effect = {
			{type = "storage", name = "CosmicForceManaRestore", value = 3},
		},
	},
	["6:13"] = {
		name = "Solar Blessing",
		description = "Learn Spell Solar Blessing\nIncrease the target's max health by 65% for 8 seconds and healing them instantly for 50% of your max mana at the start and ending of spell.",
		effect = {
			{type = "spell", name = "Solar Blessing"},
		},
	},
	["6:14"] = {
		name = "Back to basics",
		description = "+4% wand damage per level",
		effect = {
			{type = "storage", name = "WandDamage", value = 4},
		},
	},
	["6:15"] = {
		name = "Mana Feather",
		description = "Aery now restores 0.2% (per level) of your max mana per basic attack\n\n\nThis node does not require a previous node to be unlocked",
		effect = {
			{type = "storage", name = "AeryManaRestore", value = 2},
		},
	},
	["6:16"] = {
		name = "Sacred Constitution",
		description = "Increases max health by 4.0% per level\n\n\nThis node does not require a previous node to be unlocked",
		effect = {
			{type = "condition", name = "MaxHealthPercent", value = 4},
		},
	},
	["7:0"] = {
		name = "Core",
		description = "",
	},
	["7:1"] = {
		name = "Elemental Harmony",
		description = "Increases the damage of your elemental fists (Fire, Ice, Life) by 2% per level when used in combination",
		effect = {
			{type = "storage", name = "ElementalHarmony", value = 2},
		},
	},
	["7:2"] = {
		name = "Vital Points",
		description = "Increase critical strike chance by 2% per level",
		effect = {
			{type = "condition", name = "Critical Strike", value = 2},
		},
	},
	["7:3"] = {
		name = "Mystic Punch",
		description = "you have a 3% (per level) chance to land a mystic punch every time you deal physical damage",
		effect = {
			{type = "storage", name = "MysticPunch", value = 3},
		},
	},
	["7:4"] = {
		name = "Inner Tempo",
		description = "Landing a mystic punch increases your attack speed by 8% (per level) for 5 seconds",
		effect = {
			{type = "storage", name = "InnerTempo", value = 8},
		},
	},
	["7:5"] = {
		name = "Stormfist",
		description = "Learn Spell Stormfist\n For the next 3 seconds your physical damage sends a lighting shock to nearby target",
		effect = {
			{type = "spell", name = "Stormfist"},
		},
	},
	["7:6"] = {
		name = "Tempest God",
		description = "Empowers Stormfist, extending its duration by 1 second and amplifying its damage by 10% (per level)",
		effect = {
			{type = "storage", name = "StormfistDuration", value = 1},
			{type = "storage", name = "StormfistDamage", value = 10},
		},
	},
	["7:7"] = {
		name = "Rock Mentality",
		description = "Increases max health by 3.0% per level",
		effect = {
			{type = "condition", name = "MaxHealthPercent", value = 3},
		},
	},
	["7:8"] = {
		name = "Meditative Recovery",
		description = "Every time you use a monk healing spell, restore 1.2% of your maximum health and 2% of your maximum mana.",
		effect = {
			{type = "storage", name = "MeditativeRecovery", value = 2},
		},
	},
	["7:9"] = {
		name = "Mountain Stance",
		description = "Learn spell Mountain Stance\nReduce Damage taken by 30% and increases your max health by 25% for 10 seconds",
		effect = {
			{type = "spell", name = "Mountain Stance"},
		},
	},
	["7:10"] = {
		name = "Glacial Palm",
		description = "Your adaptive punch (ice + ice) now has a 5% (per level) chance to trigger Glacial Palm wich deals damage to the target and all nearby enemies.",
		effect = {
			{type = "storage", name = "GlacialPalm", value = 5},
		},
	},
	["7:11"] = {
		name = "Frozen Lotus",
		description = "Triggering glacial palm will now heal you by 15% (per level) of the damage done .",
		effect = {
			{type = "storage", name = "FrozenLotus", value = 15},
		},
	},
	["7:12"] = {
		name = "Frost Blossom",
		description = "Increase the damage by Glacial Palm and Frozen Lotus haling by 6% (per level)",
		effect = {
			{type = "storage", name = "FrostBlossom", value = 6},
		},
	},
	["7:13"] = {
		name = "Vital Palm",
		description = "Increase the healing effectiveness of your adaptive punch (life + life) by 10% (per level)",
		effect = {
			{type = "storage", name = "VitalPalm", value = 10},
		},
	},
	["7:14"] = {
		name = "Chi Transfer",
		description = "Dealing physical melee damage has a chance 3% chance (per level) to send chi healing wave to a nearby ally.",
		effect = {
			{type = "storage", name = "ChiTransfer", value = 3},
		},
	},
	["7:15"] = {
		name = "Mystic Reserves",
		description = "increase your maximum mana by 10% (per level)",
		effect = {
			{type = "condition", name = "MaxManaPercent", value = 5},
		},
	},
	["7:16"] = {
		name = "Life Pulse",
		description = "Every third consecutive Life punch has a 20% (per level) chance to triger a healing chi wave wich heals a random nearby ally.",
		effect = {
			{type = "storage", name = "LifePulse", value = 20},
		},
	},
	["7:17"] = {
		name = "Zen Barrier",
		description = "Learn spell Zen Barrier\nPlace a serenity sphere on a chosen player for 8 seconds. Each time they take damage, the sphere absorbs the damage and instantly heals them for the same amount.",
		effect = {
			{type = "spell", name = "Zen Barrier"},
		},
	},
	["7:18"] = {
		name = "Serene Amplification",
		description = "Increase the healing effectiveness of zen barrier when is casted on yourself and the healing effectiveness of fist of life by 10% (per level)",
		effect = {
			{type = "storage", name = "SereneAmplification", value = 10},
		},
	},
	["8:0"] = {
		name = "Core",
		description = "",
	},
	["8:1"] = {
		name = "Savage Bloom",
		description = "Increase terra strike and carnivorous vile damage by 3% (per level)",
		effect = {
			{type = "storage", name = "SavageBloom", value = 3},
		},
	},
	["8:2"] = {
		name = "Primal Infestation",
		description = "Your nature or earth damage, has a 2% (per level) chance to trigger a carnivorous vile with 45% effectiveness.",
		effect = {
			{type = "storage", name = "PrimalInfestation", value = 2},
		},
	},
	["8:3"] = {
		name = "Swarn of Insects",
		description = "Learn spell Swarn of Insects\nPlace a swarm of insects on a target increasing it's damage received by 10% (per level) from all sources.",
		effect = {
			{type = "spell", name = "Insect Swarm"},
		},
	},
	["8:4"] = {
		name = "Hive Queen",
		description = "Increase your critical damage chance by 2% (per level) for each enemy reached by Swarn of Insects",
		effect = {
			{type = "storage", name = "HiveQueen", value = 2},
		},
	},
	["8:5"] = {
		name = "Thorned Rose",
		description = "Piercing Wave now bleeds enemies dealing physical damage and increse its damage by 2% (per level).",
		effect = {
			{type = "storage", name = "EntanglingRoots", value = 2},
		},
	},
	["8:6"] = {
		name = "Force of Nature",
		description = "Increase the damage done by Wrath of Nature by 4% (per level)",
		effect = {
			{type = "storage", name = "ForceOfNature", value = 4},
		},
	},
	["8:7"] = {
		name = "Spirit Pool",
		description = "Increases maximum mana by 5% per level",
		effect = {
			{type = "condition", name = "MaxManaPercent", value = 5},
		},
	},
	["8:8"] = {
		name = "Life Bloom",
		description = "Learn Life Bloom spell",
		effect = {
			{type = "spell", name = "Life Bloom"},
		},
	},
	["8:9"] = {
		name = "Blooming Wisdom",
		description = "Decrease the % mana cost required to cast life bloom by 2% per level",
		effect = {
			{type = "storage", name = "BloomingWisdom", value = 2},
		},
	},
	["8:10"] = {
		name = "Healing Concentration",
		description = "Increase the effectiveness of Focus Healing by 6% per level",
		effect = {
			{type = "storage", name = "FocusHealing", value = 6},
		},
	},
	["8:11"] = {
		name = "Living Ground",
		description = "Learn Living Ground spell\nPlace a nature ground on your current position wich heal all nearby allies while standing on it.",
		effect = {
			{type = "spell", name = "living ground"},
		},
	},
	["8:12"] = {
		name = "Thorned Sanctuary",
		description = "Living ground now deals damage to nearby enemies every 1.0 seconds, dealing 2% (per level) of your max health as nature damage.",
		effect = {
			{type = "storage", name = "ThornedSanctuary", value = 2},
		},
	},
	["8:13"] = {
		name = "Winter's Grasp",
		description = "Increase your ice damage by 4% per level.",
		effect = {
			{type = "condition", name = "Ice Damage", value = 4},
		},
	},
	["8:14"] = {
		name = "Ice Shatter",
		description = "Learn Ice Shatter spell\nTurn the target into a solid ice block dealing ice damage and a second AOE damage when it ends.",
		effect = {
			{type = "spell", name = "Ice Shatter"},
		},
	},
	["8:15"] = {
		name = "Permafrost Trap",
		description = "Dealing ice damage have a 4% chance to trigger Frost cage , wich dealth ice damage to the target and nearby enemies.",
		effect = {
			{type = "storage", name = "PermafrostTrap", value = 4},
		},
	},
	["8:16"] = {
		name = "Frost Armor",
		description = "Learn Frost Armor spell\nGain a frost armor wich reduces your damage taken by 20% and deals ice damage back to the attacker.",
		effect = {
			{type = "spell", name = "Frost Armor"},
		},
	},
	["8:17"] = {
		name = "Frost Aura",
		description = "frost armor now deals damage to nearby enemies every 1.0 seconds, dealing 1% of your max mana as ice damage.",
		effect = {
			{type = "storage", name = "FrostAura", value = 1},
		},
	},
	["8:18"] = {
		name = "Nature's Endurance",
		description = "Increases max health by 5.0% per level",
		effect = {
			{type = "condition", name = "MaxHealthPercent", value = 5},
		},
	},
	["8:19"] = {
		name = "Bear Form",
		description = "Learn Bear Form spell\n\n\nThis node does not require a previous node to be unlocked",
		effect = {
			{type = "spell", name = "Bear Form"},
		},
	},
	["8:20"] = {
		name = "Wildhide Endurance",
		description = "Increase bear form maximum health and health regeneration by 5% per level",
		effect = {
			{type = "storage", name = "WildhideEndurance", value = 5},
		},
	},
	["9:0"] = {
		name = "Core",
		description = "",
	},
	["9:1"] = {
		name = "Short Circuit",
		description = "During static shock, your attacks have a 10% (per level) chance to deal extra damage to enemies affected by Static Shock. (this effect is increased by magic level and base weapon damage)",
		effect = {
			{type = "storage", name = "ShortCircuit", value = 10},
		},
	},
	["9:2"] = {
		name = "Kinetic Dancer",
		description = "Increase physical damage done by 2% and your energy damage by 2% (per level)",
		effect = {
			{type = "condition", name = "Physical Damage", value = 2},
			{type = "condition", name = "Energy Damage", value = 2},
		},
	},
	["9:3"] = {
		name = "High Voltage",
		description = "Your Short Circuit now have a chance 25% to grant you High Voltage, wich increases your magic level by 10% (per level) for 6 seconds.",
		effect = {
			{type = "storage", name = "HighVoltage", value = 10},
		},
	},
	["9:4"] = {
		name = "Stormpiercer",
		description = "Lightning Spear now grants you 3% attack speed for 8 seconds and deals 3% more damage per level",
		effect = {
			{type = "storage", name = "Stormpiercer", value = 3},
		},
	},
	["9:5"] = {
		name = "Tempest Coin",
		description = "Lern spell Tempest Coin\nToss a tempest coin in the air that will grant you Tempest Charges, Tempest charges will determine the times Charged Strike will be triggered on next cast based on token results (1-3).",
		effect = {
			{type = "spell", name = "Tempest Coin"},
		},
	},
	["9:6"] = {
		name = "Gambler's Luck",
		description = "Increase the max number result from tempest coin by 1 (per level)",
		effect = {
			{type = "storage", name = "GamblerLuck", value = 1},
		},
	},
	["9:7"] = {
		name = "Jackpot",
		description = "Increase the damage of your casted charged strike based on your Tempest Coin roll by 1 % (per level) per roll",
		effect = {
			{type = "storage", name = "Jackpot", value = 1},
		},
	},
	["9:8"] = {
		name = "Lightning Riposte",
		description = "You have a 2% (per level) chance to parry physical damage and send a small portion back to the attacker as energy damage.",
		effect = {
			{type = "storage", name = "LightningRiposte", value = 2},
		},
	},
	["9:9"] = {
		name = "Lightning Waltz",
		description = "Your Veil of Swords now heals you for 4% of your max health (per level) and grants you a dodge chance of 3% (per level) for 5 seconds.",
		effect = {
			{type = "storage", name = "LightningWaltzHeal", value = 4},
			{type = "storage", name = "LightningWaltzparry", value = 3},
		},
	},
	["9:10"] = {
		name = "Magnetic Shield",
		description = "Learn Magnetic Shield spell\nGain damage immunity for 5 seconds to all damage types but reduce your damage done by 80%",
		effect = {
			{type = "spell", name = "Magnetic Shield"},
		},
	},
	["9:11"] = {
		name = "Blade Mastery",
		description = "Increase your Melee skill by an aditional 3 points (per level).",
		effect = {
			{type = "condition", name = "Skill Sword", value = 3},
		},
	},
	["9:12"] = {
		name = "God of Spears",
		description = "Lightning Spear is no longer range but its damage is increased by 4% (per level) and grants you a Elusive Charge for 10 seconds. (this will refresh old charges of Elusive Charge)",
		effect = {
			{type = "storage", name = "GodOfSpears", value = 1},
		},
	},
	["9:13"] = {
		name = "Elusibe Blade",
		description = "Learn Elusive Blade spell",
		effect = {
			{type = "spell", name = "Elusive Blade"},
		},
	},
	["9:14"] = {
		name = "Dancing Edge",
		description = "Elusive Blade now has a 12% (per level) chance to trigger a second time at 50% effectiveness granting you a Elusive Charge for 10 seconds. (this will refresh old charges of Elusive Charge)",
		effect = {
			{type = "storage", name = "DancingEdge", value = 12},
		},
	},
	["9:15"] = {
		name = "Veil of Echos",
		description = "If you have 2 or more Elusive Charges, Veil of swords now turns into veil of Echos. Veil of Echos consume all Elusive Charges and  deals high amounts of physical damage.",
		effect = {
			{type = "storage", name = "VeilOfEchos", value = 1},
		},
	},
	["9:16"] = {
		name = "Reverberation",
		description = "Increase Veil of Echos and Veil of Swords damage by an aditional 4% (per level)",
		effect = {
			{type = "storage", name = "Reverberation", value = 4},
		},
	},
	["9:17"] = {
		name = "Light's ON",
		description = "Your short circuit procs now restore 0.5% of your total mana per hit. (per level)",
		effect = {
			{type = "storage", name = "LightsON", value = 0},
		},
	},
	["9:18"] = {
		name = "Critical Flow",
		description = "Increase your critical chance by an aditional 3% (per level)",
		effect = {
			{type = "condition", name = "Critical Strike", value = 3},
		},
	},
	["10:0"] = {
		name = "Core",
		description = "",
	},
	["10:1"] = {
		name = "Volatile Ammunition",
		description = "Increase your fire damage by an additional 3% (per level) and your physical damage done by an additional 2% (per level)",
		effect = {
			{type = "condition", name = "Fire Damage", value = 3},
			{type = "condition", name = "Physical Damage", value = 2},
		},
	},
	["10:2"] = {
		name = "Explosive Shot",
		description = "Learn Explosive Shot\nShoot a powerful shot that explodes on impact after a short delay applying a burn to all nearby enemies",
		effect = {
			{type = "spell", name = "Explosive Shot"},
		},
	},
	["10:3"] = {
		name = "Demolition",
		description = "Your fire damage have a 2% chance (per level) to trigger Demolition, Demolition deals aoe physical damage on impact.",
		effect = {
			{type = "storage", name = "Demolition", value = 2},
		},
	},
	["10:4"] = {
		name = "Volatile Impact",
		description = "Demolition Proc's now grant you 3% (per level) critical chance and attack speed for 5 seconds",
		effect = {
			{type = "storage", name = "VolatileImpact", value = 3},
		},
	},
	["10:5"] = {
		name = "Explosive Barrel",
		description = "Learn Explosive Barrel\nPlace a barrel at your target location exploding after a 4 seconds delay, igniting all enemies nearby. (if you dont have target it will be placed in front of you)",
		effect = {
			{type = "spell", name = "Explosive Barrel"},
		},
	},
	["10:6"] = {
		name = "Detonation Expert",
		description = "Your Explosive Shot now instantly detonates your existing explosive barrels, and increase their damage by an aditional 10% and applying a burn to all nearby enemies",
		effect = {
			{type = "storage", name = "DetonationExpert", value = 10},
		},
	},
	["10:7"] = {
		name = "Frostbite Weapon",
		description = "Learn Ice Arrow\nShoot a powerful ice arrow that slows the target for 5 seconds, if target is already slowed or frozen, it will deal double damage.",
		effect = {
			{type = "spell", name = "Ice Arrow"},
		},
	},
	["10:8"] = {
		name = "Winter Hunter",
		description = "Increase your ice damage by an aditional 2% (per level)",
		effect = {
			{type = "condition", name = "Ice Damage", value = 2},
		},
	},
	["10:9"] = {
		name = "Frost Barrel",
		description = "Learn Frost Barrel\nPlace a barrel at your location exploding after a short delay, freezing all enemies nearby.",
		effect = {
			{type = "spell", name = "Frost Barrel"},
		},
	},
	["10:10"] = {
		name = "Frost Barrage",
		description = "Arrow Barrage now deals ice damage and slows all enemies for 4 seconds\nIncrease the damage of Ice Arrow and Arrow Barrage by an aditional 2% (per level)",
		effect = {
			{type = "storage", name = "FrostBarrage", value = 2},
		},
	},
	["10:11"] = {
		name = "Momentum",
		description = "Your auto attacks now have a 20% + 1% (per level) chance to grant you Momentum, which increases your attack speed for 1% (per level)  to a maximum of 95% for 4 seconds every time your attacks hit an enemy, this effect last until duration is over. Attacks will refresh the duration of momentum.",
		effect = {
			{type = "storage", name = "Momentum", value = 1},
		},
	},
	["10:12"] = {
		name = "Frost Quiver",
		description = "Every fourth attack you have a 5% (per level) chance to trigger Frost Quiver, wich deals shoots a fronzen bolt to the target dealing ice damage.",
		effect = {
			{type = "storage", name = "FrostQuiver", value = 5},
		},
	},
	["10:13"] = {
		name = "Tenacious Spirit",
		description = "Increase your maximum health by 2% and 3 health points regeneration every 3 seconds (per level)",
		effect = {
			{type = "condition", name = "Health Regen", value = 3},
			{type = "condition", name = "MaxHealthPercent", value = 2},
		},
	},
	["10:14"] = {
		name = "Falcon Shot",
		description = "Learn Falcon Shot\nShoot a powerful shot that deals physical damage to the target and nearby enemies slowing them for 3 seconds\n\n\nThis node does not require a previous node to be unlocked",
		effect = {
			{type = "spell", name = "Falcon Shot"},
		},
	},
	["10:15"] = {
		name = "Phantom Shot",
		description = "Learn Phantom Shot\nShoot a powerful shot that deals physical damage to the target",
		effect = {
			{type = "spell", name = "Phantom Shot"},
		},
	},
	["10:16"] = {
		name = "Hunter's Mercy",
		description = "Your phantom shot now deals 4% (per level) additional damage if the target is below 50% health.",
		effect = {
			{type = "storage", name = "HunterMercy", value = 4},
		},
	},
	["10:17"] = {
		name = "Arrowstorm",
		description = "Increase the shots from rapid fire by 1 (per level) and reduces its cast time.",
		effect = {
			{type = "storage", name = "Arrowstorm", value = 1},
			{type = "storage", name = "Arrowstorm", value = 10},
		},
	},
	["10:18"] = {
		name = "Focused Fire",
		description = "Increase the damage done by your Phantom Shot, Falcon Shot and Rapid Fire by an additional 4% (per level)",
		effect = {
			{type = "storage", name = "FocusedFire", value = 4},
		},
	},
	["10:19"] = {
		name = "Dead from above",
		description = "Your physical damage has a 2% (per level) chance to trigger Dead from Above, Wich will trigger a bullet barrage from the sky that does fire damage to the target and nearby enemies.",
		effect = {
			{type = "storage", name = "DeadFromAbove", value = 2},
		},
	},
	["10:20"] = {
		name = "Scorched Mark",
		description = "Dead from above now increases your critical strike chance by 4% (per level) every time it triggers (this effect does not stack)",
		effect = {
			{type = "storage", name = "DeadFromAbove", value = 4},
		},
	},
}