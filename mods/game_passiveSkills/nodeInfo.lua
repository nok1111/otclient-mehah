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
		name = "Shadowborn Pact",
		description = "Bind your soul to the shadows. Increases dodge chance by 2% and attack speed by 2%.",
		effect = {
			{type = "condition", name = "Dodge", value = 2},
			{type = "condition", name = "Attack Speed", value = 2},
		},
	},
	["3:1"] = {
		name = "Veiled Might",
		description = "Increase physical damage done by 6% per level.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 6},
		},
	},
	["3:2"] = {
		name = "Assassin's Mastery",
		description = "Lethal Dagger deals 5% extra physical damage per level and has a 20% chance per level to apply bleed.",
		effect = {
			{type = "storage", name = "AssassinsMastery", value = 20},
		},
	},
	["3:3"] = {
		name = "Rupture Style",
		description = "Choose your rupture specialization.",
	},
	["3:4"] = {
		name = "Scent of Blood",
		description = "Deal 3% extra damage per level to bleeding targets.",
		effect = {
			{type = "storage", name = "ScentOfBlood", value = 3},
		},
	},
	["3:5"] = {
		name = "Virulent Rupture",
		description = "Dark Rupture has a 15% chance per level to spread corrupted blood to nearby targets at 35% effectiveness.",
		effect = {
			{type = "storage", name = "VirulentRupture", value = 15},
		},
	},
	["3:6"] = {
		name = "Blood Drinker",
		description = "Increases life leech by 1% per level.",
		effect = {
			{type = "condition", name = "Life Leech", value = 1},
		},
	},
	["3:7"] = {
		name = "Crimson Feast",
		description = "Killing a bleeding target restores 5% of your max health per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 2},
		},
	},
	["3:8"] = {
		name = "Assassination",
		description = "Learn the spell Assassination.",
		effect = {
			{type = "spell", name = "Assassination"},
		},
	},
	["3:11"] = {
		name = "Quickstep",
		description = "Increases dodge chance by 2% per level.",
		effect = {
			{type = "condition", name = "Dodge", value = 2},
		},
	},
	["3:12"] = {
		name = "Frenzied Blades",
		description = "Increases attack speed by 2% per level.",
		effect = {
			{type = "condition", name = "Attack Speed", value = 2},
		},
	},
	["3:13"] = {
		name = "Shadow Arts",
		description = "Choose your shadow technique.",
	},
	["3:14"] = {
		name = "Blackout",
		description = "Learn the spell Blackout. Your attacks have a chance to blind the target, reducing their hit chance.",
		effect = {
			{type = "spell", name = "Blackout"},
		},
	},
	["3:15"] = {
		name = "Death's Approach",
		description = "Lethal Dagger has a 12% chance per level to teleport you to your marked target and deal extra death damage.",
		effect = {
			{type = "storage", name = "DeathApproach", value = 12},
		},
	},
	["3:16"] = {
		name = "Killing Instinct",
		description = "Increases critical hit chance by 2% per level.",
		effect = {
			{type = "condition", name = "Critical Hit Chance", value = 2},
		},
	},
	["3:17"] = {
		name = "Blur",
		description = "Increases dodge chance by 3% per level.",
		effect = {
			{type = "condition", name = "Dodge", value = 3},
		},
	},
	["3:18"] = {
		name = "Bulwark of the Martyr",
		description = "Increases max health by 2% per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 2},
		},
	},
	["3:19"] = {
		name = "Stealth",
		description = "Learn the spell Stealth. Increases stealth duration by 1 second per level.",
		effect = {
			{type = "spell", name = "Stealth"},
			{type = "storage", name = "StealthDuration", value = 1},
		},
	},
	["3:21"] = {
		name = "Butcher's Art",
		description = "Increases Mutilate damage by 3% per level.",
		effect = {
			{type = "storage", name = "ButchersArt", value = 3},
		},
	},
	["3:22"] = {
		name = "Dark Transmutation",
		description = "Transforms Mutilate damage into Death Damage and increases Death Damage done by 8% per level.",
		effect = {
			{type = "storage", name = "DarkTransmutation", value = 1},
			{type = "condition", name = "Death Damage", value = 8},
		},
	},
	["3:23"] = {
		name = "Corruption",
		description = "Choose your path of corruption.",
	},
	["3:24"] = {
		name = "Shadow Reflection",
		description = "Lethal Dagger has a 12% chance per level to create a shadow version of yourself that deals death damage for 6 seconds.",
		effect = {
			{type = "storage", name = "ShadowReflection", value = 12},
		},
	},
	["3:25"] = {
		name = "Deathwind",
		description = "Transforms Fan of Knives damage into Death Damage and increases its over time effect by 4% per level.",
		effect = {
			{type = "storage", name = "Deathwind", value = 4},
		},
	},
	["3:26"] = {
		name = "Deathbringer",
		description = "Your melee attacks have a 3% chance per level to deal extra death damage on hit.",
		effect = {
			{type = "storage", name = "Deathbringer", value = 3},
		},
	},
	["3:27"] = {
		name = "Necrotic Edge",
		description = "Increases death damage by 3% per level.",
		effect = {
			{type = "condition", name = "Death Damage", value = 3},
		},
	},
	["3:28"] = {
		name = "Umbral Clone",
		description = "Your shadow reflection lasts 2 additional seconds per level and deals 5% more damage per level.",
		effect = {
			{type = "storage", name = "ShadowReflection", value = 5},
		},
	},
	["3:29"] = {
		name = "Void Execution",
		description = "Learn the spell Void Execution.",
		effect = {
			{type = "spell", name = "Void Execution"},
		},
	},
	["3:30"] = {
		name = "Bloodletter's Grasp",
		description = "Your cruelty and agility feed each other. Increases critical hit chance by 3% and dodge by 3% while you have unlocked Virulent Rupture and Death's Approach.",
		effect = {
			{type = "condition", name = "Critical Hit Chance", value = 3},
			{type = "condition", name = "Dodge", value = 3},
		},
	},
	["3:31"] = {
		name = "Void Dancer",
		description = "The shadows bend to your will. Increases attack speed by 3% and death damage by 3% while you have unlocked Blur and Necrotic Edge.",
		effect = {
			{type = "condition", name = "Attack Speed", value = 3},
			{type = "condition", name = "Death Damage", value = 3},
		},
	},
	["4:0"] = {
		name = "Draconic Heritage",
		description = "Dragon blood flows through your veins. Increases max health by 2% and physical damage by 2%.",
		effect = {
			{type = "condition", name = "Max Health", value = 2},
			{type = "condition", name = "Physical Damage", value = 2},
		},
	},
	["4:1"] = {
		name = "Scaled Rupture",
		description = "Increase Rend damage by 3% per level.",
		effect = {
			{type = "storage", name = "ScaledRupture", value = 3},
		},
	},
	["4:2"] = {
		name = "Colossal Blows",
		description = "Increase physical damage done by 2% per level.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 2},
		},
	},
	["4:3"] = {
		name = "Battle Focus",
		description = "Choose your combat specialization.",
	},
	["4:4"] = {
		name = "Heartseeker",
		description = "Increase critical strike chance by 2% per level.",
		effect = {
			{type = "condition", name = "Critical Hit Chance", value = 2},
		},
	},
	["4:5"] = {
		name = "Lifeblood Strike",
		description = "Increase the health gain from your Brutal Swing by 10% per level.",
		effect = {
			{type = "storage", name = "LifebloodStrike", value = 10},
		},
	},
	["4:6"] = {
		name = "Shockwave",
		description = "Learn the spell Shockwave.",
		effect = {
			{type = "spell", name = "Shockwave"},
		},
	},
	["4:7"] = {
		name = "Rebound Strike",
		description = "Brutal Swing has a 10% chance per level to heal you for 8% of your max health.",
		effect = {
			{type = "storage", name = "ReboundStrike", value = 10},
		},
	},
	["4:8"] = {
		name = "Bloodlust",
		description = "Learn the spell Bloodlust.",
		effect = {
			{type = "spell", name = "Bloodlust"},
		},
	},
	["4:11"] = {
		name = "Goliath",
		description = "Increase max health by 4% per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 4},
		},
	},
	["4:12"] = {
		name = "Bloodthirst",
		description = "Increases life leech by 2% per level.",
		effect = {
			{type = "condition", name = "Life Leech", value = 2},
		},
	},
	["4:13"] = {
		name = "Dragon's Path",
		description = "Choose your draconic path.",
	},
	["4:14"] = {
		name = "Dragon Heart",
		description = "Dragon Aura now heals the caster and increases its healing effectiveness by 5% per level.",
		effect = {
			{type = "storage", name = "DragonHeart", value = 5},
		},
	},
	["4:15"] = {
		name = "Survival Instincts",
		description = "Auto attacks heal you based on missing health, increased 1% per missing 1% health per level.",
		effect = {
			{type = "storage", name = "SurvivalInstincts", value = 1},
		},
	},
	["4:16"] = {
		name = "Fire Within",
		description = "Learn the spell Fire Within.",
		effect = {
			{type = "spell", name = "Fire Within"},
		},
	},
	["4:17"] = {
		name = "Emberhide",
		description = "Increase elemental resistance by 2% per level.",
		effect = {
			{type = "storage", name = "Emberhide", value = 2},
		},
	},
	["4:18"] = {
		name = "Draconic Chains",
		description = "Learn the spell Draconic Chains.",
		effect = {
			{type = "spell", name = "Draconic Chains"},
		},
	},
	["4:21"] = {
		name = "Ember Touch",
		description = "Auto attacks have a 2% chance per level to apply a burning effect for 2 seconds.",
		effect = {
			{type = "storage", name = "EmberTouch", value = 2},
		},
	},
	["4:22"] = {
		name = "Berserker's Tempo",
		description = "Increases attack speed by 5% per level.",
		effect = {
			{type = "condition", name = "Attack Speed", value = 5},
		},
	},
	["4:23"] = {
		name = "Flame Mastery",
		description = "Choose your flame specialization.",
	},
	["4:24"] = {
		name = "Flame Eater",
		description = "Increase damage done to burning targets by 2% per level.",
		effect = {
			{type = "storage", name = "FlameEater", value = 2},
		},
	},
	["4:25"] = {
		name = "Inner Flame",
		description = "Increase fire damage by 3% per level.",
		effect = {
			{type = "condition", name = "Fire Damage", value = 3},
		},
	},
	["4:26"] = {
		name = "Burning Soul",
		description = "Burning effects last 1 additional second per level and deal 5% more damage per level.",
		effect = {
			{type = "storage", name = "EmberTouch", value = 5},
		},
	},
	["4:27"] = {
		name = "Cinder Armor",
		description = "Increase max health by 2% per level while a burning enemy is nearby.",
		effect = {
			{type = "condition", name = "Max Health", value = 2},
		},
	},
	["4:28"] = {
		name = "Phoenix Wrath",
		description = "Learn the spell Phoenix Wrath.",
		effect = {
			{type = "spell", name = "Phoenix Wrath"},
		},
	},
	["4:29"] = {
		name = "Eternal Flame",
		description = "When you die, you are revived with 25% health and all nearby enemies are set on fire for 5 seconds. 10 minute cooldown.",
		effect = {
			{type = "storage", name = "EmberTouch", value = 25},
		},
	},
	["4:30"] = {
		name = "Draconic Fury",
		description = "Your fury and scales combine. Increases critical hit chance by 3% and max health by 3% while you have unlocked Lifeblood Strike and Dragon Heart.",
		effect = {
			{type = "condition", name = "Critical Hit Chance", value = 3},
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["4:31"] = {
		name = "Crimson Phoenix",
		description = "The phoenix and dragon unite. Increases life leech by 3% and fire damage by 3% while you have unlocked Emberhide and Flame Eater.",
		effect = {
			{type = "condition", name = "Life Leech", value = 3},
			{type = "condition", name = "Fire Damage", value = 3},
		},
	},
	["4:32"] = {
		name = "Dragon Soul",
		description = "Learn the spell Dragon Soul.",
		effect = {
			{type = "spell", name = "Dragon Soul"},
		},
	},
	["4:33"] = {
		name = "Bloodline",
		description = "Increases the healing of Dragon Soul by 5% per level.",
		effect = {
			{type = "storage", name = "Bloodline", value = 5},
		},
	},
	["5:0"] = {
		name = "Forbidden Pact",
		description = "Bind yourself to forbidden powers. Increases max health by 2% and death damage by 2%.",
		effect = {
			{type = "condition", name = "Max Health", value = 2},
			{type = "condition", name = "Death Damage", value = 2},
		},
	},
	["5:1"] = {
		name = "Malefic Persistence",
		description = "Increases the duration of Curse by 0.5 seconds per level and increases curse damage by 3% per level.",
		effect = {
			{type = "storage", name = "MaleficPersistencedamage", value = 3},
			{type = "storage", name = "MaleficPersistenceDuration", value = 5},
		},
	},
	["5:2"] = {
		name = "Malediction",
		description = "Learn the spell Malediction.",
		effect = {
			{type = "spell", name = "Malediction"},
		},
	},
	["5:3"] = {
		name = "Plague Spread",
		description = "Choose your plague specialization.",
	},
	["5:4"] = {
		name = "Plague Detonation",
		description = "When Malediction is applied to a target, it has a 20% chance per level to explode and send malefic pestilence to nearby enemies.",
		effect = {
			{type = "storage", name = "PlagueDetonation", value = 20},
		},
	},
	["5:5"] = {
		name = "Lasting Blight",
		description = "Increase Malediction, Curse and Dark Plague duration by 0.5 seconds per level.",
		effect = {
			{type = "storage", name = "LastingBlight", value = 5},
		},
	},
	["5:6"] = {
		name = "Dark Plague",
		description = "Learn the spell Dark Plague.",
		effect = {
			{type = "spell", name = "Dark Plague"},
		},
	},
	["5:7"] = {
		name = "Soulstorm",
		description = "Drain Soul now also affects additional nearby cursed enemies around your targets. +1 additional enemy per level.",
		effect = {
			{type = "storage", name = "Soulstorm", value = 1},
		},
	},
	["5:8"] = {
		name = "Soulstorm Echoes",
		description = "Increases the number of times Drain Soul damages its targets by 1 per level.",
		effect = {
			{type = "storage", name = "SoulstormTicks", value = 1},
		},
	},
	["5:11"] = {
		name = "Demonic Bulwark",
		description = "Increase the max health of your summons by an additional 18% per level.",
		effect = {
			{type = "storage", name = "DemonicBulwark", value = 18},
		},
	},
	["5:12"] = {
		name = "Legion Mastery",
		description = "Increase the maximum number of Servants you can control by 1 per level and increase your chance to successfully summon by 100% per level.",
		effect = {
			{type = "storage", name = "LegionMasteryNumber", value = 1},
			{type = "storage", name = "LegionMasteryChance", value = 1},
		},
	},
	["5:13"] = {
		name = "Command Style",
		description = "Choose your command specialization.",
	},
	["5:14"] = {
		name = "Infernal Command",
		description = "Increases the damage of your summons by 4% per level.",
		effect = {
			{type = "storage", name = "InfernalCommand", value = 4},
		},
	},
	["5:15"] = {
		name = "Abyssal Refund",
		description = "Your Void Mender restores part of your mana every time it heals a target. Increase healing efficiency by 7% per level.",
		effect = {
			{type = "storage", name = "AbyssalRefund", value = 7},
		},
	},
	["5:16"] = {
		name = "Void Mender",
		description = "Learn the spell Summon Void Mender.",
		effect = {
			{type = "spell", name = "Summon Void Mender"},
		},
	},
	["5:17"] = {
		name = "Soul Link",
		description = "Your summons share 3% of their max health with you per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["5:18"] = {
		name = "Void Guard",
		description = "Learn the spell Summon Void Guard.",
		effect = {
			{type = "spell", name = "Summon Void Guard"},
		},
	},
	["5:21"] = {
		name = "Immortal Flesh",
		description = "Increase your max health by 3% per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["5:22"] = {
		name = "Dark Aura",
		description = "Learn the spell Dark Aura.",
		effect = {
			{type = "spell", name = "Dark Aura"},
		},
	},
	["5:23"] = {
		name = "Pact Style",
		description = "Choose your pact specialization.",
	},
	["5:24"] = {
		name = "Lingering Darkness",
		description = "Increase the duration of Dark Aura by 0.5 seconds per level.",
		effect = {
			{type = "storage", name = "LingeringDarkness", value = 5},
		},
	},
	["5:25"] = {
		name = "Pactmaster's Gift",
		description = "Increase the mana transfer from Blood Pact by 12% per level.",
		effect = {
			{type = "storage", name = "PactmasterGift", value = 12},
		},
	},
	["5:26"] = {
		name = "Sanguine Shield",
		description = "Increases the effectiveness of Blood Wall by 12% per level.",
		effect = {
			{type = "storage", name = "BloodWall", value = 12},
		},
	},
	["5:27"] = {
		name = "Demonic Vigor",
		description = "Increases life leech by 2% per level.",
		effect = {
			{type = "condition", name = "Life Leech", value = 2},
		},
	},
	["5:28"] = {
		name = "Zombie Wall",
		description = "Learn the spell Zombie Wall.",
		effect = {
			{type = "spell", name = "Zombie Wall"},
		},
	},
	["5:30"] = {
		name = "Plaguebringer",
		description = "Your blight and vitality combine. Increases death damage by 3% and max health by 3% while you have unlocked Lasting Blight and Lingering Darkness.",
		effect = {
			{type = "condition", name = "Death Damage", value = 3},
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["5:31"] = {
		name = "Soul Harvester",
		description = "Your curses and legion combine. Increases curse damage by 3% and summon damage by 3% while you have unlocked Soulstorm and Infernal Command.",
		effect = {
			{type = "condition", name = "Death Damage", value = 3},
			{type = "storage", name = "InfernalCommand", value = 3},
		},
	},
	["6:0"] = {
		name = "Astral Communion",
		description = "Commune with the cosmos. Increases energy damage by 2% and max mana by 2%.",
		effect = {
			{type = "condition", name = "Energy Damage", value = 2},
			{type = "condition", name = "Max Mana", value = 2},
		},
	},
	["6:1"] = {
		name = "Cosmic Focus",
		description = "Increase the energy damage done by 2% per level.",
		effect = {
			{type = "condition", name = "Energy Damage", value = 2},
		},
	},
	["6:2"] = {
		name = "Astral Burn",
		description = "Starfall now applies a damaging condition to the target which deals energy damage for 1 second per level.",
		effect = {
			{type = "storage", name = "AstralBurn", value = 1},
		},
	},
	["6:3"] = {
		name = "Star Style",
		description = "Choose your star specialization.",
	},
	["6:4"] = {
		name = "Falling Stars",
		description = "Dealing energy damage has a 2% chance per level to trigger a Starfall on the target.",
		effect = {
			{type = "storage", name = "FallingStars", value = 2},
		},
	},
	["6:5"] = {
		name = "Aery's Rapidfire",
		description = "Increase Aery's Strikes shots by 1 per level.",
		effect = {
			{type = "storage", name = "AeryRapidfire", value = 1},
		},
	},
	["6:6"] = {
		name = "Holy Flare",
		description = "Learn the spell Holy Flare.",
		effect = {
			{type = "spell", name = "Holy Flare"},
		},
	},
	["6:7"] = {
		name = "Celestial Insight",
		description = "Increases your Magic Level by 2 points per level.",
		effect = {
			{type = "condition", name = "Magic Level", value = 2},
		},
	},
	["6:8"] = {
		name = "Full Moon",
		description = "Learn the spell Full Moon.",
		effect = {
			{type = "spell", name = "Full Moon"},
		},
	},
	["6:11"] = {
		name = "Starwell",
		description = "Increases max mana by 4% per level.",
		effect = {
			{type = "condition", name = "Max Mana", value = 4},
		},
	},
	["6:12"] = {
		name = "Divine Restoration",
		description = "Increases healing effectiveness by 6% per level and reduces the mana cost of Moon Light by 3% per level.",
		effect = {
			{type = "condition", name = "Healing Effectiveness", value = 6},
			{type = "storage", name = "MoonLightManaCost", value = 3},
		},
	},
	["6:13"] = {
		name = "Lunar Path",
		description = "Choose your lunar path.",
	},
	["6:14"] = {
		name = "Moonshower",
		description = "Increase the healing of Rain Fall by 6% per level and increase its duration by 1 second per level.",
		effect = {
			{type = "storage", name = "RainFallHealing", value = 6},
			{type = "storage", name = "RainFallDuration", value = 1},
		},
	},
	["6:15"] = {
		name = "Luminous Bond",
		description = "Increase the passive healing of Aery by 6% per level.",
		effect = {
			{type = "storage", name = "LuminousBond", value = 6},
		},
	},
	["6:16"] = {
		name = "Guiding Constellation",
		description = "Cosmic Force now restores 3% of your max mana per level.",
		effect = {
			{type = "storage", name = "CosmicForceManaRestore", value = 3},
		},
	},
	["6:17"] = {
		name = "Mana Feather",
		description = "Aery now restores 0.2% of your max mana per basic attack per level.",
		effect = {
			{type = "storage", name = "AeryManaRestore", value = 2},
		},
	},
	["6:18"] = {
		name = "Solar Blessing",
		description = "Learn the spell Solar Blessing. Increases the target's max health by 65% for 8 seconds and heals them instantly for 50% of your max mana at the start and ending of the spell.",
		effect = {
			{type = "spell", name = "Solar Blessing"},
		},
	},
	["6:21"] = {
		name = "Back to Basics",
		description = "Increase wand damage by 4% per level.",
		effect = {
			{type = "storage", name = "WandDamage", value = 4},
		},
	},
	["6:22"] = {
		name = "Sacred Constitution",
		description = "Increases max health by 4% per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 4},
		},
	},
	["6:23"] = {
		name = "Cosmic Bond",
		description = "Choose your cosmic bond.",
	},
	["6:24"] = {
		name = "Arcane Resonance",
		description = "Increases max mana by 3% per level and reduces spell mana costs by 2% per level.",
		effect = {
			{type = "condition", name = "Max Mana", value = 3},
		},
	},
	["6:25"] = {
		name = "Vital Resonance",
		description = "Increases max health by 3% per level and life leech by 1% per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
			{type = "condition", name = "Life Leech", value = 1},
		},
	},
	["6:26"] = {
		name = "Stellar Alignment",
		description = "When you cast a spell, you have a 4% chance per level to restore 5% of your max mana.",
		effect = {
			{type = "storage", name = "CosmicForceManaRestore", value = 4},
		},
	},
	["6:27"] = {
		name = "Astral Vigor",
		description = "Increases healing effectiveness by 3% per level.",
		effect = {
			{type = "condition", name = "Healing Effectiveness", value = 3},
		},
	},
	["6:28"] = {
		name = "Cosmic Convergence",
		description = "When your mana drops below 20%, you enter Cosmic Convergence for 6 seconds: +10% magic level and all spells cost 50% less mana. 30 second cooldown.",
		effect = {
			{type = "condition", name = "Magic Level", value = 10},
		},
	},
	["6:30"] = {
		name = "Starweaver",
		description = "Your radiance and lunarity combine. Increases energy damage by 3% and max mana by 3% while you have unlocked Falling Stars and Moonshower.",
		effect = {
			{type = "condition", name = "Energy Damage", value = 3},
			{type = "condition", name = "Max Mana", value = 3},
		},
	},
	["6:31"] = {
		name = "Astral Harmony",
		description = "Your lunarity and astral bond combine. Increases healing effectiveness by 3% and max health by 3% while you have unlocked Luminous Bond and Vital Resonance.",
		effect = {
			{type = "condition", name = "Healing Effectiveness", value = 3},
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["7:0"] = {
		name = "Inner Peace",
		description = "Balance your body and spirit. Increases max health by 2% and healing effectiveness by 2%.",
		effect = {
			{type = "condition", name = "Max Health", value = 2},
			{type = "condition", name = "Healing Effectiveness", value = 2},
		},
	},
	["7:1"] = {
		name = "Elemental Harmony",
		description = "Increases the damage of your elemental fists (Fire, Ice, Life) by 2% per level when used in combination.",
		effect = {
			{type = "storage", name = "ElementalHarmony", value = 2},
		},
	},
	["7:2"] = {
		name = "Vital Points",
		description = "Increase critical strike chance by 2% per level.",
		effect = {
			{type = "condition", name = "Critical Hit Chance", value = 2},
		},
	},
	["7:3"] = {
		name = "Combat Style",
		description = "Choose your combat specialization.",
	},
	["7:4"] = {
		name = "Mystic Punch",
		description = "You have a 3% chance per level to land a Mystic Punch every time you deal physical damage.",
		effect = {
			{type = "storage", name = "MysticPunch", value = 3},
		},
	},
	["7:5"] = {
		name = "Inner Tempo",
		description = "Landing a Mystic Punch increases your attack speed by 8% per level for 5 seconds.",
		effect = {
			{type = "storage", name = "InnerTempo", value = 8},
		},
	},
	["7:6"] = {
		name = "Stormfist",
		description = "Learn the spell Stormfist. For the next 3 seconds your physical damage sends a lightning shock to nearby targets.",
		effect = {
			{type = "spell", name = "Stormfist"},
		},
	},
	["7:7"] = {
		name = "Fist Mastery",
		description = "Increases physical damage by 3% per level.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 3},
		},
	},
	["7:8"] = {
		name = "Tempest God",
		description = "Empowers Stormfist, extending its duration by 1 second and amplifying its damage by 10% per level.",
		effect = {
			{type = "storage", name = "StormfistDuration", value = 1},
			{type = "storage", name = "StormfistDamage", value = 10},
		},
	},
	["7:11"] = {
		name = "Rock Mentality",
		description = "Increases max health by 3% per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["7:12"] = {
		name = "Meditative Recovery",
		description = "Every time you use a monk healing spell, restore 1.2% of your maximum health and 2% of your maximum mana.",
		effect = {
			{type = "storage", name = "MeditativeRecovery", value = 2},
		},
	},
	["7:13"] = {
		name = "Mountain Style",
		description = "Choose your mountain specialization.",
	},
	["7:14"] = {
		name = "Mountain Stance",
		description = "Learn the spell Mountain Stance. Reduces damage taken by 30% and increases your max health by 25% for 10 seconds.",
		effect = {
			{type = "spell", name = "Mountain Stance"},
		},
	},
	["7:15"] = {
		name = "Glacial Palm",
		description = "Your adaptive punch (Ice + Ice) now has a 5% chance per level to trigger Glacial Palm which deals damage to the target and all nearby enemies.",
		effect = {
			{type = "storage", name = "GlacialPalm", value = 5},
		},
	},
	["7:16"] = {
		name = "Frozen Lotus",
		description = "Triggering Glacial Palm will now heal you by 15% per level of the damage done.",
		effect = {
			{type = "storage", name = "FrozenLotus", value = 15},
		},
	},
	["7:17"] = {
		name = "Frost Blossom",
		description = "Increase the damage of Glacial Palm and Frozen Lotus healing by 6% per level.",
		effect = {
			{type = "storage", name = "FrostBlossom", value = 6},
		},
	},
	["7:18"] = {
		name = "Eternal Mountain",
		description = "While Mountain Stance is active, you also reflect 15% of incoming damage back to attackers as ice damage.",
		effect = {
			{type = "storage", name = "FrostBlossom", value = 15},
		},
	},
	["7:21"] = {
		name = "Vital Palm",
		description = "Increase the healing effectiveness of your adaptive punch (Life + Life) by 10% per level.",
		effect = {
			{type = "storage", name = "VitalPalm", value = 10},
		},
	},
	["7:22"] = {
		name = "Chi Transfer",
		description = "Dealing physical melee damage has a 3% chance per level to send a chi healing wave to a nearby ally.",
		effect = {
			{type = "storage", name = "ChiTransfer", value = 3},
		},
	},
	["7:23"] = {
		name = "Chi Style",
		description = "Choose your chi specialization.",
	},
	["7:24"] = {
		name = "Mystic Reserves",
		description = "Increase your maximum mana by 5% per level.",
		effect = {
			{type = "condition", name = "Max Mana", value = 5},
		},
	},
	["7:25"] = {
		name = "Life Pulse",
		description = "Every third consecutive Life punch has a 20% chance per level to trigger a healing chi wave which heals a random nearby ally.",
		effect = {
			{type = "storage", name = "LifePulse", value = 20},
		},
	},
	["7:26"] = {
		name = "Zen Barrier",
		description = "Learn the spell Zen Barrier. Place a serenity sphere on a chosen player for 8 seconds. Each time they take damage, the sphere absorbs the damage and instantly heals them for the same amount.",
		effect = {
			{type = "spell", name = "Zen Barrier"},
		},
	},
	["7:27"] = {
		name = "Serene Amplification",
		description = "Increase the healing effectiveness of Zen Barrier when cast on yourself and the healing effectiveness of Fist of Life by 10% per level.",
		effect = {
			{type = "storage", name = "SereneAmplification", value = 10},
		},
	},
	["7:28"] = {
		name = "Enlightened State",
		description = "When you heal an ally below 30% health, you enter Enlightened State for 5 seconds: +10% healing effectiveness and your next punch costs no mana. 20 second cooldown.",
		effect = {
			{type = "condition", name = "Healing Effectiveness", value = 10},
		},
	},
	["7:30"] = {
		name = "Tempest Mountain",
		description = "Your fury and stone combine. Increases critical hit chance by 3% and max health by 3% while you have unlocked Inner Tempo and Mountain Stance.",
		effect = {
			{type = "condition", name = "Critical Hit Chance", value = 3},
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["7:31"] = {
		name = "Serene Storm",
		description = "Your stone and chi combine. Increases max health by 3% and healing effectiveness by 3% while you have unlocked Glacial Palm and Life Pulse.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
			{type = "condition", name = "Healing Effectiveness", value = 3},
		},
	},
	["8:0"] = {
		name = "Nature's Embrace",
		description = "Embrace the wild. Increases earth damage by 2% and max mana by 2%.",
		effect = {
			{type = "condition", name = "Earth Damage", value = 2},
			{type = "condition", name = "Max Mana", value = 2},
		},
	},
	["8:1"] = {
		name = "Savage Bloom",
		description = "Increase Terra Strike and Carnivorous Vile damage by 3% per level.",
		effect = {
			{type = "storage", name = "SavageBloom", value = 3},
		},
	},
	["8:2"] = {
		name = "Primal Infestation",
		description = "Your nature or earth damage has a 2% chance per level to trigger a Carnivorous Vile with 45% effectiveness.",
		effect = {
			{type = "storage", name = "PrimalInfestation", value = 2},
		},
	},
	["8:3"] = {
		name = "Swarm Style",
		description = "Choose your swarm specialization.",
	},
	["8:4"] = {
		name = "Swarm of Insects",
		description = "Learn the spell Insect Swarm. Place a swarm of insects on a target, increasing its damage received by 10% per level from all sources.",
		effect = {
			{type = "spell", name = "Insect Swarm"},
		},
	},
	["8:5"] = {
		name = "Thorned Rose",
		description = "Piercing Wave now bleeds enemies dealing physical damage and increases its damage by 2% per level.",
		effect = {
			{type = "storage", name = "EntanglingRoots", value = 2},
		},
	},
	["8:6"] = {
		name = "Hive Queen",
		description = "Increase your critical damage chance by 2% per level for each enemy reached by Swarm of Insects.",
		effect = {
			{type = "storage", name = "HiveQueen", value = 2},
		},
	},
	["8:7"] = {
		name = "Nature's Wrath",
		description = "Increases earth damage by 3% per level.",
		effect = {
			{type = "condition", name = "Earth Damage", value = 3},
		},
	},
	["8:8"] = {
		name = "Force of Nature",
		description = "Increase the damage done by Wrath of Nature by 4% per level.",
		effect = {
			{type = "storage", name = "ForceOfNature", value = 4},
		},
	},
	["8:11"] = {
		name = "Spirit Pool",
		description = "Increases maximum mana by 5% per level.",
		effect = {
			{type = "condition", name = "Max Mana", value = 5},
		},
	},
	["8:12"] = {
		name = "Life Bloom",
		description = "Learn the spell Life Bloom.",
		effect = {
			{type = "spell", name = "Life Bloom"},
		},
	},
	["8:13"] = {
		name = "Bloom Style",
		description = "Choose your bloom specialization.",
	},
	["8:14"] = {
		name = "Blooming Wisdom",
		description = "Decrease the mana cost required to cast Life Bloom by 2% per level.",
		effect = {
			{type = "storage", name = "BloomingWisdom", value = 2},
		},
	},
	["8:15"] = {
		name = "Healing Concentration",
		description = "Increase the effectiveness of Focus Healing by 6% per level.",
		effect = {
			{type = "storage", name = "FocusHealing", value = 6},
		},
	},
	["8:16"] = {
		name = "Living Ground",
		description = "Learn the spell Living Ground. Place a nature ground on your current position which heals all nearby allies while standing on it.",
		effect = {
			{type = "spell", name = "Living Ground"},
		},
	},
	["8:17"] = {
		name = "Nature's Endurance",
		description = "Increases max health by 5% per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 5},
		},
	},
	["8:18"] = {
		name = "Thorned Sanctuary",
		description = "Living Ground now deals damage to nearby enemies every 1.0 seconds, dealing 2% of your max health per level as nature damage.",
		effect = {
			{type = "storage", name = "ThornedSanctuary", value = 2},
		},
	},
	["8:21"] = {
		name = "Winter's Grasp",
		description = "Increase your ice damage by 4% per level.",
		effect = {
			{type = "condition", name = "Ice Damage", value = 4},
		},
	},
	["8:22"] = {
		name = "Ice Shatter",
		description = "Learn the spell Ice Shatter. Turn the target into a solid ice block dealing ice damage and a second AOE damage when it ends.",
		effect = {
			{type = "spell", name = "Ice Shatter"},
		},
	},
	["8:23"] = {
		name = "Frost Style",
		description = "Choose your frost specialization.",
	},
	["8:24"] = {
		name = "Permafrost Trap",
		description = "Dealing ice damage has a 4% chance per level to trigger Frost Cage, which deals ice damage to the target and nearby enemies.",
		effect = {
			{type = "storage", name = "PermafrostTrap", value = 4},
		},
	},
	["8:25"] = {
		name = "Bear Form",
		description = "Learn the spell Bear Form.",
		effect = {
			{type = "spell", name = "Bear Form"},
		},
	},
	["8:26"] = {
		name = "Frost Armor",
		description = "Learn the spell Frost Armor. Gain a frost armor which reduces your damage taken by 20% and deals ice damage back to the attacker.",
		effect = {
			{type = "spell", name = "Frost Armor"},
		},
	},
	["8:27"] = {
		name = "Wildhide Endurance",
		description = "Increase Bear Form maximum health and health regeneration by 5% per level.",
		effect = {
			{type = "storage", name = "WildhideEndurance", value = 5},
		},
	},
	["8:28"] = {
		name = "Frost Aura",
		description = "Frost Armor now deals damage to nearby enemies every 1.0 seconds, dealing 1% of your max mana per level as ice damage.",
		effect = {
			{type = "storage", name = "FrostAura", value = 1},
		},
	},
	["8:30"] = {
		name = "Wild Bloom",
		description = "Your wildgrowth and verdancy combine. Increases earth damage by 3% and max mana by 3% while you have unlocked Swarm of Insects and Blooming Wisdom.",
		effect = {
			{type = "condition", name = "Earth Damage", value = 3},
			{type = "condition", name = "Max Mana", value = 3},
		},
	},
	["8:31"] = {
		name = "Frozen Sanctuary",
		description = "Your verdancy and frost combine. Increases max health by 3% and ice damage by 3% while you have unlocked Nature's Endurance and Permafrost Trap.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
			{type = "condition", name = "Ice Damage", value = 3},
		},
	},
	["9:0"] = {
		name = "Static Flow",
		description = "Channel the storm through your blades. Increases energy damage by 2% and physical damage by 2%.",
		effect = {
			{type = "condition", name = "Energy Damage", value = 2},
			{type = "condition", name = "Physical Damage", value = 2},
		},
	},
	["9:1"] = {
		name = "Short Circuit",
		description = "During Static Shock, your attacks have a 10% chance per level to deal extra damage to enemies affected by Static Shock. This effect is increased by magic level and base weapon damage.",
		effect = {
			{type = "storage", name = "ShortCircuit", value = 10},
		},
	},
	["9:2"] = {
		name = "Kinetic Dancer",
		description = "Increase physical damage done by 2% and your energy damage by 2% per level.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 2},
			{type = "condition", name = "Energy Damage", value = 2},
		},
	},
	["9:3"] = {
		name = "Storm Style",
		description = "Choose your storm specialization.",
	},
	["9:4"] = {
		name = "High Voltage",
		description = "Your Short Circuit now has a 25% chance to grant you High Voltage, which increases your magic level by 10% per level for 6 seconds.",
		effect = {
			{type = "storage", name = "HighVoltage", value = 10},
		},
	},
	["9:5"] = {
		name = "Stormpiercer",
		description = "Lightning Spear now grants you 3% attack speed for 8 seconds and deals 3% more damage per level.",
		effect = {
			{type = "storage", name = "Stormpiercer", value = 3},
		},
	},
	["9:6"] = {
		name = "Tempest Coin",
		description = "Learn the spell Tempest Coin. Toss a tempest coin in the air that will grant you Tempest Charges. Tempest Charges will determine the times Charged Strike will be triggered on next cast based on token results (1-3).",
		effect = {
			{type = "spell", name = "Tempest Coin"},
		},
	},
	["9:7"] = {
		name = "Gambler's Luck",
		description = "Increase the max number result from Tempest Coin by 1 per level.",
		effect = {
			{type = "storage", name = "GamblerLuck", value = 1},
		},
	},
	["9:8"] = {
		name = "Jackpot",
		description = "Increase the damage of your casted Charged Strike based on your Tempest Coin roll by 1% per level per roll.",
		effect = {
			{type = "storage", name = "Jackpot", value = 1},
		},
	},
	["9:11"] = {
		name = "Lightning Riposte",
		description = "You have a 2% chance per level to parry physical damage and send a small portion back to the attacker as energy damage.",
		effect = {
			{type = "storage", name = "LightningRiposte", value = 2},
		},
	},
	["9:12"] = {
		name = "Lightning Waltz",
		description = "Your Veil of Swords now heals you for 4% of your max health per level and grants you a dodge chance of 3% per level for 5 seconds.",
		effect = {
			{type = "storage", name = "LightningWaltzHeal", value = 4},
			{type = "storage", name = "LightningWaltzparry", value = 3},
		},
	},
	["9:13"] = {
		name = "Guard Style",
		description = "Choose your guard specialization.",
	},
	["9:14"] = {
		name = "Magnetic Shield",
		description = "Learn the spell Magnetic Shield. Gain damage immunity for 5 seconds to all damage types but reduce your damage done by 80%.",
		effect = {
			{type = "spell", name = "Magnetic Shield"},
		},
	},
	["9:15"] = {
		name = "Light's On",
		description = "Your Short Circuit procs now restore 0.5% of your total mana per hit per level.",
		effect = {
			{type = "storage", name = "LightsON", value = 0.5},
		},
	},
	["9:16"] = {
		name = "Critical Flow",
		description = "Increase your critical chance by an additional 3% per level.",
		effect = {
			{type = "condition", name = "Critical Hit Chance", value = 3},
		},
	},
	["9:17"] = {
		name = "Energy Reserve",
		description = "Increases max mana by 4% per level.",
		effect = {
			{type = "condition", name = "Max Mana", value = 4},
		},
	},
	["9:18"] = {
		name = "Magnetic Mastery",
		description = "While Magnetic Shield is active, you also reflect 25% of incoming damage back as energy damage to attackers.",
		effect = {
			{type = "storage", name = "LightningRiposte", value = 25},
		},
	},
	["9:21"] = {
		name = "Blade Mastery",
		description = "Increase your Melee skill by an additional 3 points per level.",
		effect = {
			{type = "condition", name = "Sword Skill", value = 3},
		},
	},
	["9:22"] = {
		name = "God of Spears",
		description = "Lightning Spear is no longer ranged but its damage is increased by 4% per level and grants you an Elusive Charge for 10 seconds. This will refresh old charges of Elusive Charge.",
		effect = {
			{type = "storage", name = "GodOfSpears", value = 1},
		},
	},
	["9:23"] = {
		name = "Blade Style",
		description = "Choose your blade specialization.",
	},
	["9:24"] = {
		name = "Elusive Blade",
		description = "Learn the spell Elusive Blade.",
		effect = {
			{type = "spell", name = "Elusive Blade"},
		},
	},
	["9:25"] = {
		name = "Dancing Edge",
		description = "Elusive Blade now has a 12% chance per level to trigger a second time at 50% effectiveness, granting you an Elusive Charge for 10 seconds. This will refresh old charges of Elusive Charge.",
		effect = {
			{type = "storage", name = "DancingEdge", value = 12},
		},
	},
	["9:26"] = {
		name = "Veil of Echos",
		description = "If you have 2 or more Elusive Charges, Veil of Swords now turns into Veil of Echos. Veil of Echos consumes all Elusive Charges and deals high amounts of physical damage.",
		effect = {
			{type = "storage", name = "VeilOfEchos", value = 1},
		},
	},
	["9:27"] = {
		name = "Reverberation",
		description = "Increase Veil of Echos and Veil of Swords damage by an additional 4% per level.",
		effect = {
			{type = "storage", name = "Reverberation", value = 4},
		},
	},
	["9:28"] = {
		name = "Echo Storm",
		description = "When you consume Elusive Charges for Veil of Echos, each charge consumed has a 20% chance to trigger an additional Echo at 75% effectiveness.",
		effect = {
			{type = "storage", name = "VeilOfEchos", value = 20},
		},
	},
	["9:30"] = {
		name = "Storm Blade",
		description = "Your storm and blade combine. Increases energy damage by 3% and sword skill by 3 while you have unlocked High Voltage and Elusive Blade.",
		effect = {
			{type = "condition", name = "Energy Damage", value = 3},
			{type = "condition", name = "Sword Skill", value = 3},
		},
	},
	["9:31"] = {
		name = "Charged Ward",
		description = "Your ward and blade combine. Increases dodge by 3% and critical hit chance by 3% while you have unlocked Critical Flow and Dancing Edge.",
		effect = {
			{type = "condition", name = "Dodge", value = 3},
			{type = "condition", name = "Critical Hit Chance", value = 3},
		},
	},
	["10:0"] = {
		name = "Eagle Eye",
		description = "Sharpen your aim. Increases physical damage by 2% and fire damage by 2%.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 2},
			{type = "condition", name = "Fire Damage", value = 2},
		},
	},
	["10:1"] = {
		name = "Volatile Ammunition",
		description = "Increase your fire damage by an additional 3% per level and your physical damage done by an additional 2% per level.",
		effect = {
			{type = "condition", name = "Fire Damage", value = 3},
			{type = "condition", name = "Physical Damage", value = 2},
		},
	},
	["10:2"] = {
		name = "Explosive Shot",
		description = "Learn the spell Explosive Shot. Shoot a powerful shot that explodes on impact after a short delay, applying a burn to all nearby enemies.",
		effect = {
			{type = "spell", name = "Explosive Shot"},
		},
	},
	["10:3"] = {
		name = "Blast Style",
		description = "Choose your blast specialization.",
	},
	["10:4"] = {
		name = "Demolition",
		description = "Your fire damage has a 2% chance per level to trigger Demolition, which deals AOE physical damage on impact.",
		effect = {
			{type = "storage", name = "Demolition", value = 2},
		},
	},
	["10:5"] = {
		name = "Explosive Barrel",
		description = "Learn the spell Explosive Barrel. Place a barrel at your target location exploding after a 4 second delay, igniting all nearby enemies. If you don't have a target it will be placed in front of you.",
		effect = {
			{type = "spell", name = "Explosive Barrel"},
		},
	},
	["10:6"] = {
		name = "Volatile Impact",
		description = "Demolition procs now grant you 3% per level critical chance and attack speed for 5 seconds.",
		effect = {
			{type = "storage", name = "VolatileImpact", value = 3},
		},
	},
	["10:7"] = {
		name = "Dead from Above",
		description = "Your physical damage has a 2% chance per level to trigger Dead from Above, which triggers a bullet barrage from the sky that deals fire damage to the target and nearby enemies.",
		effect = {
			{type = "storage", name = "DeadFromAbove", value = 2},
		},
	},
	["10:8"] = {
		name = "Detonation Expert",
		description = "Your Explosive Shot now instantly detonates your existing Explosive Barrels, increasing their damage by an additional 10% per level and applying a burn to all nearby enemies.",
		effect = {
			{type = "storage", name = "DetonationExpert", value = 10},
		},
	},
	["10:11"] = {
		name = "Frostbite Weapon",
		description = "Learn the spell Ice Arrow. Shoot a powerful ice arrow that slows the target for 5 seconds. If the target is already slowed or frozen, it will deal double damage.",
		effect = {
			{type = "spell", name = "Ice Arrow"},
		},
	},
	["10:12"] = {
		name = "Winter Hunter",
		description = "Increase your ice damage by an additional 2% per level.",
		effect = {
			{type = "condition", name = "Ice Damage", value = 2},
		},
	},
	["10:13"] = {
		name = "Frost Style",
		description = "Choose your frost specialization.",
	},
	["10:14"] = {
		name = "Frost Barrel",
		description = "Learn the spell Frost Barrel. Place a barrel at your location exploding after a short delay, freezing all nearby enemies.",
		effect = {
			{type = "spell", name = "Frost Barrel"},
		},
	},
	["10:15"] = {
		name = "Frost Barrage",
		description = "Arrow Barrage now deals ice damage and slows all enemies for 4 seconds. Increase the damage of Ice Arrow and Arrow Barrage by an additional 2% per level.",
		effect = {
			{type = "storage", name = "FrostBarrage", value = 2},
		},
	},
	["10:16"] = {
		name = "Momentum",
		description = "Your auto attacks now have a 20% + 1% per level chance to grant you Momentum, which increases your attack speed by 1% per level to a maximum of 95% for 4 seconds. Attacks will refresh the duration of Momentum.",
		effect = {
			{type = "storage", name = "Momentum", value = 1},
		},
	},
	["10:17"] = {
		name = "Tenacious Spirit",
		description = "Increase your maximum health by 2% per level and gain 3 health points regeneration every 3 seconds per level.",
		effect = {
			{type = "condition", name = "Health Regen", value = 3},
			{type = "condition", name = "Max Health", value = 2},
		},
	},
	["10:18"] = {
		name = "Frost Quiver",
		description = "Every fourth attack you have a 5% chance per level to trigger Frost Quiver, which shoots a frozen bolt to the target dealing ice damage.",
		effect = {
			{type = "storage", name = "FrostQuiver", value = 5},
		},
	},
	["10:21"] = {
		name = "Phantom Shot",
		description = "Learn the spell Phantom Shot. Shoot a powerful shot that deals physical damage to the target.",
		effect = {
			{type = "spell", name = "Phantom Shot"},
		},
	},
	["10:22"] = {
		name = "Hunter's Mercy",
		description = "Your Phantom Shot now deals 4% per level additional damage if the target is below 50% health.",
		effect = {
			{type = "storage", name = "HunterMercy", value = 4},
		},
	},
	["10:23"] = {
		name = "Marksman Style",
		description = "Choose your marksman specialization.",
	},
	["10:24"] = {
		name = "Arrowstorm",
		description = "Increase the shots from Rapid Fire by 1 per level and reduce its cast time.",
		effect = {
			{type = "storage", name = "Arrowstorm", value = 1},
			{type = "storage", name = "Arrowstorm", value = 10},
		},
	},
	["10:25"] = {
		name = "Falcon Shot",
		description = "Learn the spell Falcon Shot. Shoot a powerful shot that deals physical damage to the target and nearby enemies, slowing them for 3 seconds.",
		effect = {
			{type = "spell", name = "Falcon Shot"},
		},
	},
	["10:26"] = {
		name = "Focused Fire",
		description = "Increase the damage done by your Phantom Shot, Falcon Shot and Rapid Fire by an additional 4% per level.",
		effect = {
			{type = "storage", name = "FocusedFire", value = 4},
		},
	},
	["10:27"] = {
		name = "Scorched Mark",
		description = "Dead from Above now increases your critical strike chance by 4% per level every time it triggers. This effect does not stack.",
		effect = {
			{type = "storage", name = "DeadFromAbove", value = 4},
		},
	},
	["10:28"] = {
		name = "Apex Predator",
		description = "When you kill an enemy, you gain Apex Predator for 8 seconds: +15% physical damage and +15% fire damage. 30 second cooldown.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 15},
			{type = "condition", name = "Fire Damage", value = 15},
		},
	},
	["10:30"] = {
		name = "Frostfire Arsenal",
		description = "Your ballistics and frost combine. Increases fire damage by 3% and ice damage by 3% while you have unlocked Explosive Barrel and Frost Barrel.",
		effect = {
			{type = "condition", name = "Fire Damage", value = 3},
			{type = "condition", name = "Ice Damage", value = 3},
		},
	},
	["10:31"] = {
		name = "Eternal Hunter",
		description = "Your frost and survival combine. Increases max health by 3% and ice damage by 3% while you have unlocked Frost Barrage and Tenacious Spirit.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
			{type = "condition", name = "Ice Damage", value = 3},
		},
	},
	["11:0"] = {
		name = "Virtuoso",
		description = "You are a master of sound and spirit. Increases energy damage by 2% and healing effectiveness by 2%.",
		effect = {
			{type = "condition", name = "Energy Damage", value = 2},
			{type = "condition", name = "Healing Effectiveness", value = 2},
		},
	},
	["11:1"] = {
		name = "Sonic Amplification",
		description = "+3% energy damage per level.",
		effect = {
			{type = "storage", name = "SonicAmplification", value = 3},
		},
	},
	["11:2"] = {
		name = "Dissonant Surge",
		description = "When Dissonance exceeds 70, your attack spells have a 5% chance per level to trigger a free Echo Strike on the target.",
		effect = {
			{type = "storage", name = "DissonantSurge", value = 5},
		},
	},
	["11:3"] = {
		name = "Strike Style",
		description = "Choose your offensive specialization.",
	},
	["11:4"] = {
		name = "Resonance Spread",
		description = "Resonant Chorus now applies Resonance to up to 2 additional enemies per level hit by the spell.",
		effect = {
			{type = "storage", name = "ResonanceSpread", value = 2},
		},
	},
	["11:5"] = {
		name = "Discordant Wrath",
		description = "Discordant Verse now hits all enemies within 2 tiles of the target. If the target has Resonance, the debuff spreads to all hit enemies.",
		effect = {
			{type = "storage", name = "DiscordantWrath", value = 1},
		},
	},
	["11:6"] = {
		name = "Harmonic Overload",
		description = "Harmonic Collapse detonations leave a sonic field for 3 seconds that deals energy damage per second to enemies inside. +10% explosion damage per level.",
		effect = {
			{type = "storage", name = "HarmonicOverload", value = 10},
		},
	},
	["11:7"] = {
		name = "Dissonant Frenzy",
		description = "While Dissonance is above 50, your attack spells deal +3% energy damage per level. While Dissonance is above 80, your critical hits with attack spells deal +5% extra damage per level.",
		effect = {
			{type = "storage", name = "DissonantFrenzy", value = 3},
		},
	},
	["11:8"] = {
		name = "Apocalypse Master",
		description = "Grand Finale (Dissonance mode) now also consumes all Resonance marks, each adding 15% damage. Requiem storage increased to 30%. Self-vulnerability debuff removed entirely.",
		effect = {
			{type = "storage", name = "ApocalypseMaster", value = 1},
		},
	},
	["11:11"] = {
		name = "Harmonious Aura",
		description = "+3% healing effectiveness per level.",
		effect = {
			{type = "condition", name = "Healing Effectiveness", value = 3},
		},
	},
	["11:12"] = {
		name = "Extended Performance",
		description = "Melody pulse range +1 per level and duration +3s per level.",
		effect = {
			{type = "storage", name = "ExtendedPerformance", value = 1},
		},
	},
	["11:13"] = {
		name = "Melodic Style",
		description = "Choose your support specialization.",
	},
	["11:14"] = {
		name = "Cheerful Cleansing",
		description = "Cheerful Melody now cleanses 1 negative condition per level from allies on application. Burst heal +10% per level.",
		effect = {
			{type = "storage", name = "CheerfulCleansing", value = 1},
		},
	},
	["11:15"] = {
		name = "Menacing Pressure",
		description = "Menacing Melody's damage taken debuff increases by +3% per level (from 15% base). Stun duration +0.5s per level.",
		effect = {
			{type = "storage", name = "MenacingPressure", value = 3},
		},
	},
	["11:16"] = {
		name = "Cathartic Resonance",
		description = "Cathartic Melody's damage buff now also applies to spell damage. Burst damage +8% per level.",
		effect = {
			{type = "storage", name = "CatharticResonance", value = 8},
		},
	},
	["11:17"] = {
		name = "Harmonious Overflow",
		description = "While Harmony is above 65, your melody effects are 20% stronger per level (healing, mana regen, speed, debuff). +2% max health per level.",
		effect = {
			{type = "storage", name = "HarmoniousOverflow", value = 20},
		},
	},
	["11:18"] = {
		name = "Elysian Master",
		description = "Grand Finale (Harmony mode) shield increased to 25% max HP. Cleansed allies gain immunity to negative conditions for 4s. Mana restore increased to 50% of heal.",
		effect = {
			{type = "storage", name = "ElysianMaster", value = 1},
		},
	},
	["11:21"] = {
		name = "Echo Mastery",
		description = "Sonic waves from Resonance now hit 1 additional target per level.",
		effect = {
			{type = "storage", name = "EchoMastery", value = 1},
		},
	},
	["11:22"] = {
		name = "Lingering Resonance",
		description = "Resonance duration +1s per level. When Resonance expires naturally, it deals burst energy damage to the target equal to 5% of damage stored per level.",
		effect = {
			{type = "storage", name = "LingeringResonance", value = 5},
		},
	},
	["11:23"] = {
		name = "Echo Style",
		description = "Choose your utility specialization.",
	},
	["11:24"] = {
		name = "Reverb Cascade",
		description = "While Reverberation is active, sonic waves also heal nearby allies for 3% of damage dealt per level.",
		effect = {
			{type = "storage", name = "ReverbCascade", value = 3},
		},
	},
	["11:25"] = {
		name = "Epic Tempo",
		description = "Epic Melody now also grants +3% attack speed per level to allies. Duration +2s per level.",
		effect = {
			{type = "storage", name = "EpicTempo", value = 3},
		},
	},
	["11:26"] = {
		name = "Bardic Soul",
		description = "+4% max mana per level and +2% mana regen per level. When you shift Dissonance or Harmony by casting any spell, restore 2% of max mana per level.",
		effect = {
			{type = "storage", name = "BardicSoul", value = 2},
		},
	},
	["11:27"] = {
		name = "Finale Mastery",
		description = "Grand Finale deals +8% damage and heals +8% per level. After casting Grand Finale, your resources reset to 65 instead of 50.",
		effect = {
			{type = "storage", name = "FinaleMastery", value = 8},
		},
	},
	["11:28"] = {
		name = "Virtuoso's Finale",
		description = "When you cast Grand Finale, all allies in range gain Crescendo Inspiration for 10s: +15% damage and +15% healing. Your Dissonance/Harmony resets to 75 instead of 50.",
		effect = {
			{type = "storage", name = "VirtuososFinale", value = 1},
		},
	},
	["11:30"] = {
		name = "Dark Symphony",
		description = "When Dissonance is above 70, your attack spells have a 10% chance to apply the Discordant Verse debuff (-15% damage dealt) to the target for 3 seconds. 8 second cooldown.",
		effect = {
			{type = "storage", name = "DarkSymphony", value = 10},
		},
	},
	["11:31"] = {
		name = "Eternal Echo",
		description = "When you cast any melody, all Resonating enemies take 15% more damage for 3 seconds.",
		effect = {
			{type = "storage", name = "EternalEcho", value = 15},
		},
	},
	["13:0"] = {
		name = "Bushido Spirit",
		description = "The way of the warrior. Increases physical damage by 2% and max health by 2%.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 2},
			{type = "condition", name = "Max Health", value = 2},
		},
	},
	["13:1"] = {
		name = "Keen Edge",
		description = "+3% physical damage per level.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 3},
		},
	},
	["13:2"] = {
		name = "Focus Mastery",
		description = "Maximum Focus stacks increased by 1 per level (up to 6). Synergy: Meditation can grant up to 6 Focus, and Blade Master triggers at max stacks.",
		effect = {
			{type = "storage", name = "FocusMastery", value = 1},
		},
	},
	["13:3"] = {
		name = "Sword Style",
		description = "Choose your offensive specialization: War Cry (party damage buff), Death Mark (debuff + execute synergy), or Blade Flurry (multi-hit that applies Exposed).",
	},
	["13:4"] = {
		name = "War Cry",
		description = "Learn the spell War Cry. Grant +10% damage to yourself and nearby party members for 8 seconds. Support spell that complements any build. 15s cooldown.",
		effect = {
			{type = "storage", name = "WarCry", value = 1},
		},
	},
	["13:5"] = {
		name = "Death Mark",
		description = "Learn the spell Death Mark. Mark a target for 8 seconds. Marked targets take +20% damage from all your attacks. Synergy: Merciful End gets +10% execute threshold and +15% damage on marked targets. 15s cooldown.",
		effect = {
			{type = "storage", name = "DeathMark", value = 1},
		},
	},
	["13:6"] = {
		name = "Bloodletting",
		description = "Crimson Lotus bleed duration +2s per level and bleed damage +10% per level. When a bleeding target dies, restore 5% max HP. Synergy: bleeding targets take +50% execute damage from Merciful End and Iaijutsu consumes bleeds for +20% damage.",
		effect = {
			{type = "storage", name = "Bloodletting", value = 10},
		},
	},
	["13:7"] = {
		name = "Executioner's Edge",
		description = "Merciful End execute threshold +5% per level (up to 40%). Execute damage +10% per level. Synergy: bleeding targets get +10% threshold, Death Mark gives +10% threshold.",
		effect = {
			{type = "storage", name = "ExecutionersEdge", value = 5},
		},
	},
	["13:8"] = {
		name = "Blade Master",
		description = "At maximum Focus, your finisher spells consume 0 Focus and deal +30% damage. 10s cooldown after triggering. This allows finishers to be used without losing your Focus stacks.",
		effect = {
			{type = "storage", name = "BladeMaster", value = 1},
		},
	},
	["13:9"] = {
		name = "Blade Flurry",
		description = "Learn the spell Blade Flurry. Strike a target 3 times in rapid succession, dealing physical damage. The final hit applies Exposed (max 3 stacks, 8s). Exposed targets take +10% damage from finishers per stack (up to +30%). Builder: generates +1 Focus. 3.5s cooldown.",
		effect = {
			{type = "storage", name = "BladeFlurry", value = 1},
		},
	},
	["13:11"] = {
		name = "Iron Body",
		description = "+3% max HP per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["13:12"] = {
		name = "Focused Defense",
		description = "Guardian Stance duration +2s per level and heal +5% per level.",
		effect = {
			{type = "storage", name = "FocusedDefense", value = 5},
		},
	},
	["13:13"] = {
		name = "Shield Style",
		description = "Choose your specialization: Phantom Slash (line dash + damage), Second Wind (heal), or Counter Strike (reactive counter-attack while Guardian Stance is active).",
	},
	["13:14"] = {
		name = "Phantom Slash",
		description = "Learn the spell Phantom Slash. Dash through all enemies in a line up to 4 tiles, dealing physical damage to each. Leaves after-images along the path. 6s cooldown.",
		effect = {
			{type = "storage", name = "PhantomSlash", value = 1},
		},
	},
	["13:15"] = {
		name = "Second Wind",
		description = "Learn the spell Second Wind. Instantly heal 15% max HP + 10% per Focus stack consumed. Consumes all Focus. 20s cooldown.",
		effect = {
			{type = "storage", name = "SecondWind", value = 1},
		},
	},
	["13:16"] = {
		name = "Parry",
		description = "+3% dodge per level. When you dodge an attack, gain 1 Focus stack. Synergy: Counter Strike chance scales with Parry levels (+3% per level).",
		effect = {
			{type = "storage", name = "Parry", value = 3},
		},
	},
	["13:17"] = {
		name = "Undying Will",
		description = "When you drop below 20% HP, gain 3 Focus stacks and 50% damage reduction for 4 seconds. 60s cooldown.",
		effect = {
			{type = "storage", name = "UndyingWill", value = 1},
		},
	},
	["13:18"] = {
		name = "Fortress",
		description = "Guardian Stance now reflects 50% of melee damage to attackers. While Guardian Stance is active, you generate 1 Focus when hit (1s cooldown). Synergy: enables Counter Strike proc.",
		effect = {
			{type = "storage", name = "Fortress", value = 1},
		},
	},
	["13:19"] = {
		name = "Counter Strike",
		description = "Learn Counter Strike (passive). While Guardian Stance is active, you have a chance to automatically counter-attack when hit, dealing physical damage and generating +1 Focus. Chance: 10% base + 3% per Parry level. Scales with Parry levels.",
		effect = {
			{type = "storage", name = "CounterStrike", value = 1},
		},
	},
	["13:21"] = {
		name = "Swift Feet",
		description = "+2% movement speed per level.",
		effect = {
			{type = "condition", name = "Speed", value = 20},
		},
	},
	["13:22"] = {
		name = "Wind Step Mastery",
		description = "Wind Step range +1 tile per level.",
		effect = {
			{type = "storage", name = "WindStepMastery", value = 1},
		},
	},
	["13:23"] = {
		name = "Wind Style",
		description = "Choose your utility specialization.",
	},
	["13:24"] = {
		name = "Blade Dash",
		description = "Learn the spell Blade Dash. Strike a target up to 3 tiles away, dash through them, and heal for 25% of damage dealt. Mobility + sustain spell. 6s cooldown.",
		effect = {
			{type = "storage", name = "BladeDash", value = 1},
		},
	},
	["13:25"] = {
		name = "Searing Wind",
		description = "Learn the spell Searing Wind. Your Wind Step leaves a trail of fire for 3 seconds that burns enemies standing in it. Passive enhancement to Wind Step.",
		effect = {
			{type = "storage", name = "SearingWind", value = 1},
		},
	},
	["13:26"] = {
		name = "Meditation",
		description = "Learn the spell Meditation. Channel for 1 second to instantly gain 3 Focus stacks. Respects Focus Mastery (up to 6 max). 15s cooldown.",
		effect = {
			{type = "storage", name = "Meditation", value = 1},
		},
	},
	["13:27"] = {
		name = "Flowing Water",
		description = "After using Wind Step, your next direct attack within 3s deals +15% damage per level and generates +1 Focus. Synergy: stacks with Wind Step → Iaijutsu combo for burst damage.",
		effect = {
			{type = "storage", name = "FlowingWater", value = 15},
		},
	},
	["13:28"] = {
		name = "Storm Spirit",
		description = "After dashing, gain Storm Spirit for 5s: +20% attack speed, +15% cooldown reduction, and your attacks hit all enemies within 2 tiles (50% splash damage).",
		effect = {
			{type = "storage", name = "StormSpirit", value = 1},
		},
	},
	["13:30"] = {
		name = "Bushido",
		description = "When you consume 3+ Focus stacks on a finisher, gain Bushido for 6 seconds: +10% damage and +10% damage reduction. Synergy: pairs with Blade Master for sustained finisher pressure.",
		effect = {
			{type = "storage", name = "Bushido", value = 1},
		},
	},
	["13:31"] = {
		name = "Zanshin",
		description = "After consuming all Focus, your next builder spell within 3 seconds generates 2 Focus stacks instead of 1 and deals +25% damage. Synergy: enables rapid Focus rebuilding after a finisher for combo chains.",
		effect = {
			{type = "storage", name = "Zanshin", value = 1},
		},
	},
	["14:0"] = {
		name = "Sanguine Heritage",
		description = "Blood is power. Increases lifesteal by 2% and max Blood Essence by 5.",
		effect = {
			{type = "condition", name = "Lifesteal", value = 2},
			{type = "storage", name = "EssenceFlow", value = 5},
		},
	},
	["14:1"] = {
		name = "Blood Power",
		description = "+3% damage per level.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 3},
		},
	},
	["14:2"] = {
		name = "Bleed Mastery",
		description = "Bleed damage +15% per level and bleed duration +1s per level.",
		effect = {
			{type = "storage", name = "BleedMastery", value = 15},
		},
	},
	["14:3"] = {
		name = "Crimson Fork",
		description = "Choose your offensive specialization.",
	},
	["14:4"] = {
		name = "Blood Curse",
		description = "Learn the spell Blood Curse. Debuff a target for 6 seconds: target takes +15% damage and healing received is reduced by 50%. 12s cooldown.",
		effect = {
			{type = "storage", name = "BloodCurse", value = 1},
		},
	},
	["14:5"] = {
		name = "Crimson Rain",
		description = "Learn the spell Crimson Rain. Call down a rain of blood on a 3x3 area for 5 seconds, applying bleeds to all enemies standing in it. 10s cooldown.",
		effect = {
			{type = "storage", name = "CrimsonRain", value = 1},
		},
	},
	["14:6"] = {
		name = "Eruption Mastery",
		description = "Blood Eruption damage bonus per bleed consumed +10% per level and shield cap +5% per level.",
		effect = {
			{type = "storage", name = "EruptionMastery", value = 10},
		},
	},
	["14:7"] = {
		name = "Frenzy Mastery",
		description = "Blood Frenzy duration +2s per level and damage bonus +5% per level.",
		effect = {
			{type = "storage", name = "FrenzyMastery", value = 5},
		},
	},
	["14:8"] = {
		name = "Crimson Devastation",
		description = "Blood Detonation damage +50%. Survivors of Blood Detonation get a new bleed applied (4 ticks, 25% heal).",
		effect = {
			{type = "storage", name = "CrimsonDevastation", value = 1},
		},
	},
	["14:11"] = {
		name = "Vitality",
		description = "+3% max HP per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["14:12"] = {
		name = "Lifesteal Mastery",
		description = "+2% lifesteal per level.",
		effect = {
			{type = "condition", name = "Lifesteal", value = 2},
		},
	},
	["14:13"] = {
		name = "Sanguine Fork",
		description = "Choose your defensive specialization.",
	},
	["14:14"] = {
		name = "Sanguine Shield",
		description = "Learn the spell Sanguine Shield. For 5 seconds, 20% of incoming damage is converted to Blood Essence instead of dealing damage. 15s cooldown.",
		effect = {
			{type = "storage", name = "SanguineShield", value = 1},
		},
	},
	["14:15"] = {
		name = "Vampiric Aura",
		description = "Learn the spell Vampiric Aura. For 10 seconds, all allies within 5 tiles gain 10% lifesteal. 20s cooldown.",
		effect = {
			{type = "storage", name = "VampiricAura", value = 1},
		},
	},
	["14:16"] = {
		name = "Pool Mastery",
		description = "Sanguine Pool duration +1s per level and shield +5% per level.",
		effect = {
			{type = "storage", name = "PoolMastery", value = 5},
		},
	},
	["14:17"] = {
		name = "Blood Armor",
		description = "When you kill a bleeding target, gain a shield equal to 10% max HP for 5 seconds.",
		effect = {
			{type = "storage", name = "BloodArmor", value = 1},
		},
	},
	["14:18"] = {
		name = "Sanguine Fortress",
		description = "Sanguine Pool now cleanses all debuffs on cast and grants CC immunity for its duration.",
		effect = {
			{type = "storage", name = "SanguineFortress", value = 1},
		},
	},
	["14:21"] = {
		name = "Essence Flow",
		description = "+5 max Blood Essence per level (up to 115).",
		effect = {
			{type = "storage", name = "EssenceFlow", value = 5},
		},
	},
	["14:22"] = {
		name = "Orb Mastery",
		description = "+1 max Blood Orb per level (up to 8).",
		effect = {
			{type = "storage", name = "OrbMastery", value = 1},
		},
	},
	["14:23"] = {
		name = "Hemomancy Fork",
		description = "Choose your utility specialization.",
	},
	["14:24"] = {
		name = "Blood Walk",
		description = "Learn the spell Blood Walk. Teleport to a bleeding target within 6 tiles, dealing AoE damage on arrival. 6s cooldown.",
		effect = {
			{type = "storage", name = "BloodWalk", value = 1},
		},
	},
	["14:25"] = {
		name = "Crimson Chains",
		description = "Learn the spell Crimson Chains. Root all enemies within 3 tiles for 3 seconds. 12s cooldown.",
		effect = {
			{type = "storage", name = "CrimsonChains", value = 1},
		},
	},
	["14:26"] = {
		name = "Tether Mastery",
		description = "Blood Tether duration +1s per level and damage +10% per level.",
		effect = {
			{type = "storage", name = "TetherMastery", value = 10},
		},
	},
	["14:27"] = {
		name = "Blood Ritual",
		description = "Learn the spell Blood Ritual. Toggle: sacrifice 5% HP per second for 15 Blood Essence per second. 1s cooldown to toggle off.",
		effect = {
			{type = "storage", name = "BloodRitual", value = 1},
		},
	},
	["14:28"] = {
		name = "Hemomancy Mastery",
		description = "Blood Lance only consumes 50% of orbs (rounded down). During Blood Frenzy, Blood Lance applies 2 bleeds instead of 1.",
		effect = {
			{type = "storage", name = "HemomancyMastery", value = 1},
		},
	},
	["14:30"] = {
		name = "Blood Sovereignty",
		description = "When you enter Blood Frenzy, all active bleeds on enemies are instantly triggered (deal all remaining damage at once).",
		effect = {
			{type = "storage", name = "BloodSovereignty", value = 1},
		},
	},
	["14:31"] = {
		name = "Eternal Thirst",
		description = "While in Blood Frenzy, all spell HP costs are reduced by 50%.",
		effect = {
			{type = "storage", name = "EternalThirst", value = 1},
		},
	},
	["15:0"] = {
		name = "Nature's Guardian",
		description = "+2% max HP. When you apply an Elemental Mark, gain 1 stack of Guardian's Resolve (max 5). Each stack: +1% damage and +1% shield strength. Stacks decay after 8s of no mark application.",
		effect = {
			{type = "condition", name = "Max Health", value = 2},
		},
	},
	["15:1"] = {
		name = "Earth Power",
		description = "+3% earth damage per level.",
		effect = {
			{type = "condition", name = "Physical Damage", value = 3},
		},
	},
	["15:2"] = {
		name = "Resonating Marks",
		description = "When you apply an Elemental Mark, 20% chance per level to trigger an echo: deal 10% of the spell's damage again as earth damage to all enemies within 2 tiles.",
		effect = {
			{type = "storage", name = "ResonatingMarks", value = 20},
		},
	},
	["15:3"] = {
		name = "Earth Fork",
		description = "Choose your offensive specialization.",
	},
	["15:4"] = {
		name = "Thorned Skin",
		description = "Learn the spell Thorned Skin. For 8 seconds, reflect 25% of melee damage as earth. Each reflect grants 1 Thorn Stack (max 5). When Thorned Skin ends, each stack explodes for earth damage around you. 15s cooldown.",
		effect = {
			{type = "storage", name = "ThornedSkin", value = 1},
		},
	},
	["15:5"] = {
		name = "Seismic Slam",
		description = "Learn the spell Seismic Slam. Leap to a target location (5 tiles), dealing earth damage in 3x3 on impact. If you have Earth Mark, consume it to stun all hit enemies for 2s and create a Fissure on the landing spot for 5s. 8s cooldown.",
		effect = {
			{type = "storage", name = "SeismicSlam", value = 1},
		},
	},
	["15:6"] = {
		name = "Cleave Mastery",
		description = "Crystal Cleave has +15% chance per level to apply Earth Mark twice. Crystal Cleave damage +10% per level.",
		effect = {
			{type = "storage", name = "CleaveMastery", value = 15},
		},
	},
	["15:7"] = {
		name = "Tectonic Surge",
		description = "When you consume an Earth Mark, gain Tectonic Surge for 6s: your next earth spell deals +20% damage per level and applies Earth Mark even if it normally doesn't.",
		effect = {
			{type = "storage", name = "TectonicSurge", value = 20},
		},
	},
	["15:8"] = {
		name = "Tectonic Wrath",
		description = "When you consume an Earth Mark, all enemies within 3 tiles take earth damage equal to 5% of your max HP and are knocked back 2 tiles. If this kills a target, instantly refresh Earth Mark on yourself.",
		effect = {
			{type = "storage", name = "TectonicWrath", value = 1},
		},
	},
	["15:11"] = {
		name = "Frost Resilience",
		description = "+3% max HP per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 3},
		},
	},
	["15:12"] = {
		name = "Shield Mastery",
		description = "All shields +10% per level. When a shield is fully absorbed, gain 1 Guardian's Resolve stack.",
		effect = {
			{type = "storage", name = "ShieldMastery", value = 10},
		},
	},
	["15:13"] = {
		name = "Frost Fork",
		description = "Choose your defensive specialization.",
	},
	["15:14"] = {
		name = "Ice Barrier",
		description = "Learn the spell Ice Barrier. For 6 seconds, gain a shield absorbing 20% max HP. Melee attackers are slowed 30% for 3s and you gain 1 Frost Stack per hit (max 5). When the shield expires, each Frost Stack releases a frozen shard at the nearest enemy. 12s cooldown.",
		effect = {
			{type = "storage", name = "IceBarrier", value = 1},
		},
	},
	["15:15"] = {
		name = "Taunting Roar",
		description = "Learn the spell Taunting Roar. Force all enemies within 4 tiles to attack you for 4s. Marked targets are also rooted for 2s. While taunted, enemies deal 15% less damage to you. 20s cooldown.",
		effect = {
			{type = "storage", name = "TauntingRoar", value = 1},
		},
	},
	["15:16"] = {
		name = "Frozen Heart",
		description = "When a shield expires or is fully absorbed, freeze all enemies within 2 tiles for 1s + 0.5s per level. 10s cooldown per level.",
		effect = {
			{type = "storage", name = "FrozenHeart", value = 1},
		},
	},
	["15:17"] = {
		name = "Cold Blooded",
		description = "When you drop below 40% HP, automatically cast Permafrost Shell (if off cooldown) and gain 20% damage reduction for 4s. 30s cooldown per level.",
		effect = {
			{type = "storage", name = "ColdBlooded", value = 1},
		},
	},
	["15:18"] = {
		name = "Permafrost",
		description = "Permafrost Shell grants CC immunity for its duration. When fully absorbed, instantly refresh its cooldown and apply Frost Mark to all enemies within 3 tiles.",
		effect = {
			{type = "storage", name = "Permafrost", value = 1},
		},
	},
	["15:21"] = {
		name = "Healing Touch",
		description = "Sylvan Mend heal +10% per level. When you heal a target with an active shield, the shield is also strengthened by 10% per level.",
		effect = {
			{type = "storage", name = "HealingTouch", value = 10},
		},
	},
	["15:22"] = {
		name = "Nature's Swiftness",
		description = "+2% movement speed per level. After casting any spell, your next melee attack within 3s deals +15% damage per level and applies both Earth and Frost Mark.",
		effect = {
			{type = "storage", name = "NaturesSwiftness", value = 15},
		},
	},
	["15:23"] = {
		name = "Wilderness Fork",
		description = "Choose your utility specialization.",
	},
	["15:24"] = {
		name = "Root Grasp",
		description = "Learn the spell Root Grasp. Root a target for 3s. If the target has Earth Mark, consume it: root spreads to all enemies within 2 tiles and duration becomes 5s. Rooted enemies take +15% damage. 10s cooldown.",
		effect = {
			{type = "storage", name = "RootGrasp", value = 1},
		},
	},
	["15:25"] = {
		name = "Spring of Life",
		description = "Learn the spell Spring of Life. Create a healing spring on a 3x3 area for 8s. Allies standing in it heal 4% max HP/s and gain 5% damage reduction. If you have Earth Mark, consume it: spring also cleanses debuffs on entry. 20s cooldown.",
		effect = {
			{type = "storage", name = "SpringOfLife", value = 1},
		},
	},
	["15:26"] = {
		name = "Bulwark Mastery",
		description = "Guardian's Bulwark radius +1 tile per level. Allies shielded gain +5% damage reduction per level for the shield's duration.",
		effect = {
			{type = "storage", name = "BulwarkMastery", value = 5},
		},
	},
	["15:27"] = {
		name = "Sanctuary Mastery",
		description = "Verdant Sanctuary duration +2s per level. Final explosion damage +15% per level and applies Earth Mark to all enemies hit.",
		effect = {
			{type = "storage", name = "SanctuaryMastery", value = 15},
		},
	},
	["15:28"] = {
		name = "Nature's Wrath",
		description = "20% chance when applying a Mark to also apply the opposite Mark. Both marks can now be active simultaneously. When both marks are active, your spells deal +15% damage and shields are +15% stronger.",
		effect = {
			{type = "storage", name = "NaturesWrath", value = 1},
		},
	},
	["15:30"] = {
		name = "Elemental Harmony",
		description = "When you consume an Earth Mark, gain Frost Charge for 5s: next Frost spell deals +40% damage. When you consume a Frost Mark, gain Earth Charge for 5s: next Earth spell deals +40% damage and its shield/heal is empowered by 40%.",
		effect = {
			{type = "storage", name = "ElementalHarmony", value = 1},
		},
	},
	["15:31"] = {
		name = "Guardian's Oath",
		description = "When you cast a shield spell, all allies within 3 tiles gain 10% of the shield amount and Guardian's Resolve stacks are doubled for 5s. When you cast a heal, all allies within 3 tiles gain 10% lifesteal for 5s. At 5 Guardian's Resolve stacks, your next shield spell costs no mana.",
		effect = {
			{type = "storage", name = "GuardiansOath", value = 1},
		},
	},
	["12:0"] = {
		name = "Tinker's Ingenuity",
		description = "Increases max Scrap by 1 and all damage by 2% per Scrap stack.",
		effect = {
			{type = "storage", name = "Ingenuity", value = 1},
		},
	},
	["12:1"] = {
		name = "Bot Mastery",
		description = "+3% bot damage per level.",
		effect = {
			{type = "storage", name = "BotMastery", value = 3},
		},
	},
	["12:2"] = {
		name = "Reinforced Chassis",
		description = "+5% bot HP per level.",
		effect = {
			{type = "storage", name = "ReinforcedChassis", value = 5},
		},
	},
	["12:3"] = {
		name = "Fork: Combat Protocol",
		description = "Choose a combat protocol for your bots.",
	},
	["12:4"] = {
		name = "Assault Module",
		description = "All bots gain a second attack spell. +1 extra attack per level.",
		effect = {
			{type = "storage", name = "AssaultModule", value = 1},
		},
	},
	["12:5"] = {
		name = "Swarm Protocol",
		description = "+1 max mines and +5% mine damage per level.",
		effect = {
			{type = "storage", name = "SwarmProtocol", value = 1},
		},
	},
	["12:6"] = {
		name = "Overclocked Servos",
		description = "Bots move 15% faster and attack 10% faster per level.",
		effect = {
			{type = "storage", name = "OverclockedServos", value = 1},
		},
	},
	["12:7"] = {
		name = "Fork: Bot Blueprint",
		description = "Choose a new bot blueprint to deploy.",
	},
	["12:8"] = {
		name = "Laser Bot",
		description = "Unlocks Deploy Laser Bot — melee bot with a wave laser attack (3-tile line AoE).",
		effect = {
			{type = "storage", name = "LaserBotUnlock", value = 1},
		},
	},
	["12:9"] = {
		name = "Ranger Bot",
		description = "Unlocks Deploy Ranger Bot — long-range sniper bot (range 6, high damage).",
		effect = {
			{type = "storage", name = "RangerBotUnlock", value = 1},
		},
	},
	["12:10"] = {
		name = "War Bot MK2",
		description = "War Bot transforms into War Bot MK2: gains energy beam spell, shield aura, and +50% HP.",
		effect = {
			{type = "storage", name = "WarBotMK2", value = 1},
		},
	},
	["12:11"] = {
		name = "Targeting Matrix",
		description = "+2% critical hit chance for all bots per level.",
		effect = {
			{type = "storage", name = "TargetingMatrix", value = 2},
		},
	},
	["12:12"] = {
		name = "EMP Overload",
		description = "Bots explode on death dealing energy AoE damage equal to 20% of their max HP.",
		effect = {
			{type = "storage", name = "EMPOverload", value = 1},
		},
	},
	["12:13"] = {
		name = "Mech Commander",
		description = "+1 max robot. Mech Suite enhanced: player +30% damage, bots +40% damage, +5s duration.",
		effect = {
			{type = "storage", name = "MechCommander", value = 1},
		},
	},
	["12:14"] = {
		name = "Explosive Force",
		description = "+3% explosion damage per level (Grenade, Mine, Bomber).",
		effect = {
			{type = "storage", name = "ExplosiveForce", value = 3},
		},
	},
	["12:15"] = {
		name = "Shrapnel",
		description = "Explosions leave a 3s bleed on hit targets. +2% bleed damage per level.",
		effect = {
			{type = "storage", name = "Shrapnel", value = 2},
		},
	},
	["12:16"] = {
		name = "Fork: Detonation Style",
		description = "Choose a detonation enhancement.",
	},
	["12:17"] = {
		name = "Chain Reaction",
		description = "Explosions have 20% chance per level to chain to a nearby enemy.",
		effect = {
			{type = "storage", name = "ChainReaction", value = 20},
		},
	},
	["12:18"] = {
		name = "Thermite",
		description = "Explosions deal +15% fire damage over 3s per level.",
		effect = {
			{type = "storage", name = "Thermite", value = 15},
		},
	},
	["12:19"] = {
		name = "Cluster Bomb",
		description = "Grenade Toss spawns 3 mini explosions around impact point.",
		effect = {
			{type = "storage", name = "ClusterBomb", value = 1},
		},
	},
	["12:20"] = {
		name = "Mine Field",
		description = "+2 max Land Mines, mine cooldown reduced by 2s.",
		effect = {
			{type = "storage", name = "MineField", value = 1},
		},
	},
	["12:21"] = {
		name = "Volatile Mixture",
		description = "+5% fire damage per level.",
		effect = {
			{type = "storage", name = "VolatileMixture", value = 5},
		},
	},
	["12:22"] = {
		name = "Concussion Blast",
		description = "Explosions have 25% chance to stun targets for 1s.",
		effect = {
			{type = "storage", name = "ConcussionBlast", value = 25},
		},
	},
	["12:23"] = {
		name = "Demolitionist",
		description = "Grenade Toss costs 0 Scrap. Land Mines detonate in 2x2 area.",
		effect = {
			{type = "storage", name = "Demolitionist", value = 1},
		},
	},
	["12:24"] = {
		name = "Plated Armor",
		description = "+2% max health per level.",
		effect = {
			{type = "condition", name = "Max Health", value = 2},
		},
	},
	["12:25"] = {
		name = "Shield Generator",
		description = "Casting Repair also gives addShield() for 5% of max HP per level.",
		effect = {
			{type = "storage", name = "ShieldGenerator", value = 5},
		},
	},
	["12:26"] = {
		name = "Fork: Defense System",
		description = "Choose a defensive system.",
	},
	["12:27"] = {
		name = "Barrier Bot",
		description = "Unlocks Deploy Barrier Bot — stationary bot that casts addShield() on allies in range.",
		effect = {
			{type = "storage", name = "BarrierBotUnlock", value = 1},
		},
	},
	["12:28"] = {
		name = "Reactive Armor",
		description = "Taking damage has 15% chance per level to knockback the attacker.",
		effect = {
			{type = "storage", name = "ReactiveArmor", value = 15},
		},
	},
	["12:29"] = {
		name = "Field Medic",
		description = "Repair Bots also heals the player for 50% of the amount healed.",
		effect = {
			{type = "storage", name = "FieldMedic", value = 1},
		},
	},
	["12:30"] = {
		name = "Power Core",
		description = "+1 max Scrap per level.",
		effect = {
			{type = "storage", name = "PowerCore", value = 1},
		},
	},
	["12:31"] = {
		name = "Emergency Protocol",
		description = "Below 30% HP: auto-deploy a War Bot and gain shield. 60s cooldown.",
		effect = {
			{type = "storage", name = "EmergencyProtocol", value = 1},
		},
	},
	["12:32"] = {
		name = "Nanite Repair",
		description = "+3% HP regeneration per level.",
		effect = {
			{type = "condition", name = "HP Regeneration", value = 3},
		},
	},
	["12:33"] = {
		name = "Mech Suite",
		description = "Unlocks Mech Suite spell: +20% damage and attack speed to self and bots, 15s duration.",
		effect = {
			{type = "spell", name = "Mech Suite"},
		},
	},
	["12:34"] = {
		name = "Scrap Munitions",
		description = "When you deploy a bot, your next Grenade Toss costs 0 Scrap. 10s cooldown.",
		effect = {
			{type = "storage", name = "Scrap Munitions", value = 1},
		},
	},
	["12:35"] = {
		name = "Juggernaut Protocol",
		description = "Mech Suite also grants +10% max HP and repairs all active bots to full on activation.",
		effect = {
			{type = "storage", name = "Juggernaut Protocol", value = 1},
		},
	},
	["12:36"] = {
		name = "Controlled Detonation",
		description = "Land Mines and Grenade Toss heal you for 5% of max HP per explosion hit.",
		effect = {
			{type = "storage", name = "Controlled Detonation", value = 5},
		},
	},
}
