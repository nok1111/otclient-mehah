-- Wiki Module
-- In-game knowledge base with search and categories

wikiWindow = nil
wikiButton = nil
currentLanguage = 'en'
currentCategory = nil
currentSubCategory = nil

function init()
  print("[Wiki] Module initializing...")
  connect(g_game, { onGameStart = online, onGameEnd = offline })
  
  g_keyboard.bindKeyDown('Ctrl+H', toggle)
  
  if g_game.isOnline() then
    online()
  end
  print("[Wiki] Module initialized successfully")
end

function terminate()
  print("[Wiki] Module terminating...")
  
  disconnect(g_game, { onGameStart = online, onGameEnd = offline })
  g_keyboard.unbindKeyDown('Ctrl+H')
  
  -- Clean up if still online
  offline()
  
  print("[Wiki] Module terminated")
end

function online()
  print("[Wiki] online() called")
  
  -- Load UI first
  if not wikiWindow then
    print("[Wiki] Loading wiki UI...")
    wikiWindow = g_ui.displayUI('wiki')
    
    if wikiWindow then
      print("[Wiki] UI loaded successfully")
      wikiWindow:hide()
    else
      print("[Wiki] ERROR: Failed to load wiki.otui")
      return
    end
  end
  
  -- Create button when entering game
  if not wikiButton then
    if modules.game_mainpanel then
      print("[Wiki] Creating wiki button...")
      wikiButton = modules.game_mainpanel.addToggleButton('wikiButton', 
        tr('Wiki'), '/images/options/button_options', toggle, false, 15)
      wikiButton:setOn(false)
      print("[Wiki] Wiki button created successfully")
    else
      print("[Wiki] ERROR: game_mainpanel not available")
    end
  else
    print("[Wiki] Button already exists")
  end
  
  -- Load wiki data when player connects
  loadWikiData()
end

function offline()
  print("[Wiki] offline() called - cleaning up")
  
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
    print("[Wiki] ERROR: wikiWindow not loaded yet")
    return
  end
  
  print("[Wiki] Showing wiki window")
  
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
  
  for categoryName, categoryData in pairs(WikiData.categories) do
    local categoryWidget = g_ui.createWidget('WikiCategoryItem', categoryList)
    categoryWidget:setText(categoryData.name)
    categoryWidget:setId(categoryName)
    
    categoryWidget.onClick = function()
      selectCategory(categoryName)
    end
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
  
  -- Show subcategories
  for subCatName, subCatData in pairs(categoryData.subcategories) do
    local subCatWidget = g_ui.createWidget('WikiSubCategoryItem', subCategoryList)
    subCatWidget:setText(subCatData.name)
    subCatWidget:setId(subCatName)
    
    subCatWidget.onClick = function()
      selectSubCategory(categoryName, subCatName)
    end
  end
  
  -- Highlight selected category
  highlightSelectedCategory(categoryName)
end

function selectSubCategory(categoryName, subCategoryName)
  currentSubCategory = subCategoryName
  
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')
  contentPanel:destroyChildren()
  
  local subCatData = WikiData.categories[categoryName].subcategories[subCategoryName]
  if not subCatData then return end
  
  -- Display content based on subcategory type
  if subCatData.type == 'list' then
    displayListContent(subCatData.items)
  elseif subCatData.type == 'pets' then
    displayPetsContent(subCatData.items)
  elseif subCatData.type == 'enchants' then
    displayEnchantsContent(subCatData.items)
  else
    displayTextContent(subCatData.content)
  end
  
  -- Highlight selected subcategory
  highlightSelectedSubCategory(subCategoryName)
end

function displayListContent(items)
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')
  
  for _, item in ipairs(items) do
    local itemWidget = g_ui.createWidget('WikiListItem', contentPanel)
    itemWidget:getChildById('name'):setText(item.name)
    itemWidget:getChildById('description'):setText(item.description or '')
    
    if item.icon then
      itemWidget:getChildById('icon'):setItemId(item.icon)
    end
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

function displayEnchantsContent(enchants)
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')
  
  for _, enchant in ipairs(enchants) do
    local enchantWidget = g_ui.createWidget('WikiEnchantItem', contentPanel)
    
    enchantWidget:getChildById('name'):setText(enchant.name)
    enchantWidget:getChildById('description'):setText(enchant.description or '')
    enchantWidget:getChildById('enchantType'):setText('Type: ' .. enchant.enchantType)
    enchantWidget:getChildById('valuesPerLevel'):setText('Values: ' .. enchant.valuesPerLevel)
    enchantWidget:getChildById('minLevel'):setText('Min Level: ' .. enchant.minLevel)
    enchantWidget:getChildById('equipment'):setText('Equipment: ' .. enchant.equipment)
    
    -- Icon is now a static PNG image defined in OTUI, no need to set it per item
  end
end

function displayTextContent(content)
  local contentPanel = wikiWindow:recursiveGetChildById('contentPanel')
  
  local textWidget = g_ui.createWidget('WikiTextContent', contentPanel)
  textWidget:setText(content)
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
      langButton:setText(currentLanguage:upper())
    end
  end
end

function highlightSelectedCategory(categoryName)
  local categoryList = wikiWindow:recursiveGetChildById('categoryList')
  for _, widget in ipairs(categoryList:getChildren()) do
    if widget:getId() == categoryName then
      widget:setOn(true)
    else
      widget:setOn(false)
    end
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
