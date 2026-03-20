modules.game_forge = modules.game_forge or {}

local Forge = modules.game_forge

local OPCODE_FORGE = 217

local window = nil
local toggleButton = nil

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

  local feedCard = getForgeCard('feedCard')
  if feedCard then
    local costLabel = feedCard:getChildById('cardCostLabel')
    local valueLabel = feedCard:getChildById('cardValueLabel')
    if costLabel then
      costLabel:setText(string.format('Cost: %dx Item %d', tonumber(data.feedAshPerAction) or 1, tonumber(data.feedAshItemId) or 0))
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
      costLabel:setText(string.format('Cost: %dx Item %d', tonumber(data.consumeEssencePerAction) or 1, tonumber(data.consumeEssenceItemId) or 0))
    end
    if valueLabel then
      valueLabel:setText(string.format('Value: +%d exp instant', consumeExp))
    end
  end

  local infuseCard = getForgeCard('infuseCard')
  if infuseCard then
    local costLabel = infuseCard:getChildById('cardCostLabel')
    local valueLabel = infuseCard:getChildById('cardValueLabel')
    if costLabel then
      costLabel:setText(string.format('Requirement: %d/%d progress', coreProgress, requiredProgress))
    end
    if valueLabel then
      valueLabel:setText('Value: +1 core level, milestone scaling')
    end
  end
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

  if modules.game_mainpanel and modules.game_mainpanel.addToggleButton then
    toggleButton = modules.game_mainpanel.addToggleButton(
      'forgeToggleButton',
      tr('Forge'),
      '/images/options/button_prey',
      toggle,
      false,
      1012
    )
  end

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

  if toggleButton and not toggleButton:isDestroyed() then
    toggleButton:destroy()
  end
  toggleButton = nil
end
