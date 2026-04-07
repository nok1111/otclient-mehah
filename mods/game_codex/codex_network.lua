if not Codex then Codex = {} end

-- [Controller] Network and Opcodes for Codex

function Codex.initNetwork()
	ProtocolGame.registerExtendedOpcode(Codex.opCode, Codex.onExtendedOpcode)
end

function Codex.terminateNetwork()
	ProtocolGame.unregisterExtendedOpcode(Codex.opCode)
end

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
		Codex.cachedCards = {}
		Codex.cachedCardsExp = {}
		for cardIdStr, cardInfo in pairs(data.cards or {}) do
			local cardId = tonumber(cardIdStr)
			if cardId then
				if type(cardInfo) == "table" then
					Codex.cachedCards[cardId] = cardInfo.level
					Codex.cachedCardsExp[cardId] = cardInfo.exp or 0
				else
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
		Codex.cachedParagonLevel = data.paragonLevel or 0
		Codex.cachedPlayerLevel = data.playerLevel or 1
		Codex.cachedIsPremium = data.isPremium or false
		Codex.cachedEarlySlotUnlocks = data.earlySlotUnlocks or 0
		Codex.cachedNextEarlySlotUnlockCost = data.nextEarlySlotUnlockCost
			or Codex.getEarlySlotUnlockCost(Codex.cachedEarlySlotUnlocks)
		Codex.cachedBronzeCrates = data.bronzeCrates or 0
		Codex.cachedSilverCrates = data.silverCrates or 0
		Codex.cachedGoldenCrates = data.goldenCrates or 0
		
		-- Cache slot unlock status
		Codex.cachedSlotUnlockStatus = {}
		for slotStr, slotInfo in pairs(data.slotUnlockStatus or {}) do
			local slotIndex = tonumber(slotStr)
			if slotIndex then
				Codex.cachedSlotUnlockStatus[slotIndex] = {
					unlocked = slotInfo.unlocked,
					requirement = slotInfo.requirement
				}
			end
		end
		
		Codex.tempCardDatabase = {}
		Codex.baseDataReceived = true
		
	elseif data.topic == "card-database-batch" then
		if data.cards then
			for cardIdStr, serverData in pairs(data.cards) do
				local cardId = tonumber(cardIdStr)
				if cardId then
					local localData = Codex.cardDescriptions[cardId]
					if localData then
						Codex.tempCardDatabase[cardId] = {
							id = serverData.id,
							storage = serverData.storage,
							maxLevel = serverData.maxLevel,
							name = localData.name,
							rarity = localData.rarity,
							trigger = localData.trigger,
							cardFrame = localData.cardFrame,
							description = localData.descriptions
						}
					else
						Codex.tempCardDatabase[cardId] = serverData
					end
				end
			end
		end
		
	elseif data.topic == "crate-database" then
		Codex.cachedCrateDatabase = {}
		for crateIdStr, crateData in pairs(data.crates or {}) do
			local crateId = tonumber(crateIdStr)
			if crateId then
				Codex.cachedCrateDatabase[crateId] = crateData
			end
		end
		
	elseif data.topic == "base-data-complete" then
		if Codex.baseDataReceived then
			Codex.cachedCardDatabase = Codex.tempCardDatabase
			Codex.switchTab(Codex.currentTab)
		end

	elseif data.topic == "collection-update" then
		local cardId = tonumber(data.cardId)
		if cardId then
			Codex.cachedCards[cardId] = data.level
			Codex.cachedCardsExp[cardId] = data.exp or 0
			if Codex.currentTab == Codex.TAB_COLLECTION then
				Codex.setupCollectionUI()
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
			Codex.updateActiveSlots()
		end

	elseif data.topic == "currency-update" then
		Codex.cachedEssences = data.essences or 0
		if Codex.UI and Codex.UI.EssencesLabel then
			Codex.UI.EssencesLabel:setText("Codex Essences: " .. Codex.cachedEssences)
		end

	elseif data.topic == "crates-update" then
		Codex.cachedBronzeCrates = data.bronzeCrates or 0
		Codex.cachedSilverCrates = data.silverCrates or 0
		Codex.cachedGoldenCrates = data.goldenCrates or 0
		if Codex.currentTab == Codex.TAB_CRATES then
			Codex.cratesHandlersConnected = false
			Codex.setupCratesUI()
		end

	elseif data.topic == "open-crate-reply" then
		if data.success and data.cardData then
			Codex.showCardObtainedOverlay(
				data.cardData.cardId, 
				data.cardData.level, 
				Codex.rarityColors[data.cardData.rarity],
				data.cardData.bonusEssences,
				data.cardData.crateId
			)
		elseif data.message then
			Codex.setupMessage("Crate Opening Failed", data.message)
		end

	elseif data.topic == "crate-reward-selected" then
		if data.success then
			local optionsOverlay = Codex.UI:getChildById("CrateOptionsOverlay")
			if optionsOverlay then
				optionsOverlay:hide()
			end
			local cardData = Codex.cachedCardDatabase[data.cardId]
			local rarityColor = cardData and Codex.rarityColors[cardData.rarity] or "#FFFFFF"
			Codex.showCardObtainedOverlay(data.cardId, data.level, rarityColor)
			
			if Codex.currentTab == Codex.TAB_COLLECTION then
				Codex.setupCollectionUI()
			end
		else
			Codex.setupMessage("Selection Failed", data.message)
		end

	elseif data.topic == "feed-card-exp-reply" then
		if data.success then
			if data.newLevel then
				Codex.cachedCards[data.cardId] = data.newLevel
			end
			if data.newExp ~= nil then
				Codex.cachedCardsExp[data.cardId] = data.newExp
			end
			if data.newEssences ~= nil then
				Codex.cachedEssences = data.newEssences
				if Codex.UI and Codex.UI.EssencesLabel then
					Codex.UI.EssencesLabel:setText("Codex Essences: " .. data.newEssences)
				end
			end
			
			if Codex.currentTab == Codex.TAB_UPGRADE then
				Codex.setupUpgradeUI()
			end
		else
			Codex.setupMessage("Cannot Upgrade", data.message or "Not enough resources")
		end

	elseif data.topic == "message-reply" then
		if data.title and data.message then
			Codex.setupMessage(data.title, data.message)
		end
	end
end
