famenpcWindow = nil
itemsPanel = nil
radioTabs = nil
radioItems = nil
searchText = nil
setupPanel = nil
quantity = nil
quantityScroll = nil
nameLabel = nil
famedescLabel = nil
priceLabel = nil
moneyLabel = nil
weightDesc = nil
weightLabel = nil
capacityDesc = nil
capacityLabel = nil
tradeButton = nil

ignoreCapacity = nil

playerFreeCapacity = 0
playerfamepoints = 0
playerFameLevel = 0
tradeItems = {}
selectedItem = nil

function init()
	famenpcWindow = g_ui.displayUI('famenpcshop')
	famenpcWindow:setVisible(false)

	itemsPanel = famenpcWindow:recursiveGetChildById('fameitemsPanel')
	searchText = famenpcWindow:recursiveGetChildById('famesearchText')

	setupPanel = famenpcWindow:recursiveGetChildById('famesetupPanel')
	quantityScroll = setupPanel:getChildById('famequantityScroll')
	nameLabel = setupPanel:getChildById('famename')
	famedescLabel = setupPanel:getChildById('famedesc')
	priceLabel = setupPanel:getChildById('fameprice')
	moneyLabel = setupPanel:getChildById('famemoney')
	weightDesc = setupPanel:getChildById('weightDesc')
	weightLabel = setupPanel:getChildById('fameweight')
	capacityDesc = setupPanel:getChildById('famecapacityDesc')
	capacityLabel = setupPanel:getChildById('famecapacity')
	tradeButton = famenpcWindow:recursiveGetChildById('fametradeButton')

	ignoreCapacity = famenpcWindow:recursiveGetChildById('fameignoreCapacity')

	if g_game.isOnline() then
		playerFreeCapacity = g_game.getLocalPlayer():getFreeCapacity()
	end

	connect(g_game, { onGameEnd = hide })

	connect(LocalPlayer, { onFreeCapacityChange = onFreeCapacityChange, onInventoryChange = onInventoryChange })

	ProtocolGame.registerOpcode(GameServerOpcodes.GameServerOpenFameShop, parseNpcShop)
end

function terminate()
	famenpcWindow:destroy()

	disconnect(g_game, {onGameEnd = hide })

	disconnect(LocalPlayer, { onFreeCapacityChange = onFreeCapacityChange, onInventoryChange = onInventoryChange })

	ProtocolGame.unregisterOpcode(GameServerOpcodes.GameServerOpenFameShop, parseNpcShop)
end

function show()
	if g_game.isOnline() then
		famenpcWindow:show()
		famenpcWindow:raise()
		famenpcWindow:focus()
	end
end

function hide()
	famenpcWindow:hide()
	modules.game_interface.getRootPanel():focus()
end

function onItemBoxChecked(widget)
	if widget:isChecked() then
		local item = widget.item
		selectedItem = item
		famerefreshItem(item)
		tradeButton:enable()
	end
end

function onQuantityValueChange(quantity)
	if selectedItem then
		weightLabel:setText(string.format('%.2f', selectedItem.weight * quantity) .. ' ' .. 'oz')
		priceLabel:setText(formatCurrency(getFameItemPrice(selectedItem)))
	end
end

function onTradeClick()
	local protocol = g_game.getProtocolGame()
	if not protocol then
		return
	end
	
	local msg = OutputMessage.create()
	msg:addU8(ClientOpcodes.ClientFameShopBuy)
	msg:addU16(selectedItem.id)
	msg:addU32(selectedItem.price)
	msg:addU16(tonumber(quantityScroll:getValue()))
	protocol:send(msg)
end

function onSearchTextChange()
	famerefreshPlayerGoods()
end

function onIgnoreCapacityChange()
	famerefreshPlayerGoods()
end

function fameclearSelectedItem()
	nameLabel:clearText()
	weightLabel:clearText()
	priceLabel:clearText()
	tradeButton:disable()
	quantityScroll:setMinimum(0)
	quantityScroll:setMaximum(0)
	if selectedItem then
		if radioItems then
			radioItems:selectWidget(nil)
		end
		selectedItem = nil
	end
end

function getFameItemPrice(item, single)
	local amount = 1
	local single = single or false
	if not single then
		amount = quantityScroll:getValue()
	end
	return item.price * amount
end

function canTradeFameItem(item)
	return (ignoreCapacity:isChecked() or (not ignoreCapacity:isChecked() and playerFreeCapacity >= item.weight)) and playerfamepoints >= getFameItemPrice(item, true) and playerFameLevel >= item.fameLevel
end

function famerefreshItem(item)
	nameLabel:setText(item.name)
	weightLabel:setText(string.format('%.2f', item.weight) .. ' ' .. 'oz')
	priceLabel:setText(formatCurrency(getFameItemPrice(item)))
    famedescLabel:setText(item.famedesc)
	local capacityMaxCount = math.floor(playerFreeCapacity / item.weight)
	if ignoreCapacity:isChecked() then
		capacityMaxCount = 65535
	end

	local priceMaxCount = math.floor(playerfamepoints / getFameItemPrice(item, true))
	local finalCount = math.max(0, math.min(100, math.min(priceMaxCount, capacityMaxCount)))
	quantityScroll:setMinimum(1)
	quantityScroll:setMaximum(finalCount)

	setupPanel:enable()
end

function famerefreshTradeItems()
	fameclearSelectedItem()

	searchText:clearText()
	setupPanel:disable()
	itemsPanel:destroyChildren()

	if radioItems then
		radioItems:destroy()
	end
	radioItems = UIRadioGroup.create()

	for key, item in pairs(tradeItems) do
		local itemBox = g_ui.createWidget('fameNPCItemBox', itemsPanel)
		itemBox.item = item

		local text = item.name

		text = text .. '\n' .. item.fameLevel .. " fame level"

		local price = formatCurrency(item.price)
		text = text .. '\n' .. price
		itemBox:setText(text)

		local itemWidget = itemBox:getChildById('fameitem')
		itemWidget:setItemId(item.clientId)
		itemWidget:setVirtual(true)
		itemWidget:setItemCount(item.amount)

		radioItems:addWidget(itemBox)
	end
end

function famerefreshPlayerGoods()
	moneyLabel:setText(playerfamepoints)
	capacityLabel:setText(string.format('%.2f', playerFreeCapacity) .. ' ' .. 'oz')

	local searchFilter = searchText:getText():lower()
	local foundSelectedItem = false

	local items = itemsPanel:getChildCount()
	for i = 1, items do
		local itemWidget = itemsPanel:getChildByIndex(i)
		local item = itemWidget.item

		local canTradeFame = canTradeFameItem(item)
		itemWidget:setOn(canTradeFame)
		itemWidget:setEnabled(canTradeFame)

		local searchCondition = (searchFilter == '') or (searchFilter ~= '' and string.find(item.name:lower(), searchFilter) ~= nil)
		itemWidget:setVisible(searchCondition)

		if selectedItem == item and itemWidget:isEnabled() and itemWidget:isVisible() then
			foundSelectedItem = true
		end
	end

	if not foundSelectedItem then
		fameclearSelectedItem()
	end

	if selectedItem then
		famerefreshItem(selectedItem)
	end
end

function parseNpcShop(protocol, msg)
	-- parse info
	tradeItems = {}
	local size = msg:getU16()
	for i = 1, size do
		local item = {}
		item.id = msg:getU16()
		item.clientId = msg:getU16()
		item.price = msg:getU32()
		item.amount = msg:getU16()
		item.fameLevel = msg:getU32()
		item.weight = msg:getU32()
		item.name = msg:getString()
		item.famedesc = msg:getString()
		tradeItems[#tradeItems + 1] = item
	end

	playerfamepoints = msg:getU32()
	playerFameLevel = msg:getU32()

	famerefreshTradeItems()
	famerefreshPlayerGoods()
	addEvent(show) -- player goods has not been parsed yet
end

function onFreeCapacityChange(localPlayer, freeCapacity, oldFreeCapacity)
	playerFreeCapacity = freeCapacity

	if famenpcWindow:isVisible() then
		famerefreshPlayerGoods()
	end
end

function onInventoryChange(inventory, item, oldItem)
	if famenpcWindow:isVisible() then
		famerefreshPlayerGoods()
	end
end

function formatCurrency(amount)
	return amount .. ' ' .. "fame pts"
end
