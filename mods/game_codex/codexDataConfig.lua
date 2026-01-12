
Codex = {}
Codex.opCode = 174

-- Path Constants
Codex.cardImagesPath = "/images/codex/cards/"
Codex.crateImagesPath = "/images/codex/crates/"

-- Card Experience Table (Level 1-10)
Codex.cardExpTable = {
	[1] = 100,    -- Level 1 -> 2
	[2] = 250,    -- Level 2 -> 3
	[3] = 500,    -- Level 3 -> 4
	[4] = 1000,   -- Level 4 -> 5
	[5] = 2000,   -- Level 5 -> 6
	[6] = 4000,   -- Level 6 -> 7
	[7] = 8000,   -- Level 7 -> 8
	[8] = 15000,  -- Level 8 -> 9
	[9] = 25000,  -- Level 9 -> 10
	[10] = 0      -- Max level (no more exp needed)
}

-- UI Constants
Codex.cardWidth = 80
Codex.cardHeight = 100
Codex.cardMargin = 10
Codex.cardsPerRow = 5

-- Tab Constants
Codex.TAB_COLLECTION = 1
Codex.TAB_DECK = 2
Codex.TAB_CRATES = 3

-- Rarity Colors
Codex.rarityColors = {
	common = "#9d9d9d",
	uncommon = "#1eff00",
	rare = "#0070dd",
	epic = "#a335ee",
	legendary = "#ff8000"
}
