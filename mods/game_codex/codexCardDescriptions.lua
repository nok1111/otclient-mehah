
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
			[1] = "3% chance to chain damage to 1 nearby enemy",
			[2] = "4% chance to chain damage to 2 nearby enemy",
			[3] = "5% chance to chain damage to 3 nearby enemy",
			[4] = "6% chance to chain damage to 4 nearby enemy",
			[5] = "7% chance to chain damage to 5 nearby enemy",
			[6] = "8% chance to chain damage to 6 nearby enemy",
			[7] = "9% chance to chain damage to 7 nearby enemy",
			[8] = "10% chance to chain damage to 8 nearby enemy",
			[9] = "11% chance to chain damage to 9 nearby enemy",
			[10] = "12% chance to chain damage to 10 nearby enemies"
		}
	},
	[2] = {
		name = "Blood Echo",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "bloodecho",
		descriptions = {
			[1] = "2% of damage dealt is echoed as healing",
			[2] = "3% of damage dealt is echoed as healing",
			[3] = "4% of damage dealt is echoed as healing",
			[4] = "5% of damage dealt is echoed as healing",
			[5] = "6% of damage dealt is echoed as healing",
			[6] = "7% of damage dealt is echoed as healing",
			[7] = "8% of damage dealt is echoed as healing",
			[8] = "9% of damage dealt is echoed as healing",
			[9] = "10% of damage dealt is echoed as healing",
			[10] = "11% of damage dealt is echoed as healing"
		}
	},
	[3] = {
		name = "Critical Surge",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "criticalsurge",
		descriptions = {
			[1] = "+4% Critical Hit Chance",
			[2] = "+8% Critical Hit Chance",
			[3] = "+10% Critical Hit Chance",
			[4] = "+12% Critical Hit Chance",
			[5] = "+15% Critical Hit Chance",
			[6] = "+18% Critical Hit Chance",
			[7] = "+20% Critical Hit Chance",
			[8] = "+24% Critical Hit Chance",
			[9] = "+26% Critical Hit Chance",
			[10] = "+30% Critical Hit Chance"
		}
	},
	[4] = {
		name = "Executioner",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "executioner",
		descriptions = {
			[1] = "reduce your cooldowns by 100ms after a kill",
			[2] = "reduce your cooldowns by 150ms after a kill",
			[3] = "reduce your cooldowns by 200ms after a kill",
			[4] = "reduce your cooldowns by 300ms after a kill",
			[5] = "reduce your cooldowns by 500ms after a kill",
			[6] = "reduce your cooldowns by 600 ms after a kill",
			[7] = "reduce your cooldowns by 800 ms after a kill",
			[8] = "reduce your cooldowns by 1 second after a kill",
			[9] = "reduce your cooldowns by 1.2 seconds after a kill",
			[10] = "reduce your cooldowns by 1.5 seconds after a kill"
		}
	},
	[5] = {
		name = "Golem",
		rarity = "common",
		trigger = "onDamageTaken",
		cardFrame = "golem",
		descriptions = {
			[1] = "Reduce all damage taken by 4%",
			[2] = "Reduce all damage taken by 5%",
			[3] = "Reduce all damage taken by 6%",
			[4] = "Reduce all damage taken by 8%",
			[5] = "Reduce all damage taken by 10%",
			[6] = "Reduce all damage taken by 12%",
			[7] = "Reduce all damage taken by 14%",
			[8] = "Reduce all damage taken by 16%",
			[9] = "Reduce all damage taken by 18%",
			[10] = "Reduce all damage taken by 20%"
		}
	},
	[6] = {
		name = "Water Elemental",
		rarity = "epic",
		trigger = "onDamageTaken",
		cardFrame = "water elemental",
		descriptions = {
			[1] = "10% of damage taken is converted to mana (1:1 ratio)",
			[2] = "12% of damage taken is converted to mana (1:1 ratio)",
			[3] = "14% of damage taken is converted to mana (1:1 ratio)",
			[4] = "16% of damage taken is converted to mana (1:1 ratio)",
			[5] = "15% of damage taken is converted to mana (1:1 ratio)",
			[6] = "18% of damage taken is converted to mana (1:1 ratio)",
			[7] = "20% of damage taken is converted to mana (1:1 ratio)",
			[8] = "22% of damage taken is converted to mana (1:1 ratio)",
			[9] = "24% of damage taken is converted to mana (1:1 ratio)",
			[10] = "25% of damage taken is converted to mana (1:1 ratio)"
		}
	},
	[7] = {
		name = "Ravenous Beast",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "ravenous beast",
		descriptions = {
			[1] = "Deal 10% more damage when below 25% HP",
			[2] = "Deal 12% more damage when below 28% HP",
			[3] = "Deal 14% more damage when below 30% HP",
			[4] = "Deal 16% more damage when below 32% HP",
			[5] = "Deal 18% more damage when below 34% HP",
			[6] = "Deal 20% more damage when below 36% HP",
			[7] = "Deal 22% more damage when below 38% HP",
			[8] = "Deal 24% more damage when below 40% HP",
			[9] = "Deal 26% more damage when below 42% HP",
			[10] = "Deal 30% more damage when below 45% HP"
		}
	},
	[8] = {
		name = "The Phoenix",
		rarity = "legendary",
		trigger = "onDeath",
		cardFrame = "the phoenix",
		descriptions = {
			[1] = "Revive with 20% HP once every 180 minutes",
			[2] = "Revive with 25% HP once every 170 minutes",
			[3] = "Revive with 30% HP once every 160 minutes",
			[4] = "Revive with 35% HP once every 150 minutes",
			[5] = "Revive with 40% HP once every 140 minutes",
			[6] = "Revive with 50% HP once every 130 minutes",
			[7] = "Revive with 60% HP once every 120 minutes",
			[8] = "Revive with 70% HP once every 110 minutes",
			[9] = "Revive with 80% HP once every 100 minutes",
			[10] = "Revive with 90% HP once every 90 minutes"
		}
	},
	[9] = {
		name = "The Witch",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "the witch",
		descriptions = {
			[1] = "gain +2 magic level for every 1000 max mana points",
			[2] = "gain +2 magic level for every 950 max mana points",
			[3] = "gain +2 magic level for every 950 max mana points",
			[4] = "gain +2 magic level for every 900 max mana points",
			[5] = "gain +2 magic level for every 850 max mana points",
			[6] = "gain +2 magic level for every 800 max mana points",
			[7] = "gain +2 magic level for every 750 max mana points",
			[8] = "gain +2 magic level for every 700 max mana points",
			[9] = "gain +2 magic level for every 650 max mana points",
			[10] = "gain +2 magic level for every 600 max mana points"
		}
	},
	[10] = {
		name = "The Behemoth",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "the behemoth",
		descriptions = {
			[1] = "Increase your size by 5%, max health by 20% and gain 5% life leech",
			[2] = "Increase your size by 10%, max health by 25% and gain 6% life leech",
			[3] = "Increase your size by 15%, max health by 30% and gain 7% life leech",
			[4] = "Increase your size by 20%, max health by 35% and gain 8% life leech",
			[5] = "Increase your size by 25%, max health by 40% and gain 10% life leech",
			[6] = "Increase your size by 30%, max health by 45% and gain 12% life leech",
			[7] = "Increase your size by 35%, max health by 50% and gain 14% life leech",
			[8] = "Increase your size by 40%, max health by 55% and gain 16% life leech",
			[9] = "Increase your size by 45%, max health by 60% and gain 18% life leech",
			[10] = "Increase your size by 50%, max health by 65% and gain 20% life leech"
		}
	},
	[11] = {
		name = "Guns Lover",
		rarity = "legendary",
		trigger = "onSpell",
		cardFrame = "guns lover",
		descriptions = {
			[1] = "Ranged attacks: 10% chance for 2x2 AoE (30% + 3% per attack speed%)",
			[2] = "Ranged attacks: 12% chance for 2x2 AoE (30% + 3% per attack speed%)",
			[3] = "Ranged attacks: 14% chance for 2x2 AoE (30% + 3% per attack speed%)",
			[4] = "Ranged attacks: 16% chance for 2x2 AoE (30% + 3% per attack speed%)",
			[5] = "Ranged attacks: 18% chance for 2x2 AoE (30% + 3% per attack speed%)",
			[6] = "Ranged attacks: 20% chance for 2x2 AoE (30% + 3% per attack speed%)",
			[7] = "Ranged attacks: 22% chance for 2x2 AoE (30% + 3% per attack speed%)",
			[8] = "Ranged attacks: 24% chance for 2x2 AoE (30% + 3% per attack speed%)",
			[9] = "Ranged attacks: 26% chance for 2x2 AoE (30% + 3% per attack speed%)",
			[10] = "Ranged attacks: 28% chance for 2x2 AoE (30% + 3% per attack speed%)"
		}
	},
	[12] = {
		name = "Goliath",
		rarity = "rare",
		trigger = "onSpell",
		cardFrame = "goliath",
		descriptions = {
			[1] = "When below 20% HP, every spell you cast will heal you for 1% of your max HP",
			[2] = "When below 20% HP, every spell you cast will heal you for 2% of your max HP",
			[3] = "When below 20% HP, every spell you cast will heal you for 3% of your max HP",
			[4] = "When below 20% HP, every spell you cast will heal you for 4% of your max HP",
			[5] = "When below 21% HP, every spell you cast will heal you for 5% of your max HP",
			[6] = "When below 22% HP, every spell you cast will heal you for 6% of your max HP",
			[7] = "When below 24% HP, every spell you cast will heal you for 7% of your max HP",
			[8] = "When below 26% HP, every spell you cast will heal you for 8% of your max HP",
			[9] = "When below 28% HP, every spell you cast will heal you for 9% of your max HP",
			[10] = "When below 30% HP, every spell you cast will heal you for 10% of your max HP"
		}
	},
	[13] = {
		name = "The Gunner",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "gunner",
		descriptions = {
			[1] = "Increase your attack speed by 2% and critical chance by 2%",
			[2] = "Increase your attack speed by 4% and critical chance by 4%",
			[3] = "Increase your attack speed by 6% and critical chance by 6%",
			[4] = "Increase your attack speed by 8% and critical chance by 8%",
			[5] = "Increase your attack speed by 10% and critical chance by 10%",
			[6] = "Increase your attack speed by 12% and critical chance by 12%",
			[7] = "Increase your attack speed by 14% and critical chance by 14%",
			[8] = "Increase your attack speed by 16% and critical chance by 16%",
			[9] = "Increase your attack speed by 18% and critical chance by 18%",
			[10] = "Increase your attack speed by 20% and critical chance by 20%"
		}
	},
	[14] = {
		name = "Soul Leech",
		rarity = "epic",
		trigger = "onKill",
		cardFrame = "soul leech",
		descriptions = {
			[1] = "Restore 5% max HP and max Mana on kill",
			[2] = "Restore 6% max HP and max Mana on kill",
			[3] = "Restore 7% max HP and max Mana on kill",
			[4] = "Restore 8% max HP and max Mana on kill",
			[5] = "Restore 9% max HP and max Mana on kill",
			[6] = "Restore 10% max HP and max Mana on kill",
			[7] = "Restore 11% max HP and max Mana on kill",
			[8] = "Restore 12% max HP and max Mana on kill",
			[9] = "Restore 13% max HP and max Mana on kill",
			[10] = "Restore 14% max HP and max Mana on kill"
		}
	},
	[15] = {
		name = "Carnage Presence",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "carnage presence",
		descriptions = {
			[1] = "killing an enemy has a 5% chance to explode and deal 15% damage of his max hp",
			[2] = "killing an enemy has a 7% chance to explode and deal 16% damage of his max hp",
			[3] = "killing an enemy has a 9% chance to explode and deal 17% damage of his max hp",
			[4] = "killing an enemy has a 11% chance to explode and deal 18% damage of his max hp",
			[5] = "killing an enemy has a 13% chance to explode and deal 19% damage of his max hp",
			[6] = "killing an enemy has a 15% chance to explode and deal 20% damage of his max hp",
			[7] = "killing an enemy has a 17% chance to explode and deal 21% damage of his max hp",
			[8] = "killing an enemy has a 19% chance to explode and deal 22% damage of his max hp",
			[9] = "killing an enemy has a 21% chance to explode and deal 24% damage of his max hp",
			[10] = "killing an enemy has a 25% chance to explode and deal 25% damage of his max hp"
		}
	},
	[16] = {
		name = "Blood is Fuel",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "bloodisfuel",
		descriptions = {
			[1] = "spells cost 2% max HP, gain +4% damage",
			[2] = "spells cost 3% max HP, gain +5% damage",
			[3] = "spells cost 4% max HP, gain +6% damage",
			[4] = "spells cost 5% max HP, gain +7% damage",
			[5] = "spells cost 6% max HP, gain +8% damage",
			[6] = "spells cost 7% max HP, gain +9% damage",
			[7] = "spells cost 8% max HP, gain +10% damage",
			[8] = "spells cost 8% max HP, gain +11% damage",
			[9] = "spells cost 8% max HP, gain +12% damage",
			[10] = "spells cost 8% max HP, gain +15% damage"
		}
	},
	[17] = {
		name = "The Necromancer",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "the necromancer",
		descriptions = {
			[1] = "Killed enemies fight for you for 2s and explode on death dealing 5% of their max hp",
			[2] = "Killed enemies fight for you for 3s and explode on death dealing 6% of their max hp",
			[3] = "Killed enemies fight for you for 4s and explode on death dealing 7% of their max hp",
			[4] = "Killed enemies fight for you for 5s and explode on death dealing 8% of their max hp",
			[5] = "Killed enemies fight for you for 6s and explode on death dealing 9% of their max hp",
			[6] = "Killed enemies fight for you for 7s and explode on death dealing 10% of their max hp",
			[7] = "Killed enemies fight for you for 8s and explode on death dealing 11% of their max hp",
			[8] = "Killed enemies fight for you for 9s and explode on death dealing 12% of their max hp",
			[9] = "Killed enemies fight for you for 10s and explode on death dealing 13% of their max hp",
			[10] = "Killed enemies fight for you for 10s and explode on death dealing 14% of their max hp"
		}
	},
	[18] = {
		name = "Glass Cannon",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "glass cannon",
		descriptions = {
			[1] = "Deal 5% more damage, take 5% more damage",
			[2] = "Deal 8% more damage, take 8% more damage",
			[3] = "Deal 11% more damage, take 11% more damage",
			[4] = "Deal 14% more damage, take 14% more damage",
			[5] = "Deal 17% more damage, take 17% more damage",
			[6] = "Deal 20% more damage, take 20% more damage",
			[7] = "Deal 23% more damage, take 23% more damage",
			[8] = "Deal 26% more damage, take 26% more damage",
			[9] = "Deal 29% more damage, take 29% more damage",
			[10] = "Deal 32% more damage, take 32% more damage"
		}
	},
	[19] = {
		name = "Megalodon",
		rarity = "common",
		trigger = "onKill",
		cardFrame = "megalodon",
		descriptions = {
			[1] = "Kills have a 10% chance to cause nearby monsters to panic for 1 seconds",
			[2] = "Kills have a 15% chance to cause nearby monsters to panic for 1 seconds",
			[3] = "Kills have a 20% chance to cause nearby monsters to panic for 2 seconds",
			[4] = "Kills have a 25% chance to cause nearby monsters to panic for 2 seconds",
			[5] = "Kills have a 30% chance to cause nearby monsters to panic for 2 seconds",
			[6] = "Kills have a 35% chance to cause nearby monsters to panic for 2 seconds",
			[7] = "Kills have a 40% chance to cause nearby monsters to panic for 3 seconds",
			[8] = "Kills have a 45% chance to cause nearby monsters to panic for 3 seconds",
			[9] = "Kills have a 50% chance to cause nearby monsters to panic for 3 seconds",
			[10] = "Kills have a 55% chance to cause nearby monsters to panic for 3 seconds"
		}
	},
	[20] = {
		name = "The Hydra",
		rarity = "legendary",
		trigger = "onDamageTaken",
		cardFrame = "the hydra",
		descriptions = {
			[1] = "everytime you get hit you have a 1% chance to deal poison damage in a 3 square radius healing you by 1% of your max hp",
			[2] = "everytime you get hit you have a 2% chance to deal poison damage in a 3 square radius healing you by 2% of your max hp",
			[3] = "everytime you get hit you have a 3% chance to deal poison damage in a 3 square radius healing you by 3% of your max hp",
			[4] = "everytime you get hit you have a 4% chance to deal poison damage in a 3 square radius healing you by 4% of your max hp",
			[5] = "everytime you get hit you have a 5% chance to deal poison damage in a 3 square radius healing you by 5% of your max hp",
			[6] = "everytime you get hit you have a 6% chance to deal poison damage in a 3 square radius healing you by 6% of your max hp",
			[7] = "everytime you get hit you have a 7% chance to deal poison damage in a 3 square radius healing you by 7% of your max hp",
			[8] = "everytime you get hit you have a 8% chance to deal poison damage in a 3 square radius healing you by 8% of your max hp",
			[9] = "everytime you get hit you have a 9% chance to deal poison damage in a 3 square radius healing you by 9% of your max hp",
			[10] = "everytime you get hit you have a 10% chance to deal poison damage in a 3 square radius healing you by 10% of your max hp"
		}
	},
	[21] = {
		name = "The Hammersword",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "hammersword",
		descriptions = {
			[1] = "Each melee hit increases damage by 1% At max stacks, release a massive shockwave",
			[2] = "Each melee hit increases damage by 2% At max stacks, release a massive shockwave",
			[3] = "Each melee hit increases damage by 3% At max stacks, release a massive shockwave",
			[4] = "Each melee hit increases damage by 4% At max stacks, release a massive shockwave",
			[5] = "Each melee hit increases damage by 5% At max stacks, release a massive shockwave",
			[6] = "Each melee hit increases damage by 6% At max stacks, release a massive shockwave",
			[7] = "Each melee hit increases damage by 7% At max stacks, release a massive shockwave",
			[8] = "Each melee hit increases damage by 8% At max stacks, release a massive shockwave",
			[9] = "Each melee hit increases damage by 9% At max stacks, release a massive shockwave",
			[10] = "Each melee hit increases damage by 10% At max stacks, release a massive shockwave"
		}
	},
	[22] = {
		name = "Final Symphony",
		rarity = "epic",
		trigger = "onLowHP",
		cardFrame = "final symphony",
		descriptions = {
			[1] = "Below 20% HP, attacks release shockwaves",
			[2] = "Below 23% HP, attacks release shockwaves",
			[3] = "Below 26% HP, attacks release shockwaves",
			[4] = "Below 29% HP, attacks release shockwaves",
			[5] = "Below 32% HP, attacks release shockwaves",
			[6] = "Below 35% HP, attacks release shockwaves",
			[7] = "Below 38% HP, attacks release shockwaves",
			[8] = "Below 41% HP, attacks release shockwaves",
			[9] = "Below 44% HP, attacks release shockwaves",
			[10] = "Below 47% HP, attacks release shockwaves"
		}
	},
	[23] = {
		name = "Mechagolem",
		rarity = "common",
		trigger = "onDamageTaken",
		cardFrame = "mechagolem",
		descriptions = {
			[1] = "5% chance: reflect 5% damage taken as energy damage",
			[2] = "6% chance: reflect 6% damage taken as energy damage",
			[3] = "7% chance: reflect 7% damage taken as energy damage",
			[4] = "8% chance: reflect 8% damage taken as energy damage",
			[5] = "9% chance: reflect 9% damage taken as energy damage",
			[6] = "10% chance: reflect 10% damage taken as energy damage",
			[7] = "11% chance: reflect 11% damage taken as energy damage",
			[8] = "12% chance: reflect 12% damage taken as energy damage",
			[9] = "13% chance: reflect 13% damage taken as energy damage",
			[10] = "14% chance: reflect 14% damage taken as energy damage"
		}
	},
	[24] = {
		name = "The Slime",
		rarity = "epic",
		trigger = "onDamageTaken",
		cardFrame = "slime",
		descriptions = {
			[1] = "1% of damage taken converts to healing 1:0.3 ratio",
			[2] = "2% of damage taken converts to healing 1:0.3 ratio",
			[3] = "3% of damage taken converts to healing 1:0.3 ratio",
			[4] = "4% of damage taken converts to healing 1:0.3 ratio",
			[5] = "5% of damage taken converts to healing 1:0.3 ratio",
			[6] = "6% of damage taken converts to healing 1:0.3 ratio",
			[7] = "7% of damage taken converts to healing 1:0.3 ratio",
			[8] = "8% of damage taken converts to healing 1:0.3 ratio",
			[9] = "9% of damage taken converts to healing 1:0.3 ratio",
			[10] = "10% of damage taken converts to healing 1:0.3 ratio"
		}
	},
	[25] = {
		name = "The Child",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the child",
		descriptions = {
			[1] = "Gain 1% more experience from monsters",
			[2] = "Gain 2% more experience from monsters",
			[3] = "Gain 3% more experience from monsters",
			[4] = "Gain 4% more experience from monsters",
			[5] = "Gain 5% more experience from monsters",
			[6] = "Gain 6% more experience from monsters",
			[7] = "Gain 7% more experience from monsters",
			[8] = "Gain 8% more experience from monsters",
			[9] = "Gain 9% more experience from monsters",
			[10] = "Gain 10% more experience from monsters"
		}
	},
	[26] = {
		name = "Undine",
		rarity = "rare",
		trigger = "onHeal",
		cardFrame = "undine",
		descriptions = {
			[1] = "Heals have a 5% chance to double",
			[2] = "Heals have a 10% chance to double",
			[3] = "Heals have a 15% chance to double",
			[4] = "Heals have a 20% chance to double",
			[5] = "Heals have a 25% chance to double",
			[6] = "Heals have a 30% chance to double",
			[7] = "Heals have a 35% chance to double",
			[8] = "Heals have a 40% chance to double",
			[9] = "Heals have a 45% chance to double",
			[10] = "Heals have a 50% chance to double"
		}
	},
	[27] = {
		name = "The Elf",
		rarity = "common",
		trigger = "onHeal",
		cardFrame = "the elf",
		descriptions = {
			[1] = "Healing also restores mana 1% max mana",
			[2] = "Healing also restores mana 2% max mana",
			[3] = "Healing also restores mana 3% max mana",
			[4] = "Healing also restores mana 4% max mana",
			[5] = "Healing also restores mana 5% max mana",
			[6] = "Healing also restores mana 6% max mana",
			[7] = "Healing also restores mana 7% max mana",
			[8] = "Healing also restores mana 8% max mana",
			[9] = "Healing also restores mana 9% max mana",
			[10] = "Healing also restores mana 10% max mana"
		}
	},
	[28] = {
		name = "Archangel",
		rarity = "common",
		trigger = "onHeal",
		cardFrame = "archangel",
		descriptions = {
			[1] = "Healing allies smites nearby enemies for 5% of the healing amount",
			[2] = "Healing allies smites nearby enemies for 8% of the healing amount",
			[3] = "Healing allies smites nearby enemies for 10% of the healing amount",
			[4] = "Healing allies smites nearby enemies for 12% of the healing amount",
			[5] = "Healing allies smites nearby enemies for 14% of the healing amount",
			[6] = "Healing allies smites nearby enemies for 16% of the healing amount",
			[7] = "Healing allies smites nearby enemies for 18% of the healing amount",
			[8] = "Healing allies smites nearby enemies for 20% of the healing amount",
			[9] = "Healing allies smites nearby enemies for 22% of the healing amount",
			[10] = "Healing allies smites nearby enemies for 24% of the healing amount"
		}
	},
	[29] = {
		name = "Blood Link",
		rarity = "common",
		trigger = "onHeal",
		cardFrame = "blood link",
		descriptions = {
			[1] = "Healing will also heal a random nearby party member for 10% the healing amount",
			[2] = "Healing will also heal a random nearby party member for 15% the healing amount",
			[3] = "Healing will also heal a random nearby party member for 20% the healing amount",
			[4] = "Healing will also heal a random nearby party member for 25% the healing amount",
			[5] = "Healing will also heal a random nearby party member for 30% the healing amount",
			[6] = "Healing will also heal a random nearby party member for 35% the healing amount",
			[7] = "Healing will also heal a random nearby party member for 40% the healing amount",
			[8] = "Healing will also heal a random nearby party member for 45% the healing amount",
			[9] = "Healing will also heal a random nearby party member for 50% the healing amount",
			[10] = "Healing will also heal a random nearby party member for 55% the healing amount"
		}
	},
	[30] = {
		name = "The Naga",
		rarity = "epic",
		trigger = "onHeal",
		cardFrame = "the naga",
		descriptions = {
			[1] = "Healing poisons nearby enemies for 3 seconds dealing 5% of the healing amount per second",
			[2] = "Healing poisons nearby enemies for 3 seconds dealing 7% of the healing amount per second",
			[3] = "Healing poisons nearby enemies for 3 seconds dealing 9% of the healing amount per second",
			[4] = "Healing poisons nearby enemies for 3 seconds dealing 11% of the healing amount per second",
			[5] = "Healing poisons nearby enemies for 3 seconds dealing 13% of the healing amount per second",
			[6] = "Healing poisons nearby enemies for 3 seconds dealing 15% of the healing amount per second",
			[7] = "Healing poisons nearby enemies for 3 seconds dealing 17% of the healing amount per second",
			[8] = "Healing poisons nearby enemies for 3 seconds dealing 19% of the healing amount per second",
			[9] = "Healing poisons nearby enemies for 3 seconds dealing 21% of the healing amount per second",
			[10] = "Healing poisons nearby enemies for 3 seconds dealing 23% of the healing amount per second"
		}
	},
	[31] = {
		name = "The Dragon",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "the dragon",
		descriptions = {
			[1] = "Stack Furia de Dragón on hit. At 5 stacks, release a fire wave dealing 150% damage",
			[2] = "Stack Furia de Dragón on hit. At 5 stacks, release a fire wave dealing 175% damage",
			[3] = "Stack Furia de Dragón on hit. At 5 stacks, release a fire wave dealing 200% damage",
			[4] = "Stack Furia de Dragón on hit. At 5 stacks, release a fire wave dealing 225% damage",
			[5] = "Stack Furia de Dragón on hit. At 5 stacks, release a fire wave dealing 250% damage",
			[6] = "Stack Furia de Dragón on hit. At 5 stacks, release a fire wave dealing 275% damage",
			[7] = "Stack Furia de Dragón on hit. At 5 stacks, release a fire wave dealing 300% damage",
			[8] = "Stack Furia de Dragón on hit. At 5 stacks, release a fire wave dealing 325% damage",
			[9] = "Stack Furia de Dragón on hit. At 5 stacks, release a fire wave dealing 350% damage",
			[10] = "Stack Furia de Dragón on hit. At 5 stacks, release a fire wave dealing 400% damage"
		}
	},
	[32] = {
		name = "Pyromancer",
		rarity = "common",
		trigger = "onSpell",
		cardFrame = "pyromancer",
		descriptions = {
			[1] = "5% chance on spell cast to create fire fields that deal damage for 4 seconds",
			[2] = "6% chance on spell cast to create fire fields that deal damage for 4 seconds",
			[3] = "7% chance on spell cast to create fire fields that deal damage for 4 seconds",
			[4] = "8% chance on spell cast to create fire fields that deal damage for 4 seconds",
			[5] = "9% chance on spell cast to create fire fields that deal damage for 4 seconds",
			[6] = "10% chance on spell cast to create fire fields that deal damage for 4 seconds",
			[7] = "11% chance on spell cast to create fire fields that deal damage for 4 seconds",
			[8] = "12% chance on spell cast to create fire fields that deal damage for 4 seconds",
			[9] = "13% chance on spell cast to create fire fields that deal damage for 4 seconds",
			[10] = "15% chance on spell cast to create fire fields that deal damage for 4 seconds"
		}
	},
	[33] = {
		name = "Dragon Lord",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "dragon lord",
		descriptions = {
			[1] = "For each dragon card: +1% crit, +3% HP, +3% MP, +1% damage",
			[2] = "For each dragon card: +2% crit, +4% HP, +4% MP, +2% damage",
			[3] = "For each dragon card: +3% crit, +5% HP, +5% MP, +3% damage",
			[4] = "For each dragon card: +4% crit, +6% HP, +6% MP, +4% damage",
			[5] = "For each dragon card: +5% crit, +7% HP, +7% MP, +5% damage",
			[6] = "For each dragon card: +6% crit, +8% HP, +8% MP, +6% damage",
			[7] = "For each dragon card: +7% crit, +9% HP, +9% MP, +7% damage",
			[8] = "For each dragon card: +8% crit, +10% HP, +10% MP, +8% damage",
			[9] = "For each dragon card: +9% crit, +11% HP, +11% MP, +9% damage",
			[10] = "For each dragon card: +10% crit, +12% HP, +12% MP, +10% damage"
		}
	},
	[34] = {
		name = "Essence Reaver",
		rarity = "common",
		trigger = "passive",
		cardFrame = "essence reaver",
		descriptions = {
			[1] = "+5% chance to obtain essences from monsters and elite variations",
			[2] = "+7% chance to obtain essences from monsters and elite variations",
			[3] = "+9% chance to obtain essences from monsters and elite variations",
			[4] = "+11% chance to obtain essences from monsters and elite variations",
			[5] = "+13% chance to obtain essences from monsters and elite variations",
			[6] = "+15% chance to obtain essences from monsters and elite variations",
			[7] = "+18% chance to obtain essences from monsters and elite variations",
			[8] = "+21% chance to obtain essences from monsters and elite variations",
			[9] = "+24% chance to obtain essences from monsters and elite variations",
			[10] = "+28% chance to obtain essences from monsters and elite variations"
		}
	},
	[35] = {
		name = "Frost Dragon",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "frost dragon",
		descriptions = {
			[1] = "6% chance to deal 20% ice damage and slow the enemy",
			[2] = "8% chance to deal 25% ice damage and slow the enemy",
			[3] = "10% chance to deal 30% ice damage and slow the enemy",
			[4] = "12% chance to deal 35% ice damage and slow the enemy",
			[5] = "14% chance to deal 40% ice damage and slow the enemy",
			[6] = "16% chance to deal 45% ice damage and slow the enemy",
			[7] = "18% chance to deal 50% ice damage and slow the enemy",
			[8] = "20% chance to deal 55% ice damage and slow the enemy",
			[9] = "23% chance to deal 60% ice damage and slow the enemy",
			[10] = "26% chance to deal 70% ice damage and slow the enemy"
		}
	},
	[36] = {
		name = "Blossom Dragon",
		rarity = "epic",
		trigger = "onHealingSpell",
		cardFrame = "blossom dragon",
		descriptions = {
			[1] = "Every 4th healing spell: 3x3 nature damage (80%) + heal 5% max HP",
			[2] = "Every 4th healing spell: 3x3 nature damage (90%) + heal 6% max HP",
			[3] = "Every 4th healing spell: 3x3 nature damage (100%) + heal 7% max HP",
			[4] = "Every 4th healing spell: 3x3 nature damage (110%) + heal 8% max HP",
			[5] = "Every 4th healing spell: 3x3 nature damage (120%) + heal 9% max HP",
			[6] = "Every 4th healing spell: 3x3 nature damage (130%) + heal 10% max HP",
			[7] = "Every 4th healing spell: 3x3 nature damage (140%) + heal 11% max HP",
			[8] = "Every 4th healing spell: 3x3 nature damage (150%) + heal 12% max HP",
			[9] = "Every 4th healing spell: 3x3 nature damage (160%) + heal 13% max HP",
			[10] = "Every 4th healing spell: 3x3 nature damage (180%) + heal 15% max HP"
		}
	},
	[37] = {
		name = "Scorpion",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "scorpion",
		descriptions = {
			[1] = "Attacks have a 20% chance to poison for 50% damage per second (5s)",
			[2] = "Attacks have a 20% chance to poison for 60% damage per second (5s)",
			[3] = "Attacks have a 20% chance to poison for 70% damage per second (5s)",
			[4] = "Attacks have a 20% chance to poison for 80% damage per second (5s)",
			[5] = "Attacks have a 20% chance to poison for 90% damage per second (5s)",
			[6] = "Attacks have a 20% chance to poison for 100% damage per second (5s)",
			[7] = "Attacks have a 20% chance to poison for 110% damage per second (5s)",
			[8] = "Attacks have a 20% chance to poison for 120% damage per second (5s)",
			[9] = "Attacks have a 20% chance to poison for 130% damage per second (5s)",
			[10] = "Attacks have a 20% chance to poison for 140% damage per second (5s)"
		}
	},
	[38] = {
		name = "The Viper",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "the viper",
		descriptions = {
			[1] = "Earth/poison damage now bites the target dealing poison damage dealing player level (0.22) per card level",
			[2] = "Earth/poison damage now bites the target dealing poison damage dealing player level (0.22) per card level",
			[3] = "Earth/poison damage now bites the target dealing poison damage dealing player level (0.22) per card level",
			[4] = "Earth/poison damage now bites the target dealing poison damage dealing player level (0.22) per card level",
			[5] = "Earth/poison damage now bites the target dealing poison damage dealing player level (0.22) per card level",
			[6] = "Earth/poison damage now bites the target dealing poison damage dealing player level (0.22) per card level",
			[7] = "Earth/poison damage now bites the target dealing poison damage dealing player level (0.22) per card level",
			[8] = "Earth/poison damage now bites the target dealing poison damage dealing player level (0.22) per card level",
			[9] = "Earth/poison damage now bites the target dealing poison damage dealing player level (0.22) per card level",
			[10] = "Earth/poison damage now bites the target dealing poison damage dealing player level (0.22) per card level"
		}
	},
	[39] = {
		name = "Zeus",
		rarity = "common",
		trigger = "onSpell",
		cardFrame = "zeus",
		descriptions = {
			[1] = "Every 10th spell: lightning strikes all nearby enemies dealing 120% damage",
			[2] = "Every 10th spell: lightning strikes all nearby enemies dealing 135% damage",
			[3] = "Every 10th spell: lightning strikes all nearby enemies dealing 150% damage",
			[4] = "Every 10th spell: lightning strikes all nearby enemies dealing 165% damage",
			[5] = "Every 10th spell: lightning strikes all nearby enemies dealing 180% damage",
			[6] = "Every 10th spell: lightning strikes all nearby enemies dealing 200% damage",
			[7] = "Every 10th spell: lightning strikes all nearby enemies dealing 220% damage",
			[8] = "Every 10th spell: lightning strikes all nearby enemies dealing 240% damage",
			[9] = "Every 10th spell: lightning strikes all nearby enemies dealing 260% damage",
			[10] = "Every 10th spell: lightning strikes all nearby enemies dealing 300% damage"
		}
	},
	[40] = {
		name = "Svarog",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "svarog",
		descriptions = {
			[1] = "Each kill: +3% fire damage (max 3 stacks, lost after 10 no kill)",
			[2] = "Each kill: +3.5% fire damage (max 3 stacks, lost after 10 no kill)",
			[3] = "Each kill: +4% fire damage (max 3 stacks, lost after 10 no kill)",
			[4] = "Each kill: +4.5% fire damage (max 4 stacks, lost after 10 no kill)",
			[5] = "Each kill: +5% fire damage (max 4 stacks, lost after 10 no kill)",
			[6] = "Each kill: +5.5% fire damage (max 4 stacks, lost after 10 no kill)",
			[7] = "Each kill: +6% fire damage (max 4 stacks, lost after 10 no kill)", 
			[8] = "Each kill: +6.5% fire damage (max 4 stacks, lost after 10 no kill)",
			[9] = "Each kill: +7% fire damage (max 4 stacks, lost after 10 no kill)",
			[10] = "Each kill: +7.5% fire damage (max 5 stacks, lost after 10 no kill)"
		}
	},
	[41] = {
		name = "Veles",
		rarity = "epic",
		trigger = "onHit",
		cardFrame = "veles",
		descriptions = {
			[1] = "8% chance on earth damage to create earth spikes in a line",
			[2] = "10% chance on earth damage to create earth spikes in a line",
			[3] = "12% chance on earth damage to create earth spikes in a line",
			[4] = "14% chance on earth damage to create earth spikes in a line",
			[5] = "16% chance on earth damage to create earth spikes in a line",
			[6] = "18% chance on earth damage to create earth spikes in a line",
			[7] = "20% chance on earth damage to create earth spikes in a line",
			[8] = "23% chance on earth damage to create earth spikes in a line",
			[9] = "26% chance on earth damage to create earth spikes in a line",
			[10] = "30% chance on earth damage to create earth spikes in a line"
		}
	},
	[42] = {
		name = "Yacy",
		rarity = "epic",
		trigger = "onHealingSpell",
		cardFrame = "yacy",
		descriptions = {
			[1] = "Healing spells deal 10% AoE damage, damage spells heal for 5% AoE",
			[2] = "Healing spells deal 12% AoE damage, damage spells heal for 6% AoE",
			[3] = "Healing spells deal 14% AoE damage, damage spells heal for 7% AoE",
			[4] = "Healing spells deal 16% AoE damage, damage spells heal for 8% AoE",
			[5] = "Healing spells deal 18% AoE damage, damage spells heal for 9% AoE",
			[6] = "Healing spells deal 20% AoE damage, damage spells heal for 10% AoE",
			[7] = "Healing spells deal 23% AoE damage, damage spells heal for 11% AoE",
			[8] = "Healing spells deal 26% AoE damage, damage spells heal for 12% AoE",
			[9] = "Healing spells deal 30% AoE damage, damage spells heal for 13% AoE",
			[10] = "Healing spells deal 35% AoE damage, damage spells heal for 15% AoE"
		}
	},
	[43] = {
		name = "Quetzalcoatl",
		rarity = "legendary",
		trigger = "onCrit",
		cardFrame = "quetzalcoatl",
		descriptions = {
			[1] = "Critical hits launch 1 missiles to nearby enemies (2 Seconds cooldown)",
			[2] = "Critical hits launch 2 missiles to nearby enemies (2 Seconds cooldown)",
			[3] = "Critical hits launch 3 missiles to nearby enemies (2 Seconds cooldown)",
			[4] = "Critical hits launch 4 missiles to nearby enemies (2 Seconds cooldown)",
			[5] = "Critical hits launch 5 missiles to nearby enemies (2 Seconds cooldown)",
			[6] = "Critical hits launch 6 missiles to nearby enemies (2 Seconds cooldown)",
			[7] = "Critical hits launch 7 missiles to nearby enemies (2 Seconds cooldown)",
			[8] = "Critical hits launch 8 missiles to nearby enemies (2 Seconds cooldown)",
			[9] = "Critical hits launch 9 missiles to nearby enemies (2 Seconds cooldown)",
			[10] = "Critical hits launch 10 missiles to nearby enemies (2 Seconds cooldown)"
		}
	},
	[44] = {
		name = "The Obelisk",
		rarity = "common",
		trigger = "onStandStill",
		cardFrame = "the obelisk",
		descriptions = {
			[1] = "Standing still for 3 seconds reduces physical damage taken by 8%",
			[2] = "Standing still for 3 seconds reduces physical damage taken by 10%",
			[3] = "Standing still for 3 seconds reduces physical damage taken by 12%",
			[4] = "Standing still for 3 seconds reduces physical damage taken by 14%",
			[5] = "Standing still for 3 seconds reduces physical damage taken by 16%",
			[6] = "Standing still for 3 seconds reduces physical damage taken by 18%",
			[7] = "Standing still for 3 seconds reduces physical damage taken by 20%",
			[8] = "Standing still for 3 seconds reduces physical damage taken by 23%",
			[9] = "Standing still for 3 seconds reduces physical damage taken by 26%",
			[10] = "Standing still for 3 seconds reduces physical damage taken by 30%"
		}
	},
	[45] = {
		name = "The Bull",
		rarity = "common",
		trigger = "onDash",
		cardFrame = "the bull",
		descriptions = {
			[1] = "your dash or teleport spells creates an earthquake trail dealing 120% of your level as earth damage",
			[2] = "your dash or teleport spells creates an earthquake trail dealing 135% of your level as earth damage",
			[3] = "your dash or teleport spells creates an earthquake trail dealing 150% of your level as earth damage",
			[4] = "your dash or teleport spells creates an earthquake trail dealing 165% of your level as earth damage",
			[5] = "your dash or teleport spells creates an earthquake trail dealing 180% of your level as earth damage",
			[6] = "your dash or teleport spells creates an earthquake trail dealing 200% of your level as earth damage",
			[7] = "your dash or teleport spells creates an earthquake trail dealing 220% of your level as earth damage",
			[8] = "your dash or teleport spells creates an earthquake trail dealing 240% of your level as earth damage",
			[9] = "your dash or teleport spells creates an earthquake trail dealing 260% of your level as earth damage",
			[10] = "your dash or teleport spells creates an earthquake trail dealing 300% of your level as earth damage"
		}
	},
	[46] = {
		name = "The Dwarf",
		rarity = "common",
		trigger = "onDamageTaken",
		cardFrame = "the dwarf",
		descriptions = {
			[1] = "When HP drops below 40%, heal 15% max HP and gain speed for 5 secs (1 min cooldown)",
			[2] = "When HP drops below 40%, heal 20% max HP and gain speed for 5 secs (1 min cooldown)",
			[3] = "When HP drops below 40%, heal 25% max HP and gain speed for 5 secs (1 min cooldown)",
			[4] = "When HP drops below 40%, heal 30% max HP and gain speed for 5 secs (1 min cooldown)",
			[5] = "When HP drops below 40%, heal 35% max HP and gain speed for 5 secs (1 min cooldown)",
			[6] = "When HP drops below 40%, heal 40% max HP and gain speed for 5 secs (1 min cooldown)",
			[7] = "When HP drops below 40%, heal 45% max HP and gain speed for 5 secs (1 min cooldown)",
			[8] = "When HP drops below 40%, heal 50% max HP and gain speed for 5 secs (1 min cooldown)",
			[9] = "When HP drops below 40%, heal 55% max HP and gain speed for 5 secs (1 min cooldown)",
			[10] = "When HP drops below 40%, heal 60% max HP and gain speed for 5 secs (1 min cooldown)"
		}
	},
	[47] = {
		name = "The Skeleton",
		rarity = "common",
		trigger = "onDamageTaken",
		cardFrame = "the skeleton",
		descriptions = {
			[1] = "3% chance to reduce physical damage to 1 (15s cooldown)",
			[2] = "4% chance to reduce physical damage to 1 (15s cooldown)",
			[3] = "5% chance to reduce physical damage to 1 (15s cooldown)",
			[4] = "6% chance to reduce physical damage to 1 (15s cooldown)",
			[5] = "7% chance to reduce physical damage to 1 (15s cooldown)",
			[6] = "8% chance to reduce physical damage to 1 (15s cooldown)",
			[7] = "9% chance to reduce physical damage to 1 (15s cooldown)",
			[8] = "10% chance to reduce physical damage to 1 (15s cooldown)",
			[9] = "12% chance to reduce physical damage to 1 (15s cooldown)",
			[10] = "15% chance to reduce physical damage to 1 (15s cooldown)"
		}
	},
	[48] = {
		name = "The Soldier",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the soldier",
		descriptions = {
			[1] = "+10 shielding skill, +5% crit chance",
			[2] = "+15 shielding skill, +6% crit chance",
			[3] = "+20 shielding skill, +7% crit chance",
			[4] = "+25 shielding skill, +8% crit chance",
			[5] = "+30 shielding skill, +9% crit chance",
			[6] = "+35 shielding skill, +10% crit chance",
			[7] = "+40 shielding skill, +11% crit chance",
			[8] = "+45 shielding skill, +12% crit chance",
			[9] = "+50 shielding skill, +13% crit chance",
			[10] = "+60 shielding skill, +15% crit chance"
		}
	},
	[49] = {
		name = "The Sargent",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "the sargent",
		descriptions = {
			[1] = "-3% party exp penalty. On kill: party heals 1% HP/Mana. this effect can only be applied once per party",
			[2] = "-6% party exp penalty. On kill: party heals 1.5% HP/Mana. this effect can only be applied once per party",
			[3] = "-9% party exp penalty. On kill: party heals 2% HP/Mana. this effect can only be applied once per party",
			[4] = "-12% party exp penalty. On kill: party heals 2.5% HP/Mana. this effect can only be applied once per party",
			[5] = "-15% party exp penalty. On kill: party heals 3% HP/Mana. this effect can only be applied once per party",
			[6] = "-18% party exp penalty. On kill: party heals 3.5% HP/Mana. this effect can only be applied once per party",
			[7] = "-21% party exp penalty. On kill: party heals 4% HP/Mana. this effect can only be applied once per party",
			[8] = "-24% party exp penalty. On kill: party heals 4.5% HP/Mana. this effect can only be applied once per party",
			[9] = "-27% party exp penalty. On kill: party heals 5% HP/Mana. this effect can only be applied once per party",
			[10] = "-30% party exp penalty. On kill: party heals 5.5% HP/Mana. this effect can only be applied once per party"
		}
	},
	[50] = {
		name = "Cyborg",
		rarity = "epic",
		trigger = "onDamageTaken",
		cardFrame = "cyborg",
		descriptions = {
			[1] = "Melee attacks have 1% chance to fire energy laser in your direction",
			[2] = "Melee attacks have 1.2% chance to fire energy laser in your direction",
			[3] = "Melee attacks have 1.4% chance to fire energy laser in your direction",
			[4] = "Melee attacks have 1.6% chance to fire energy laser in your direction",
			[5] = "Melee attacks have 1.8% chance to fire energy laser in your direction",
			[6] = "Melee attacks have 2% chance to fire energy laser in your direction",
			[7] = "Melee attacks have 2.2% chance to fire energy laser in your direction",
			[8] = "Melee attacks have 2.4% chance to fire energy laser in your direction",
			[9] = "Melee attacks have 2.6% chance to fire energy laser in your direction",
			[10] = "Melee attacks have 3% chance to fire energy laser in your direction"
		}
	},
	[51] = {
		name = "Mecha T-Rex",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "mecha t-rex",
		descriptions = {
			[1] = "Melee attacks deal area damage, scaling with robot/jurassic cards (+10% per card)",
			[2] = "Melee attacks deal area damage, scaling with robot/jurassic cards (+12% per card)",
			[3] = "Melee attacks deal area damage, scaling with robot/jurassic cards (+14% per card)",
			[4] = "Melee attacks deal area damage, scaling with robot/jurassic cards (+16% per card)",
			[5] = "Melee attacks deal area damage, scaling with robot/jurassic cards (+18% per card)",
			[6] = "Melee attacks deal area damage, scaling with robot/jurassic cards (+20% per card)",
			[7] = "Melee attacks deal area damage, scaling with robot/jurassic cards (+23% per card)",
			[8] = "Melee attacks deal area damage, scaling with robot/jurassic cards (+26% per card)",
			[9] = "Melee attacks deal area damage, scaling with robot/jurassic cards (+30% per card)",
			[10] = "Melee attacks deal area damage, scaling with robot/jurassic cards (+35% per card)"
		}
	},
	[52] = {
		name = "Twisted Mecha",
		rarity = "rare",
		trigger = "onDamageTaken",
		cardFrame = "twisted mecha",
		descriptions = {
			[1] = "+30% energy received damage. Every 10 spells: chain lightning",
			[2] = "+25% energy received damage. Every 10 spells: chain lightning",
			[3] = "+20% energy received damage. Every 10 spells: chain lightning",
			[4] = "+18% energy received damage. Every 10 spells: chain lightning",
			[5] = "+16% energy received damage. Every 10 spells: chain lightning",
			[6] = "+14% energy received damage. Every 10 spells: chain lightning",
			[7] = "+12% energy received damage. Every 10 spells: chain lightning",
			[8] = "+10% energy received damage. Every 10 spells: chain lightning",
			[9] = "+8% energy received damage. Every 10 spells: chain lightning",
			[10] = "+6% energy received damage. Every 10 spells: chain lightning"
		}
	},
	[53] = {
		name = "Bad Circuit",
		rarity = "common",
		trigger = "onDamageTaken",
		cardFrame = "bad circuit",
		descriptions = {
			[1] = "4% chance to become immune for 1.5s when taking damage (12s cooldown)",
			[2] = "5% chance to become immune for 1.5s when taking damage (12s cooldown)",
			[3] = "6% chance to become immune for 1.5s when taking damage (12s cooldown)",
			[4] = "7% chance to become immune for 1.5s when taking damage (12s cooldown)",
			[5] = "8% chance to become immune for 1.5s when taking damage (12s cooldown)",
			[6] = "9% chance to become immune for 1.5s when taking damage (12s cooldown)",
			[7] = "10% chance to become immune for 1.5s when taking damage (12s cooldown)",
			[8] = "11% chance to become immune for 1.5s when taking damage (12s cooldown)",
			[9] = "13% chance to become immune for 1.5s when taking damage (12s cooldown)",
			[10] = "15% chance to become immune for 1.5s when taking damage (12s cooldown)"
		}
	},
	[54] = {
		name = "The Opportunist",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "the opportunist",
		descriptions = {
			[1] = "+8% damage against targets with 90% HP or more",
			[2] = "+10% damage against targets with 90% HP or more",
			[3] = "+12% damage against targets with 90% HP or more",
			[4] = "+14% damage against targets with 90% HP or more",
			[5] = "+16% damage against targets with 90% HP or more",
			[6] = "+18% damage against targets with 90% HP or more",
			[7] = "+20% damage against targets with 90% HP or more",
			[8] = "+23% damage against targets with 90% HP or more",
			[9] = "+26% damage against targets with 90% HP or more",
			[10] = "+30% damage against targets with 90% HP or more"
		}
	},
	[55] = {
		name = "Raiju",
		rarity = "epic",
		trigger = "onHit",
		cardFrame = "raiju",
		descriptions = {
			[1] = "Every 12 energy attacks, chain lightning to 3 enemies for 80% damage (5s cooldown)",
			[2] = "Every 11 energy attacks, chain lightning to 3 enemies for 90% damage (5s cooldown)",
			[3] = "Every 10 energy attacks, chain lightning to 3 enemies for 100% damage (5s cooldown)",
			[4] = "Every 9 energy attacks, chain lightning to 3 enemies for 110% damage (5s cooldown)",
			[5] = "Every 8 energy attacks, chain lightning to 3 enemies for 120% damage (5s cooldown)",
			[6] = "Every 7 energy attacks, chain lightning to 3 enemies for 130% damage (5s cooldown)",
			[7] = "Every 6 energy attacks, chain lightning to 3 enemies for 140% damage (5s cooldown)",
			[8] = "Every 5 energy attacks, chain lightning to 3 enemies for 150% damage (5s cooldown)",
			[9] = "Every 4 energy attacks, chain lightning to 3 enemies for 160% damage (5s cooldown)",
			[10] = "Every 3 energy attacks, chain lightning to 3 enemies for 180% damage (5s cooldown)"
		}
	},
	[56] = {
		name = "The Fairy",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "the fairy",
		descriptions = {
			[1] = "+8% movement speed, +5% dodge chance",
			[2] = "+10% movement speed, +6% dodge chance",
			[3] = "+12% movement speed, +7% dodge chance",
			[4] = "+14% movement speed, +8% dodge chance",
			[5] = "+16% movement speed, +9% dodge chance",
			[6] = "+18% movement speed, +10% dodge chance",
			[7] = "+20% movement speed, +11% dodge chance",
			[8] = "+23% movement speed, +12% dodge chance",
			[9] = "+26% movement speed, +14% dodge chance",
			[10] = "+30% movement speed, +16% dodge chance"
		}
	},
	[57] = {
		name = "Centaur",
		rarity = "common",
		trigger = "passive",
		cardFrame = "centaur",
		descriptions = {
			[1] = "+5% movement speed, +5% attack speed",
			[2] = "+6% movement speed, +6% attack speed",
			[3] = "+7% movement speed, +7% attack speed",
			[4] = "+8% movement speed, +8% attack speed",
			[5] = "+9% movement speed, +9% attack speed",
			[6] = "+10% movement speed, +10% attack speed",
			[7] = "+11% movement speed, +11% attack speed",
			[8] = "+12% movement speed, +12% attack speed",
			[9] = "+14% movement speed, +14% attack speed",
			[10] = "+16% movement speed, +16% attack speed"
		}
	},
	[58] = {
		name = "Lone Wolf",
		rarity = "epic",
		trigger = "onKill",
		cardFrame = "dire wolf",
		descriptions = {
			[1] = "When solo: kills heal 3% HP/Mana and grant +2% exp",
			[2] = "When solo: kills heal 3.5% HP/Mana and grant +2.5% exp",
			[3] = "When solo: kills heal 4% HP/Mana and grant +3% exp",
			[4] = "When solo: kills heal 4.5% HP/Mana and grant +3.5% exp",
			[5] = "When solo: kills heal 5% HP/Mana and grant +4% exp",
			[6] = "When solo: kills heal 5.5% HP/Mana and grant +4.5% exp",
			[7] = "When solo: kills heal 6% HP/Mana and grant +5% exp",
			[8] = "When solo: kills heal 6.5% HP/Mana and grant +5.5% exp",
			[9] = "When solo: kills heal 7% HP/Mana and grant +6% exp",
			[10] = "When solo: kills heal 7.5% HP/Mana and grant +6.5% exp"
		}
	},
	[59] = {
		name = "The Greed",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the greed",
		descriptions = {
			[1] = "When in party: gain +8% of allies' experience",
			[2] = "When in party: gain +11% of allies' experience",
			[3] = "When in party: gain +14% of allies' experience",
			[4] = "When in party: gain +17% of allies' experience",
			[5] = "When in party: gain +20% of allies' experience",
			[6] = "When in party: gain +23% of allies' experience",
			[7] = "When in party: gain +26% of allies' experience",
			[8] = "When in party: gain +30% of allies' experience",
			[9] = "When in party: gain +35% of allies' experience",
			[10] = "When in party: gain +40% of allies' experience"
		}
	},
	[60] = {
		name = "Barry the Hunter",
		rarity = "common",
		trigger = "passive",
		cardFrame = "barry the hunter",
		descriptions = {
			[1] = "+1% distance skill per 700 max HP",
			[2] = "+1.5% distance skill per 700 max HP",
			[3] = "+2% distance skill per 700 max HP",
			[4] = "+2.5% distance skill per 700 max HP",
			[5] = "+3% distance skill per 700 max HP",
			[6] = "+3.5% distance skill per 700 max HP",
			[7] = "+4% distance skill per 700 max HP",
			[8] = "+4.5% distance skill per 700 max HP",
			[9] = "+5% distance skill per 700 max HP",
			[10] = "+6% distance skill per 700 max HP"
		}
	},
	[61] = {
		name = "The Apprentice",
		rarity = "common",
		trigger = "onKill",
		cardFrame = "the apprentice",
		descriptions = {
			[1] = "3% chance to gain 1 codex knowledge on kill",
			[2] = "3.1% chance to gain 2 codex knowledge on kill",
			[3] = "3.2% chance to gain 3 codex knowledge on kill",
			[4] = "3.3% chance to gain 4 codex knowledge on kill",
			[5] = "3.4% chance to gain 5 codex knowledge on kill",
			[6] = "3.5% chance to gain 6 codex knowledge on kill",
			[7] = "3.6% chance to gain 7 codex knowledge on kill",
			[8] = "3.7% chance to gain 8 codex knowledge on kill",
			[9] = "3.8% chance to gain 9 codex knowledge on kill",
			[10] = "4.2% chance to gain 11 codex knowledge on kill"
		}
	},
	[62] = {
		name = "Envy",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "envy",
		descriptions = {
			[1] = "When ally kills: 8% chance to gain 8% of their random skill",
			[2] = "When ally kills: 10% chance to gain 10% of their random skill",
			[3] = "When ally kills: 12% chance to gain 12% of their random skill",
			[4] = "When ally kills: 14% chance to gain 14% of their random skill",
			[5] = "When ally kills: 16% chance to gain 16% of their random skill",
			[6] = "When ally kills: 18% chance to gain 18% of their random skill",
			[7] = "When ally kills: 20% chance to gain 20% of their random skill",
			[8] = "When ally kills: 23% chance to gain 23% of their random skill",
			[9] = "When ally kills: 26% chance to gain 26% of their random skill",
			[10] = "When ally kills: 30% chance to gain 30% of their random skill"
		}
	},
	[63] = {
		name = "The Magician",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the magician",
		descriptions = {
			[1] = "+2 magic level",
			[2] = "+3 magic level",
			[3] = "+4 magic level",
			[4] = "+5 magic level",
			[5] = "+6 magic level",
			[6] = "+7 magic level",
			[7] = "+8 magic level",
			[8] = "+9 magic level",
			[9] = "+10 magic level",
			[10] = "+12 magic level"
		}
	},
	[64] = {
		name = "The Druid",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the druid",
		descriptions = {
			[1] = "+2% max mana per active card in deck",
			[2] = "+3% max mana per active card in deck",
			[3] = "+4% max mana per active card in deck",
			[4] = "+5% max mana per active card in deck",
			[5] = "+6% max mana per active card in deck",
			[6] = "+7% max mana per active card in deck",
			[7] = "+8% max mana per active card in deck",
			[8] = "+9% max mana per active card in deck",
			[9] = "+10% max mana per active card in deck",
			[10] = "+12% max mana per active card in deck"
		}
	},
	[65] = {
		name = "Magic Cannon",
		rarity = "epic",
		trigger = "onAttackSpell",
		cardFrame = "magic cannon",
		descriptions = {
			[1] = "Offensive spells: reduce CD by 150ms per tile distance",
			[2] = "Offensive spells: reduce CD by 165ms per tile distance",
			[3] = "Offensive spells: reduce CD by 180ms per tile distance",
			[4] = "Offensive spells: reduce CD by 195ms per tile distance",
			[5] = "Offensive spells: reduce CD by 210ms per tile distance",
			[6] = "Offensive spells: reduce CD by 225ms per tile distance",
			[7] = "Offensive spells: reduce CD by 240ms per tile distance",
			[8] = "Offensive spells: reduce CD by 255ms per tile distance",
			[9] = "Offensive spells: reduce CD by 270ms per tile distance",
			[10] = "Offensive spells: reduce CD by 285ms per tile distance"
		}
	},
	[66] = {
		name = "The Sage",
		rarity = "common",
		trigger = "passive",
		cardFrame = "the sage",
		descriptions = {
			[1] = "gain +30% max mana from your total maximum health",
			[2] = "gain +40% max mana from your total maximum health",
			[3] = "gain +50% max mana from your total maximum health",
			[4] = "gain +60% max mana from your total maximum health",
			[5] = "gain +70% max mana from your total maximum health",
			[6] = "gain +80% max mana from your total maximum health",
			[7] = "gain +90% max mana from your total maximum health",
			[8] = "gain +100% max mana from your total maximum health",
			[9] = "gain +110% max mana from your total maximum health",
			[10] = "gain +120% max mana from your total maximum health"
		}
	},
	[67] = {
		name = "The Elixir",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "the elixir",
		descriptions = {
			[1] = "+5% potion healing",
			[2] = "+7% potion healing",
			[3] = "+9% potion healing",
			[4] = "+11% potion healing",
			[5] = "+13% potion healing",
			[6] = "+15% potion healing",
			[7] = "+17% potion healing",
			[8] = "+19% potion healing",
			[9] = "+22% potion healing",
			[10] = "+25% potion healing"
		}
	},
	[68] = {
		name = "The Pulse",
		rarity = "rare",
		trigger = "onStandStill",
		cardFrame = "the pulse",
		descriptions = {
			[1] = "Stand still: Holy AoE damage every 3s (2x2) - 60 base damage",
			[2] = "Stand still: Holy AoE damage every 3s (2x2) - 70 base damage",
			[3] = "Stand still: Holy AoE damage every 3s (2x2) - 80 base damage",
			[4] = "Stand still: Holy AoE damage every 3s (2x2) - 90 base damage",
			[5] = "Stand still: Holy AoE damage every 3s (2x2) - 100 base damage",
			[6] = "Stand still: Holy AoE damage every 3s (2x2) - 110 base damage",
			[7] = "Stand still: Holy AoE damage every 3s (2x2) - 120 base damage",
			[8] = "Stand still: Holy AoE damage every 3s (2x2) - 130 base damage",
			[9] = "Stand still: Holy AoE damage every 3s (2x2) - 140 base damage",
			[10] = "Stand still: Holy AoE damage every 3s (2x2) - 160 base damage"
		}
	},
	[69] = {
		name = "Cannibal",
		rarity = "common",
		trigger = "onKill",
		cardFrame = "cannibal",
		descriptions = {
			[1] = "On kill: +8% crit for 5min. Player kill: 5% chance full heal",
			[2] = "On kill: +10% crit for 5min. Player kill: 6% chance full heal",
			[3] = "On kill: +12% crit for 5min. Player kill: 7% chance full heal",
			[4] = "On kill: +14% crit for 5min. Player kill: 8% chance full heal",
			[5] = "On kill: +16% crit for 5min. Player kill: 9% chance full heal",
			[6] = "On kill: +18% crit for 5min. Player kill: 10% chance full heal",
			[7] = "On kill: +20% crit for 5min. Player kill: 11% chance full heal",
			[8] = "On kill: +23% crit for 5min. Player kill: 12% chance full heal",
			[9] = "On kill: +26% crit for 5min. Player kill: 13% chance full heal",
			[10] = "On kill: +30% crit for 5min. Player kill: 15% chance full heal"
		}
	},
	[70] = {
		name = "The Vampire",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "the vampire",
		descriptions = {
			[1] = "+2% life leech, 5% chance Bite (heal x2)",
			[2] = "+3% life leech, 7% chance Bite (heal x2)",
			[3] = "+4% life leech, 9% chance Bite (heal x2)",
			[4] = "+5% life leech, 11% chance Bite (heal x2)",
			[5] = "+6% life leech, 13% chance Bite (heal x2)",
			[6] = "+7% life leech, 15% chance Bite (heal x2)",
			[7] = "+8% life leech, 18% chance Bite (heal x2)",
			[8] = "+10% life leech, 21% chance Bite (heal x2)",
			[9] = "+12% life leech, 24% chance Bite (heal x2)",
			[10] = "+15% life leech, 28% chance Bite (heal x2)"
		}
	},
	[71] = {
		name = "Triforce",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "triforce",
		descriptions = {
			[1] = "+2 sword, distance, and magic level",
			[2] = "+3 sword, distance, and magic level",
			[3] = "+4 sword, distance, and magic level",
			[4] = "+5 sword, distance, and magic level",
			[5] = "+6 sword, distance, and magic level",
			[6] = "+7 sword, distance, and magic level",
			[7] = "+8 sword, distance, and magic level",
			[8] = "+9 sword, distance, and magic level",
			[9] = "+10 sword, distance, and magic level",
			[10] = "+12 sword, distance, and magic level"
		}
	},
	[72] = {
		name = "Superior",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "superior",
		descriptions = {
			[1] = "+10% to all skills",
			[2] = "+11% to all skills",
			[3] = "+12% to all skills",
			[4] = "+13% to all skills",
			[5] = "+14% to all skills",
			[6] = "+15% to all skills",
			[7] = "+16% to all skills",
			[8] = "+17% to all skills",
			[9] = "+18% to all skills",
			[10] = "+22% to all skills"
		}
	},
	[73] = {
		name = "Vengance",
		rarity = "rare",
		trigger = "onDamageTaken",
		cardFrame = "vengance",
		descriptions = {
			[1] = "On hit taken: +4% damage per stack (max 20), lasts 5s",
			[2] = "On hit taken: +5% damage per stack (max 20), lasts 5s",
			[3] = "On hit taken: +6% damage per stack (max 20), lasts 5s",
			[4] = "On hit taken: +7% damage per stack (max 20), lasts 5s",
			[5] = "On hit taken: +8% damage per stack (max 20), lasts 5s",
			[6] = "On hit taken: +9% damage per stack (max 20), lasts 5s",
			[7] = "On hit taken: +10% damage per stack (max 20), lasts 5s",
			[8] = "On hit taken: +11% damage per stack (max 20), lasts 5s",
			[9] = "On hit taken: +13% damage per stack (max 20), lasts 5s",
			[10] = "On hit taken: +15% damage per stack (max 20), lasts 5s"
		}
	},
	[74] = {
		name = "Snowball",
		rarity = "common",
		trigger = "onKill",
		cardFrame = "snowball",
		descriptions = {
			[1] = "On kill: 30% chance frost explosion (lvl x1 to x1.5 dmg, 3x3). Always gain +0.1% ice dmg per kill. Area: 5x5 at 80, 7x7 at 160 stacks (max 100). Reset on death",
			[2] = "On kill: 35% chance frost explosion (lvl x2 to x3 dmg, 3x3). Always gain +0.2% ice dmg per kill. Area: 5x5 at 80, 7x7 at 160 stacks (max 110). Reset on death",
			[3] = "On kill: 40% chance frost explosion (lvl x3 to x4.5 dmg, 3x3). Always gain +0.3% ice dmg per kill. Area: 5x5 at 80, 7x7 at 160 stacks (max 120). Reset on death",
			[4] = "On kill: 45% chance frost explosion (lvl x4 to x6 dmg, 3x3). Always gain +0.4% ice dmg per kill. Area: 5x5 at 85, 7x7 at 170 stacks (max 130). Reset on death",
			[5] = "On kill: 50% chance frost explosion (lvl x5 to x7.5 dmg, 3x3). Always gain +0.5% ice dmg per kill. Area: 5x5 at 90, 7x7 at 180 stacks (max 140). Reset on death",
			[6] = "On kill: 55% chance frost explosion (lvl x6 to x9 dmg, 3x3). Always gain +0.6% ice dmg per kill. Area: 5x5 at 95, 7x7 at 190 stacks (max 150). Reset on death",
			[7] = "On kill: 60% chance frost explosion (lvl x7 to x10.5 dmg, 3x3). Always gain +0.7% ice dmg per kill. Area: 5x5 at 100, 7x7 at 200 stacks (max 160). Reset on death",
			[8] = "On kill: 65% chance frost explosion (lvl x8 to x12 dmg, 3x3). Always gain +0.8% ice dmg per kill. Area: 5x5 at 100, 7x7 at 200 stacks (max 170). Reset on death",
			[9] = "On kill: 70% chance frost explosion (lvl x9 to x13.5 dmg, 3x3). Always gain +0.9% ice dmg per kill. Area: 5x5 at 100, 7x7 at 200 stacks (max 180). Reset on death",
			[10] = "On kill: 80% chance frost explosion (lvl x10 to x15 dmg, 3x3). Always gain +1% ice dmg per kill. Area: 5x5 at 100, 7x7 at 200 stacks (max 200). Reset on death"
		}
	},
	[75] = {
		name = "Union",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "union",
		descriptions = {
			[1] = "+2% HP/Mana per unique vocation in party",
			[2] = "+3% HP/Mana per unique vocation in party",
			[3] = "+4% HP/Mana per unique vocation in party",
			[4] = "+5% HP/Mana per unique vocation in party",
			[5] = "+6% HP/Mana per unique vocation in party",
			[6] = "+7% HP/Mana per unique vocation in party",
			[7] = "+8% HP/Mana per unique vocation in party",
			[8] = "+9% HP/Mana per unique vocation in party",
			[9] = "+10% HP/Mana per unique vocation in party",
			[10] = "+12% HP/Mana per unique vocation in party"
		}
	},
	[76] = {
		name = "All for One",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "all for one",
		descriptions = {
			[1] = "+1% all skills per nearby party member",
			[2] = "+2% all skills per nearby party member",
			[3] = "+3% all skills per nearby party member",
			[4] = "+4% all skills per nearby party member",
			[5] = "+5% all skills per nearby party member",
			[6] = "+6% all skills per nearby party member",
			[7] = "+7% all skills per nearby party member",
			[8] = "+8% all skills per nearby party member",
			[9] = "+9% all skills per nearby party member",
			[10] = "+10% all skills per nearby party member"
		}
	},
	[77] = {
		name = "The Minotaur",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "the minotaur",
		descriptions = {
			[1] = "Melee attacks: +120% physical damage based on shielding skill",
			[2] = "Melee attacks: +135% physical damage based on shielding skill",
			[3] = "Melee attacks: +150% physical damage based on shielding skill",
			[4] = "Melee attacks: +165% physical damage based on shielding skill",
			[5] = "Melee attacks: +180% physical damage based on shielding skill",
			[6] = "Melee attacks: +200% physical damage based on shielding skill",
			[7] = "Melee attacks: +220% physical damage based on shielding skill",
			[8] = "Melee attacks: +240% physical damage based on shielding skill",
			[9] = "Melee attacks: +260% physical damage based on shielding skill",
			[10] = "Melee attacks: +300% physical damage based on shielding skill"
		}
	},
	[78] = {
		name = "The Griffin",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "the griffin",
		descriptions = {
			[1] = "gain +2% movement speed, Physical attacks: deal more damage based on movement speed",
			[2] = "gain +4% movement speed, Physical attacks: deal more damage based on movement speed",
			[3] = "gain +6% movement speed, Physical attacks: deal more damage based on movement speed",
			[4] = "gain +8% movement speed, Physical attacks: deal more damage based on movement speed",
			[5] = "gain +10% movement speed, Physical attacks: deal more damage based on movement speed",
			[6] = "gain +12% movement speed, Physical attacks: deal more damage based on movement speed",
			[7] = "gain +14% movement speed, Physical attacks: deal more damage based on movement speed",
			[8] = "gain +16% movement speed, Physical attacks: deal more damage based on movement speed",
			[9] = "gain +18% movement speed, Physical attacks: deal more damage based on movement speed",
			[10] = "gain +20% movement speed, Physical attacks: deal more damage based on movement speed"
		}
	},
	[79] = {
		name = "Giant Slayer",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "giant slayer",
		descriptions = {
			[1] = "Damage scales with HP difference vs target (max +16.5%)",
			[2] = "Damage scales with HP difference vs target (max +18%)",
			[3] = "Damage scales with HP difference vs target (max +19.5%)",
			[4] = "Damage scales with HP difference vs target (max +21%)",
			[5] = "Damage scales with HP difference vs target (max +22.5%)",
			[6] = "Damage scales with HP difference vs target (max +24%)",
			[7] = "Damage scales with HP difference vs target (max +25.5%)",
			[8] = "Damage scales with HP difference vs target (max +27%)",
			[9] = "Damage scales with HP difference vs target (max +28.5%)",
			[10] = "Damage scales with HP difference vs target (max +30%)"
		}
	},
	[80] = {
		name = "Chainless",
		rarity = "epic",
		trigger = "onSpell",
		cardFrame = "chainless",
		descriptions = {
			[1] = "Different spells in a row: 4th spell gets +30% damage",
			[2] = "Different spells in a row: 4th spell gets +33% damage",
			[3] = "Different spells in a row: 4th spell gets +36% damage",
			[4] = "Different spells in a row: 4th spell gets +39% damage",
			[5] = "Different spells in a row: 4th spell gets +42% damage",
			[6] = "Different spells in a row: 4th spell gets +45% damage",
			[7] = "Different spells in a row: 4th spell gets +48% damage",
			[8] = "Different spells in a row: 4th spell gets +51% damage",
			[9] = "Different spells in a row: 4th spell gets +54% damage",
			[10] = "Different spells in a row: 4th spell gets +60% damage"
		}
	},
	[81] = {
		name = "Leviathan",
		rarity = "rare",
		trigger = "onStandStill",
		cardFrame = "leviathan",
		descriptions = {
			[1] = "Stand still 6s: +10% damage for 3s",
			[2] = "Stand still 6s: +12% damage for 3s",
			[3] = "Stand still 6s: +14% damage for 3s",
			[4] = "Stand still 6s: +16% damage for 3s",
			[5] = "Stand still 6s: +18% damage for 3s",
			[6] = "Stand still 6s: +20% damage for 3s",
			[7] = "Stand still 6s: +23% damage for 3s",
			[8] = "Stand still 6s: +26% damage for 3s",
			[9] = "Stand still 6s: +30% damage for 3s",
			[10] = "Stand still 6s: +35% damage for 3s"
		}
	},
	[82] = {
		name = "Nautilus",
		rarity = "rare",
		trigger = "passive",
		cardFrame = "nautilus",
		descriptions = {
			[1] = "Every 6s: +30% max HP shield, -50% movement speed",
			[2] = "Every 6s: +35% max HP shield, -50% movement speed",
			[3] = "Every 6s: +40% max HP shield, -50% movement speed",
			[4] = "Every 6s: +45% max HP shield, -50% movement speed",
			[5] = "Every 6s: +50% max HP shield, -50% movement speed",
			[6] = "Every 6s: +55% max HP shield, -50% movement speed",
			[7] = "Every 6s: +60% max HP shield, -50% movement speed",
			[8] = "Every 6s: +65% max HP shield, -50% movement speed",
			[9] = "Every 6s: +70% max HP shield, -50% movement speed",
			[10] = "Every 6s: +75% max HP shield, -50% movement speed"
		}
	},
	[83] = {
		name = "Shielded to the teeth",
		rarity = "rare",
		trigger = "onShield",
		cardFrame = "armored to the teeth",
		descriptions = {
			[1] = "Gain shield: +10% block chance for 5s",
			[2] = "Gain shield: +12% block chance for 5s",
			[3] = "Gain shield: +14% block chance for 5s",
			[4] = "Gain shield: +16% block chance for 5s",
			[5] = "Gain shield: +18% block chance for 5s",
			[6] = "Gain shield: +20% block chance for 5s",
			[7] = "Gain shield: +23% block chance for 5s",
			[8] = "Gain shield: +26% block chance for 5s",
			[9] = "Gain shield: +30% block chance for 5s",
			[10] = "Gain shield: +35% block chance for 5s"
		}
	},
	[84] = {
		name = "The Pope",
		rarity = "common",
		trigger = "onShieldDamage",
		cardFrame = "thepope",
		descriptions = {
			[1] = "Shield absorbs damage: heal 10% of absorbed damage",
			[2] = "Shield absorbs damage: heal 12% of absorbed damage",
			[3] = "Shield absorbs damage: heal 14% of absorbed damage",
			[4] = "Shield absorbs damage: heal 16% of absorbed damage",
			[5] = "Shield absorbs damage: heal 18% of absorbed damage",
			[6] = "Shield absorbs damage: heal 20% of absorbed damage",
			[7] = "Shield absorbs damage: heal 23% of absorbed damage",
			[8] = "Shield absorbs damage: heal 26% of absorbed damage",
			[9] = "Shield absorbs damage: heal 30% of absorbed damage",
			[10] = "Shield absorbs damage: heal 35% of absorbed damage"
		}
	},
	[85] = {
		name = "Wrecking Ball",
		rarity = "common",
		trigger = "onDash",
		cardFrame = "wreckingball",
		descriptions = {
			[1] = "Dash: +10% max HP shield",
			[2] = "Dash: +12% max HP shield",
			[3] = "Dash: +14% max HP shield",
			[4] = "Dash: +16% max HP shield",
			[5] = "Dash: +18% max HP shield",
			[6] = "Dash: +20% max HP shield",
			[7] = "Dash: +23% max HP shield",
			[8] = "Dash: +26% max HP shield",
			[9] = "Dash: +30% max HP shield",
			[10] = "Dash: +35% max HP shield"
		}
	},
	[86] = {
		name = "Bubble Gun",
		rarity = "epic",
		trigger = "onCrit",
		cardFrame = "bubbles gun",
		descriptions = {
			[1] = "Critical hit: +30% crit damage as shield",
			[2] = "Critical hit: +33% crit damage as shield",
			[3] = "Critical hit: +36% crit damage as shield",
			[4] = "Critical hit: +39% crit damage as shield",
			[5] = "Critical hit: +42% crit damage as shield",
			[6] = "Critical hit: +45% crit damage as shield",
			[7] = "Critical hit: +48% crit damage as shield",
			[8] = "Critical hit: +51% crit damage as shield",
			[9] = "Critical hit: +54% crit damage as shield",
			[10] = "Critical hit: +57% crit damage as shield"
		}
	},
	[87] = {
		name = "The Dancer",
		rarity = "epic",
		trigger = "passive",
		cardFrame = "the dancer",
		descriptions = {
			[1] = "+10% crit. Crit: gain 1% dodge chance for 3 seconds. Dodge: gain 1% critical chance for 3 seconds",
			[2] = "+10% crit. Crit: gain 2% dodge chance for 3 seconds. Dodge: gain 2% critical chance for 3 seconds",
			[3] = "+10% crit. Crit: gain 3% dodge chance for 3 seconds. Dodge: gain 3% critical chance for 3 seconds",
			[4] = "+10% crit. Crit: gain 4% dodge chance for 3 seconds. Dodge: gain 4% critical chance for 3 seconds",
			[5] = "+10% crit. Crit: gain 5% dodge chance for 3 seconds. Dodge: gain 5% critical chance for 3 seconds",
			[6] = "+10% crit. Crit: gain 6% dodge chance for 3 seconds. Dodge: gain 6% critical chance for 3 seconds",
			[7] = "+10% crit. Crit: gain 7% dodge chance for 3 seconds. Dodge: gain 7% critical chance for 3 seconds",
			[8] = "+10% crit. Crit: gain 8% dodge chance for 3 seconds. Dodge: gain 8% critical chance for 3 seconds",
			[9] = "+10% crit. Crit: gain 9% dodge chance for 3 seconds. Dodge: gain 9% critical chance for 3 seconds",
			[10] = "+10% crit. Crit: gain 10% dodge chance for 3 seconds. Dodge: gain 10% critical chance for 3 seconds"
		}
	},
	[88] = {
		name = "Demonic Pact",
		rarity = "epic",
		trigger = "onKill",
		cardFrame = "demonic pact",
		descriptions = {
			[1] = "Kill: summons gain shield 10% max HP for 5s",
			[2] = "Kill: summons gain shield 12% max HP for 5s",
			[3] = "Kill: summons gain shield 14% max HP for 5s",
			[4] = "Kill: summons gain shield 16% max HP for 5s",
			[5] = "Kill: summons gain shield 18% max HP for 5s",
			[6] = "Kill: summons gain shield 20% max HP for 5s",
			[7] = "Kill: summons gain shield 23% max HP for 5s",
			[8] = "Kill: summons gain shield 26% max HP for 5s",
			[9] = "Kill: summons gain shield 30% max HP for 5s",
			[10] = "Kill: summons gain shield 35% max HP for 5s"
		}
	},
	[89] = {
		name = "Gaia",
		rarity = "legendary",
		trigger = "passive",
		cardFrame = "gaia",
		descriptions = {
			[1] = "+10% healing. Heals grant shield 10% of heal amount for 5s",
			[2] = "+12% healing. Heals grant shield 12% of heal amount for 5s",
			[3] = "+14% healing. Heals grant shield 14% of heal amount for 5s",
			[4] = "+16% healing. Heals grant shield 16% of heal amount for 5s",
			[5] = "+18% healing. Heals grant shield 18% of heal amount for 5s",
			[6] = "+20% healing. Heals grant shield 20% of heal amount for 5s",
			[7] = "+22% healing. Heals grant shield 23% of heal amount for 5s",
			[8] = "+24% healing. Heals grant shield 26% of heal amount for 5s",
			[9] = "+26% healing. Heals grant shield 30% of heal amount for 5s",
			[10] = "+30% healing. Heals grant shield 35% of heal amount for 5s"
		}
	},
	[90] = {
		name = "Kiss of Heavens",
		rarity = "rare",
		trigger = "onDefensiveSpell",
		cardFrame = "kiss of heavens",
		descriptions = {
			[1] = "Defensive spell: 12% chance heal 5% max HP + stun enemies 3s",
			[2] = "Defensive spell: 14% chance heal 6% max HP + stun enemies 3s",
			[3] = "Defensive spell: 16% chance heal 7% max HP + stun enemies 3s",
			[4] = "Defensive spell: 18% chance heal 8% max HP + stun enemies 3s",
			[5] = "Defensive spell: 20% chance heal 9% max HP + stun enemies 3s",
			[6] = "Defensive spell: 23% chance heal 10% max HP + stun enemies 3s",
			[7] = "Defensive spell: 26% chance heal 11% max HP + stun enemies 3s",
			[8] = "Defensive spell: 30% chance heal 12% max HP + stun enemies 3s",
			[9] = "Defensive spell: 35% chance heal 14% max HP + stun enemies 3s",
			[10] = "Defensive spell: 40% chance heal 16% max HP + stun enemies 3s"
		}
	},

	-- Card 91: Crazy to Shoot (onBowAttack & onWandAttack + onCrit)
	[91] = {
		name = "Crazy to Shoot",
		rarity = "epic",	
		trigger = "onCrit",
		cardFrame = "crazy to shoot",
		descriptions = {
			[1] = "Distance attacks: 12% chance +1% crit (max 10%). Crits: 12% chance +1% attack speed (max 10%)",
			[2] = "Distance attacks: 14% chance +1% crit (max 12%). Crits: 14% chance +1% attack speed (max 12%)",
			[3] = "Distance attacks: 16% chance +1% crit (max 14%). Crits: 16% chance +1% attack speed (max 14%)",
			[4] = "Distance attacks: 18% chance +1% crit (max 16%). Crits: 18% chance +1% attack speed (max 16%)",
			[5] = "Distance attacks: 20% chance +1% crit (max 18%). Crits: 20% chance +1% attack speed (max 18%)",
			[6] = "Distance attacks: 23% chance +1% crit (max 20%). Crits: 23% chance +1% attack speed (max 20%)",
			[7] = "Distance attacks: 26% chance +1% crit (max 23%). Crits: 26% chance +1% attack speed (max 23%)",
			[8] = "Distance attacks: 30% chance +1% crit (max 26%). Crits: 30% chance +1% attack speed (max 26%)",
			[9] = "Distance attacks: 35% chance +1% crit (max 30%). Crits: 35% chance +1% attack speed (max 30%)",
			[10] = "Distance attacks: 40% chance +1% crit (max 35%). Crits: 40% chance +1% attack speed (max 35%)"
		}
	},

	-- Card 92: Blood Pool (onHit - melee only, handled by unified_passives.lua)
	[92] = {
		name = "Blood Pool",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "blood pool",	
		descriptions = {
			[1] = "Melee hits: 12% chance +5% attack speed & life leech for 5s (5s cooldown)",
			[2] = "Melee hits: 14% chance +6% attack speed & life leech for 5s (5s cooldown)",
			[3] = "Melee hits: 16% chance +7% attack speed & life leech for 5s (5s cooldown)",
			[4] = "Melee hits: 18% chance +8% attack speed & life leech for 5s (5s cooldown)",
			[5] = "Melee hits: 20% chance +9% attack speed & life leech for 5s (5s cooldown)",
			[6] = "Melee hits: 23% chance +10% attack speed & life leech for 5s (5s cooldown)",
			[7] = "Melee hits: 26% chance +11% attack speed & life leech for 5s (5s cooldown)",
			[8] = "Melee hits: 30% chance +12% attack speed & life leech for 5s (5s cooldown)",
			[9] = "Melee hits: 35% chance +14% attack speed & life leech for 5s (5s cooldown)",
			[10] = "Melee hits: 40% chance +16% attack speed & life leech for 5s (5s cooldown)"
		},
	},

	-- Card 93: Bullet Rain (onBowAttack/onWandAttack - AoE damage scaled by attack speed)
	[93] = {
		name = "Bullet Rain",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "bullet rain",
		descriptions = {
			[1] = "Ranged attacks: 12% chance for 2x2 AoE (30% + 0.5% per attack speed%)",
			[2] = "Ranged attacks: 14% chance for 2x2 AoE (30% + 0.5% per attack speed%)",
			[3] = "Ranged attacks: 16% chance for 2x2 AoE (30% + 0.5% per attack speed%)",
			[4] = "Ranged attacks: 18% chance for 2x2 AoE (30% + 0.5% per attack speed%)",
			[5] = "Ranged attacks: 20% chance for 2x2 AoE (30% + 0.5% per attack speed%)",
			[6] = "Ranged attacks: 23% chance for 2x2 AoE (30% + 0.5% per attack speed%)",
			[7] = "Ranged attacks: 26% chance for 2x2 AoE (30% + 0.5% per attack speed%)",
			[8] = "Ranged attacks: 30% chance for 2x2 AoE (30% + 0.5% per attack speed%)",
			[9] = "Ranged attacks: 35% chance for 2x2 AoE (30% + 0.5% per attack speed%)",
			[10] = "Ranged attacks: 40% chance for 2x2 AoE (30% + 0.5% per attack speed%)"
		}
	},

	-- Card 94: Sniper (onBowAttack/onWandAttack - missile damage scaled by distance)
	[94] = {
		name = "Sniper",
		rarity = "rare",
		trigger = "onHit",
		cardFrame = "sniper",
		descriptions = {
			[1] = "Ranged attacks: 15% chance for missile (playerLevel * 0.30 * tiles)",
			[2] = "Ranged attacks: 17% chance for missile (playerLevel * 0.35 * tiles)",
			[3] = "Ranged attacks: 19% chance for missile (playerLevel * 0.40 * tiles)",
			[4] = "Ranged attacks: 21% chance for missile (playerLevel * 0.45 * tiles)",
			[5] = "Ranged attacks: 23% chance for missile (playerLevel * 0.50 * tiles)",
			[6] = "Ranged attacks: 25% chance for missile (playerLevel * 0.55 * tiles)",
			[7] = "Ranged attacks: 27% chance for missile (playerLevel * 0.60 * tiles)",
			[8] = "Ranged attacks: 29% chance for missile (playerLevel * 0.65 * tiles)",
			[9] = "Ranged attacks: 31% chance for missile (playerLevel * 0.70 * tiles)",
			[10] = "Ranged attacks: 33% chance for missile (playerLevel * 0.75 * tiles)"
		}
	},

	-- Card 95: Doom (onAttack - death damage triggers crit + death damage buff)
	[95] = {
		name = "Doom",
		rarity = "epic",
		trigger = "onHit",
		cardFrame = "doom",
		descriptions = {
			[1] = "Death damage: 15% chance for buff (+2% crit, +10% death dmg, 5s)",
			[2] = "Death damage: 17% chance for buff (+3% crit, +12% death dmg, 5s)",
			[3] = "Death damage: 19% chance for buff (+4% crit, +14% death dmg, 5s)",
			[4] = "Death damage: 21% chance for buff (+5% crit, +16% death dmg, 5s)",
			[5] = "Death damage: 23% chance for buff (+6% crit, +18% death dmg, 5s)",
			[6] = "Death damage: 25% chance for buff (+7% crit, +20% death dmg, 5s)",
			[7] = "Death damage: 27% chance for buff (+8% crit, +23% death dmg, 5s)",
			[8] = "Death damage: 29% chance for buff (+9% crit, +26% death dmg, 5s)",
			[9] = "Death damage: 31% chance for buff (+10% crit, +30% death dmg, 5s)",
			[10] = "Death damage: 33% chance for buff (+12% crit, +35% death dmg, 5s)"
		}
	},

	-- Card 96: Candle of Atonement (Passive bonuses + holy damage shield)
	[96] = {
		name = "Candle of Atonement",
		rarity = "common",
		trigger = "passive",
		cardFrame = "candleofattonenment",
		descriptions = {
			[1] = "+10% healing, +10% shielding. Holy dmg: shield = 10% dmg (2s, 10s CD)",
			[2] = "+12% healing, +12% shielding. Holy dmg: shield = 12% dmg (2s, 10s CD)",
			[3] = "+14% healing, +14% shielding. Holy dmg: shield = 14% dmg (2s, 10s CD)",
			[4] = "+16% healing, +16% shielding. Holy dmg: shield = 16% dmg (2s, 10s CD)",
			[5] = "+18% healing, +18% shielding. Holy dmg: shield = 18% dmg (2s, 10s CD)",
			[6] = "+20% healing, +20% shielding. Holy dmg: shield = 20% dmg (2s, 10s CD)",
			[7] = "+23% healing, +23% shielding. Holy dmg: shield = 23% dmg (2s, 10s CD)",
			[8] = "+26% healing, +26% shielding. Holy dmg: shield = 26% dmg (2s, 10s CD)",
			[9] = "+30% healing, +30% shielding. Holy dmg: shield = 30% dmg (2s, 10s CD)",
			[10] = "+35% healing, +35% shielding. Holy dmg: shield = 35% dmg (2s, 10s CD)"
		}
	},

	-- Card 97: Dark Commander (onDeath - summon death causes AoE damage)
	[97] = {
		name = "Dark Commander",
		rarity = "common",
		trigger = "passive",
		cardFrame = "dark commander",
		descriptions = {
			[1] = "Summon death: AoE damage = 10% of summon max HP",
			[2] = "Summon death: AoE damage = 12% of summon max HP",
			[3] = "Summon death: AoE damage = 14% of summon max HP",
			[4] = "Summon death: AoE damage = 16% of summon max HP",
			[5] = "Summon death: AoE damage = 18% of summon max HP",
			[6] = "Summon death: AoE damage = 20% of summon max HP",
			[7] = "Summon death: AoE damage = 23% of summon max HP",
			[8] = "Summon death: AoE damage = 26% of summon max HP",
			[9] = "Summon death: AoE damage = 30% of summon max HP",
			[10] = "Summon death: AoE damage = 35% of summon max HP"
		}
	},

	-- Card 98: The Hero (onKill - gain fame points)
	[98] = {
		name = "The Hero",
		rarity = "common",
		trigger = "onKill",
		cardFrame = "the hero",
		descriptions = {
			[1] = "Kill monsters lv 2+: +10% fame points",
			[2] = "Kill monsters lv 2+: +12% fame points",
			[3] = "Kill monsters lv 2+: +14% fame points",
			[4] = "Kill monsters lv 2+: +16% fame points",
			[5] = "Kill monsters lv 2+: +18% fame points",
			[6] = "Kill monsters lv 2+: +20% fame points",
			[7] = "Kill monsters lv 2+: +23% fame points",
			[8] = "Kill monsters lv 2+: +26% fame points",
			[9] = "Kill monsters lv 2+: +30% fame points",
			[10] = "Kill monsters lv 2+: +35% fame points"
		}
	},

	-- Card 99: Fire Circus (onSpell - orbital fire rings)
	[99] = {
		name = "Fire Circus",
		rarity = "rare",
		trigger = "onAttackSpell",
		cardFrame = "fire circus",
		descriptions = {
			[1] = "Attack spells: 12% chance for 5 fire rings (20% dmg each, 6s)",
			[2] = "Attack spells: 14% chance for 5 fire rings (25% dmg each, 6s)",
			[3] = "Attack spells: 16% chance for 5 fire rings (30% dmg each, 6s)",
			[4] = "Attack spells: 18% chance for 5 fire rings (35% dmg each, 6s)",
			[5] = "Attack spells: 20% chance for 5 fire rings (40% dmg each, 6s)",
			[6] = "Attack spells: 23% chance for 5 fire rings (45% dmg each, 6s)",
			[7] = "Attack spells: 26% chance for 5 fire rings (50% dmg each, 6s)",
			[8] = "Attack spells: 30% chance for 5 fire rings (55% dmg each, 6s)",
			[9] = "Attack spells: 35% chance for 5 fire rings (60% dmg each, 6s)",
			[10] = "Attack spells: 40% chance for 5 fire rings (70% dmg each, 6s)"
		}
	},

	-- Card 100: Carnival (onKill - explosive balloon summon)
	[100] = {
		name = "Carnival",
		rarity = "legendary",
		trigger = "onKill",
		cardFrame = "carnival",
		descriptions = {
			[1] = "+1 Magic level, Kill: 15% chance to spawn balloon scaling with magic level + (50% dmg AoE, 3s)",
			[2] = "+2 Magic level, Kill: 18% chance to spawn balloon scaling with magic level + (60% dmg AoE, 3s)",
			[3] = "+3 Magic level, Kill: 21% chance to spawn balloon scaling with magic level + (70% dmg AoE, 3s)",
			[4] = "+4 Magic level, Kill: 24% chance to spawn balloon scaling with magic level + (80% dmg AoE, 3s)",
			[5] = "+5 Magic level, Kill: 27% chance to spawn balloon scaling with magic level + (90% dmg AoE, 3s)",
			[6] = "+6 Magic level, Kill: 30% chance to spawn balloon scaling with magic level + (100% dmg AoE, 3s)",
			[7] = "+7 Magic level, Kill: 33% chance to spawn balloon scaling with magic level + (110% dmg AoE, 3s)",
			[8] = "+8 Magic level, Kill: 36% chance to spawn balloon scaling with magic level + (120% dmg AoE, 3s)",
			[9] = "+9 Magic level, Kill: 40% chance to spawn balloon scaling with magic level + (130% dmg AoE, 3s)",
			[10] = "+10 Magic level, Kill: 45% chance to spawn balloon scaling with magic level + (150% dmg AoE, 3s)"
		}
	},

	-- Card 101: The Clown (onAttack - clones throwing pies)
	[101] = {
		name = "The Clown",
		rarity = "rare",
		trigger = "onAttackSpell",
		cardFrame = "clown",
		descriptions = {
			[1] = "Attack: 5% chance to spawn 1 clone throwing pies",
			[2] = "Attack: 7% chance to spawn 1 clone throwing pies",
			[3] = "Attack: 9% chance to spawn 2 clones throwing pies",
			[4] = "Attack: 11% chance to spawn 2 clones throwing pies",
			[5] = "Attack: 13% chance to spawn 3 clones throwing pies",
			[6] = "Attack: 15% chance to spawn 3 clones throwing pies",
			[7] = "Attack: 17% chance to spawn 4 clones throwing pies",
			[8] = "Attack: 19% chance to spawn 4 clones throwing pies",
			[9] = "Attack: 22% chance to spawn 5 clones throwing pies",
			[10] = "Attack: 25% chance to spawn 6 clones throwing pies"
		}
	},

	-- Card 102: Dark Monk (onAttack - death damage buff)
	[102] = {
		name = "Dark Monk",
		rarity = "common",
		trigger = "onHit",
		cardFrame = "dark monk",
		descriptions = {
			[1] = "Physical damage: 1% chance to gain +1 death damage for 10s",
			[2] = "Physical damage: 2% chance to gain +2 death damage for 10s",
			[3] = "Physical damage: 3% chance to gain +3 death damage for 10s",
			[4] = "Physical damage: 4% chance to gain +4 death damage for 10s",
			[5] = "Physical damage: 5% chance to gain +5 death damage for 10s",
			[6] = "Physical damage: 6% chance to gain +6 death damage for 10s",
			[7] = "Physical damage: 7% chance to gain +7 death damage for 10s",
			[8] = "Physical damage: 8% chance to gain +8 death damage for 10s",
			[9] = "Physical damage: 9% chance to gain +9 death damage for 10s",
			[10] = "Physical damage: 10% chance to gain +10 death damage for 10s"
		}
	},

	-- Card 103: The Priest (onHeal - holy charges for spell damage boost)
	[103] = {
		name = "The Priest",
		rarity = "legendary",
		trigger = "onHeal",
		cardFrame = "the priest",
		descriptions = {
			[1] = "Heals generate holy charges. At 3 charges: next spell +15% damage",
			[2] = "Heals generate holy charges. At 3 charges: next spell +18% damage",
			[3] = "Heals generate holy charges. At 3 charges: next spell +21% damage",
			[4] = "Heals generate holy charges. At 3 charges: next spell +24% damage",
			[5] = "Heals generate holy charges. At 3 charges: next spell +27% damage",
			[6] = "Heals generate holy charges. At 3 charges: next spell +30% damage",
			[7] = "Heals generate holy charges. At 3 charges: next spell +33% damage",
			[8] = "Heals generate holy charges. At 3 charges: next spell +36% damage",
			[9] = "Heals generate holy charges. At 3 charges: next spell +42% damage",
			[10] = "Heals generate holy charges. At 3 charges: next spell +48% damage"
		}
	},

	-- Card 104: Backtoashes (onKill - death missiles to nearby enemies)
	[104] = {
		name = "Backtoashes",
		rarity = "rare",
		trigger = "onKill",
		cardFrame = "backtoashes",
		descriptions = {
			[1] = "On kill: 5% chance to launch 2 death missiles to enemies in 4x4",
			[2] = "On kill: 6% chance to launch 2 death missiles to enemies in 4x4",
			[3] = "On kill: 7% chance to launch 3 death missiles to enemies in 4x4",
			[4] = "On kill: 8% chance to launch 3 death missiles to enemies in 4x4",
			[5] = "On kill: 9% chance to launch 4 death missiles to enemies in 4x4",
			[6] = "On kill: 10% chance to launch 4 death missiles to enemies in 4x4",
			[7] = "On kill: 11% chance to launch 5 death missiles to enemies in 4x4",
			[8] = "On kill: 12% chance to launch 5 death missiles to enemies in 4x4",
			[9] = "On kill: 14% chance to launch 6 death missiles to enemies in 4x4",
			[10] = "On kill: 16% chance to launch 6 death missiles to enemies in 4x4"
		}
	}
}
