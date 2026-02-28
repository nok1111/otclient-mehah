if not Codex then Codex = {} end

-- [Model] Central Data Storage for Codex

Codex.cachedCards = {}
Codex.cachedCardsExp = {}
Codex.cachedActiveCards = {}
Codex.cachedEssences = 0
Codex.cachedMaxSlots = 3
Codex.cachedParagonLevel = 0
Codex.cachedEarlySlotUnlocks = 0
Codex.cachedNextEarlySlotUnlockCost = 500
Codex.cachedCardDatabase = {}
Codex.cachedCrateDatabase = {}
Codex.cachedBronzeCrates = 0
Codex.cachedSilverCrates = 0
Codex.cachedGoldenCrates = 0

-- State tags
Codex.tempCardDatabase = {}
Codex.baseDataReceived = false
Codex.craftingInProgress = false
Codex.crateAnimationInProgress = false
Codex.cratesHandlersConnected = false

-- UI State
Codex.currentTab = Codex.TAB_COLLECTION or 1
Codex.selectedCrateId = 1
Codex.selectedUpgradeCardId = nil
Codex.selectedCardId = nil
Codex.currentCollectionPage = 1

-- Helper to check if a card is equipped
function Codex.isCardEquipped(cardId)
	for slot, equippedCardId in pairs(Codex.cachedActiveCards) do
		if equippedCardId == cardId then
			return true
		end
	end
	return false
end
