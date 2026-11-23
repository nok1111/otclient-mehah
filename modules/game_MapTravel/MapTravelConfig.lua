
MapTravel = {}
MapTravel.unlockedNodes = {}
MapTravel.currentNodeNameId = nil
MapTravel.devMode = false


MapTravel.mapScale = 0.65 -- because original map image is too large (this scale also scales labels and where they should be placed)
MapTravel.mapDirectory = "images/worldmap"
MapTravel.mapFilledDirectory = "images/worldmap" -- can be used in devMode to refrence where nodes should be placed  (to display already label filled map underneath non labeled map)


MapTravel_OPCODE = 214


MapTravel.icons = {
	premium = "/images/topbuttons/prey",
	gold = "/images/topbuttons/gold_t",
	item = "/images/topbuttons/shop",
	storage = "/images/topbuttons/inventory",
	progressReq = "/images/topbuttons/questlog"
}

-- icons used only by the Dominion node tooltip (separate so MapTravel.icons
-- can be repurposed later without touching these)
MapTravel.dominionIcons = {
	owner = "/images/icons/row-1-column-5",
	state = "/images/icons/row-1-column-6",
	type  = "/images/icons/row-7-column-4",
	lord  = "/images/icons/fame_big",
	benefit = "/images/icons/icon_achievement",
}

-- .dat magic-effect ids for the world-map markers (rendered via UIEffect widget)
MapTravel.eventMarkerDatEffect = 876   -- zone events
MapTravel.buffMarkerDatEffect = 1540   -- zone buffs

-- Zone-buff icons: keyed by server buff type AND by the 'icon' template key
-- (zone_buffs.lua sends both). Swap paths when real buff art exists.
MapTravel.buffIcons = {
	doubleExp = "/images/icons/icon_experience",
	buff_exp = "/images/icons/icon_experience",
	monsterRush = "/images/icons/skull",
	buff_spawn = "/images/icons/skull",
	orbShower = "/images/icons/crystal-ball_8034727",
	buff_orbs = "/images/icons/crystal-ball_8034727",
	bloodPact = "/images/icons/skull",
	buff_pact = "/images/icons/skull",
	bountyHunt = "/images/icons/gold-bars",
	buff_bounty = "/images/icons/gold-bars",
	rapidRegen = "/images/icons/icon_health",
	buff_heal = "/images/icons/icon_health",
	speedDemon = "/images/icons/speed",
	buff_speed = "/images/icons/speed",
	survivalInstinct = "/images/icons/icon_shielding",
	buff_defense = "/images/icons/icon_shielding",
	bloodMoon = "/images/icons/fire",
	buff_moon = "/images/icons/fire",
	codexKnowledge = "/images/icons/star",
	buff_codex = "/images/icons/star",
}


-- shared waypoint icon scale (1 = png native size)
MapTravel.nodeIconScale = 2

MapTravel.mapNodesConfig = {
	[1] = {
		displayName = "Valoria City",
		nameId = "valoria_city",
		actionId = 61205,
		discoverable = false,
		modulePos = {marginTop = 3816, marginLeft = 1824}, -- world 199,702,6
		serverPos = {199, 702, 6},
		premium = false,
		cost = { gold = 5 },
	},
	[2] = {
		displayName = "Milltown",
		nameId = "milltown",
		actionId = 61200,
		discoverable = false,
		modulePos = {marginTop = 3992, marginLeft = 2236}, -- world 302,746,7
		serverPos = {302, 746, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[3] = {
		displayName = "The Crossroads",
		nameId = "the_crossroads",
		actionId = 61206,
		discoverable = false,
		modulePos = {marginTop = 3956, marginLeft = 3044}, -- world 504,737,7
		serverPos = {504, 737, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[4] = {
		displayName = "Rivermill",
		nameId = "rivermill",
		actionId = 61201,
		discoverable = false,
		modulePos = {marginTop = 4440, marginLeft = 2796}, -- world 442,858,7
		serverPos = {442, 858, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[5] = {
		displayName = "Goldhaven",
		nameId = "goldhaven",
		actionId = 61202,
		discoverable = false,
		modulePos = {marginTop = 4188, marginLeft = 4280}, -- world 813,795,7
		serverPos = {813, 795, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[6] = {
		displayName = "Zilkeep",
		nameId = "zilkeep",
		actionId = 61203,
		discoverable = false,
		modulePos = {marginTop = 4704, marginLeft = 3796}, -- world 692,924,7
		serverPos = {692, 924, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[7] = {
		displayName = "Thar'neskar",
		nameId = "tharneskar",
		actionId = 61204,
		discoverable = false,
		modulePos = {marginTop = 5336, marginLeft = 3956}, -- world 732,1082,7
		serverPos = {732, 1082, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[8] = {
		displayName = "Juldem",
		nameId = "juldem",
		actionId = 61208,
		discoverable = false,
		modulePos = {marginTop = 5816, marginLeft = 3260}, -- world 558,1202,7
		serverPos = {558, 1202, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[9] = {
		displayName = "Southern Watchpost",
		nameId = "southern_watchpost",
		actionId = 61210,
		discoverable = false,
		modulePos = {marginTop = 5656, marginLeft = 4076}, -- world 762,1162,6
		serverPos = {762, 1162, 6},
		premium = false,
		cost = { gold = 5 },
	},
	[10] = {
		displayName = "Vhassim",
		nameId = "vhassim",
		actionId = 61209,
		discoverable = false,
		modulePos = {marginTop = 5800, marginLeft = 4864}, -- world 959,1198,6
		serverPos = {959, 1198, 6},
		premium = false,
		cost = { gold = 5 },
	},
	[11] = {
		displayName = "Gladiators Stance",
		nameId = "gladiators_stance",
		actionId = 61212,
		discoverable = false,
		modulePos = {marginTop = 5568, marginLeft = 5540}, -- world 1128,1140,7
		serverPos = {1128, 1140, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[12] = {
		displayName = "Garona",
		nameId = "garona",
		actionId = 61211,
		discoverable = false,
		modulePos = {marginTop = 4728, marginLeft = 5068}, -- world 1010,930,3
		serverPos = {1010, 930, 3},
		premium = false,
		cost = { gold = 5 },
	},
	[13] = {
		displayName = "Wildthorns Camp",
		nameId = "wildthorns_camp",
		actionId = 61207,
		discoverable = false,
		modulePos = {marginTop = 3688, marginLeft = 4996}, -- world 992,670,6
		serverPos = {992, 670, 6},
		premium = false,
		cost = { gold = 5 },
	},
	[14] = {
		displayName = "Jungle Path",
		nameId = "jungle_path",
		actionId = 61213,
		discoverable = false,
		modulePos = {marginTop = 3808, marginLeft = 5596}, -- world 1142,700,7
		serverPos = {1142, 700, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[15] = {
		displayName = "Stoneport City",
		nameId = "stoneport_city",
		actionId = 61214,
		discoverable = false,
		modulePos = {marginTop = 3036, marginLeft = 5556}, -- world 1132,507,6
		serverPos = {1132, 507, 6},
		premium = false,
		cost = { gold = 5 },
	},
	[16] = {
		displayName = "Frostveil Island",
		nameId = "frostveil_island",
		actionId = 61215,
		discoverable = false,
		modulePos = {marginTop = 2684, marginLeft = 5452}, -- world 1106,419,7
		serverPos = {1106, 419, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[17] = {
		displayName = "Frozen Port",
		nameId = "frozen_port",
		actionId = 61216,
		discoverable = false,
		modulePos = {marginTop = 2276, marginLeft = 2696}, -- world 417,317,7
		serverPos = {417, 317, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[18] = {
		displayName = "Coldreach Island",
		nameId = "coldreach_island",
		actionId = 61217,
		discoverable = false,
		modulePos = {marginTop = 1800, marginLeft = 2748}, -- world 430,198,7
		serverPos = {430, 198, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[19] = {
		displayName = "Dark Passage",
		nameId = "dark_passage",
		actionId = 61218,
		discoverable = false,
		modulePos = {marginTop = 4512, marginLeft = 6184}, -- world 1289,876,5
		serverPos = {1289, 876, 5},
		premium = false,
		cost = { gold = 5 },
	},
	[20] = {
		displayName = "Inferna's Island",
		nameId = "infernas_island",
		actionId = 61219,
		discoverable = false,
		modulePos = {marginTop = 3140, marginLeft = 3088}, -- world 515,533,7
		serverPos = {515, 533, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[21] = {
		displayName = "Powderia",
		nameId = "powderia",
		actionId = 61220,
		discoverable = false,
		modulePos = {marginTop = 5412, marginLeft = 2984}, -- world 489,1101,7
		serverPos = {489, 1101, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[22] = {
		displayName = "Death's Gate",
		nameId = "deaths_gate",
		actionId = 61221,
		discoverable = false,
		modulePos = {marginTop = 6580, marginLeft = 3252}, -- world 556,1393,7
		serverPos = {556, 1393, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[23] = {
		displayName = "Forgotten Isle",
		nameId = "forgotten_isle",
		actionId = 61222,
		discoverable = false,
		modulePos = {marginTop = 6740, marginLeft = 5780}, -- world 1188,1433,7
		serverPos = {1188, 1433, 7},
		premium = false,
		cost = { gold = 5 },
	},
	[24] = {
		displayName = "Bloody Coast",
		nameId = "bloody_coast",
		actionId = 61223,
		discoverable = false,
		modulePos = {marginTop = 5756, marginLeft = 5732}, -- world 1176,1187,6
		serverPos = {1176, 1187, 6},
		premium = false,
		cost = { gold = 5 },
	},
	[25] = {
		displayName = "Cursed Island",
		nameId = "cursed_island",
		actionId = 61224,
		discoverable = false,
		modulePos = {marginTop = 3596, marginLeft = 4428}, -- world 850,647,6
		serverPos = {850, 647, 6},
		premium = false,
		cost = { gold = 5 },
		storagesReqs = {{id = 999999, value = 1, name = "TODO: storage req"}}, -- placeholder, fix storage id
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
    modulePos = { marginTop = 635, marginLeft = 320 },
    effectId = 239,
    creatureSizeExtra = 50,
  },
  {
    displayName = "Mining excavation [south]",
    outfit = { type = 2600 }, -- lookType ID (example)
    name = "Mining excavation [south]", 
    recommendedLevel = "40+",
    modulePos = { marginTop = 715, marginLeft = 320 },
    effectId = 239,
    creatureSizeExtra = 50,
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
    recommendedLevel = "60+", 
    modulePos = { marginTop = 645, marginLeft = 405 },
    effectId = 239,
    creatureSizeExtra = 80,
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
    recommendedLevel = "90+", 
    modulePos = { marginTop = 892, marginLeft = 435 },
    effectId = 239,
    creatureSizeExtra = 50,
  },

  {
    outfit = { type = 2450 }, -- lookType ID (example)
    name = "Sporeveil Outskirts", 
    recommendedLevel = "70+", 
    modulePos = { marginTop = 808, marginLeft = 598 },
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

	{
		name = "Troll's lair", 
		outfit = { type = 1893 }, -- lookType ID (example)
		recommendedLevel = "15+", 
		modulePos = { marginTop = 592, marginLeft = 206 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 148,
	},

	{
		name = "Hydra Lairs", 
		outfit = { type = 1397 }, -- lookType ID (example)
		recommendedLevel = "100+", 
		modulePos = { marginTop = 1188, marginLeft = 850 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 148,
	},

	{
		name = "Scorpion's Veil", 
		outfit = { type = 1485 }, -- lookType ID (example)
		recommendedLevel = "30+", 
		modulePos = { marginTop = 1120, marginLeft = 928 },
		effectId = 239,
		creatureSizeExtra = 100,
	},
	
		{
		name = "Emberwild Barrens", 
		outfit = { type = 1497 }, -- lookType ID (example)
		recommendedLevel = "85+", 
		modulePos = { marginTop = 975, marginLeft = 890 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 150,
	},

	{
		name = "Emberwild Catacombs", 
		outfit = { type = 2314 }, -- lookType ID (example)
		recommendedLevel = "125+", 
		modulePos = { marginTop = 890, marginLeft = 970 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 120,
	},
	{
		name = "Bone Beach", 
		outfit = { type = 1628 }, -- lookType ID (example)
		recommendedLevel = "175+", 
		modulePos = { marginTop = 800, marginLeft = 910 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 120,
	},

	{
		name = "Jungle Depths", 
		outfit = { type = 1567 }, -- lookType ID (example)
		recommendedLevel = "175+", 
		modulePos = { marginTop = 810, marginLeft = 875 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 120,
	},
	{
		name = "bonedust mountain", 
		outfit = { type = 2555 }, -- lookType ID (example)
		recommendedLevel = "230+", 
		modulePos = { marginTop = 1038, marginLeft = 920 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 120,
	},
	{
		name = "isle of powderia", 
		outfit = { type = 2582 }, -- lookType ID (example)
		recommendedLevel = "215+", 
		modulePos = { marginTop = 962, marginLeft = 365 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 120,
	},
	{
		name = "isle of dragonia", 
		outfit = { type = 2463 }, -- lookType ID (example)
		recommendedLevel = "135+", 
		modulePos = { marginTop = 425, marginLeft = 330 },
		effectId = 239,
		creatureSizeExtra = 270,
		creatureFixSize = 148,
	},






	--marginTop = 1005, marginLeft = 340.5






























  -- Example: static image node (no creature effect applied)
  {
    displayName = "Dungeon",
    image = "/images/icons/dungeon.png",
    name = "Lucela's Dungeon",
    recommendedLevel = 60,
    modulePos = { marginTop = 635, marginLeft = 610 },
    imageScale = 0.65,
  },
    {
    displayName = "Arena",
    image = "/images/icons/flags.png",
    name = "Sandstorm Colliseum",
    recommendedLevel = 180,
    modulePos = { marginTop = 1000, marginLeft = 1012 },
    imageScale = 0.85,
  },
  -- Add more zone entries as needed
}

------------------------------------------------------------
-- Territorial Dominion node positions (optional overrides)
------------------------------------------------------------
-- Keyed by territory id (1-15, same ids the server sends on opcode 237).
-- Values use base-image pixel space, same as modulePos above (scaled by
-- MapTravel.mapScale at render). If a node is missing or has nil margins,
-- the marker falls back to worldToPixelXY(corePos) — useful only while the
-- map image actually covers the node's world area.
-- Fill these by hand to place each dominion node on the map art.
MapTravel.dominionNodePositions = {
  [1]  = { marginTop = 3716, marginLeft = 3492 }, -- Skyport Exchange (world 616,677,5)
  [2]  = { marginTop = 3932, marginLeft = 2908 }, -- Emberdeep Excavation (world 470,731,5)
  [3]  = { marginTop = 4532, marginLeft = 4296 }, -- Gilded Hollow (world 817,881,6)
  [4]  = { marginTop = 5668, marginLeft = 3492 }, -- Sunfall Fields (world 616,1165,7)
  [5]  = { marginTop = 6068, marginLeft = 4924 }, -- Veil of Isis (world 974,1265,7)
  [6]  = { marginTop = 5736, marginLeft = 5356 }, -- Cutthroat Arena (world 1082,1182,7)
  [7]  = { marginTop = 4880, marginLeft = 5532 }, -- Overgrown Ruins (world 1126,968,7)
  [8]  = { marginTop = 3680, marginLeft = 5492 }, -- Verdant Depths (world 1116,668,7)
  [9]  = { marginTop = 2884, marginLeft = 4996 }, -- Emerald Oasis (world 992,469,7)
  [10] = { marginTop = 2472, marginLeft = 5688 }, -- Frozen Hollow (world 1165,366,7)
  [11] = { marginTop = 2136, marginLeft = 3632 }, -- The Emerald Gloom (world 651,282,7)
  [12] = { marginTop = 2192, marginLeft = 5092 }, -- Netherwatch Spire (world 1016,296,7)
  [13] = { marginTop = 5596, marginLeft = 7120 }, -- Hellforge Ruins (world 1523,1147,2)
  [14] = { marginTop = 5596, marginLeft = 7120 }, -- The Infinite Inferno (world 1523,1147,2)
  [15] = { marginTop = 5504, marginLeft = 6484 }, -- Throne of Ascension (world 1364,1124,1)
}

-- Per-node marker item ids (clientId). Any node not listed falls back to 33327.
MapTravel.dominionNodeIcons = {
  -- [1]  = 33327, -- Skyport Exchange
  -- [2]  = 33327, -- Emberdeep Excavation
  -- [3]  = 33327, -- Gilded Hollow
  -- [4]  = 33327, -- Sunfall Fields
  -- [5]  = 33327, -- Veil of Isis
  -- [6]  = 33327, -- Cutthroat Arena
  -- [7]  = 33327, -- Overgrown Ruins
  -- [8]  = 33327, -- Verdant Depths
  -- [9]  = 33327, -- Emerald Oasis
  -- [10] = 33327, -- Frozen Hollow
  -- [11] = 33327, -- The Emerald Gloom
  -- [12] = 33327, -- Netherwatch Spire
  -- [13] = 33327, -- Hellforge Ruins
  -- [14] = 33327, -- The Infinite Inferno
  -- [15] = 33327, -- Throne of Ascension
}