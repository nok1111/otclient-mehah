
MapTravel = {}
MapTravel.unlockedNodes = {}
MapTravel.currentNodeNameId = nil
MapTravel.devMode = false


MapTravel.mapScale = 0.65 -- because original map image is too large (this scale also scales labels and where they should be placed)
MapTravel.mapDirectory = "images/worldmap"
MapTravel.mapFilledDirectory = "images/worldmapFilled" -- can be used in devMode to refrence where nodes should be placed  (to display already label filled map underneath non labeled map)


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
			gold = 300,
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
			gold = 300,
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
			gold = 300,
		},
	},
	[4] = {
		displayName = "Galestra City",
		nameId = "galestra",
		discoverable = false,
		modulePos = {marginTop = 410, marginLeft = 5},
		serverPos = {124, 776, 0},
		premium = false,
		cost = {
			gold = 0,
		},
	},
	[5] = {
		displayName = "Garona",
		nameId = "garona",
		discoverable = false,
		modulePos = {marginTop = 575, marginLeft = 95.5},
		serverPos = {31921, 32072, 6},
		premium = false,
		cost = {
			gold = 300,
		},
	},
	[6] = {
		displayName = "Vendel Pass",
		nameId = "vendel",
		discoverable = false,
		modulePos = {marginTop = 700, marginLeft = 190},
		serverPos = {442, 858, 7},
		premium = false,
		cost = {
			gold = 300,
		},
	},
	[7] = {
		displayName = "Greith Keep",
		nameId = "greith",
		discoverable = false,
		modulePos = {marginTop = 625, marginLeft = 530.5},
		serverPos = {813, 795, 7},
		premium = false,
		cost = {
			gold = 300,
		},
	},
	[8] = {
		displayName = "Ziill Keep",
		nameId = "ziill",
		discoverable = false,
		modulePos = {marginTop = 802.5, marginLeft = 510.5},
		serverPos = {692, 924, 7},
		premium = false,
		cost = {
			gold = 300,
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
			gold = 300,
		},
	},
	[10] = {
		displayName = "Thar’Neskar",
		nameId = "tharneskar",
		discoverable = false,
		modulePos = {marginTop = 950, marginLeft = 508},
		serverPos = {732, 1088, 5},
		premium = false,
		--storagesReqs = {{id = 50002, value = 1, name = "Path to Garona"}},
		cost = {
			gold = 300,
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
			gold = 300,
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
			gold = 300,
		},
	},

}