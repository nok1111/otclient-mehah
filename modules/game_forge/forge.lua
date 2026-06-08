modules.game_forge = modules.game_forge or {}

local Forge = modules.game_forge

local OPCODE_FORGE = 217

local window = nil
local toggleButton = nil
local perksWindow = nil
local lastState = nil

local ACTION_OPEN = 'forge_open'
local ACTION_FEED_CORE = 'forge_feed_core'
local ACTION_CONSUME_ESSENCE = 'forge_consume_essence'
local ACTION_INFUSE_CORE = 'forge_infuse_core'

local function getForgeCard(cardId)
  if not window or window:isDestroyed() then
    return nil
  end

  local cardsContainer = window:getChildById('cardsContainer')
  if cardsContainer then
    local card = cardsContainer:getChildById(cardId)
    if card then
      return card
    end
  end

  return window:getChildById(cardId)
end

local function setCardContent(card, title, description, iconPath, buttonText)
  if not card then
    return
  end

  local titleLabel = card:getChildById('cardTitle')
  if titleLabel then
    titleLabel:setText(title)
  end

  local descLabel = card:getChildById('cardDesc')
  if descLabel then
    descLabel:setText(description)
  end

  local image = card:getChildById('cardImage')
  if image and iconPath and iconPath ~= '' then
    image:setImageSource(iconPath)
  end

  local button = card:getChildById('cardButton')
  if button then
    button:setText(buttonText)
  end
end

local function sendAction(action, data)
  local protocol = g_game.getProtocolGame()
  if not protocol then
    return
  end

  protocol:sendExtendedOpcode(OPCODE_FORGE, json.encode({
    action = action,
    data = data or {}
  }))
end

local function ensureWindow()
  if window and not window:isDestroyed() then
    return true
  end

  local parent = rootWidget
  if modules.game_interface and modules.game_interface.getRootPanel then
    parent = modules.game_interface.getRootPanel() or rootWidget
  end

  window = g_ui.createWidget('ForgeWindow', parent)
  window:hide()

  local cardsContainer = window:getChildById('cardsContainer')
  if cardsContainer then
    local cards = {
      cardsContainer:getChildById('feedCard'),
      cardsContainer:getChildById('consumeCard'),
      cardsContainer:getChildById('infuseCard')
    }

    for _, card in ipairs(cards) do
      if card then
        card:setWidth(230)
        card:setHeight(372)
        local image = card:getChildById('cardImage')
        if image then
          image:setWidth(136)
          image:setHeight(136)
        end
      end
    end
  end

  local feedCard = getForgeCard('feedCard')
  local consumeCard = getForgeCard('consumeCard')
  local infuseCard = getForgeCard('infuseCard')

  setCardContent(
    feedCard,
    'Feed Core',
    'Consume Demonic Ash to fill the core progress bar.',
    '/images/forge/core_feed',
    'Feed Core'
  )

  setCardContent(
    consumeCard,
    'Consume Ember',
    'Consume essence for instant experience.',
    '/images/forge/core_consume',
    'Consume'
  )

  setCardContent(
    infuseCard,
    'Infuse Core',
    'Requires full bar. Increases core level and milestones.',
    '/images/forge/core_infuse',
    'Infuse'
  )

  if feedCard then
    local button = feedCard:getChildById('cardButton')
    if button then
      button.onClick = function()
        sendAction(ACTION_FEED_CORE)
      end
    end
  end

  if consumeCard then
    local button = consumeCard:getChildById('cardButton')
    if button then
      button.onClick = function()
        sendAction(ACTION_CONSUME_ESSENCE)
      end
    end
  end

  if infuseCard then
    local button = infuseCard:getChildById('cardButton')
    if button then
      button.onClick = function()
        sendAction(ACTION_INFUSE_CORE)
      end
    end
  end

  local perksButton = window:recursiveGetChildById('perksButton')
  if perksButton then
    perksButton.onClick = function()
      Forge.togglePerks()
    end
  end

  local forgeCloseButton = window:recursiveGetChildById('forgeCloseButton')
  if forgeCloseButton then
    forgeCloseButton.onClick = function()
      Forge.hide()
    end
  end

  return true
end

local function applyState(data)
  if not ensureWindow() then
    return
  end

  data = data or {}
  local coreLevel = tonumber(data.coreLevel) or 0
  local coreProgress = tonumber(data.coreProgress) or 0
  local requiredProgress = tonumber(data.requiredProgress) or 0
  local milestone = tonumber(data.milestone) or 0
  local ashDropBonusChance = tonumber(data.ashDropBonusChance) or 0
  local consumeExp = tonumber(data.consumeExp) or 0

  local ashBonusLabel = window:getChildById('ashBonusLabel')
  local milestoneLabel = window:getChildById('milestoneLabel')
  local progressLabel = window:getChildById('progressLabel')
  local coreProgressBar = window:getChildById('coreProgressBar')

  if ashBonusLabel then
    ashBonusLabel:setText(string.format('Ash Bonus: %.1f%% (cap 25%%)', ashDropBonusChance))
  end

  if milestoneLabel then
    milestoneLabel:setText(string.format('Milestone: %d', milestone))
  end

  if progressLabel then
    progressLabel:setText(string.format('Core: %d | Progress: %d/%d', coreLevel, coreProgress, requiredProgress))
  end

  if coreProgressBar then
    if requiredProgress > 0 then
      coreProgressBar:setValue(coreProgress, 0, requiredProgress)
    else
      coreProgressBar:setPercent(0)
    end
    coreProgressBar:setText(string.format('Core Progress: %d/%d', coreProgress, requiredProgress))
  end

  local feedAshName = data.feedAshItemName
  if not feedAshName or feedAshName == '' then
    feedAshName = string.format('Item %d', tonumber(data.feedAshItemId) or 0)
  end

  local essenceName = data.consumeEssenceItemName
  if not essenceName or essenceName == '' then
    essenceName = string.format('Item %d', tonumber(data.consumeEssenceItemId) or 0)
  end

  local feedCard = getForgeCard('feedCard')
  if feedCard then
    local costLabel = feedCard:getChildById('cardCostLabel')
    local valueLabel = feedCard:getChildById('cardValueLabel')
    if costLabel then
      costLabel:setText(string.format('Cost: %dx %s', tonumber(data.feedAshPerAction) or 1, feedAshName))
    end
    if valueLabel then
      valueLabel:setText('Value: +1 core progress')
    end
  end

  local consumeCard = getForgeCard('consumeCard')
  if consumeCard then
    local costLabel = consumeCard:getChildById('cardCostLabel')
    local valueLabel = consumeCard:getChildById('cardValueLabel')
    if costLabel then
      costLabel:setText(string.format('Cost: %dx %s', tonumber(data.consumeEssencePerAction) or 1, essenceName))
    end
    if valueLabel then
      local label = data.paragonActive and 'Paragon XP' or 'exp'
      valueLabel:setText(string.format('Value: +%d %s instant', consumeExp, label))
    end
  end

  local infuseCard = getForgeCard('infuseCard')
  if infuseCard then
    local costLabel = infuseCard:getChildById('cardCostLabel')
    local valueLabel = infuseCard:getChildById('cardValueLabel')
    if costLabel then
      local maxLv = tonumber(data.maxLevel) or 0
      if maxLv > 0 and coreLevel >= maxLv then
        costLabel:setText(string.format('Max level reached (%d)', maxLv))
      else
        costLabel:setText(string.format('Requirement: %d/%d progress', coreProgress, requiredProgress))
      end
    end
    if valueLabel then
      valueLabel:setText('Value: +1 core level, milestone scaling')
    end
  end

  lastState = data
  if perksWindow and not perksWindow:isDestroyed() and perksWindow:isVisible() then
    Forge.refreshPerks()
  end
end

local function ensurePerksWindow()
  if perksWindow and not perksWindow:isDestroyed() then
    return true
  end

  local parent = rootWidget
  if modules.game_interface and modules.game_interface.getRootPanel then
    parent = modules.game_interface.getRootPanel() or rootWidget
  end

  perksWindow = g_ui.createWidget('ForgePerksWindow', parent)
  perksWindow:hide()

  local closeBtn = perksWindow:recursiveGetChildById('perksCloseButton')
  if closeBtn then
    closeBtn.onClick = function()
      Forge.togglePerks()
    end
  end

  return true
end

function Forge.refreshPerks()
  if not ensurePerksWindow() then return end
  if not lastState then return end

  local list = perksWindow:recursiveGetChildById('perksList')
  if not list then return end
  list:destroyChildren()

  local currentLevel = tonumber(lastState.coreLevel) or 0
  local perks = lastState.perks or {}

  for _, perk in ipairs(perks) do
    local ok, row = pcall(g_ui.createWidget, 'ForgePerkRow', list)
    if not ok or not row then
      break
    end
    local lv = tonumber(perk.level) or 0
    local title = string.format('Level %d', lv)
    if perk.isMilestone then
      title = title .. '  (Milestone)'
    end
    if lv <= currentLevel then
      title = title .. '  [Unlocked]'
    end

    local unlocked = lv <= currentLevel
    local lockedColor = '#6E6E6E'

    local titleLabel = row:getChildById('rowTitle')
    if titleLabel then
      titleLabel:setText(title)
      if not unlocked then
        titleLabel:setColor(lockedColor)
      elseif perk.isMilestone then
        titleLabel:setColor('#FFD17A')
      else
        titleLabel:setColor('#9FD49F')
      end
    end

    local descLabel = row:getChildById('rowDesc')
    if descLabel then
      local consumeExp = tonumber(perk.consumeExp) or 0
      local lines = {}
      table.insert(lines, string.format('-%.1f%% damage taken (Forge Zone)   |   +%.1f%% Ash drop',
        tonumber(perk.damageReduction) or 0, tonumber(perk.ashDropBonus) or 0))
      local secondParts = {}
      table.insert(secondParts, string.format('Consume Ember: +%s exp', formatNumber and formatNumber(consumeExp) or tostring(consumeExp)))
      if perk.isMilestone then
        table.insert(secondParts, string.format('+%.1f%% damage to monsters (Forge Zone)', tonumber(perk.damageBonus) or 0))
      end
      table.insert(lines, table.concat(secondParts, '   |   '))
      descLabel:setText(table.concat(lines, '\n'))
      if unlocked then
        descLabel:setColor('#C5E1FF')
      else
        descLabel:setColor(lockedColor)
      end
    end

  end

  local headerLabel = perksWindow:recursiveGetChildById('perksHeader')
  if headerLabel then
    local maxLv = tonumber(lastState.maxLevel) or 0
    headerLabel:setText(string.format('Core Level: %d / %d   Zone ID: %d', currentLevel, maxLv, tonumber(lastState.forgeZoneId) or 0))
  end
end

function Forge.togglePerks()
  if not ensurePerksWindow() then return end
  if perksWindow:isVisible() then
    perksWindow:hide()
    return
  end
  perksWindow:show()
  perksWindow:raise()
  perksWindow:focus()

  if not lastState then
    sendAction(ACTION_OPEN)
  end
  Forge.refreshPerks()
end

local function onExtendedOpcode(protocol, opcode, buffer)
  if opcode ~= OPCODE_FORGE then
    return
  end

  local ok, packet = pcall(function()
    return json.decode(buffer)
  end)

  if not ok or type(packet) ~= 'table' then
    return
  end

  if packet.action == 'forge_open_window' then
    if ensureWindow() then
      window:show()
      window:raise()
      window:focus()
      if toggleButton and not toggleButton:isDestroyed() then
        toggleButton:setOn(true)
      end
    end

    applyState(packet.data)
    if packet.feedback and packet.feedback ~= '' then
      modules.game_textmessage.displayStatusMessage(packet.feedback)
    end
    return
  end

  if packet.action == 'forge_close_window' then
    Forge.hide()
    if packet.feedback and packet.feedback ~= '' then
      modules.game_textmessage.displayStatusMessage(packet.feedback)
    end
    return
  end

  if packet.action == 'forge_state' then
    applyState(packet.data)
    if packet.feedback and packet.feedback ~= '' then
      modules.game_textmessage.displayStatusMessage(packet.feedback)
    end
  end
end

function Forge.show()
  if not ensureWindow() then
    return
  end

  window:show()
  window:raise()
  window:focus()
  sendAction(ACTION_OPEN)

  if toggleButton and not toggleButton:isDestroyed() then
    toggleButton:setOn(true)
  end
end

function Forge.hide()
  if window and not window:isDestroyed() then
    window:hide()
  end

  if perksWindow and not perksWindow:isDestroyed() then
    perksWindow:hide()
  end

  if toggleButton and not toggleButton:isDestroyed() then
    toggleButton:setOn(false)
  end
end

local function toggle()
  if not ensureWindow() then
    return
  end

  if window:isVisible() then
    Forge.hide()
  else
    Forge.show()
  end
end

function init()
  g_ui.importStyle('forge.otui')

  connect(g_game, {
    onGameEnd = Forge.hide
  })

  ProtocolGame.registerExtendedOpcode(OPCODE_FORGE, onExtendedOpcode)

  if toggleButton and not toggleButton:isDestroyed() then
    toggleButton:destroy()
  end
  toggleButton = nil

  if g_game.isOnline() then
    Forge.show()
    Forge.hide()
  end
end

function terminate()
  disconnect(g_game, {
    onGameEnd = Forge.hide
  })

  ProtocolGame.unregisterExtendedOpcode(OPCODE_FORGE)

  if window and not window:isDestroyed() then
    window:destroy()
  end
  window = nil

  if perksWindow and not perksWindow:isDestroyed() then
    perksWindow:destroy()
  end
  perksWindow = nil

  if toggleButton and not toggleButton:isDestroyed() then
    toggleButton:destroy()
  end
  toggleButton = nil
end
