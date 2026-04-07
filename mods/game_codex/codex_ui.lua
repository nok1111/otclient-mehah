if not Codex then Codex = {} end

-- [View] User Interface for Codex

------ UI Management and Toggling ------

function Codex.toggle()
	if Codex.UI:isVisible() then
		Codex.hide()
	else
		Codex.show()
	end
end

function Codex.show()
	Codex.UI:show()
	Codex.UI:raise()
	Codex.UI:focus()
	Codex.Button:setOn(true)
	Codex.sendOpcode({ topic = "currency-request" })
	Codex.switchTab(Codex.currentTab)
end

function Codex.hide()
	Codex.UI:hide()
	Codex.Button:setOn(false)
	modules.game_interface.getRootPanel():focus()
end

------ Tab Management ------

function Codex.setupTabButtons()
	local tabsPanel = Codex.UI:getChildById("TabsPanel")
	if not tabsPanel then return end
	
	Codex.UI.CollectionTab = tabsPanel:getChildById("CollectionTab")
	Codex.UI.DeckTab = tabsPanel:getChildById("DeckTab")
	Codex.UI.CratesTab = tabsPanel:getChildById("CratesTab")
	Codex.UI.UpgradeTab = tabsPanel:getChildById("UpgradeTab")
	
	local essencesPanel = tabsPanel:getChildById("EssencesPanel")
	Codex.UI.EssencesLabel = essencesPanel and essencesPanel:getChildById("EssencesLabel") or nil

	if Codex.UI.CollectionTab then Codex.UI.CollectionTab.onClick = function() Codex.switchTab(Codex.TAB_COLLECTION) end end
	if Codex.UI.DeckTab then Codex.UI.DeckTab.onClick = function() Codex.switchTab(Codex.TAB_DECK) end end
	if Codex.UI.CratesTab then Codex.UI.CratesTab.onClick = function() Codex.switchTab(Codex.TAB_CRATES) end end
	if Codex.UI.UpgradeTab then Codex.UI.UpgradeTab.onClick = function() Codex.switchTab(Codex.TAB_UPGRADE) end end
	
	if Codex.UI.EssencesLabel then
		Codex.UI.EssencesLabel:setText("Codex Essences: " .. Codex.cachedEssences)
	end
end

function Codex.switchTab(tabId)
	Codex.currentTab = tabId

	Codex.UI.CollectionPanel = Codex.UI:getChildById("CollectionPanel")
	Codex.UI.DeckPanel = Codex.UI:getChildById("DeckPanel")
	Codex.UI.CratesPanel = Codex.UI:getChildById("CratesPanel")
	Codex.UI.UpgradePanel = Codex.UI:getChildById("UpgradePanel")
	local filterPanel = Codex.UI:getChildById("FilterPanel")

	if Codex.UI.CollectionPanel then Codex.UI.CollectionPanel:hide() end
	if Codex.UI.DeckPanel then Codex.UI.DeckPanel:hide() end
	if Codex.UI.CratesPanel then Codex.UI.CratesPanel:hide() end
	if Codex.UI.UpgradePanel then Codex.UI.UpgradePanel:hide() end

	if filterPanel then
		if tabId == Codex.TAB_CRATES then filterPanel:hide() else filterPanel:show() end
	end

	if Codex.UI.CollectionTab then Codex.UI.CollectionTab:setOn(false) end
	if Codex.UI.DeckTab then Codex.UI.DeckTab:setOn(false) end
	if Codex.UI.CratesTab then Codex.UI.CratesTab:setOn(false) end
	if Codex.UI.UpgradeTab then Codex.UI.UpgradeTab:setOn(false) end

	if tabId == Codex.TAB_COLLECTION then
		if Codex.UI.CollectionPanel then Codex.UI.CollectionPanel:show() end
		if Codex.UI.CollectionTab then Codex.UI.CollectionTab:setOn(true) end
		Codex.setupCollectionUI()
	elseif tabId == Codex.TAB_DECK then
		if Codex.UI.DeckPanel then Codex.UI.DeckPanel:show() end
		if Codex.UI.DeckTab then Codex.UI.DeckTab:setOn(true) end
		Codex.setupDeckUI()
	elseif tabId == Codex.TAB_CRATES then
		if Codex.UI.CratesPanel then Codex.UI.CratesPanel:show() end
		if Codex.UI.CratesTab then Codex.UI.CratesTab:setOn(true) end
		Codex.setupCratesUI()
	elseif tabId == Codex.TAB_UPGRADE then
		if Codex.UI.UpgradePanel then Codex.UI.UpgradePanel:show() end
		if Codex.UI.UpgradeTab then Codex.UI.UpgradeTab:setOn(true) end
		Codex.setupUpgradeUI()
	end
end

------ Collection Tab ------

function Codex.setupCollectionUI()
	local collectionGrid = Codex.UI.CollectionPanel and Codex.UI.CollectionPanel.CollectionGrid
	if not collectionGrid then return end
	
	collectionGrid:destroyChildren()
	
	local allCardIds = {}
	for cardId, cardData in pairs(Codex.cachedCardDatabase) do table.insert(allCardIds, cardId) end
	table.sort(allCardIds)
	
	local filteredCardIds = {}
	for _, cardId in ipairs(allCardIds) do
		local cardData = Codex.cachedCardDatabase[cardId]
		local cardLevel = Codex.cachedCards[cardId] or 0
		if Codex.passesFilters(cardId, cardLevel, cardData) then
			table.insert(filteredCardIds, cardId)
		end
	end
	
	local totalFilteredCards = #filteredCardIds
	local cardsPerPage = Codex.cardsPerPage or 20
	local totalPages = math.max(1, math.ceil(totalFilteredCards / cardsPerPage))
	
	if Codex.currentCollectionPage > totalPages then Codex.currentCollectionPage = totalPages end
	
	local startIndex = (Codex.currentCollectionPage - 1) * cardsPerPage + 1
	local endIndex = math.min(startIndex + cardsPerPage - 1, totalFilteredCards)
	
	local paginationPanel = Codex.UI.CollectionPanel and Codex.UI.CollectionPanel:getChildById("PaginationPanel")
	if paginationPanel then
		local pageInfo = paginationPanel:getChildById("PageInfo")
		if pageInfo then pageInfo:setText("Page " .. Codex.currentCollectionPage .. " / " .. totalPages) end
		
		local prevButton = paginationPanel:getChildById("PrevPageButton")
		if prevButton then
			prevButton:setEnabled(Codex.currentCollectionPage > 1)
			prevButton.onClick = Codex.prevCollectionPage
		end
		
		local nextButton = paginationPanel:getChildById("NextPageButton")
		if nextButton then
			nextButton:setEnabled(Codex.currentCollectionPage < totalPages)
			nextButton.onClick = Codex.nextCollectionPage
		end
	end

	for i = startIndex, endIndex do
		local cardId = filteredCardIds[i]
		local cardData = Codex.cachedCardDatabase[cardId]
		local cardLevel = Codex.cachedCards[cardId] or 0
		local isUnlocked = cardLevel > 0
		
		local cardWidget = g_ui.createWidget("CollectionCardEntry", collectionGrid)
		if cardWidget then
			cardWidget:setId("card_" .. cardId)
			cardWidget.cardId = cardId
			cardWidget.cardData = cardData

			local cardImage = cardWidget:getChildById("cardImage")
			if cardImage then
				cardImage:setImageSource(Codex.cardImagesPath .. cardData.cardFrame .. ".png")
				if isUnlocked then
					cardImage:setImageColor("#ffffff")
					cardImage:setOpacity(1.0)
				else
					cardImage:setImageColor("#404040")
					cardImage:setOpacity(0.5)
				end
			end

			local lockIcon = cardWidget:getChildById("lockIcon")
			if lockIcon then lockIcon:setVisible(not isUnlocked) end

			local nameLabel = cardWidget:getChildById("cardNameLabel")
			if nameLabel then
				nameLabel:setText(cardData.name)
				nameLabel:setColor(Codex.rarityColors[cardData.rarity] or "#ffffff")
			end

			local levelLabel = cardWidget:getChildById("cardLevelLabel")
			if levelLabel then
				levelLabel:setText(isUnlocked and tostring(cardLevel) or "0")
			end

			local expBar = cardWidget:getChildById("expBar")
			local expLabel = cardWidget:getChildById("expLabel")
			
			if isUnlocked and cardLevel < cardData.maxLevel then
				local currentExp = Codex.cachedCardsExp[cardId] or 0
				local expNeeded = Codex.cardExpTable[cardLevel] or 1
				local expPercent = math.min(100, math.floor((currentExp / expNeeded) * 100))
				
				if expBar then 
					expBar:setPercent(expPercent)
					expBar:setVisible(true)
				end
				if expLabel then
					expLabel:setText(currentExp .. "/" .. expNeeded)
					expLabel:setVisible(true)
				end
			end

			cardWidget.onClick = function() Codex.selectCard(cardId) end
			cardWidget.onHoverChange = Codex.onCardHoverChange
		end
	end
end

function Codex.nextCollectionPage()
	local totalCards = table.size(Codex.cachedCardDatabase)
	local totalPages = math.ceil(totalCards / Codex.cardsPerPage)
	
	if Codex.currentCollectionPage < totalPages then
		Codex.currentCollectionPage = Codex.currentCollectionPage + 1
		Codex.setupCollectionUI()
	end
end

function Codex.prevCollectionPage()
	if Codex.currentCollectionPage > 1 then
		Codex.currentCollectionPage = Codex.currentCollectionPage - 1
		Codex.setupCollectionUI()
	end
end

function Codex.selectCard(cardId)
	Codex.selectedCardId = cardId
	Codex.updateCardDetails()
end

function Codex.updateCardDetails()
	local cardDetailsPanel = Codex.UI.CollectionPanel and Codex.UI.CollectionPanel.CardDetailsPanel
	if not cardDetailsPanel or not Codex.selectedCardId then return end

	local cardData = Codex.cachedCardDatabase[Codex.selectedCardId]
	if not cardData then return end

	local cardLevel = Codex.cachedCards[Codex.selectedCardId] or 0
	local isUnlocked = cardLevel > 0

	local cardImageHeader = cardDetailsPanel:getChildById("CardImageHeader")
	if cardImageHeader then
		cardImageHeader:setImageSource(Codex.cardImagesPath .. cardData.cardFrame .. ".png")
		cardImageHeader:show()
		
		if not isUnlocked then
			cardImageHeader:setOpacity(0.5)
			cardImageHeader:setImageColor("#404040")
		else
			cardImageHeader:setOpacity(1.0)
			cardImageHeader:setImageColor("#ffffff")
		end
	end

	if cardDetailsPanel.CardName then
		cardDetailsPanel.CardName:setText(cardData.name)
		cardDetailsPanel.CardName:setColor(Codex.rarityColors[cardData.rarity] or "#ffffff")
	end

	if cardDetailsPanel.CardLevel then
		if isUnlocked then
			cardDetailsPanel.CardLevel:setText("Level: " .. cardLevel .. " / " .. cardData.maxLevel)
		else
			cardDetailsPanel.CardLevel:setText("LOCKED")
		end
	end
	
	local cardExpBar = cardDetailsPanel:getChildById("CardExpBar")
	local cardExpText = cardDetailsPanel:getChildById("CardExpText")
	
	if cardExpBar and cardExpText then
		if isUnlocked and cardLevel < cardData.maxLevel then
			local currentExp = Codex.cachedCardsExp[Codex.selectedCardId] or 0
			local expNeeded = Codex.cardExpTable[cardLevel] or 1
			local expPercent = math.min(100, math.floor((currentExp / expNeeded) * 100))
			
			cardExpBar:setPercent(expPercent)
			cardExpText:setText(currentExp .. " / " .. expNeeded .. " EXP")
			cardExpBar:setVisible(true)
			cardExpText:setVisible(true)
		elseif isUnlocked and cardLevel >= cardData.maxLevel then
			cardExpBar:setPercent(100)
			cardExpText:setText("MAX LEVEL")
			cardExpBar:setVisible(true)
			cardExpText:setVisible(true)
		else
			cardExpBar:setVisible(false)
			cardExpText:setVisible(false)
		end
	end

	if cardDetailsPanel.CardTrigger then
		cardDetailsPanel.CardTrigger:destroyChildren()
		
		local triggerIconPath = Codex.triggerIcons[cardData.trigger]
		if triggerIconPath then
			local iconWidget = g_ui.createWidget("UIWidget", cardDetailsPanel.CardTrigger)
			iconWidget:setImageSource(triggerIconPath)
			iconWidget:setSize({width = 16, height = 16})
			iconWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			iconWidget:addAnchor(AnchorTop, "parent", AnchorTop)
			iconWidget:setMarginTop(-3)
			
			cardDetailsPanel.CardTrigger:setText("Trigger: " .. cardData.trigger)
			cardDetailsPanel.CardTrigger:setTextOffset({x = 0, y = 14})
		else
			cardDetailsPanel.CardTrigger:setText("Trigger: " .. cardData.trigger)
			cardDetailsPanel.CardTrigger:setTextOffset({x = 0, y = 0})
		end
	end

	if cardDetailsPanel.CardDescription then
		cardDetailsPanel.CardDescription:destroyChildren()
		
		if isUnlocked and cardData.description then
			local currentDesc = cardData.description[cardLevel] or cardData.description[1] or "No description"
			local maxDesc = cardData.description[cardData.maxLevel] or "No description"

			local currentLabel = g_ui.createWidget("Label", cardDetailsPanel.CardDescription)
			currentLabel:setText("Current (Lvl " .. cardLevel .. "):")
			currentLabel:setColor("#00ff00")
			currentLabel:setMarginTop(5)
			currentLabel:setTextAutoResize(true)

			local currentDescLabel = g_ui.createWidget("Label", cardDetailsPanel.CardDescription)
			currentDescLabel:setText(currentDesc)
			currentDescLabel:setTextWrap(true)
			currentDescLabel:setTextAutoResize(true)
			currentDescLabel:setMarginTop(2)

			if cardLevel < cardData.maxLevel then
				local maxLabel = g_ui.createWidget("Label", cardDetailsPanel.CardDescription)
				maxLabel:setText("Max (Lvl " .. cardData.maxLevel .. "):")
				maxLabel:setColor("#A020F0")
				maxLabel:setMarginTop(10)
				maxLabel:setTextAutoResize(true)

				local maxDescLabel = g_ui.createWidget("Label", cardDetailsPanel.CardDescription)
				maxDescLabel:setText(maxDesc)
				maxDescLabel:setTextWrap(true)
				maxDescLabel:setTextAutoResize(true)
				maxDescLabel:setMarginTop(2)
			end
		else
			local lockedLabel = g_ui.createWidget("Label", cardDetailsPanel.CardDescription)
			lockedLabel:setText("This card is locked. Open crates to unlock it!")
			lockedLabel:setTextWrap(true)
			lockedLabel:setTextAutoResize(true)
			lockedLabel:setColor("#888888")
		end
	end

	if cardDetailsPanel.CardStatus then
		local isActive = false
		for slot, activeCardId in pairs(Codex.cachedActiveCards) do
			if activeCardId == Codex.selectedCardId then
				isActive = true
				break
			end
		end
		if isActive then
			cardDetailsPanel.CardStatus:setText("Status: ACTIVE")
			cardDetailsPanel.CardStatus:setColor("#00ff00")
		else
			cardDetailsPanel.CardStatus:setText("Status: INACTIVE")
			cardDetailsPanel.CardStatus:setColor("#888888")
		end
	end
end

------ Deck Tab ------

function Codex.setupDeckUI()
	local availableCardsPanel = Codex.UI.DeckPanel and Codex.UI.DeckPanel.AvailableCardsPanel
	local activeSlotsPanel = Codex.UI.DeckPanel and Codex.UI.DeckPanel.ActiveSlotsPanel
	
	if not availableCardsPanel or not activeSlotsPanel then return end
	
	availableCardsPanel:destroyChildren()
	for cardId, cardLevel in pairs(Codex.cachedCards) do
		local cardData = Codex.cachedCardDatabase[cardId]
		if cardData then
			if not Codex.passesFilters(cardId, cardLevel, cardData) then goto continue end
			
			local cardWidget = g_ui.createWidget("DeckCardEntry", availableCardsPanel)
			cardWidget:setId("available_card_" .. cardId)
			cardWidget.cardId = cardId
			cardWidget.cardData = cardData
			
			cardWidget:setImageSource(Codex.getCardBackgroundByRarity(cardData.rarity))
			cardWidget:setImageBorder(3)
			cardWidget:setImageRepeated(false)
			cardWidget:setImageFixedRatio(false)
			
			local cardIcon = cardWidget:getChildById("cardIcon")
			if cardIcon then cardIcon:setImageSource(Codex.cardImagesPath .. cardData.cardFrame .. ".png") end

			local cardName = cardWidget:getChildById("cardName")
			if cardName then
				cardName:setText(cardData.name)
				cardName:setColor(Codex.rarityColors[cardData.rarity] or "#ffffff")
			end

			local cardLevelLabel = cardWidget:getChildById("cardLevel")
			if cardLevelLabel then cardLevelLabel:setText("Level: " .. cardLevel .. "/" .. cardData.maxLevel) end

			if cardLevel < cardData.maxLevel then
				local currentExp = Codex.cachedCardsExp[cardId] or 0
				local expNeeded = Codex.cardExpTable[cardLevel] or 1
				local expPercent = math.min(100, math.floor((currentExp / expNeeded) * 100))
				
				local expBar = cardWidget:getChildById("expBar")
				if expBar then
					expBar:setPercent(expPercent)
					expBar:setVisible(true)
				end
				
				local expLabel = cardWidget:getChildById("expLabel")
				if expLabel then
					expLabel:setText(currentExp .. "/" .. expNeeded)
					expLabel:setVisible(true)
				end
			end

			local equipButton = cardWidget:getChildById("equipButton")
			if equipButton then
				equipButton:setEnabled(not Codex.isCardEquipped(cardId))
				equipButton.onClick = function() Codex.equipCard(cardId) end
			end
			
			cardWidget.onHoverChange = Codex.onCardHoverChange
			::continue::
		end
	end

	activeSlotsPanel:destroyChildren()
	local maxSlots = 6
	
	for i = 1, maxSlots do
		local slotWidget = g_ui.createWidget("ActiveSlot", activeSlotsPanel)
		slotWidget:setId("slot_" .. i)
		slotWidget.slotIndex = i
		
		local slotStatus = Codex.cachedSlotUnlockStatus and Codex.cachedSlotUnlockStatus[i]
		local isLocked = not (slotStatus and slotStatus.unlocked)
		local activeCardId = Codex.cachedActiveCards[i]
		
		local slotLabel = slotWidget:getChildById("slotLabel")
		local slotPlaceholder = slotWidget:getChildById("slotPlaceholder")
		local slotCardImage = slotWidget:getChildById("slotCardImage")
		local removeButton = slotWidget:getChildById("removeButton")
		local requirementLabel = slotWidget:getChildById("requirementLabel")
		
		if slotLabel then
			if isLocked then
				slotLabel:setText("Slot " .. i .. " (Locked)")
				slotLabel:setColor("#888888")
			else
				slotLabel:setText("Slot " .. i)
				slotLabel:setColor("#ffffff")
			end
		end
		
		if isLocked then
			if slotPlaceholder then slotPlaceholder:setOpacity(0.3) end
			if slotCardImage then slotCardImage:hide() end
			if removeButton then removeButton:hide() end
			slotWidget:setOpacity(0.5)
			if requirementLabel and slotStatus then
				requirementLabel:setText(slotStatus.requirement or "Locked")
				requirementLabel:show()
			end
		elseif activeCardId and activeCardId > 0 then
			local cardData = Codex.cachedCardDatabase[activeCardId]
			if cardData and slotCardImage then
				slotCardImage:setImageSource(Codex.cardImagesPath .. cardData.cardFrame .. ".png")
				slotCardImage:show()
				slotCardImage.cardId = activeCardId
				slotCardImage.cardData = cardData
				slotCardImage.onHoverChange = Codex.onCardHoverChange
				
				slotWidget.cardId = activeCardId
				slotWidget.cardData = cardData
				slotWidget.onHoverChange = Codex.onCardHoverChange
			end
			if slotPlaceholder then slotPlaceholder:hide() end
			if removeButton then
				removeButton:show()
				removeButton.onClick = function() Codex.removeCard(i) end
			end
		else
			if slotPlaceholder then slotPlaceholder:show() end
			if slotCardImage then slotCardImage:hide() end
			if removeButton then removeButton:hide() end
		end
	end
end

function Codex.equipCard(cardId)
	if Codex.isCardEquipped(cardId) then
		Codex.setupMessage("Already Equipped", "This card is already equipped!")
		return
	end
	
	-- Find first unlocked and empty slot
	for i = 1, 6 do
		local slotStatus = Codex.cachedSlotUnlockStatus and Codex.cachedSlotUnlockStatus[i]
		local isUnlocked = slotStatus and slotStatus.unlocked
		if isUnlocked and (not Codex.cachedActiveCards[i] or Codex.cachedActiveCards[i] == 0) then
			Codex.sendOpcode({ topic = "activate-card-request", cardId = cardId, slotIndex = i })
			return
		end
	end
	Codex.setupMessage("No Free Slots", "All unlocked slots are full!")
end

function Codex.removeCard(slotIndex)
	Codex.sendOpcode({ topic = "deactivate-card-request", slotIndex = slotIndex })
end

function Codex.updateActiveSlots()
	local activeSlotsPanel = Codex.UI.DeckPanel and Codex.UI.DeckPanel.ActiveSlotsPanel
	local availableCardsPanel = Codex.UI.DeckPanel and Codex.UI.DeckPanel.AvailableCardsPanel
	if not activeSlotsPanel then return end
	
	for i = 1, 6 do
		local slotWidget = activeSlotsPanel:getChildById("slot_" .. i)
		if slotWidget then
			local slotStatus = Codex.cachedSlotUnlockStatus and Codex.cachedSlotUnlockStatus[i]
			local isLocked = not (slotStatus and slotStatus.unlocked)
			local activeCardId = Codex.cachedActiveCards[i]
			
			local slotPlaceholder = slotWidget:getChildById("slotPlaceholder")
			local slotCardImage = slotWidget:getChildById("slotCardImage")
			local removeButton = slotWidget:getChildById("removeButton")
			local requirementLabel = slotWidget:getChildById("requirementLabel")
			
			if not isLocked and activeCardId and activeCardId > 0 then
				local cardData = Codex.cachedCardDatabase[activeCardId]
				if cardData then
					if slotPlaceholder then slotPlaceholder:hide() end
					if requirementLabel then requirementLabel:hide() end
					if slotCardImage then
						slotCardImage:setImageSource(Codex.cardImagesPath .. cardData.cardFrame .. ".png")
						slotCardImage:show()
						slotCardImage.cardId = activeCardId
						slotCardImage.cardData = cardData
						slotCardImage.onHoverChange = Codex.onCardHoverChange
					end
					slotWidget.cardId = activeCardId
					slotWidget.cardData = cardData
					slotWidget.onHoverChange = Codex.onCardHoverChange
					if removeButton then
						removeButton:show()
						removeButton:setEnabled(true)
						removeButton.onClick = function() Codex.removeCard(i) end
					end
				end
			else
				if slotPlaceholder then slotPlaceholder:show() end
				if slotCardImage then
					slotCardImage:hide()
					slotCardImage.onHoverChange = nil
				end
				slotWidget.onHoverChange = nil
				if removeButton then removeButton:hide() end
				
				-- Show requirement label if slot is locked
				if isLocked and requirementLabel and slotStatus then
					requirementLabel:setText(slotStatus.requirement or "Locked")
					requirementLabel:show()
				elseif requirementLabel then
					requirementLabel:hide()
				end
			end
		end
	end
	
	if availableCardsPanel then
		for _, cardWidget in ipairs(availableCardsPanel:getChildren()) do
			local cardId = cardWidget.cardId
			if cardId then
				local equipButton = cardWidget:getChildById("equipButton")
				if equipButton then
					equipButton:setEnabled(not Codex.isCardEquipped(cardId))
				end
			end
		end
	end
end

------ Crates Tab ------

function Codex.setupCratesUI()
	local cratesPanel = Codex.UI.CratesPanel
	if not cratesPanel then return end
	
	if not Codex.cachedCrateDatabase or not Codex.cachedCrateDatabase[1] then
		Codex.cachedCrateDatabase = {
			[1] = { id = 1, name = "Bronze Crate", craftCost = 100, rarityWeights = { common = 70, rare = 20, epic = 8, legendary = 2 } },
			[2] = { id = 2, name = "Silver Crate", craftCost = 200, rarityWeights = { common = 60, rare = 25, epic = 10, legendary = 5 } },
			[3] = { id = 3, name = "Golden Crate", craftCost = 350, rarityWeights = { common = 30, rare = 30, epic = 30, legendary = 10 } }
		}
	end

	local selectorPanel = cratesPanel:getChildById("CrateSelectorPanel")
	if not selectorPanel then return end
	
	local bronzeButton = selectorPanel:getChildById("BronzeCrateButton")
	local silverButton = selectorPanel:getChildById("SilverCrateButton")
	local goldenButton = selectorPanel:getChildById("GoldenCrateButton")

	if bronzeButton then
		bronzeButton:setText("\n\n\n" .. "     BRONZE CRATE\nx" .. Codex.cachedBronzeCrates)
		bronzeButton.onClick = function() Codex.selectCrateType(1) end
	end
	if silverButton then
		silverButton:setText("\n\n\n" .. "     SILVER CRATE\nx" .. Codex.cachedSilverCrates)
		silverButton.onClick = function() Codex.selectCrateType(2) end
	end
	if goldenButton then
		goldenButton:setText("\n\n\n" .. "     GOLDEN CRATE\nx" .. Codex.cachedGoldenCrates)
		goldenButton.onClick = function() Codex.selectCrateType(3) end
	end

	local craftingPanel = cratesPanel:getChildById("CraftingPanel")
	if not craftingPanel then return end
	
	local craftBronze = craftingPanel:getChildById("CraftBronzeButton")
	local craftSilver = craftingPanel:getChildById("CraftSilverButton")
	local craftGolden = craftingPanel:getChildById("CraftGoldenButton")

	if craftBronze then craftBronze.onClick = function() Codex.craftCrate(craftBronze, 1) end end
	if craftSilver then craftSilver.onClick = function() Codex.craftCrate(craftSilver, 2) end end
	if craftGolden then craftGolden.onClick = function() Codex.craftCrate(craftGolden, 3) end end
	Codex.cratesHandlersConnected = true

	Codex.selectCrateType(Codex.selectedCrateId or 1)
end

function Codex.selectCrateType(crateId)
	Codex.selectedCrateId = crateId
	local crateData = Codex.cachedCrateDatabase[crateId]
	local cratesPanel = Codex.UI.CratesPanel
	if not cratesPanel or not crateData then return end

	local displayPanel = cratesPanel:getChildById("CrateDisplayPanel")
	if not displayPanel then return end

	local imageMap = {
		[1] = "/images/ui/windows/card_window_normal",
		[2] = "/images/ui/windows/card_window_rare",
		[3] = "/images/ui/windows/card_window_legendary"
	}
	if imageMap[crateId] then displayPanel:setImageSource(imageMap[crateId]) end

	local nameLabel = displayPanel:getChildById("SelectedCrateName")
	if nameLabel then nameLabel:setText(crateData.name:upper()) end

	local ownedLabel = displayPanel:getChildById("CrateOwnedCount")
	if ownedLabel then
		local ownedCount = (crateId == 1 and Codex.cachedBronzeCrates) or (crateId == 2 and Codex.cachedSilverCrates) or (crateId == 3 and Codex.cachedGoldenCrates) or 0
		ownedLabel:setText("You own: " .. ownedCount)
	end

	local barsPanel = displayPanel:getChildById("ProbabilityBarsPanel")
	if barsPanel then
		barsPanel:destroyChildren()
		if crateData.rarityWeights then
			local rarityOrder = {"common", "rare", "epic", "legendary"}
			for _, rarity in ipairs(rarityOrder) do
				local weight = crateData.rarityWeights[rarity]
				if weight and weight > 0 then
					Codex.createProbabilityBar(barsPanel, rarity, weight)
				end
			end
			if crateData.bonusEssences then
				Codex.createBonusEssencesBar(barsPanel, crateData.bonusEssences.amount, crateData.bonusEssences.chance)
			end
		end
	end

	local openButton = displayPanel:getChildById("OpenCrateButton")
	if openButton then
		local ownedCount = (crateId == 1 and Codex.cachedBronzeCrates) or (crateId == 2 and Codex.cachedSilverCrates) or (crateId == 3 and Codex.cachedGoldenCrates) or 0
		openButton:setEnabled(ownedCount > 0)
		openButton.onClick = function()
			if Codex.crateAnimationInProgress then return end
			Codex.sendOpcode({ topic = "open-crate-request", crateId = crateId })
		end
	end
end

function Codex.createProbabilityBar(container, rarity, weight)
	local barContainer = g_ui.createWidget("UIWidget", container)
	barContainer:setSize({width = 400, height = 25})
	barContainer:setMarginTop(5)
	
	local label = g_ui.createWidget("Label", barContainer)
	label:setText(rarity:sub(1,1):upper() .. rarity:sub(2))
	label:setColor(Codex.rarityColors[rarity] or "#FFFFFF")
	label:addAnchor(AnchorLeft, "parent", AnchorLeft)
	label:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	label:setWidth(120)
	label:setTextAlign(AlignRight)
	
	local barBg = g_ui.createWidget("UIWidget", barContainer)
	barBg:addAnchor(AnchorLeft, "parent", AnchorLeft)
	barBg:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	barBg:setMarginLeft(130)
	barBg:setSize({width = 170, height = 15})
	barBg:setBackgroundColor("#2a2a2a")
	
	local barFill = g_ui.createWidget("UIWidget", barBg)
	barFill:addAnchor(AnchorLeft, "parent", AnchorLeft)
	barFill:addAnchor(AnchorTop, "parent", AnchorTop)
	barFill:addAnchor(AnchorBottom, "parent", AnchorBottom)
	barFill:setWidth(math.floor(170 * weight / 100))
	barFill:setBackgroundColor(Codex.rarityColors[rarity] or "#FFFFFF")
	
	local percentLabel = g_ui.createWidget("Label", barContainer)
	percentLabel:setText(weight .. "%")
	percentLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
	percentLabel:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	percentLabel:setMarginLeft(310)
	percentLabel:setColor("#FFFFFF")
end

function Codex.createBonusEssencesBar(container, amount, chance)
	local barContainer = g_ui.createWidget("UIWidget", container)
	barContainer:setSize({width = 400, height = 25})
	barContainer:setMarginTop(15)
	
	local label = g_ui.createWidget("Label", barContainer)
	label:setText("Bonus Essences")
	label:setColor("#A020F0")
	label:addAnchor(AnchorLeft, "parent", AnchorLeft)
	label:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	label:setWidth(120)
	label:setTextAlign(AlignRight)
	
	local barBg = g_ui.createWidget("UIWidget", barContainer)
	barBg:addAnchor(AnchorLeft, "parent", AnchorLeft)
	barBg:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	barBg:setMarginLeft(130)
	barBg:setSize({width = 170, height = 15})
	barBg:setBackgroundColor("#2a2a2a")
	
	local barFill = g_ui.createWidget("UIWidget", barBg)
	barFill:addAnchor(AnchorLeft, "parent", AnchorLeft)
	barFill:addAnchor(AnchorTop, "parent", AnchorTop)
	barFill:addAnchor(AnchorBottom, "parent", AnchorBottom)
	barFill:setWidth(math.floor(170 * chance / 100))
	barFill:setBackgroundColor("#A020F0")
	
	local percentLabel = g_ui.createWidget("Label", barContainer)
	percentLabel:setText(chance .. "%")
	percentLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
	percentLabel:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	percentLabel:setMarginLeft(310)
	percentLabel:setColor("#A020F0")
end

function Codex.craftCrate(buttonWidget, crateId)
	if Codex.craftingInProgress then return end
	Codex.craftingInProgress = true
	buttonWidget:setEnabled(false)
	Codex.sendOpcode({ topic = "craft-crate-request", crateId = crateId })
	scheduleEvent(function()
		Codex.craftingInProgress = false
		buttonWidget:setEnabled(true)
	end, 600)
end

function Codex.showEssencesBonusOverlay(amount, crateId)
	local overlay = Codex.UI:getChildById("EssencesBonusOverlay")
	local content = overlay and overlay:getChildById("EssencesBonusContent")
	if not content then return end

	local essenceImage = content:getChildById("BonusEssenceImage")
	if essenceImage then
		local crateNames = {[1] = "bronze", [2] = "silver", [3] = "golden"}
		local imagePath = "/images/codex/" .. (crateNames[crateId] or "bronze") .. "_" .. amount .. ".png"
		essenceImage:setImageSource(imagePath)
		essenceImage:setOpacity(0)
		
		essenceImage.onClick = function()
			g_effects.fadeOut(essenceImage, 300)
			scheduleEvent(function()
				overlay:hide()
				if Codex.currentTab == Codex.TAB_COLLECTION then Codex.setupCollectionUI() end
			end, 300)
		end
	end

	local amountLabel = content:getChildById("BonusEssenceAmount")
	if amountLabel then amountLabel:setText("+" .. amount .. " Codex Essences!") end

	overlay:show()
	overlay:raise()
	overlay:focus()

	if essenceImage then scheduleEvent(function() g_effects.fadeIn(essenceImage, 500) end, 100) end
end

function Codex.showCardObtainedOverlay(cardId, cardLevel, rarityColor, bonusEssences, crateId)
	local overlay = Codex.UI:getChildById("CardObtainedOverlay")
	local content = overlay and overlay:getChildById("CardObtainedContent")
	if not content then return end

	local cardData = Codex.cachedCardDatabase[cardId]
	if not cardData then return end

	local cardImage = content:getChildById("ObtainedCardImage")
	if cardImage then
		cardImage:setImageSource(Codex.cardImagesPath .. cardData.cardFrame .. ".png")
		cardImage:setOpacity(0)
		cardImage.cardId = cardId
		cardImage.cardData = cardData
		cardImage.onHoverChange = Codex.onCardHoverChange
	end

	local nameLabel = content:getChildById("ObtainedCardName")
	if nameLabel then
		nameLabel:setText(cardData.name)
		nameLabel:setOpacity(0)
		nameLabel:setColor(rarityColor or Codex.rarityColors[cardData.rarity] or "#FFFFFF")
	end

	local levelLabel = content:getChildById("ObtainedCardLevel")
	if levelLabel then
		levelLabel:setText((cardLevel > 1) and ("LEVEL UP! -> Level " .. cardLevel) or ("NEW CARD! Level " .. cardLevel))
		levelLabel:setOpacity(0)
		levelLabel:setColor(rarityColor or Codex.rarityColors[cardData.rarity] or "#FFFFFF")
	end

	overlay:show()
	overlay:raise()
	overlay:focus()

	Codex.crateAnimationInProgress = true

	local suspenseEffect = g_ui.createWidget('CardSuspenseEffect', overlay)
	if suspenseEffect then suspenseEffect:raise() end
	
	scheduleEvent(function()
		Codex.crateAnimationInProgress = false
		if suspenseEffect then suspenseEffect:destroy() end
		
		if cardImage then
			g_effects.fadeIn(cardImage, 500)
			if nameLabel then g_effects.fadeIn(nameLabel, 500) end
			if levelLabel then g_effects.fadeIn(levelLabel, 500) end
			
			local closeOverlay = function()
				if cardImage then g_effects.fadeOut(cardImage, 300) end
				if nameLabel then g_effects.fadeOut(nameLabel, 300) end
				if levelLabel then g_effects.fadeOut(levelLabel, 300) end
				
				scheduleEvent(function()
					overlay:hide()
					if bonusEssences and bonusEssences > 0 and crateId then
						Codex.showEssencesBonusOverlay(bonusEssences, crateId)
					else
						if Codex.currentTab == Codex.TAB_COLLECTION then Codex.setupCollectionUI() end
					end
				end, 300)
			end
			
			cardImage.onClick = closeOverlay
			
			local particle = g_ui.createWidget('CardObtainedParticles', cardImage)
			if particle then
				particle:fill('parent')
				particle:setOpacity(0.75)
				particle:setFocusable(true)
				particle.onClick = closeOverlay
				scheduleEvent(function() if particle then particle:destroy() end end, 1500)
			end
			
			local effectWidget = g_ui.createWidget('CardEffectWidget', cardImage)
			if effectWidget then
				effectWidget:fill('parent')
				effectWidget:setFocusable(true)
				effectWidget.onClick = closeOverlay
				scheduleEvent(function() if effectWidget then effectWidget:destroy() end end, 600)
			end
		end
	end, 2000)
end

------ Tooltip Management ------

function Codex.moveToolTip()
	if not Codex.Tooltip or not Codex.Tooltip:isVisible() then return end
	local pos = g_window.getMousePosition()
	local windowSize = g_window.getSize()
	local tipSize = Codex.Tooltip:getSize()

	pos.x = pos.x + 1
	pos.y = pos.y + 1

	if windowSize.width - (pos.x + tipSize.width) < 10 then pos.x = pos.x - tipSize.width - 3 else pos.x = pos.x + 10 end
	if windowSize.height - (pos.y + tipSize.height) < 10 then pos.y = pos.y - tipSize.height - 3 else pos.y = pos.y + 10 end

	Codex.Tooltip:setPosition(pos)
	Codex.Tooltip:raise()
end

function Codex.applyTooltip(cardData, cardLevel)
	Codex.Tooltip:setText(cardData.name)
	Codex.Tooltip:setColor(Codex.rarityColors[cardData.rarity] or "#ffffff")
	
	if Codex.Tooltip.description then
		Codex.Tooltip.description:setText("Level " .. cardLevel .. "/" .. cardData.maxLevel .. " - " .. (cardData.rarity or "common"):upper())
		Codex.Tooltip.description:setColor("#ffffff")
	end
	
	if Codex.Tooltip.trigger then
		Codex.Tooltip.trigger:destroyChildren()
		local triggerIconPath = Codex.triggerIcons[cardData.trigger]
		if triggerIconPath then
			local iconWidget = g_ui.createWidget("UIWidget", Codex.Tooltip.trigger)
			iconWidget:setImageSource(triggerIconPath)
			iconWidget:setSize({width = 16, height = 16})
			iconWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			iconWidget:addAnchor(AnchorTop, "parent", AnchorTop)
			
			Codex.Tooltip.trigger:setText(cardData.trigger)
			Codex.Tooltip.trigger:setColor("#ffaa00")
			Codex.Tooltip.trigger:setTextOffset({x = 0, y = 14})
		else
			Codex.Tooltip.trigger:setText(cardData.trigger)
			Codex.Tooltip.trigger:setColor("#ffaa00")
			Codex.Tooltip.trigger:setTextOffset({x = 0, y = 0})
		end
	end
	
	if Codex.Tooltip.cardDesc then
		local desc = cardData.description[cardLevel] or cardData.description[1] or "No description"
		Codex.Tooltip.cardDesc:setText(desc)
		Codex.Tooltip.cardDesc:setColor("#ffffff")
	end
	
	if Codex.Tooltip.expBar and Codex.Tooltip.expLabel then
		if cardLevel < cardData.maxLevel then
			local currentExp = Codex.cachedCardsExp[cardData.id] or 0
			local expNeeded = Codex.cardExpTable[cardLevel] or 1
			local expPercent = math.min(100, math.floor((currentExp / expNeeded) * 100))
			
			Codex.Tooltip.expBar:setPercent(expPercent)
			Codex.Tooltip.expBar:show()
			Codex.Tooltip.expLabel:setText(currentExp .. "/" .. expNeeded)
			Codex.Tooltip.expLabel:setColor("#ffffff")
			Codex.Tooltip.expLabel:show()
		else
			Codex.Tooltip.expBar:hide()
			Codex.Tooltip.expLabel:hide()
		end
	end
	
	scheduleEvent(function()
		local descHeight = Codex.Tooltip.description and Codex.Tooltip.description:getHeight() or 0
		local triggerHeight = Codex.Tooltip.trigger and Codex.Tooltip.trigger:getHeight() or 0
		local cardDescHeight = Codex.Tooltip.cardDesc and Codex.Tooltip.cardDesc:getHeight() or 0
		local expBarHeight = (Codex.Tooltip.expBar and Codex.Tooltip.expBar:isVisible()) and 18 or 0
		local totalHeight = 70 + descHeight + triggerHeight + cardDescHeight + expBarHeight
		Codex.Tooltip:setHeight(math.max(totalHeight, 100))
	end, 10)
end

function Codex.onCardHoverChange(widget, hovered)
	if hovered and widget.cardData then
		local cardLevel = Codex.cachedCards[widget.cardId] or 1
		Codex.applyTooltip(widget.cardData, cardLevel)
		Codex.Tooltip:show()
		connect(rootWidget, { onMouseMove = Codex.moveToolTip })
	else
		Codex.Tooltip:hide()
		disconnect(rootWidget, { onMouseMove = Codex.moveToolTip })
	end
end

------ Upgrade Tab ------

function Codex.setupUpgradeUI()
	local upgradePanel = Codex.UI.UpgradePanel
	local cardGrid = upgradePanel and upgradePanel:getChildById("UpgradeCardGrid")
	if not cardGrid then return end
	
	cardGrid:destroyChildren()
	
	local ownedCards = {}
	for cardId, level in pairs(Codex.cachedCards) do
		if level > 0 then table.insert(ownedCards, cardId) end
	end
	table.sort(ownedCards)
	
	for _, cardId in ipairs(ownedCards) do
		local cardData = Codex.cachedCardDatabase[cardId]
		if cardData then
			local cardLevel = Codex.cachedCards[cardId] or 0
			if not Codex.passesFilters(cardId, cardLevel, cardData) then goto continue end
			
			local cardWidget = g_ui.createWidget("UpgradeCardEntry", cardGrid)
			if cardWidget then
				cardWidget:setId("upgrade_card_" .. cardId)
				cardWidget.cardId = cardId
				cardWidget.cardData = cardData
				
				local cardImage = cardWidget:getChildById("cardImage")
				if cardImage then
					cardImage:setImageSource(Codex.cardImagesPath .. cardData.cardFrame .. ".png")
					cardImage:setImageColor("#ffffff")
					cardImage:setOpacity(1.0)
				end
				
				local nameLabel = cardWidget:getChildById("cardNameLabel")
				if nameLabel then
					nameLabel:setText(cardData.name)
					nameLabel:setColor(Codex.rarityColors[cardData.rarity] or "#ffffff")
				end
				
				local levelLabel = cardWidget:getChildById("cardLevelLabel")
				if levelLabel then
					levelLabel:setText("Lv " .. cardLevel .. "/" .. cardData.maxLevel)
				end
				
				local expBar = cardWidget:getChildById("miniExpBar")
				if expBar and cardLevel < cardData.maxLevel then
					local currentExp = Codex.cachedCardsExp[cardId] or 0
					local expNeeded = Codex.cardExpTable[cardLevel] or 1
					local expPercent = math.min(100, math.floor((currentExp / expNeeded) * 100))
					expBar:setPercent(expPercent)
					expBar:setVisible(true)
				end
				
				cardWidget.onClick = function() Codex.selectUpgradeCard(cardId) end
			end
			::continue::
		end
	end
	
	if Codex.selectedUpgradeCardId and Codex.cachedCards[Codex.selectedUpgradeCardId] then
		Codex.selectUpgradeCard(Codex.selectedUpgradeCardId)
	elseif #ownedCards > 0 then
		Codex.selectUpgradeCard(ownedCards[1])
	else
		Codex.clearUpgradeDetails()
	end
end

function Codex.selectUpgradeCard(cardId)
	Codex.selectedUpgradeCardId = cardId
	local upgradePanel = Codex.UI.UpgradePanel
	local detailsPanel = upgradePanel and upgradePanel:getChildById("UpgradeDetailsPanel")
	if not detailsPanel then return end
	
	local cardData = Codex.cachedCardDatabase[cardId]
	local cardLevel = Codex.cachedCards[cardId] or 0
	local currentExp = Codex.cachedCardsExp[cardId] or 0
	local expNeeded = Codex.cardExpTable[cardLevel] or 0
	
	if not cardData then return end
	
	local cardImage = detailsPanel:getChildById("UpgradeCardImage")
	if cardImage then
		cardImage:setImageSource(Codex.cardImagesPath .. cardData.cardFrame .. ".png")
		cardImage:setVisible(true)
	end
	
	local cardName = detailsPanel:getChildById("UpgradeCardName")
	if cardName then
		cardName:setText(cardData.name)
		cardName:setColor(Codex.rarityColors[cardData.rarity] or "#ffffff")
	end
	
	local cardLevelLabel = detailsPanel:getChildById("UpgradeCardLevel")
	if cardLevelLabel then cardLevelLabel:setText("Level: " .. cardLevel .. " / " .. cardData.maxLevel) end
	
	local expBar = detailsPanel:getChildById("UpgradeExpBar")
	local expText = detailsPanel:getChildById("UpgradeExpText")
	if expBar and expText then
		expBar:setBackgroundColor("#A020F0")
		if cardLevel < cardData.maxLevel then
			local expPercent = math.min(100, math.floor((currentExp / expNeeded) * 100))
			expBar:setPercent(expPercent)
			expText:setText(currentExp .. " / " .. expNeeded .. " EXP")
		else
			expBar:setPercent(100)
			expText:setText("MAX LEVEL")
		end
	end
	
	local descLabel = detailsPanel:getChildById("UpgradeCardDescription")
	if descLabel and cardData.description then
		descLabel:setText(cardData.description[cardLevel] or cardData.description[1] or "-")
	end
	
	local nextLevelDesc = detailsPanel:getChildById("UpgradeNextLevelDescription")
	if nextLevelDesc and cardData.description then
		if cardLevel < cardData.maxLevel then
			local nextDesc = cardData.description[cardLevel + 1]
			if nextDesc then
				nextLevelDesc:setText("Next Level: " .. nextDesc)
				nextLevelDesc:setVisible(true)
			else nextLevelDesc:setVisible(false) end
		else nextLevelDesc:setVisible(false) end
	end
	
	local feedButton = detailsPanel:getChildById("FeedExpButton")
	local maxLevelLabel = detailsPanel:getChildById("MaxLevelLabel")
	
	if feedButton and maxLevelLabel then
		if cardLevel >= cardData.maxLevel then
			feedButton:setEnabled(false)
			feedButton:setVisible(false)
			maxLevelLabel:setVisible(true)
		else
			feedButton:setEnabled(true)
			feedButton:setVisible(true)
			maxLevelLabel:setVisible(false)
			feedButton.onClick = function() Codex.sendOpcode({ topic = "feed-card-exp", cardId = cardId }) end
		end
	end
end

function Codex.clearUpgradeDetails()
	local upgradePanel = Codex.UI.UpgradePanel
	local detailsPanel = upgradePanel and upgradePanel:getChildById("UpgradeDetailsPanel")
	if not detailsPanel then return end
	
	local cardImage = detailsPanel:getChildById("UpgradeCardImage")
	if cardImage then cardImage:setVisible(false) end
	
	local cardName = detailsPanel:getChildById("UpgradeCardName")
	if cardName then cardName:setText("Select a card") end
	
	local cardLevel = detailsPanel:getChildById("UpgradeCardLevel")
	if cardLevel then cardLevel:setText("Level: -") end
	
	local expBar = detailsPanel:getChildById("UpgradeExpBar")
	if expBar then expBar:setPercent(0) end
	
	local expText = detailsPanel:getChildById("UpgradeExpText")
	if expText then expText:setText("0 / 0 EXP") end
	
	local descLabel = detailsPanel:getChildById("UpgradeCardDescription")
	if descLabel then descLabel:setText("-") end
	
	local feedButton = detailsPanel:getChildById("FeedExpButton")
	if feedButton then
		feedButton:setEnabled(false)
		feedButton:setVisible(true)
	end
	
	local maxLevelLabel = detailsPanel:getChildById("MaxLevelLabel")
	if maxLevelLabel then maxLevelLabel:setVisible(false) end
end

------ Dialogs and Messages ------

function Codex.setupDialogButtons()
	if Codex.UI.MessageBase and Codex.UI.MessageBase.ConfirmButton then
		Codex.UI.MessageBase.ConfirmButton.onClick = function()
			Codex.UI.MessageBase:setVisible(false)
			Codex.UI.LockUI:setVisible(false)
		end
	end

	if Codex.UI then
		Codex.UI.onKeyDown = function(widget, keyCode)
			if keyCode == KeyEnter and Codex.UI.MessageBase and Codex.UI.MessageBase:isVisible() then
				Codex.UI.MessageBase:setVisible(false)
				Codex.UI.LockUI:setVisible(false)
				return true
			end
			return false
		end
	end
end

function Codex.setupMessage(title, message)
	if not Codex.UI.MessageBase or not Codex.UI.LockUI then return end
	Codex.UI.LockUI:setVisible(true)
	Codex.UI.MessageBase:setVisible(true)
	Codex.UI.MessageBase:setText(title)
	Codex.UI.MessageBase.Text:setText(message)
	local height = Codex.UI.MessageBase.Text:getTextSize().height + 150
	Codex.UI.MessageBase:setHeight(height)
end
