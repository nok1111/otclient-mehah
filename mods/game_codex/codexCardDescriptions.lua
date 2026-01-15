
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
			[1] = "gain +1% magic damage for every 1000 max mana points",
			[2] = "gain +2% magic damage for every 1000 max mana points",
			[3] = "gain +3% magic damage for every 1000 max mana points",
			[4] = "gain +4% magic damage for every 1000 max mana points",
			[5] = "gain +5% magic damage for every 1000 max mana points",
			[6] = "gain +6% magic damage for every 1000 max mana points",
			[7] = "gain +7% magic damage for every 1000 max mana points",
			[8] = "gain +8% magic damage for every 1000 max mana points",
			[9] = "gain +9% magic damage for every 1000 max mana points",
			[10] = "gain +10% magic damage for every 1000 max mana points"
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
			[1] = "Dealing damage with a bow or crossbow has a chance 5% to trigger a bullet barrage",
			[2] = "Dealing damage with a bow or crossbow has a chance 6% to trigger a bullet barrage",
			[3] = "Dealing damage with a bow or crossbow has a chance 8% to trigger a bullet barrage",
			[4] = "Dealing damage with a bow or crossbow has a chance 10% to trigger a bullet barrage",
			[5] = "Dealing damage with a bow or crossbow has a chance 12% to trigger a bullet barrage",
			[6] = "Dealing damage with a bow or crossbow has a chance 14% to trigger a bullet barrage",
			[7] = "Dealing damage with a bow or crossbow has a chance 16% to trigger a bullet barrage",
			[8] = "Dealing damage with a bow or crossbow has a chance 18% to trigger a bullet barrage",
			[9] = "Dealing damage with a bow or crossbow has a chance 20% to trigger a bullet barrage",
			[10] = "Dealing damage with a bow or crossbow has a chance 25% to trigger a bullet barrage"
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
			[1] = "Spend 2% HP on cast to deal 2% extra damage",
			[2] = "Spend 3% HP on cast to deal 4% extra damage",
			[3] = "Spend 4% HP on cast to deal 8% extra damage",
			[4] = "Spend 5% HP on cast to deal 12% extra damage",
			[5] = "Spend 6% HP on cast to deal 16% extra damage",
			[6] = "Spend 7% HP on cast to deal 18% extra damage",
			[7] = "Spend 8% HP on cast to deal 20% extra damage",
			[8] = "Spend 9% HP on cast to deal 22% extra damage",
			[9] = "Spend 10% HP on cast to deal 24% extra damage",
			[10] = "Spend 10% HP on cast to deal 25% extra damage"
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
	}
}
