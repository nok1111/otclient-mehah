
MapTravel = {}
MapTravel.unlockedNodes = {}
MapTravel.currentNodeNameId = nil
MapTravel.devMode = false


MapTravel.mapScale = 0.65 -- because original map image is too large (this scale also scales labels and where they should be placed)
MapTravel.mapDirectory = "images/worldmap"
MapTravel.mapFilledDirectory = "images/worldmap" -- can be used in devMode to refrence where nodes should be placed  (to display already label filled map underneath non labeled map)


MapTravel_OPCODE = 214


MapTravel.icons = {
	premium = "/images/topbuttons/commands",
	gold = "/images/topbuttons/gold_t",
	item = "/images/topbuttons/ancestral",
	storage = "/images/topbuttons/character_stats2",
	progressReq = "/images/topbuttons/greater_dungeon"
}


MapTravel.mapNodesConfig = {
	[1] = {
		displayName = "Islanda",
		nameId = "islanda",
		discoverable = false,
		modulePos = {marginTop = 20, marginLeft = 202.5},
		serverPos = {432, 335, 7},
		premium = true,
		cost = {
			gold = 20,
		},
	},
	[2] = {
		displayName = "Swantears",
		nameId = "swantears",
		discoverable = false,
		modulePos = {marginTop = 92, marginLeft = 760},
		serverPos = {908, 456, 5},
		premium = false,
		cost = {
			gold = 20,
		},
	},
	[3] = {
		displayName = "Heleda",
		nameId = "heleda",
		discoverable = false,
		modulePos = {marginTop = 250, marginLeft = 1020},
		serverPos = {1106, 419, 7},
		premium = true,
		cost = {
			gold = 20,
		},
	},
	[4] = {
		displayName = "Galestra City",
		nameId = "galestra",
		discoverable = false,
		modulePos = {marginTop = 620, marginLeft = 100},
		serverPos = {227, 703, 6},
		premium = false,
		cost = {
			gold = 0,
		},
	},
	[5] = {
		displayName = "Garona",
		nameId = "garona",
		discoverable = false,
		modulePos = {marginTop = 665, marginLeft = 160},
		serverPos = {302, 746, 7},
		premium = false,
		cost = {
			gold = 20,
		},
	},
	[6] = {
		displayName = "Vendel Pass",
		nameId = "vendel",
		discoverable = false,
		modulePos = {marginTop = 750, marginLeft = 300},
		serverPos = {442, 858, 7},
		premium = false,
		cost = {
			gold = 20,
		},
	},
	[7] = {
		displayName = "Greith Keep",
		nameId = "greith",
		discoverable = false,
		modulePos = {marginTop = 698, marginLeft = 665.5},
		serverPos = {813, 795, 7},
		premium = false,
		cost = {
			gold = 20,
		},
	},
	[8] = {
		displayName = "Ziill Keep",
		nameId = "ziill",
		discoverable = false,
		modulePos = {marginTop = 840.5, marginLeft = 552.5},
		serverPos = {692, 924, 7},
		premium = false,
		cost = {
			gold = 20,
		},
	},
	[9] = {
		displayName = "WildThorns",
		nameId = "wildthorns",
		discoverable = false,
		modulePos = {marginTop = 775.5, marginLeft = 850.5},
		serverPos = {33177, 31764, 6},
		premium = false,
		cost = {
			gold = 20,
		},
	},
	[10] = {
		displayName = "Thar'Neskar",
		nameId = "tharneskar",
		discoverable = false,
		modulePos = {marginTop = 990, marginLeft = 580},
		serverPos = {732, 1088, 5},
		premium = false,
		--storagesReqs = {{id = 50002, value = 1, name = "Path to Garona"}},
		cost = {
			gold = 20,
		},
	},
	[11] = {
		displayName = "Vhassim",
		nameId = "vhassim",
		discoverable = false,
		modulePos = {marginTop = 1055, marginLeft = 737.5},
		serverPos = {959, 1198, 6},
		premium = true,
		cost = {
			gold = 20,
		},
	},
	[12] = {
		displayName = "Havenhold",
		nameId = "Havenhold",
		discoverable = false,
		modulePos = {marginTop = 1497.5, marginLeft = 100},
		serverPos = {32008, 32443, 6},
		premium = true,
		cost = {
			gold = 20,
		},
	},

}

-- Zone nodes (no teleport/discover). Each entry renders a creature looktype as the node icon
-- and shows a tooltip with the creature and recommended level.
-- outfit.type is the lookType ID to render; name is the zone name; recommendedLevel is a number/string.
-- modulePos uses the same coordinate system as mapNodesConfig and will be scaled by MapTravel.mapScale.
MapTravel.zoneNodeSize = { width = 70, height = 70 }
-- zonesConfig now supports two icon types per entry:
-- 1) Creature icon: provide `outfit = { type = <lookTypeId> }`
-- 2) Static image icon: provide `image = "/images/..."` (omit `outfit`)
-- Optional per-entry fields:
--   effectId (number)            -> attaches an effect to creature icons only
--   creatureSizeExtra (number)   -> extra size added to thing real size for better fit
--   marginLeftOffset / marginTopOffset (numbers) -> fine tune position for creature icons
--   imageScale (number, default 1)               -> scale factor for image icons
--   imageMarginLeftOffset / imageMarginTopOffset -> fine tune position for image icons
MapTravel.zonesConfig = {
  -- Example: creature looktype node with per-node effect
  {
	displayName = "Bloody Tunnels",
    outfit = { type = 1485 }, -- lookType ID (example)
    name = "Bloody Tunnels",
    recommendedLevel = "30+",
    modulePos = { marginTop = 625, marginLeft = 150 },
    effectId = 239,
    creatureSizeExtra = 100,
  },
  {
	displayName = "Twigkin Forest",
    outfit = { type = 2493 }, -- lookType ID (example)
    name = "Twigkin Forest", 
    recommendedLevel = "8+",
    modulePos = { marginTop = 590, marginLeft = 150 },
    effectId = 239,
    creatureSizeExtra = 70,
  },

  {
	displayName = "Ashen Grove",
    outfit = { type = 1927 }, -- lookType ID (example)
    name = "Ashen Grove", 
    recommendedLevel = "18+",
    modulePos = { marginTop = 535, marginLeft = 200 },
    effectId = 239,
    creatureSizeExtra = 85,
  },

  {
    displayName = "Garona Forest",
    outfit = { type = 2036 }, -- lookType ID (example)
    name = "Garona Forest", 
    recommendedLevel = "40+",
    modulePos = { marginTop = 680, marginLeft = 250 },
    effectId = 239,
    creatureSizeExtra = 85,
  },

  {
    displayName = "Mining excavation [north]",
    outfit = { type = 2600 }, -- lookType ID (example)
    name = "Mining excavation [north]", 
    recommendedLevel = "40+",
    modulePos = { marginTop = 650, marginLeft = 335 },
    effectId = 239,
    creatureSizeExtra = 40,
  },
  {
    displayName = "Mining excavation [south]",
    outfit = { type = 2600 }, -- lookType ID (example)
    name = "Mining excavation [south]", 
    recommendedLevel = "40+",
    modulePos = { marginTop = 700, marginLeft = 345 },
    effectId = 239,
    creatureSizeExtra = 40,
  },
  {
    outfit = { type = 1802 }, -- lookType ID (example)
    name = "Bull's plain", 
    recommendedLevel = "60+",
    modulePos = { marginTop = 570, marginLeft = 350 },
    effectId = 239,
    creatureSizeExtra = 90,
  },
  {
    outfit = { type = 2473 }, -- lookType ID (example)
    name = "Verdant Grove", 
    recommendedLevel = "70+", 
    modulePos = { marginTop = 540, marginLeft = 442 },
    effectId = 239,
    creatureSizeExtra = 55,
  },

  {
    outfit = { type = 2718 }, -- lookType ID (example)
    name = "Thornback Swamp", 
    recommendedLevel = "70+", 
    modulePos = { marginTop = 630, marginLeft = 480 },
    effectId = 239,
    creatureSizeExtra = 70,
  },
  {
    outfit = { type = 1702 }, -- lookType ID (example)
    name = "Cursed Cementery", 
    recommendedLevel = "90+", 
    modulePos = { marginTop = 680, marginLeft = 570 },
    effectId = 239,
    creatureSizeExtra = 50,
  },
  {
    outfit = { type = 1738 }, -- lookType ID (example)
    name = "Shadow Hollow", 
    recommendedLevel = "80+", 
    modulePos = { marginTop = 645, marginLeft = 403 },
    effectId = 239,
    creatureSizeExtra = 70,
  },
  {
    outfit = { type = 2594 }, -- lookType ID (example)
    name = "Forgotten Library", 
    recommendedLevel = "100+", 
    modulePos = { marginTop = 645, marginLeft = 688 },
    effectId = 239,
    creatureSizeExtra = 70,
  },

  {
    outfit = { type = 2689 }, -- lookType ID (example)
    name = "Eldenmere Ruins", 
    recommendedLevel = "65+", 
    modulePos = { marginTop = 750, marginLeft = 645 },
    effectId = 239,
    creatureSizeExtra = 70,
  },

  {
    outfit = { type = 2424 }, -- lookType ID (example)
    name = "Chlorophyll Tunnels", 
    recommendedLevel = "65+", 
    modulePos = { marginTop = 892, marginLeft = 435 },
    effectId = 239,
    creatureSizeExtra = 50,
  },

  {
    outfit = { type = 2450 }, -- lookType ID (example)
    name = "Sporeveil Outskirts", 
    recommendedLevel = "70+", 
    modulePos = { marginTop = 808, marginLeft = 580 },
    effectId = 239,
    creatureSizeExtra = 80,
  },
  {
    outfit = { type = 2450 }, -- lookType ID (example)
    name = "Sporeveil Swamp", 
    recommendedLevel = "70+", 
    modulePos = { marginTop = 875, marginLeft = 615 },
    effectId = 239,
    creatureSizeExtra = 80,
  },
  {
    outfit = { type = 2504 }, -- lookType ID (example)
    name = "Tuskin Mountain", 
    recommendedLevel = "125+", 
    modulePos = { marginTop = 875, marginLeft = 710 },
    effectId = 239,
    creatureSizeExtra = 70,
  },

  {
    outfit = { type = 2504 }, -- lookType ID (example)
    name = "Tuskin West Mountain", 
    recommendedLevel = "125+", 
    modulePos = { marginTop = 925, marginLeft = 550 },
    effectId = 239,
    creatureSizeExtra = 70,
  },

  {
    outfit = { type = 2720 }, -- lookType ID (example)
    name = "Wyrmfang Mountain", 
    recommendedLevel = "110+", 
    modulePos = { marginTop = 1005, marginLeft = 645 },
    effectId = 239,
    creatureSizeExtra = 128,
  },

  {
    outfit = { type = 1550 }, -- lookType ID (example)
    name = "Troll Fortress", 
    recommendedLevel = "125+", 
    modulePos = { marginTop = 955, marginLeft = 750 },
    effectId = 239,
    creatureSizeExtra = 95,
	},

	{
		outfit = { type = 2552 }, -- lookType ID (example)
		name = "Burried Tombs", 
		recommendedLevel = "230+", 
		modulePos = { marginTop = 1032, marginLeft = 389 },
		effectId = 239,
		creatureSizeExtra = 45,
	},
	{
		outfit = { type = 2672 }, -- lookType ID (example)
		name = "Murloks Beach", 
		recommendedLevel = "150+", 
		modulePos = { marginTop = 1094, marginLeft = 340 },
		effectId = 239,
		creatureSizeExtra = 60,
	},

	{
		outfit = { type = 1499 }, -- lookType ID (example)
		name = "desert draptors mountain", 
		recommendedLevel = "137+", 
		modulePos = { marginTop = 1140, marginLeft = 465 },
		effectId = 239,
		creatureSizeExtra = 135,
	},

	{
		name = "death mountain", 
		outfit = { type = 1290 }, -- lookType ID (example)
		recommendedLevel = "125+", 
		modulePos = { marginTop = 1050, marginLeft = 685 },
		effectId = 239,
		creatureSizeExtra = 95,
	},

	{
		name = "Ogre Foothills", 
		outfit = { type = 2427 }, -- lookType ID (example)
		recommendedLevel = "240+", 
		modulePos = { marginTop = 1180, marginLeft = 700 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 148,
	},

	{
		name = "High Foothills", 
		outfit = { type = 2626 }, -- lookType ID (example)
		recommendedLevel = "180+", 
		modulePos = { marginTop = 1020, marginLeft = 845 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 148,
	},































  -- Example: static image node (no creature effect applied)
  {
    displayName = "Dungeon",
    image = "/images/icons/dungeon.png",
    name = "Lucela's Dungeon",
    recommendedLevel = 60,
    modulePos = { marginTop = 635, marginLeft = 610 },
    imageScale = 0.65,
  },
  -- Add more zone entries as needed
}