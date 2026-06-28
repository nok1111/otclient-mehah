Auction = Auction or {}
Auction.opCode = Auction.opCode or 102

-- helper: apply upgrade tier icon to an item widget
local function applyTier(widget, tier)
  if not widget then return end
  local tierWidget = widget:recursiveGetChildById('tier')
  if not tierWidget then return end
  tier = tonumber(tier) or 0
  if tier > 0 then
    local xOffset = (math.min(math.max(tier, 1), 10) - 1) * 9
    tierWidget:setImageClip({ x = xOffset, y = 0, width = 10, height = 9 })
    tierWidget:setVisible(true)
  else
    tierWidget:setVisible(false)
  end
end

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
  if tab ~= 'auction' and tab ~= 'my' and tab ~= 'history' and tab ~= 'mail' then return end
  Auction.activeTab = tab
  -- toggle UI
  if Auction.buyButton and Auction.buyButton.setVisible then Auction.buyButton:setVisible(tab == 'auction') end
  if Auction.buyCountSpin and Auction.buyCountSpin.setVisible then Auction.buyCountSpin:setVisible(tab == 'auction') end
  if Auction.buyCountValue and Auction.buyCountValue.setVisible then Auction.buyCountValue:setVisible(tab == 'auction') end
  if Auction.buyCostValue and Auction.buyCostValue.setVisible then Auction.buyCostValue:setVisible(tab == 'auction') end
  local costLbl = Auction.window and Auction.window:recursiveGetChildById('buyCostLabel') or nil
  if costLbl and costLbl.setVisible then costLbl:setVisible(tab == 'auction') end
  local costIco = Auction.window and Auction.window:recursiveGetChildById('buyCostIcon') or nil
  if costIco and costIco.setVisible then costIco:setVisible(tab == 'auction') end
  local amountLbl = Auction.window and Auction.window:recursiveGetChildById('buyAmountLabel') or nil
  if amountLbl and amountLbl.setVisible then amountLbl:setVisible(tab == 'auction') end
  -- Ensure we use the same list/scroll as other tabs for 'history'
  if Auction.historyPanel and Auction.historyPanel.setVisible then Auction.historyPanel:setVisible(false) end
  local resultsHeader = Auction.window and Auction.window:recursiveGetChildById('resultsHeader') or nil
  local sellerHeader = Auction.window and Auction.window:recursiveGetChildById('sellerHeader') or nil
  local browseScroll = Auction.window and Auction.window:recursiveGetChildById('browseScroll') or nil
  local actionsRow = Auction.window and Auction.window:recursiveGetChildById('actionsRow') or nil
  local browseVBar = Auction.window and Auction.window:recursiveGetChildById('browseVBar') or nil
  local myOffersPanel = Auction.window and Auction.window:recursiveGetChildById('myOffersPanel') or nil
  if Auction.categoryPanel and Auction.categoryPanel.setVisible then Auction.categoryPanel:setVisible(tab == 'auction') end
  if Auction.updateSubcategoryUI then Auction.updateSubcategoryUI() end
  if resultsHeader and resultsHeader.setVisible then resultsHeader:setVisible(tab ~= 'my') end
  if browseScroll and browseScroll.setVisible then browseScroll:setVisible(tab ~= 'my') end
  if browseVBar and browseVBar.setVisible then browseVBar:setVisible(tab ~= 'my') end
  if actionsRow and actionsRow.setVisible then actionsRow:setVisible(tab == 'auction') end
  if myOffersPanel and myOffersPanel.setVisible then myOffersPanel:setVisible(tab == 'my') end
  local mainArea = Auction.window and Auction.window:recursiveGetChildById('mainArea') or nil
  if mainArea and mainArea.removeAnchor and mainArea.addAnchor then
    mainArea:removeAnchor(3) -- remove left anchor
    if tab == 'auction' then
      mainArea:addAnchor(3, 'categoryPanel', 4) -- left to categoryPanel.right
    else
      mainArea:addAnchor(3, 'parent', 3) -- left to parent.left (use category space)
    end
  end
  local paginationRow = Auction.window and Auction.window:recursiveGetChildById('paginationRow') or nil
  local auctionTools = { Auction.sortBox, Auction.prevPageButton, Auction.nextPageButton, Auction.pageLabel, paginationRow }
  for _, widget in ipairs(auctionTools) do
    if widget and widget.setVisible then widget:setVisible(tab == 'auction') end
  end
  if tab == 'auction' then Auction.updatePageLabel() end
  if Auction.window and Auction.window.updateLayout then Auction.window:updateLayout() end
  -- Highlight active tab
  local tabButtons = { auction = Auction.tabAuction, my = Auction.tabMy, history = Auction.tabHistory, mail = Auction.tabMail }
  for name, btn in pairs(tabButtons) do
    if btn and btn.setColor and btn.setBackgroundColor then
      if name == tab then
        btn:setColor('#f5c542')
        btn:setBackgroundColor('#252535')
        if btn.setBorderColor then btn:setBorderColor('#f5c542') end
      else
        btn:setColor('#cccccc')
        btn:setBackgroundColor('#1a1a24')
        if btn.setBorderColor then btn:setBorderColor('#2a2a3a') end
      end
    end
  end
  if sellerHeader and sellerHeader.setText then
    if tab == 'history' or tab == 'mail' then sellerHeader:setText('') else sellerHeader:setText('Seller') end
  end
  local timeHeader = Auction.window and Auction.window:recursiveGetChildById('timeHeader') or nil
  if timeHeader and timeHeader.setText then
    if tab == 'history' or tab == 'mail' then timeHeader:setText('Date') else timeHeader:setText('Time Left') end
  end
  -- clear current list
  if Auction.browseList then Auction.browseList:destroyChildren() end
  -- request data
  if tab == 'auction' then
    print('[Auction][Client] [source] setTab -> AH_SEARCH')
    Auction.send('AH_SEARCH', Auction.buildSearchParams())
  elseif tab == 'my' then
    Auction.send('AH_MY', {})
  elseif tab == 'history' then
    if Auction.browseList then
      Auction.browseList:destroyChildren()
      local loading = g_ui.createWidget('UILabel', Auction.browseList)
      loading:setText('Loading...')
      loading:setPhantom(true)
      loading:setColor('#bbbbbb')
      loading:setMarginTop(8)
      loading:setMarginLeft(8)
      loading:setWidth(120)
      loading:setHeight(16)
    end
    Auction.send('AH_HISTORY', {})
  elseif tab == 'mail' then
    if Auction.browseList then
      Auction.browseList:destroyChildren()
      local loading = g_ui.createWidget('UILabel', Auction.browseList)
      loading:setText('Loading...')
      loading:setPhantom(true)
      loading:setColor('#bbbbbb')
      loading:setMarginTop(8)
      loading:setMarginLeft(8)
      loading:setWidth(120)
      loading:setHeight(16)
    end
    Auction.send('AH_MAIL', {})
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
    return string.format('%s (%s)', formatPrice(total), formatPrice(per))
  end
  return formatPrice(total)
end
Auction = Auction or {}
Auction.opCode = 102

-- helper: current category filter
local function getSelectedCategory()
  return Auction.currentCategory or 'all'
end

-- helper: build AH_SEARCH payload with current UI values
function Auction.buildSearchParams(nameOverride)
  local name = nameOverride
  if not name and Auction.searchEdit and Auction.searchEdit.getText then
    name = Auction.searchEdit:getText()
  end
  local params = {
    limit = 25,
    offset = tonumber(Auction.searchOffset) or 0,
    category = getSelectedCategory(),
    sortBy = Auction.searchSortBy or 'newest',
    sortOrder = (Auction.searchSortBy == 'price_desc') and 'DESC' or 'ASC'
  }
  print(string.format('[Auction][Client] buildSearchParams category=%s name=%s sort=%s offset=%s', tostring(params.category), tostring(name), tostring(params.sortBy), tostring(params.offset)))
  if name and name ~= '' then params.name = name end
  return params
end

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
Auction.activeTab = 'auction' -- 'auction' | 'my' | 'history' | 'mail'
Auction.buyButton = nil
Auction.cancelButton = nil
Auction.tabAuction = nil
Auction.tabMy = nil
Auction.myOffersList = nil
Auction.searchDebounceEvent = nil
Auction.buyCountSpin = nil
Auction.buyCountValue = nil
Auction.buyCostValue = nil
Auction.buyCostIcon = nil
Auction.createCostIcon = nil
Auction.rewardGold = nil
Auction.rewardFame = nil
Auction.dur12 = nil
Auction.dur24 = nil
Auction.dur48 = nil
Auction.rewardGroup = nil
Auction.durationGroup = nil
Auction.currentSelected = { id = nil, count = 1, price = 0 }
Auction.searchOffset = 0
Auction.searchSortBy = 'newest'
Auction.currentCategory = 'all'
Auction.weaponsExpanded = false
Auction.consumablesExpanded = false
Auction.ignoreSearchEdit = false

-- Update partial-buy controls from currentSelected
function Auction.updateBuyControls(curOverride)
  if not (Auction.buyCountSpin and Auction.buyCostValue) then return end
  local maxc = tonumber(Auction.currentSelected.count) or 1
  local total = tonumber(Auction.currentSelected.price) or 0
  if maxc < 1 then maxc = 1 end
  if Auction.buyCountSpin.setMaximum then Auction.buyCountSpin:setMaximum(maxc) end
  local cur = tonumber(curOverride) or tonumber((Auction.buyCountSpin.getValue and Auction.buyCountSpin:getValue()) or 1) or 1
  if cur < 1 then cur = 1 end
  if cur > maxc then cur = maxc end
  if curOverride and Auction.buyCountSpin.setValue then Auction.buyCountSpin:setValue(cur) end
  if Auction.buyCountValue and Auction.buyCountValue.setText then Auction.buyCountValue:setText(tostring(cur)) end
  local part = math.floor((total > 0 and (total * (cur / maxc))) or 0)
  if Auction.buyCostValue.setText then Auction.buyCostValue:setText(buildPriceText(part, 1)) end
  local reward = Auction.currentSelected.reward or 'gold'
  if Auction.buyCostIcon and Auction.buyCostIcon.setImageSource then
    Auction.buyCostIcon:setImageSource(reward == 'fame' and '/images/icons/fame.png' or '/images/icons/gold_coin.png')
  end
  print(string.format('[Auction][Client] updateBuyControls cur=%s max=%s total=%s part=%s reward=%s', tostring(cur), tostring(maxc), tostring(total), tostring(part), tostring(reward)))
end

function Auction.updateRewardUI()
  local reward = 'gold'
  if Auction.rewardGroup and Auction.rewardGroup.getSelectedWidget then
    local sel = Auction.rewardGroup:getSelectedWidget()
    if sel and sel.getId then
      local id = sel:getId()
      if id == 'rewardFame' then reward = 'fame' end
    end
  end
  if Auction.createCostIcon and Auction.createCostIcon.setImageSource then
    Auction.createCostIcon:setImageSource(reward == 'fame' and '/images/icons/fame.png' or '/images/icons/gold_coin.png')
  end
end

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
  Auction.createCostValue = Auction.window:recursiveGetChildById('createCostValue')
  Auction.createCostIcon = Auction.window:recursiveGetChildById('createCostIcon')
  Auction.myOffersList = Auction.window:recursiveGetChildById('myOffersList')
  Auction.rewardGold = Auction.window:recursiveGetChildById('rewardGold')
  Auction.rewardFame = Auction.window:recursiveGetChildById('rewardFame')
  Auction.dur12 = Auction.window:recursiveGetChildById('dur12')
  Auction.dur24 = Auction.window:recursiveGetChildById('dur24')
  Auction.dur48 = Auction.window:recursiveGetChildById('dur48')
  Auction.tabAuction     = Auction.window:recursiveGetChildById('tabAuction')
  Auction.tabMy          = Auction.window:recursiveGetChildById('tabMy')
  Auction.tabMail        = Auction.window:recursiveGetChildById('tabMail')
  Auction.tabHistory     = Auction.window:recursiveGetChildById('tabHistory')
  Auction.buyCountSpin = Auction.window:recursiveGetChildById('buyCountSpin')
  Auction.buyCountValue= Auction.window:recursiveGetChildById('buyCountValue')
  Auction.buyCostValue = Auction.window:recursiveGetChildById('buyCostValue')
  Auction.buyCostIcon = Auction.window:recursiveGetChildById('buyCostIcon')
  Auction.historyList  = Auction.window:recursiveGetChildById('historyList')
  Auction.historyPanel = Auction.window:recursiveGetChildById('historyPanel')
  Auction.sortBox      = Auction.window:recursiveGetChildById('sortBox')
  Auction.pageLabel    = Auction.window:recursiveGetChildById('pageLabel')
  Auction.prevPageButton = Auction.window:recursiveGetChildById('prevPageButton')
  Auction.nextPageButton = Auction.window:recursiveGetChildById('nextPageButton')

  Auction.categoryPanel    = Auction.window:recursiveGetChildById('categoryPanel')
  Auction.subcategoryPanel = Auction.window:recursiveGetChildById('subcategoryPanel')

  -- Sidebar category buttons
  Auction.catAll         = Auction.window:recursiveGetChildById('catAll')
  Auction.catWeapons     = Auction.window:recursiveGetChildById('catWeapons')
  Auction.catArmor       = Auction.window:recursiveGetChildById('catArmor')
  Auction.catShields     = Auction.window:recursiveGetChildById('catShields')
  Auction.catBoots       = Auction.window:recursiveGetChildById('catBoots')
  Auction.catHelmet      = Auction.window:recursiveGetChildById('catHelmet')
  Auction.catAccessories = Auction.window:recursiveGetChildById('catAccessories')
  Auction.catRunes       = Auction.window:recursiveGetChildById('catRunes')
  Auction.catPets        = Auction.window:recursiveGetChildById('catPets')
  Auction.catConsumables = Auction.window:recursiveGetChildById('catConsumables')
  Auction.catMaterials   = Auction.window:recursiveGetChildById('catMaterials')
  Auction.catOthers      = Auction.window:recursiveGetChildById('catOthers')

  -- Subcategory panels
  Auction.subcategoryPanel = Auction.window:recursiveGetChildById('subcategoryPanel')
  Auction.consumablesSubcategoryPanel = Auction.window:recursiveGetChildById('consumablesSubcategoryPanel')

  -- Subcategory buttons (weapons)
  Auction.subOneHand   = Auction.window:recursiveGetChildById('subOneHand')
  Auction.subTwoHand   = Auction.window:recursiveGetChildById('subTwoHand')
  Auction.subDistance  = Auction.window:recursiveGetChildById('subDistance')
  Auction.subWands     = Auction.window:recursiveGetChildById('subWands')
  Auction.subShields   = Auction.window:recursiveGetChildById('subShields')

  -- Subcategory buttons (consumables)
  Auction.subPotions   = Auction.window:recursiveGetChildById('subPotions')
  Auction.subFlasks    = Auction.window:recursiveGetChildById('subFlasks')
  Auction.subElixirs   = Auction.window:recursiveGetChildById('subElixirs')

  -- Initialize sort options
  if Auction.sortBox then
    local sortOpts = { 'Newest', 'Price: Low to High', 'Price: High to Low', 'Time Left' }
    if Auction.sortBox.clearOptions then pcall(function() Auction.sortBox:clearOptions() end) end
    for i = 1, #sortOpts do
      pcall(function() Auction.sortBox:addOption(sortOpts[i]) end)
    end
    if Auction.sortBox.setCurrentOption then
      pcall(function() Auction.sortBox:setCurrentOption('Newest') end)
    elseif Auction.sortBox.setText then
      pcall(function() Auction.sortBox:setText('Newest') end)
    end
    Auction.sortBox.onOptionChange = function(widget, text, index)
      Auction.onSortChange(text)
    end
    Auction.sortBox.onChange = function(widget)
      local ok, txt = pcall(function() return widget:getText() end)
      Auction.onSortChange(ok and txt or nil)
    end
  end

  -- Bind page buttons
  if Auction.prevPageButton then Auction.prevPageButton.onClick = Auction.onPrevPage end
  if Auction.nextPageButton then Auction.nextPageButton.onClick = Auction.onNextPage end
  Auction.updatePageLabel()

  local function updateCountValue() end

  local function updateCreateTotal()
    if not Auction.createCostValue then return end
    local unit = tonumber(Auction.priceEdit and Auction.priceEdit:getText() or 0) or 0
    local cnt = tonumber(Auction.countSpin and Auction.countSpin:getValue() or 1) or 1
    if cnt < 1 then cnt = 1 end
    local total = math.floor(unit * cnt)
    Auction.createCostValue:setText(tostring(total))
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
      updateCreateTotal()
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
          updateCreateTotal()
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
  local refreshButton = Auction.window:recursiveGetChildById('refreshButton')
  local searchButton = Auction.window:recursiveGetChildById('searchButton')
  local listButton   = Auction.window:recursiveGetChildById('listButton')
  local buyButton    = Auction.window:recursiveGetChildById('buyButton')
  local cancelButton = Auction.window:recursiveGetChildById('cancelButton')
  if refreshButton then refreshButton.onClick = Auction.onRefresh end
  if searchButton then searchButton.onClick = Auction.onSearch end

  -- Bind sidebar category buttons
  local catButtons = {
    { 'catAll', 'all' }, { 'catWeapons', 'weapons' }, { 'catArmor', 'armors' },
    { 'catShields', 'shields' }, { 'catBoots', 'boots' }, { 'catHelmet', 'helmet' },
    { 'catAccessories', 'accessories' }, { 'catRunes', 'runes' }, { 'catPets', 'pets' },
    { 'catConsumables', 'consumables' }, { 'catMaterials', 'materials' },
    { 'catOthers', 'others' }
  }
  for _, pair in ipairs(catButtons) do
    local btn = Auction[pair[1]]
    if btn then
      btn.onClick = function()
        local cat = pair[2]
        if cat == 'weapons' then
          -- Toggle subcategories on re-click, always fall back to all weapons
          Auction.weaponsExpanded = not Auction.weaponsExpanded
          Auction.consumablesExpanded = false
          Auction.currentCategory = 'weapons'
        elseif cat == 'consumables' then
          -- Toggle consumables subcategories on re-click
          Auction.consumablesExpanded = not Auction.consumablesExpanded
          Auction.weaponsExpanded = false
          Auction.currentCategory = 'consumables'
        else
          if Auction.currentCategory == cat then return end
          Auction.weaponsExpanded = false
          Auction.consumablesExpanded = false
          Auction.currentCategory = cat
        end
        Auction.updateCategoryUI()
        Auction.updateSubcategoryUI()
        Auction.onSearch()
      end
    end
  end
  Auction.updateCategoryUI()
  Auction.updateSubcategoryUI()

  -- Bind weapon subcategory buttons
  local subButtons = {
    { 'subOneHand', 'weapons_onehand' }, { 'subTwoHand', 'weapons_twohand' },
    { 'subDistance', 'weapons_distance' }, { 'subWands', 'weapons_wands' },
    { 'subShields', 'weapons_shield' }
  }
  for _, pair in ipairs(subButtons) do
    local btn = Auction[pair[1]]
    if btn then
      btn.onClick = function()
        if Auction.currentCategory == pair[2] then return end
        Auction.weaponsExpanded = true
        Auction.consumablesExpanded = false
        Auction.currentCategory = pair[2]
        Auction.updateCategoryUI()
        Auction.updateSubcategoryUI()
        Auction.onSearch()
      end
    end
  end

  -- Bind consumables subcategory buttons
  local consumablesSubButtons = {
    { 'subPotions', 'consumables_potions' }, { 'subFlasks', 'consumables_flasks' },
    { 'subElixirs', 'consumables_elixirs' }
  }
  for _, pair in ipairs(consumablesSubButtons) do
    local btn = Auction[pair[1]]
    if btn then
      btn.onClick = function()
        if Auction.currentCategory == pair[2] then return end
        Auction.consumablesExpanded = true
        Auction.weaponsExpanded = false
        Auction.currentCategory = pair[2]
        Auction.updateCategoryUI()
        Auction.updateSubcategoryUI()
        Auction.onSearch()
      end
    end
  end

  -- Live search disabled: TextEdit onTextChange can fire during window open
  -- and trigger duplicate AH_SEARCH, which is causing the freeze.
  -- Use the Search button instead.
  if Auction.searchEdit then
    -- no-op onTextChange prevents any accidental live search
    Auction.searchEdit.onTextChange = function(widget, text) end
  end
  if listButton   then listButton.onClick   = Auction.onList   end
  if buyButton    then buyButton.onClick    = Auction.onBuy    end
  if cancelButton then cancelButton.onClick = Auction.onCancel end
  if Auction.tabAuction then Auction.tabAuction.onClick = function() Auction.setTab('auction') end end
  if Auction.tabMy then Auction.tabMy.onClick = function() Auction.setTab('my') end end
  if Auction.tabHistory then Auction.tabHistory.onClick = function() Auction.setTab('history') end end
  if Auction.tabMail then Auction.tabMail.onClick = function() Auction.setTab('mail') end end
  Auction.buyButton = buyButton
  Auction.cancelButton = cancelButton
  if Auction.buyButton and Auction.buyButton.setEnabled then Auction.buyButton:setEnabled(false) end
  if Auction.cancelButton and Auction.cancelButton.setEnabled then Auction.cancelButton:setEnabled(false) end

  -- Bind buy amount SpinBox change
  if Auction.buyCountSpin and Auction.buyCountSpin.onValueChange ~= nil then
    Auction.buyCountSpin.onValueChange = function(self, value)
      local v = value or (self and self.getValue and self:getValue()) or 1
      Auction.updateBuyControls(v)
    end
  end

  if Auction.countSpin then
    Auction.countSpin.onValueChange = function(self, value)
      updateCountValue()
      updateCreateTotal()
    end
    updateCountValue()
    updateCreateTotal()
  end

  if Auction.priceEdit then
    Auction.priceEdit.onTextChange = function(self, text)
      updateCreateTotal()
    end
  end

  -- Reward type and duration radio groups
  if UIRadioGroup then
    Auction.rewardGroup = UIRadioGroup.create()
    Auction.durationGroup = UIRadioGroup.create()
    if Auction.rewardGold then Auction.rewardGroup:addWidget(Auction.rewardGold) end
    if Auction.rewardFame then Auction.rewardGroup:addWidget(Auction.rewardFame) end
    if Auction.dur12 then Auction.durationGroup:addWidget(Auction.dur12) end
    if Auction.dur24 then Auction.durationGroup:addWidget(Auction.dur24) end
    if Auction.dur48 then Auction.durationGroup:addWidget(Auction.dur48) end
    if Auction.rewardGroup then
      Auction.rewardGroup.onSelectionChange = function(group, selected, previous)
        Auction.updateRewardUI()
      end
    end
    if Auction.rewardGroup and Auction.rewardGold then Auction.rewardGroup:selectWidget(Auction.rewardGold, true) end
    if Auction.durationGroup and Auction.dur24 then Auction.durationGroup:selectWidget(Auction.dur24, true) end
    Auction.updateRewardUI()
  end

  -- tab visuals and initial request are set by toggle() after ensureWindow()
  return true
end

function Auction.send(e, d)
  local protocol = g_game.getProtocolGame()
  if not protocol then return end
  print(string.format('[Auction][Client] >>> send %s', tostring(e)))
  protocol:sendExtendedOpcode(Auction.opCode, json.encode({ e = e, d = d }))
end

function Auction.onExtendedOpcode(protocol, code, buffer)
  print(string.format('[Auction][Client] <<< recv opcode %d', code))
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
    print('[Auction][Client] [source] AH_OPEN_ACK handler -> AH_SEARCH')
    local okReq1, reqErr1 = pcall(function() Auction.send('AH_SEARCH', Auction.buildSearchParams()) end)
    if not okReq1 then print('[Auction][Client][Warn] Failed to request AH_SEARCH: '..tostring(reqErr1)) end
    local okReq2, reqErr2 = pcall(function() Auction.send('AH_MY', {}) end)
    if not okReq2 then print('[Auction][Client][Warn] Failed to request AH_MY: '..tostring(reqErr2)) end
  -- history is fetched on demand when switching to tab
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
      empty:setWidth(120)
      empty:setHeight(16)
    end
    for i = 1, #d do
      local w = g_ui.createWidget('AuctionRow', Auction.browseList)
      local cnt = tonumber(d[i].count) or 1
      local baseName = tostring(d[i].name or ''):gsub('^%s*[xX]%s*%d+%s+', '')
      w:getChildById('name'):setText(baseName)
      w:getChildById('price'):setText(buildPriceText(tonumber(d[i].price) or 0, cnt))
      local priceIcon = w:getChildById('priceIcon')
      if priceIcon and priceIcon.setImageSource then
        priceIcon:setImageSource((d[i].reward == 'fame') and '/images/icons/fame.png' or '/images/icons/gold_coin.png')
      end
      local item = w:getChildById('icon')
      print(string.format('[Auction][Client] SEARCH row i=%d id=%s name=%s price=%s cid=%s count=%s tier=%s', i, tostring(d[i].id), tostring(d[i].name), tostring(d[i].price), tostring(d[i].cid), tostring(d[i].count), tostring(d[i].tier)))
      item:setItemId(d[i].cid)
      applyIconShader(item, d[i].name)
      applyIconCount(item, cnt)
      applyTier(item, d[i].tier)
      w.listingId = d[i].id
      w.stackCount = cnt
      w.totalPrice = tonumber(d[i].price) or 0
      w.rewardType = d[i].reward or 'gold'
      -- set Seller and Time Left columns for Auction tab
      local sellerNameLbl = w:getChildById('sellerName')
      if sellerNameLbl then
        sellerNameLbl:setText(tostring(d[i].sellerName or ''))
      end
      local timeLbl = w:getChildById('timeLeft')
      if timeLbl then
        local ttl = tonumber(d[i].ttl) or 0
        if ttl >= 3600 then
          timeLbl:setText(string.format('%dh', math.ceil(ttl / 3600)))
        else
          timeLbl:setText(string.format('%dm', math.max(0, math.ceil(ttl / 60))))
        end
      end
      -- ensure per-row cancel is hidden on Auction tab rows
      local rowCancel = w:recursiveGetChildById('rowCancel')
      if rowCancel then rowCancel:setVisible(false) end
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
        -- update partial-buy selection data
        Auction.currentSelected.id = w.listingId
        Auction.currentSelected.count = w.stackCount
        Auction.currentSelected.price = w.totalPrice
        Auction.currentSelected.reward = w.rewardType or 'gold'
        -- initialize slider range/value for this stack
        if Auction.buyCountSpin then
          if Auction.buyCountSpin.setMinimum then Auction.buyCountSpin:setMinimum(1) end
          if Auction.buyCountSpin.setMaximum then Auction.buyCountSpin:setMaximum(w.stackCount) end
          if Auction.buyCountSpin.setValue then Auction.buyCountSpin:setValue(1) end
        end
        if Auction.updateBuyControls then Auction.updateBuyControls(1) end
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
    if Auction.nextPageButton and Auction.nextPageButton.setEnabled then
      Auction.nextPageButton:setEnabled(#d >= 25)
    end
  elseif e == 'AH_MY_DATA' then
    print(string.format('[Auction][Client] AH_MY_DATA count=%d', type(d)=='table' and #d or -1))
    if not Auction.myOffersList or Auction.activeTab ~= 'my' then return end
    if Auction.selectedMyRow then
      pcall(function() local o = Auction.selectedMyRow:getChildById('sel'); if o then o:setVisible(false) end end)
    end
    Auction.selectedId = nil
    Auction.selectedMyRow = nil
    Auction.myOffersList:destroyChildren()
    if #d == 0 then
      local empty = g_ui.createWidget('UILabel', Auction.myOffersList)
      empty:setText('You have no active listings.')
      empty:setPhantom(true)
      empty:setColor('#bbbbbb')
      empty:setMarginTop(8)
      empty:setMarginLeft(8)
      empty:setWidth(120)
      empty:setHeight(16)
    end
    for i = 1, #d do
      local w = g_ui.createWidget('AuctionRow', Auction.myOffersList)
      local cnt = tonumber(d[i].count) or 1
      local baseName = tostring(d[i].name or ''):gsub('^%s*[xX]%s*%d+%s+', '')
      w:getChildById('name'):setText(baseName)
      w:getChildById('price'):setText(buildPriceText(tonumber(d[i].price) or 0, cnt))
      local priceIcon = w:getChildById('priceIcon')
      if priceIcon and priceIcon.setImageSource then
        priceIcon:setImageSource((d[i].reward == 'fame') and '/images/icons/fame.png' or '/images/icons/gold_coin.png')
      end
      local item = w:getChildById('icon')
      print(string.format('[Auction][Client] MY row i=%d id=%s name=%s price=%s cid=%s count=%s tier=%s', i, tostring(d[i].id), tostring(d[i].name), tostring(d[i].price), tostring(d[i].cid), tostring(d[i].count), tostring(d[i].tier)))
      item:setItemId(d[i].cid)
      applyIconShader(item, d[i].name)
      applyIconCount(item, cnt)
      applyTier(item, d[i].tier)
      w.listingId = d[i].id
      w.rewardType = d[i].reward or 'gold'
      -- show Time Left on My tab (hours if >=1h, else minutes)
      local timeLbl = w:getChildById('timeLeft')
      if timeLbl then
        local ttl = tonumber(d[i].ttl) or 0
        if ttl >= 3600 then
          timeLbl:setText(string.format('%dh', math.ceil(ttl / 3600)))
        else
          timeLbl:setText(string.format('%dm', math.max(0, math.ceil(ttl / 60))))
        end
      end
      -- show per-row cancel button for My Listings
      local rowCancel = w:recursiveGetChildById('rowCancel')
      if rowCancel then
        rowCancel:setVisible(true)
        rowCancel.onClick = function()
          Auction.send('AH_CANCEL', { id = w.listingId })
        end
      end
      print(string.format('[Auction][Client] added my row id=%s name=%s', tostring(d[i].id), tostring(d[i].name)))
      print('[Auction][Client] list child count:', Auction.myOffersList:getChildCount())
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
        Auction.currentSelected.reward = w.rewardType or 'gold'
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
      local suffix = (d.reward == 'fame' and ' fame') or ' gp'
      displayInfoBox('Auction', 'Listed: '..d.name..' x'..d.count..' for '..d.price..suffix)
      Auction.send('AH_MY', {})
      Auction.send('AH_SEARCH', Auction.buildSearchParams())
      if Auction.listItemSlot then Auction.listItemSlot:setItem(nil) end
      Auction.priceEdit:setText('')
      Auction.countSpin:setValue(1)
      if Auction.rewardGroup and Auction.rewardGold then Auction.rewardGroup:selectWidget(Auction.rewardGold, true) end
      if Auction.durationGroup and Auction.dur24 then Auction.durationGroup:selectWidget(Auction.dur24, true) end
      Auction.updateRewardUI()
    end
  elseif e == 'AH_BUY_ACK' then
    print('[Auction][Client] AH_BUY_ACK received')
    if d and d.error then
      displayInfoBox('Auction', d.error)
    else
      local suffix = (d.reward == 'fame') and ' fame' or ' gp'
      displayInfoBox('Auction', 'Purchased for '..d.price..suffix)
      Auction.send('AH_MY', {})
      Auction.send('AH_SEARCH', Auction.buildSearchParams())
    end
  elseif e == 'AH_BUY_PART_ACK' then
    print('[Auction][Client] AH_BUY_PART_ACK received')
    if d and d.error then
      displayInfoBox('Auction', d.error)
    else
      local suffix = (d.reward == 'fame') and ' fame' or ' gp'
      displayInfoBox('Auction', 'Purchased '..tostring(d.count)..' for '..tostring(d.price)..suffix)
      Auction.send('AH_MY', {})
      local params = Auction.buildSearchParams()
      print(string.format('[Auction][Client] refresh after BUY_PART with category=%s name=%s', tostring(params.category), tostring(params.name)))
      Auction.send('AH_SEARCH', params)
    end
  elseif e == 'AH_CANCEL_ACK' then
    print('[Auction][Client] AH_CANCEL_ACK received')
    if d and d.error then
      displayInfoBox('Auction', d.error)
    else
      displayInfoBox('Auction', 'Listing canceled.')
      Auction.send('AH_MY', {})
      local params = Auction.buildSearchParams()
      print(string.format('[Auction][Client] refresh after CANCEL with category=%s name=%s', tostring(params.category), tostring(params.name)))
      Auction.send('AH_SEARCH', params)
    end
  elseif e == 'AH_HISTORY_DATA' then
    print(string.format('[Auction][Client] AH_HISTORY_DATA count=%d', type(d)=='table' and #d or -1))
    if Auction.activeTab ~= 'history' then return end
    if not Auction.browseList then return end
    Auction.browseList:destroyChildren()
    if #d == 0 then
      local empty = g_ui.createWidget('UILabel', Auction.browseList)
      empty:setText('No sales yet.')
      empty:setPhantom(true)
      empty:setColor('#bbbbbb')
      empty:setMarginTop(8)
      empty:setMarginLeft(8)
      empty:setWidth(120)
      empty:setHeight(16)
      return
    end
    for i = 1, #d do
      local w = g_ui.createWidget('AuctionRow', Auction.browseList)
      local cnt = tonumber(d[i].count) or 1
      local baseName = tostring(d[i].name or ''):gsub('^%s*[xX]%s*%d+%s+', '')
      w:getChildById('name'):setText(baseName)
      w:getChildById('price'):setText(tostring(d[i].price) .. ' gold')
      local item = w:getChildById('icon')
      item:setItemId(d[i].cid)
      applyIconShader(item, d[i].name)
      applyIconCount(item, cnt)
      applyTier(item, d[i].tier)
      -- show date in the timeLeft column
      local function fmt(ts)
        if tonumber(ts) then
          return os.date and os.date('%Y-%m-%d %H:%M', ts) or tostring(ts)
        end
        return tostring(ts)
      end
      local timeLbl = w:getChildById('timeLeft'); if timeLbl then timeLbl:setText(fmt(d[i].sold_at)) end
      local sellerNameLbl = w:getChildById('sellerName'); if sellerNameLbl then sellerNameLbl:setText('') end
      local rowCancel = w:recursiveGetChildById('rowCancel'); if rowCancel then rowCancel:setVisible(false) end
    end
  elseif e == 'AH_MAIL_DATA' then
    print(string.format('[Auction][Client] AH_MAIL_DATA count=%d', type(d)=='table' and #d or -1))
    if Auction.activeTab ~= 'mail' then return end
    if not Auction.browseList then return end
    Auction.browseList:destroyChildren()
    if #d == 0 then
      local empty = g_ui.createWidget('UILabel', Auction.browseList)
      empty:setText('No pending payouts.')
      empty:setPhantom(true)
      empty:setColor('#bbbbbb')
      empty:setMarginTop(8)
      empty:setMarginLeft(8)
      empty:setWidth(120)
      empty:setHeight(16)
      return
    end
    for i = 1, #d do
      local w = g_ui.createWidget('AuctionRow', Auction.browseList)
      local cnt = tonumber(d[i].count) or 1
      local baseName = tostring(d[i].name or ''):gsub('^%s*[xX]%s*%d+%s+', '')
      w:getChildById('name'):setText(baseName)
      local priceLbl = w:getChildById('price')
      local priceIcon = w:getChildById('priceIcon')
      local amount = tonumber(d[i].price) or 0
      if amount > 0 then
        priceLbl:setText(tostring(amount))
        if priceIcon and priceIcon.setImageSource then
          priceIcon:setImageSource((d[i].reward == 'fame') and '/images/icons/fame.png' or '/images/icons/gold_coin.png')
        end
        if priceIcon and priceIcon.setVisible then priceIcon:setVisible(true) end
      else
        priceLbl:setText('')
        if priceIcon and priceIcon.setVisible then priceIcon:setVisible(false) end
      end
      local item = w:getChildById('icon')
      item:setItemId(d[i].cid)
      applyIconShader(item, d[i].name)
      applyIconCount(item, cnt)
      applyTier(item, d[i].tier)
      local timeLbl = w:getChildById('timeLeft')
      if timeLbl then
        local ts = tonumber(d[i].sold_at) or 0
        timeLbl:setText(os.date and os.date('%Y-%m-%d %H:%M', ts) or tostring(ts))
      end
      local sellerNameLbl = w:getChildById('sellerName'); if sellerNameLbl then sellerNameLbl:setText('') end
      local rowCancel = w:recursiveGetChildById('rowCancel')
      if rowCancel then
        rowCancel:setVisible(true)
        if rowCancel.setText then rowCancel:setText(amount > 0 and 'Claim' or 'Claim Item') end
        local pid = d[i].id
        rowCancel.onClick = function()
          Auction.send('AH_CLAIM', { id = pid })
        end
      end
    end
  elseif e == 'AH_CLAIM_ACK' then
    if d and d.error then
      displayInfoBox('Auction', d.error)
    else
      displayInfoBox('Auction', 'You successfully claimed this offer.')
      Auction.send('AH_MAIL', {})
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
  -- Add a main panel button when game starts (if mainpanel module is available)
  if modules and modules.game_mainpanel and modules.game_mainpanel.addToggleButton then
    pcall(function()
      modules.game_mainpanel.addToggleButton('auctionButton', tr('Auction'), '', Auction.toggle, false, 9)
    end)
  end
  -- Defer UI creation until first open; do not import OTUI here to avoid startup issues
  if Auction.pendingOpen and not Auction.window then
    if Auction.ensureWindow() then
      Auction.pendingOpen = false
      Auction.window:show(); Auction.window:raise(); Auction.window:focus()
      print('[Auction][Client] [source] onGameStart pendingOpen -> AH_SEARCH')
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
  Auction.myOffersList = nil
  Auction.searchEdit = nil
  Auction.priceEdit = nil
  Auction.countSpin = nil
  Auction.listItemSlot = nil
  Auction.buyCostIcon = nil
  Auction.createCostIcon = nil
  Auction.rewardGold = nil
  Auction.rewardFame = nil
  Auction.dur12 = nil
  Auction.dur24 = nil
  Auction.dur48 = nil
  if Auction.rewardGroup and Auction.rewardGroup.destroy then Auction.rewardGroup:destroy() end
  if Auction.durationGroup and Auction.durationGroup.destroy then Auction.durationGroup:destroy() end
  Auction.rewardGroup = nil
  Auction.durationGroup = nil
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
  g_keyboard.bindKeyDown('Ctrl+A', Auction.toggle)
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

function Auction.toggle()
  print('[Auction][Client] toggle called')
  if not Auction.window or Auction.window:isDestroyed() then
    if not Auction.ensureWindow() then
      return
    end
  end
  if Auction.window:isVisible() then
    Auction.window:hide()
  else
    Auction.window:show(); Auction.window:raise(); Auction.window:focus()
    Auction.setTab(Auction.activeTab or 'auction')
  end
end

function Auction.onOpen()
  print('[Auction][Client] onOpen called')
  Auction.toggle()
end

function Auction.onRefresh()
  print('[Auction][Client] onRefresh: reloading lists')
  if Auction.activeTab == 'auction' then
    Auction.send('AH_SEARCH', Auction.buildSearchParams())
  else
    Auction.send('AH_MY', {})
  end
end

function Auction.updatePageLabel()
  if Auction.pageLabel and Auction.pageLabel.setText then
    local page = math.floor((tonumber(Auction.searchOffset) or 0) / 25) + 1
    Auction.pageLabel:setText('Page ' .. page)
  end
  if Auction.prevPageButton and Auction.prevPageButton.setEnabled then
    Auction.prevPageButton:setEnabled((tonumber(Auction.searchOffset) or 0) > 0)
  end
end

function Auction.onSortChange(text)
  if not text then return end
  local map = {
    ['Newest'] = 'newest',
    ['Price: Low to High'] = 'timethenprice',
    ['Price: High to Low'] = 'price_desc',
    ['Time Left'] = 'timeleft'
  }
  local newSort = map[tostring(text)] or 'newest'
  if newSort ~= Auction.searchSortBy then
    Auction.searchSortBy = newSort
    Auction.searchOffset = 0
    Auction.updatePageLabel()
    if Auction.activeTab == 'auction' then
      Auction.clearBrowseWithLoading()
      Auction.send('AH_SEARCH', Auction.buildSearchParams())
    end
  end
end

function Auction.onPrevPage()
  if Auction.activeTab ~= 'auction' then return end
  Auction.searchOffset = math.max(0, (tonumber(Auction.searchOffset) or 0) - 25)
  Auction.updatePageLabel()
  Auction.clearBrowseWithLoading()
  Auction.send('AH_SEARCH', Auction.buildSearchParams())
end

function Auction.onNextPage()
  if Auction.activeTab ~= 'auction' then return end
  Auction.searchOffset = (tonumber(Auction.searchOffset) or 0) + 25
  Auction.updatePageLabel()
  Auction.clearBrowseWithLoading()
  Auction.send('AH_SEARCH', Auction.buildSearchParams())
end

function Auction.onSearch()
  print(string.format('[Auction][Client] onSearch: name=%s', tostring(Auction.searchEdit and Auction.searchEdit:getText() or '')))
  Auction.searchOffset = 0
  Auction.updatePageLabel()
  if Auction.activeTab == 'auction' then Auction.clearBrowseWithLoading() end
  Auction.send('AH_SEARCH', Auction.buildSearchParams())
end

function Auction.updateCategoryUI()
  local cats = { 'all', 'weapons', 'armors', 'shields', 'boots', 'helmet', 'accessories', 'runes', 'pets', 'consumables', 'materials', 'others' }
  local ids = { 'catAll', 'catWeapons', 'catArmor', 'catShields', 'catBoots', 'catHelmet', 'catAccessories', 'catRunes', 'catPets', 'catConsumables', 'catMaterials', 'catOthers' }
  for i, c in ipairs(cats) do
    local btn = Auction[ids[i]]
    if btn and btn.setColor and btn.setBackgroundColor then
      local active = (Auction.currentCategory == c)
      -- weapons subcategories keep the main Weapons button highlighted
      if c == 'weapons' and Auction.currentCategory and Auction.currentCategory:match('^weapons_') then
        active = true
      end
      -- consumables subcategories keep the main Consumables button highlighted
      if c == 'consumables' and Auction.currentCategory and Auction.currentCategory:match('^consumables_') then
        active = true
      end
      if active then
        btn:setColor('#f5c542')
        btn:setBackgroundColor('#2a2a3a')
      else
        btn:setColor('#cccccc')
        btn:setBackgroundColor('#1a1a24')
      end
    end
  end
end

function Auction.updateSubcategoryUI()
  -- Weapons subcategory panel
  local isWeaponSub = Auction.currentCategory and Auction.currentCategory:match('^weapons_') ~= nil
  local showWeapons = Auction.weaponsExpanded or isWeaponSub
  if Auction.subcategoryPanel and Auction.subcategoryPanel.setVisible then
    Auction.subcategoryPanel:setVisible(showWeapons)
  end
  if Auction.subcategoryPanel and Auction.subcategoryPanel.setHeight then
    Auction.subcategoryPanel:setHeight(showWeapons and 110 or 0)
  end

  -- Consumables subcategory panel
  local isConsumablesSub = Auction.currentCategory and Auction.currentCategory:match('^consumables_') ~= nil
  local showConsumables = Auction.consumablesExpanded or isConsumablesSub
  if Auction.consumablesSubcategoryPanel and Auction.consumablesSubcategoryPanel.setVisible then
    Auction.consumablesSubcategoryPanel:setVisible(showConsumables)
  end
  if Auction.consumablesSubcategoryPanel and Auction.consumablesSubcategoryPanel.setHeight then
    Auction.consumablesSubcategoryPanel:setHeight(showConsumables and 64 or 0)
  end

  local weaponSubMap = {
    ['weapons_onehand'] = 'subOneHand',
    ['weapons_twohand'] = 'subTwoHand',
    ['weapons_distance'] = 'subDistance',
    ['weapons_wands'] = 'subWands',
    ['weapons_shield'] = 'subShields'
  }
  for key, id in pairs(weaponSubMap) do
    local btn = Auction[id]
    if btn and btn.setColor and btn.setBackgroundColor then
      if Auction.currentCategory == key then
        btn:setColor('#f5c542')
        btn:setBackgroundColor('#2a2a3a')
      else
        btn:setColor('#aaaaaa')
        btn:setBackgroundColor('#14141c')
      end
    end
  end

  local consumablesSubMap = {
    ['consumables_potions'] = 'subPotions',
    ['consumables_flasks'] = 'subFlasks',
    ['consumables_elixirs'] = 'subElixirs'
  }
  for key, id in pairs(consumablesSubMap) do
    local btn = Auction[id]
    if btn and btn.setColor and btn.setBackgroundColor then
      if Auction.currentCategory == key then
        btn:setColor('#f5c542')
        btn:setBackgroundColor('#2a2a3a')
      else
        btn:setColor('#aaaaaa')
        btn:setBackgroundColor('#14141c')
      end
    end
  end
end

function Auction.onFilterChange()
  if Auction.activeTab ~= 'auction' then return end
  local cat = getSelectedCategory()
  if cat == Auction.currentCategory then return end
  Auction.currentCategory = cat
  Auction.updateCategoryUI()
  Auction.searchOffset = 0
  Auction.updatePageLabel()
  Auction.clearBrowseWithLoading()
  Auction.send('AH_SEARCH', Auction.buildSearchParams())
end

function Auction.clearBrowseWithLoading()
  if not Auction.browseList then return end
  Auction.browseList:destroyChildren()
  local loading = g_ui.createWidget('UILabel', Auction.browseList)
  loading:setText('Loading...')
  loading:setPhantom(true)
  loading:setColor('#bbbbbb')
  loading:setMarginTop(8)
  loading:setMarginLeft(8)
  loading:setWidth(100)
  loading:setHeight(16)
  -- also reset selection and buttons
  Auction.selectedId = nil
  if Auction.buyButton and Auction.buyButton.setEnabled then Auction.buyButton:setEnabled(false) end
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
    Auction.send('AH_SEARCH', Auction.buildSearchParams(term))
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
  local desired = 1
  if Auction.buyCountSpin and Auction.buyCountSpin.getValue then
    desired = tonumber(Auction.buyCountSpin:getValue()) or 1
  end
  local full = tonumber(Auction.currentSelected and Auction.currentSelected.count or 1) or 1
  if desired < full then
    Auction.send('AH_BUY_PART', { id = Auction.selectedId, count = desired })
  else
    Auction.send('AH_BUY', { id = Auction.selectedId })
  end
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
  local reward = 'gold'
  if Auction.rewardGroup and Auction.rewardGroup.getSelectedWidget then
    local sel = Auction.rewardGroup:getSelectedWidget()
    if sel and sel.getId and sel:getId() == 'rewardFame' then reward = 'fame' end
  end
  local duration = 24
  if Auction.durationGroup and Auction.durationGroup.getSelectedWidget then
    local sel = Auction.durationGroup:getSelectedWidget()
    if sel and sel.getId then
      local id = sel:getId()
      if id == 'dur12' then duration = 12 elseif id == 'dur48' then duration = 48 end
    end
  end
  print(string.format('[Auction][Client] Sending AH_LIST pos=(%s,%s,%s) clientCid=%s count=%s totalPrice=%s reward=%s duration=%s', tostring(pos.x), tostring(pos.y), tostring(pos.z), tostring(cid), tostring(count), tostring(totalPrice), tostring(reward), tostring(duration)))
  Auction.send('AH_LIST', { pos = { x = pos.x, y = pos.y, z = pos.z }, cid = cid, count = count, price = totalPrice, reward = reward, duration = duration })
end
