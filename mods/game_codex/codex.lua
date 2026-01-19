
------ Trigger Icons Mapping

Codex.triggerIcons = {
	onHit = "/images/icons/row-1-column-1",           -- Espada para ataques
	passive = "/images/icons/row-2-column-8",       -- Estrella para pasivos
	onKill = "/images/icons/row-2-column-4",         -- Calavera para kills
	onDamageTaken = "/images/icons/row-1-column-3",  -- Escudo para daño recibido
	onDeath = "/images/icons/row-5-column-3",       -- Fuego para muerte/rebirth
	onSpell = "/images/icons/row-4-column-7",       -- Cristal para hechizos
	onLowHP = "/images/icons/row-5-column-7",       -- Corazón para low HP
	onHeal = "/images/icons/row-5-column-2",         -- Corazón verde para heals
	onCrit = "/images/icons/row-8-column-6",         -- Rayo para críticos
	onDash = "/images/icons/dash",         -- Bota/velocidad para dash
	onStandStill = "/images/icons/blast",   -- Piedra/defensa para stand still
}

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
	Codex.cachedBronzeCrates = 0
	Codex.cachedSilverCrates = 0
	Codex.cachedGoldenCrates = 0
	Codex.crateAnimationInProgress = false
	Codex.currentTab = Codex.TAB_COLLECTION
	Codex.selectedCrateId = 1  -- Default to Bronze
	
	-- Temporary batch accumulation
	Codex.tempCardDatabase = {}
	Codex.baseDataReceived = false

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

	-- Sort card IDs for consistent pagination
	local sortedCardIds = {}
	for cardId, cardData in pairs(Codex.cachedCardDatabase) do
		table.insert(sortedCardIds, cardId)
		print("[Codex DEBUG] Found card ID: " .. cardId .. " - " .. cardData.name)
	end
	table.sort(sortedCardIds)
	
	-- Calculate pagination
	local totalCards = #sortedCardIds
	local cardsPerPage = Codex.cardsPerPage or 20 -- Fallback to 20
	local totalPages = math.ceil(totalCards / cardsPerPage)
	local startIndex = (Codex.currentCollectionPage - 1) * cardsPerPage + 1
	local endIndex = math.min(startIndex + cardsPerPage - 1, totalCards)
	
	print("[Codex DEBUG] Total cards in database: " .. totalCards)
	print("[Codex DEBUG] Cards per page (Codex.cardsPerPage): " .. tostring(Codex.cardsPerPage))
	print("[Codex DEBUG] Cards per page (used): " .. cardsPerPage)
	print("[Codex DEBUG] Division result (totalCards / cardsPerPage): " .. (totalCards / cardsPerPage))
	print("[Codex DEBUG] Total pages (math.ceil): " .. totalPages)
	print("[Codex DEBUG] Current page: " .. Codex.currentCollectionPage)
	print("[Codex DEBUG] Showing cards from index " .. startIndex .. " to " .. endIndex)
	
	-- Update page info label
	local paginationPanel = Codex.UI.CollectionPanel and Codex.UI.CollectionPanel:getChildById("PaginationPanel")
	if paginationPanel then
		local pageInfo = paginationPanel:getChildById("PageInfo")
		if pageInfo then
			pageInfo:setText("Page " .. Codex.currentCollectionPage .. " / " .. totalPages)
		end
		
		-- Update navigation buttons
		local prevButton = paginationPanel:getChildById("PrevPageButton")
		if prevButton then
			prevButton:setEnabled(Codex.currentCollectionPage > 1)
		end
		
		local nextButton = paginationPanel:getChildById("NextPageButton")
		if nextButton then
			nextButton:setEnabled(Codex.currentCollectionPage < totalPages)
		end
	end

	-- Display only cards for current page
	for i = startIndex, endIndex do
		local cardId = sortedCardIds[i]
		local cardData = Codex.cachedCardDatabase[cardId]
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

		-- Add card name label with rarity color
		local nameLabel = g_ui.createWidget("Label", cardWidget)
		if nameLabel then
			nameLabel:setId("cardNameLabel")
			nameLabel:setText(cardData.name)
			nameLabel:setColor(Codex.rarityColors[cardData.rarity] or "#ffffff")
			nameLabel:setFont("verdana-11px-rounded")
			nameLabel:setTextAlign(AlignBottomCenter)
			nameLabel:addAnchor(AnchorBottom, "parent", AnchorBottom)
			nameLabel:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			nameLabel:setMarginBottom(17) -- Space for level label and exp bar below
			nameLabel:setTextAutoResize(true)
		end

		-- Add level label (positioned at bottom-left)
		local levelLabel = g_ui.createWidget("Label", cardWidget)
		if levelLabel then
			levelLabel:setId("cardLevelLabel")
			levelLabel:setFont("verdana-11px-rounded")
			levelLabel:setTextAutoResize(true)
			levelLabel:setColor("#FFD700")
			levelLabel:addAnchor(AnchorBottom, "parent", AnchorBottom)
			levelLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
			levelLabel:setMarginBottom(17)
			levelLabel:setMarginLeft(19)
			if isUnlocked then
				levelLabel:setText(cardLevel) --cardLevel .. "/" .. cardData.maxLevel
			else
				levelLabel:setText("0")
			end
		end

		-- Add EXP bar if unlocked and not max level
		if isUnlocked and cardLevel < cardData.maxLevel then
			local currentExp = Codex.cachedCardsExp[cardId] or 0
			local expNeeded = Codex.cardExpTable[cardLevel] or 1
			local expPercent = math.floor((currentExp / expNeeded) * 100)
			
			local expBar = g_ui.createWidget("ProgressBar", cardWidget)
			expBar:setId("expBar")
			expBar:addAnchor(AnchorBottom, "parent", AnchorBottom)
			expBar:addAnchor(AnchorLeft, "parent", AnchorLeft)
			expBar:addAnchor(AnchorRight, "parent", AnchorRight)
			expBar:setHeight(10)
			expBar:setMarginTop(20)
			expBar:setMarginLeft(2)
			expBar:setMarginRight(2)
			expBar:setBackgroundColor("#FFD700")
			expBar:setPercent(expPercent)
			
			-- Add exp text label
			local expLabel = g_ui.createWidget("Label", cardWidget)
			expLabel:setId("expLabel")
			expLabel:setText(currentExp .. "/" .. expNeeded)
			expLabel:setFont("verdana-11px-rounded")
			expLabel:setColor("#fdfdfcff")
			expLabel:setTextAutoResize(true)
			expLabel:addAnchor(AnchorBottom, "parent", AnchorBottom)
			expLabel:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			expLabel:setMarginBottom(-2)
		end

		-- Click handler
		cardWidget.onClick = function()
			Codex.selectCard(cardId)
		end

		-- Hover handler
		cardWidget.onHoverChange = Codex.onCardHoverChange
	end
	
	print("[Codex] Collection UI setup complete!")
	
	-- Setup pagination button handlers
	local paginationPanel = Codex.UI.CollectionPanel and Codex.UI.CollectionPanel:getChildById("PaginationPanel")
	if paginationPanel then
		local prevButton = paginationPanel:getChildById("PrevPageButton")
		local nextButton = paginationPanel:getChildById("NextPageButton")
		
		if prevButton then
			prevButton.onClick = function()
				Codex.prevCollectionPage()
			end
		end
		
		if nextButton then
			nextButton.onClick = function()
				Codex.nextCollectionPage()
			end
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
		
		if isUnlocked and cardData.description then
			-- Show current level and max level descriptions
			local currentDesc = cardData.description[cardLevel] or cardData.description[1] or "No description"
			local maxDesc = cardData.description[cardData.maxLevel] or "No description"

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
			
			-- Set background based on card level
			local backgroundImage = Codex.getCardBackgroundByLevel(cardLevel)
			cardWidget:setImageSource(backgroundImage)
			cardWidget:setImageBorder(3)
			cardWidget:setImageRepeated(false)
			cardWidget:setImageFixedRatio(false)
			

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

			-- Add EXP bar if not max level
			if cardLevel < cardData.maxLevel then
				local currentExp = Codex.cachedCardsExp[cardId] or 0
				local expNeeded = Codex.cardExpTable[cardLevel] or 1
				local expPercent = math.floor((currentExp / expNeeded) * 100)
				
				local expBar = g_ui.createWidget("ProgressBar", cardWidget)
				expBar:setId("expBar")
				expBar:addAnchor(AnchorBottom, "parent", AnchorBottom)
				expBar:addAnchor(AnchorLeft, "parent", AnchorLeft)
				expBar:addAnchor(AnchorRight, "parent", AnchorRight)
				expBar:setHeight(3)
				expBar:setMarginBottom(1)
				expBar:setMarginLeft(5)
				expBar:setMarginRight(5)
				expBar:setBackgroundColor("#FFD700")
				expBar:setPercent(expPercent)
				
				-- Add exp text label
				local expLabel = g_ui.createWidget("Label", cardWidget)
				expLabel:setId("expLabel")
				expLabel:setText(currentExp .. "/" .. expNeeded)
				expLabel:setFont("verdana-11px-rounded")
				expLabel:setColor("#FFD700")
				expLabel:setTextAutoResize(true)
				expLabel:addAnchor(AnchorBottom, "parent", AnchorBottom)
				expLabel:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
				expLabel:setMarginBottom(3)
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
			
			-- Add hover tooltip
			cardWidget.onHoverChange = Codex.onCardHoverChange
		end
	end

	-- Setup active slots
	activeSlotsPanel:destroyChildren()
	local maxSlots = 6 -- Total slots (3 base + 3 locked)
	
	-- Ascension requirements for locked slots
	local ascensionRequirements = {
		[4] = "Requires one ascension",
		[5] = "Requires third ascension",
		[6] = "Requires sixth ascension"
	}
	
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
			-- Locked slot
			if slotPlaceholder then slotPlaceholder:setOpacity(0.3) end
			if slotCardImage then slotCardImage:hide() end
			if removeButton then removeButton:hide() end
			slotWidget:setOpacity(0.5)
			
			-- Show ascension requirement label
			if requirementLabel and ascensionRequirements[i] then
				requirementLabel:setText(ascensionRequirements[i])
				requirementLabel:show()
			end
		elseif activeCardId and activeCardId > 0 then
			-- Slot has a card
			local cardData = Codex.cachedCardDatabase[activeCardId]
			if cardData and slotCardImage then
				local imagePath = Codex.cardImagesPath .. cardData.cardFrame .. ".png"
				slotCardImage:setImageSource(imagePath)
				slotCardImage:show()
				
				-- Add tooltip to card image
				slotCardImage.cardId = activeCardId
				slotCardImage.cardData = cardData
				slotCardImage.onHoverChange = Codex.onCardHoverChange
				
				-- Also add tooltip to the slot widget itself
				slotWidget.cardId = activeCardId
				slotWidget.cardData = cardData
				slotWidget.onHoverChange = Codex.onCardHoverChange
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

-- Update only active slots (optimized, no full UI rebuild)
function Codex.updateActiveSlots()
	local activeSlotsPanel = Codex.UI.DeckPanel and Codex.UI.DeckPanel.ActiveSlotsPanel
	local availableCardsPanel = Codex.UI.DeckPanel and Codex.UI.DeckPanel.AvailableCardsPanel
	
	if not activeSlotsPanel then
		print("[Codex] ActiveSlotsPanel not found in updateActiveSlots")
		return
	end
	
	-- Update each existing slot widget
	local maxSlots = 6
	for i = 1, maxSlots do
		local slotWidget = activeSlotsPanel:getChildById("slot_" .. i)
		if slotWidget then
			local isLocked = i > Codex.cachedMaxSlots
			local activeCardId = Codex.cachedActiveCards[i]
			
			local slotPlaceholder = slotWidget:getChildById("slotPlaceholder")
			local slotCardImage = slotWidget:getChildById("slotCardImage")
			local removeButton = slotWidget:getChildById("removeButton")
			local requirementLabel = slotWidget:getChildById("requirementLabel")
			
			if not isLocked and activeCardId and activeCardId > 0 then
				-- Slot has a card
				local cardData = Codex.cachedCardDatabase[activeCardId]
				if cardData then
					if slotPlaceholder then slotPlaceholder:hide() end
					if requirementLabel then requirementLabel:hide() end
					
					if slotCardImage then
						local imagePath = Codex.cardImagesPath .. cardData.cardFrame .. ".png"
						slotCardImage:setImageSource(imagePath)
						slotCardImage:show()
					end
					
					if removeButton then
						removeButton:show()
						removeButton:setEnabled(true)
						removeButton.onClick = function()
							Codex.removeCard(i)
						end
					end
				end
			else
				-- Empty or locked slot
				if slotPlaceholder then slotPlaceholder:show() end
				if slotCardImage then slotCardImage:hide() end
				if removeButton then removeButton:hide() end
			end
		end
	end
	
	-- Update equip buttons in available cards panel
	if availableCardsPanel then
		for _, cardWidget in ipairs(availableCardsPanel:getChildren()) do
			local cardId = cardWidget.cardId
			if cardId then
				local equipButton = cardWidget:getChildById("equipButton")
				if equipButton then
					local isEquipped = Codex.isCardEquipped(cardId)
					equipButton:setEnabled(not isEquipped)
				end
			end
		end
	end
end

------ Crates Tab (NEW DESIGN)

-- Note: Codex.rarityColors already defined in codexDataConfig.lua, don't redefine
-- Using same colors for probability bars

function Codex.setupCratesUI()
	local cratesPanel = Codex.UI.CratesPanel
	if not cratesPanel then 
		print("[Codex ERROR] CratesPanel not found in setupCratesUI")
		return 
	end
	
	print("[Codex] Setting up Crates UI...")

	-- Fallback: If server data not received, use hardcoded data
	if not Codex.cachedCrateDatabase or not Codex.cachedCrateDatabase[1] then
		print("[Codex] No crate database from server, using fallback data")
		Codex.cachedCrateDatabase = {
			[1] = {
				id = 1,
				name = "Bronze Crate",
				craftCost = 25,
				rarityWeights = {
					common = 85,
					rare = 12,
					epic = 3,
					legendary = 0
				}
			},
			[2] = {
				id = 2,
				name = "Silver Crate",
				craftCost = 60,
				rarityWeights = {
					common = 60,
					rare = 25,
					epic = 10,
					legendary = 5
				}
			},
			[3] = {
				id = 3,
				name = "Golden Crate",
				craftCost = 120,
				rarityWeights = {
					common = 40,
					rare = 35,
					epic = 20,
					legendary = 5
				}
			}
		}
	end

	-- Setup crate selector buttons with onClick handlers
	local selectorPanel = cratesPanel:getChildById("CrateSelectorPanel")
	if not selectorPanel then
		print("[Codex ERROR] CrateSelectorPanel not found!")
		return
	end
	
	local bronzeButton = selectorPanel:getChildById("BronzeCrateButton")
	local silverButton = selectorPanel:getChildById("SilverCrateButton")
	local goldenButton = selectorPanel:getChildById("GoldenCrateButton")

	print("[Codex] Bronze button: " .. tostring(bronzeButton ~= nil))
	print("[Codex] Silver button: " .. tostring(silverButton ~= nil))
	print("[Codex] Golden button: " .. tostring(goldenButton ~= nil))

	if bronzeButton then
		bronzeButton:setText("\n\n\n" .. "     BRONZE CRATE\nx" .. Codex.cachedBronzeCrates)
		
		
		connect(bronzeButton, { onClick = function()
			print("[Codex] Bronze button clicked")
			Codex.selectCrateType(1)
		end })
		print("[Codex] Bronze button configured")
	else
		print("[Codex ERROR] Bronze button not found!")
	end

	if silverButton then
		silverButton:setText("\n\n\n" .. "     SILVER CRATE\nx" .. Codex.cachedSilverCrates)
		connect(silverButton, { onClick = function()
			print("[Codex] Silver button clicked")
			Codex.selectCrateType(2)
		end })
		print("[Codex] Silver button configured")
	else
		print("[Codex ERROR] Silver button not found!")
	end

	if goldenButton then
		goldenButton:setText("\n\n\n" .. "     GOLDEN CRATE\nx" .. Codex.cachedGoldenCrates)
		connect(goldenButton, { onClick = function()
			print("[Codex] Golden button clicked")
			Codex.selectCrateType(3)
		end })
		print("[Codex] Golden button configured")
	else
		print("[Codex ERROR] Golden button not found!")
	end

	-- Setup crafting buttons
	local craftingPanel = cratesPanel:getChildById("CraftingPanel")
	if not craftingPanel then
		print("[Codex ERROR] CraftingPanel not found!")
		return
	end
	
	local craftBronze = craftingPanel:getChildById("CraftBronzeButton")
	local craftSilver = craftingPanel:getChildById("CraftSilverButton")
	local craftGolden = craftingPanel:getChildById("CraftGoldenButton")

	if craftBronze then
		connect(craftBronze, { onClick = function()
			print("[Codex] Craft Bronze clicked")
			Codex.craftCrate(1)
		end })
	end

	if craftSilver then
		connect(craftSilver, { onClick = function()
			print("[Codex] Craft Silver clicked")
			Codex.craftCrate(2)
		end })
	end

	if craftGolden then
		connect(craftGolden, { onClick = function()
			print("[Codex] Craft Golden clicked")
			Codex.craftCrate(3)
		end })
	end

	-- Display currently selected crate
	print("[Codex] Displaying initial crate selection...")
	Codex.selectCrateType(Codex.selectedCrateId or 1)
end

function Codex.selectCrateType(crateId)
	print("[Codex] selectCrateType called with crateId: " .. crateId)
	Codex.selectedCrateId = crateId
	
	local crateData = Codex.cachedCrateDatabase[crateId]
	local cratesPanel = Codex.UI.CratesPanel
	
	if not cratesPanel then 
		print("[Codex ERROR] CratesPanel not found")
		return 
	end
	
	if not crateData then 
		print("[Codex ERROR] Crate data not found for crateId: " .. crateId)
		print("[Codex] Available crates in cache:")
		for id, data in pairs(Codex.cachedCrateDatabase) do
			print("  - Crate ID: " .. id .. " = " .. (data.name or "unknown"))
		end
		return 
	end

	local displayPanel = cratesPanel:getChildById("CrateDisplayPanel")
	if not displayPanel then 
		print("[Codex ERROR] CrateDisplayPanel not found")
		return 
	end

	-- Update panel background image based on crate type
	local imageMap = {
		[1] = "/images/ui/windows/card_window_normal",   -- Bronze
		[2] = "/images/ui/windows/card_window_rare",     -- Silver
		[3] = "/images/ui/windows/card_window_legendary" -- Golden
	}
	if imageMap[crateId] then
		displayPanel:setImageSource(imageMap[crateId])
		print("[Codex] Updated panel image to: " .. imageMap[crateId])
	end

	-- Update crate name
	local nameLabel = displayPanel:getChildById("SelectedCrateName")
	if nameLabel then
		nameLabel:setText(crateData.name:upper())
		print("[Codex] Updated crate name to: " .. crateData.name)
	end

	-- Update owned count
	local ownedLabel = displayPanel:getChildById("CrateOwnedCount")
	if ownedLabel then
		local ownedCount = 0
		if crateId == 1 then ownedCount = Codex.cachedBronzeCrates
		elseif crateId == 2 then ownedCount = Codex.cachedSilverCrates
		elseif crateId == 3 then ownedCount = Codex.cachedGoldenCrates
		end
		ownedLabel:setText("You own: " .. ownedCount)
		print("[Codex] Updated owned count to: " .. ownedCount)
	end

	-- Update probability bars
	local barsPanel = displayPanel:getChildById("ProbabilityBarsPanel")
	if barsPanel then
		barsPanel:destroyChildren()
		
		if crateData.rarityWeights then
			print("[Codex] Creating probability bars...")
			-- Sort rarities for consistent display order (only 4 rarities)
			local rarityOrder = {"common", "rare", "epic", "legendary"}
			for _, rarity in ipairs(rarityOrder) do
				local weight = crateData.rarityWeights[rarity]
				if weight and weight > 0 then
					Codex.createProbabilityBar(barsPanel, rarity, weight)
					print("[Codex] Created bar for " .. rarity .. ": " .. weight .. "%")
				end
			end
			
			-- Add bonus essences bar if available
			if crateData.bonusEssences then
				Codex.createBonusEssencesBar(barsPanel, crateData.bonusEssences.amount, 
					crateData.bonusEssences.chance)
			end
		else
			print("[Codex ERROR] No rarityWeights found in crateData")
		end
	end

	-- Setup Open button
	local openButton = displayPanel:getChildById("OpenCrateButton")
	if openButton then
		local ownedCount = 0
		if crateId == 1 then ownedCount = Codex.cachedBronzeCrates
		elseif crateId == 2 then ownedCount = Codex.cachedSilverCrates
		elseif crateId == 3 then ownedCount = Codex.cachedGoldenCrates
		end
		
		openButton:setEnabled(ownedCount > 0)
		openButton.onClick = function()
			-- Block opening if animation is in progress
			if Codex.crateAnimationInProgress then
				print("[Codex] Cannot open crate - animation in progress")
				return
			end
			
			print("[Codex] Opening crate: " .. crateId)
			Codex.sendOpcode({
				topic = "open-crate-request",
				crateId = crateId
			})
		end
		print("[Codex] Open button configured, enabled: " .. tostring(ownedCount > 0))
	end
end

function Codex.createProbabilityBar(container, rarity, weight)
	local barContainer = g_ui.createWidget("UIWidget", container)
	barContainer:setSize({width = 400, height = 25})
	barContainer:setMarginTop(5)
	
	-- Rarity label with color (right-aligned)
	local label = g_ui.createWidget("Label", barContainer)
	label:setText(rarity:sub(1,1):upper() .. rarity:sub(2))
	label:setColor(Codex.rarityColors[rarity] or "#FFFFFF")
	label:addAnchor(AnchorLeft, "parent", AnchorLeft)
	label:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	label:setWidth(120)
	label:setTextAlign(AlignRight)
	
	-- Progress bar background
	local barBg = g_ui.createWidget("UIWidget", barContainer)
	barBg:addAnchor(AnchorLeft, "parent", AnchorLeft)
	barBg:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	barBg:setMarginLeft(130)
	barBg:setSize({width = 170, height = 15})
	barBg:setBackgroundColor("#2a2a2a")
	
	-- Progress bar fill
	local barFill = g_ui.createWidget("UIWidget", barBg)
	barFill:addAnchor(AnchorLeft, "parent", AnchorLeft)
	barFill:addAnchor(AnchorTop, "parent", AnchorTop)
	barFill:addAnchor(AnchorBottom, "parent", AnchorBottom)
	barFill:setWidth(math.floor(170 * weight / 100))
	barFill:setBackgroundColor(Codex.rarityColors[rarity] or "#FFFFFF")
	
	-- Percentage label
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
	
	-- Bonus label (right-aligned)
	local label = g_ui.createWidget("Label", barContainer)
	label:setText("Bonus Essences")
	label:setColor("#FFD700")
	label:addAnchor(AnchorLeft, "parent", AnchorLeft)
	label:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	label:setWidth(120)
	label:setTextAlign(AlignRight)
	
	-- Progress bar background
	local barBg = g_ui.createWidget("UIWidget", barContainer)
	barBg:addAnchor(AnchorLeft, "parent", AnchorLeft)
	barBg:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	barBg:setMarginLeft(130)
	barBg:setSize({width = 170, height = 15})
	barBg:setBackgroundColor("#2a2a2a")
	
	-- Progress bar fill
	local barFill = g_ui.createWidget("UIWidget", barBg)
	barFill:addAnchor(AnchorLeft, "parent", AnchorLeft)
	barFill:addAnchor(AnchorTop, "parent", AnchorTop)
	barFill:addAnchor(AnchorBottom, "parent", AnchorBottom)
	barFill:setWidth(math.floor(170 * chance / 100))
	barFill:setBackgroundColor("#FFD700")
	
	-- Percentage label
	local percentLabel = g_ui.createWidget("Label", barContainer)
	percentLabel:setText(chance .. "%")
	percentLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
	percentLabel:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	percentLabel:setMarginLeft(310)
	percentLabel:setColor("#FFD700")
end

function Codex.craftCrate(crateId)
	Codex.sendOpcode({
		topic = "craft-crate-request",
		crateId = crateId
	})
end

function Codex.showEssencesBonusOverlay(amount, crateId)
	print("[Codex DEBUG] showEssencesBonusOverlay called")
	print("[Codex DEBUG]   amount: " .. tostring(amount))
	print("[Codex DEBUG]   crateId: " .. tostring(crateId))
	
	local overlay = Codex.UI:getChildById("EssencesBonusOverlay")
	if not overlay then 
		print("[Codex ERROR] EssencesBonusOverlay not found")
		return 
	end

	local content = overlay:getChildById("EssencesBonusContent")
	if not content then 
		print("[Codex ERROR] EssencesBonusContent not found")
		return 
	end

	-- Setup essence image based on crate type
	local essenceImage = content:getChildById("BonusEssenceImage")
	if essenceImage then
		-- Image path: /images/codex/essences/bronze_50.png, silver_80.png, golden_120.png
		local crateNames = {[1] = "bronze", [2] = "silver", [3] = "golden"}
		local crateName = crateNames[crateId] or "bronze"
		local imagePath = "/images/codex/" .. crateName .. "_" .. amount .. ".png"
		print("[Codex DEBUG] Setting essence image: " .. imagePath)
		essenceImage:setImageSource(imagePath)
		essenceImage:setOpacity(0) -- Start invisible for fade-in
		
		-- Click to close with fade-out
		essenceImage.onClick = function()
			print("[Codex DEBUG] Essence clicked, fading out...")
			g_effects.fadeOut(essenceImage, 300)
			scheduleEvent(function()
				overlay:hide()
				-- Refresh collection UI if visible
				if Codex.currentTab == Codex.TAB_COLLECTION then
					Codex.setupCollectionUI()
				end
			end, 300)
		end
	else
		print("[Codex ERROR] BonusEssenceImage not found")
	end

	-- Setup amount label
	local amountLabel = content:getChildById("BonusEssenceAmount")
	if amountLabel then
		amountLabel:setText("+" .. amount .. " Codex Essences!")
	end

	-- Show overlay
	print("[Codex DEBUG] Showing essences overlay...")
	overlay:show()
	overlay:raise()
	overlay:focus()

	-- Fade in animation
	if essenceImage then
		scheduleEvent(function()
			print("[Codex DEBUG] Starting essence fade-in animation")
			g_effects.fadeIn(essenceImage, 500) -- 500ms fade-in
		end, 100)
	end
end

function Codex.showCardObtainedOverlay(cardId, cardLevel, rarityColor, bonusEssences, crateId)
	print("[Codex DEBUG] showCardObtainedOverlay called")
	print("[Codex DEBUG]   cardId: " .. tostring(cardId))
	print("[Codex DEBUG]   cardLevel: " .. tostring(cardLevel))
	print("[Codex DEBUG]   bonusEssences: " .. tostring(bonusEssences))
	print("[Codex DEBUG]   crateId: " .. tostring(crateId))
	
	local overlay = Codex.UI:getChildById("CardObtainedOverlay")
	if not overlay then 
		print("[Codex ERROR] CardObtainedOverlay not found")
		return 
	end

	local content = overlay:getChildById("CardObtainedContent")
	if not content then 
		print("[Codex ERROR] CardObtainedContent not found")
		return 
	end

	local cardData = Codex.cachedCardDatabase[cardId]
	if not cardData then 
		print("[Codex ERROR] Card data not found for cardId: " .. cardId)
		return 
	end
	print("[Codex DEBUG] Card data found: " .. cardData.name)

	-- Setup card image
	local cardImage = content:getChildById("ObtainedCardImage")
	if cardImage then
		local imagePath = Codex.cardImagesPath .. cardData.cardFrame .. ".png"
		print("[Codex DEBUG] Setting image: " .. imagePath)
		cardImage:setImageSource(imagePath)
		cardImage:setOpacity(0) -- Start invisible for fade-in
		
		-- Make card data available for tooltip
		cardImage.cardId = cardId
		cardImage.cardData = cardData
		
		-- Enable tooltip on hover
		cardImage.onHoverChange = Codex.onCardHoverChange
	else
		print("[Codex ERROR] ObtainedCardImage not found")
	end

	-- Setup card name
	local nameLabel = content:getChildById("ObtainedCardName")
	if nameLabel then
		nameLabel:setText(cardData.name)
		nameLabel:setOpacity(0) -- Start invisible
		local color = rarityColor or Codex.rarityColors[cardData.rarity] or "#FFFFFF"
		nameLabel:setColor(color)
	end

	-- Setup level info
	local levelLabel = content:getChildById("ObtainedCardLevel")
	if levelLabel then
		local text = ""
		if cardLevel > 1 then
			text = "LEVEL UP! -> Level " .. cardLevel
		else
			text = "NEW CARD! Level " .. cardLevel
		end
		levelLabel:setText(text)
		levelLabel:setOpacity(0) -- Start invisible
		-- Use rarity color for level too
		local color = rarityColor or Codex.rarityColors[cardData.rarity] or "#FFFFFF"
		levelLabel:setColor(color)
	end

	-- Show overlay
	print("[Codex DEBUG] Showing overlay...")
	overlay:show()
	overlay:raise()
	overlay:focus()

	-- Block crate opening during animation
	Codex.crateAnimationInProgress = true
	print("[Codex DEBUG] Crate opening BLOCKED during animation")

	-- Suspense effect (2 seconds before revealing card)
	print("[Codex DEBUG] Creating suspense effect...")
	local suspenseEffect = g_ui.createWidget('CardSuspenseEffect', overlay)
	if suspenseEffect then
		
		suspenseEffect:raise()
		print("[Codex DEBUG] Suspense effect created")
		
		-- Destroy suspense and reveal card after 2 seconds
		scheduleEvent(function()
			-- Unblock crate opening after suspense
			Codex.crateAnimationInProgress = false
			print("[Codex DEBUG] Crate opening UNBLOCKED")
			
			if suspenseEffect then
				suspenseEffect:destroy()
				print("[Codex DEBUG] Suspense effect destroyed")
			end
			
			-- NOW reveal the card with all effects
			if cardImage then
				print("[Codex DEBUG] Starting fade-in animation")
				g_effects.fadeIn(cardImage, 500) -- 500ms fade-in
				
				-- Fade in name and level labels at the same time
				if nameLabel then
					g_effects.fadeIn(nameLabel, 500)
				end
				if levelLabel then
					g_effects.fadeIn(levelLabel, 500)
				end
				
				-- Common close function with fade-out
				local closeOverlay = function()
					print("[Codex DEBUG] Closing overlay with fade-out...")
					-- Fade out all visible elements
					if cardImage then g_effects.fadeOut(cardImage, 300) end
					if nameLabel then g_effects.fadeOut(nameLabel, 300) end
					if levelLabel then g_effects.fadeOut(levelLabel, 300) end
					
					-- Wait for fade-out to complete
					scheduleEvent(function()
						overlay:hide()
						
						-- Check if there's bonus essences to show
						if bonusEssences and bonusEssences > 0 and crateId then
							print("[Codex DEBUG] Showing bonus essences overlay...")
							Codex.showEssencesBonusOverlay(bonusEssences, crateId)
						else
							-- Refresh collection UI if visible
							if Codex.currentTab == Codex.TAB_COLLECTION then
								Codex.setupCollectionUI()
							end
						end
					end, 300)
				end
				
				-- Make card clickable
				cardImage.onClick = closeOverlay
				
				-- Add particle effect
				print("[Codex DEBUG] Creating particle effect...")
				local particle = g_ui.createWidget('CardObtainedParticles', cardImage)
				if particle then
					particle:fill('parent')
					particle:setOpacity(0.75) -- Semi-transparent
					particle:setFocusable(true) -- Make clickable
					particle.onClick = closeOverlay -- Same close function
					-- Destroy particle after 1.5 seconds
					scheduleEvent(function() 
						if particle then
							particle:destroy() 
							print("[Codex DEBUG] Particle effect destroyed")
						end
					end, 1500)
				else
					print("[Codex ERROR] Failed to create particle effect")
				end
				
				-- Add UIEffect (effect 1075 from .dat)
				print("[Codex DEBUG] Creating UIEffect (1075)...")
				local effectWidget = g_ui.createWidget('CardEffectWidget', cardImage)
				if effectWidget then
					effectWidget:fill('parent')
					effectWidget:setFocusable(true) -- Make clickable
					effectWidget.onClick = closeOverlay -- Same close function
					-- Destroy effect after 600ms
					scheduleEvent(function()
						if effectWidget then
							effectWidget:destroy()
							print("[Codex DEBUG] UIEffect destroyed")
						end
					end, 600)
				else
					print("[Codex ERROR] Failed to create UIEffect")
				end
			end
		end, 2000) -- 2 seconds suspense
	else
		print("[Codex ERROR] Failed to create suspense effect")
	end
end

------ Tooltip Management (keeping old showCrateResults for backward compatibility)

function Codex.showCrateResults(rewards)
	-- This function is deprecated, now using showCrateOptionsOverlay
	print("[Codex] showCrateResults deprecated, use showCrateOptionsOverlay")
end

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
	
	-- Set card name with rarity color
	local rarityColor = Codex.rarityColors[cardData.rarity] or "#ffffff"
	Codex.Tooltip:setText(cardData.name)
	Codex.Tooltip:setColor(rarityColor)
	
	-- Set level info in description label
	if Codex.Tooltip.description then
		local levelInfo = "Level " .. cardLevel .. "/" .. cardData.maxLevel .. " - " .. (cardData.rarity or "common"):upper()
		Codex.Tooltip.description:setText(levelInfo)
		Codex.Tooltip.description:setColor("#ffffff")
	end
	
	if Codex.Tooltip.trigger then
		-- Limpiar widgets hijos existentes (iconos previos)
		Codex.Tooltip.trigger:destroyChildren()
		
		local triggerIconPath = Codex.triggerIcons[cardData.trigger]
		if triggerIconPath then
			-- Crear widget de icono centrado
			local iconWidget = g_ui.createWidget("UIWidget", Codex.Tooltip.trigger)
			iconWidget:setImageSource(triggerIconPath)
			iconWidget:setSize({width = 16, height = 16})
			iconWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			iconWidget:addAnchor(AnchorTop, "parent", AnchorTop)
			
			-- Texto del trigger centrado debajo del icono (usando text-offset vertical)
			Codex.Tooltip.trigger:setText(cardData.trigger)
			Codex.Tooltip.trigger:setColor("#ffaa00")
			Codex.Tooltip.trigger:setTextOffset({x = 0, y = 14}) -- Bajar solo el texto, no el icono
		else
			Codex.Tooltip.trigger:setText(cardData.trigger)
			Codex.Tooltip.trigger:setColor("#ffaa00")
			Codex.Tooltip.trigger:setTextOffset({x = 0, y = 0})
		end
	end
	
	-- Set card description in cardDesc label
	if Codex.Tooltip.cardDesc then
		local desc = cardData.description[cardLevel] or cardData.description[1] or "No description"
		Codex.Tooltip.cardDesc:setText(desc)
		Codex.Tooltip.cardDesc:setColor("#ffffff")
	end
	
	-- Set exp bar and label (if not max level)
	if Codex.Tooltip.expBar and Codex.Tooltip.expLabel then
		if cardLevel < cardData.maxLevel then
			local currentExp = Codex.cachedCardsExp[cardData.id] or 0
			local expNeeded = Codex.cardExpTable[cardLevel] or 1
			local expPercent = math.floor((currentExp / expNeeded) * 100)
			
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
	
	-- Calculate dynamic height based on text content
	scheduleEvent(function()
		local descHeight = Codex.Tooltip.description and Codex.Tooltip.description:getHeight() or 0
		local triggerHeight = Codex.Tooltip.trigger and Codex.Tooltip.trigger:getHeight() or 0
		local cardDescHeight = Codex.Tooltip.cardDesc and Codex.Tooltip.cardDesc:getHeight() or 0
		local expBarHeight = (Codex.Tooltip.expBar and Codex.Tooltip.expBar:isVisible()) and 18 or 0
		local totalHeight = 70 + descHeight + triggerHeight + cardDescHeight + expBarHeight -- 70 = padding + title + margins
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
		Codex.cachedBronzeCrates = data.bronzeCrates or 0
		Codex.cachedSilverCrates = data.silverCrates or 0
		Codex.cachedGoldenCrates = data.goldenCrates or 0
		
		-- Reset temp database for batch accumulation
		Codex.tempCardDatabase = {}
		Codex.baseDataReceived = true
		
		print("[Codex] Base data received, waiting for batches...")
		
	elseif data.topic == "card-database-batch" then
		-- Accumulate card batches and merge with local descriptions
		if data.cards then
			for cardIdStr, serverData in pairs(data.cards) do
				local cardId = tonumber(cardIdStr)
				if cardId then
					-- Get local description data
					local localData = Codex.cardDescriptions[cardId]
					if localData then
						-- Merge: server data (mechanical) + client data (UI)
						Codex.tempCardDatabase[cardId] = {
							id = serverData.id,
							storage = serverData.storage,
							maxLevel = serverData.maxLevel,
							-- From client descriptions file:
							name = localData.name,
							rarity = localData.rarity,
							trigger = localData.trigger,
							cardFrame = localData.cardFrame,
							description = localData.descriptions
						}
					else
						print("[Codex WARNING] No local description found for card ID: " .. cardId)
						Codex.tempCardDatabase[cardId] = serverData
					end
				end
			end
			
			local cardCount = 0
			for _ in pairs(Codex.tempCardDatabase) do
				cardCount = cardCount + 1
			end
			print("[Codex] Received batch " .. (data.batchIndex or "?") .. ", total cards: " .. cardCount)
		end
		
	elseif data.topic == "crate-database" then
		-- Store crate database
		Codex.cachedCrateDatabase = {}
		local crateCount = 0
		for crateIdStr, crateData in pairs(data.crates or {}) do
			local crateId = tonumber(crateIdStr)
			if crateId then
				Codex.cachedCrateDatabase[crateId] = crateData
				crateCount = crateCount + 1
				print("[Codex] Stored crate " .. crateId .. ": " .. (crateData.name or "unknown"))
				if crateData.rarityWeights then
					print("[Codex]   Has rarityWeights")
				else
					print("[Codex]   WARNING: No rarityWeights!")
				end
			end
		end
		print("[Codex] Crate database received, total crates: " .. crateCount)
		
	elseif data.topic == "base-data-complete" then
		-- Finalize: move temp database to actual database
		if Codex.baseDataReceived then
			Codex.cachedCardDatabase = Codex.tempCardDatabase
			
			local cardCount = 0
			for _ in pairs(Codex.cachedCardDatabase) do
				cardCount = cardCount + 1
			end
			
			print("[Codex] Base data loading complete! Total cards: " .. cardCount)
			
			-- Now refresh UI
			Codex.switchTab(Codex.currentTab)
		else
			print("[Codex ERROR] Received complete signal but no base data!")
		end

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
			-- Solo actualizar slots activos, no recrear todo el UI
			Codex.updateActiveSlots()
		end

	elseif data.topic == "currency-update" then
		Codex.cachedEssences = data.essences or 0
		if Codex.UI.EssencesLabel then
			Codex.UI.EssencesLabel:setText("Codex Essences: " .. Codex.cachedEssences)
		end

	elseif data.topic == "crates-update" then
		Codex.cachedBronzeCrates = data.bronzeCrates or 0
		Codex.cachedSilverCrates = data.silverCrates or 0
		Codex.cachedGoldenCrates = data.goldenCrates or 0
		-- Refresh crates UI if visible
		if Codex.currentTab == Codex.TAB_CRATES then
			Codex.setupCratesUI()
		end

	elseif data.topic == "open-crate-reply" then
		print("[Codex DEBUG] Received open-crate-reply")
		print("[Codex DEBUG]   success: " .. tostring(data.success))
		
		if data.success and data.cardData then
			print("[Codex DEBUG] Card obtained: " .. tostring(data.cardData.name))
			print("[Codex DEBUG]   cardId: " .. tostring(data.cardData.cardId))
			print("[Codex DEBUG]   level: " .. tostring(data.cardData.level))
			print("[Codex DEBUG]   leveledUp: " .. tostring(data.cardData.leveledUp))
			print("[Codex DEBUG]   bonusEssences: " .. tostring(data.cardData.bonusEssences))
			print("[Codex DEBUG]   crateId: " .. tostring(data.cardData.crateId))
			
			-- Show card directly in overlay with fade-in
			Codex.showCardObtainedOverlay(
				data.cardData.cardId, 
				data.cardData.level, 
				Codex.rarityColors[data.cardData.rarity],
				data.cardData.bonusEssences,
				data.cardData.crateId
			)
		elseif data.message then
			print("[Codex DEBUG] Showing error message: " .. data.message)
			Codex.setupMessage("Crate Opening Failed", data.message)
		else
			print("[Codex ERROR] Unknown open-crate-reply state")
		end

	elseif data.topic == "crate-reward-selected" then
		print("[Codex DEBUG] Received crate-reward-selected")
		print("[Codex DEBUG]   success: " .. tostring(data.success))
		print("[Codex DEBUG]   cardId: " .. tostring(data.cardId))
		print("[Codex DEBUG]   level: " .. tostring(data.level))
		
		if data.success then
			-- Hide options overlay first
			local optionsOverlay = Codex.UI:getChildById("CrateOptionsOverlay")
			if optionsOverlay then
				print("[Codex DEBUG] Hiding options overlay")
				optionsOverlay:hide()
			else
				print("[Codex ERROR] CrateOptionsOverlay not found to hide")
			end
			
			-- Get card data for rarity color
			local cardData = Codex.cachedCardDatabase[data.cardId]
			if cardData then
				print("[Codex DEBUG] Card found in cache: " .. cardData.name)
				print("[Codex DEBUG] Card rarity: " .. tostring(cardData.rarity))
			else
				print("[Codex ERROR] Card not found in cache for cardId: " .. tostring(data.cardId))
			end
			
			local rarityColor = cardData and Codex.rarityColors[cardData.rarity] or "#FFFFFF"
			print("[Codex DEBUG] Calculated rarity color: " .. rarityColor)
			
			-- Show card obtained overlay with fade-in animation
			print("[Codex DEBUG] Calling showCardObtainedOverlay...")
			Codex.showCardObtainedOverlay(data.cardId, data.level, rarityColor)
			
			-- Refresh UI
			if Codex.currentTab == Codex.TAB_COLLECTION then
				print("[Codex DEBUG] Refreshing collection UI")
				Codex.setupCollectionUI()
			end
		else
			print("[Codex DEBUG] Crate reward selection failed: " .. tostring(data.message))
			Codex.setupMessage("Selection Failed", data.message)
		end

	elseif data.topic == "message-reply" then
		if data.title and data.message then
			Codex.setupMessage(data.title, data.message)
		end
	end
end
