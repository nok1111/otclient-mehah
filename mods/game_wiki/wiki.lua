-- coding: utf-8
-- Wiki Module
-- In-game knowledge base with search and categories

wikiWindow = nil
wikiButton = nil
currentLanguage = 'en'
currentCategory = nil
currentSubCategory = nil

-- Sidebar order for categories (by importance/context). Unknown keys go last,
-- alphabetically. Subcategories honor an optional `order` field, then name.
local WIKI_CATEGORY_ORDER = {
  'ascension_guide',   -- First steps, talents, paragon, codex
  'tasks', 'daily_tasks',
  'currencies',
  'items', 'item_upgrades', 'proficiency', 'crafting',
  'monster_orbs', 'zones', 'dungeons',
  'codex',
  'pets', 'achievements',
  'prestige',
}

-- Sidebar icon per category. Gold-monochrome PNGs generated offline into
-- data/images/wiki/caticons/ ('<name>_hot.png' = brighter variant for
-- hover/selected states).
local WIKI_CATEGORY_ICONS = {
  ascension_guide = 'ascension_guide',
  tasks           = 'tasks',
  daily_tasks     = 'daily_tasks',
  currencies      = 'currencies',
  items           = 'items',
  item_upgrades   = 'item_upgrades',
  proficiency     = 'proficiency',
  crafting        = 'crafting',
  monster_orbs    = 'monster_orbs',
  zones           = 'zones',
  dungeons        = 'dungeons',
  pets            = 'pets',
  achievements    = 'achievements',
  prestige        = 'prestige',
  codex           = 'codex',
}

local function wikiCatIcon(categoryName, hot)
  local base = WIKI_CATEGORY_ICONS[categoryName]
  if not base then return nil end
  return '/images/wiki/caticons/' .. base .. (hot and '_hot' or '') .. '.png'
end

local function wikiSortedKeys(tbl, orderList)
  local keys, seen, rest = {}, {}, {}
  for _, k in ipairs(orderList or {}) do
    if tbl[k] and not seen[k] then keys[#keys + 1] = k; seen[k] = true end
  end
  for k in pairs(tbl) do
    if not seen[k] then rest[#rest + 1] = k end
  end
  table.sort(rest, function(a, b) return (tbl[a].name or a) < (tbl[b].name or b) end)
  for _, k in ipairs(rest) do keys[#keys + 1] = k end
  return keys
end

local WIKI_ACCENT = '#ffd75e'

-- Converts wiki markup into [color] spans understood by UIWidget:parseColoredText.
--   **text**                   -> accent-colored inline highlight
--   [color=#rrggbb]...[/color] -> passed through as-is
local function wikiMarkupToColored(text)
  local t = text or ''
  t = t:gsub('%*%*(.-)%*%*', '[color=' .. WIKI_ACCENT .. ']%1[/color]')
  -- bullet lists: "- item" at line start -> gold bullet marker
  t = ('\n' .. t):gsub('\n%s*%-%s+', '\n[color=#d4a843]•[/color]  ')
  t = t:sub(2)
  return t
end

local function wikiColoredLabel(style, parent, text, defaultColor)
  local widget = g_ui.createWidget(style, parent)
  widget:parseColoredText(wikiMarkupToColored(text), defaultColor or '#dfdfdf')
  return widget
end

local function wikiAutoHeight(widget, label, minHeight, padding)
  scheduleEvent(function()
    if widget and not widget:isDestroyed() then
      widget:setHeight(math.max(minHeight, label:getTextSize().height + padding))
    end
  end, 0)
end

-- Convert a server item id to the client id expected by Item:setItemId.
-- Map generated from data/items/items.otb (item_client_ids.lua).
local function wikiClientItemId(serverId)
  return (WikiItemClientIds and WikiItemClientIds[serverId]) or serverId
end

local function wikiAddCard(parent, card)
  local widget = g_ui.createWidget('WikiRichCard', parent)
  if card.icon then
    widget:getChildById('icon'):setItemId(wikiClientItemId(card.icon))
  elseif card.image then
    widget:getChildById('icon'):hide()
    local img = widget:getChildById('imageIcon')
    img:setImageSource(card.image)
    img:show()
  end
  local nameWidget = widget:getChildById('name')
  nameWidget:parseColoredText(wikiMarkupToColored(card.name or ''), card.color or '#ffcc00')
  local descWidget = widget:getChildById('description')
  descWidget:parseColoredText(wikiMarkupToColored(card.description or ''), card.descColor or '#cccccc')
  wikiAutoHeight(widget, descWidget, 58, 8 + 14 + 2 + 10)
  return widget
end

local function wikiAddNoteBox(parent, section, style)
  local widget = g_ui.createWidget(style, parent)
  local label = widget:getChildById('text')
  label:parseColoredText(wikiMarkupToColored(section.content or ''), section.color or '#dfdfdf')
  wikiAutoHeight(widget, label, 40, 24)
  return widget
end

function init()
  connect(g_game, { onGameStart = online, onGameEnd = offline })
  
  g_keyboard.bindKeyDown('Ctrl+H', toggle)
  
  if g_game.isOnline() then
    online()
  end
end

function terminate()
  
  disconnect(g_game, { onGameStart = online, onGameEnd = offline })
  g_keyboard.unbindKeyDown('Ctrl+H')
  
  -- Clean up if still online
  offline()
  
end

function online()
  
  -- Load UI first
  if not wikiWindow then
    wikiWindow = g_ui.displayUI('wiki')
    
    if wikiWindow then
      wikiWindow:hide()
    else
      return
    end
  end
  
  -- Create button when entering game
  if not wikiButton then
    if modules.game_mainpanel then
      wikiButton = modules.game_mainpanel.addToggleButton('wikiButton', 
        tr('Wiki'), '/images/options/button_options', toggle, false, 14)
      wikiButton:setOn(false)
    else
    end
  else
  end
  
  -- Load wiki data when player connects
  loadWikiData()
end

function offline()
  
  if wikiWindow then
    wikiWindow:destroy()
    wikiWindow = nil
  end
  
  if wikiButton then
    wikiButton:destroy()
    wikiButton = nil
  end
end

function toggle()
  if not wikiButton then
    show()
    return
  end
  
  if wikiButton:isOn() then
    hide()
  else
    show()
  end
end

function show()
  if not wikiWindow then
    return
  end
  
  
  -- Populate content on first show
  if not wikiWindow.initialized then
    populateCategories()
    updateLanguageLabel()
    wikiWindow.initialized = true
  end
  
  wikiWindow:show()
  wikiWindow:raise()
  wikiWindow:focus()
  
  if wikiButton then
    wikiButton:setOn(true)
  end
end

function hide()
  if wikiWindow then
    wikiWindow:hide()
  end
  
  if wikiButton then
    wikiButton:setOn(false)
  end
end

function loadWikiData()
  -- Load wiki content based on current language
  WikiData = getWikiData(currentLanguage)
end

function populateCategories()
  local categoryList = wikiWindow:recursiveGetChildById('categoryList')
  categoryList:destroyChildren()
  
  if not WikiData then
    loadWikiData()
  end
  
  for _, categoryName in ipairs(wikiSortedKeys(WikiData.categories, WIKI_CATEGORY_ORDER)) do
    local categoryData = WikiData.categories[categoryName]
    local categoryWidget = g_ui.createWidget('WikiCategoryItem', categoryList)
    categoryWidget:setId(categoryName)

    local iconWidget = categoryWidget:getChildById('iconWidget')
    local iconSrc = wikiCatIcon(categoryName, false)
    if iconWidget and iconSrc then
      iconWidget:setImageSource(iconSrc)
    end

    local label = categoryWidget:getChildById('label')
    if label then label:setText(categoryData.name) end

    categoryWidget.onClick = function()
      selectCategory(categoryName)
    end
    categoryWidget.onHoverChange = function(self, hovered)
      if not self:isOn() then
        if label then label:setColor(hovered and '#ffffff' or '#dfdfdf') end
        if iconWidget then iconWidget:setImageSource(wikiCatIcon(categoryName, hovered) or '') end
      end
    end
  end

  -- Open the first category so the window never starts empty
  if not currentCategory then
    local first = wikiSortedKeys(WikiData.categories, WIKI_CATEGORY_ORDER)[1]
    if first then selectCategory(first) end
  end
end

function selectCategory(categoryName)
  currentCategory = categoryName
  currentSubCategory = nil
  
  local subCategoryList = wikiWindow:recursiveGetChildById('subCategoryList')
  subCategoryList:destroyChildren()
  
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')
  contentPanel:destroyChildren()
  
  local categoryData = WikiData.categories[categoryName]
  if not categoryData then return end
  
  -- Show subcategories (sorted by optional `order`, then name)
  local subKeys = {}
  for k in pairs(categoryData.subcategories) do subKeys[#subKeys + 1] = k end
  table.sort(subKeys, function(a, b)
    local sa, sb = categoryData.subcategories[a], categoryData.subcategories[b]
    local oa, ob = sa.order or 999, sb.order or 999
    if oa ~= ob then return oa < ob end
    return (sa.name or a) < (sb.name or b)
  end)

  for _, subCatName in ipairs(subKeys) do
    local subCatData = categoryData.subcategories[subCatName]
    local subCatWidget = g_ui.createWidget('WikiSubCategoryItem', subCategoryList)
    subCatWidget:setText(subCatData.name)
    subCatWidget:setId(subCatName)

    subCatWidget.onClick = function()
      selectSubCategory(categoryName, subCatName)
    end
  end

  -- Highlight selected category
  highlightSelectedCategory(categoryName)

  -- Show the first subcategory page right away
  if subKeys[1] then
    selectSubCategory(categoryName, subKeys[1])
  end
end

function selectSubCategory(categoryName, subCategoryName)
  currentSubCategory = subCategoryName
  
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')
  contentPanel:destroyChildren()
  
  local subCatData = WikiData.categories[categoryName].subcategories[subCategoryName]
  if not subCatData then return end

  -- rich_text pages carry their own title; other types get one generated
  if subCatData.type ~= 'rich_text' then
    wikiColoredLabel('WikiRichTitle', contentPanel, subCatData.name)
    g_ui.createWidget('WikiRichDivider', contentPanel)
  end

  -- Display content based on subcategory type
  if subCatData.type == 'list' then
    displayListContent(subCatData.items)
  elseif subCatData.type == 'pets' then
    displayPetsContent(subCatData.items)
  elseif subCatData.type == 'rich_text' then
    displayRichTextContent(subCatData.sections)
  else
    displayTextContent(subCatData.content)
  end
  
  -- Highlight selected subcategory
  highlightSelectedSubCategory(subCategoryName)

  -- Track reading progress for the footer bar
  if WikiData.categories[categoryName] then
    g_settings.set('wiki_read_' .. currentLanguage .. '_' .. categoryName .. '_' .. subCategoryName, true)
    updateProgressLabel()
  end
end

function updateProgressLabel()
  local label = wikiWindow and wikiWindow:recursiveGetChildById('progressLabel')
  if not label or not WikiData then return end

  local total, read = 0, 0
  for catName, catData in pairs(WikiData.categories) do
    for subName in pairs(catData.subcategories or {}) do
      total = total + 1
      if g_settings.getBoolean('wiki_read_' .. currentLanguage .. '_' .. catName .. '_' .. subName) then
        read = read + 1
      end
    end
  end
  if total > 0 then
    local pct = math.floor(read / total * 100)
    label:setText(tr('Wiki progress'))
    local percentLabel = wikiWindow:recursiveGetChildById('percentLabel')
    if percentLabel then percentLabel:setText(tr('%d%% COMPLETE', pct)) end
    local bar = wikiWindow:recursiveGetChildById('progressBar')
    if bar then bar:setPercent(pct) end
  end
end

function displayListContent(items)
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')

  for _, item in ipairs(items) do
    local itemWidget = g_ui.createWidget('WikiListItem', contentPanel)
    itemWidget:getChildById('name'):setText(item.name)
    local descWidget = itemWidget:getChildById('description')
    descWidget:setText(item.description or '')

    if item.icon then
      itemWidget:getChildById('icon'):setItemId(wikiClientItemId(item.icon))
    elseif item.image then
      itemWidget:getChildById('icon'):hide()
      local img = itemWidget:getChildById('imageIcon')
      img:setImageSource(item.image)
      img:show()
    end

    -- Adjust height to fit wrapped description text
    scheduleEvent(function()
      if itemWidget and not itemWidget:isDestroyed() then
        local textSize = descWidget:getTextSize()
        local nameWidget = itemWidget:getChildById('name')
        local newHeight = math.max(60, 8 + nameWidget:getHeight() + 2 + textSize.height + 10)
        itemWidget:setHeight(newHeight)
      end
    end, 0)
  end
end

function displayPetsContent(pets)
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')
  
  for _, pet in ipairs(pets) do
    local petWidget = g_ui.createWidget('WikiPetItem', contentPanel)
    
    -- Set creature outfit visual
    if pet.outfitId and pet.outfitId > 0 then
      local petOutfit = petWidget:getChildById('petOutfit')
      if petOutfit then
        local outfit = { type = pet.outfitId }
        petOutfit:setOutfit(outfit)
      end
    end
    
    petWidget:getChildById('petName'):setText(pet.name)
    
    -- Color code rarity
    local rarityLabel = petWidget:getChildById('petRarity')
    rarityLabel:setText('Rarity: ' .. pet.rarity)
    if pet.rarity == 'Epic' then
      rarityLabel:setColor('#ff00ff')
    elseif pet.rarity == 'Rare' then
      rarityLabel:setColor('#0099ff')
    elseif pet.rarity == 'Uncommon' then
      rarityLabel:setColor('#00ff00')
    else
      rarityLabel:setColor('#aaaaaa')
    end
    
    -- Show element with color
    if pet.element then
      local elementLabel = petWidget:getChildById('petElement')
      elementLabel:setText('Element: ' .. pet.element)
      -- Color based on element type
      if pet.element:find('Fire') then
        elementLabel:setColor('#ff6600')
      elseif pet.element:find('Ice') then
        elementLabel:setColor('#00ccff')
      elseif pet.element:find('Death') then
        elementLabel:setColor('#cc00cc')
      elseif pet.element:find('Holy') then
        elementLabel:setColor('#ffff00')
      elseif pet.element:find('Energy') then
        elementLabel:setColor('#cc00ff')
      elseif pet.element:find('Poison') then
        elementLabel:setColor('#00ff00')
      elseif pet.element:find('Earth') then
        elementLabel:setColor('#996633')
      else
        elementLabel:setColor('#ffaa55')
      end
    end
    
    petWidget:getChildById('petCollector'):setText('Collector: ' .. pet.collector)
    
    -- Abilities
    local abilitiesText = ''
    for i, ability in ipairs(pet.abilities) do
      abilitiesText = abilitiesText .. '• ' .. ability.name .. ': ' .. ability.description
      if i < #pet.abilities then
        abilitiesText = abilitiesText .. '\n'
      end
    end
    petWidget:getChildById('petAbilities'):setText(abilitiesText)
  end
end

function displayTextContent(content)
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')
  wikiColoredLabel('WikiRichColoredText', contentPanel, content)
end

function displayRichTextContent(sections)
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')

  if not sections then return end

  for _, section in ipairs(sections) do
    if section.type == 'text' then
      wikiColoredLabel('WikiRichColoredText', contentPanel, section.content, section.color)
    elseif section.type == 'title' then
      wikiColoredLabel('WikiRichTitle', contentPanel, section.text, section.color)
    elseif section.type == 'subtitle' then
      wikiColoredLabel('WikiRichSubtitle', contentPanel, section.text, section.color)
    elseif section.type == 'card' then
      wikiAddCard(contentPanel, section)
    elseif section.type == 'cards' then
      for _, card in ipairs(section.items or {}) do
        wikiAddCard(contentPanel, card)
      end
    elseif section.type == 'tip' then
      wikiAddNoteBox(contentPanel, section, 'WikiRichTip')
    elseif section.type == 'warning' then
      wikiAddNoteBox(contentPanel, section, 'WikiRichWarn')
    elseif section.type == 'divider' then
      g_ui.createWidget('WikiRichDivider', contentPanel)
    elseif section.type == 'image' then
      local imgWidget = g_ui.createWidget('WikiRichImage', contentPanel)
      imgWidget:setImageSource(section.path or '')
      if section.width and section.height then
        imgWidget:setSize({ width = section.width, height = section.height })
      end
    elseif section.type == 'spacer' then
      local spacer = g_ui.createWidget('WikiRichSpacer', contentPanel)
      if section.height then
        spacer:setHeight(section.height)
      end
    end
  end
end

function onSearchTextChange()
  local searchEdit = wikiWindow:recursiveGetChildById('searchEdit')
  local searchText = searchEdit:getText():lower()
  
  if searchText == '' then
    -- Clear search, show normal view
    if currentCategory then
      selectCategory(currentCategory)
    end
    return
  end
  
  -- Search through all categories and subcategories
  local results = searchWiki(searchText)
  displaySearchResults(results)
end

function searchWiki(query)
  local results = {}
  
  for categoryName, categoryData in pairs(WikiData.categories) do
    for subCatName, subCatData in pairs(categoryData.subcategories) do
      -- Search in subcategory name
      if subCatData.name:lower():find(query) then
        table.insert(results, {
          category = categoryData.name,
          subcategory = subCatData.name,
          data = subCatData
        })
      end
      
      -- Search in items
      if subCatData.items then
        for _, item in ipairs(subCatData.items) do
          if item.name:lower():find(query) or 
             (item.description and item.description:lower():find(query)) then
            table.insert(results, {
              category = categoryData.name,
              subcategory = subCatData.name,
              item = item,
              data = subCatData
            })
          end
        end
      end
    end
  end
  
  return results
end

function displaySearchResults(results)
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')
  contentPanel:destroyChildren()
  
  if #results == 0 then
    local noResults = g_ui.createWidget('Label', contentPanel)
    noResults:setText('No results found')
    noResults:setTextAlign(AlignCenter)
    return
  end
  
  for _, result in ipairs(results) do
    local resultWidget = g_ui.createWidget('WikiSearchResult', contentPanel)
    resultWidget:getChildById('resultCategory'):setText(result.category .. ' > ' .. result.subcategory)
    
    if result.item then
      resultWidget:getChildById('resultName'):setText(result.item.name)
      resultWidget:getChildById('resultDesc'):setText(result.item.description or '')
    else
      resultWidget:getChildById('resultName'):setText(result.subcategory)
      resultWidget:getChildById('resultDesc'):setText('Click to view')
    end
    
    resultWidget.onClick = function()
      -- Navigate to this result
      for catKey, catData in pairs(WikiData.categories) do
        if catData.name == result.category then
          selectCategory(catKey)
          for subKey, subData in pairs(catData.subcategories) do
            if subData.name == result.subcategory then
              selectSubCategory(catKey, subKey)
              break
            end
          end
          break
        end
      end
    end
  end
end

function changeLanguage()
  -- Toggle between languages
  if currentLanguage == 'en' then
    currentLanguage = 'es'
  else
    currentLanguage = 'en'
  end
  
  loadWikiData()
  updateLanguageLabel()
  
  -- Refresh current view
  if wikiWindow and wikiWindow:isVisible() then
    populateCategories()
    if currentCategory then
      selectCategory(currentCategory)
      if currentSubCategory then
        selectSubCategory(currentCategory, currentSubCategory)
      end
    end
  end
end

function updateLanguageLabel()
  if wikiWindow then
    local langButton = wikiWindow:recursiveGetChildById('languageButton')
    if langButton then
      langButton:setText(currentLanguage:upper() .. ' ▾')
    end
  end
end

function highlightSelectedCategory(categoryName)
  local categoryList = wikiWindow:recursiveGetChildById('categoryList')
  for _, widget in ipairs(categoryList:getChildren()) do
    local on = widget:getId() == categoryName
    widget:setOn(on)
    local label = widget:getChildById('label')
    if label then label:setColor(on and '#ffd75e' or '#dfdfdf') end
    local iconWidget = widget:getChildById('iconWidget')
    local src = wikiCatIcon(widget:getId(), on)
    if iconWidget and src then iconWidget:setImageSource(src) end
  end
end

function highlightSelectedSubCategory(subCategoryName)
  local subCategoryList = wikiWindow:recursiveGetChildById('subCategoryList')
  for _, widget in ipairs(subCategoryList:getChildren()) do
    if widget:getId() == subCategoryName then
      widget:setOn(true)
    else
      widget:setOn(false)
    end
  end
end
