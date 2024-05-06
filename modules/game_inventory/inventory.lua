InventorySlotStyles = {
  [InventorySlotHead] = "HeadSlot",
  [InventorySlotNeck] = "NeckSlot",
  [InventorySlotBack] = "BackSlot",
  [InventorySlotBody] = "BodySlot",
  [InventorySlotRight] = "RightSlot",
  [InventorySlotLeft] = "LeftSlot",
  [InventorySlotLeg] = "LegSlot",
  [InventorySlotFeet] = "FeetSlot",
  [InventorySlotFinger] = "FingerSlot",
  [InventorySlotAmmo] = "AmmoSlot"
}


InventoryExtraInfo = {
    [1] = "PhysicalInfo",
    [2] = "EnergyInfo",
    [3] = "NatureInfo",
    [4] = "FireInfo",
    [5] = "FrostInfo",
    [6] = "DeathInfo",
    [7] = "ElementalReductionInfo",
    [8] = "PhysicalReductionInfo",
    [9] = "ArmorInfo"
}

inventoryWindow = nil
inventoryPanel = nil
inventoryButton = nil
purseButton = nil
extraInfo = nil

local defaultHeight = 240
local extraInfoVisible = false

function init()
  connect(LocalPlayer, {
    onInventoryChange = onInventoryChange,
    --onBlessingsChange = onBlessingsChange
  })
 connect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

  ProtocolGame.registerExtendedOpcode(ExtendedIds.PlayerExtraInfo, onExtendedPlayerInfo)

  g_keyboard.bindKeyDown('Ctrl+I', toggle)

  inventoryButton = modules.client_topmenu.addRightGameToggleButton('inventoryButton', tr('Inventory') .. ' (Ctrl+I)', '/images/topbuttons/inventory', toggle)
  inventoryButton:setOn(true)

  inventoryWindow = g_ui.loadUI('inventory')
  inventoryWindow:disableResize()
  inventoryPanel = inventoryWindow:getChildById('contentsPanel')
  extraInfo = inventoryWindow:getChildById('extraInfo')

  purseButton = inventoryPanel:getChildById('purseButton')
  local function purseFunction()
    local purse = g_game.getLocalPlayer():getInventoryItem(InventorySlotPurse)
    if purse then
      g_game.use(purse)
    end
  end
  --purseButton.onClick = purseFunction

  refresh()
  inventoryWindow:setup()
  if g_game.isOnline() then
        inventoryWindow:setupOnStart()
    end
end

function terminate()
  disconnect(LocalPlayer, {
    onInventoryChange = onInventoryChange,
    --onBlessingsChange = onBlessingsChange
  })
   disconnect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

  ProtocolGame.unregisterExtendedOpcode(ExtendedIds.PlayerExtraInfo)
  g_keyboard.unbindKeyDown('Ctrl+I')

  inventoryWindow:destroy()
  inventoryButton:destroy()
  
	inventoryWindow = nil
    inventoryPanel = nil
    inventoryButton = nil
    purseButton = nil
end

function toggleAdventurerStyle(hasBlessing)
  for slot = InventorySlotFirst, InventorySlotLast do
    local itemWidget = inventoryPanel:getChildById('slot' .. slot)
    if itemWidget then
      itemWidget:setOn(hasBlessing)
    end
  end
end

function online()
    inventoryWindow:setupOnStart() -- load character window configuration
    refresh()
end

function offline()
    inventoryWindow:setParent(nil, true)
end

function refresh()
  local player = g_game.getLocalPlayer()
  for i = InventorySlotFirst, InventorySlotPurse do
    if g_game.isOnline() then
      onInventoryChange(player, i, player:getInventoryItem(i))
    else
      onInventoryChange(player, i, nil)
    end
    toggleAdventurerStyle(player and Bit.hasBit(player:getBlessings(), Blessings.Adventurer) or false)
  end

  --purseButton:setVisible(g_game.getFeature(GamePurseSlot))
end

function toggle()
  if inventoryButton:isOn() then
    inventoryWindow:close()
    inventoryButton:setOn(false)
  else
    inventoryWindow:open()
    inventoryButton:setOn(true)
  end
end

function onMiniWindowClose()
  inventoryButton:setOn(false)
end

-- hooked events
function onInventoryChange(player, slot, item, oldItem)
  if slot > InventorySlotPurse then return end

  if slot == InventorySlotPurse then
    if g_game.getFeature(GamePurseSlot) then
      --purseButton:setEnabled(item and true or false)
    end
    return
  end

  local itemWidget = inventoryPanel:getChildById('slot' .. slot)
  if item then
    itemWidget:setStyle('InventoryItem')
    itemWidget:setItem(item)
    -- added
    local thisItem = item
    local newColour = getItemRarityColor(thisItem)
    if newColour == "none" then
        itemWidget:setBorderWidth(0)    
    else
        itemWidget:setBorderWidth(1)    
        itemWidget:setBorderColor(newColour) -- added
    end
    local rarity = item:getItemRarity()
    print(item:getName().."|rarity:"..tostring(rarity))
    local tierImgPath = "/images/ui/slots/item"
    if rarity == 0 then
        tierImgPath = "/images/ui/item"
    elseif rarity == 1 then
        tierImgPath = tierImgPath .. "Common"
    elseif rarity == 2 then
        tierImgPath = tierImgPath .. "Rare"
    elseif rarity == 3 then
        tierImgPath = tierImgPath .. "Epic"
    elseif rarity == 4 then
        tierImgPath = tierImgPath .. "Legendary"
    else
        tierImgPath = "/images/ui/item"
    end
    print("tierImgPath:"..tostring(tierImgPath))
    itemWidget:setImageSource(tierImgPath)
    -- added
  else
    itemWidget:setImageSource("/images/ui/item") --may cause
    itemWidget:setStyle(InventorySlotStyles[slot])
    itemWidget:setItem(nil)

  end
  sendGetInventoryStatistics()
end

function onExtendedPlayerInfo(protocol, opcode, buffer)
    local info = buffer:split('|')
    for i = 1, #InventoryExtraInfo do
        local infoWidget = extraInfo:getChildById(InventoryExtraInfo[i])
        if infoWidget then
            local text = info[i]:split(":")
            infoWidget:getChildById('textLabel'):setText(text[1] .. ":")
            if i >= #InventoryExtraInfo - 2 then
                infoWidget:getChildById('valueLabel'):setText(text[2])
            else
                infoWidget:getChildById('valueLabel'):setText(text[2] .. "%")
            end
            if tonumber(text[2]) > 0 then
                infoWidget:getChildById('valueLabel'):setColor("#00ff00")
            else
                infoWidget:getChildById('valueLabel'):setColor("#4a4a4a")
            end
        end
    end
end

function sendGetInventoryStatistics()
    local protocol = g_game.getProtocolGame()
    if protocol then
        protocol:sendExtendedOpcode(ClientOpcodes.ClientGetInventoryAbilities, "")
    end
end

function expandInfo(button)
    if extraInfoVisible then
        inventoryWindow:setHeight(defaultHeight)
        extraInfoVisible = false
        extraInfo:setVisible(false)
    else
        local height = defaultHeight + 125
        inventoryWindow:setHeight(height)
        extraInfoVisible = true
        extraInfo:setVisible(true)
        sendGetInventoryStatistics()
    end

end

--[[function onBlessingsChange(player, blessings, oldBlessings)
  local hasAdventurerBlessing = Bit.hasBit(blessings, Blessings.Adventurer)
  if hasAdventurerBlessing ~= Bit.hasBit(oldBlessings, Blessings.Adventurer) then
    toggleAdventurerStyle(hasAdventurerBlessing)
  end
end]]