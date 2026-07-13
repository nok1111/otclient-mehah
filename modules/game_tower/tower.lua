TowerTracker = TowerTracker or {}

local OPCODE_TOWER = 215
local trackerWidget = nil
local trackerData = nil
local trackerToggleButton = nil
local trackerHiddenByUser = false
local trackerTimerEvent = nil
local trackerTimerSync = nil
local lobbyButton = nil
local lobbyWindow = nil
local lobbyState = nil
local isRenderingLobby = false
local applyTrackerData
local showPlaceholderTracker

local ACTION_PROGRESS = 'tower_progress'
local ACTION_LOBBY_OPEN = 'tower_lobby_open'
local ACTION_LOBBY_UPDATE = 'tower_lobby_update'
local ACTION_LOBBY_CLOSE = 'tower_lobby_close'
local ACTION_LOBBY_REQUEST = 'tower_lobby_request'
local ACTION_LOBBY_INPUT = 'tower_lobby_action'

local OBJECTIVE_NAMES = {
  kill = 'Kill',
  extermination = 'Extermination',
  kill_all = 'Extermination',
  elite = 'Elite',
  boss = 'Boss',
  boss_floor = 'Boss',
  survive = 'Survive',
  sigil = 'Sigil'
}

local OBJECTIVE_COLORS = {
  kill = '#7DCBFF',
  extermination = '#FFD27D',
  kill_all = '#FFD27D',
  elite = '#FFCC66',
  boss = '#FF8A8A',
  boss_floor = '#FF8A8A',
  survive = '#A8E6A1',
  sigil = '#D2A8FF'
}

local function clearTrackerTimerEvent()
  if trackerTimerEvent then
    removeEvent(trackerTimerEvent)
    trackerTimerEvent = nil
  end
end

local function formatRemainingTime(seconds)
  local value = math.max(0, math.floor(tonumber(seconds) or 0))
  local hours = math.floor(value / 3600)
  local minutes = math.floor((value % 3600) / 60)
  local secs = value % 60

  if hours > 0 then
    return string.format('%d:%02d:%02d', hours, minutes, secs)
  end

  return string.format('%02d:%02d', minutes, secs)
end

local function getRemainingFloorSeconds()
  if not trackerData or trackerData.active ~= true then
    return nil
  end

  local deadlineAt = tonumber(trackerData.floorDeadlineAt) or 0
  if deadlineAt <= 0 then
    return nil
  end

  local sync = trackerTimerSync
  if not sync then
    sync = {
      serverNow = tonumber(trackerData.serverNow) or os.time(),
      clientMs = g_clock.millis()
    }
    trackerTimerSync = sync
  end

  local elapsed = math.max(0, (g_clock.millis() - sync.clientMs) / 1000)
  local estimatedNow = sync.serverNow + elapsed
  return math.max(0, math.floor((deadlineAt - estimatedNow) + 0.5))
end

local function refreshTrackerTimerLabel()
  if not trackerWidget or trackerWidget:isDestroyed() then
    return
  end

  local timerLabel = trackerWidget:getChildById('timerLabel')
  if not timerLabel then
    return
  end

  local remaining = getRemainingFloorSeconds()
  if remaining == nil then
    timerLabel:setText('Time Left: --:--')
    timerLabel:setColor('#C5E1FF')
    return
  end

  timerLabel:setText(string.format('Time Left: %s', formatRemainingTime(remaining)))
  if remaining <= 30 then
    timerLabel:setColor('#FF8A8A')
  elseif remaining <= 120 then
    timerLabel:setColor('#FFD27D')
  else
    timerLabel:setColor('#9FD49F')
  end
end

local function startTrackerTimerLoop()
  clearTrackerTimerEvent()
  local function tick()
    refreshTrackerTimerLabel()

    if not trackerData or trackerData.active ~= true or trackerHiddenByUser then
      trackerTimerEvent = nil
      return
    end

    trackerTimerEvent = scheduleEvent(tick, 250)
  end

  trackerTimerEvent = scheduleEvent(tick, 50)
end

local function getParentWidget()
  if modules.game_interface and modules.game_interface.getRootPanel then
    local rootPanel = modules.game_interface.getRootPanel()
    if rootPanel then
      return rootPanel
    end
  end

  return rootWidget
end

local function parsePacket(buffer)
  local ok, data = pcall(function()
    return json.decode(buffer)
  end)

  if not ok then
    g_logger.error('[TowerTracker] JSON decode failed: ' .. tostring(data))
    return nil
  end

  if type(data) ~= 'table' then
    return nil
  end

  return data
end

local function sendAction(action, data)
  local protocol = g_game.getProtocolGame()
  if not protocol then
    return
  end

  local payload = {
    action = action,
    data = data or {}
  }
  protocol:sendExtendedOpcode(OPCODE_TOWER, json.encode(payload))
end

local function getPayload(packet)
  if type(packet) ~= 'table' then
    return nil, nil
  end

  if type(packet.action) == 'string' then
    local packetData = packet.data
    if type(packetData) ~= 'table' then
      packetData = {}
    end
    return packet.action, packetData
  end

  if packet.active ~= nil then
    return ACTION_PROGRESS, packet
  end

  if type(packet.data) == 'table' and packet.data.active ~= nil then
    return ACTION_PROGRESS, packet.data
  end

  return ACTION_PROGRESS, packet
end

local function destroyTracker()
  if trackerWidget and not trackerWidget:isDestroyed() then
    trackerWidget:destroy()
  end
  trackerWidget = nil
end

local function destroyLobby()
  if lobbyWindow and not lobbyWindow:isDestroyed() then
    lobbyWindow:destroy()
  end
  lobbyWindow = nil
end

local function ensureToggleButton()
  if trackerToggleButton and not trackerToggleButton:isDestroyed() then
    return
  end

  if not modules.game_mainpanel or not modules.game_mainpanel.addToggleButton then
    return
  end

 -- trackerToggleButton = modules.game_mainpanel.addToggleButton(
 --   'towerTrackerButton',
  --  tr('Tower Tracker'),
  --  '/images/options/button_prey',
  --  function()
  --    trackerHiddenByUser = not trackerHiddenByUser
   --   if trackerHiddenByUser then
   --     if trackerWidget and not trackerWidget:isDestroyed() then
   --       trackerWidget:hide()
  --      end
   --   elseif trackerData then
   --     applyTrackerData(trackerData)
  --    else
  --      showPlaceholderTracker()
  --    end

  --    if trackerToggleButton and not trackerToggleButton:isDestroyed() then
  --      trackerToggleButton:setOn(not trackerHiddenByUser)
 --     end
 --   end,
 --   false,
    1010
 -- )

  if trackerToggleButton and not trackerToggleButton:isDestroyed() then
    trackerToggleButton:setOn(not trackerHiddenByUser)
  end

  if lobbyButton and not lobbyButton:isDestroyed() then
    lobbyButton:setOn(false)
  end
end

local function destroyToggleButton()
  if trackerToggleButton and not trackerToggleButton:isDestroyed() then
    trackerToggleButton:destroy()
  end
  trackerToggleButton = nil
end

local function destroyLobbyButton()
  if lobbyButton and not lobbyButton:isDestroyed() then
    lobbyButton:destroy()
  end
  lobbyButton = nil
end

local function sanitizeFloor(text, minFloor, maxFloor)
  local floor = tonumber(text)
  if not floor then
    floor = minFloor or 1
  end

  floor = math.floor(floor)

  if minFloor and floor < minFloor then
    floor = minFloor
  end

  if maxFloor and floor > maxFloor then
    floor = maxFloor
  end

  if floor < 1 then
    floor = 1
  end

  return floor
end

local function normalizeMultilineText(text)
  local value = tostring(text or '')
  value = value:gsub('\\r\\n', '\n')
  value = value:gsub('\\n', '\n')
  return value
end

local function getValidFloorRange(minFloor, maxFloor)
  local minValue = tonumber(minFloor) or 1
  local maxValue = tonumber(maxFloor) or minValue
  if maxValue < minValue then
    maxValue = minValue - 1
  end
  return minValue, maxValue
end

local function hasUnlockedFloor(minFloor, maxFloor)
  local minValue, maxValue = getValidFloorRange(minFloor, maxFloor)
  return maxValue >= minValue
end

local function getSelectedFloorFromDropdown(dropdown, minFloor, maxFloor)
  if not hasUnlockedFloor(minFloor, maxFloor) then
    return nil
  end

  if not dropdown then
    return sanitizeFloor(minFloor, minFloor, maxFloor)
  end

  if dropdown.getCurrentOption then
    local option = dropdown:getCurrentOption()
    if option then
      local fromData = tonumber(option.data)
      if fromData then
        return sanitizeFloor(fromData, minFloor, maxFloor)
      end

      local fromText = tostring(option.text or ''):match('(%d+)')
      if fromText then
        return sanitizeFloor(tonumber(fromText), minFloor, maxFloor)
      end
    end
  end

  if dropdown.getCurrentIndex then
    local idx = tonumber(dropdown:getCurrentIndex()) or 0
    return sanitizeFloor((minFloor or 1) + idx, minFloor, maxFloor)
  end

  return sanitizeFloor(minFloor, minFloor, maxFloor)
end

local function ensureLobbyButton()
  if lobbyButton and not lobbyButton:isDestroyed() then
    lobbyButton:destroy()
  end
  lobbyButton = nil
end

local function formatObjectiveName(rawType)
  if not rawType then
    return 'None'
  end

  local key = string.lower(tostring(rawType))
  return OBJECTIVE_NAMES[key] or key:gsub('^%l', string.upper)
end

local function ensureTracker()
  if trackerWidget and not trackerWidget:isDestroyed() then
    return true
  end

  local parent = getParentWidget()
  if not parent then
    return false
  end

  trackerWidget = g_ui.createWidget('TowerTracker', parent)
  trackerWidget:hide()
  return true
end

local function ensureLobbyWindow()
  if lobbyWindow and not lobbyWindow:isDestroyed() then
    return true
  end

  local parent = getParentWidget()
  if not parent then
    return false
  end

  lobbyWindow = g_ui.createWidget('TowerLobbyWindow', parent)
  lobbyWindow:hide()
  return true
end

local function buildDefaultLobbyState()
  return {
    bestFloorWeek = 0,
    currency = 0,
    weeklyMutator = {
      key = 'none',
      name = 'No mutator',
      description = ''
    },
    systemInfoText = '- Enter solo or trio\n- Clear floor objectives\n- Push your weekly best floor',
    rewardsText = '- Tower Shards per floor\n- Weekly chest based on best floor',
    solo = {
      minFloor = 1,
      maxFloor = 1,
      selectedFloor = 1,
      floorTimeoutSeconds = 0,
      statusText = 'Ready to start'
    },
    trio = {
      minFloor = 1,
      maxFloor = 1,
      selectedFloor = 1,
      floorTimeoutSeconds = 0,
      statusText = 'Create or join a trio',
      partyCode = '----',
      members = {'Empty', 'Empty', 'Empty'},
      isReady = false,
      showPanel = false
    }
  }
end

local function normalizeLobbyState(state)
  local defaults = buildDefaultLobbyState()
  if type(state) ~= 'table' then
    return defaults
  end

  local merged = {
    bestFloorWeek = tonumber(state.bestFloorWeek) or defaults.bestFloorWeek,
    currency = tonumber(state.currency) or defaults.currency,
    weeklyMutator = {},
    systemInfoText = tostring(state.systemInfoText or defaults.systemInfoText),
    rewardsText = tostring(state.rewardsText or defaults.rewardsText),
    solo = {},
    trio = {}
  }

  local weeklyMutator = type(state.weeklyMutator) == 'table' and state.weeklyMutator or {}
  merged.weeklyMutator.key = tostring(weeklyMutator.key or defaults.weeklyMutator.key)
  merged.weeklyMutator.name = tostring(weeklyMutator.name or defaults.weeklyMutator.name)
  merged.weeklyMutator.description = tostring(weeklyMutator.description or defaults.weeklyMutator.description)

  local solo = type(state.solo) == 'table' and state.solo or {}
  merged.solo.minFloor = tonumber(solo.minFloor) or defaults.solo.minFloor
  merged.solo.maxFloor = tonumber(solo.maxFloor) or defaults.solo.maxFloor
  merged.solo.selectedFloor = tonumber(solo.selectedFloor) or merged.solo.minFloor
  merged.solo.floorTimeoutSeconds = tonumber(solo.floorTimeoutSeconds) or defaults.solo.floorTimeoutSeconds
  merged.solo.statusText = tostring(solo.statusText or defaults.solo.statusText)

  local trio = type(state.trio) == 'table' and state.trio or {}
  merged.trio.minFloor = tonumber(trio.minFloor) or defaults.trio.minFloor
  merged.trio.maxFloor = tonumber(trio.maxFloor) or defaults.trio.maxFloor
  merged.trio.selectedFloor = tonumber(trio.selectedFloor) or merged.trio.minFloor
  merged.trio.floorTimeoutSeconds = tonumber(trio.floorTimeoutSeconds) or defaults.trio.floorTimeoutSeconds
  merged.trio.statusText = tostring(trio.statusText or defaults.trio.statusText)
  merged.trio.partyCode = tostring(trio.partyCode or defaults.trio.partyCode)
  merged.trio.isReady = trio.isReady == true
  merged.trio.showPanel = trio.showPanel == true

  merged.trio.members = {'Empty', 'Empty', 'Empty'}
  if type(trio.members) == 'table' then
    for i = 1, 3 do
      merged.trio.members[i] = tostring(trio.members[i] or 'Empty')
    end
  end

  return merged
end

local function setCardData(card, config)
  if not card then
    return
  end

  local modeTitle = card:getChildById('modeTitle')
  local modeDesc = card:getChildById('modeDesc')
  local modeStatus = card:getChildById('modeStatus')
  local modeTimer = card:getChildById('modeTimer')
  local floorDropdown = card:getChildById('floorDropdown')
  local actionButton = card:getChildById('actionButton')

  if modeTitle then
    modeTitle:setText(config.title)
  end
  if modeDesc then
    modeDesc:setText(config.description)
  end
  if modeStatus then
    modeStatus:setText(config.statusText)
  end
  if modeTimer then
    local timeoutSeconds = math.max(0, math.floor(tonumber(config.floorTimeoutSeconds) or 0))
    if timeoutSeconds > 0 then
      modeTimer:setText(string.format('Floor Timer: %s', formatRemainingTime(timeoutSeconds)))
      modeTimer:setColor('#FFD27D')
    else
      modeTimer:setText('Floor Timer: --:--')
      modeTimer:setColor('#C5E1FF')
    end
  end
  local canSelectFloor = hasUnlockedFloor(config.minFloor, config.maxFloor)
  if floorDropdown then
    floorDropdown:setTooltip(canSelectFloor and string.format('Unlocked floors: %d to %d', config.minFloor, config.maxFloor) or 'No unlocked floors available yet.')
    if floorDropdown.clearOptions then
      floorDropdown:clearOptions()
    end
    if canSelectFloor and floorDropdown.addOption then
      for floor = config.minFloor, config.maxFloor do
        floorDropdown:addOption(string.format('Floor %d (Unlocked)', floor), floor)
      end
    end

    local selectedFloor = canSelectFloor and sanitizeFloor(config.selectedFloor, config.minFloor, config.maxFloor) or nil
    if canSelectFloor and floorDropdown.setCurrentIndex then
      floorDropdown:setCurrentIndex(math.max(0, selectedFloor - config.minFloor))
    end
    if floorDropdown.setEnabled then
      floorDropdown:setEnabled(canSelectFloor)
    end

    floorDropdown.onOptionChange = function(widget, text, data)
      if isRenderingLobby or not config.onFloorChanged or not canSelectFloor then
        return
      end

      local selected = tonumber(data)
      if not selected then
        selected = tonumber(tostring(text or ''):match('(%d+)'))
      end
      selected = sanitizeFloor(selected, config.minFloor, config.maxFloor)
      config.onFloorChanged(selected)
    end
  end
  if actionButton then
    actionButton:setText(canSelectFloor and config.buttonText or 'No Floors Unlocked')
    actionButton:setEnabled(canSelectFloor)
    actionButton.onClick = canSelectFloor and config.onClick or nil
  end
end

local function renderLobby(state)
  if not ensureLobbyWindow() then
    return
  end

  isRenderingLobby = true

  state = normalizeLobbyState(state)
  lobbyState = state

  local summaryLabel = lobbyWindow:getChildById('summaryLabel')
  if summaryLabel then
    summaryLabel:setText(string.format('Weekly Best: %d | Shards: %d', state.bestFloorWeek, state.currency))
  end

  local mutatorNameLabel = lobbyWindow:getChildById('mutatorNameLabel')
  if mutatorNameLabel then
    mutatorNameLabel:setText(tr(state.weeklyMutator.name))
  end

  local mutatorDescLabel = lobbyWindow:getChildById('mutatorDescLabel')
  if mutatorDescLabel then
    local mutatorDesc = normalizeMultilineText(state.weeklyMutator.description)
    if mutatorDesc == '' then
      mutatorDesc = tr('No special mutation this week.')
    end
    mutatorDescLabel:setText(tr(mutatorDesc))
  end

  local systemInfoTextLabel = lobbyWindow:getChildById('systemInfoTextLabel')
  if systemInfoTextLabel then
    systemInfoTextLabel:setText(normalizeMultilineText(state.systemInfoText))
  end

  local rewardsTextLabel = lobbyWindow:getChildById('rewardsTextLabel')
  if rewardsTextLabel then
    rewardsTextLabel:setText(normalizeMultilineText(state.rewardsText))
  end

  local cardsContainer = lobbyWindow:getChildById('cardsContainer')
  local soloCard = cardsContainer and cardsContainer:getChildById('soloCard')
  local trioCard = cardsContainer and cardsContainer:getChildById('trioCard')

  setCardData(soloCard, {
    title = 'Solo Run',
    description = 'Fight alone. Fast queue and full control.',
    statusText = state.solo.statusText,
    minFloor = state.solo.minFloor,
    maxFloor = state.solo.maxFloor,
    selectedFloor = state.solo.selectedFloor,
    floorTimeoutSeconds = state.solo.floorTimeoutSeconds,
    onFloorChanged = function(selectedFloor)
      sendAction(ACTION_LOBBY_INPUT, {type = 'preview_floor', floor = selectedFloor})
    end,
    buttonText = 'Start Solo',
    onClick = function()
      local floorDropdown = soloCard and soloCard:getChildById('floorDropdown')
      local selectedFloor = getSelectedFloorFromDropdown(floorDropdown, state.solo.minFloor, state.solo.maxFloor)
      if not selectedFloor then
        return
      end
      sendAction(ACTION_LOBBY_INPUT, {type = 'start_solo', floor = selectedFloor})
    end
  })

  setCardData(trioCard, {
    title = 'Trio Run',
    description = '3-player team lobby. Share progress and roles.',
    statusText = state.trio.statusText,
    minFloor = state.trio.minFloor,
    maxFloor = state.trio.maxFloor,
    selectedFloor = state.trio.selectedFloor,
    floorTimeoutSeconds = state.trio.floorTimeoutSeconds,
    onFloorChanged = function(selectedFloor)
      sendAction(ACTION_LOBBY_INPUT, {type = 'preview_floor', floor = selectedFloor})
    end,
    buttonText = 'Open Trio Panel',
    onClick = function()
      local trioPanel = lobbyWindow and lobbyWindow:getChildById('trioPanel')
      if trioPanel then
        local newVisible = not trioPanel:isVisible()
        trioPanel:setHeight(newVisible and 132 or 0)
        trioPanel:setVisible(newVisible)
      end
    end
  })

  local trioPanel = lobbyWindow:getChildById('trioPanel')
  if trioPanel then
    trioPanel:setHeight(state.trio.showPanel and 132 or 0)
    trioPanel:setVisible(state.trio.showPanel)

    local partyCodeLabel = trioPanel:getChildById('partyCodeLabel')
    local membersLabel = trioPanel:getChildById('membersLabel')
    local joinCodeEdit = trioPanel:getChildById('joinCodeEdit')
    local createPartyButton = trioPanel:getChildById('createPartyButton')
    local joinPartyButton = trioPanel:getChildById('joinPartyButton')
    local readyButton = trioPanel:getChildById('readyButton')
    local startTrioButton = trioPanel:getChildById('startTrioButton')
    local leavePartyButton = trioPanel:getChildById('leavePartyButton')

    if partyCodeLabel then
      partyCodeLabel:setText(string.format('Party Code: %s', state.trio.partyCode))
    end

    if membersLabel then
      membersLabel:setText(string.format('Members:\n[1] %s\n[2] %s\n[3] %s', state.trio.members[1], state.trio.members[2], state.trio.members[3]))
    end

    if createPartyButton then
      createPartyButton.onClick = function()
        sendAction(ACTION_LOBBY_INPUT, {type = 'create_trio'})
      end
    end

    if joinPartyButton then
      joinPartyButton.onClick = function()
        local code = joinCodeEdit and joinCodeEdit:getText() or ''
        sendAction(ACTION_LOBBY_INPUT, {type = 'join_trio', code = tostring(code or '')})
      end
    end

    if readyButton then
      readyButton:setText(state.trio.isReady and 'Unready' or 'Ready')
      readyButton.onClick = function()
        sendAction(ACTION_LOBBY_INPUT, {type = 'toggle_ready'})
      end
    end

    if startTrioButton then
      startTrioButton:setEnabled(hasUnlockedFloor(state.trio.minFloor, state.trio.maxFloor))
      startTrioButton.onClick = function()
        local floorDropdown = trioCard and trioCard:getChildById('floorDropdown')
        local selectedFloor = getSelectedFloorFromDropdown(floorDropdown, state.trio.minFloor, state.trio.maxFloor)
        if not selectedFloor then
          return
        end
        sendAction(ACTION_LOBBY_INPUT, {type = 'start_trio', floor = selectedFloor})
      end
    end

    if leavePartyButton then
      leavePartyButton.onClick = function()
        sendAction(ACTION_LOBBY_INPUT, {type = 'leave_trio'})
      end
    end
  end

  local closeLobbyButton = lobbyWindow:getChildById('closeLobbyButton')
  if closeLobbyButton then
    closeLobbyButton.onClick = function()
      TowerTracker.hideLobby()
    end
  end

  isRenderingLobby = false
end

function TowerTracker.requestLobby()
  sendAction(ACTION_LOBBY_REQUEST, {})
end

function TowerTracker.showLobby(state)
  if not ensureLobbyWindow() then
    return
  end

  renderLobby(state or lobbyState or buildDefaultLobbyState())
  lobbyWindow:show()
  lobbyWindow:raise()
  lobbyWindow:focus()

  if lobbyButton and not lobbyButton:isDestroyed() then
    lobbyButton:setOn(true)
  end
end

function TowerTracker.hideLobby()
  if lobbyWindow and not lobbyWindow:isDestroyed() then
    lobbyWindow:hide()
  end

  if lobbyButton and not lobbyButton:isDestroyed() then
    lobbyButton:setOn(false)
  end
end

showPlaceholderTracker = function()
  if not ensureTracker() then
    return
  end

  local titleLabel = trackerWidget:getChildById('titleLabel')
  if titleLabel then
    titleLabel:setText('Tower Progress')
  end

  local floorLabel = trackerWidget:getChildById('floorLabel')
  if floorLabel then
    floorLabel:setText('Floor: 0')
  end

  local objectiveLabel = trackerWidget:getChildById('objectiveLabel')
  if objectiveLabel then
    objectiveLabel:setText('Objective: waiting for run data')
    objectiveLabel:setColor('#C5E1FF')
  end

  local objectiveProgressBar = trackerWidget:getChildById('objectiveProgressBar')
  if objectiveProgressBar then
    objectiveProgressBar:setPercent(0)
  end

  local timerLabel = trackerWidget:getChildById('timerLabel')
  if timerLabel then
    timerLabel:setText('Time Left: --:--')
    timerLabel:setColor('#C5E1FF')
  end

  local metaLabel = trackerWidget:getChildById('metaLabel')
  if metaLabel then
    metaLabel:setText('Best: 0 | Shards: 0')
  end

  trackerWidget:show()
  trackerWidget:raise()
end

applyTrackerData = function(data)
  if not ensureTracker() then
    return
  end

  local isActive = data and data.active
  if not isActive or trackerHiddenByUser then
    clearTrackerTimerEvent()
    trackerTimerSync = nil
    trackerWidget:hide()
    return
  end

  trackerTimerSync = {
    serverNow = tonumber(data.serverNow) or os.time(),
    clientMs = g_clock.millis()
  }

  local runId = tonumber(data.runId)
  local floor = tonumber(data.floor) or 0
  local objectiveTypeKey = string.lower(tostring(data.objectiveType or 'none'))
  local objectiveType = formatObjectiveName(objectiveTypeKey)
  local objectiveProgress = tonumber(data.objectiveProgress) or 0
  local objectiveGoal = tonumber(data.objectiveGoal) or 0
  local bestFloorWeek = tonumber(data.bestFloorWeek) or 0
  local currency = tonumber(data.currency) or 0
  local biome = tostring(data.biome or '')
  local mutator = tostring(data.mutator or '')

  local titleText = 'Tower Progress'
  if runId then
    titleText = string.format('Tower Run #%d', runId)
  end
  if biome ~= '' and biome ~= 'nil' then
    titleText = titleText .. ' - ' .. biome
  end
  if mutator ~= '' and mutator ~= 'nil' then
    titleText = titleText .. ' [' .. tr(mutator) .. ']'
  end

  local titleLabel = trackerWidget:getChildById('titleLabel')
  if titleLabel then
    titleLabel:setText(titleText)
  end

  local floorLabel = trackerWidget:getChildById('floorLabel')
  if floorLabel then
    floorLabel:setText(string.format('Floor: %d', floor))
  end

  local objectiveLabel = trackerWidget:getChildById('objectiveLabel')
  if objectiveLabel then
    objectiveLabel:setText(string.format('Objective: %s %d/%d', objectiveType, objectiveProgress, objectiveGoal))
    objectiveLabel:setColor(OBJECTIVE_COLORS[objectiveTypeKey] or '#C5E1FF')
  end

  local objectiveProgressBar = trackerWidget:getChildById('objectiveProgressBar')
  if objectiveProgressBar then
    if objectiveGoal > 0 then
      objectiveProgressBar:setValue(objectiveProgress, 0, objectiveGoal)
    else
      objectiveProgressBar:setPercent(0)
    end
  end

  local metaLabel = trackerWidget:getChildById('metaLabel')
  if metaLabel then
    metaLabel:setText(string.format('Best: %d | Shards: %d', bestFloorWeek, currency))
  end

  refreshTrackerTimerLabel()
  startTrackerTimerLoop()

  trackerWidget:show()
  trackerWidget:raise()

  if trackerToggleButton and not trackerToggleButton:isDestroyed() then
    trackerToggleButton:setOn(true)
  end
end

local function onGameEnd()
  trackerData = nil
  clearTrackerTimerEvent()
  trackerTimerSync = nil
  lobbyState = nil
  if trackerWidget and not trackerWidget:isDestroyed() then
    trackerWidget:hide()
  end

  if lobbyWindow and not lobbyWindow:isDestroyed() then
    lobbyWindow:hide()
  end

  if trackerToggleButton and not trackerToggleButton:isDestroyed() then
    trackerToggleButton:setOn(not trackerHiddenByUser)
  end
end

local function onExtendedOpcode(protocol, opcode, buffer)
  if opcode ~= OPCODE_TOWER then
    return
  end

  local packet = parsePacket(buffer)
  if not packet then
    return
  end

  local action, payload = getPayload(packet)

  if action == ACTION_PROGRESS then
    trackerData = payload
    applyTrackerData(trackerData)
    return
  end

  if action == ACTION_LOBBY_OPEN then
    lobbyState = payload
    TowerTracker.showLobby(lobbyState)
    return
  end

  if action == ACTION_LOBBY_UPDATE then
    lobbyState = payload
    if lobbyWindow and not lobbyWindow:isDestroyed() and lobbyWindow:isVisible() then
      renderLobby(lobbyState)
    end
    return
  end

  if action == ACTION_LOBBY_CLOSE then
    TowerTracker.hideLobby()
    return
  end

  trackerData = payload
  applyTrackerData(trackerData)
end

local function onGameStart()
  ensureToggleButton()
  ensureLobbyButton()

  if trackerData then
    applyTrackerData(trackerData)
  elseif trackerWidget and not trackerWidget:isDestroyed() then
    trackerWidget:hide()
  end
end

function init()
  g_ui.importStyle('tower.otui')
  ensureToggleButton()
  ensureLobbyButton()

  connect(g_game, {
    onGameStart = onGameStart,
    onGameEnd = onGameEnd
  })

  ProtocolGame.registerExtendedOpcode(OPCODE_TOWER, onExtendedOpcode)

  if g_game.isOnline() then
    onGameStart()
  end
end

function terminate()
  disconnect(g_game, {
    onGameStart = onGameStart,
    onGameEnd = onGameEnd
  })

  ProtocolGame.unregisterExtendedOpcode(OPCODE_TOWER)
  clearTrackerTimerEvent()
  trackerTimerSync = nil
  trackerData = nil
  lobbyState = nil
  destroyTracker()
  destroyLobby()
  destroyToggleButton()
  destroyLobbyButton()
end
