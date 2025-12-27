stashWindow = nil
itemsPanel = nil
radioItemSet = nil
stashSelectAmount = nil
searchEdit = nil
stashItems = {}

-- Opcode for stash system
local STASH_OPCODE = 200
local STASH_ACTION = {
    OPEN = 1,
    ADD_ITEM = 2,
    WITHDRAW_ITEM = 3,
    UPDATE = 4,
    CLOSE = 5
}

function resetSelectAmount()
    if stashSelectAmount then
        stashSelectAmount:destroy()
        stashSelectAmount = nil
    end
end

function resetItems()
    if itemsPanel then
        itemsPanel:destroyChildren()
    end
    if radioItemSet then
        radioItemSet:destroy()
        radioItemSet = nil
    end
end

function prepareWithdraw(itemId, itemAmount)
    resetSelectAmount()

    stashSelectAmount = g_ui.createWidget('StashSelectAmount', rootWidget)
    stashSelectAmount:lock()

    local itembox = stashSelectAmount:getChildById('item')
    itembox:setItemId(itemId)
    itembox:setItemCount(itemAmount)

    local scrollbar = stashSelectAmount:getChildById('countScrollBar')
    scrollbar:setMaximum(itemAmount)
    scrollbar:setMinimum(1)
    scrollbar:setValue(itemAmount)
    scrollbar.onValueChange = function(self, value)
        itembox:setItemCount(value)
    end

    g_keyboard.bindKeyPress('Up', function()
        scrollbar:setValue(scrollbar:getValue() + 10)
    end, stashSelectAmount)
    g_keyboard.bindKeyPress('Down', function()
        scrollbar:setValue(scrollbar:getValue() - 10)
    end, stashSelectAmount)
    g_keyboard.bindKeyPress('Right', function()
        scrollbar:onIncrement()
    end, stashSelectAmount)
    g_keyboard.bindKeyPress('Left', function()
        scrollbar:onDecrement()
    end, stashSelectAmount)
    g_keyboard.bindKeyPress('PageUp', function()
        scrollbar:setValue(scrollbar:getMaximum())
    end, stashSelectAmount)
    g_keyboard.bindKeyPress('PageDown', function()
        scrollbar:setValue(scrollbar:getMinimum())
    end, stashSelectAmount)

    local okButton = stashSelectAmount:getChildById('buttonOk')
    local withdrawFunc = function()
        -- Send withdraw request to server via extended opcode
        local data = {
            action = STASH_ACTION.WITHDRAW_ITEM,
            itemId = itemId,
            count = itembox:getItemCount()
        }
        local proto = g_game.getProtocolGame()
        if proto then
            proto:sendExtendedOpcode(STASH_OPCODE, json.encode(data))
        end
        stashSelectAmount:unlock()
        resetSelectAmount()
    end
    local cancelButton = stashSelectAmount:getChildById('buttonCancel')
    local cancelFunc = function()
        stashSelectAmount:unlock()
        resetSelectAmount()
    end

    stashSelectAmount.onEnter = withdrawFunc
    stashSelectAmount.onEscape = cancelFunc

    okButton.onClick = withdrawFunc
    cancelButton.onClick = cancelFunc
end

function renderItems()
    if not g_game.isOnline() then
        return
    end
    resetItems()
    radioItemSet = UIRadioGroup.create()
    local searchFilter = searchEdit:getText():lower()
    for itemId, amount in pairs(stashItems) do
        local thingType = g_things.getThingType(itemId, 0)
        if thingType then
            local itemName = thingType:getName()
            if not itemName or itemName == "" or itemName:lower():find(searchFilter, 1, true) then
                local item = Item.create(itemId)
                item:setCount(amount)
                local itemBox = g_ui.createWidget('StashItemBox', itemsPanel)
                itemBox:getChildById('item'):setItem(item)
                radioItemSet:addWidget(itemBox)
                if itemName and itemName ~= "" then
                    itemBox:setTooltip(itemName)
                else
                    itemBox:setTooltip("Loading...")
                end
                g_mouse.bindPress(itemBox, function()
                    prepareWithdraw(itemId, amount)
                end, MouseLeftButton)
            end
        end
    end
    if stashWindow:isHidden() then
        stashWindow:show()
        stashWindow:lock()
    end
end

function onSupplyStashEnter(payload)
    stashItems = {}
    for i = 1, #payload do
        local itemId = payload[i][1]
        local amount = payload[i][2]
        stashItems[itemId] = amount
    end
    renderItems()
end

function onSupplyStashClose()
    stashItems = {}
    resetItems()
    resetSelectAmount()
    if searchEdit then
        searchEdit:setText('')
    end
    if not stashWindow:isHidden() then
        stashWindow:hide()
        stashWindow:unlock()
        modules.game_interface.getRootPanel():focus()
    end
end

function onExtendedOpcode(protocol, opcode, buffer)
    if opcode ~= STASH_OPCODE then
        return
    end
    
    local status, data = pcall(function() return json.decode(buffer) end)
    if not status or not data then
        return
    end
    
    if data.action == STASH_ACTION.OPEN then
        -- Server wants to open stash window
        if stashWindow and stashWindow:isHidden() then
            stashWindow:show()
            stashWindow:lock()
        end
    elseif data.action == STASH_ACTION.UPDATE then
        -- Server sends stash items to update display
        stashItems = {}
        if data.items then
            for _, itemData in ipairs(data.items) do
                local itemId = tonumber(itemData.itemId)
                local count = tonumber(itemData.count)
                if itemId and count then
                    stashItems[itemId] = count
                end
            end
        end
        renderItems()
    elseif data.action == STASH_ACTION.CLOSE then
        -- Server wants to close stash window
        onSupplyStashClose()
    end
end

function init()
    g_ui.importStyle('game_stash')
    connect(g_game, {
        onSupplyStashEnter = onSupplyStashEnter,
        onGameEnd = onSupplyStashClose,
    })
    
    -- Register extended opcode for stash system
    ProtocolGame.registerExtendedOpcode(STASH_OPCODE, onExtendedOpcode)
    
    stashWindow = g_ui.createWidget('StashWindow', rootWidget)
    stashWindow:hide()
    itemsPanel = stashWindow:recursiveGetChildById('itemsPanel')
    searchEdit = stashWindow:recursiveGetChildById('searchEdit')
end

function terminate()
    disconnect(g_game, {
        onSupplyStashEnter = onSupplyStashEnter,
        onGameEnd = onSupplyStashClose,
    })
    
    -- Unregister extended opcode
    ProtocolGame.unregisterExtendedOpcode(STASH_OPCODE, onExtendedOpcode)
    
    onSupplyStashClose()
    stashWindow:destroy()
end
