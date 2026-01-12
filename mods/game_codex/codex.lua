
------ Initialization and Termination

function Codex.init()
	connect(
		g_game,
		{
			onGameStart = Codex.onGameStart,
			onGameEnd = Codex.onGameEnd
		}
	)
	ProtocolGame.registerExtendedOpcode(Codex.opCode, Codex.onExtendedOpcode)
	if g_game.isOnline() then
		Codex.onGameStart()
	end
end

function Codex.terminate()
	disconnect(
		g_game,
		{
			onGameStart = Codex.onGameStart,
			onGameEnd = Codex.onGameEnd
		}
	)
	ProtocolGame.unregisterExtendedOpcode(Codex.opCode)
	Codex.onGameEnd()
end

function Codex.onGameStart()
	Codex.UI = g_ui.displayUI("codex")
	if not Codex.UI then
		print("[Codex] ERROR: Failed to load codex.otui")
		return
	end
	
	Codex.UI:hide()
	
	print("[Codex] UI loaded successfully")

	if not Codex.Button then
		Codex.Button = modules.game_mainpanel.addStoreButton("Codex",
		tr("Codex"), '/images/options/large_stats', Codex.toggle, false, 5)
		Codex.Button:setOn(false)
	end

	Codex.Tooltip = g_ui.displayUI("CardTooltip")
	Codex.Tooltip:hide()

	-- Initialize cache FIRST
	Codex.cachedCards = {}
	Codex.cachedCardsExp = {}
	Codex.cachedActiveCards = {}
	Codex.cachedEssences = 0
	Codex.cachedMaxSlots = 3
	Codex.cachedCardDatabase = {}
	Codex.cachedCrateDatabase = {}
	Codex.currentTab = Codex.TAB_COLLECTION

	Codex.setupDialogButtons()
	Codex.setupTabButtons()
	
	-- Request initial data from server
	Codex.sendOpcode({ topic = "base-data-request" })
end

function Codex.onGameEnd()
	if Codex.Tooltip then
		Codex.Tooltip:destroy()
		Codex.Tooltip = nil
	end

	if Codex.Button then
		Codex.Button:destroy()
		Codex.Button = nil
	end

	if Codex.UI then
		Codex.UI:destroy()
		Codex.UI = nil
	end
end

------ UI Management and Toggling

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
	Codex.switchTab(Codex.currentTab)
end

function Codex.hide()
	Codex.UI:hide()
	Codex.Button:setOn(false)
end

------ Tab Management

function Codex.setupTabButtons()
	print("[Codex] Setting up tab buttons...")
	
	-- Get TabsPanel first
	local tabsPanel = Codex.UI:getChildById("TabsPanel")
	if not tabsPanel then
		print("[Codex] ERROR: TabsPanel not found!")
		return
	end
	
	-- Get buttons from TabsPanel
	local collectionTab = tabsPanel:getChildById("CollectionTab")
	local deckTab = tabsPanel:getChildById("DeckTab")
	local cratesTab = tabsPanel:getChildById("CratesTab")
	local essencesLabel = tabsPanel:getChildById("EssencesLabel")
	
	print("[Codex] CollectionTab exists: " .. tostring(collectionTab ~= nil))
	print("[Codex] DeckTab exists: " .. tostring(deckTab ~= nil))
	print("[Codex] CratesTab exists: " .. tostring(cratesTab ~= nil))
	print("[Codex] EssencesLabel exists: " .. tostring(essencesLabel ~= nil))
	
	if collectionTab then
		collectionTab.onClick = function() 
			print("[Codex] Collection tab clicked!")
			Codex.switchTab(Codex.TAB_COLLECTION) 
		end
	end
	if deckTab then
		deckTab.onClick = function() 
			print("[Codex] Deck tab clicked!")
			Codex.switchTab(Codex.TAB_DECK) 
		end
	end
	if cratesTab then
		cratesTab.onClick = function() 
			print("[Codex] Crates tab clicked!")
			Codex.switchTab(Codex.TAB_CRATES) 
		end
	end
	
	-- Store references for later use
	Codex.UI.CollectionTab = collectionTab
	Codex.UI.DeckTab = deckTab
	Codex.UI.CratesTab = cratesTab
	Codex.UI.EssencesLabel = essencesLabel
	
	-- Update essences display immediately
	if essencesLabel then
		essencesLabel:setText("Codex Essences: " .. Codex.cachedEssences)
	end
end

function Codex.switchTab(tabId)
	Codex.currentTab = tabId
	
	print("[Codex] Switching to tab: " .. tabId)

	-- Get panels
	local collectionPanel = Codex.UI:getChildById("CollectionPanel")
	local deckPanel = Codex.UI:getChildById("DeckPanel")
	local cratesPanel = Codex.UI:getChildById("CratesPanel")

	-- Hide all panels
	if collectionPanel then collectionPanel:hide() end
	if deckPanel then deckPanel:hide() end
	if cratesPanel then cratesPanel:hide() end

	-- Reset tab button states
	if Codex.UI.CollectionTab then Codex.UI.CollectionTab:setOn(false) end
	if Codex.UI.DeckTab then Codex.UI.DeckTab:setOn(false) end
	if Codex.UI.CratesTab then Codex.UI.CratesTab:setOn(false) end

	-- Show selected panel and activate tab
	if tabId == Codex.TAB_COLLECTION then
		print("[Codex] Showing Collection panel")
		if collectionPanel then collectionPanel:show() end
		if Codex.UI.CollectionTab then Codex.UI.CollectionTab:setOn(true) end
		Codex.setupCollectionUI()
	elseif tabId == Codex.TAB_DECK then
		print("[Codex] Showing Deck panel")
		print("[Codex] DeckPanel exists: " .. tostring(deckPanel ~= nil))
		if deckPanel then 
			deckPanel:show()
			print("[Codex] DeckPanel shown")
		end
		if Codex.UI.DeckTab then Codex.UI.DeckTab:setOn(true) end
		Codex.setupDeckUI()
	elseif tabId == Codex.TAB_CRATES then
		print("[Codex] Showing Crates panel")
		if cratesPanel then cratesPanel:show() end
		if Codex.UI.CratesTab then Codex.UI.CratesTab:setOn(true) end
		Codex.setupCratesUI()
	end
	
	-- Store panel references
	Codex.UI.CollectionPanel = collectionPanel
	Codex.UI.DeckPanel = deckPanel
	Codex.UI.CratesPanel = cratesPanel
end

------ Collection Tab

function Codex.setupCollectionUI()
	local collectionGrid = Codex.UI.CollectionPanel and Codex.UI.CollectionPanel.CollectionGrid
	if not collectionGrid then 
		print("[Codex] CollectionGrid not found!")
		return 
	end
	
	collectionGrid:destroyChildren()
	
	print("[Codex] Setting up collection UI...")
	print("[Codex] Card database size: " .. table.size(Codex.cachedCardDatabase))
	print("[Codex] Player cards size: " .. table.size(Codex.cachedCards))

	for cardId, cardData in pairs(Codex.cachedCardDatabase) do
		print("[Codex] Creating card widget for cardId: " .. cardId .. " - " .. cardData.name)
		
		local cardWidget = g_ui.createWidget("CardEntry", collectionGrid)
		if not cardWidget then
			print("[Codex] ERROR: Failed to create CardEntry widget!")
			return
		end
		
		local cardLevel = Codex.cachedCards[cardId] or 0
		local isUnlocked = cardLevel > 0

		cardWidget:setId("card_" .. cardId)
		cardWidget.cardId = cardId
		cardWidget.cardData = cardData

		-- Set card image
		local cardImage = cardWidget:getChildById("cardImage")
		if cardImage then
			local imagePath = Codex.cardImagesPath .. cardData.cardFrame .. ".png"
			cardImage:setImageSource(imagePath)
			
			if isUnlocked then
				cardImage:setImageColor("#ffffff")
				cardImage:setOpacity(1.0)
			else
				cardImage:setImageColor("#404040")
				cardImage:setOpacity(0.5)
			end
		end

		-- Add lock icon if locked
		if not isUnlocked then
			local lockIcon = g_ui.createWidget("CardLockIcon", cardWidget)
		end

		-- Add level label
		local levelLabel = g_ui.createWidget("CardLevelLabel", cardWidget)
		if levelLabel then
			if isUnlocked then
				levelLabel:setText(cardLevel .. "/" .. cardData.maxLevel)
			else
				levelLabel:setText("LOCKED")
			end
		end

		-- Click handler
		cardWidget.onClick = function()
			Codex.selectCard(cardId)
		end

		-- Hover handler
		cardWidget.onHoverChange = Codex.onCardHoverChange
	end
	
	print("[Codex] Collection UI setup complete!")
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

	-- Update card image header
	local cardImageHeader = cardDetailsPanel:getChildById("CardImageHeader")
	if cardImageHeader then
		local imagePath = Codex.cardImagesPath .. cardData.cardFrame .. ".png"
		cardImageHeader:setImageSource(imagePath)
		cardImageHeader:show()
		
		if not isUnlocked then
			cardImageHeader:setOpacity(0.5)
			cardImageHeader:setImageColor("#404040")
		else
			cardImageHeader:setOpacity(1.0)
			cardImageHeader:setImageColor("#ffffff")
		end
	end

	-- Update card name
	if cardDetailsPanel.CardName then
		cardDetailsPanel.CardName:setText(cardData.name)
		local rarityColor = Codex.rarityColors[cardData.rarity] or "#ffffff"
		cardDetailsPanel.CardName:setColor(rarityColor)
	end

	-- Update card level
	if cardDetailsPanel.CardLevel then
		if isUnlocked then
			cardDetailsPanel.CardLevel:setText("Level: " .. cardLevel .. " / " .. cardData.maxLevel)
		else
			cardDetailsPanel.CardLevel:setText("LOCKED")
		end
	end
	
	-- Update experience bar
	local cardExpBar = cardDetailsPanel:getChildById("CardExpBar")
	local cardExpText = cardDetailsPanel:getChildById("CardExpText")
	
	if cardExpBar and cardExpText then
		if isUnlocked and cardLevel < cardData.maxLevel then
			local currentExp = Codex.cachedCardsExp[Codex.selectedCardId] or 0
			local expNeeded = Codex.cardExpTable[cardLevel] or 1
			local expPercent = math.floor((currentExp / expNeeded) * 100)
			
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

	-- Update trigger
	if cardDetailsPanel.CardTrigger then
		cardDetailsPanel.CardTrigger:setText("Trigger: " .. cardData.trigger)
	end

	-- Update description
	if cardDetailsPanel.CardDescription then
		cardDetailsPanel.CardDescription:destroyChildren()
		
		if isUnlocked then
			-- Show current level and max level descriptions
			local currentDesc = cardData.description[cardLevel] or cardData.description[1]
			local maxDesc = cardData.description[cardData.maxLevel]

			local currentLabel = g_ui.createWidget("Label", cardDetailsPanel.CardDescription)
			currentLabel:setText("Current (Lvl " .. cardLevel .. "):")
			currentLabel:setColor("#00ff00")
			currentLabel:setMarginTop(5)

			local currentDescLabel = g_ui.createWidget("Label", cardDetailsPanel.CardDescription)
			currentDescLabel:setText(currentDesc)
			currentDescLabel:setTextWrap(true)
			currentDescLabel:setMarginTop(2)

			if cardLevel < cardData.maxLevel then
				local maxLabel = g_ui.createWidget("Label", cardDetailsPanel.CardDescription)
				maxLabel:setText("Max (Lvl " .. cardData.maxLevel .. "):")
				maxLabel:setColor("#ffd700")
				maxLabel:setMarginTop(10)

				local maxDescLabel = g_ui.createWidget("Label", cardDetailsPanel.CardDescription)
				maxDescLabel:setText(maxDesc)
				maxDescLabel:setTextWrap(true)
				maxDescLabel:setMarginTop(2)
			end
		else
			local lockedLabel = g_ui.createWidget("Label", cardDetailsPanel.CardDescription)
			lockedLabel:setText("This card is locked. Open crates to unlock it!")
			lockedLabel:setTextWrap(true)
			lockedLabel:setColor("#888888")
		end
	end

	-- Update status
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

------ Deck Tab

function Codex.setupDeckUI()
	local availableCardsPanel = Codex.UI.DeckPanel and Codex.UI.DeckPanel.AvailableCardsPanel
	local activeSlotsPanel = Codex.UI.DeckPanel and Codex.UI.DeckPanel.ActiveSlotsPanel
	
	if not availableCardsPanel or not activeSlotsPanel then 
		print("[Codex] Deck panels not found!")
		print("[Codex] AvailableCardsPanel: " .. tostring(availableCardsPanel))
		print("[Codex] ActiveSlotsPanel: " .. tostring(activeSlotsPanel))
		return 
	end
	
	print("[Codex] Setting up Deck UI...")
	print("[Codex] Player cards: " .. table.size(Codex.cachedCards))
	print("[Codex] Active cards: " .. table.size(Codex.cachedActiveCards))
	print("[Codex] Max slots: " .. Codex.cachedMaxSlots)

	-- Setup available cards (unlocked only)
	availableCardsPanel:destroyChildren()
	for cardId, cardLevel in pairs(Codex.cachedCards) do
		local cardData = Codex.cachedCardDatabase[cardId]
		if cardData then
			local cardWidget = g_ui.createWidget("DeckCardEntry", availableCardsPanel)
			cardWidget:setId("available_card_" .. cardId)
			cardWidget.cardId = cardId
			cardWidget.cardData = cardData

			-- Set card icon
			local cardIcon = cardWidget:getChildById("cardIcon")
			if cardIcon then
				local imagePath = Codex.cardImagesPath .. cardData.cardFrame .. ".png"
				cardIcon:setImageSource(imagePath)
			end

			-- Set card name
			local cardName = cardWidget:getChildById("cardName")
			if cardName then
				cardName:setText(cardData.name)
				cardName:setColor(Codex.rarityColors[cardData.rarity] or "#ffffff")
			end

			-- Set card level
			local cardLevelLabel = cardWidget:getChildById("cardLevel")
			if cardLevelLabel then
				cardLevelLabel:setText("Level: " .. cardLevel .. "/" .. cardData.maxLevel)
			end

			-- Equip button
			local equipButton = cardWidget:getChildById("equipButton")
			if equipButton then
				-- Check if card is already equipped
				local isEquipped = Codex.isCardEquipped(cardId)
				equipButton:setEnabled(not isEquipped)
				
				equipButton.onClick = function()
					Codex.equipCard(cardId)
				end
			end
		end
	end

	-- Setup active slots
	activeSlotsPanel:destroyChildren()
	local maxSlots = 6 -- Total slots (3 base + 3 locked)
	for i = 1, maxSlots do
		local slotWidget = g_ui.createWidget("ActiveSlot", activeSlotsPanel)
		slotWidget:setId("slot_" .. i)
		slotWidget.slotIndex = i
		
		local isLocked = i > Codex.cachedMaxSlots
		local activeCardId = Codex.cachedActiveCards[i]
		
		-- Get slot elements
		local slotLabel = slotWidget:getChildById("slotLabel")
		local slotPlaceholder = slotWidget:getChildById("slotPlaceholder")
		local slotCardImage = slotWidget:getChildById("slotCardImage")
		local removeButton = slotWidget:getChildById("removeButton")
		
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
			-- Locked slot
			if slotPlaceholder then slotPlaceholder:setOpacity(0.3) end
			if slotCardImage then slotCardImage:hide() end
			if removeButton then removeButton:hide() end
			slotWidget:setOpacity(0.5)
		elseif activeCardId and activeCardId > 0 then
			-- Slot has a card
			local cardData = Codex.cachedCardDatabase[activeCardId]
			if cardData and slotCardImage then
				local imagePath = Codex.cardImagesPath .. cardData.cardFrame .. ".png"
				slotCardImage:setImageSource(imagePath)
				slotCardImage:show()
			end
			if slotPlaceholder then slotPlaceholder:hide() end
			if removeButton then
				removeButton:show()
				removeButton.onClick = function()
					Codex.removeCard(i)
				end
			end
		else
			-- Empty slot
			if slotPlaceholder then slotPlaceholder:show() end
			if slotCardImage then slotCardImage:hide() end
			if removeButton then removeButton:hide() end
		end
	end
end

-- Helper function to check if a card is already equipped
function Codex.isCardEquipped(cardId)
	for slot, equippedCardId in pairs(Codex.cachedActiveCards) do
		if equippedCardId == cardId then
			return true
		end
	end
	return false
end

-- Equip a card to the first available slot
function Codex.equipCard(cardId)
	-- Check if card is already equipped
	if Codex.isCardEquipped(cardId) then
		Codex.setupMessage("Already Equipped", "This card is already equipped!")
		return
	end
	
	-- Find first empty slot
	for i = 1, Codex.cachedMaxSlots do
		if not Codex.cachedActiveCards[i] or Codex.cachedActiveCards[i] == 0 then
			-- Send request to server
			Codex.sendOpcode({
				topic = "activate-card-request",
				cardId = cardId,
				slotIndex = i
			})
			return
		end
	end
	
	Codex.setupMessage("No Free Slots", "All active slots are full!")
end

-- Remove a card from a slot
function Codex.removeCard(slotIndex)
	Codex.sendOpcode({
		topic = "deactivate-card-request",
		slotIndex = slotIndex
	})
end

------ Crates Tab

function Codex.setupCratesUI()
	local cratesList = Codex.UI.CratesPanel and Codex.UI.CratesPanel.CratesList
	local crateDetailsPanel = Codex.UI.CratesPanel and Codex.UI.CratesPanel.CrateDetailsPanel
	
	if not cratesList or not crateDetailsPanel then return end

	cratesList:destroyChildren()

	for crateId, crateData in pairs(Codex.cachedCrateDatabase) do
		local crateWidget = g_ui.createWidget("CrateEntry", cratesList)
		crateWidget:setId("crate_" .. crateId)
		crateWidget.crateId = crateId
		crateWidget.crateData = crateData

		local nameLabel = g_ui.createWidget("Label", crateWidget)
		nameLabel:setText(crateData.name)
		nameLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
		nameLabel:setMarginLeft(10)

		local costLabel = g_ui.createWidget("Label", crateWidget)
		costLabel:setText(crateData.cost .. " Essences")
		costLabel:addAnchor(AnchorRight, "parent", AnchorRight)
		costLabel:setMarginRight(10)
		costLabel:setColor("#ffff00")

		crateWidget.onClick = function()
			Codex.selectCrate(crateId)
		end
	end

	-- Update essences display
	if Codex.UI.EssencesLabel then
		Codex.UI.EssencesLabel:setText("Codex Essences: " .. Codex.cachedEssences)
	end
end

function Codex.selectCrate(crateId)
	local crateData = Codex.cachedCrateDatabase[crateId]
	local crateDetailsPanel = Codex.UI.CratesPanel and Codex.UI.CratesPanel.CrateDetailsPanel
	
	if not crateData or not crateDetailsPanel then return end

	Codex.selectedCrateId = crateId

	if crateDetailsPanel.CrateName then
		crateDetailsPanel.CrateName:setText(crateData.name)
	end

	if crateDetailsPanel.CrateCost then
		crateDetailsPanel.CrateCost:setText("Cost: " .. crateData.cost .. " Codex Essences")
	end

	-- Show possible rewards as small card icons
	if crateDetailsPanel.CrateRewards then
		crateDetailsPanel.CrateRewards:destroyChildren()

		for _, reward in ipairs(crateData.rewards) do
			local cardData = Codex.cachedCardDatabase[reward.cardId]
			if cardData then
				local cardIcon = g_ui.createWidget("UIWidget", crateDetailsPanel.CrateRewards)
				cardIcon:setSize({width = 60, height = 100})
				cardIcon:setImageSource(Codex.cardImagesPath .. cardData.cardFrame .. ".png")
				cardIcon:setOpacity(0.7)
			end
		end
	end

	-- Hide results panel when selecting a new crate
	local resultsTitle = crateDetailsPanel:getChildById("CrateResultsTitle")
	local resultsPanel = crateDetailsPanel:getChildById("CrateResultsPanel")
	if resultsTitle then resultsTitle:hide() end
	if resultsPanel then 
		resultsPanel:destroyChildren()
		resultsPanel:hide()
	end

	if crateDetailsPanel.OpenCrateButton then
		crateDetailsPanel.OpenCrateButton.onClick = function()
			Codex.openCrate(crateId)
		end
	end
end

function Codex.openCrate(crateId)
	local crateData = Codex.cachedCrateDatabase[crateId]
	if not crateData then return end

	if Codex.cachedEssences < crateData.cost then
		Codex.setupMessage("Not Enough Essences", "You need " .. crateData.cost .. " Codex Essences to open this crate.")
		return
	end

	Codex.sendOpcode({
		topic = "open-crate-request",
		crateId = crateId
	})
end

function Codex.showCrateResults(rewards)
	print("[Codex] showCrateResults called with " .. #rewards .. " rewards")
	
	local crateDetailsPanel = Codex.UI.CratesPanel and Codex.UI.CratesPanel.CrateDetailsPanel
	if not crateDetailsPanel then 
		print("[Codex] ERROR: CrateDetailsPanel not found")
		return 
	end

	local resultsTitle = crateDetailsPanel:getChildById("CrateResultsTitle")
	local resultsPanel = crateDetailsPanel:getChildById("CrateResultsPanel")
	
	print("[Codex] resultsTitle exists: " .. tostring(resultsTitle ~= nil))
	print("[Codex] resultsPanel exists: " .. tostring(resultsPanel ~= nil))
	
	if not resultsTitle or not resultsPanel then return end

	-- Clear previous results
	resultsPanel:destroyChildren()
	
	-- Show results section
	resultsTitle:show()
	resultsPanel:show()

	-- Add each reward card with fade-in animation
	local delay = 0
	for i, reward in ipairs(rewards) do
		print("[Codex] Processing reward " .. i .. ": cardId=" .. reward.cardId)
		local cardData = Codex.cachedCardDatabase[reward.cardId]
		if cardData then
			print("[Codex] Card data found: " .. cardData.name)
			
			-- Create card container
			local cardContainer = g_ui.createWidget("UIWidget", resultsPanel)
			cardContainer:setSize({width = 110, height = 180})
			cardContainer:setOpacity(0)
			
			-- Card image
			local cardWidget = g_ui.createWidget("UIWidget", cardContainer)
			cardWidget:setSize({width = 96, height = 160})
			cardWidget:setImageSource(Codex.cardImagesPath .. cardData.cardFrame .. ".png")
			cardWidget:addAnchor(AnchorTop, "parent", AnchorTop)
			cardWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			
			-- Add level indicator if leveled up
			if reward.leveledUp then
				local levelLabel = g_ui.createWidget("Label", cardWidget)
				levelLabel:setText("LEVEL UP!")
				levelLabel:setColor("#00ff00")
				levelLabel:setFont("verdana-11px-rounded")
				levelLabel:setTextAlign(AlignTopCenter)
				levelLabel:setMarginTop(5)
			end
			
			-- Add card name below
			local nameLabel = g_ui.createWidget("Label", cardContainer)
			nameLabel:setText(cardData.name)
			nameLabel:setColor(Codex.rarityColors[cardData.rarity] or "#ffffff")
			nameLabel:setFont("verdana-11px-rounded")
			nameLabel:setTextAlign(AlignBottomCenter)
			nameLabel:addAnchor(AnchorBottom, "parent", AnchorBottom)
			nameLabel:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			
			-- Fade in animation with delay
			scheduleEvent(function()
				print("[Codex] Fading in card: " .. cardData.name)
				g_effects.fadeIn(cardContainer, 150)
			end, delay)
			
			delay = delay + 200 -- 200ms between each card
		else
			print("[Codex] ERROR: Card data not found for cardId=" .. reward.cardId)
		end
	end
end

------ Tooltip Management

function Codex.moveToolTip()
	if not Codex.Tooltip or not Codex.Tooltip:isVisible() then
		return
	end

	local pos = g_window.getMousePosition()
	local windowSize = g_window.getSize()
	local tipSize = Codex.Tooltip:getSize()

	pos.x = pos.x + 1
	pos.y = pos.y + 1

	if windowSize.width - (pos.x + tipSize.width) < 10 then
		pos.x = pos.x - tipSize.width - 3
	else
		pos.x = pos.x + 10
	end

	if windowSize.height - (pos.y + tipSize.height) < 10 then
		pos.y = pos.y - tipSize.height - 3
	else
		pos.y = pos.y + 10
	end

	Codex.Tooltip:setPosition(pos)
	Codex.Tooltip:raise()
end

function Codex.applyTooltip(cardData, cardLevel)
	Codex.moveToolTip()
	Codex.Tooltip:setText(cardData.name)
	
	if Codex.Tooltip.description then
		local desc = cardData.description[cardLevel] or cardData.description[1] or "No description"
		Codex.Tooltip.description:setText(desc)
	end
	
	if Codex.Tooltip.trigger then
		Codex.Tooltip.trigger:setText("Trigger: " .. cardData.trigger)
	end
	
	local totalHeight = 100
	if Codex.Tooltip.description then
		totalHeight = Codex.Tooltip.description:getHeight() + 80
	end
	Codex.Tooltip:setHeight(totalHeight)
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

------ Dialogs and Messages

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
	if not Codex.UI.MessageBase or not Codex.UI.LockUI then
		return
	end
	Codex.UI.LockUI:setVisible(true)
	Codex.UI.MessageBase:setVisible(true)
	Codex.UI.MessageBase:setText(title)
	Codex.UI.MessageBase.Text:setText(message)
	local height = Codex.UI.MessageBase.Text:getTextSize().height + 150
	Codex.UI.MessageBase:setHeight(height)
end

------ Opcode Handling and Communication

function Codex.sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()
	if protocolGame then
		protocolGame:sendExtendedJSONOpcode(Codex.opCode, data)
	end
end

function Codex.onExtendedOpcode(protocol, opcode, buffer)
	local data = json.decode(buffer)
	
	print("[Codex] Received opcode with topic: " .. (data.topic or "nil"))
	
	if data.topic == "base-data-reply" then
		print("[Codex] Received base-data-reply from server")
		
		-- Store cached data (now includes exp)
		Codex.cachedCards = {}
		Codex.cachedCardsExp = {}
		for cardIdStr, cardInfo in pairs(data.cards or {}) do
			local cardId = tonumber(cardIdStr)
			if cardId then
				if type(cardInfo) == "table" then
					Codex.cachedCards[cardId] = cardInfo.level
					Codex.cachedCardsExp[cardId] = cardInfo.exp or 0
				else
					-- Backward compatibility
					Codex.cachedCards[cardId] = cardInfo
					Codex.cachedCardsExp[cardId] = 0
				end
			end
		end

		Codex.cachedActiveCards = {}
		for slotStr, cardId in pairs(data.activeCards or {}) do
			local slot = tonumber(slotStr)
			if slot then
				Codex.cachedActiveCards[slot] = cardId
			end
		end

		Codex.cachedEssences = data.essences or 0
		Codex.cachedMaxSlots = data.maxSlots or 3
		
		-- Convert cardDatabase string keys to numbers
		Codex.cachedCardDatabase = {}
		for cardIdStr, cardData in pairs(data.cardDatabase or {}) do
			local cardId = tonumber(cardIdStr)
			if cardId then
				-- Also convert description keys back to numbers
				if cardData.description then
					local descConverted = {}
					for levelStr, desc in pairs(cardData.description) do
						local level = tonumber(levelStr)
						if level then
							descConverted[level] = desc
						end
					end
					cardData.description = descConverted
				end
				Codex.cachedCardDatabase[cardId] = cardData
			end
		end
		
		-- Convert crateDatabase string keys to numbers
		Codex.cachedCrateDatabase = {}
		for crateIdStr, crateData in pairs(data.crateDatabase or {}) do
			local crateId = tonumber(crateIdStr)
			if crateId then
				Codex.cachedCrateDatabase[crateId] = crateData
			end
		end

		-- Refresh current tab
		Codex.switchTab(Codex.currentTab)

	elseif data.topic == "collection-update" then
		local cardId = tonumber(data.cardId)
		if cardId then
			Codex.cachedCards[cardId] = data.level
			Codex.cachedCardsExp[cardId] = data.exp or 0
			if Codex.currentTab == Codex.TAB_COLLECTION then
				Codex.setupCollectionUI()
				-- If this card is currently selected, update details
				if Codex.selectedCardId == cardId then
					Codex.updateCardDetails()
				end
			end
		end

	elseif data.topic == "deck-update" then
		Codex.cachedActiveCards = {}
		for slotStr, cardId in pairs(data.activeCards or {}) do
			local slot = tonumber(slotStr)
			if slot then
				Codex.cachedActiveCards[slot] = cardId
			end
		end
		if Codex.currentTab == Codex.TAB_DECK then
			Codex.setupDeckUI()
		end

	elseif data.topic == "currency-update" then
		Codex.cachedEssences = data.essences or 0
		if Codex.UI.EssencesLabel then
			Codex.UI.EssencesLabel:setText("Codex Essences: " .. Codex.cachedEssences)
		end

	elseif data.topic == "open-crate-reply" then
		if data.success and data.rewards then
			Codex.showCrateResults(data.rewards)
		elseif data.message then
			Codex.setupMessage("Crate Opening Failed", data.message)
		end

	elseif data.topic == "message-reply" then
		if data.title and data.message then
			Codex.setupMessage(data.title, data.message)
		end
	end
end
