CombatMeter = CombatMeter or {}

local OPCODE_COMBAT_METER = 221
local SETTINGS_NODE = 'CombatMeter'
local SETTINGS_UI_OPTIONS_KEY = 'uiOptions'
local DPS_WINDOW_MS = 5000
local DPS_WINDOW_SECONDS = DPS_WINDOW_MS / 1000

local combatWindow = nil
local optionsWindow = nil
local combatButton = nil
local dpsRenderEvent = nil
local currentTab = "damage"
local rows = {}
local dpsState = {
  points = {},
  lastFightTime = 0,
  lastMode = 'solo',
}
local clientUiOptions = {
  compactNumbers = true,
  showPercent = true,
  showHitsInValue = false,
}
local snapshot = {
  mode = "solo",
  fightTime = 0,
  damage = {},
  healing = {},
  options = {
    includeSummons = true,
    autoResetOnPartyChange = false,
    scope = 'party',
  }
}

local function normalizeScope(scope)
  local value = tostring(scope or 'party'):lower()
  if value == 'solo' or value == 'party' or value == 'all' then
    return value
  end

  return 'party'
end

local function parseBoolean(value, fallback)
  if type(value) == 'boolean' then
    return value
  end
  if type(value) == 'number' then
    return value ~= 0
  end
  if type(value) == 'string' then
    local lowered = value:lower()
    if lowered == '1' or lowered == 'true' or lowered == 'yes' or lowered == 'on' then
      return true
    end
    if lowered == '0' or lowered == 'false' or lowered == 'no' or lowered == 'off' then
      return false
    end
  end

  return fallback == true
end

local function saveClientUiOptions()
  local settings = g_settings.getNode(SETTINGS_NODE)
  if type(settings) ~= 'table' then
    settings = {}
  end

  settings[SETTINGS_UI_OPTIONS_KEY] = {
    compactNumbers = clientUiOptions.compactNumbers == true,
    showPercent = clientUiOptions.showPercent == true,
    showHitsInValue = clientUiOptions.showHitsInValue == true,
  }

  g_settings.setNode(SETTINGS_NODE, settings)
end

local function loadClientUiOptions()
  local settings = g_settings.getNode(SETTINGS_NODE)
  if type(settings) ~= 'table' then
    return
  end

  local options = settings[SETTINGS_UI_OPTIONS_KEY]
  if type(options) ~= 'table' then
    return
  end

  clientUiOptions.compactNumbers = parseBoolean(options.compactNumbers, clientUiOptions.compactNumbers)
  clientUiOptions.showPercent = parseBoolean(options.showPercent, clientUiOptions.showPercent)
  clientUiOptions.showHitsInValue = parseBoolean(options.showHitsInValue, clientUiOptions.showHitsInValue)
end

local function nextScope(scope)
  local current = normalizeScope(scope)
  if current == 'solo' then
    return 'party'
  elseif current == 'party' then
    return 'all'
  end

  return 'solo'
end

local function scopeLabel(scope)
  local normalized = normalizeScope(scope)
  if normalized == 'all' then
    return 'ALL (Global Top)'
  elseif normalized == 'party' then
    return 'PARTY'
  end

  return 'SOLO'
end

local function formatTime(seconds)
  local value = math.max(0, math.floor(tonumber(seconds) or 0))
  local minutes = math.floor(value / 60)
  local secs = value % 60
  return string.format('%02d:%02d', minutes, secs)
end

local function formatShortNumber(value)
  local amount = math.max(0, tonumber(value) or 0)
  if amount >= 1000000 then
    return string.format('%.1fM', amount / 1000000)
  end
  if amount >= 1000 then
    return string.format('%.1fK', amount / 1000)
  end
  return tostring(math.floor(amount + 0.5))
end

local function formatValue(total)
  if clientUiOptions.compactNumbers then
    return formatShortNumber(total)
  end

  return tostring(math.floor(math.max(0, tonumber(total) or 0)))
end

local function formatDpsValue(value)
  local dps = math.max(0, tonumber(value) or 0)
  if clientUiOptions.compactNumbers and dps >= 1000 then
    return formatShortNumber(dps)
  end

  return string.format('%.1f', dps)
end

local function clamp(value, minValue, maxValue)
  if value < minValue then
    return minValue
  end
  if value > maxValue then
    return maxValue
  end
  return value
end

local function resetDpsState()
  dpsState.points = {}
  dpsState.lastFightTime = 0
  dpsState.lastMode = snapshot.mode or 'solo'
end

local function keyForGuid(guid)
  return tostring(guid or 0)
end

local function pruneDpsPoints(nowMs)
  local cutoff = nowMs - DPS_WINDOW_MS
  for guidKey, pointList in pairs(dpsState.points) do
    local firstInside = nil
    for i = 1, #pointList do
      local point = pointList[i]
      if point and (tonumber(point.t) or 0) >= cutoff then
        firstInside = i
        break
      end
    end

    if firstInside and firstInside > 1 then
      local keepFrom = firstInside - 1
      local writeIndex = 1
      for i = keepFrom, #pointList do
        pointList[writeIndex] = pointList[i]
        writeIndex = writeIndex + 1
      end
      while #pointList >= writeIndex do
        pointList[#pointList] = nil
      end
    elseif not firstInside and #pointList > 1 then
      local lastPoint = pointList[#pointList]
      pointList[1] = lastPoint
      while #pointList > 1 do
        pointList[#pointList] = nil
      end
    end

    if #pointList == 0 then
      dpsState.points[guidKey] = nil
    end
  end
end

local function ingestDpsSnapshot(damageRows, fightTime, mode)
  local nowMs = g_clock.millis()
  local currentFightTime = math.max(0, tonumber(fightTime) or 0)
  local currentMode = tostring(mode or 'solo')

  if currentMode ~= dpsState.lastMode or currentFightTime < (tonumber(dpsState.lastFightTime) or 0) then
    resetDpsState()
  end

  local rowsData = type(damageRows) == 'table' and damageRows or {}

  for i = 1, #rowsData do
    local entry = rowsData[i]
    local guidKey = keyForGuid(entry.guid)
    local total = math.max(0, tonumber(entry.total) or 0)
    local pointList = dpsState.points[guidKey]
    if type(pointList) ~= 'table' then
      pointList = {}
      dpsState.points[guidKey] = pointList
    end

    local previousPoint = pointList[#pointList]
    local previousTotal = previousPoint and math.max(0, tonumber(previousPoint.total) or 0) or nil
    if previousTotal == nil or total ~= previousTotal or #pointList == 0 then
      pointList[#pointList + 1] = {
        t = nowMs,
        total = total,
      }
    elseif previousPoint then
      previousPoint.t = nowMs
    end
  end

  dpsState.lastFightTime = currentFightTime
  dpsState.lastMode = currentMode
  pruneDpsPoints(nowMs)
end

local function getTotalAtTime(pointList, queryMs)
  if type(pointList) ~= 'table' or #pointList == 0 then
    return 0
  end

  if queryMs <= (tonumber(pointList[1].t) or 0) then
    return math.max(0, tonumber(pointList[1].total) or 0)
  end

  local lastPoint = pointList[#pointList]
  local lastT = tonumber(lastPoint.t) or 0
  local lastTotal = math.max(0, tonumber(lastPoint.total) or 0)
  if queryMs >= lastT then
    return lastTotal
  end

  for i = 2, #pointList do
    local left = pointList[i - 1]
    local right = pointList[i]
    local leftT = tonumber(left.t) or 0
    local rightT = tonumber(right.t) or leftT
    if queryMs <= rightT then
      local leftTotal = math.max(0, tonumber(left.total) or 0)
      local rightTotal = math.max(0, tonumber(right.total) or 0)
      local span = rightT - leftT
      if span <= 0 then
        return rightTotal
      end
      local alpha = clamp((queryMs - leftT) / span, 0, 1)
      return leftTotal + ((rightTotal - leftTotal) * alpha)
    end
  end

  return lastTotal
end

local function getRollingDpsForGuid(guid)
  local nowMs = g_clock.millis()
  pruneDpsPoints(nowMs)

  local pointList = dpsState.points[keyForGuid(guid)]
  if type(pointList) ~= 'table' or #pointList == 0 then
    return 0
  end

  local latestTotal = math.max(0, tonumber(pointList[#pointList].total) or 0)
  local cutoff = nowMs - DPS_WINDOW_MS
  local cutoffTotal = getTotalAtTime(pointList, cutoff)
  local damageInWindow = math.max(0, latestTotal - cutoffTotal)

  return damageInWindow / DPS_WINDOW_SECONDS
end

local function buildDpsRows()
  local damageRows = type(snapshot.damage) == 'table' and snapshot.damage or {}
  local dpsRows = {}

  for i = 1, #damageRows do
    local entry = damageRows[i]
    dpsRows[#dpsRows + 1] = {
      guid = entry.guid,
      name = entry.name,
      vocation = entry.vocation,
      total = getRollingDpsForGuid(entry.guid),
      hits = entry.hits,
      rawTotal = math.max(0, tonumber(entry.total) or 0),
    }
  end

  table.sort(dpsRows, function(a, b)
    local aTotal = tonumber(a.total) or 0
    local bTotal = tonumber(b.total) or 0
    if aTotal == bTotal then
      return tostring(a.name or '') < tostring(b.name or '')
    end
    return aTotal > bTotal
  end)

  return dpsRows
end

local function getVocationColorHex(vocationId, isHealing)
  local voc = tonumber(vocationId) or 0

  if voc == 1 or voc == 5 then -- sorcerer / master sorcerer
    return '#50A0FF'
  elseif voc == 2 or voc == 6 then -- druid / elder druid
    return '#48C780'
  elseif voc == 3 or voc == 7 then -- paladin / royal paladin
    return '#FFD166'
  elseif voc == 4 or voc == 8 then -- knight / elite knight
    return '#E46A6A'
  elseif voc == 9 or voc == 10 then -- optional custom voc ids
    return '#C88CFF'
  end

  if isHealing then
    return '#5BBF7A'
  end

  return '#7A94D9'
end

local function sendTopic(topic, data)
  local protocol = g_game.getProtocolGame()
  if not protocol then
    return
  end

  protocol:sendExtendedJSONOpcode(OPCODE_COMBAT_METER, {
    topic = topic,
    data = data or {}
  })
end

local function clearRows()
  for i = 1, #rows do
    local row = rows[i]
    if row and not row:isDestroyed() then
      row:destroy()
    end
  end
  rows = {}
end

local function setTabButtonState()
  if not combatWindow then
    return
  end

  local function setActiveTabVisual(button, active)
    if not button then
      return
    end

    button:setOn(active)
    if active then
      button:setBackgroundColor('#2ECC71')
    else
      button:setBackgroundColor('#1F1F1F')
    end
  end

  local damageTab = combatWindow:getChildById('damageTab')
  local healingTab = combatWindow:getChildById('healingTab')
  local dpsTab = combatWindow:getChildById('dpsTab')
  setActiveTabVisual(damageTab, currentTab == 'damage')
  setActiveTabVisual(healingTab, currentTab == 'healing')
  setActiveTabVisual(dpsTab, currentTab == 'dps')
end

local function updateOptionsWindowState()
  if not optionsWindow then
    return
  end

  local scope = normalizeScope(snapshot.options.scope)
  local autoReset = snapshot.options.autoResetOnPartyChange == true

  local summary = optionsWindow:getChildById('summaryLabel')
  if summary then
    summary:setText(string.format(
      'Server filters\n- Scope: %s\n- Auto reset on party change: %s\n\nDisplay\n- Compact numbers: %s\n- Show percent: %s\n- Show hits in value: %s',
      scopeLabel(scope),
      autoReset and 'ON' or 'OFF',
      clientUiOptions.compactNumbers and 'ON' or 'OFF',
      clientUiOptions.showPercent and 'ON' or 'OFF',
      clientUiOptions.showHitsInValue and 'ON' or 'OFF'
    ))
  end

  local autoResetButton = optionsWindow:getChildById('autoResetButton')
  if autoResetButton then
    autoResetButton:setText(autoReset and 'Disable Auto Reset' or 'Enable Auto Reset')
  end

  local scopeButton = optionsWindow:getChildById('scopeButton')
  if scopeButton then
    scopeButton:setText('Scope: ' .. scopeLabel(nextScope(scope)))
  end

  local compactButton = optionsWindow:getChildById('compactNumbersButton')
  if compactButton then
    compactButton:setText(clientUiOptions.compactNumbers and 'Compact Numbers: ON' or 'Compact Numbers: OFF')
  end

  local percentButton = optionsWindow:getChildById('showPercentButton')
  if percentButton then
    percentButton:setText(clientUiOptions.showPercent and 'Show Percent: ON' or 'Show Percent: OFF')
  end

  local hitsButton = optionsWindow:getChildById('showHitsButton')
  if hitsButton then
    hitsButton:setText(clientUiOptions.showHitsInValue and 'Show Hits in Value: ON' or 'Show Hits in Value: OFF')
  end
end

local function renderRows()
  if not combatWindow then
    return
  end

  local listPanel = combatWindow:getChildById('listPanel')
  if not listPanel then
    return
  end

  clearRows()

  local source = nil
  if currentTab == 'healing' then
    source = snapshot.healing
  elseif currentTab == 'dps' then
    source = buildDpsRows()
  else
    source = snapshot.damage
  end

  if type(source) ~= 'table' then
    source = {}
  end

  if #source == 0 then
    local empty = g_ui.createWidget('Label', listPanel)
    empty:setId('combatMeterEmptyRow')
    empty:setText('No data yet')
    empty:setColor('#888888')
    empty:setFont('verdana-11px-antialised')
    empty:setHeight(20)
    empty:setTextAlign(AlignCenter)
    rows[#rows + 1] = empty
    return
  end

  local topValue = tonumber(source[1].total) or 1
  if topValue <= 0 then
    topValue = 1
  end

  local rowWidth = math.max(188, listPanel:getWidth() - 6)
  local barMaxWidth = math.max(0, rowWidth - 4)
  local isHealingTab = currentTab == 'healing'
  local isDpsTab = currentTab == 'dps'
  local minBarWidth = 10

  for i = 1, #source do
    local entry = source[i]
    local name = tostring(entry.name or ('Player ' .. tostring(entry.guid or i)))
    local total = math.max(0, tonumber(entry.total) or 0)
    local rawTotal = math.max(0, tonumber(entry.rawTotal) or 0)
    local hits = math.max(0, tonumber(entry.hits) or 0)
    local pct = clamp(total / topValue, 0, 1)
    local pctText = math.floor((pct * 100) + 0.5)
    local colorHex = getVocationColorHex(entry.vocation, isHealingTab)

    local row = g_ui.createWidget('CombatMeterRow', listPanel)
    row:setWidth(rowWidth)

    if i == 1 then
      row:setBackgroundColor('#202020EE')
      row:setBorderWidth(2)
      row:setBorderColor(colorHex)
    elseif i % 2 == 0 then
      row:setBackgroundColor('#171717D8')
      row:setBorderColor('#313131')
    else
      row:setBackgroundColor('#101010D8')
      row:setBorderColor('#2A2A2A')
    end

    local bar = row:getChildById('bar')
    if bar then
      local barWidth = math.floor(barMaxWidth * pct)
      if total > 0 then
        barWidth = math.max(minBarWidth, barWidth)
      end
      barWidth = math.min(barMaxWidth, barWidth)
      bar:setWidth(barWidth)
      bar:setBackgroundColor(colorHex .. 'CC')
    end

    local nameLabel = row:getChildById('nameLabel')
    if nameLabel then
      nameLabel:setText(string.format('%d. %s', i, name))
      if i == 1 then
        nameLabel:setColor('#FFF4C2')
      else
        nameLabel:setColor('#F2F2F2')
      end
    end

    local valueLabel = row:getChildById('valueLabel')
    if valueLabel then
      local parts = { isDpsTab and (formatDpsValue(total) .. '/s') or formatValue(total) }
      if clientUiOptions.showPercent then
        parts[#parts + 1] = string.format('%d%%', pctText)
      end
      if clientUiOptions.showHitsInValue then
        parts[#parts + 1] = string.format('%dh', hits)
      end
      valueLabel:setText(table.concat(parts, ' | '))
      valueLabel:setColor('#FFFFFF')
      if isDpsTab then
        local fightSeconds = math.max(1, tonumber(snapshot.fightTime) or 0)
        valueLabel:setTooltip(string.format('DPS: %.2f\nTotal Damage: %d\nFight Time: %s\nHits: %d', total, rawTotal, formatTime(fightSeconds), hits))
      else
        valueLabel:setTooltip(string.format('Total: %d\nHits: %d', total, hits))
      end
    end

    rows[#rows + 1] = row
  end
end

local function applySnapshot(data)
  if type(data) ~= 'table' then
    return
  end

  snapshot.mode = tostring(data.mode or snapshot.mode or 'solo')
  snapshot.fightTime = tonumber(data.fightTime) or 0
  snapshot.damage = type(data.damage) == 'table' and data.damage or {}
  snapshot.healing = type(data.healing) == 'table' and data.healing or {}

  ingestDpsSnapshot(snapshot.damage, snapshot.fightTime, snapshot.mode)

  if type(data.options) == 'table' then
    snapshot.options.includeSummons = data.options.includeSummons == true
    snapshot.options.autoResetOnPartyChange = data.options.autoResetOnPartyChange == true
    snapshot.options.scope = normalizeScope(data.options.scope)
  end

  updateOptionsWindowState()

  if combatWindow then
    local modeLabel = combatWindow:getChildById('modeLabel')
    local timeLabel = combatWindow:getChildById('timeLabel')

    if modeLabel then
      local modeText = 'Solo'
      if snapshot.mode == 'party' then
        modeText = 'Party'
      elseif snapshot.mode == 'all' then
        modeText = 'All (Global Top)'
      end
      modeLabel:setText(string.format('Mode: %s', modeText))
    end

    if timeLabel then
      timeLabel:setText(formatTime(snapshot.fightTime))
    end

    renderRows()
  end
end

local function onExtendedOpcode(protocol, opcode, packet)
  if opcode ~= OPCODE_COMBAT_METER then
    return
  end

  if type(packet) ~= 'table' then
    return
  end

  local topic = packet.topic
  if topic == 'snapshot' then
    applySnapshot(packet.data)
    return
  end

  if type(packet.data) == 'table' then
    applySnapshot(packet.data)
  end
end

local function toggleWindow()
  if not combatWindow then
    return
  end

  if combatWindow:isVisible() then
    combatWindow:hide()
    if optionsWindow then
      optionsWindow:hide()
    end
    if combatButton then
      combatButton:setOn(false)
    end
    return
  end

  combatWindow:show()
  combatWindow:raise()
  combatWindow:focus()

  if combatButton then
    combatButton:setOn(true)
  end

  sendTopic('open', {})
end

local function openOptionsDialog()
  if not optionsWindow then
    return
  end

  updateOptionsWindowState()
  optionsWindow:show()
  optionsWindow:raise()
  optionsWindow:focus()
end

local function bindWindowEvents()
  if not combatWindow then
    return
  end

  local damageTab = combatWindow:getChildById('damageTab')
  local healingTab = combatWindow:getChildById('healingTab')
  local dpsTab = combatWindow:getChildById('dpsTab')
  local resetButton = combatWindow:getChildById('resetButton')
  local optionsButton = combatWindow:getChildById('optionsButton')
  local closeButton = combatWindow:getChildById('closeButton')

  if optionsWindow then
    local autoResetButton = optionsWindow:getChildById('autoResetButton')
    local scopeButton = optionsWindow:getChildById('scopeButton')
    local compactNumbersButton = optionsWindow:getChildById('compactNumbersButton')
    local showPercentButton = optionsWindow:getChildById('showPercentButton')
    local showHitsButton = optionsWindow:getChildById('showHitsButton')
    local closeOptionsButton = optionsWindow:getChildById('closeOptionsButton')

    if autoResetButton then
      autoResetButton.onClick = function()
        sendTopic('options', {
          autoResetOnPartyChange = not snapshot.options.autoResetOnPartyChange,
          scope = normalizeScope(snapshot.options.scope),
        })
      end
    end

    if scopeButton then
      scopeButton.onClick = function()
        sendTopic('options', {
          autoResetOnPartyChange = snapshot.options.autoResetOnPartyChange,
          scope = nextScope(snapshot.options.scope),
        })
      end
    end

    if compactNumbersButton then
      compactNumbersButton.onClick = function()
        clientUiOptions.compactNumbers = not clientUiOptions.compactNumbers
        saveClientUiOptions()
        updateOptionsWindowState()
        renderRows()
      end
    end

    if showPercentButton then
      showPercentButton.onClick = function()
        clientUiOptions.showPercent = not clientUiOptions.showPercent
        saveClientUiOptions()
        updateOptionsWindowState()
        renderRows()
      end
    end

    if showHitsButton then
      showHitsButton.onClick = function()
        clientUiOptions.showHitsInValue = not clientUiOptions.showHitsInValue
        saveClientUiOptions()
        updateOptionsWindowState()
        renderRows()
      end
    end

    if closeOptionsButton then
      closeOptionsButton.onClick = function()
        optionsWindow:hide()
      end
    end
  end

  if damageTab then
    damageTab.onClick = function()
      currentTab = 'damage'
      if dpsRenderEvent then
        removeEvent(dpsRenderEvent)
        dpsRenderEvent = nil
      end
      setTabButtonState()
      renderRows()
    end
  end

  if healingTab then
    healingTab.onClick = function()
      currentTab = 'healing'
      if dpsRenderEvent then
        removeEvent(dpsRenderEvent)
        dpsRenderEvent = nil
      end
      setTabButtonState()
      renderRows()
    end
  end

  if dpsTab then
    dpsTab.onClick = function()
      currentTab = 'dps'

      if dpsRenderEvent then
        removeEvent(dpsRenderEvent)
        dpsRenderEvent = nil
      end

      local function dpsTick()
        if not combatWindow or combatWindow:isDestroyed() or not combatWindow:isVisible() or currentTab ~= 'dps' then
          dpsRenderEvent = nil
          return
        end

        renderRows()
        dpsRenderEvent = scheduleEvent(dpsTick, 250)
      end

      dpsRenderEvent = scheduleEvent(dpsTick, 250)
      setTabButtonState()
      renderRows()
    end
  end

  if resetButton then
    resetButton.onClick = function()
      sendTopic('reset', {})
    end
  end

  if optionsButton then
    optionsButton.onClick = openOptionsDialog
  end

  if closeButton then
    closeButton.onClick = function()
      combatWindow:hide()
      if dpsRenderEvent then
        removeEvent(dpsRenderEvent)
        dpsRenderEvent = nil
      end
      if optionsWindow then
        optionsWindow:hide()
      end
      if combatButton then
        combatButton:setOn(false)
      end
    end
  end

  setTabButtonState()
  updateOptionsWindowState()
end

local function create()
  if combatWindow then
    return
  end

  combatWindow = g_ui.displayUI('combat_meter')
  combatWindow:hide()

  if not optionsWindow then
    optionsWindow = g_ui.createWidget('CombatMeterOptionsWindow', g_ui.getRootWidget())
    optionsWindow:hide()
  end

  if not combatButton then
    combatButton = modules.game_mainpanel.addStoreButton(
      'combatMeterButton',
      tr('Combat Meter'),
      '/images/options/task_large',
      toggleWindow,
      false,
      7
    )
    combatButton:setOn(false)
  end

  bindWindowEvents()
  applySnapshot(snapshot)
end

local function destroy()
  if dpsRenderEvent then
    removeEvent(dpsRenderEvent)
    dpsRenderEvent = nil
  end

  resetDpsState()

  clearRows()

  if optionsWindow then
    optionsWindow:destroy()
    optionsWindow = nil
  end

  if combatWindow then
    combatWindow:destroy()
    combatWindow = nil
  end

  if combatButton then
    combatButton:destroy()
    combatButton = nil
  end
end

local function onGameStart()
  create()
  sendTopic('requestSnapshot', {})
end

local function onGameEnd()
  destroy()
end

function init()
  loadClientUiOptions()

  connect(g_game, {
    onGameStart = onGameStart,
    onGameEnd = onGameEnd,
  })

  ProtocolGame.registerExtendedJSONOpcode(OPCODE_COMBAT_METER, onExtendedOpcode)

  if g_game.isOnline() then
    onGameStart()
  end
end

function terminate()
  saveClientUiOptions()

  disconnect(g_game, {
    onGameStart = onGameStart,
    onGameEnd = onGameEnd,
  })

  ProtocolGame.unregisterExtendedJSONOpcode(OPCODE_COMBAT_METER)
  destroy()
end
