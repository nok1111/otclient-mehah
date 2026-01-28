-- Filter system for Codex cards

Codex.activeFilters = {
	searchText = "",
	selectedTrigger = "All",
	rarities = {},
	levels = {}
}

-- Initialize filter UI
function Codex.initializeFilters()
	local filterPanel = Codex.UI:getChildById("FilterPanel")
	if not filterPanel then
		print("[Codex] FilterPanel not found!")
		return
	end
	
	-- Setup search input
	local searchInput = filterPanel:getChildById("SearchInput")
	if searchInput then
		searchInput.onTextChange = function(widget, text)
			Codex.activeFilters.searchText = text:lower()
			Codex.applyFilters()
		end
	end
	
	-- Setup trigger dropdown
	local triggerDropdown = filterPanel:getChildById("TriggerFilterDropdown")
	if triggerDropdown then
		-- Add "All" option first
		triggerDropdown:addOption("All")
		
		-- Add trigger options from Codex.triggerIcons
		local triggers = {
			"onHit", "passive", "onKill", "onDamageTaken", "onDeath",
			"onSpell", "onLowHP", "onHeal", "onCrit", "onDash",
			"onStandStill", "onDefensiveSpell", "onShield", 
			"onShieldDamage", "onAttackSpell", "onHealingSpell"
		}
		
		for _, trigger in ipairs(triggers) do
			triggerDropdown:addOption(trigger)
		end
		
		triggerDropdown:setCurrentOption("All")
		
		triggerDropdown.onOptionChange = function(widget, option)
			Codex.activeFilters.selectedTrigger = option
			Codex.applyFilters()
		end
	end
	
	-- Initialize all checkboxes as checked and assign callbacks
	local checkboxes = {
		"CommonCheckbox", "RareCheckbox", "EpicCheckbox", "LegendaryCheckbox",
		"Level1to3Checkbox", "Level4to6Checkbox", "Level7to9Checkbox", "Level10Checkbox"
	}
	
	for _, checkboxId in ipairs(checkboxes) do
		local checkbox = filterPanel:getChildById(checkboxId)
		if checkbox then
			checkbox:setChecked(true)
			checkbox.onCheckChange = function()
				Codex.onFilterChange()
			end
		end
	end
	
	-- Setup Clear Filters button
	local clearButton = filterPanel:getChildById("ClearFiltersButton")
	if clearButton then
		clearButton.onClick = function()
			Codex.clearFilters()
		end
	end
	
	-- Initialize active filters
	Codex.activeFilters.rarities = {common = true, rare = true, epic = true, legendary = true}
	Codex.activeFilters.levels = {["1-3"] = true, ["4-6"] = true, ["7-9"] = true, ["10"] = true}
end

-- Called when any filter changes
function Codex.onFilterChange()
	local filterPanel = Codex.UI:getChildById("FilterPanel")
	if not filterPanel then return end
	
	-- Update rarity filters
	Codex.activeFilters.rarities = {
		common = filterPanel:getChildById("CommonCheckbox"):isChecked(),
		rare = filterPanel:getChildById("RareCheckbox"):isChecked(),
		epic = filterPanel:getChildById("EpicCheckbox"):isChecked(),
		legendary = filterPanel:getChildById("LegendaryCheckbox"):isChecked()
	}
	
	-- Update level filters
	Codex.activeFilters.levels = {
		["1-3"] = filterPanel:getChildById("Level1to3Checkbox"):isChecked(),
		["4-6"] = filterPanel:getChildById("Level4to6Checkbox"):isChecked(),
		["7-9"] = filterPanel:getChildById("Level7to9Checkbox"):isChecked(),
		["10"] = filterPanel:getChildById("Level10Checkbox"):isChecked()
	}
	
	Codex.applyFilters()
end

-- Clear all filters
function Codex.clearFilters()
	local filterPanel = Codex.UI:getChildById("FilterPanel")
	if not filterPanel then return end
	
	-- Clear search
	local searchInput = filterPanel:getChildById("SearchInput")
	if searchInput then
		searchInput:setText("")
	end
	
	-- Reset trigger dropdown
	local triggerDropdown = filterPanel:getChildById("TriggerFilterDropdown")
	if triggerDropdown then
		triggerDropdown:setCurrentOption("All")
	end
	
	-- Check all checkboxes
	local checkboxes = {
		"CommonCheckbox", "RareCheckbox", "EpicCheckbox", "LegendaryCheckbox",
		"Level1to3Checkbox", "Level4to6Checkbox", "Level7to9Checkbox", "Level10Checkbox"
	}
	
	for _, checkboxId in ipairs(checkboxes) do
		local checkbox = filterPanel:getChildById(checkboxId)
		if checkbox then
			checkbox:setChecked(true)
		end
	end
	
	-- Reset active filters
	Codex.activeFilters.searchText = ""
	Codex.activeFilters.selectedTrigger = "All"
	Codex.activeFilters.rarities = {common = true, rare = true, epic = true, legendary = true}
	Codex.activeFilters.levels = {["1-3"] = true, ["4-6"] = true, ["7-9"] = true, ["10"] = true}
	
	Codex.applyFilters()
end

-- Apply filters to current view
function Codex.applyFilters()
	if Codex.currentTab == Codex.TAB_COLLECTION then
		Codex.setupCollectionUI()
	elseif Codex.currentTab == Codex.TAB_DECK then
		Codex.setupDeckUI()
	elseif Codex.currentTab == Codex.TAB_UPGRADE then
		Codex.setupUpgradeUI()
	end
end

-- Check if a card passes current filters
function Codex.passesFilters(cardId, cardLevel, cardData)
	if not cardData then return false end
	
	-- Search filter
	if Codex.activeFilters.searchText ~= "" then
		local nameMatch = cardData.name:lower():find(Codex.activeFilters.searchText, 1, true)
		if not nameMatch then
			return false
		end
	end
	
	-- Rarity filter
	if not Codex.activeFilters.rarities[cardData.rarity] then
		return false
	end
	
	-- Level filter
	local levelGroup = nil
	if cardLevel >= 1 and cardLevel <= 3 then
		levelGroup = "1-3"
	elseif cardLevel >= 4 and cardLevel <= 6 then
		levelGroup = "4-6"
	elseif cardLevel >= 7 and cardLevel <= 9 then
		levelGroup = "7-9"
	elseif cardLevel >= 10 then
		levelGroup = "10"
	end
	
	if levelGroup and not Codex.activeFilters.levels[levelGroup] then
		return false
	end
	
	-- Trigger filter
	if Codex.activeFilters.selectedTrigger ~= "All" then
		if not cardData.trigger or cardData.trigger ~= Codex.activeFilters.selectedTrigger then
			return false
		end
	end
	
	return true
end
