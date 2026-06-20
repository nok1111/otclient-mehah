local iconTopMenu = nil

local inventoryShrink = false
local itemSlotsWithDuration = {}
local updateSlotsDurationEvent = nil
local DURATION_UPDATE_INTERVAL = 1000

local function getInventoryUi()
    if inventoryShrink then
        return inventoryController.ui.offPanel
    end

    return inventoryController.ui.onPanel
end

local getSlotPanelBySlot = {
    [InventorySlotHead] = function(ui) 
        local slot = ui.activePanel and ui.activePanel:getChildById('helmet') or ui.helmet
        return slot, slot and slot.helmet or nil
    end,
    [InventorySlotNeck] = function(ui) return ui.amulet, ui.amulet.amulet end,
    [InventorySlotBack] = function(ui) return ui.backpack, ui.backpack.backpack end,
    [InventorySlotBody] = function(ui) 
        local slot = ui.combatPanel and ui.combatPanel:getChildById('armor') or ui.armor
        return slot, slot and slot.armor or nil
    end,
    [InventorySlotRight] = function(ui) 
        local slot = ui.combatPanel and ui.combatPanel:getChildById('shield') or ui.shield
        return slot, slot and slot.shield or nil
    end,
    [InventorySlotLeft] = function(ui) 
        local slot = ui.combatPanel and ui.combatPanel:getChildById('sword') or ui.sword
        return slot, slot and slot.sword or nil
    end,
    [InventorySlotLeg] = function(ui) return ui.legs, ui.legs.legs end,
    [InventorySlotFeet] = function(ui) 
        local slot = ui.activePanel and ui.activePanel:getChildById('boots') or ui.boots
        return slot, slot and slot.boots or nil
    end,
    [InventorySlotFinger] = function(ui) return ui.ring, ui.ring.ring end,
    [InventorySlotAmmo] = function(ui) 
        local slot = ui.activePanel and ui.activePanel:getChildById('tools') or ui.tools
        return slot, slot and slot.tools or nil
    end,
    [InventorySlotRune1] = function(ui) 
        local slot = ui.craftingPanel and ui.craftingPanel:getChildById('rune1') or ui.rune1
        return slot, slot and slot.rune1 or nil
    end,
    [InventorySlotRune2] = function(ui) 
        local slot = ui.craftingPanel and ui.craftingPanel:getChildById('rune2') or ui.rune2
        return slot, slot and slot.rune2 or nil
    end,
    [InventorySlotRune3] = function(ui) 
        local slot = ui.craftingPanel and ui.craftingPanel:getChildById('rune3') or ui.rune3
        return slot, slot and slot.rune3 or nil
    end
}

local function formatDuration(duration)
    return string.format("%dm%02d", duration / 60, duration % 60)
end

local function stopEvent()
    if updateSlotsDurationEvent then
        removeEvent(updateSlotsDurationEvent)
        updateSlotsDurationEvent = nil
    end
end

local function updateSlotsDuration()
    -- @ prevent :
    if not g_game.isOnline() or next(itemSlotsWithDuration) == nil then
        stopEvent()
        return
    end
    -- @

    if not modules.client_options.getOption('showExpiryInInvetory') then
        stopEvent()
        local ui = getInventoryUi()
        for slot, itemDurationReg in pairs(itemSlotsWithDuration) do
            local getSlotInfo = getSlotPanelBySlot[slot]
            if getSlotInfo then
                local slotPanel = getSlotInfo(ui)
                if slotPanel and slotPanel.item then
                    slotPanel.item.duration:setText("")
                end
            end
        end
        return
    end

    local currTime = g_clock.seconds()
    local ui = getInventoryUi()
    local hasItemsWithDuration = false

    for slot, itemDurationReg in pairs(itemSlotsWithDuration) do
        local item = itemDurationReg.item
        if item and item:getDurationTime() > 0 then
            hasItemsWithDuration = true
            local durationTimeLeft = math.max(0, itemDurationReg.timeEnd - currTime)
            local getSlotInfo = getSlotPanelBySlot[slot]
            if getSlotInfo then
                local slotPanel = getSlotInfo(ui)
                if slotPanel and slotPanel.item then
                    slotPanel.item.duration:setText(formatDuration(durationTimeLeft))
                end
            end
        end
    end

    if hasItemsWithDuration then
        updateSlotsDurationEvent = scheduleEvent(updateSlotsDuration, DURATION_UPDATE_INTERVAL)
    else
        stopEvent()
    end
end

local function walkEvent()
    if modules.client_options.getOption('autoChaseOverride') then
        if g_game.isAttacking() and g_game.getChaseMode() == ChaseOpponent then
            selectPosture('stand', false)
        end
    end
end

local function combatEvent()
    if g_game.getChaseMode() == ChaseOpponent then
        selectPosture('follow', true)
    else
        selectPosture('stand', true)
    end
    
    if g_game.getFightMode() == FightOffensive then
        selectCombat('attack', true)
    elseif g_game.getFightMode() == FightDefensive then
        selectCombat('defense', true)
    end
    
    -- Update PVP toggle based on safe fight
    local pvpEnabled = not g_game.isSafeFight()
    local ui = getInventoryUi()
    if ui.pvpToggle then
        ui.pvpToggle:setChecked(pvpEnabled)
    end
end

local function inventoryEvent(player, slot, item, oldItem)
    if inventoryShrink then
        return
    end

    local ui = getInventoryUi()
    local getSlotInfo = getSlotPanelBySlot[slot]
    if not getSlotInfo then
        --print("Slot not found:", slot)
        return
    end
    --print("Slot found:", slot)

    local slotPanel, toggler = getSlotInfo(ui)

    slotPanel.item:setItem(item)
    toggler:setEnabled(not item)
    slotPanel.item:setWidth(34)
    slotPanel.item:setHeight(34)
    slotPanel.item.duration:setText("")
    slotPanel.item.charges:setText("")
    if g_game.getFeature(GameThingClock) then
        if item and item:getDurationTime() > 0 then
            if not itemSlotsWithDuration[slot] or itemSlotsWithDuration[slot].item ~= item then
                itemSlotsWithDuration[slot] = {
                    item = item,
                    timeEnd = g_clock.seconds() + item:getDurationTime()
                }
            end
            if modules.client_options.getOption('showExpiryInInvetory') then
                if not updateSlotsDurationEvent then
                    updateSlotsDuration()
                end
            end
        else
            itemSlotsWithDuration[slot] = nil
        end
    end
    
    if modules.client_options.getOption('showExpiryInInvetory') then
        ItemsDatabase.setCharges(slotPanel.item, item)
    end
    ItemsDatabase.setTier(slotPanel.item, item)
    ItemsDatabase.setProficiency(slotPanel.item, item)
end

local function onSoulChange(localPlayer, soul)
    local ui = getInventoryUi()
    if not localPlayer then
        return
    end
    if not soul then
        return
    end

    if ui.soulPanel and ui.soulPanel.soul then
        ui.soulPanel.soul:setText(soul)
    end

    if ui.soulAndCapacity and ui.soulAndCapacity.soul then
        ui.soulAndCapacity.soul:setText(soul)
    end
end

local function onFreeCapacityChange(player, freeCapacity)
    if not player then
        return
    end

    if not freeCapacity then
        return
    end
    if freeCapacity > 99999 then
        freeCapacity = math.min(9999, math.floor(freeCapacity / 1000)) .. "k"
    elseif freeCapacity > 999 then
        freeCapacity = math.floor(freeCapacity)
    elseif freeCapacity > 99 then
        freeCapacity = math.floor(freeCapacity * 10) / 10
    end
    local ui = getInventoryUi()
    if ui.capacityPanel and ui.capacityPanel.capacity then
        ui.capacityPanel.capacity:setText(freeCapacity)
    end
    if ui.soulAndCapacity and ui.soulAndCapacity.capacity then
        ui.soulAndCapacity.capacity:setText(freeCapacity)
    end
end

function getIconsPanelOn()
    return inventoryController.ui.onPanel.icons
end

function getIconsPanelOff()
    return inventoryController.ui.offPanel.icons
end

-- Re-decorate equipment slots with proficiency tier bars (called after a
-- proficiency data sync from the game_itemproficiency module).
function updateProficiencyOverlays()
    local player = g_game.getLocalPlayer()
    if not player or inventoryShrink then
        return
    end
    local ui = getInventoryUi()
    for slot = InventorySlotFirst, InventorySlotRune3 do
        local getSlotInfo = getSlotPanelBySlot[slot]
        if getSlotInfo then
            local slotPanel = getSlotInfo(ui)
            if slotPanel and slotPanel.item then
                ItemsDatabase.setProficiency(slotPanel.item, player:getInventoryItem(slot))
            end
        end
    end
end

function refreshInventory_panel()
    local player = g_game.getLocalPlayer()
    if player then
        onSoulChange(player, player:getSoul())
        onFreeCapacityChange(player, player:getFreeCapacity())
    end
    if inventoryShrink then
        return
    end

    for i = InventorySlotFirst, InventorySlotRune3 do
        if g_game.isOnline() then
            inventoryEvent(player, i, player:getInventoryItem(i))
        else
            inventoryEvent(player, i, nil)
        end
    end
end

local function refreshInventorySizes()
    if inventoryShrink then
        inventoryController.ui:setOn(false)
        inventoryController.ui.onPanel:hide()
        inventoryController.ui.offPanel:show()
    else
        inventoryController.ui:setOn(true)
        inventoryController.ui.onPanel:show()
        inventoryController.ui.offPanel:hide()
        refreshInventory_panel()
    end
    combatEvent()
    walkEvent()
    modules.game_mainpanel.reloadMainPanelSizes()
end

function onSetChaseMode(self, selectedChaseModeButton)
    if selectedChaseModeButton == nil then
        return
    end
    
    local buttonId = selectedChaseModeButton:getId()
    local chaseMode
    if buttonId == 'followPosture' then
        chaseMode = ChaseOpponent
    else
        chaseMode = DontChase
    end
    g_game.setChaseMode(chaseMode)
end

inventoryController = Controller:new()
inventoryController:setUI('inventory', modules.game_interface.getRightPanel())

function inventoryController:onInit()
    refreshInventory_panel()
    local ui = getInventoryUi()

    iconTopMenu = modules.game_mainpanel.addStoreButton('inventoryButton', tr('Inventory'), '/images/icons/bag', toggle, false, 3)

    ProtocolGame.registerExtendedOpcode(217, function(protocol, opcode, buffer)
        refreshInventory_panel()
        if modules.game_containers and modules.game_containers.refreshContainerItems then
            for _, container in pairs(g_game.getContainers()) do
                modules.game_containers.refreshContainerItems(container)
            end
        end
    end)
end

local slotTooltips = {
    helmet = 'Spell Slot (Active)',
    boots = 'Boots (Active)',
    tools = 'Tools Slot',
    sword = 'Weapon',
    shield = 'Shield / Weapon',
    armor = 'Armor',
    backpack = 'Backpack',
    ring = 'Ring',
    amulet = 'Necklace',
    rune1 = 'Crafting Rune Slot',
    rune2 = 'Crafting Rune Slot',
    rune3 = 'Crafting Rune Slot'
}

local function setupTooltips()
    -- Tooltips ahora se definen directamente en 10-items.otui
    -- Los UIWidgets de slots tienen !tooltip y se muestran solo cuando enabled: false (slot vacío)
    -- Cuando hay item equipado, el UIWidget tiene enabled: true y el tooltip del item se muestra normalmente
end

function inventoryController:onGameStart()
    local player = g_game.getLocalPlayer()
    if player then
        local char = g_game.getCharacterName()
        local lastCombatControls = g_settings.getNode('LastCombatControls')
        if not table.empty(lastCombatControls) then
            if lastCombatControls[char] then
                g_game.setFightMode(lastCombatControls[char].fightMode)
                g_game.setChaseMode(lastCombatControls[char].chaseMode)
                g_game.setSafeFight(lastCombatControls[char].safeFight)
                if lastCombatControls[char].pvpMode then
                    g_game.setPVPMode(lastCombatControls[char].pvpMode)
                end
            end
        end
    end
    inventoryController:registerEvents(LocalPlayer, {
        onInventoryChange = inventoryEvent,
        onSoulChange = onSoulChange,
        onFreeCapacityChange = onFreeCapacityChange
    }):execute()

    inventoryController:registerEvents(g_game, {
        onWalk = walkEvent,
        onAutoWalk = walkEvent,
        onFightModeChange = combatEvent,
        onChaseModeChange = combatEvent,
        onSafeFightChange = combatEvent,
        onPVPModeChange = combatEvent
    }):execute()

    inventoryShrink = g_settings.getBoolean('mainpanel_shrink_inventory')
    refreshInventorySizes()
    refreshInventory_panel()

    -- Show/hide blessings button based on client version
    local showBlessings = g_game.getClientVersion() >= 1000
    if showBlessings then
        inventoryController.ui.offPanel.blessings:show()
        inventoryController.ui.onPanel.blessings:show()
    else
        inventoryController.ui.offPanel.blessings:hide()
        inventoryController.ui.onPanel.blessings:hide()
    end
    inventoryController.ui.onPanel.purseButton:setVisible(false)
    
    -- Setup tooltips after UI is loaded with delay
    addEvent(setupTooltips, 500)

    if iconTopMenu then
        iconTopMenu:setOn(inventoryController.ui:isVisible())
    end
end

function inventoryController:onGameEnd()
    stopEvent()

    local lastCombatControls = g_settings.getNode('LastCombatControls')
    if not lastCombatControls then
        lastCombatControls = {}
    end
    local player = g_game.getLocalPlayer()
    if player then
        local char = g_game.getCharacterName()
        lastCombatControls[char] = {
            fightMode = g_game.getFightMode(),
            chaseMode = g_game.getChaseMode(),
            safeFight = g_game.isSafeFight()
        }
        if g_game.getFeature(GamePVPMode) then
            lastCombatControls[char].pvpMode = g_game.getPVPMode()
        end
        g_settings.setNode('LastCombatControls', lastCombatControls)
    end
end

function inventoryController:onTerminate()
    if iconTopMenu then
        iconTopMenu:destroy()
        iconTopMenu = nil
    end

    ProtocolGame.unregisterExtendedOpcode(217)
end

function onSetSafeFight(self, checked)
    if not checked then
        inventoryController.ui.onPanel.pvp:setChecked(false)
        inventoryController.ui.offPanel.pvp:setChecked(false)
      else
        inventoryController.ui.onPanel.pvp:setChecked(true)  
        inventoryController.ui.offPanel.pvp:setChecked(true)  
      end
    g_game.setSafeFight(not checked)
    if not checked then
        g_game.cancelAttack()
    end
end

function onSetPVPToggle(button, checked)
    -- Sync both panels
    inventoryController.ui.onPanel.pvpToggle:setChecked(checked)
    inventoryController.ui.offPanel.pvpToggle:setChecked(checked)
    
    if checked then
        -- PVP ON: can attack players
        g_game.setSafeFight(false)
        g_game.setPVPMode(PVPRedFist)
    else
        -- PVP OFF: safe mode
        g_game.setSafeFight(true)
        g_game.setPVPMode(PVPWhiteDove)
    end
end

function selectPosture(key, ignoreUpdate)
    local ui = getInventoryUi()
    if key == 'stand' then
        ui.standPosture:setEnabled(false)
        ui.followPosture:setEnabled(true)
        if not ignoreUpdate then
            g_game.setChaseMode(DontChase)
        end
    elseif key == 'follow' then
        ui.standPosture:setEnabled(true)
        ui.followPosture:setEnabled(false)
        if not ignoreUpdate then
            g_game.setChaseMode(ChaseOpponent)
        end
    end
end

function selectCombat(combat, ignoreUpdate)
    local ui = getInventoryUi()
    if combat == 'attack' then
        ui.attack:setEnabled(false)
        ui.defense:setEnabled(true)
        if not ignoreUpdate then
            g_game.setFightMode(FightOffensive)
        end
    elseif combat == 'defense' then
        ui.attack:setEnabled(true)
        ui.defense:setEnabled(false)
        if not ignoreUpdate then
            g_game.setFightMode(FightDefensive)
        end
    end
end


function changeInventorySize()
    inventoryShrink = not inventoryShrink
    g_settings.set('mainpanel_shrink_inventory', inventoryShrink)
    refreshInventorySizes()
    modules.game_mainpanel.reloadMainPanelSizes()
    local player = g_game.getLocalPlayer()
    if player and g_game.isOnline() then
        onFreeCapacityChange(player, player:getFreeCapacity())
        onSoulChange(player, player:getSoul())
    end
end

function getSlot5()
    return inventoryController.ui.onPanel.shield
end

function reloadInventory()
    if modules.client_options.getOption('showExpiryInInvetory') then
        updateSlotsDuration()
    end
    
    for slot, getSlotInfo in pairs(getSlotPanelBySlot) do
        local ui = getInventoryUi()
        local slotPanel, toggler = getSlotInfo(ui)
        if slotPanel then
            local player = g_game.getLocalPlayer()
            if player then
                inventoryEvent(player, slot, player:getInventoryItem(slot))
            end
        end
    end
end

function extendedView(extendedView)

        print("not extendedView inventory")
        --inventoryController.ui:setBorderColor('alpha')
        inventoryController.ui:setBorderWidth(0)
        local mainRightPanel = modules.game_interface.getRightPanel()
        if not mainRightPanel:hasChild(inventoryController.ui) then
            mainRightPanel:insertChild(3, inventoryController.ui)
        end
        inventoryController.ui:show()

    inventoryController.ui.moveOnlyToMain = false

end

function toggle()
    if iconTopMenu:isOn() then
        inventoryController.ui:hide()
        iconTopMenu:setOn(false)
    else
        inventoryController.ui:show()
        iconTopMenu:setOn(true)
    end
end
