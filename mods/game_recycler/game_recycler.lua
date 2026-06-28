Recycler = {}

local RECYCLER_OPCODE = 90

local recyclerWindow = nil
local recyclerSlots = {}
local slotData = {}

function Recycler.init()
  print("[Recycler][Client] init() called")
  connect(g_game, { onGameEnd = Recycler.hide })
  
  print("[Recycler][Client] Registering opcode " .. RECYCLER_OPCODE)
  ProtocolGame.registerExtendedOpcode(RECYCLER_OPCODE, Recycler.onExtendedOpcode)
  
  print("[Recycler][Client] Module initialized successfully")
end

function Recycler.terminate()
  disconnect(g_game, { onGameEnd = Recycler.hide })
  
  ProtocolGame.unregisterExtendedOpcode(RECYCLER_OPCODE)
  
  Recycler.hide()
end

function Recycler.show()
  if not recyclerWindow then
    print("[Recycler][Client] Creating window UI...")
    
    -- Load UI from file like game_bossbar does
    recyclerWindow = g_ui.loadUI('game_recycler', modules.game_interface.getRootPanel())
    
    if not recyclerWindow then
      print("[Recycler][Client] ERROR: Failed to load game_recycler UI")
      return
    end
    
    print("[Recycler][Client] Window created successfully")
    
    -- Setup slots using recursiveGetChildById like game_auction
    for i = 1, 9 do
      local slot = recyclerWindow:recursiveGetChildById('slot' .. i)
      if slot then
        recyclerSlots[i] = slot
        slotData[i] = { itemId = 0, count = 0, value = 0 }
        print("[Recycler][Client] Slot " .. i .. " found and configured")
      else
        print("[Recycler][Client] WARNING: Slot " .. i .. " not found in UI")
      end
    end
    
    -- Assign onDrop handlers AFTER all slots are found
    for i = 1, 9 do
      local slot = recyclerSlots[i]
      if slot then
        local slotIndex = i
        
        slot.onDrop = function(self, draggedWidget, mousePos)
          print("[Recycler][Client] onDrop triggered for slot " .. slotIndex)
          
          local srcItem = draggedWidget and draggedWidget.currentDragThing or nil
          if not srcItem then
            print("[Recycler][Client] No currentDragThing")
            return false
          end
          
          local it = nil
          if draggedWidget.getItem then
            it = draggedWidget:getItem()
          end
          
          if it then
            print(string.format("[Recycler][Client] Item found: id=%d", it:getId()))
            
            -- DO NOT show item visually yet - wait for server validation
            -- self:setItem(it)  -- Removed - server will send RECYCLER_UPDATE if valid
            
            if srcItem.getPosition then
              local pos = srcItem:getPosition()
              print(string.format("[Recycler][Client] Position: %d,%d,%d", pos.x, pos.y, pos.z))
              Recycler.send('RECYCLER_PLACE', {
                slot = slotIndex,
                pos = { x = pos.x, y = pos.y, z = pos.z }
              })
            end
          else
            print("[Recycler][Client] No item found in draggedWidget")
          end
          
          return true
        end
        
        slot.onMouseRelease = function(self, mousePosition, mouseButton)
          if mouseButton == MouseLeftButton then
            local item = self:getItem()
            if item then
              Recycler.removeItem(slotIndex)
              return true
            end
          end
          return false
        end
      end
    end
    
    -- Bind button handlers like game_auction
    local scrapButton = recyclerWindow:recursiveGetChildById('scrapButton')
    local closeButton = recyclerWindow:recursiveGetChildById('closeButton')
    if scrapButton then 
      scrapButton.onClick = Recycler.onScrapAll
      print("[Recycler][Client] Scrap button bound")
    end
    if closeButton then 
      closeButton.onClick = Recycler.hide
      print("[Recycler][Client] Close button bound")
    end
    
    recyclerWindow:hide()
  end
  
  if not recyclerWindow then
    print("[Recycler][Client] ERROR: Window is still nil, cannot show")
    return
  end
  
  recyclerWindow:show()
  recyclerWindow:raise()
  recyclerWindow:focus()
  
  -- Request to open recycler
  Recycler.send('RECYCLER_OPEN', {})
end

function Recycler.hide()
  if recyclerWindow then
    Recycler.send('RECYCLER_CLOSE', {})
    recyclerWindow:hide()
  end
end

function Recycler.send(event, data)
  print(string.format("[Recycler][Client] Sending event: %s", tostring(event)))
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    local payload = json.encode({ e = event, d = data })
    print("[Recycler][Client] Payload: " .. tostring(payload))
    protocolGame:sendExtendedOpcode(RECYCLER_OPCODE, payload)
  else
    print("[Recycler][Client] ERROR: No protocol game available")
  end
end

function Recycler.onSlotDrop(slotIndex, draggedWidget)
  if not draggedWidget then 
    print("[Recycler][Client] onSlotDrop: no draggedWidget")
    return false 
  end
  
  local item = draggedWidget.currentDragThing or (draggedWidget.getItem and draggedWidget:getItem())
  if not item then 
    print("[Recycler][Client] onSlotDrop: no item")
    return false 
  end
  
  local pos = item:getPosition()
  if not pos then 
    print("[Recycler][Client] onSlotDrop: no position")
    return false 
  end
  
  print(string.format("[Recycler][Client] Dropped item in slot %d, itemId: %d, pos: %d,%d,%d", slotIndex, item:getId(), pos.x, pos.y, pos.z))
  
  -- Show item visually in the slot immediately
  local slot = recyclerSlots[slotIndex]
  if slot then
    slot:setItem(item)
    print("[Recycler][Client] Item set visually in slot " .. slotIndex)
  end
  
  -- Send to server
  Recycler.send('RECYCLER_PLACE', {
    slot = slotIndex,
    pos = { x = pos.x, y = pos.y, z = pos.z }
  })
  
  return true
end

function Recycler.removeItem(slotIndex)
  print(string.format("[Recycler][Client] Removing item from slot %d", slotIndex))
  
  -- Clear slot visually
  if recyclerSlots[slotIndex] then
    recyclerSlots[slotIndex]:setItem(nil)
  end
  
  slotData[slotIndex] = { itemId = 0, count = 0, value = 0 }
  
  -- Send to server
  Recycler.send('RECYCLER_REMOVE', {
    slot = slotIndex
  })
end

function Recycler.onScrapAll()
  print("[Recycler][Client] Scrap All clicked")
  Recycler.send('RECYCLER_SCRAP', {})
end

function Recycler.updateDisplay(data)
  if not recyclerWindow or not data then return end
  
  local slots = data.slots or {}
  local totalValue = data.totalValue or 0
  
  print(string.format("[Recycler][Client] updateDisplay: totalValue=%d", totalValue))
  
  -- Update slots
  for i = 1, 9 do
    local slotInfo = slots[i]
    if slotInfo and recyclerSlots[i] then
      if slotInfo.clientId and slotInfo.clientId > 0 then
        -- Use clientId for correct sprite display
        recyclerSlots[i]:setItemId(slotInfo.clientId)
        if slotInfo.count and slotInfo.count > 1 then
          recyclerSlots[i]:setItemCount(slotInfo.count)
        end
        slotData[i] = slotInfo
        print(string.format("[Recycler][Client] Slot %d updated: clientId=%d, serverId=%d", i, slotInfo.clientId, slotInfo.serverId or 0))
      else
        recyclerSlots[i]:setItem(nil)
        slotData[i] = { serverId = 0, clientId = 0, count = 0, value = 0 }
      end
    end
  end
  
  -- Update total value and bonuses using recursiveGetChildById
  local totalValueLabel = recyclerWindow:recursiveGetChildById('totalValue')
  if totalValueLabel then
    totalValueLabel:setText(tr('%d gold', totalValue))
    print("[Recycler][Client] Total value label updated: " .. totalValue)
  else
    print("[Recycler][Client] ERROR: totalValue label not found")
  end
  
  local rarityBonusLabel = recyclerWindow:recursiveGetChildById('rarityBonusValue')
  if rarityBonusLabel then
    local rarityBonus = data.rarityBonus or 0
    rarityBonusLabel:setText(tr('+ %d gold', rarityBonus))
    print("[Recycler][Client] Rarity bonus label updated: " .. rarityBonus)
  else
    print("[Recycler][Client] ERROR: rarityBonusValue label not found")
  end
  
  local enchantBonusLabel = recyclerWindow:recursiveGetChildById('enchantBonusValue')
  if enchantBonusLabel then
    local enchantBonus = data.enchantBonus or 0
    enchantBonusLabel:setText(tr('+ %d gold', enchantBonus))
    print("[Recycler][Client] Enchant bonus label updated: " .. enchantBonus)
  else
    print("[Recycler][Client] ERROR: enchantBonusValue label not found")
  end
  
  print(string.format("[Recycler][Client] Updated - Total: %d gold, Rarity bonus: %d, Enchant bonus: %d", 
    totalValue, data.rarityBonus or 0, data.enchantBonus or 0))
end

function Recycler.onExtendedOpcode(protocol, opcode, buffer)
  if opcode ~= RECYCLER_OPCODE then return end
  
  print("[Recycler][Client] onExtendedOpcode received, buffer: " .. tostring(buffer))
  
  local ok, packet = pcall(function() return json.decode(buffer) end)
  if not ok or type(packet) ~= 'table' then
    print("[Recycler][Client] Failed to decode packet: " .. tostring(ok))
    return
  end
  
  local event = packet.e
  local data = packet.d
  
  print(string.format("[Recycler][Client] Received event: %s", tostring(event)))
  
  if event == "RECYCLER_OPEN_WINDOW" then
    print("[Recycler][Client] Opening window from server signal")
    Recycler.show()
  elseif event == "RECYCLER_CLOSE_WINDOW" then
    print("[Recycler][Client] Closing window from server signal")
    Recycler.hide()
  elseif event == "RECYCLER_UPDATE" then
    Recycler.updateDisplay(data)
  elseif event == "RECYCLER_REJECTED" then
    -- Server rejected the item - clear the slot visually
    local slotIndex = data and data.slot
    if slotIndex and recyclerSlots[slotIndex] then
      print(string.format("[Recycler][Client] Item rejected for slot %d: %s", slotIndex, data.reason or "unknown"))
      recyclerSlots[slotIndex]:setItem(nil)
    end
  end
end

print("[Recycler][Client] Module script loaded")
