tokennpcWindow = nil
itemsPanel = nil
radioTabs = nil
radioItems = nil
searchText = nil
setupPanel = nil
quantity = nil
quantityScroll = nil
nameLabel = nil
TokendescLabel = nil
priceLabel = nil
moneyLabel = nil
weightDesc = nil
weightLabel = nil
capacityDesc = nil
capacityLabel = nil
tradeButton = nil

ignoreCapacity = nil

playerFreeCapacity = 0
playerTokenpoints = 0
--playerTokenLevel = 0
tradeItems = {}
selectedTokenItem = nil

function init()
	tokennpcWindow = g_ui.displayUI('tokenshop')
	tokennpcWindow:setVisible(false)

	itemsPanel = tokennpcWindow:recursiveGetChildById('TokenitemsPanel')
	searchText = tokennpcWindow:recursiveGetChildById('TokensearchText')

	setupPanel = tokennpcWindow:recursiveGetChildById('TokensetupPanel')
	quantityScroll = setupPanel:getChildById('TokenquantityScroll')
	nameLabel = setupPanel:getChildById('Tokenname')
	TokendescLabel = setupPanel:getChildById('Tokendesc')
	priceLabel = setupPanel:getChildById('Tokenprice')
	moneyLabel = setupPanel:getChildById('Tokenmoney')
	weightDesc = setupPanel:getChildById('weightDesc')
	weightLabel = setupPanel:getChildById('Tokenweight')
	capacityDesc = setupPanel:getChildById('TokencapacityDesc')
	capacityLabel = setupPanel:getChildById('Tokencapacity')
	tradeButton = tokennpcWindow:recursiveGetChildById('TokentradeButton')

	ignoreCapacity = tokennpcWindow:recursiveGetChildById('TokenignoreCapacity')

	if g_game.isOnline() then
		playerFreeCapacity = g_game.getLocalPlayer():getFreeCapacity()
	end

	connect(g_game, { onGameEnd = hide })

	connect(LocalPlayer, { onFreeCapacityChange = onFreeCapacityChange, onInventoryChange = onInventoryChange })

	ProtocolGame.registerOpcode(GameServerOpcodes.GameServerOpentokenShop , parseTokenShop)
end

function terminate()
	tokennpcWindow:destroy()

	disconnect(g_game, {onGameEnd = hide })

	disconnect(LocalPlayer, { onFreeCapacityChange = onFreeCapacityChange, onInventoryChange = onInventoryChange })

	ProtocolGame.unregisterOpcode(GameServerOpcodes.GameServerOpentokenShop , parseTokenShop)
end

function show()
	if g_game.isOnline() then
		tokennpcWindow:show()
		tokennpcWindow:raise()
		tokennpcWindow:focus()
	end
end

function hide()
	tokennpcWindow:hide()
        modules.game_interface.getRootPanel():focus()
end

function onItemBoxChecked(widget)
	if widget:isChecked() then
		local item = widget.item
		selectedTokenItem = item
		TokenrefreshItem(item)
		tradeButton:enable()
	end
end

function onQuantityValueChange(quantity)
	if selectedTokenItem then
		weightLabel:setText(string.format('%.2f', selectedTokenItem.weight * quantity) .. ' ' .. 'oz')
		priceLabel:setText(formatCurrency(getTokenItemPrice(selectedTokenItem)) .. ' ' .. item.TokenName)
	end
end

function onTradeTokenClick()
	local protocol = g_game.getProtocolGame()
	if not protocol then
		return
	end
	
	local msg = OutputMessage.create()
	msg:addU8(ClientOpcodes.ClientTokenBuy)
	msg:addU16(selectedTokenItem.id)
	msg:addU32(selectedTokenItem.price)
	msg:addU16(tonumber(quantityScroll:getValue()))
	msg:addU16(selectedTokenItem.Tokenid)
	protocol:send(msg)
end

function onSearchTextChange()
	TokenrefreshPlayerGoods()

end
function onIgnoreCapacityChange()
	TokenrefreshPlayerGoods()
end

function TokenclearselectedTokenItem()
	nameLabel:clearText()
	weightLabel:clearText()
	priceLabel:clearText()
	tradeButton:disable()
	quantityScroll:setMinimum(0)
	quantityScroll:setMaximum(0)
	if selectedTokenItem then
		if radioItems then
			radioItems:selectWidget(nil)
		end
		selectedTokenItem = nil
	end
end

function getTokenItemPrice(item, single)
	local amount = 1
	local single = single or false
	if not single then
		amount = quantityScroll:getValue()
	end
	return item.price * amount
end

function canTradeTokenItem(item)
	return (ignoreCapacity:isChecked() or (not ignoreCapacity:isChecked() and playerFreeCapacity >= item.weight)) and playerTokenpoints >= getTokenItemPrice(item, true)
end

function TokenrefreshItem(item)
	nameLabel:setText(item.name)
	weightLabel:setText(string.format('%.2f', item.weight) .. ' ' .. 'oz')
	priceLabel:setText(formatCurrency(getTokenItemPrice(item)) .. ' ' .. item.TokenName)
    TokendescLabel:setText(item.Tokendesc)
	local capacityMaxCount = math.floor(playerFreeCapacity / item.weight)
	if ignoreCapacity:isChecked() then
		capacityMaxCount = 65535
	end

	local priceMaxCount = math.floor(playerTokenpoints / getTokenItemPrice(item, true))
	local finalCount = math.max(0, math.min(100, math.min(priceMaxCount, capacityMaxCount)))
	quantityScroll:setMinimum(1)
	quantityScroll:setMaximum(finalCount)

	setupPanel:enable()
end

function TokenrefreshTradeItems()
	TokenclearselectedTokenItem()

	searchText:clearText()
	setupPanel:disable()
	itemsPanel:destroyChildren()

	if radioItems then
		radioItems:destroy()
	end
	radioItems = UIRadioGroup.create()

	for key, item in pairs(tradeItems) do
		local itemBox = g_ui.createWidget('tokennpcItemBox', itemsPanel)
		itemBox.item = item

		local text = item.name

		--text = text .. '\n' .. item.TokenLevel .. " Token level"

		local price = formatCurrency(item.price) .. ' ' .. item.TokenName
		text = text .. '\n' .. price
		itemBox:setText(text)

		local itemWidget = itemBox:getChildById('Tokenitem')
		itemWidget:setItemId(item.clientId)
		itemWidget:setVirtual(true)
		itemWidget:setItemCount(item.amount)
		--rarity
		--print(item.name.."|rarity:"..tostring(item.rarity))
		local tierImgPath = "/images/ui/slots/item"
		if item.rarity == 0 then
			tierImgPath = "/images/ui/item"
		elseif item.rarity == 1 then
			tierImgPath = tierImgPath .. "Common"
		elseif item.rarity == 2 then
			tierImgPath = tierImgPath .. "Rare"
		elseif item.rarity == 3 then
			tierImgPath = tierImgPath .. "Epic"
		elseif item.rarity == 4 then
			tierImgPath = tierImgPath .. "Legendary"
		else
			tierImgPath = "/images/ui/item"
		end
		--print("tierImgPath:"..tostring(tierImgPath))
		itemWidget:setImageSource(tierImgPath)
		radioItems:addWidget(itemBox)
	end
end

function TokenrefreshPlayerGoods()
	
	
	capacityLabel:setText(string.format('%.2f', playerFreeCapacity) .. ' ' .. 'oz')

	local searchFilter = searchText:getText():lower()
	local foundselectedTokenItem = false

	local items = itemsPanel:getChildCount()
	for i = 1, items do
		local itemWidget = itemsPanel:getChildByIndex(i)
		local item = itemWidget.item

		local canTradeToken = canTradeTokenItem(item)
		itemWidget:setOn(canTradeToken)
		itemWidget:setEnabled(canTradeToken)
		moneyLabel:setText(item.playerTokenpoints)
		local searchCondition = (searchFilter == '') or (searchFilter ~= '' and string.find(item.name:lower(), searchFilter) ~= nil)
		itemWidget:setVisible(searchCondition)

		if selectedTokenItem == item and itemWidget:isEnabled() and itemWidget:isVisible() then
			foundselectedTokenItem = true
			moneyLabel:setText(selectedTokenItem.playerTokenpoints)
		end
	end

	if not foundselectedTokenItem then
		TokenclearselectedTokenItem()
	end

	if selectedTokenItem then
		TokenrefreshItem(selectedTokenItem)
	end
end

function parseTokenShop(protocol, msg)
	-- parse info
	tradeItems = {}
	local size = msg:getU16()
	for i = 1, size do
		local item = {}
		item.id = msg:getU16()
		item.clientId = msg:getU16()
		item.rarity = msg:getU8()
		item.price = msg:getU32()
		item.amount = msg:getU16()
		--item.TokenLevel = msg:getU32()
		item.weight = msg:getU32()
		item.name = msg:getString()
		item.Tokendesc = msg:getString()
		item.Tokenid = msg:getU16()
		item.TokenName = msg:getString()
		playerTokenpoints = msg:getU32()
		tradeItems[#tradeItems + 1] = item
		
	end


	--playerTokenLevel = msg:getU32()

	TokenrefreshTradeItems()
	TokenrefreshPlayerGoods()
	addEvent(show) -- player goods has not been parsed yet
end

function onFreeCapacityChange(localPlayer, freeCapacity, oldFreeCapacity)
	playerFreeCapacity = freeCapacity

	if tokennpcWindow:isVisible() then
		TokenrefreshPlayerGoods()
	end
end

function onInventoryChange(inventory, item, oldItem)
	if tokennpcWindow:isVisible() then
		TokenrefreshPlayerGoods()
	end
end

function formatCurrency(amount)


	return amount 
end
