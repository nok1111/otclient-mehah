Auction = Auction or {}
Auction.opCode = 102

-- state
Auction.window = nil
Auction.browseList = nil
Auction.myList = nil
Auction.searchEdit = nil
Auction.priceEdit = nil
Auction.countSpin = nil
Auction.listItemSlot = nil
Auction.selectedListingId = nil
Auction.selectedMyId = nil
Auction.listFromPos = nil
Auction.pendingOpen = false

function Auction.send(e, d)
  local protocol = g_game.getProtocolGame()
  if not protocol then return end
  protocol:sendExtendedOpcode(Auction.opCode, json.encode({ e = e, d = d }))
end

function Auction.onExtendedOpcode(protocol, code, buffer)
  print('[Auction][Client] onExtendedOpcode called')
  if code ~= Auction.opCode then return end
  print(string.format('[Auction][Client] onExtendedOpcode code=%d buffer=%s', code, tostring(buffer)))
  local ok, pkt = pcall(function() return json.decode(buffer) end)
  if not ok or type(pkt) ~= 'table' then return end
  local e = pkt.e
  local d = pkt.d

  if e == 'AH_OPEN_ACK' then
    print('[Auction][Client] AH_OPEN_ACK received, showing window and requesting data')
    if Auction.window then
      Auction.window:show()
      Auction.window:raise()
      Auction.window:focus()
      Auction.send('AH_SEARCH', { limit = 25, offset = 0 })
      Auction.send('AH_MY', {})
    else
      -- UI not ready yet (race right after login); open once created
      Auction.pendingOpen = true
    end
  elseif e == 'AH_SEARCH_DATA' then
    print(string.format('[Auction][Client] AH_SEARCH_DATA count=%d', type(d)=='table' and #d or -1))
    if not Auction.browseList then return end
    Auction.browseList:destroyChildren()
    for i = 1, #d do
      local w = g_ui.createWidget('AuctionRow', Auction.browseList)
      w:getChildById('name'):setText(d[i].name)
      w:getChildById('price'):setText(d[i].price)
      local item = w:getChildById('icon')
      item:setItemId(d[i].cid)
      w.listingId = d[i].id
      print(string.format('[Auction][Client] added search row id=%s name=%s', tostring(d[i].id), tostring(d[i].name)))
      print('[Auction][Client] browseList child count:', Auction.browseList:getChildCount())
      if w.getWidth and w.getHeight then
        print(string.format('[Auction][Client] search row size w=%d h=%d', w:getWidth(), w:getHeight()))
      end
      if Auction.browseList.getWidth and Auction.browseList.getHeight then
        print(string.format('[Auction][Client] browseList size w=%d h=%d', Auction.browseList:getWidth(), Auction.browseList:getHeight()))
      end
      local browseScroll = Auction.window and Auction.window:recursiveGetChildById('browseScroll') or nil
      if browseScroll and browseScroll.getWidth then
        print(string.format('[Auction][Client] browseScroll size w=%d h=%d', browseScroll:getWidth(), browseScroll:getHeight()))
      end
      w.onClick = function()
        print(string.format('[Auction][Client] Selected listing id=%s', tostring(w.listingId)))
        Auction.selectedListingId = w.listingId
      end
    end
  elseif e == 'AH_MY_DATA' then
    print(string.format('[Auction][Client] AH_MY_DATA count=%d', type(d)=='table' and #d or -1))
    if not Auction.myList then return end
    Auction.myList:destroyChildren()
    -- Insert a visible test label to ensure the container paints
    local test = g_ui.createWidget('Label', Auction.myList)
    test:setText('TEST ROW')
    test:setColor('white')
    if test.setTextAutoResize then test:setTextAutoResize(true) end
    print('[Auction][Client] inserted TEST label; myList child count:', Auction.myList:getChildCount())
    for i = 1, #d do
      local w = g_ui.createWidget('AuctionRow', Auction.myList)
      w:getChildById('name'):setText(d[i].name .. ' x'..d[i].count)
      w:getChildById('price'):setText(d[i].price)
      local item = w:getChildById('icon')
      item:setItemId(d[i].cid)
      w.listingId = d[i].id
      print(string.format('[Auction][Client] added my row id=%s name=%s', tostring(d[i].id), tostring(d[i].name)))
      print('[Auction][Client] myList child count:', Auction.myList:getChildCount())
      if w.getWidth and w.getHeight then
        print(string.format('[Auction][Client] my row size w=%d h=%d', w:getWidth(), w:getHeight()))
      end
      if Auction.myList.getWidth and Auction.myList.getHeight then
        print(string.format('[Auction][Client] myList size w=%d h=%d', Auction.myList:getWidth(), Auction.myList:getHeight()))
      end
      local myScroll = Auction.window and Auction.window:recursiveGetChildById('myScroll') or nil
      if myScroll and myScroll.getWidth then
        print(string.format('[Auction][Client] myScroll size w=%d h=%d', myScroll:getWidth(), myScroll:getHeight()))
      end
      w.onClick = function()
        print(string.format('[Auction][Client] Selected my listing id=%s', tostring(w.listingId)))
        Auction.selectedMyId = w.listingId
      end
    end
  elseif e == 'AH_LIST_ACK' then
    print('[Auction][Client] AH_LIST_ACK received')
    if d and d.error then
      displayInfoBox('Auction', d.error)
    else
      displayInfoBox('Auction', 'Listed: '..d.name..' x'..d.count..' for '..d.price..' gp')
      Auction.send('AH_MY', {})
      Auction.send('AH_SEARCH', { limit = 25, offset = 0 })
      if Auction.listItemSlot then Auction.listItemSlot:setItem(nil) end
      Auction.priceEdit:setText('')
      Auction.countSpin:setValue(1)
    end
  elseif e == 'AH_BUY_ACK' then
    print('[Auction][Client] AH_BUY_ACK received')
    if d and d.error then
      displayInfoBox('Auction', d.error)
    else
      displayInfoBox('Auction', 'Purchased for '..d.price..' gp')
      Auction.send('AH_MY', {})
      Auction.send('AH_SEARCH', { limit = 25, offset = 0 })
    end
  elseif e == 'AH_CANCEL_ACK' then
    print('[Auction][Client] AH_CANCEL_ACK received')
    if d and d.error then
      displayInfoBox('Auction', d.error)
    else
      displayInfoBox('Auction', 'Listing canceled.')
      Auction.send('AH_MY', {})
      Auction.send('AH_SEARCH', { limit = 25, offset = 0 })
    end
  end
end

function Auction.onDropToListSlot(self, mousePos, draggedWidget)
  print('[Auction][Client] onDropToListSlot triggered')
  if not draggedWidget then return false end
  -- prefer direct item; fallback to currentDragThing
  local itemWidgetItem = draggedWidget.item
  local dragThing = draggedWidget.currentDragThing
  if not itemWidgetItem and not dragThing then return false end
  if itemWidgetItem then
    Auction.listItemSlot:setItem(itemWidgetItem)
  end
  local draggedItem = draggedWidget.currentDragThing
  if draggedItem and draggedItem.getPosition then
    Auction.listFromPos = draggedItem:getPosition()
    print(string.format('[Auction][Client] Captured pos x=%s y=%s z=%s', tostring(Auction.listFromPos.x), tostring(Auction.listFromPos.y), tostring(Auction.listFromPos.z)))
  else
    Auction.listFromPos = nil
  end
  return true
end

function Auction.onGameStart()
  -- optional per-session setup
  print('[Auction][Client] onGameStart called')
  -- Import style and create the window only after entering the game
  g_ui.importStyle('game_auction.otui')
  Auction.window = g_ui.createWidget('AuctionWindow', rootWidget)
  if not Auction.window then
    print('[Auction][Client][Error] Failed to create AuctionWindow widget on game start')
    return
  end
  Auction.window:hide()

  -- Recursively resolve children since they are nested
  Auction.browseList   = Auction.window:recursiveGetChildById('browseList')
  Auction.myList       = Auction.window:recursiveGetChildById('myList')
  Auction.searchEdit   = Auction.window:recursiveGetChildById('searchEdit')
  Auction.priceEdit    = Auction.window:recursiveGetChildById('priceEdit')
  Auction.countSpin    = Auction.window:recursiveGetChildById('countSpin')
  Auction.listItemSlot = Auction.window:recursiveGetChildById('listItemSlot')
  if not Auction.listItemSlot then
    print('[Auction][Client][Warn] listItemSlot not found in UI (list drag disabled)')
  else
    -- Allow drops and react to them like bot slots
    -- Use onItemChange which is triggered by OTClient when an Item widget accepts a drop
    Auction.listItemSlot.onItemChange = function(widget)
      local item = widget:getItem()
      print(string.format('[Auction][Client] listItemSlot.onItemChange item=%s', tostring(item and item:getId() or nil)))
      -- Visual is already handled by the Item widget
    end
    -- Capture precise inventory position when dropping (preferred path)
    Auction.listItemSlot.onDrop = function(self, draggedWidget, mousePos)
      local srcItem = draggedWidget and draggedWidget.currentDragThing or nil
      if srcItem and srcItem.getPosition then
        Auction.listFromPos = srcItem:getPosition()  -- contains x=65535 and proper y/z
        print(string.format('[Auction][Client] onDrop inventory pos captured x=%s y=%s z=%s', tostring(Auction.listFromPos.x), tostring(Auction.listFromPos.y), tostring(Auction.listFromPos.z)))
      else
        Auction.listFromPos = nil
      end
      -- also set the visual if needed
      if draggedWidget and draggedWidget.getItem then
        local it = draggedWidget:getItem()
        if it then self:setItem(it) end
      end
      return true
    end
    -- Fallback: when mouse is released over the slot, pick the UIItem under cursor (like actionbar)
    Auction.listItemSlot.onMouseRelease = function(self, mousePosition, mouseButton)
      local root = modules.game_interface.getRootPanel()
      if not root then return false end
      local clickedWidget = root:recursiveGetChildByPos(mousePosition, false)
      if not clickedWidget then return false end
      if clickedWidget.getClassName and clickedWidget:getClassName() == 'UIItem' and not clickedWidget:isVirtual() then
        local item = clickedWidget:getItem()
        if item and item:getPosition().x == 65535 then
          self:setItem(item)
          Auction.listFromPos = item:getPosition()
          print(string.format('[Auction][Client] onMouseRelease picked inventory item id=%s', tostring(item:getId())))
          return true
        end
      end
      return false
    end
  end

  -- Bind button handlers
  local openButton   = Auction.window:recursiveGetChildById('openButton')
  local searchButton = Auction.window:recursiveGetChildById('searchButton')
  local listButton   = Auction.window:recursiveGetChildById('listButton')
  local buyButton    = Auction.window:recursiveGetChildById('buyButton')
  local cancelButton = Auction.window:recursiveGetChildById('cancelButton')
  if openButton   then openButton.onClick   = Auction.onOpen   end
  if searchButton then searchButton.onClick = Auction.onSearch end
  if listButton   then listButton.onClick   = Auction.onList   end
  if buyButton    then buyButton.onClick    = Auction.onBuy    end
  if cancelButton then cancelButton.onClick = Auction.onCancel end

  -- If server already told us to open before UI existed, open now
  if Auction.pendingOpen then
    Auction.pendingOpen = false
    Auction.window:show()
    Auction.window:raise()
    Auction.window:focus()
    Auction.send('AH_SEARCH', { limit = 25, offset = 0 })
    Auction.send('AH_MY', {})
  end
end

function Auction.onGameEnd()
  print('[Auction][Client] onGameEnd called')
  -- Destroy UI when leaving the game
  if Auction.window then Auction.window:destroy() Auction.window = nil end
  Auction.browseList = nil
  Auction.myList = nil
  Auction.searchEdit = nil
  Auction.priceEdit = nil
  Auction.countSpin = nil
  Auction.listItemSlot = nil
  Auction.selectedListingId = nil
  Auction.selectedMyId = nil
  Auction.listFromPos = nil
end

function Auction.init()
  print('[Auction][Client] init: registering opcode')
  connect(
    g_game,
    {
      onGameStart = Auction.onGameStart,
      onGameEnd = Auction.onGameEnd
    }
  )
  ProtocolGame.registerExtendedOpcode(Auction.opCode, Auction.onExtendedOpcode)
  if g_game.isOnline() then
    Auction.onGameStart()
  end
end

function Auction.terminate()
  print('[Auction][Client] terminate: unregistering opcode and destroying UI')
  disconnect(
    g_game,
    {
      onGameStart = Auction.onGameStart,
      onGameEnd = Auction.onGameEnd
    }
  )
  ProtocolGame.unregisterExtendedOpcode(Auction.opCode, Auction.onExtendedOpcode)
  -- If client terminates while in-game, ensure cleanup
  g_keyboard.unbindKeyDown('Ctrl+A')
  if Auction.window then Auction.window:destroy() Auction.window = nil end
end

-- No manual toggle; window opens only via opcode

function Auction.onOpen()
  print('[Auction][Client] onOpen: sending AH_OPEN')
  Auction.send('AH_OPEN', {})
end

function Auction.onSearch()
  print(string.format('[Auction][Client] onSearch: name=%s', tostring(Auction.searchEdit:getText())))
  local name = Auction.searchEdit:getText()
  Auction.send('AH_SEARCH', { name = name, limit = 25, offset = 0 })
end

function Auction.onBuy()
  print(string.format('[Auction][Client] onBuy: selectedListingId=%s', tostring(Auction.selectedListingId)))
  if not Auction.selectedListingId then
    displayInfoBox('Auction', 'Select a listing to buy.')
    return
  end
  Auction.send('AH_BUY', { id = Auction.selectedListingId })
end

function Auction.onCancel()
  print(string.format('[Auction][Client] onCancel: selectedMyId=%s', tostring(Auction.selectedMyId)))
  if not Auction.selectedMyId then
    displayInfoBox('Auction', 'Select one of your listings to cancel.')
    return
  end
  Auction.send('AH_CANCEL', { id = Auction.selectedMyId })
end

function Auction.onList()
  print('[Auction][Client] onList called')
  local item = Auction.listItemSlot:getItem()
  if not item then
    displayInfoBox('Auction', 'Drag an item into the slot.')
    return
  end
  local price = tonumber(Auction.priceEdit:getText()) or 0
  local count = tonumber(Auction.countSpin:getValue()) or 1
  print(string.format('[Auction][Client] onList price=%s count=%s', tostring(price), tostring(count)))
  if price < 1 then
    displayInfoBox('Auction', 'Enter a valid price.')
    return
  end
  local pos = Auction.listFromPos or (item.getPosition and item:getPosition() or nil)
  if not pos or pos.x ~= 0xFFFF then
    displayInfoBox('Auction', 'Item must be dragged from your inventory (not the ground).')
    return
  end
  local cid = item:getId()
  print(string.format('[Auction][Client] Sending AH_LIST pos=(%s,%s,%s) cid=%s count=%s', tostring(pos.x), tostring(pos.y), tostring(pos.z), tostring(cid), tostring(count)))
  Auction.send('AH_LIST', { pos = { x = pos.x, y = pos.y, z = pos.z }, cid = cid, count = count, price = price })
end
