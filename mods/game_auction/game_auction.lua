Auction = Auction or {}
Auction.opCode = Auction.opCode or 102

-- helper: apply shader to icon based on item name
local function applyIconShader(icon, name)
  if not icon or not name then return end
  local lname = name:lower()
  local shaderName
  if lname:find('orbital', 1, true) then
    shaderName = 'Orbital'
  elseif lname:find('forged', 1, true) then
    shaderName = 'Forged'
  elseif lname:find('[corrupted]', 1, true) then
    shaderName = 'Corrupted'
  end
  if icon.setShader and shaderName then
    pcall(function() icon:setShader(shaderName) end)
  end
end

-- Tab switching API
function Auction.setTab(tab)
  if tab ~= 'auction' and tab ~= 'my' then return end
  Auction.activeTab = tab
  -- toggle UI
  local showCreate = (tab == 'my')
  if Auction.createLabel and Auction.createLabel.setVisible then Auction.createLabel:setVisible(showCreate) end
  if Auction.createRowPanel and Auction.createRowPanel.setVisible then Auction.createRowPanel:setVisible(showCreate) end
  if Auction.buyButton and Auction.buyButton.setVisible then Auction.buyButton:setVisible(tab == 'auction') end
  if Auction.cancelButton and Auction.cancelButton.setVisible then Auction.cancelButton:setVisible(tab == 'my') end
  -- clear current list
  if Auction.browseList then Auction.browseList:destroyChildren() end
  -- request data
  if tab == 'auction' then
    Auction.send('AH_SEARCH', { limit = 25, offset = 0 })
  else
    Auction.send('AH_MY', {})
  end
end

-- helper: show count overlay on the icon (e.g., x37)
local function applyIconCount(icon, count)
  if not icon then return end
  local lbl = icon:recursiveGetChildById('countLabel')
  if not lbl then
    lbl = g_ui.createWidget('UILabel', icon)
    lbl:setId('countLabel')
    lbl:setPhantom(true)
    lbl:setTextAlign(AlignRight)
    lbl:addAnchor(AnchorBottom, '100%')
    lbl:addAnchor(AnchorRight, '100%')
    lbl:setMarginRight(2)
    lbl:setMarginBottom(1)
    lbl:setColor('#ffffff')
    if lbl.setOutlineColor then lbl:setOutlineColor('#000000') end
    if lbl.setOutlineWidth then lbl:setOutlineWidth(1) end
    pcall(function() if lbl.setFont then lbl:setFont('verdana-11px-rounded') end end)
    if lbl.applyStyle then pcall(function() lbl:applyStyle('auctionCountBadge') end) end
  end
  if tonumber(count) and count > 1 then
    lbl:setText('x'..tostring(count))
    lbl:setVisible(true)
  else
    lbl:setVisible(false)
  end
end

-- helper: price formatting with thousands separators
local function formatPrice(n)
  if type(n) ~= 'number' then return tostring(n) end
  local s = tostring(math.floor(n))
  local k
  while true do
    s, k = s:gsub('^(%-?%d+)(%d%d%d)', '%1,%2')
    if k == 0 then break end
  end
  return s
end

-- helper: build price text, include unit price when count>1
local function buildPriceText(total, count)
  if tonumber(count) and count > 1 then
    local per = math.floor(total / count)
    return string.format('%s (%s ea)', formatPrice(total), formatPrice(per))
  end
  return formatPrice(total)
end
Auction = Auction or {}
Auction.opCode = 102

-- state
Auction.window = nil
Auction.browseList = nil
Auction.searchEdit = nil
Auction.priceEdit = nil
Auction.countSpin = nil
Auction.listItemSlot = nil
Auction.selectedId = nil
Auction.listFromPos = nil
Auction.pendingOpen = false
Auction.activeTab = 'auction' -- 'auction' or 'my'
Auction.buyButton = nil
Auction.cancelButton = nil
Auction.tabAuction = nil
Auction.tabMy = nil
Auction.createLabel = nil
Auction.createRowPanel = nil
Auction.countValue = nil
Auction.searchDebounceEvent = nil

-- Lazy UI creator to avoid crashing during login if OTUI has issues
function Auction.ensureWindow()
  if Auction.window and not Auction.window:isDestroyed() then return true end
  local okImport, importErr = pcall(function() g_ui.importStyle('game_auction.otui') end)
  if not okImport then
    print('[Auction][Client][Error] Failed to import style game_auction.otui: '..tostring(importErr))
    return false
  end
  local okCreate, winOrErr = pcall(function() return g_ui.createWidget('AuctionWindow', rootWidget) end)
  if not okCreate or not winOrErr then
    print('[Auction][Client][Error] Failed to create AuctionWindow: '..tostring(winOrErr))
    return false
  end
  Auction.window = winOrErr
  Auction.window:hide()

  -- Recursively resolve children since they are nested
  Auction.browseList   = Auction.window:recursiveGetChildById('browseList')
  Auction.searchEdit   = Auction.window:recursiveGetChildById('searchEdit')
  Auction.priceEdit    = Auction.window:recursiveGetChildById('priceEdit')
  Auction.countSpin    = Auction.window:recursiveGetChildById('countSpin')
  Auction.listItemSlot = Auction.window:recursiveGetChildById('listItemSlot')
  Auction.createLabel  = Auction.window:recursiveGetChildById('createLabel')
  Auction.createRowPanel = Auction.window:recursiveGetChildById('createRow')
  Auction.tabAuction   = Auction.window:recursiveGetChildById('tabAuction')
  Auction.tabMy        = Auction.window:recursiveGetChildById('tabMy')
  Auction.countValue   = Auction.window:recursiveGetChildById('countValue')

  local function updateCountValue()
    if Auction.countValue and Auction.countSpin and Auction.countSpin.getValue then
      local v = tonumber(Auction.countSpin:getValue()) or 1
      Auction.countValue:setText(tostring(v))
    end
  end

  if Auction.listItemSlot then
    Auction.listItemSlot.onItemChange = function(widget)
      local item = widget:getItem()
      print(string.format('[Auction][Client] listItemSlot.onItemChange item=%s', tostring(item and item:getId() or nil)))
      if item and Auction.countSpin and Auction.countSpin.setValue then
        local cnt = (item.getCount and item:getCount()) or 1
        if Auction.countSpin.setMaximum then Auction.countSpin:setMaximum(math.max(1, cnt)) end
        local cur = tonumber(Auction.countSpin:getValue()) or 1
        Auction.countSpin:setValue(math.min(math.max(1, cur), math.max(1, cnt)))
      end
      updateCountValue()
    end
    Auction.listItemSlot.onDrop = function(self, draggedWidget, mousePos)
      local srcItem = draggedWidget and draggedWidget.currentDragThing or nil
      if srcItem and srcItem.getPosition then
        Auction.listFromPos = srcItem:getPosition()
        print(string.format('[Auction][Client] onDrop inventory pos captured x=%s y=%s z=%s', tostring(Auction.listFromPos.x), tostring(Auction.listFromPos.y), tostring(Auction.listFromPos.z)))
      else
        Auction.listFromPos = nil
      end
      if draggedWidget and draggedWidget.getItem then
        local it = draggedWidget:getItem()
        if it then
          self:setItem(it)
          if Auction.countSpin and Auction.countSpin.setValue then
            local cnt = (it.getCount and it:getCount()) or 1
            if Auction.countSpin.setMaximum then Auction.countSpin:setMaximum(math.max(1, cnt)) end
            local cur = tonumber(Auction.countSpin:getValue()) or 1
            Auction.countSpin:setValue(math.min(math.max(1, cur), math.max(1, cnt)))
          end
          updateCountValue()
        end
      end
      return true
    end
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
          if Auction.countSpin and Auction.countSpin.setValue then
            local cnt = (item.getCount and item:getCount()) or 1
            if Auction.countSpin.setMaximum then Auction.countSpin:setMaximum(math.max(1, cnt)) end
            local cur = tonumber(Auction.countSpin:getValue()) or 1
            Auction.countSpin:setValue(math.min(math.max(1, cur), math.max(1, cnt)))
          end
          updateCountValue()
          return true
        end
      end
      return false
    end
  else
    print('[Auction][Client][Warn] listItemSlot not found in UI (list drag disabled)')
  end

  -- Bind button handlers
  local openButton   = Auction.window:recursiveGetChildById('openButton')
  local searchButton = Auction.window:recursiveGetChildById('searchButton')
  local listButton   = Auction.window:recursiveGetChildById('listButton')
  local buyButton    = Auction.window:recursiveGetChildById('buyButton')
  local cancelButton = Auction.window:recursiveGetChildById('cancelButton')
  if openButton   then openButton.onClick   = Auction.onOpen   end
  if searchButton then searchButton.onClick = Auction.onSearch end
  if Auction.searchEdit then
    Auction.searchEdit.onTextChange = function(widget, text)
      local term = text or (widget and widget.getText and widget:getText()) or ''
      Auction.onSearchChange(term)
    end
  end
  if listButton   then listButton.onClick   = Auction.onList   end
  if buyButton    then buyButton.onClick    = Auction.onBuy    end
  if cancelButton then cancelButton.onClick = Auction.onCancel end
  if Auction.tabAuction then Auction.tabAuction.onClick = function() Auction.setTab('auction') end end
  if Auction.tabMy then Auction.tabMy.onClick = function() Auction.setTab('my') end end
  Auction.buyButton = buyButton
  Auction.cancelButton = cancelButton
  if Auction.buyButton and Auction.buyButton.setEnabled then Auction.buyButton:setEnabled(false) end
  if Auction.cancelButton and Auction.cancelButton.setEnabled then Auction.cancelButton:setEnabled(false) end

  if Auction.countSpin then
    Auction.countSpin.onValueChange = function(self, value)
      updateCountValue()
    end
    updateCountValue()
  end

  -- initialize tab visuals (default auction)
  Auction.setTab('auction')
  return true
end

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
    if not Auction.window then
      -- Try to lazily create the UI now
      if not Auction.ensureWindow() then
        -- If creation fails (e.g. OTUI parse), defer until later
        Auction.pendingOpen = true
        return
      end
    end
    local okShow, showErr = pcall(function()
      print('[Auction][Client] showing window (deferred)...')
      scheduleEvent(function()
        if not Auction.window or Auction.window:isDestroyed() then return end
        Auction.window:show(); Auction.window:raise(); Auction.window:focus()
      end, 10)
    end)
    if not okShow then
      print('[Auction][Client][Error] Failed to show auction window: '..tostring(showErr))
      return
    end
    local okReq1, reqErr1 = pcall(function() Auction.send('AH_SEARCH', { limit = 25, offset = 0 }) end)
    if not okReq1 then print('[Auction][Client][Warn] Failed to request AH_SEARCH: '..tostring(reqErr1)) end
    local okReq2, reqErr2 = pcall(function() Auction.send('AH_MY', {}) end)
    if not okReq2 then print('[Auction][Client][Warn] Failed to request AH_MY: '..tostring(reqErr2)) end
  elseif e == 'AH_SEARCH_DATA' then
    print(string.format('[Auction][Client] AH_SEARCH_DATA count=%d', type(d)=='table' and #d or -1))
    if not Auction.browseList or Auction.activeTab ~= 'auction' then return end
    -- reset selection and disable buy until user selects again
    if Auction.selectedBrowseRow then
      pcall(function() local o = Auction.selectedBrowseRow:getChildById('sel'); if o then o:setVisible(false) end end)
    end
    Auction.selectedId = nil
    Auction.selectedBrowseRow = nil
    if Auction.buyButton and Auction.buyButton.setEnabled then Auction.buyButton:setEnabled(false) end
    Auction.browseList:destroyChildren()
    if #d == 0 then
      local empty = g_ui.createWidget('UILabel', Auction.browseList)
      empty:setText('No results.')
      empty:setPhantom(true)
      empty:setColor('#bbbbbb')
      empty:setMarginTop(8)
      empty:setMarginLeft(8)
    end
    for i = 1, #d do
      local w = g_ui.createWidget('AuctionRow', Auction.browseList)
      w:getChildById('name'):setText(d[i].name)
      w:getChildById('price'):setText(buildPriceText(tonumber(d[i].price) or 0, tonumber(d[i].count) or 1))
      local item = w:getChildById('icon')
      print(string.format('[Auction][Client] SEARCH row i=%d id=%s name=%s price=%s cid=%s count=%s', i, tostring(d[i].id), tostring(d[i].name), tostring(d[i].price), tostring(d[i].cid), tostring(d[i].count)))
      item:setItemId(d[i].cid)
      applyIconShader(item, d[i].name)
      applyIconCount(item, d[i].count)
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
      w:setFocusable(true)
      local function selectBrowse()
        if Auction.selectedBrowseRow and Auction.selectedBrowseRow ~= w then
          pcall(function() local o = Auction.selectedBrowseRow:getChildById('sel'); if o then o:setVisible(false) end end)
        end
        local overlay = w:getChildById('sel'); if overlay then overlay:setVisible(true) end
        Auction.selectedBrowseRow = w
        Auction.selectedId = w.listingId
        if Auction.buyButton and Auction.buyButton.setEnabled then Auction.buyButton:setEnabled(true) end
        print(string.format('[Auction][Client] Selected listing id=%s', tostring(w.listingId)))
      end
      w.onClick = function()
        selectBrowse()
      end
      w.onMousePress = function(self, mousePos, mouseButton)
        selectBrowse()
        return true
      end
    end
  elseif e == 'AH_MY_DATA' then
    print(string.format('[Auction][Client] AH_MY_DATA count=%d', type(d)=='table' and #d or -1))
    if not Auction.browseList or Auction.activeTab ~= 'my' then return end
    if Auction.selectedMyRow then
      pcall(function() local o = Auction.selectedMyRow:getChildById('sel'); if o then o:setVisible(false) end end)
    end
    Auction.selectedId = nil
    Auction.selectedMyRow = nil
    if Auction.cancelButton and Auction.cancelButton.setEnabled then Auction.cancelButton:setEnabled(false) end
    Auction.browseList:destroyChildren()
    if #d == 0 then
      local empty = g_ui.createWidget('UILabel', Auction.browseList)
      empty:setText('You have no active listings.')
      empty:setPhantom(true)
      empty:setColor('#bbbbbb')
      empty:setMarginTop(8)
      empty:setMarginLeft(8)
    end
    for i = 1, #d do
      local w = g_ui.createWidget('AuctionRow', Auction.browseList)
      -- Show count only on the icon overlay, not in the name label
      w:getChildById('name'):setText(d[i].name)
      w:getChildById('price'):setText(buildPriceText(tonumber(d[i].price) or 0, tonumber(d[i].count) or 1))
      local item = w:getChildById('icon')
      print(string.format('[Auction][Client] MY row i=%d id=%s name=%s price=%s cid=%s count=%s', i, tostring(d[i].id), tostring(d[i].name), tostring(d[i].price), tostring(d[i].cid), tostring(d[i].count)))
      item:setItemId(d[i].cid)
      applyIconShader(item, d[i].name)
      applyIconCount(item, d[i].count)
      w.listingId = d[i].id
      print(string.format('[Auction][Client] added my row id=%s name=%s', tostring(d[i].id), tostring(d[i].name)))
      print('[Auction][Client] list child count:', Auction.browseList:getChildCount())
      if w.getWidth and w.getHeight then
        print(string.format('[Auction][Client] my row size w=%d h=%d', w:getWidth(), w:getHeight()))
      end
      -- single scroll used
      w:setFocusable(true)
      local function selectMy()
        if Auction.selectedMyRow and Auction.selectedMyRow ~= w then
          pcall(function() local o = Auction.selectedMyRow:getChildById('sel'); if o then o:setVisible(false) end end)
        end
        local overlay = w:getChildById('sel'); if overlay then overlay:setVisible(true) end
        Auction.selectedMyRow = w
        Auction.selectedId = w.listingId
        if Auction.cancelButton and Auction.cancelButton.setEnabled then Auction.cancelButton:setEnabled(true) end
        print(string.format('[Auction][Client] Selected my listing id=%s', tostring(w.listingId)))
      end
      w.onClick = function()
        selectMy()
      end
      w.onMousePress = function(self, mousePos, mouseButton)
        selectMy()
        return true
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

function Auction.onDropToListSlot(self, draggedWidget, mousePos)
  print('[Auction][Client] onDropToListSlot triggered (OTUI)')
  if not draggedWidget then return false end
  -- prefer direct item; fallback to currentDragThing
  local itemWidgetItem = draggedWidget.getItem and draggedWidget:getItem() or draggedWidget.item
  local dragThing = draggedWidget.currentDragThing
  if not itemWidgetItem and not dragThing then return false end
  if itemWidgetItem and Auction.listItemSlot and Auction.listItemSlot.setItem then
    Auction.listItemSlot:setItem(itemWidgetItem)
  end
  local draggedItem = dragThing
  if draggedItem and draggedItem.getPosition then
    Auction.listFromPos = draggedItem:getPosition()
    print(string.format('[Auction][Client] Captured pos x=%s y=%s z=%s', tostring(Auction.listFromPos.x), tostring(Auction.listFromPos.y), tostring(Auction.listFromPos.z)))
  else
    Auction.listFromPos = nil
  end
  return true
end

function Auction.onGameStart()
  print('[Auction][Client] onGameStart called')
  -- Defer UI creation until first open; do not import OTUI here to avoid startup issues
  if Auction.pendingOpen and not Auction.window then
    if Auction.ensureWindow() then
      Auction.pendingOpen = false
      Auction.window:show(); Auction.window:raise(); Auction.window:focus()
      Auction.send('AH_SEARCH', { limit = 25, offset = 0 })
      Auction.send('AH_MY', {})
    end
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

function Auction.onRefresh()
  print('[Auction][Client] onRefresh: reloading lists')
  if Auction.activeTab == 'auction' then
    Auction.send('AH_SEARCH', { limit = 25, offset = 0 })
  else
    Auction.send('AH_MY', {})
  end
end

function Auction.onSearch()
  print(string.format('[Auction][Client] onSearch: name=%s', tostring(Auction.searchEdit:getText())))
  local name = Auction.searchEdit:getText()
  Auction.send('AH_SEARCH', { name = name, limit = 25, offset = 0 })
end

-- Debounced live search from TextEdit.onTextChange
function Auction.onSearchChange(text)
  -- Only search on Auction tab
  if Auction.activeTab ~= 'auction' then return end
  if Auction.searchDebounceEvent and removeEvent then
    pcall(function() removeEvent(Auction.searchDebounceEvent) end)
    Auction.searchDebounceEvent = nil
  end
  Auction.searchDebounceEvent = scheduleEvent(function()
    Auction.searchDebounceEvent = nil
    local term = text
    -- double-check current text
    if Auction.searchEdit and Auction.searchEdit.getText then term = Auction.searchEdit:getText() end
    print(string.format('[Auction][Client] onSearchChange debounced term=%s', tostring(term)))
    Auction.send('AH_SEARCH', { name = term, limit = 25, offset = 0 })
  end, 200)
end

function Auction.onClearSearch()
  if not Auction.searchEdit then return end
  Auction.searchEdit:setText('')
  Auction.onSearch()
end

function Auction.onBuy()
  print(string.format('[Auction][Client] onBuy: selectedId=%s', tostring(Auction.selectedId)))
  if not Auction.selectedId then
    displayInfoBox('Auction', 'Select a listing to buy.')
    return
  end
  Auction.send('AH_BUY', { id = Auction.selectedId })
end

function Auction.onCancel()
  print(string.format('[Auction][Client] onCancel: selectedId=%s', tostring(Auction.selectedId)))
  if not Auction.selectedId then
    displayInfoBox('Auction', 'Select one of your listings to cancel.')
    return
  end
  Auction.send('AH_CANCEL', { id = Auction.selectedId })
end

function Auction.onList()
  print('[Auction][Client] onList called')
  local item = Auction.listItemSlot:getItem()
  if not item then
    displayInfoBox('Auction', 'Drag an item into the slot.')
    return
  end
  local unitPrice = tonumber(Auction.priceEdit:getText()) or 0
  local count = tonumber(Auction.countSpin:getValue()) or 1
  if count < 1 then count = 1 end
  -- total price is per-unit * count
  local totalPrice = math.floor((unitPrice or 0) * count)
  print(string.format('[Auction][Client] onList unitPrice=%s count=%s totalPrice=%s', tostring(unitPrice), tostring(count), tostring(totalPrice)))
  if unitPrice < 1 then
    displayInfoBox('Auction', 'Enter a valid price.')
    return
  end
  local pos = Auction.listFromPos or (item.getPosition and item:getPosition() or nil)
  if not pos or pos.x ~= 0xFFFF then
    displayInfoBox('Auction', 'Item must be dragged from your inventory (not the ground).')
    return
  end
  local cid = item:getId()
  if item.getClientId then cid = item:getClientId() end
  print(string.format('[Auction][Client] Sending AH_LIST pos=(%s,%s,%s) clientCid=%s count=%s totalPrice=%s', tostring(pos.x), tostring(pos.y), tostring(pos.z), tostring(cid), tostring(count), tostring(totalPrice)))
  Auction.send('AH_LIST', { pos = { x = pos.x, y = pos.y, z = pos.z }, cid = cid, count = count, price = totalPrice })
end
