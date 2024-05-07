enchantnpcWindow = nil
itemsPanel = nil
radioTabs = nil
radioItems = nil
searchText = nil
setupPanel = nil
quantity = nil
quantityScroll = nil
nameLabel = nil
enchantdescLabel = nil
priceLabel = nil
moneyLabel = nil
weightDesc = nil
weightLabel = nil
playerenchantLevel = nil
capacityDesc = nil
capacityLabel = nil
tradeButton = nil

ignoreCapacity = nil

playerFreeCapacity = 0
playerenchantpoints = 0
tradeItems = {}
selectedItem = nil

function init()
	enchantnpcWindow = g_ui.displayUI('enchantnpcshop')
	enchantnpcWindow:setVisible(false)

	itemsPanel = enchantnpcWindow:recursiveGetChildById('enchantitemsPanel')
	searchText = enchantnpcWindow:recursiveGetChildById('enchantsearchText')

	setupPanel = enchantnpcWindow:recursiveGetChildById('enchantsetupPanel')
	quantityScroll = setupPanel:getChildById('enchantquantityScroll')
	nameLabel = setupPanel:getChildById('enchantname')
	enchantdescLabel = setupPanel:getChildById('enchantdesc')
	priceLabel = setupPanel:getChildById('enchantprice')
	moneyLabel = setupPanel:getChildById('enchantmoney')
	weightDesc = setupPanel:getChildById('weightDesc')
	weightLabel = setupPanel:getChildById('enchantweight')
	capacityDesc = setupPanel:getChildById('enchantcapacityDesc')
	capacityLabel = setupPanel:getChildById('enchantcapacity')
	tradeButton = enchantnpcWindow:recursiveGetChildById('enchanttradeButton')

	ignoreCapacity = enchantnpcWindow:recursiveGetChildById('enchantignoreCapacity')

	if g_game.isOnline() then
		playerFreeCapacity = g_game.getLocalPlayer():getFreeCapacity()
	end

	connect(g_game, { onGameEnd = hide })

	connect(LocalPlayer, { onFreeCapacityChange = onFreeCapacityChange, onInventoryChange = onInventoryChange })

	ProtocolGame.registerOpcode(GameServerOpcodes.GameServerOpenEnchantShop, parseNpcShop)
end

function terminate()
	enchantnpcWindow:destroy()

	disconnect(g_game, {onGameEnd = hide })

	disconnect(LocalPlayer, { onFreeCapacityChange = onFreeCapacityChange, onInventoryChange = onInventoryChange })

	ProtocolGame.unregisterOpcode(GameServerOpcodes.GameServerOpenEnchantShop, parseNpcShop)
end

function show()
	if g_game.isOnline() then
		enchantnpcWindow:show()
		enchantnpcWindow:raise()
		enchantnpcWindow:focus()
	end
end

function hide()
	enchantnpcWindow:hide()
	modules.game_interface.getRootPanel():focus()
end

function onItemBoxChecked(widget)
	if widget:isChecked() then
		local item = widget.item
		selectedItem = item
		enchantrefreshItem(item)
		tradeButton:enable()
	end
end

function onQuantityValueChange(quantity)
	if selectedItem then
		weightLabel:setText(string.format('%.2f', selectedItem.weight * quantity) .. ' ' .. 'oz')
		priceLabel:setText(formatCurrency(getenchantItemPrice(selectedItem)))
	end
end

function onTradeClick()
	local protocol = g_game.getProtocolGame()
	if not protocol then
		return
	end
	
	local msg = OutputMessage.create()
	msg:addU8(ClientOpcodes.EnchantNpcShopBuy)
	msg:addU16(selectedItem.id)
	msg:addU32(selectedItem.price)
	msg:addU16(tonumber(quantityScroll:getValue()))
	protocol:send(msg)
end

function onSearchTextChange()
	enchantrefreshPlayerGoods()
end

function onIgnoreCapacityChange()
	enchantrefreshPlayerGoods()
end

function enchantclearSelectedItem()
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

function getenchantItemPrice(item, single)
	local amount = 1
	local single = single or false
	if not single then
		amount = quantityScroll:getValue()
	end
	return item.price * amount
end

function canTradeenchantItem(item)
	return (ignoreCapacity:isChecked() or (not ignoreCapacity:isChecked() and playerFreeCapacity >= item.weight)) and playerenchantpoints >= getenchantItemPrice(item, true)
end

function enchantrefreshItem(item)
	nameLabel:setText(item.name)
	weightLabel:setText(string.format('%.2f', item.weight) .. ' ' .. 'oz')
	priceLabel:setText(formatCurrency(getenchantItemPrice(item)))
    enchantdescLabel:setText(item.enchantdesc)
	local capacityMaxCount = math.floor(playerFreeCapacity / item.weight)
	if ignoreCapacity:isChecked() then
		capacityMaxCount = 65535
	end

	local priceMaxCount = math.floor(playerenchantpoints / getenchantItemPrice(item, true))
	local finalCount = math.max(0, math.min(100, math.min(priceMaxCount, capacityMaxCount)))
	quantityScroll:setMinimum(1)
	quantityScroll:setMaximum(finalCount)

	setupPanel:enable()
end

function enchantrefreshTradeItems()
	enchantclearSelectedItem()

	searchText:clearText()
	setupPanel:disable()
	itemsPanel:destroyChildren()

	if radioItems then
		radioItems:destroy()
	end
	radioItems = UIRadioGroup.create()

	for key, item in pairs(tradeItems) do
		local itemBox = g_ui.createWidget('enchantNPCItemBox', itemsPanel)
		itemBox.item = item

		local text = item.name

		text = text .. '\n' .. " Item level: " .. item.itemLevel

		local price = formatCurrency(item.price)
		text = text .. '\n' .. price
		itemBox:setText(text)

		local itemWidget = itemBox:getChildById('enchantitem')
		itemWidget:setItemId(item.clientId)
		itemWidget:setVirtual(true)
		itemWidget:setItemCount(item.amount)

		radioItems:addWidget(itemBox)
	end
end

function enchantrefreshPlayerGoods()
	moneyLabel:setText(playerenchantpoints)
	capacityLabel:setText(string.format('%.2f', playerFreeCapacity) .. ' ' .. 'oz')

	local searchFilter = searchText:getText():lower()
	local foundSelectedItem = false

	local items = itemsPanel:getChildCount()
	for i = 1, items do
		local itemWidget = itemsPanel:getChildByIndex(i)
		local item = itemWidget.item

		local canTradeenchant = canTradeenchantItem(item)
		itemWidget:setOn(canTradeenchant)
		itemWidget:setEnabled(canTradeenchant)

		local searchCondition = (searchFilter == '') or (searchFilter ~= '' and string.find(item.name:lower(), searchFilter) ~= nil)
		itemWidget:setVisible(searchCondition)

		if selectedItem == item and itemWidget:isEnabled() and itemWidget:isVisible() then
			foundSelectedItem = true
		end
	end

	if not foundSelectedItem then
		enchantclearSelectedItem()
	end

	if selectedItem then
		enchantrefreshItem(selectedItem)
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
		item.itemLevel = msg:getU32()
		item.weight = msg:getU32()
		item.name = msg:getString()
		item.enchantdesc = msg:getString()
		tradeItems[#tradeItems + 1] = item
	end

	playerenchantpoints = msg:getU32()

	enchantrefreshTradeItems()
	enchantrefreshPlayerGoods()
	addEvent(show) -- player goods has not been parsed yet
end

function onFreeCapacityChange(localPlayer, freeCapacity, oldFreeCapacity)
	playerFreeCapacity = freeCapacity

	if enchantnpcWindow:isVisible() then
		enchantrefreshPlayerGoods()
	end
end

function onInventoryChange(inventory, item, oldItem)
	if enchantnpcWindow:isVisible() then
		enchantrefreshPlayerGoods()
	end
end

function formatCurrency(amount)
	return amount .. ' ' .. "Gold"
end
