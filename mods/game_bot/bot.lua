-- Simplified Bot Module
-- Version 2.0 by nok1111
-- All-in-one: Bot logic + UI in single file

botButton = nil
botMainLoop = nil
botWindow = nil
contentsPanel = nil
enableButton = nil
statusLabel = nil
botTabs = nil

-- Bot panels
local combatPanel = nil
local healingPanel = nil
local supportPanel = nil

-- Setup flags to prevent multiple setups
local combatSetup = false
local healingSetup = false
local supportSetup = false
local needsUIRefresh = false  -- Flag to track when storage is loaded and UI needs update

-- SimplifiedBot (integrated from bot_simple.lua)
SimplifiedBot = {}
local botEnabled = false
local storage = {}
local storageFile = nil

-- Combat state
local lastAttackSpell = 1
local currentTarget = nil

-- Healing state
local lastHealTime = 0
local healCooldown = 1000

-- Support state
local lastSupport1 = 0
local lastSupport2 = 0
local lastEat = 0

-- Potion item selection
local mouseGrabberWidget = nil
local potionTypeToSet = nil  -- 'health' or 'mana'

-- Export for UI access
modules.game_bot = modules.game_bot or {}
modules.game_bot.botMainLoop = nil

function onMiniWindowClose()
  if botButton then botButton:setOn(false) end
end

function startChoosePotionItem(potionType)
  if g_ui.isMouseGrabbed() then
    return
  end
  potionTypeToSet = potionType
  mouseGrabberWidget:grabMouse()
  g_mouse.pushCursor('target')
  print("[Bot] Crosshair active - click on", potionType, "potion item")
end

function onChoosePotionItemRelease(self, mousePosition, mouseButton)
  local item = nil
  if mouseButton == MouseLeftButton then
    local clickedWidget = modules.game_interface.getRootPanel():recursiveGetChildByPos(mousePosition, false)
    if clickedWidget then
      if clickedWidget:getClassName() == 'UIItem' and not clickedWidget:isVirtual() then
        item = clickedWidget:getItem()
      end
    end
  end

  if item and item:getPosition().x == 65535 and potionTypeToSet then
    local itemId = item:getId()
    print("[Bot] Selected item ID:", itemId, "for", potionTypeToSet)
    
    if potionTypeToSet == 'health' then
      storage.healing.healthPotion.itemId = itemId
      local healthPotionButton = healingPanel:recursiveGetChildById('healthPotionButton')
      if healthPotionButton then
        healthPotionButton:setText(tostring(itemId))
      end
    elseif potionTypeToSet == 'mana' then
      storage.healing.manaPotion.itemId = itemId
      local manaPotionButton = healingPanel:recursiveGetChildById('manaPotionButton')
      if manaPotionButton then
        manaPotionButton:setText(tostring(itemId))
      end
    elseif potionTypeToSet == 'food' then
      storage.support.autoEat.itemId = itemId
      local autoEatButton = supportPanel:recursiveGetChildById('autoEatButton')
      if autoEatButton then
        autoEatButton:setText(tostring(itemId))
      end
    end
    
    SimplifiedBot.saveStorage()
    potionTypeToSet = nil
  end
  
  g_mouse.popCursor('target')
  self:ungrabMouse()
  return true
end

function debugInput()
  print("[DEBUG] Setting up input debugging...")
  
  connect(g_keyboard, {
    onKeyPress = function(keyCode, keyboardModifiers)
      print("[DEBUG] g_keyboard Key pressed:", keyCode, "Modifiers:", keyboardModifiers)
      return false
    end
  })
  
  local rootWidget = modules.game_interface.getRootPanel()
  if rootWidget then
    connect(rootWidget, {
      onKeyPress = function(self, keyCode, keyboardModifiers)
        print("[DEBUG] Root widget key pressed:", keyCode)
        return false
      end
    })
    print("[DEBUG] Root widget connected")
  else
    print("[DEBUG] WARNING: rootWidget not found")
  end
  
  print("[DEBUG] Input debugging active")
end

function init()
  print("[Bot] Module initializing...")
  
  -- TEMPORARY: Debug input
  debugInput()
  
  -- Storage will be initialized when character logs in (onlineSimple)
  print("[Bot] Module loaded, waiting for character login...")
  
  -- STEP 3: Create UI (like original mehah)
  if modules.game_interface then
    print("[Bot] Creating bot UI...")
    status, err = pcall(function()
      -- Import UI styles first
      g_ui.importStyle('ui/basic')
      
      botWindow = g_ui.loadUI('bot', modules.game_interface.getLeftPanel())
      if not botWindow then
        error("Failed to load bot.otui")
      end
      botWindow:hide()
      
      -- Create mouse grabber widget for item selection
      mouseGrabberWidget = g_ui.createWidget('UIWidget')
      mouseGrabberWidget:setVisible(false)
      mouseGrabberWidget:setFocusable(false)
      mouseGrabberWidget.onMouseRelease = onChoosePotionItemRelease
      
      -- Connect keyboard to botWindow for TextEdit input
      connect(botWindow, {
        onKeyPress = function(self, keyCode, keyboardModifiers)
          return false -- Propagate event to children
        end
      })
      
      -- Get UI components
      contentsPanel = botWindow.contentsPanel
      enableButton = contentsPanel.enableButton
      statusLabel = contentsPanel.statusLabel
      botTabs = contentsPanel.tabButtonsPanel
      
      -- Setup enable button
      enableButton.onClick = function()
        if SimplifiedBot.isEnabled() then
          SimplifiedBot.setOff()
          if botMainLoop then botMainLoop.setOff() end
          enableButton:setOn(false)
          statusLabel:setText('Status: Stopped')
        else
          SimplifiedBot.setOn()
          if botMainLoop then botMainLoop.setOn() end
          enableButton:setOn(true)
          statusLabel:setText('Status: Running')
        end
      end
      
      -- Initialize tabs (storage is ready now)
      print("[Bot] Initializing UI tabs...")
      local uiSuccess = initTabs()
      if not uiSuccess then
        error("initTabs() failed")
      end
    end)
    
    if not status then
      print("[Bot] ERROR creating UI: " .. tostring(err))
      return
    end
    print("[Bot] UI created successfully with tabs")
  end
  
  -- STEP 5: Connect game events
  print("[Bot] Connecting game events...")
  connect(g_game, {
    onGameStart = onlineSimple,
    onGameEnd = offlineSimple,
  })
  print("[Bot] Game events connected")
  
  if g_game.isOnline() then
    print("[Bot] Player is already online, calling onlineSimple()...")
    local success, error = pcall(onlineSimple)
    if not success then
      print("[Bot] ERROR in onlineSimple: " .. tostring(error))
    end
  end
  
  print("[Bot] Module initialized successfully")
end

function terminate()
  print("[Bot] Module terminating...")
  
  disconnect(g_keyboard)
  
  disconnect(g_game, {
    onGameStart = onlineSimple,
    onGameEnd = offlineSimple,
  })
  
  -- Clean up panels
  combatPanel = nil
  healingPanel = nil
  supportPanel = nil
  
  if SimplifiedBot and SimplifiedBot.terminate then
    SimplifiedBot.terminate()
  end
  
  if botMainLoop then
    botMainLoop.setOff()
  end

  if botButton then
    botButton:destroy()
    botButton = nil
  end
  
  print("[Bot] Module terminated successfully")
end

function toggleSimple()
  print("[Bot] toggleSimple() called")
  
  if not botWindow then
    print("[Bot] ERROR: botWindow not created")
    return
  end
  
  -- Toggle window visibility
  if botWindow:isVisible() then
    botWindow:hide()
    if botButton then botButton:setOn(false) end
  else
    botWindow:show()
    botWindow:raise()
    botWindow:focus()
    if botButton then botButton:setOn(true) end
    modules.game_interface.checkAndOpenLeftPanel()
    
    -- If storage was loaded and UI needs refresh, force setup of all panels
    if needsUIRefresh then
      print("[Bot] Refreshing UI with loaded storage...")
      
      -- Reset all setup flags
      combatSetup = false
      healingSetup = false
      supportSetup = false
      
      -- Force refresh of visible panel after a delay
      scheduleEvent(function()
        if combatPanel and combatPanel:isVisible() then
          setupCombatPanel()
        end
        if healingPanel and healingPanel:isVisible() then
          setupHealingPanel()
        end
        if supportPanel and supportPanel:isVisible() then
          setupSupportPanel()
        end
      end, 100)
      
      needsUIRefresh = false
    end
  end
end

function onlineSimple()
  print("[Bot] onlineSimple() called")
  
  if not SimplifiedBot then
    print("[Bot] ERROR: SimplifiedBot is nil!")
    return
  end
  
  -- Load storage now that character name is available
  print("[Bot] Loading storage for character:", g_game.getCharacterName())
  SimplifiedBot.loadStorage()
  SimplifiedBot.init()
  
  -- Force UI refresh immediately if window is already open (character switch without closing client)
  if botWindow and botWindow:isVisible() then
    print("[Bot] Bot window is open - refreshing UI immediately...")
    
    -- Reset all setup flags
    combatSetup = false
    healingSetup = false
    supportSetup = false
    
    -- Force refresh of visible panel
    scheduleEvent(function()
      if combatPanel and combatPanel:isVisible() then
        setupCombatPanel()
      end
      if healingPanel and healingPanel:isVisible() then
        setupHealingPanel()
      end
      if supportPanel and supportPanel:isVisible() then
        setupSupportPanel()
      end
    end, 100)
  else
    -- Mark that UI needs refresh when window is opened later
    needsUIRefresh = true
    print("[Bot] Storage loaded - UI will refresh when bot window is opened")
  end
  
  print("[Bot] SimplifiedBot ready for online mode")

  
  
  -- Create button if it doesn't exist
  if not botButton then
    local status, err = pcall(function()
      print("[Bot] Creating bot button...")
      botButton = modules.game_mainpanel.addToggleButton('botButton', tr('Bot'), '/images/options/bot', toggleSimple, false, 99999)
      botButton:setOn(false)
      botButton:show()
    end)
    
    if not status then
      print("[Bot] ERROR creating button: " .. tostring(err))
      return
    end
  end
  
  -- Create main loop
  if not botMainLoop then
    status, err = pcall(function()
      print("[Bot] Creating main loop...")
      botMainLoop = {
        event = nil,
        enabled = false,
        setOn = function()
          if botMainLoop.enabled then return end
          print("[Bot] Main loop STARTING...")
          botMainLoop.enabled = true
          botMainLoop.loop()
        end,
        setOff = function()
          print("[Bot] Main loop STOPPING...")
          botMainLoop.enabled = false
          if botMainLoop.event then
            removeEvent(botMainLoop.event)
            botMainLoop.event = nil
          end
        end,
        loop = function()
          if not botMainLoop.enabled then return end
          if SimplifiedBot and SimplifiedBot.mainLoop then
            SimplifiedBot.mainLoop()
          end
          botMainLoop.event = scheduleEvent(botMainLoop.loop, 1000)
        end
      }
      modules.game_bot.botMainLoop = botMainLoop
    end)
    
    if not status then
      print("[Bot] ERROR creating main loop: " .. tostring(err))
      return
    end
  end
  
  
  -- Load storage
  status, err = pcall(function()
    print("[Bot] Loading storage...")
    SimplifiedBot.loadStorage()
    if SimplifiedBot.isEnabled() and botMainLoop then
      botMainLoop.setOn()
    end
  end)
  
  if not status then
    print("[Bot] ERROR loading storage: " .. tostring(err))
  end
  
  print("[Bot] onlineSimple() completed")
end

function offlineSimple()
  print("[Bot] offlineSimple() - Character going offline")
  
  if SimplifiedBot and SimplifiedBot.saveStorage then
    SimplifiedBot.saveStorage()
  end
  if SimplifiedBot and SimplifiedBot.setOff then
    SimplifiedBot.setOff()
  end
  if botMainLoop then
    botMainLoop.setOff()
  end
  
  -- Clear storage and storageFile to prevent transfer between characters
  print("[Bot] Clearing storage for next character login")
  storage = {}
  storageFile = nil
  
  -- Reset setup flags to force UI refresh on next login
  combatSetup = false
  healingSetup = false
  supportSetup = false
  needsUIRefresh = false
  print("[Bot] UI setup flags reset")
end

-- SimplifiedBot Functions (integrated from bot_simple.lua)

function SimplifiedBot.init()
  print("[Bot] SimplifiedBot.init() called")
  -- Storage will be loaded in onlineSimple() when character name is available
  
  if not storage.combat then
    print("[Bot] storage.combat is NIL - creating new with defaults")
    storage.combat = {
      enabled = false,
      attackAll = false,
      attackSummons = false,
      monsterList = {},
      spells = {"", "", ""}
    }
  else
    print("[Bot] storage.combat EXISTS - keeping saved values")
    print("[Bot] - enabled:", storage.combat.enabled)
    print("[Bot] - attackAll:", storage.combat.attackAll)
    
    -- Only set defaults for missing fields
    if storage.combat.attackSummons == nil then
      storage.combat.attackSummons = false
    end
    if not storage.combat.spells or #storage.combat.spells == 0 then
      storage.combat.spells = {"", "", ""}
    end
    if not storage.combat.monsterList then
      storage.combat.monsterList = {}
    end
  end
  
  if not storage.healing then
    storage.healing = {
      spell = {enabled = true, text = "minor heal", hpPercent = 60},
      healthPotion = {enabled = true, itemId = 3160, hpPercent = 40},
      manaPotion = {enabled = true, itemId = 268, mpPercent = 70}
    }
  end
  
  if not storage.support then
    storage.support = {
      spell1 = {enabled = false, text = "utamo vita", cooldown = 90},
      spell2 = {enabled = false, text = "utani hur", cooldown = 60},
      autoEat = {enabled = false, itemId = 3577, interval = 10}
    }
  end
end

function SimplifiedBot.terminate()
  SimplifiedBot.saveStorage()
  SimplifiedBot.setOff()
end

function SimplifiedBot.loadStorage()
  local path = "/bot_simplified/"
  if not g_resources.directoryExists(path) then
    g_resources.makeDir(path)
  end
  
  local charName = g_game.getCharacterName()
  if not charName or charName == "" then
    charName = "default"
  end
  
  -- Sanitize character name for filename (remove invalid chars)
  charName = charName:gsub("[^%w_-]", "_")
  
  storageFile = path .. "settings_" .. g_settings.getNumber('profile') .. "_" .. charName .. ".json"
  print("[Bot] Storage file: " .. storageFile)
  
  if g_resources.fileExists(storageFile) then
    print("[Bot] Loading existing storage...")
    local status, result = pcall(function()
      return json.decode(g_resources.readFileContents(storageFile))
    end)
    
    if status then
      storage = result
      print("[Bot] Storage loaded successfully")
    else
      print("[Bot] Failed to load storage")
    end
  else
    print("[Bot] No storage file found, using defaults")
  end
end

function SimplifiedBot.saveStorage()
  if not storageFile then
    print("[Bot] saveStorage: No storageFile set!")
    return
  end
  
  print("[Bot] Saving to file:", storageFile)
  
  local status, result = pcall(function()
    return json.encode(storage, 2)
  end)
  
  if status then
    g_resources.writeFileContents(storageFile, result)
    print("[Bot] Storage saved successfully")
  else
    print("[Bot] ERROR saving storage:", result)
  end
end

function SimplifiedBot.setOn()
  if not g_game.isOnline() then return end
  botEnabled = true
  SimplifiedBot.updateStatus()
end

function SimplifiedBot.setOff()
  botEnabled = false
  currentTarget = nil
  if g_game.isOnline() then
    g_game.cancelAttack()
  end
  SimplifiedBot.updateStatus()
end

function SimplifiedBot.toggle()
  if botEnabled then
    SimplifiedBot.setOff()
  else
    SimplifiedBot.setOn()
  end
end

function SimplifiedBot.isEnabled()
  return botEnabled
end

function SimplifiedBot.updateStatus()
  if not botWindow then return end
  
  local statusLabel = botWindow:recursiveGetChildById('statusLabel')
  local enableButton = botWindow:recursiveGetChildById('enableButton')
  
  if statusLabel then
    if botEnabled then
      statusLabel:setText("Status: Running")
      statusLabel:setColor("#00FF00")
    else
      statusLabel:setText("Status: Stopped")
      statusLabel:setColor("#FF0000")
    end
  end
  
  if enableButton then
    enableButton:setOn(botEnabled)
  end
end

function SimplifiedBot.setWindow(window)
  botWindow = window
  SimplifiedBot.updateStatus()
end

function SimplifiedBot.getStorage()
  return storage
end

function SimplifiedBot.processCombat()
  if not storage.combat then 
    print("[Bot Combat] ERROR: storage.combat is nil")
    return 
  end
  
  -- Check if combat is enabled
  if not storage.combat.enabled then
    print("[Bot Combat] Combat is disabled - skipping")
    -- Cancel any existing attack
    if g_game.getAttackingCreature() then
      g_game.cancelAttack()
    end
    return
  end
  
  if not g_game.isOnline() then return end
  
  local player = g_game.getLocalPlayer()
  if not player then return end
  
  local pos = player:getPosition()
  local creatures = g_map.getSpectators(pos, false)
  
  print("[Bot Combat] Found", #creatures, "creatures nearby")
  print("[Bot Combat] storage.combat.attackAll =", storage.combat.attackAll)
  if storage.combat.monsterList and #storage.combat.monsterList > 0 then
    print("[Bot Combat] Monster list:", table.concat(storage.combat.monsterList, ", "))
  else
    print("[Bot Combat] Monster list: EMPTY")
  end
  
  local bestTarget = nil
  local closestDistance = 999
  local monstersFound = 0
  local summonsSkipped = 0
  
  for _, creature in ipairs(creatures) do
    if creature:isMonster() then
      monstersFound = monstersFound + 1
      
      -- Check if should skip summons
      local isSummon = creature:isSummon()
      if isSummon and not storage.combat.attackSummons then
        summonsSkipped = summonsSkipped + 1
        print("[Bot Combat] Skipping summon:", creature:getName())
        goto continue
      end
      
      local shouldAttack = false
      
      if storage.combat.attackAll then
        -- Attack all monsters EXCEPT those in exclusion list
        shouldAttack = true
        
        -- Check if monster is in exclusion list (blacklist)
        if storage.combat.monsterList and #storage.combat.monsterList > 0 then
          local monsterName = creature:getName():lower()
          for _, excludedName in ipairs(storage.combat.monsterList) do
            if monsterName:find(excludedName:lower(), 1, true) then
              shouldAttack = false
              print("[Bot Combat] Monster excluded from attack:", creature:getName())
              break
            end
          end
        end
        
        if shouldAttack then
          print("[Bot Combat] AttackAll enabled - will attack:", creature:getName())
        end
      end
      
      if shouldAttack then
        local creaturePos = creature:getPosition()
        local distance = math.max(math.abs(pos.x - creaturePos.x), math.abs(pos.y - creaturePos.y))
        print("[Bot Combat] Monster", creature:getName(), "at distance", distance)
        if distance < closestDistance then
          closestDistance = distance
          bestTarget = creature
        end
      end
      
      ::continue::
    end
  end
  
  print("[Bot Combat] Summary - Monsters:", monstersFound, "Summons skipped:", summonsSkipped, "Best target:", bestTarget and bestTarget:getName() or "none")
  
  if bestTarget then
    currentTarget = bestTarget
    if g_game.getAttackingCreature() ~= bestTarget then
      print("[Bot Combat] Attacking:", bestTarget:getName())
      g_game.attack(bestTarget)
    end
    SimplifiedBot.castAttackSpell()
  else
    currentTarget = nil
    if g_game.getAttackingCreature() then
      g_game.cancelAttack()
    end
  end
end

function SimplifiedBot.castAttackSpell()
  if not storage.combat or not storage.combat.spells then
    print("[Bot Spell] ERROR: storage.combat.spells is nil")
    return
  end
  
  local spells = storage.combat.spells
  local validSpells = {}
  
  print("[Bot Spell] Raw spells from storage:", table.concat(spells or {}, ", "))
  
  for _, spell in ipairs(spells) do
    if spell and spell:len() > 0 then
      table.insert(validSpells, spell)
    end
  end
  
  print("[Bot Spell] Valid spells:", #validSpells, "spells -", table.concat(validSpells, ", "))
  
  if #validSpells == 0 then
    print("[Bot Spell] No valid spells to cast")
    return
  end
  
  local spell = validSpells[lastAttackSpell]
  if spell then
    print("[Bot Spell] Casting:", spell)
    g_game.talk(spell)
  end
  
  lastAttackSpell = lastAttackSpell + 1
  if lastAttackSpell > #validSpells then
    lastAttackSpell = 1
  end
end

function SimplifiedBot.processHealing()
  if not g_game.isOnline() then return end
  
  local now = g_clock.millis()
  if now - lastHealTime < healCooldown then return end
  
  local player = g_game.getLocalPlayer()
  if not player then return end
  
  local hp = player:getHealthPercent()
  local maxMana = player:getMaxMana()
  local mp = maxMana > 0 and math.floor(100 * player:getMana() / maxMana) or 100
  
  if storage.healing.spell.enabled and hp < storage.healing.spell.hpPercent then
    if storage.healing.spell.text:len() > 0 then
      g_game.talk(storage.healing.spell.text)
      lastHealTime = now
      return
    end
  end
  
  if storage.healing.healthPotion.enabled and hp < storage.healing.healthPotion.hpPercent then
    g_game.useInventoryItemWith(storage.healing.healthPotion.itemId, player)
    lastHealTime = now
    return
  end
  
  if storage.healing.manaPotion.enabled and mp < storage.healing.manaPotion.mpPercent then
    g_game.useInventoryItemWith(storage.healing.manaPotion.itemId, player)
    lastHealTime = now
    return
  end
end

function SimplifiedBot.processSupport()
  if not g_game.isOnline() then return end
  
  local now = g_clock.millis()
  
  if storage.support.spell1.enabled then
    local cooldown = storage.support.spell1.cooldown * 1000
    if now - lastSupport1 >= cooldown then
      if storage.support.spell1.text:len() > 0 then
        g_game.talk(storage.support.spell1.text)
        lastSupport1 = now
      end
    end
  end
  
  if storage.support.spell2.enabled then
    local cooldown = storage.support.spell2.cooldown * 1000
    if now - lastSupport2 >= cooldown then
      if storage.support.spell2.text:len() > 0 then
        g_game.talk(storage.support.spell2.text)
        lastSupport2 = now
      end
    end
  end
  
  if storage.support.autoEat.enabled then
    local interval = storage.support.autoEat.interval * 1000
    if now - lastEat >= interval then
      SimplifiedBot.eatFood()
      lastEat = now
    end
  end
end

function SimplifiedBot.eatFood()
  local itemId = storage.support.autoEat.itemId
  if itemId <= 100 then return end
  
  for _, container in pairs(g_game.getContainers()) do
    for _, item in ipairs(container:getItems()) do
      if item:getId() == itemId then
        g_game.use(item)
        return
      end
    end
  end
  
  if g_game.getClientVersion() >= 780 then
    g_game.useInventoryItem(itemId)
  end
end

function SimplifiedBot.mainLoop()
  if not botEnabled then 
    print("[Bot MainLoop] botEnabled is false - not running")
    return 
  end
  if not g_game.isOnline() then 
    print("[Bot MainLoop] Not online - not running")
    return 
  end
  
  print("[Bot MainLoop] Executing... botEnabled:", botEnabled)
  SimplifiedBot.processHealing()
  SimplifiedBot.processCombat()
  SimplifiedBot.processSupport()
end

-- UI Functions (consolidated from bot_ui.lua)

function showTextInputModal(title, currentText, callback)
  local inputWindow = g_ui.createWidget('MainWindow', g_ui.getRootWidget())
  inputWindow:setId('textInputModal')
  inputWindow:setText(title)
  inputWindow:setSize({width = 340, height = 170})
  
  local label = g_ui.createWidget('Label', inputWindow)
  label:setText('Enter spell text:')
  label:setTextAlign(AlignLeft)
  label:addAnchor(AnchorTop, 'parent', AnchorTop)
  label:addAnchor(AnchorLeft, 'parent', AnchorLeft)
  label:setMarginTop(15)
  label:setMarginLeft(15)
  
  local textEdit = g_ui.createWidget('TextEdit', inputWindow)
  textEdit:setId('modalTextEdit')
  textEdit:setText(currentText or "")
  textEdit:addAnchor(AnchorTop, 'prev', AnchorBottom)
  textEdit:addAnchor(AnchorLeft, 'parent', AnchorLeft)
  textEdit:addAnchor(AnchorRight, 'parent', AnchorRight)
  textEdit:setMarginTop(8)
  textEdit:setMarginLeft(15)
  textEdit:setMarginRight(15)
  textEdit:setHeight(25)
  
  local okButton = g_ui.createWidget('Button', inputWindow)
  okButton:setText('OK')
  okButton:setWidth(90)
  okButton:setHeight(32)
  okButton:addAnchor(AnchorTop, 'prev', AnchorBottom)
  okButton:addAnchor(AnchorRight, 'parent', AnchorHorizontalCenter)
  okButton:setMarginTop(15)
  okButton:setMarginRight(5)
  
  local cancelButton = g_ui.createWidget('Button', inputWindow)
  cancelButton:setText('Cancel')
  cancelButton:setWidth(90)
  cancelButton:setHeight(32)
  cancelButton:addAnchor(AnchorTop, 'prev', AnchorTop)
  cancelButton:addAnchor(AnchorLeft, 'parent', AnchorHorizontalCenter)
  cancelButton:setMarginLeft(5)
  
  okButton.onClick = function()
    local text = textEdit:getText()
    if callback then callback(text) end
    inputWindow:destroy()
  end
  
  cancelButton.onClick = function()
    inputWindow:destroy()
  end
  
  textEdit.onKeyPress = function(self, keyCode, keyboardModifiers)
    if keyCode == KeyEnter or keyCode == KeyNumpadEnter then
      local text = textEdit:getText()
      if callback then callback(text) end
      inputWindow:destroy()
      return true
    elseif keyCode == KeyEscape then
      inputWindow:destroy()
      return true
    end
    return false
  end
  
  inputWindow:show()
  inputWindow:raise()
  inputWindow:focus()
  textEdit:focus()
  textEdit:selectAll()
end

function initTabs()
  print("[Bot] Initializing tabs...")
  
  if not botWindow or not botTabs or not contentsPanel then
    g_logger.error("[Bot] Required UI components not found")
    return false
  end
  
  -- Get tab buttons
  local combatTabButton = botTabs:getChildById('combatTabButton')
  local healingTabButton = botTabs:getChildById('healingTabButton')
  local supportTabButton = botTabs:getChildById('supportTabButton')
  
  if not combatTabButton or not healingTabButton or not supportTabButton then
    g_logger.error("[Bot] Tab buttons not found")
    return false
  end
  
  -- Load panels
  local status, err = pcall(function()
    combatPanel = g_ui.loadUI('/game_bot/panels/combat', contentsPanel.botPanel)
    healingPanel = g_ui.loadUI('/game_bot/panels/healing', contentsPanel.botPanel)
    supportPanel = g_ui.loadUI('/game_bot/panels/support', contentsPanel.botPanel)
  end)
  
  if not status then
    g_logger.error("[Bot] Failed to load panels: " .. tostring(err))
    return false
  end
  
  -- Setup tab switching
  combatTabButton.onClick = function() 
    showPanel(combatPanel)
    combatTabButton:setOn(true)
    healingTabButton:setOn(false)
    supportTabButton:setOn(false)
    if not combatSetup then
      setupCombatPanel()
    end
  end
  
  healingTabButton.onClick = function() 
    showPanel(healingPanel)
    combatTabButton:setOn(false)
    healingTabButton:setOn(true)
    supportTabButton:setOn(false)
    setupHealingPanel()
  end
  
  supportTabButton.onClick = function() 
    showPanel(supportPanel)
    combatTabButton:setOn(false)
    healingTabButton:setOn(false)
    supportTabButton:setOn(true)
    setupSupportPanel()
  end
  
  -- Show first tab and setup
  showPanel(combatPanel)
  combatTabButton:setOn(true)
  
  scheduleEvent(function()
    setupCombatPanel()
  end, 100)
  
  return true
end

function showPanel(panel)
  if combatPanel then combatPanel:hide() end
  if healingPanel then healingPanel:hide() end
  if supportPanel then supportPanel:hide() end
  
  if panel then
    local parent = panel:getParent()
    if parent then
      parent:setEnabled(true)
      parent:setVisible(true)
    end
    
    panel:setEnabled(true)
    panel:setFocusable(true)
    panel:setVisible(true)
    panel:show()
    panel:raise()
    panel:focus()
  end
end

function setupCombatPanel()
  print("[Bot Setup] setupCombatPanel() called - combatSetup:", combatSetup)
  if combatSetup then 
    print("[Bot Setup] Combat panel already setup - skipping")
    return 
  end
  if not combatPanel then 
    print("[Bot Setup] ERROR: combatPanel is nil")
    return 
  end
  
  local storage = SimplifiedBot.getStorage()
  if not storage or not storage.combat then 
    print("[Bot Setup] ERROR: storage or storage.combat is nil")
    return 
  end
  
  print("[Bot Setup] Setting up combat panel...")
  combatSetup = true
  
  local attackAllCheckbox = combatPanel:recursiveGetChildById('attackAllCheckbox')
  if attackAllCheckbox then
    print("[Bot Setup] Loading attackAll from storage:", storage.combat.attackAll)
    attackAllCheckbox:setChecked(storage.combat.attackAll)
    attackAllCheckbox.onCheckChange = function(widget, checked)
      print("[Bot Setup] attackAll checkbox changed to:", checked)
      storage.combat.attackAll = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  local attackSummonsCheckbox = combatPanel:recursiveGetChildById('attackSummonsCheckbox')
  if attackSummonsCheckbox then
    print("[Bot Setup] Loading attackSummons from storage:", storage.combat.attackSummons)
    attackSummonsCheckbox:setChecked(storage.combat.attackSummons)
    attackSummonsCheckbox.onCheckChange = function(widget, checked)
      print("[Bot Setup] attackSummons checkbox changed to:", checked)
      storage.combat.attackSummons = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  local monsterList = combatPanel:recursiveGetChildById('monsterList')
  local addMonsterButton = combatPanel:recursiveGetChildById('addMonsterButton')
  local clearMonstersButton = combatPanel:recursiveGetChildById('clearMonstersButton')
  
  -- Function to refresh monster list display
  local function refreshMonsterList()
    if not monsterList then return end
    monsterList:destroyChildren()
    
    if storage.combat.monsterList then
      for index, monsterName in ipairs(storage.combat.monsterList) do
        local panel = g_ui.createWidget('Panel', monsterList)
        panel:setHeight(18)
        panel:setPhantom(false)
        
        local label = g_ui.createWidget('Label', panel)
        label:setText(monsterName)
        label:setPhantom(false)
        label:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        label:addAnchor(AnchorTop, 'parent', AnchorTop)
        label:setMarginLeft(5)
        label:setMarginTop(2)
        
        local removeButton = g_ui.createWidget('Button', panel)
        removeButton:setText('X')
        removeButton:setWidth(20)
        removeButton:setHeight(16)
        removeButton:addAnchor(AnchorRight, 'parent', AnchorRight)
        removeButton:addAnchor(AnchorTop, 'parent', AnchorTop)
        removeButton:setMarginRight(20)  -- Increased margin to avoid scrollbar overlap
        removeButton:setMarginTop(1)
        removeButton:setTooltip('Remove this monster')
        
        removeButton.onClick = function()
          table.remove(storage.combat.monsterList, index)
          SimplifiedBot.saveStorage()
          refreshMonsterList()
        end
      end
    end
  end
  
  refreshMonsterList()
  
  if addMonsterButton then
    addMonsterButton.onClick = function()
      showTextInputModal('Exclude Monster (name)', "", function(text)
        if text and text ~= "" then
          if not storage.combat.monsterList then
            storage.combat.monsterList = {}
          end
          
          table.insert(storage.combat.monsterList, text)
          SimplifiedBot.saveStorage()
          refreshMonsterList()
        end
      end)
    end
  end
  
  if clearMonstersButton then
    clearMonstersButton.onClick = function()
      storage.combat.monsterList = {}
      SimplifiedBot.saveStorage()
      refreshMonsterList()
    end
  end
  
  local combatEnabledCheckbox = combatPanel:recursiveGetChildById('combatEnabledCheckbox')
  if combatEnabledCheckbox then
    print("[Bot Setup] Combat Enabled from storage:", storage.combat.enabled)
    combatEnabledCheckbox:setChecked(storage.combat.enabled)
    combatEnabledCheckbox.onCheckChange = function(widget, checked)
      print("[Bot Setup] Combat Enabled changed to:", checked)
      storage.combat.enabled = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  local spell1Button = combatPanel:recursiveGetChildById('spell1Button')
  local spell2Button = combatPanel:recursiveGetChildById('spell2Button')
  local spell3Button = combatPanel:recursiveGetChildById('spell3Button')
  
  if spell1Button then
    local currentSpell = storage.combat.spells[1] or ""
    if currentSpell ~= "" then
      spell1Button:setText(currentSpell)
    end
    
    spell1Button.onClick = function()
      showTextInputModal('Spell 1', storage.combat.spells[1] or "", function(text)
        storage.combat.spells[1] = text
        spell1Button:setText(text ~= "" and text or "Click to add spell 1")
        SimplifiedBot.saveStorage()
      end)
    end
  end
  
  if spell2Button then
    local currentSpell = storage.combat.spells[2] or ""
    if currentSpell ~= "" then
      spell2Button:setText(currentSpell)
    end
    
    spell2Button.onClick = function()
      showTextInputModal('Spell 2', storage.combat.spells[2] or "", function(text)
        storage.combat.spells[2] = text
        spell2Button:setText(text ~= "" and text or "Click to add spell 2")
        SimplifiedBot.saveStorage()
      end)
    end
  end
  
  if spell3Button then
    local currentSpell = storage.combat.spells[3] or ""
    if currentSpell ~= "" then
      spell3Button:setText(currentSpell)
    end
    
    spell3Button.onClick = function()
      showTextInputModal('Spell 3', storage.combat.spells[3] or "", function(text)
        storage.combat.spells[3] = text
        spell3Button:setText(text ~= "" and text or "Click to add spell 3")
        SimplifiedBot.saveStorage()
      end)
    end
  end
end

function setupHealingPanel()
  if not healingPanel then return end
  local storage = SimplifiedBot.getStorage()
  
  local healSpellEnabled = healingPanel:recursiveGetChildById('healSpellEnabled')
  local healSpellButton = healingPanel:recursiveGetChildById('healSpellButton')
  local healSpellHpSlider = healingPanel:recursiveGetChildById('healSpellHpSlider')
  local healSpellHpLabel = healingPanel:recursiveGetChildById('healSpellHpLabel')
  
  if healSpellEnabled then
    healSpellEnabled:setChecked(storage.healing.spell.enabled)
    healSpellEnabled.onCheckChange = function(widget, checked)
      storage.healing.spell.enabled = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  if healSpellButton then
    local currentSpell = storage.healing.spell.text or ""
    if currentSpell ~= "" then
      healSpellButton:setText(currentSpell)
    end
    
    healSpellButton.onClick = function()
      showTextInputModal('Heal Spell', storage.healing.spell.text or "", function(text)
        storage.healing.spell.text = text
        healSpellButton:setText(text ~= "" and text or "Click to set spell")
        SimplifiedBot.saveStorage()
      end)
    end
  end
  
  if healSpellHpSlider and healSpellHpLabel then
    healSpellHpSlider:setValue(storage.healing.spell.hpPercent)
    healSpellHpLabel:setText(storage.healing.spell.hpPercent .. "%")
    healSpellHpSlider.onValueChange = function()
      local value = healSpellHpSlider:getValue()
      storage.healing.spell.hpPercent = value
      healSpellHpLabel:setText(value .. "%")
      SimplifiedBot.saveStorage()
    end
    
    -- Add tooltips to slider buttons
    local decrementButton = healSpellHpSlider:getChildById('decrementButton')
    local incrementButton = healSpellHpSlider:getChildById('incrementButton')
    if decrementButton then
      decrementButton:setTooltip('Decrease HP threshold')
    end
    if incrementButton then
      incrementButton:setTooltip('Increase HP threshold')
    end
  end
  
  local healthPotionEnabled = healingPanel:recursiveGetChildById('healthPotionEnabled')
  local healthPotionButton = healingPanel:recursiveGetChildById('healthPotionButton')
  local healthPotionHpSlider = healingPanel:recursiveGetChildById('healthPotionHpSlider')
  local healthPotionHpLabel = healingPanel:recursiveGetChildById('healthPotionHpLabel')
  
  if healthPotionEnabled then
    healthPotionEnabled:setChecked(storage.healing.healthPotion.enabled)
    healthPotionEnabled.onCheckChange = function(widget, checked)
      storage.healing.healthPotion.enabled = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  if healthPotionButton then
    local currentItem = tostring(storage.healing.healthPotion.itemId)
    healthPotionButton:setText(currentItem)
    healthPotionButton:setTooltip('Click to select health potion with crosshair')
    
    healthPotionButton.onClick = function()
      startChoosePotionItem('health')
    end
  end
  
  if healthPotionHpSlider and healthPotionHpLabel then
    healthPotionHpSlider:setValue(storage.healing.healthPotion.hpPercent)
    healthPotionHpLabel:setText(storage.healing.healthPotion.hpPercent .. "%")
    
    -- Add tooltips to slider buttons
    local decrementButton = healthPotionHpSlider:getChildById('decrementButton')
    local incrementButton = healthPotionHpSlider:getChildById('incrementButton')
    if decrementButton then
      decrementButton:setTooltip('Decrease HP threshold')
    end
    if incrementButton then
      incrementButton:setTooltip('Increase HP threshold')
    end
    healthPotionHpSlider.onValueChange = function()
      local value = healthPotionHpSlider:getValue()
      storage.healing.healthPotion.hpPercent = value
      healthPotionHpLabel:setText(value .. "%")
      SimplifiedBot.saveStorage()
    end
  end
  
  local manaPotionEnabled = healingPanel:recursiveGetChildById('manaPotionEnabled')
  local manaPotionButton = healingPanel:recursiveGetChildById('manaPotionButton')
  local manaPotionMpSlider = healingPanel:recursiveGetChildById('manaPotionMpSlider')
  local manaPotionMpLabel = healingPanel:recursiveGetChildById('manaPotionMpLabel')
  
  if manaPotionEnabled then
    manaPotionEnabled:setChecked(storage.healing.manaPotion.enabled)
    manaPotionEnabled.onCheckChange = function(widget, checked)
      storage.healing.manaPotion.enabled = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  if manaPotionButton then
    local currentItem = tostring(storage.healing.manaPotion.itemId)
    manaPotionButton:setText(currentItem)
    manaPotionButton:setTooltip('Click to select mana potion with crosshair')
    
    manaPotionButton.onClick = function()
      startChoosePotionItem('mana')
    end
  end
  
  if manaPotionMpSlider and manaPotionMpLabel then
    manaPotionMpSlider:setValue(storage.healing.manaPotion.mpPercent)
    manaPotionMpLabel:setText(storage.healing.manaPotion.mpPercent .. "%")
    
    -- Add tooltips to slider buttons
    local decrementButton = manaPotionMpSlider:getChildById('decrementButton')
    local incrementButton = manaPotionMpSlider:getChildById('incrementButton')
    if decrementButton then
      decrementButton:setTooltip('Decrease MP threshold')
    end
    if incrementButton then
      incrementButton:setTooltip('Increase MP threshold')
    end
    
    manaPotionMpSlider.onValueChange = function()
      local value = manaPotionMpSlider:getValue()
      storage.healing.manaPotion.mpPercent = value
      manaPotionMpLabel:setText(value .. "%")
      SimplifiedBot.saveStorage()
    end
  end
end

function setupSupportPanel()
  if not supportPanel then return end
  local storage = SimplifiedBot.getStorage()
  
  local spell1Enabled = supportPanel:recursiveGetChildById('spell1Enabled')
  local spell1Button = supportPanel:recursiveGetChildById('spell1Button')
  local spell1CooldownSlider = supportPanel:recursiveGetChildById('spell1CooldownSlider')
  local spell1CooldownLabel = supportPanel:recursiveGetChildById('spell1CooldownLabel')
  
  if spell1Enabled then
    spell1Enabled:setChecked(storage.support.spell1.enabled)
    spell1Enabled.onCheckChange = function(widget, checked)
      storage.support.spell1.enabled = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  if spell1Button then
    local currentSpell = storage.support.spell1.text or ""
    if currentSpell ~= "" then
      spell1Button:setText(currentSpell)
    end
    
    spell1Button.onClick = function()
      showTextInputModal('Support Spell 1', storage.support.spell1.text or "", function(text)
        storage.support.spell1.text = text
        spell1Button:setText(text ~= "" and text or "Click to set spell")
        SimplifiedBot.saveStorage()
      end)
    end
  end
  
  if spell1CooldownSlider and spell1CooldownLabel then
    spell1CooldownSlider:setValue(storage.support.spell1.cooldown)
    spell1CooldownLabel:setText(storage.support.spell1.cooldown .. "s")
    
    spell1CooldownSlider.onValueChange = function()
      local value = spell1CooldownSlider:getValue()
      storage.support.spell1.cooldown = value
      spell1CooldownLabel:setText(value .. "s")
      SimplifiedBot.saveStorage()
    end
    
    -- Add tooltips to slider buttons
    local decrementButton = spell1CooldownSlider:getChildById('decrementButton')
    local incrementButton = spell1CooldownSlider:getChildById('incrementButton')
    if decrementButton then
      decrementButton:setTooltip('Decrease cooldown')
    end
    if incrementButton then
      incrementButton:setTooltip('Increase cooldown')
    end
  end
  
  local spell2Enabled = supportPanel:recursiveGetChildById('spell2Enabled')
  local spell2Button = supportPanel:recursiveGetChildById('spell2Button')
  local spell2CooldownSlider = supportPanel:recursiveGetChildById('spell2CooldownSlider')
  local spell2CooldownLabel = supportPanel:recursiveGetChildById('spell2CooldownLabel')
  
  if spell2Enabled then
    spell2Enabled:setChecked(storage.support.spell2.enabled)
    spell2Enabled.onCheckChange = function(widget, checked)
      storage.support.spell2.enabled = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  if spell2Button then
    local currentSpell = storage.support.spell2.text or ""
    if currentSpell ~= "" then
      spell2Button:setText(currentSpell)
    end
    
    spell2Button.onClick = function()
      showTextInputModal('Support Spell 2', storage.support.spell2.text or "", function(text)
        storage.support.spell2.text = text
        spell2Button:setText(text ~= "" and text or "Click to set spell")
        SimplifiedBot.saveStorage()
      end)
    end
  end
  
  if spell2CooldownSlider and spell2CooldownLabel then
    spell2CooldownSlider:setValue(storage.support.spell2.cooldown)
    spell2CooldownLabel:setText(storage.support.spell2.cooldown .. "s")
    
    spell2CooldownSlider.onValueChange = function()
      local value = spell2CooldownSlider:getValue()
      storage.support.spell2.cooldown = value
      spell2CooldownLabel:setText(value .. "s")
      SimplifiedBot.saveStorage()
    end
    
    -- Add tooltips to slider buttons
    local decrementButton = spell2CooldownSlider:getChildById('decrementButton')
    local incrementButton = spell2CooldownSlider:getChildById('incrementButton')
    if decrementButton then
      decrementButton:setTooltip('Decrease cooldown')
    end
    if incrementButton then
      incrementButton:setTooltip('Increase cooldown')
    end
  end
  
  local autoEatEnabled = supportPanel:recursiveGetChildById('autoEatEnabled')
  local autoEatButton = supportPanel:recursiveGetChildById('autoEatButton')
  local autoEatIntervalSlider = supportPanel:recursiveGetChildById('autoEatIntervalSlider')
  local autoEatIntervalLabel = supportPanel:recursiveGetChildById('autoEatIntervalLabel')
  
  if autoEatEnabled then
    autoEatEnabled:setChecked(storage.support.autoEat.enabled)
    autoEatEnabled.onCheckChange = function(widget, checked)
      storage.support.autoEat.enabled = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  if autoEatButton then
    local currentItem = tostring(storage.support.autoEat.itemId)
    autoEatButton:setText(currentItem)
    autoEatButton:setTooltip('Click to select food item with crosshair')
    
    autoEatButton.onClick = function()
      startChoosePotionItem('food')
    end
  end
  
  if autoEatIntervalSlider and autoEatIntervalLabel then
    autoEatIntervalSlider:setValue(storage.support.autoEat.interval)
    autoEatIntervalLabel:setText(storage.support.autoEat.interval .. "s")
    
    autoEatIntervalSlider.onValueChange = function()
      local value = autoEatIntervalSlider:getValue()
      storage.support.autoEat.interval = value
      autoEatIntervalLabel:setText(value .. "s")
      SimplifiedBot.saveStorage()
    end
    
    -- Add tooltips to slider buttons
    local decrementButton = autoEatIntervalSlider:getChildById('decrementButton')
    local incrementButton = autoEatIntervalSlider:getChildById('incrementButton')
    if decrementButton then
      decrementButton:setTooltip('Decrease interval')
    end
    if incrementButton then
      incrementButton:setTooltip('Increase interval')
    end
  end
end
