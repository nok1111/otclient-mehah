local AUCTION_OPCODE = 102

local window
local browseList
local myList
local searchEdit
local priceEdit
local countSpin
local listItemSlot
local selectedListingId = nil
local selectedMyId = nil
local listFromPos = nil

local function send(e, d)
  local protocol = g_game.getProtocolGame()
  if not protocol then return end
  protocol:sendExtendedOpcode(AUCTION_OPCODE, json.encode({ e = e, d = d }))
end

local function onExtendedOpcode(protocol, code, buffer)
  if code ~= AUCTION_OPCODE then return end
  local ok, pkt = pcall(function() return json.decode(buffer) end)
  if not ok or type(pkt) ~= 'table' then return end
  local e = pkt.e
  local d = pkt.d

  if e == 'AH_OPEN_ACK' then
    if window then
      window:show()
      window:raise()
      window:focus()
      send('AH_SEARCH', { limit = 25, offset = 0 })
      send('AH_MY', {})
    end
  elseif e == 'AH_SEARCH_DATA' then
    if not browseList then return end
    browseList:destroyChildren()
    for i = 1, #d do
      local w = g_ui.createWidget('AuctionRow', browseList)
      w:getChildById('name'):setText(d[i].name)
      w:getChildById('price'):setText(d[i].price)
      local item = w:getChildById('icon')
      item:setItemId(d[i].cid)
      w.listingId = d[i].id
      w.onClick = function()
        selectedListingId = w.listingId
      end
    end
  elseif e == 'AH_MY_DATA' then
    if not myList then return end
    myList:destroyChildren()
    for i = 1, #d do
      local w = g_ui.createWidget('AuctionRow', myList)
      w:getChildById('name'):setText(d[i].name .. ' x'..d[i].count)
      w:getChildById('price'):setText(d[i].price)
      local item = w:getChildById('icon')
      item:setItemId(d[i].cid)
      w.listingId = d[i].id
      w.onClick = function()
        selectedMyId = w.listingId
      end
    end
  elseif e == 'AH_LIST_ACK' then
    if d and d.error then
      displayInfoBox('Auction', d.error)
    else
      displayInfoBox('Auction', 'Listed: '..d.name..' x'..d.count..' for '..d.price..' gp')
      send('AH_MY', {})
      send('AH_SEARCH', { limit = 25, offset = 0 })
      if listItemSlot then listItemSlot:setItem(nil) end
      priceEdit:setText('')
      countSpin:setValue(1)
    end
  elseif e == 'AH_BUY_ACK' then
    if d and d.error then
      displayInfoBox('Auction', d.error)
    else
      displayInfoBox('Auction', 'Purchased for '..d.price..' gp')
      send('AH_MY', {})
      send('AH_SEARCH', { limit = 25, offset = 0 })
    end
  elseif e == 'AH_CANCEL_ACK' then
    if d and d.error then
      displayInfoBox('Auction', d.error)
    else
      displayInfoBox('Auction', 'Listing canceled.')
      send('AH_MY', {})
      send('AH_SEARCH', { limit = 25, offset = 0 })
    end
  end
end

local function onDropToListSlot(self, mousePos, draggedWidget)
  if not draggedWidget or not draggedWidget:isUIThing() then return false end
  if not draggedWidget.item then return false end
  listItemSlot:setItem(draggedWidget.item)
  -- capture original item position from the dragged thing (not from cloned UI item)
  local draggedItem = draggedWidget.currentDragThing
  if draggedItem and draggedItem.getPosition then
    listFromPos = draggedItem:getPosition()
  else
    listFromPos = nil
  end
  return true
end

function init()
  ProtocolGame.registerExtendedOpcode(AUCTION_OPCODE, onExtendedOpcode)
  window = g_ui.displayUI('game_auction')
  window:hide()

  browseList = window:getChildById('browseList')
  myList = window:getChildById('myList')
  searchEdit = window:getChildById('searchEdit')
  priceEdit = window:getChildById('priceEdit')
  countSpin = window:getChildById('countSpin')
  listItemSlot = window:getChildById('listItemSlot')
  listItemSlot.onDrop = onDropToListSlot
end

function terminate()
  ProtocolGame.unregisterExtendedOpcode(AUCTION_OPCODE, onExtendedOpcode)
  if window then window:destroy() window = nil end
end

function toggle()
  if not window then return end
  if window:isVisible() then window:hide() else window:show() window:raise() window:focus() end
end

function onOpen()
  send('AH_OPEN', {})
end

function onSearch()
  local name = searchEdit:getText()
  send('AH_SEARCH', { name = name, limit = 25, offset = 0 })
end

function onBuy()
  if not selectedListingId then
    displayInfoBox('Auction', 'Select a listing to buy.')
    return
  end
  send('AH_BUY', { id = selectedListingId })
end

function onCancel()
  if not selectedMyId then
    displayInfoBox('Auction', 'Select one of your listings to cancel.')
    return
  end
  send('AH_CANCEL', { id = selectedMyId })
end

function onList()
  local item = listItemSlot:getItem()
  if not item then
    displayInfoBox('Auction', 'Drag an item into the slot.')
    return
  end
  local price = tonumber(priceEdit:getText()) or 0
  local count = tonumber(countSpin:getValue()) or 1
  if price < 1 then
    displayInfoBox('Auction', 'Enter a valid price.')
    return
  end
  local pos = listFromPos or (item.getPosition and item:getPosition() or nil)
  if not pos or pos.x ~= 0xFFFF then
    displayInfoBox('Auction', 'Item must be dragged from your inventory (not the ground).')
    return
  end
  local cid = item:getId()
  send('AH_LIST', { pos = { x = pos.x, y = pos.y, z = pos.z }, cid = cid, count = count, price = price })
end
