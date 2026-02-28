
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
Codex.TAB_UPGRADE = 4

-- Early slot unlock cost (must match server CodexUpgrade.lua)
function Codex.getEarlySlotUnlockCost(earlyUnlocks)
	earlyUnlocks = tonumber(earlyUnlocks) or 0
	if earlyUnlocks < 0 then
		earlyUnlocks = 0
	end
	local baseCost = 500
	return math.floor(baseCost * math.pow(2, earlyUnlocks))
end

-- Pagination Constants
Codex.cardsPerPage = 20
Codex.currentCollectionPage = 1

-- Rarity Colors (4 tiers only)
Codex.rarityColors = {
	common = "#ffffff",      -- Blanco
	rare = "#00ff00",        -- Verde
	epic = "#a335ee",        -- Morado
	legendary = "#ff8000"    -- Naranja
}

-- Get background image based on card level
function Codex.getCardBackgroundByLevel(level)
	if level == 1 then
		return "/images/ui/tooltip-white"
	elseif level >= 2 and level <= 4 then
		return "/images/ui/tooltip_unique"
	elseif level >= 5 and level <= 7 then
		return "/images/ui/tooltip-blue"
	elseif level >= 8 and level <= 9 then
		return "/images/ui/tooltip-purple"
	elseif level >= 10 then
		return "/images/ui/tooltip-orange"
	else
		return "/images/ui/tooltip-white" -- Default
	end
end

-- Get background image based on card rarity
function Codex.getCardBackgroundByRarity(rarity)
	if rarity == "common" then
		return "/images/ui/tooltip-white"
	elseif rarity == "rare" then
		return "/images/ui/tooltip_unique"
	elseif rarity == "epic" then
		return "/images/ui/tooltip-purple"
	elseif rarity == "legendary" then
		return "/images/ui/tooltip-orange"
	else
		return "/images/ui/tooltip-white" -- Default
	end
end

-- Get background image based on crate ID
function Codex.getCrateBackground(crateId)
	if crateId == 1 then
		-- Bronze Crate
		return "/images/ui/tooltip-white"
	elseif crateId == 2 then
		-- Silver Crate
		return "/images/ui/tooltip-blue"
	elseif crateId == 3 then
		-- Gold Crate
		return "/images/ui/tooltip-orange"
	else
		return "/images/ui/tooltip-white" -- Default
	end
end
