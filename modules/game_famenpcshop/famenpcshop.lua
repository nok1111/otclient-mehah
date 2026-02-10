-- UI Components
local window
local famePointsLabel
local fameLevelLabel
local goldLabel
local tokenLabel
local searchInput
local tabsPanel
local itemsGrid
local detailsPanel
local radioCards

-- Cosmetic preview widgets
local cosmeticPreview
local cosmeticCreature
local cosmeticFloor
local FLOOR_TILES = 3

-- Data
local playerFamePoints = 0
local playerFameLevel = 0
local playerParagonLevel = 0
local currentShopId = 1
local allItems = {}
local selectedItem = nil
local currentCategory = 'all'
local pendingReselect = nil

-- Category display metadata (add new types here as needed)
local CATEGORY_META = {
  item    = {name = 'Boosts',   icon = '/images/icons/flash'},
  mount   = {name = 'Mounts',   icon = '/images/icons/horse'},
  outfit  = {name = 'Outfits',  icon = '/images/icons/tshirt'},
  pet     = {name = 'Pets',     icon = '/images/icons/pets'},
  wings   = {name = 'Wings',    icon = '/images/icons/wings'},
  effect  = {name = 'Effects',  icon = '/images/icons/effect'},
}
local activeCategories = {}

function init()
  window = g_ui.displayUI('famenpcshop')
  window:setVisible(false)
  
  -- Get UI components
  famePointsLabel = window:recursiveGetChildById('famePointsLabel')
  fameLevelLabel = window:recursiveGetChildById('fameLevelLabel')
  goldLabel = window:recursiveGetChildById('goldLabel')
  tokenLabel = window:recursiveGetChildById('tokenLabel')
  searchInput = window:recursiveGetChildById('searchInput')
  tabsPanel = window:recursiveGetChildById('tabsPanel')
  itemsGrid = window:recursiveGetChildById('itemsGrid')
  detailsPanel = window:recursiveGetChildById('detailsPanel')
  
  -- Cosmetic preview widgets
  cosmeticPreview = detailsPanel:recursiveGetChildById('cosmeticPreview')
  cosmeticCreature = detailsPanel:recursiveGetChildById('cosmeticCreature')
  cosmeticFloor = detailsPanel:recursiveGetChildById('cosmeticFloor')
  

  -- Setup cosmetic creature preview
  cosmeticCreature:setCreatureSize(200)
  cosmeticCreature:setCenter(true)
  
  -- Initialize radio group for item cards
  radioCards = UIRadioGroup.create()
  
  connect(g_game, {onGameEnd = hide})
  ProtocolGame.registerOpcode(GameServerOpcodes.GameServerOpenFameShop, parseNpcShop)
end

function terminate()
  if radioCards then
    radioCards:destroy()
  end
  
  window:destroy()
  disconnect(g_game, {onGameEnd = hide})
  ProtocolGame.unregisterOpcode(GameServerOpcodes.GameServerOpenFameShop, parseNpcShop)
end

function show()
  if g_game.isOnline() then
    window:show()
    window:raise()
    window:focus()
  end
end

function hide()
  window:hide()
  clearSelection()
end

function createTabs()
  tabsPanel:destroyChildren()

  -- Always add "All" tab first
  local allTab = g_ui.createWidget('FameCategoryTab', tabsPanel)
  local allIcon = allTab:getChildById('iconWidget')
  allIcon:setImageSource('/images/icons/star')
  local allLabel = allTab:getChildById('tabLabel')
  allLabel:setText('All')
  allTab.categoryId = 'all'
  allTab.onClick = function() selectCategory('all') end

  -- Add tabs only for categories present in this shop
  for _, catId in ipairs(activeCategories) do
    local meta = CATEGORY_META[catId] or {name = catId, icon = '/images/icons/star'}
    local tab = g_ui.createWidget('FameCategoryTab', tabsPanel)
    local iconWidget = tab:getChildById('iconWidget')
    iconWidget:setImageSource(meta.icon)
    local tabLabel = tab:getChildById('tabLabel')
    tabLabel:setText(meta.name)
    tab.categoryId = catId
    tab.onClick = function() selectCategory(catId) end
  end

  selectCategory('all')
end

function selectCategory(categoryId)
  currentCategory = categoryId
  
  -- Update tab visual states
  for _, tab in ipairs(tabsPanel:getChildren()) do
    if tab.categoryId == categoryId then
      tab:setOn(true)
    else
      tab:setOn(false)
    end
  end
  
  refreshItems()
end

function onItemCardSelected(widget)
  if widget:isChecked() then
    selectedItem = widget.itemData
    showItemDetails(selectedItem)
  end
end

function onQuantityChange(quantity)
  if selectedItem then
    updateDetailsPrice()
  end
end

function onBuyClick()
  if not selectedItem then return end
  
  local protocol = g_game.getProtocolGame()
  if not protocol then return end
  
  local quantityScroll = detailsPanel:getChildById('quantityScroll')
  local quantity = quantityScroll:getValue()
  
  local msg = OutputMessage.create()
  msg:addU8(ClientOpcodes.ClientFameShopBuy)
  msg:addString(selectedItem.type)
  msg:addU16(selectedItem.id)
  msg:addU32(0) -- legacy price field (unused)
  msg:addU16(quantity)
  protocol:send(msg)
  
  -- Show purchase success effect
  showPurchaseSuccess()
end

function showPurchaseSuccess()
  local buyButton = detailsPanel:recursiveGetChildById('buyButton')
  local checkIcon = detailsPanel:recursiveGetChildById('purchaseCheckIcon')
  
  if not buyButton or not checkIcon then return end
  
  -- Flash verde en el botón
  buyButton:setColor('#00ff00')
  scheduleEvent(function()
    buyButton:setColor('#ffffff')
  end, 600)
  
  -- Mostrar icono check con fadeIn
  checkIcon:setVisible(true)
  checkIcon:setOpacity(0)
  g_effects.fadeIn(checkIcon, 300)
  
  -- Ocultar con fadeOut
  scheduleEvent(function()
    g_effects.fadeOut(checkIcon, 400)
    scheduleEvent(function()
      checkIcon:setVisible(false)
    end, 400)
  end, 1200)
end

function reopenShop()
  -- Save selected item ID to re-select after refresh
  local selectedItemId = nil
  if selectedItem then
    selectedItemId = selectedItem.id
  end
  
  -- Store for use after parseNpcShop
  pendingReselect = selectedItemId
  
  -- Request shop data again from server to update owned status
  local protocol = g_game.getProtocolGame()
  if protocol then
    local msg = OutputMessage.create()
    msg:addU8(ClientOpcodes.ClientFameShopOpen)
    protocol:send(msg)
  end
end

function reselectItem(itemId)
  -- Find and select the card with matching item ID
  if not itemsGrid or not radioCards then return end
  
  for _, card in ipairs(itemsGrid:getChildren()) do
    if card.itemData and card.itemData.id == itemId then
      radioCards:selectWidget(card)
      return
    end
  end
end

function onSearchTextChange()
  refreshItems()
end

function clearSelection()
  if radioCards then
    radioCards:selectWidget(nil)
  end
  selectedItem = nil
  detailsPanel:setVisible(false)
end

function canPurchaseItem(item)
  if not item then return false end
  if playerFameLevel < item.fameLevel then return false end
  if (item.paragonLevel or 0) > 0 and playerParagonLevel < item.paragonLevel then return false end
  
  -- Check if player can afford fame currency (only currency we can validate client-side)
  if item.currencies and #item.currencies > 0 then
    for _, currency in ipairs(item.currencies) do
      if currency.type == 'fame' then
        if playerFamePoints < currency.amount then return false end
      end
      -- gold, token, and item currencies will be validated server-side
    end
  end
  
  return true
end


function showItemDetails(item)
  detailsPanel:setVisible(true)
  
  local nameLabel = detailsPanel:getChildById('detailNameLabel')
  local priceLabel = detailsPanel:getChildById('detailPriceLabel')
  local levelLabel = detailsPanel:getChildById('detailLevelLabel')
  local typeLabel = detailsPanel:getChildById('detailTypeLabel')
  local descLabel = detailsPanel:getChildById('detailDescLabel')
  local quantityScroll = detailsPanel:getChildById('quantityScroll')
  local buyButton = detailsPanel:getChildById('buyButton')
  local itemWidget = detailsPanel:getChildById('detailItemWidget')
  local creatureWidget = detailsPanel:getChildById('detailCreatureWidget')
  local ownedIcon = detailsPanel:recursiveGetChildById('detailOwnedIcon')
  
  nameLabel:setText(item.name)
  
  -- Display currencies in details
  if item.currencies and #item.currencies > 0 then
    local priceText = 'Price: '
    for i, currency in ipairs(item.currencies) do
      if i > 1 then priceText = priceText .. ' + ' end
      priceText = priceText .. currency.amount .. ' '
      if currency.type == 'fame' then
        priceText = priceText .. 'Fame'
      elseif currency.type == 'gold' then
        priceText = priceText .. 'Gold'
      elseif currency.type == 'token' then
        priceText = priceText .. 'Tokens'
      elseif currency.type == 'item' then
        priceText = priceText .. 'Items'
      end
    end
    priceLabel:setText(priceText)
  end
  
  local reqText = 'Fame Level Required: ' .. item.fameLevel
  if (item.paragonLevel or 0) > 0 then
    reqText = reqText .. '  |  Paragon Level: ' .. item.paragonLevel
  end
  levelLabel:setText(reqText)
  descLabel:setText(item.famedesc or '')
  
  -- Type label
  local typeText = ''
  if item.type == 'mount' or item.type == 'outfit' or item.type == 'pet' then
    typeText = 'Cosmetic / Account-wide'
  elseif item.type == 'wings' then
    typeText = 'Wings / Account-wide'
  elseif item.type == 'effect' then
    typeText = 'Effect / Account-wide'
  elseif item.type == 'item' then
    typeText = 'Consumable'
  end
  typeLabel:setText(typeText)
  
  -- Check if owned and show overlay icon
  local isOwned = item.owned or false
  ownedIcon:setVisible(isOwned)
  
  -- Cosmetic shop [2]: use game_outfit-style floor preview
  if currentShopId == 2 then
    -- Hide normal preview widgets
    itemWidget:setVisible(false)
    creatureWidget:setVisible(false)
    cosmeticPreview:setVisible(true)
    
    -- Clear previous effects from cosmetic creature
    local creature = cosmeticCreature:getCreature()
    if creature then
      creature:clearAttachedEffects()
    end
    
    -- Set player outfit on cosmetic creature
    local localPlayer = g_game.getLocalPlayer()
    if localPlayer then
      cosmeticCreature:setOutfit(localPlayer:getOutfit())
    else
      cosmeticCreature:setOutfit({type = 128})
    end
    
    -- Attach the selected effect/wing using game_outfit pattern
    if item.type == 'wings' or item.type == 'effect' then
      local effectObj = g_attachedEffects.getById(item.id)
      if effectObj then
        cosmeticCreature:getCreature():attachEffect(effectObj:clone())
      end
    elseif item.type == 'mount' then
      local outfit = cosmeticCreature:getCreature():getOutfit()
      outfit.mount = item.clientId
      cosmeticCreature:setOutfit(outfit)
    elseif item.type == 'outfit' then
      cosmeticCreature:setOutfit({type = item.clientId, addons = 3})
    end
  else
    -- Normal shop: hide cosmetic preview, show normal widgets
    cosmeticPreview:setVisible(false)
    
    -- Clear previous attached effects from the detail creature
    local detailCreature = creatureWidget:getCreature()
    if detailCreature then
      detailCreature:clearAttachedEffects()
    end
    creatureWidget:setImageSource('')

    -- Show creature or item
    if item.type == 'item' then
      itemWidget:setVisible(true)
      creatureWidget:setVisible(false)
      itemWidget:setItemId(item.clientId)
      itemWidget:setVirtual(true)
    elseif item.type == 'wings' or item.type == 'effect' then
      itemWidget:setVisible(false)
      creatureWidget:setVisible(true)
      local category = modules.game_attachedeffects.getCategory(item.id)
      if category == ThingCategoryCreature then
        local localPlayer = g_game.getLocalPlayer()
        if localPlayer then
          creatureWidget:setOutfit(localPlayer:getOutfit())
        else
          creatureWidget:setOutfit({type = 128})
        end
        detailCreature:attachEffect(g_attachedEffects.getById(item.id):clone())
      elseif category == ThingCategoryEffect then
        local localPlayer = g_game.getLocalPlayer()
        if localPlayer then
          creatureWidget:setOutfit(localPlayer:getOutfit())
        else
          creatureWidget:setOutfit({type = 128})
        end
        detailCreature:attachEffect(g_attachedEffects.getById(item.id):clone())
      elseif category == ThingExternalTexture then
        creatureWidget:setImageSource(modules.game_attachedeffects.getTexture(item.id))
      end
    else
      itemWidget:setVisible(false)
      creatureWidget:setVisible(true)
      creatureWidget:setOutfit({type = item.clientId})
    end
  end
  
  -- Quantity - calculate based on fame currency if present
  local maxQty = 1
  if item.type == 'item' and item.currencies then
    for _, currency in ipairs(item.currencies) do
      if currency.type == 'fame' then
        maxQty = math.floor(playerFamePoints / currency.amount)
        break
      end
    end
  end
  maxQty = math.max(1, math.min(100, maxQty))
  
  quantityScroll:setMinimum(1)
  quantityScroll:setMaximum(maxQty)
  quantityScroll:setValue(1)
  
  -- Buy button state - disable if owned or can't purchase
  if isOwned then
    buyButton:setEnabled(false)
    buyButton:setText('OWNED')
  else
    buyButton:setEnabled(canPurchaseItem(item))
    buyButton:setText('BUY')
  end
end

function updateDetailsPrice()
  if not selectedItem then return end
  local quantityScroll = detailsPanel:getChildById('quantityScroll')
  local priceLabel = detailsPanel:getChildById('detailPriceLabel')
  local qty = quantityScroll:getValue()
  
  -- Update price display with quantity multiplier
  if selectedItem.currencies and #selectedItem.currencies > 0 then
    local priceText = 'Price: '
    for i, currency in ipairs(selectedItem.currencies) do
      if i > 1 then priceText = priceText .. ' + ' end
      priceText = priceText .. (currency.amount * qty) .. ' '
      if currency.type == 'fame' then
        priceText = priceText .. 'Fame'
      elseif currency.type == 'gold' then
        priceText = priceText .. 'Gold'
      elseif currency.type == 'token' then
        priceText = priceText .. 'Tokens'
      elseif currency.type == 'item' then
        priceText = priceText .. 'Items'
      end
    end
    priceLabel:setText(priceText)
  end
end

function refreshItems()
  -- Save current selection before clearing
  local previousSelectedId = nil
  if selectedItem then
    previousSelectedId = selectedItem.id
  end
  
  itemsGrid:destroyChildren()
  clearSelection()
  
  if radioCards then
    radioCards:destroy()
  end
  radioCards = UIRadioGroup.create()
  
  local searchTerm = searchInput:getText():lower()
  
  for _, item in ipairs(allItems) do
    local categoryMatch = (currentCategory == 'all' or item.type == currentCategory)
    local searchMatch = (searchTerm == '' or item.name:lower():find(searchTerm, 1, true))
    
    if categoryMatch and searchMatch then
      createItemCard(item)
    end
  end
  
  -- Try to restore previous selection first
  if previousSelectedId then
    reselectItem(previousSelectedId)
  -- If no previous selection and no pending reselect, auto-select first
  elseif not pendingReselect then
    local firstCard = itemsGrid:getFirstChild()
    if firstCard then
      radioCards:selectWidget(firstCard)
    end
  end
end

function createItemCard(item)
  local card = g_ui.createWidget('FameItemCard', itemsGrid)
  card.itemData = item
  
  local priceLabel = card:recursiveGetChildById('priceLabel')
  local priceContainer = card:recursiveGetChildById('priceContainer')
  local levelLabel = card:recursiveGetChildById('levelLabel')
  local lockIcon = card:recursiveGetChildById('lockIcon')
  local ownedIcon = card:recursiveGetChildById('ownedIcon')
  local itemWidget = card:recursiveGetChildById('itemWidget')
  local creatureWidget = card:recursiveGetChildById('creatureWidget')
  
  -- Display currencies
  priceContainer:destroyChildren()
  if item.currencies and #item.currencies > 0 then
    for _, currency in ipairs(item.currencies) do
      local icon = g_ui.createWidget('UIWidget', priceContainer)
      icon:setSize('12 12')
      icon:setPhantom(true)
      
      if currency.type == 'fame' then
        icon:setImageSource('/images/icons/fame')
      elseif currency.type == 'gold' then
        icon:setImageSource('/images/icons/prey_gold')
      elseif currency.type == 'token' then
        icon:setImageSource('/images/icons/token')
      elseif currency.type == 'item' then
        icon:setImageSource('/images/icons/icon_misc')
      end
      
      local label = g_ui.createWidget('Label', priceContainer)
      label:setText(currency.amount)
      label:setFont('verdana-11px-rounded')
      label:setColor('#ffd700')
      label:setTextAutoResize(true)
      label:setPhantom(true)
    end
  end
  
  if (item.paragonLevel or 0) > 0 then
    levelLabel:setText('Lvl ' .. item.fameLevel .. ' | P' .. item.paragonLevel)
  else
    levelLabel:setText('Lvl ' .. item.fameLevel)
  end
  
  -- Check if player owns this item (from server)
  local isOwned = item.owned or false
  
  -- If owned, show large check icon covering the card
  if isOwned then
    ownedIcon:setVisible(true)
    ownedIcon:breakAnchors()
    ownedIcon:centerIn('parent')
    card:setOpacity(0.5)
  else
    ownedIcon:setVisible(false)
    -- Show lock if can't purchase
    local canPurchase = canPurchaseItem(item)
    if canPurchase then
      card:setOpacity(1.0)
    else
      card:setOpacity(0.5)
    end
    lockIcon:setVisible(not canPurchase)
  end
  
  -- Show item or creature
  if item.type == 'item' then
    itemWidget:setVisible(true)
    creatureWidget:setVisible(false)
    itemWidget:setItemId(item.clientId)
    itemWidget:setVirtual(true)
  elseif item.type == 'wings' or item.type == 'effect' then
    itemWidget:setVisible(false)
    creatureWidget:setVisible(true)
    local category = modules.game_attachedeffects.getCategory(item.id)
    if category == ThingCategoryCreature then
      creatureWidget:setOutfit({type = modules.game_attachedeffects.thingId(item.id)})
    elseif category == ThingCategoryEffect then
      local localPlayer = g_game.getLocalPlayer()
      if localPlayer then
        creatureWidget:setOutfit(localPlayer:getOutfit())
      else
        creatureWidget:setOutfit({type = 128})
      end
      creatureWidget:getCreature():attachEffect(g_attachedEffects.getById(item.id):clone())
    elseif category == ThingExternalTexture then
      creatureWidget:setImageSource(modules.game_attachedeffects.getTexture(item.id))
    end
  else
    itemWidget:setVisible(false)
    creatureWidget:setVisible(true)
    creatureWidget:setOutfit({type = item.clientId})
  end
  
  radioCards:addWidget(card)
end

function updateFameDisplay()
  famePointsLabel:setText('Fame: ' .. playerFamePoints .. ' pts')
  fameLevelLabel:setText('Level: ' .. playerFameLevel)
  refreshItems()
end

function getPlayerParagonLevel()
  return playerParagonLevel
end

function updateGoldAndTokens(gold, tokens)
  if goldLabel then
    goldLabel:setText('Gold: ' .. gold)
    refreshItems()
  end
  if tokenLabel then
    tokenLabel:setText('Tokens: ' .. tokens)
    refreshItems()
  end
end

function parseNpcShop(protocol, msg)
  allItems = {}
  
  -- Read shop table id (1 = normal, 2 = cosmetics)
  currentShopId = msg:getU8()
  
  -- Read player's gold and tokens from server
  local playerGold = msg:getU32()
  local playerTokens = msg:getU32()

  -- Read dynamic categories from server
  activeCategories = {}
  local catCount = msg:getU8()
  for i = 1, catCount do
    table.insert(activeCategories, msg:getString())
  end
  
  local size = msg:getU16()
  for i = 1, size do
    local item = {}
    item.type = msg:getString()
    item.id = msg:getU16()
    item.clientId = msg:getU16()
    item.price = msg:getU32()
    item.amount = msg:getU16()
    item.fameLevel = msg:getU32()
    item.paragonLevel = msg:getU32()
    item.weight = msg:getU32()
    item.name = msg:getString()
    item.famedesc = msg:getString()
    item.owned = msg:getU8() == 1 -- owned flag from server
    
    -- Read currencies
    local currencyCount = msg:getU8()
    item.currencies = {}
    for j = 1, currencyCount do
      local currency = {}
      currency.type = msg:getString()
      if currency.type == 'item' then
        currency.itemId = msg:getU16()
        currency.amount = msg:getU32()
      else
        currency.amount = msg:getU32()
      end
      table.insert(item.currencies, currency)
    end
    
    table.insert(allItems, item)
  end
  
  playerFamePoints = msg:getU32()
  playerFameLevel = msg:getU32()
  playerParagonLevel = msg:getU32()
  
  updateFameDisplay()
  updateGoldAndTokens(playerGold, playerTokens)
  createTabs()
  show()
  
  -- Re-select previously selected item after refresh
  if pendingReselect then
    reselectItem(pendingReselect)
    pendingReselect = nil
  end
end
