-- Simplified Bot Module
-- Version 2.0 by nok1111
-- All-in-one: Bot logic + UI in single file

local botButton = nil
local botMainLoop = nil
local botWindow = nil
local contentsPanel = nil
local enableButton = nil
local statusLabel = nil
local botTabs = nil

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

-- Export onMiniWindowClose for bot.otui @onClose callback
modules.game_bot.onMiniWindowClose = onMiniWindowClose

function startChoosePotionItem(potionType)
  if g_ui.isMouseGrabbed() then
    return
  end
  potionTypeToSet = potionType
  mouseGrabberWidget:grabMouse()
  g_mouse.pushCursor('target')
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
  
  connect(g_keyboard, {
    onKeyPress = function(keyCode, keyboardModifiers)
      return false
    end
  })
  
  local rootWidget = modules.game_interface.getRootPanel()
  if rootWidget then
    connect(rootWidget, {
      onKeyPress = function(self, keyCode, keyboardModifiers)
        return false
      end
    })
  else
  end
end

function init()
  
  -- TEMPORARY: Debug input
  debugInput()
  
  -- Storage will be initialized when character logs in (onlineSimple)
  
  -- STEP 3: Create UI (like original mehah)
  if modules.game_interface then
    status, err = pcall(function()
      -- Import UI styles first
      g_ui.importStyle('ui/basic')
      
      botWindow = g_ui.loadUI('bot', modules.game_interface.getLeftPanel())
      if not botWindow then
        error("Failed to load bot.otui")
      end
      
      -- Setup MiniWindow (enables close/minimize buttons)
      botWindow:setContentMinimumHeight(80)
      botWindow:setup()
      
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
      enableButton = botWindow:recursiveGetChildById('enableButton')
      statusLabel = botWindow:recursiveGetChildById('statusLabel')
      botTabs = botWindow:recursiveGetChildById('tabButtonsPanel')
      contentsPanel = botWindow:recursiveGetChildById('miniwindowContents')
      
      if not enableButton or not statusLabel or not botTabs then
      else
      end
      
      enableButton.onClick = function()
        if SimplifiedBot.isEnabled() then
          SimplifiedBot.setOff()
          if botMainLoop then botMainLoop.setOff() end
          enableButton:setOn(false)
          statusLabel:setText('Status: Stopped')
          statusLabel:setColor("#FF0000")
          storage.globalEnabled = false
          SimplifiedBot.saveStorage()
        else
          SimplifiedBot.setOn()
          if botMainLoop then botMainLoop.setOn() end
          enableButton:setOn(true)
          statusLabel:setText('Status: Running')
          statusLabel:setColor("#00FF00")
          storage.globalEnabled = true
          SimplifiedBot.saveStorage()
        end
      end
      
      -- Initialize tabs (storage is ready now)
      local uiSuccess = initTabs()
      if not uiSuccess then
      end
    end)
    
    if not status then
      return
    end
  end
  
  -- STEP 5: Connect game events
  connect(g_game, {
    onGameStart = onlineSimple,
    onGameEnd = offlineSimple,
  })
  
  if g_game.isOnline() then
    local success, error = pcall(onlineSimple)
    if not success then
    end
  end
end

function terminate()
  
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
end

function toggleSimple()
  
  if not botWindow then
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
  
  if not SimplifiedBot then
    return
  end
  
  -- Load storage now that character name is available
  SimplifiedBot.loadStorage()
  SimplifiedBot.init()
  
  -- Force UI refresh immediately if window is already open (character switch without closing client)
  if botWindow and botWindow:isVisible() then
    
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
  end

  
  
  -- Create button if it doesn't exist
  if not botButton then
    local status, err = pcall(function()
      botButton = modules.game_mainpanel.addToggleButton('botButton', tr('Bot'), '/images/options/bot', toggleSimple, false, 99999)
      botButton:setOn(false)
      botButton:show()
    end)
    
    if not status then
      return
    end
  end
  
  -- Create main loop
  if not botMainLoop then
    status, err = pcall(function()
      botMainLoop = {
        event = nil,
        enabled = false,
        setOn = function()
          if botMainLoop.enabled then return end
          botMainLoop.enabled = true
          botMainLoop.loop()
        end,
        setOff = function()
          botMainLoop.enabled = false
          if botMainLoop.event then
            removeEvent(botMainLoop.event)
            botMainLoop.event = nil
          end
        end,
        loop = function()
          if not botMainLoop.enabled then return end
          if SimplifiedBot and SimplifiedBot.mainLoop then
            local success, err = pcall(SimplifiedBot.mainLoop)
            if not success then
            end
          end
          botMainLoop.event = scheduleEvent(botMainLoop.loop, 200)
        end
      }
      modules.game_bot.botMainLoop = botMainLoop
    end)
    
    if not status then
      return
    end
  end
  
  
  -- Enable main loop if bot is already enabled from profile
  status, err = pcall(function()
    if SimplifiedBot.isEnabled() and botMainLoop then
      botMainLoop.setOn()
    end
    
    -- Auto start UI toggle and the actual loop if bot is globally enabled
    if storage.globalEnabled then
      SimplifiedBot.setOn()
      if botMainLoop then botMainLoop.setOn() end
      if enableButton and statusLabel then
        enableButton:setOn(true)
        statusLabel:setText('Status: Running')
        statusLabel:setColor("#00FF00")
      end
    end
  end)
  
  if not status then
  end
end

function offlineSimple()
  
  if SimplifiedBot and SimplifiedBot.saveStorage then
    SimplifiedBot.saveStorage()
  end
  if botMainLoop then
    botMainLoop.setOff()
  end
  
  -- Clear storage and storageFile to prevent transfer between characters
  storage = {}
  storageFile = nil
  
  -- Reset setup flags to force UI refresh on next login
  combatSetup = false
  healingSetup = false
  supportSetup = false
  needsUIRefresh = false
end

-- SimplifiedBot Functions (integrated from bot_simple.lua)

function SimplifiedBot.init()
  -- Storage will be loaded in onlineSimple() when character name is available
  
  if storage.globalEnabled == nil then
    storage.globalEnabled = false
  end
  
  if not storage.combat then
    storage.combat = {
      enabled = false,
      attackAll = false,
      attackSummons = false,
      attackPlayers = false,
      holdTargetPvE = false,
      maxDistance = 10,
      priority = "Closest",
      monsterList = {},
      spells = {"", "", ""}
    }
  else
    
    -- Only set defaults for missing fields
    if storage.combat.attackSummons == nil then
      storage.combat.attackSummons = false
    end
    if storage.combat.attackPlayers == nil then
      storage.combat.attackPlayers = false
    end
    if storage.combat.holdTargetPvE == nil then
      storage.combat.holdTargetPvE = false
    end
    if storage.combat.maxDistance == nil then
      storage.combat.maxDistance = 10
    end
    if storage.combat.priority == nil then
      storage.combat.priority = "Closest"
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
      autoEat = {enabled = false, itemId = 3577, interval = 10},
      antiIdle = {enabled = false}
    }
  else
    if not storage.support.antiIdle then
      storage.support.antiIdle = {enabled = false}
    end
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
  
  if g_resources.fileExists(storageFile) then
    local status, result = pcall(function()
      return json.decode(g_resources.readFileContents(storageFile))
    end)
    
    if status then
      storage = result
    else
    end
  else
  end
  
  -- Force init to populate missing fields whenever storage is loaded
  SimplifiedBot.init()
end

local saveEvent = nil
function SimplifiedBot.delayedSave()
  if saveEvent then
    removeEvent(saveEvent)
  end
  saveEvent = scheduleEvent(function()
    SimplifiedBot.saveStorage()
    saveEvent = nil
  end, 500)
end

function SimplifiedBot.saveStorage()
  if not storageFile then
    return
  end
  
  local status, result = pcall(function()
    return json.encode(storage, 2)
  end)
  
  if status then
    g_resources.writeFileContents(storageFile, result)
  else
  end
end

function SimplifiedBot.setOn()
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
    return 
  end
  
  -- Check if combat is enabled
  if not storage.combat.enabled then
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
  
  -- PvP / PvE Hold Target logic
  local currentAttack = g_game.getAttackingCreature()
  
  if currentAttack then
    if currentAttack:isPlayer() and currentAttack:getName() ~= player:getName() and storage.combat.attackPlayers then
      currentTarget = currentAttack
      SimplifiedBot.castAttackSpell()
      return
    elseif currentAttack:isMonster() and storage.combat.holdTargetPvE then
      -- Verify if current monster is still a valid target
      local cPos = currentAttack:getPosition()
      if cPos and cPos.z == pos.z and g_map.isSightClear(pos, cPos) then
        local distance = math.max(math.abs(pos.x - cPos.x), math.abs(pos.y - cPos.y))
        local maxDist = tonumber(storage.combat.maxDistance) or 10
        if distance <= maxDist then
          -- Target is still valid, hold it
          currentTarget = currentAttack
          SimplifiedBot.castAttackSpell()
          return
        end
      end
      -- If it's no longer valid (out of range/sight), let it fall through and find a new target
    end
  end
  
  local creatures = g_map.getSpectators(pos, false)
  if storage.combat.monsterList and #storage.combat.monsterList > 0 then
  else
  end
  
  local bestTarget = nil
  local bestValue = 999 -- Distance or Health depending on priority
  local monstersFound = 0
  local summonsSkipped = 0
  local playersFound = 0
  
  for _, creature in ipairs(creatures) do
    local isMonster = creature:isMonster()
    
    if isMonster then
      monstersFound = monstersFound + 1
      
      -- Check if should skip summons
      local isSummon = creature:isSummon()
      if isSummon and not storage.combat.attackSummons then
        summonsSkipped = summonsSkipped + 1
        goto continue
      end
      
      local creaturePos = creature:getPosition()
      if creaturePos.z ~= pos.z then
        goto continue
      end
      
      if not g_map.isSightClear(pos, creaturePos) then
        goto continue
      end
      
      local shouldAttack = true
      
      if storage.combat.attackAll then
        -- Attack all monsters EXCEPT those in exclusion list
        
        -- Check if monster is in exclusion list (blacklist)
        if storage.combat.monsterList and #storage.combat.monsterList > 0 then
          local monsterName = creature:getName():lower()
          for _, excludedName in ipairs(storage.combat.monsterList) do
            if monsterName:find(excludedName:lower(), 1, true) then
              shouldAttack = false
              break
            end
          end
        end
        
        if shouldAttack then
        end
      else
        -- Only attack monsters IN the inclusion list (whitelist behavior)
        -- Support old compatibility if they don't have attackAll enabled but list is empty (fallback to true)
        if storage.combat.monsterList and #storage.combat.monsterList > 0 then
          shouldAttack = false
          local monsterName = creature:getName():lower()
          for _, includedName in ipairs(storage.combat.monsterList) do
            if monsterName:find(includedName:lower(), 1, true) then
              shouldAttack = true
              break
            end
          end
        end
      end
      
      if shouldAttack then
        local distance = math.max(math.abs(pos.x - creaturePos.x), math.abs(pos.y - creaturePos.y))
        local maxDist = tonumber(storage.combat.maxDistance) or 10
        
        -- Filter out targets that are too far
        if distance > maxDist then
          shouldAttack = false
        end
        
        if shouldAttack then
          if storage.combat.priority == "Lowest Health" then
            local hp = creature:getHealthPercent()
            if hp < bestValue then
              bestValue = hp
              bestTarget = creature
            end
          else -- Default to Closest
            if distance < bestValue then
              bestValue = distance
              bestTarget = creature
            end
          end
        end
      end
      
      ::continue::
    end
  end
  
  if bestTarget then
    currentTarget = bestTarget
    if g_game.getAttackingCreature() ~= bestTarget then
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

local lastSpellTime = 0
function SimplifiedBot.castAttackSpell()
  if not storage.combat or not storage.combat.spells then
    return
  end
  
  local now = g_clock.millis()
  if now - lastSpellTime < 2000 then return end -- Basic exhaust protection
  
  local spells = storage.combat.spells
  local validSpells = {}
  
  for _, spell in ipairs(spells) do
    if spell and spell:len() > 0 then
      table.insert(validSpells, spell)
    end
  end
  
  if #validSpells == 0 then
    return
  end
  
  local spell = validSpells[lastAttackSpell]
  if spell then
    g_game.talk(spell)
    lastSpellTime = now
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
  
  if storage.healing.spell.enabled and hp < (tonumber(storage.healing.spell.hpPercent) or 90) then
    if storage.healing.spell.text:len() > 0 then
      g_game.talk(storage.healing.spell.text)
      lastHealTime = now
      return
    end
  end
  
  if storage.healing.healthPotion.enabled and hp < (tonumber(storage.healing.healthPotion.hpPercent) or 50) then
    g_game.useInventoryItemWith(storage.healing.healthPotion.itemId, player)
    lastHealTime = now
    return
  end
  
  if storage.healing.manaPotion.enabled and mp < (tonumber(storage.healing.manaPotion.mpPercent) or 50) then
    g_game.useInventoryItemWith(storage.healing.manaPotion.itemId, player)
    lastHealTime = now
    return
  end
end

local lastAntiIdle = 0

function SimplifiedBot.processSupport()
  if not g_game.isOnline() then return end
  
  local now = g_clock.millis()
  local player = g_game.getLocalPlayer()
  
  if storage.support.antiIdle and storage.support.antiIdle.enabled and player then
    -- Turn every 14 minutes (840,000 ms)
    if now - lastAntiIdle >= 840000 then
      g_game.turn(player:getDirection())
      lastAntiIdle = now
    end
  end
  
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
    return 
  end
  if not g_game.isOnline() then 
    return 
  end
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
  
  if not botWindow or not botTabs then
    g_logger.error("[Bot] Required UI components not found")
    return false
  end
  
  -- Get tab buttons
  local combatTabButton = botWindow:recursiveGetChildById('combatTabButton')
  local healingTabButton = botWindow:recursiveGetChildById('healingTabButton')
  local supportTabButton = botWindow:recursiveGetChildById('supportTabButton')
  
  if not combatTabButton or not healingTabButton or not supportTabButton then
    g_logger.error("[Bot] Tab buttons not found")
    return false
  end
  
  -- Load panels
  local botPanel = botWindow:recursiveGetChildById('botPanel')
  if not botPanel then
    g_logger.error("[Bot] botPanel not found")
    return false
  end
  
  local status, err = pcall(function()
    combatPanel = g_ui.loadUI('/game_bot/panels/combat', botPanel)
    healingPanel = g_ui.loadUI('/game_bot/panels/healing', botPanel)
    supportPanel = g_ui.loadUI('/game_bot/panels/support', botPanel)
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
  if combatSetup then 
    return 
  end
  if not combatPanel then 
    return 
  end
  
  local storage = SimplifiedBot.getStorage()
  if not storage or not storage.combat then 
    return 
  end
  combatSetup = true
  
  local attackAllCheckbox = combatPanel:recursiveGetChildById('attackAllCheckbox')
  if attackAllCheckbox then
    attackAllCheckbox:setChecked(storage.combat.attackAll)
    attackAllCheckbox.onCheckChange = function(widget, checked)
      storage.combat.attackAll = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  local attackSummonsCheckbox = combatPanel:recursiveGetChildById('attackSummonsCheckbox')
  if attackSummonsCheckbox then
    attackSummonsCheckbox:setChecked(storage.combat.attackSummons)
    attackSummonsCheckbox.onCheckChange = function(widget, checked)
      storage.combat.attackSummons = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  local attackPlayersCheckbox = combatPanel:recursiveGetChildById('attackPlayersCheckbox')
  if attackPlayersCheckbox then
    attackPlayersCheckbox:setChecked(storage.combat.attackPlayers)
    attackPlayersCheckbox.onCheckChange = function(widget, checked)
      storage.combat.attackPlayers = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  local holdTargetPvECheckbox = combatPanel:recursiveGetChildById('holdTargetPvECheckbox')
  if holdTargetPvECheckbox then
    holdTargetPvECheckbox:setChecked(storage.combat.holdTargetPvE)
    holdTargetPvECheckbox.onCheckChange = function(widget, checked)
      storage.combat.holdTargetPvE = checked
      SimplifiedBot.saveStorage()
    end
  end
  
  local distanceSlider = combatPanel:recursiveGetChildById('distanceSlider')
  local distanceLabel = combatPanel:recursiveGetChildById('distanceLabel')
  if distanceSlider and distanceLabel then
    distanceSlider:setValue(storage.combat.maxDistance)
    distanceLabel:setText("Max Attack Distance: " .. storage.combat.maxDistance .. " sqm")
    
    distanceSlider.onValueChange = function()
      local value = distanceSlider:getValue()
      storage.combat.maxDistance = value
      distanceLabel:setText("Max Attack Distance: " .. value .. " sqm")
      SimplifiedBot.delayedSave()
    end
  end
  
  local priorityComboBox = combatPanel:recursiveGetChildById('priorityComboBox')
  if priorityComboBox then
    priorityComboBox:clearOptions()
    priorityComboBox:addOption("Closest")
    priorityComboBox:addOption("Lowest Health")
    
    -- Set current option from storage
    if storage.combat.priority then
      priorityComboBox:setCurrentOption(storage.combat.priority)
    end
    
    priorityComboBox.onOptionChange = function(widget, option, data)
      storage.combat.priority = option
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
    combatEnabledCheckbox:setChecked(storage.combat.enabled)
    combatEnabledCheckbox.onCheckChange = function(widget, checked)
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
      SimplifiedBot.delayedSave()
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
      SimplifiedBot.delayedSave()
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
      SimplifiedBot.delayedSave()
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
      SimplifiedBot.delayedSave()
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
      SimplifiedBot.delayedSave()
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
      SimplifiedBot.delayedSave()
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
  
  local antiIdleEnabled = supportPanel:recursiveGetChildById('antiIdleEnabled')
  if antiIdleEnabled then
    antiIdleEnabled:setChecked(storage.support.antiIdle.enabled)
    antiIdleEnabled.onCheckChange = function(widget, checked)
      storage.support.antiIdle.enabled = checked
      SimplifiedBot.saveStorage()
    end
  end
end

