modules.game_prestige = modules.game_prestige or {}

local Prestige = modules.game_prestige

local OPCODE_PRESTIGE = 150

local ACTION_REQUEST = 'prestige_request'
local ACTION_SELECT  = 'prestige_select'
local ACTION_OPEN    = 'prestige_open'
local ACTION_RESULT  = 'prestige_result'

-- Mode id -> icon path (matches server PrestigeConfig.ModeId)
local MODE_ICONS = {
  [1] = '/data/images/icons/repeat',   -- Prestige Normal / Reborn
  [2] = '/data/images/icons/crown',    -- Hardcore
  [3] = '/data/images/icons/treasure', -- High Risk
  [4] = '/data/images/icons/row-3-column-3',   -- Iron Man
  [5] = '/data/images/icons/row-5-column-3',   -- Nightmare I
  [6] = '/data/images/icons/row-5-column-3',   -- Nightmare II
  [7] = '/data/images/icons/row-5-column-3',   -- Nightmare III
}

local window = nil
local confirmWindow = nil
local currentModes = {}
local selectedModeId = nil
-- Current challenge snapshot (mirrors server PrestigeConfig.ChallengeState)
--   CHALLENGE_STATE_ACTIVE = 1, FAILED = 2, COMPLETED = 3
local activeModeId = 0
local activeState  = 0

local function sendPacket(action, data)
  local protocol = g_game.getProtocolGame()
  if not protocol then return end
  protocol:sendExtendedOpcode(OPCODE_PRESTIGE, json.encode({
    action = action,
    data = data or {},
    modeId = data and data.modeId or nil,
  }))
end

local function findMode(modeId)
  for _, m in ipairs(currentModes) do
    if m.id == modeId then return m end
  end
  return nil
end

local function updateDetail()
  if not window or window:isDestroyed() then return end

  local nameLabel = window:recursiveGetChildById('detailName')
  local availLabel = window:recursiveGetChildById('detailAvailability')
  local descLabel = window:recursiveGetChildById('detailDescription')
  local reqLabel = window:recursiveGetChildById('detailRequirements')
  local selectBtn = window:recursiveGetChildById('selectButton')

  local mode = selectedModeId and findMode(selectedModeId) or nil
  if not mode then
    if nameLabel then nameLabel:setText('Select a mode') end
    if availLabel then availLabel:setText('-') end
    if descLabel then descLabel:setText('-') end
    if reqLabel then reqLabel:setText('-') end
    if selectBtn then selectBtn:setEnabled(false) end
    return
  end

  if nameLabel then nameLabel:setText(mode.name or '-') end

  if availLabel then
    local isOngoing = (activeModeId == mode.id) and (activeState == 1)
    local wasCompleted = (activeModeId == 0) and mode.__completed -- placeholder (not used currently)
    if isOngoing then
      availLabel:setText('Status: ONGOING - Challenge in progress.')
      availLabel:setColor('#F2C72A') -- amber/gold
    elseif mode.unlocked then
      availLabel:setText('Status: AVAILABLE')
      availLabel:setColor('#9FD49F')
    else
      availLabel:setText('Status: LOCKED - ' .. (mode.lockedReason or 'requirements not met'))
      availLabel:setColor('#D47A7A')
    end
  end

  if descLabel then descLabel:setText(mode.description or '-') end

  if reqLabel then
    local lines = {}
    if type(mode.requirements) == 'table' then
      for _, line in ipairs(mode.requirements) do
        lines[#lines + 1] = '- ' .. tostring(line)
      end
    end
    if #lines == 0 then lines[#lines + 1] = '- Minimum level ' .. tostring(mode.minLevel or '-') end
    reqLabel:setText(table.concat(lines, '\n'))
  end

  -- Block selecting a new prestige while any challenge is ongoing (server enforces too).
  local anyOngoing = (activeState == 1) and (activeModeId > 0)
  if selectBtn then
    selectBtn:setEnabled((mode.unlocked and not anyOngoing) and true or false)
  end
end

local function selectMode(modeId)
  selectedModeId = modeId
  updateDetail()
end

local function onModeEntryFocus(widget, focused)
  if focused and widget.modeId then
    selectMode(widget.modeId)
  end
end

local function onModeEntryPress(widget)
  if widget.modeId then
    widget:focus()
    selectMode(widget.modeId)
  end
end

local function rebuildList()
  if not window or window:isDestroyed() then return end
  local list = window:recursiveGetChildById('modeList')
  if not list then return end
  list:destroyChildren()

  local firstUnlockedId = nil
  local firstId = nil

  for _, mode in ipairs(currentModes) do
    local entry = g_ui.createWidget('PrestigeModeEntry', list)
    entry.modeId = mode.id

    local isOngoing = (activeModeId == mode.id) and (activeState == 1)

    local nameLabel = entry:getChildById('modeName')
    if nameLabel then
      local displayName = mode.name or ('Mode ' .. tostring(mode.id))
      if isOngoing then
        displayName = displayName .. '  [ONGOING]'
        nameLabel:setColor('#F2C72A') -- amber/gold
      else
        nameLabel:setColor(mode.unlocked and '#FFFFFF' or '#888888')
      end
      nameLabel:setText(displayName)
    end

    local iconWidget = entry:getChildById('modeIcon')
    if iconWidget then
      local iconPath = MODE_ICONS[mode.id]
      if iconPath and iconPath ~= '' then
        iconWidget:setImageSource(iconPath)
      end
      iconWidget:setOpacity((isOngoing or mode.unlocked) and 1.0 or 0.4)
    end

    -- Illuminated row background for the ongoing challenge.
    if isOngoing then
      entry:setBackgroundColor('#5A4A1EAA')
      entry:setBorderColor('#F2C72A')
      entry:setBorderWidth(1)
    end

    entry.onFocusChange = onModeEntryFocus
    entry.onMousePress = onModeEntryPress
    entry.onClick = onModeEntryPress

    firstId = firstId or mode.id
    if mode.unlocked and not firstUnlockedId then
      firstUnlockedId = mode.id
    end
  end

  -- Reapply previous selection if still present; otherwise prefer the ongoing challenge,
  -- falling back to the first unlocked (or first) entry.
  if selectedModeId and not findMode(selectedModeId) then
    selectedModeId = nil
  end
  if not selectedModeId then
    if activeModeId and activeModeId > 0 and findMode(activeModeId) then
      selectedModeId = activeModeId
    else
      selectedModeId = firstUnlockedId or firstId
    end
  end

  if selectedModeId then
    for _, child in ipairs(list:getChildren()) do
      if child.modeId == selectedModeId then
        child:focus()
        break
      end
    end
  end

  updateDetail()
end

local function closeConfirm()
  if confirmWindow and not confirmWindow:isDestroyed() then
    confirmWindow:hide()
  end
end

local function openConfirm(mode)
  if not mode then return end

  if confirmWindow and not confirmWindow:isDestroyed() then
    confirmWindow:destroy()
  end

  local parent = rootWidget
  if modules.game_interface and modules.game_interface.getRootPanel then
    parent = modules.game_interface.getRootPanel() or rootWidget
  end

  confirmWindow = g_ui.createWidget('PrestigeConfirmWindow', parent)
  local text = confirmWindow:recursiveGetChildById('confirmText')
  local yes = confirmWindow:recursiveGetChildById('confirmYes')
  local no = confirmWindow:recursiveGetChildById('confirmNo')

  if text then
    text:setText(string.format(
      '%s\n\nThis will RESET your character (level, skills, talents, quests).\nThis action is IRREVERSIBLE.\n\nConfirm?',
      mode.name or ('Mode ' .. tostring(mode.id))
    ))
  end

  if yes then
    yes.onClick = function()
      closeConfirm()
      sendPacket(ACTION_SELECT, { modeId = mode.id })
    end
  end

  if no then
    no.onClick = closeConfirm
  end

  confirmWindow:show()
  confirmWindow:raise()
  confirmWindow:focus()
end

local MODE_DISPLAY_NAMES = {
  [1] = 'Prestige Rebirth',
  [2] = 'Hardcore Challenge',
  [3] = 'High Risk',
  [4] = 'Iron Man',
  [5] = 'Nightmare I',
  [6] = 'Nightmare II',
  [7] = 'Nightmare III',
}

local function applyPayload(payload)
  payload = payload or {}
  currentModes = payload.modes or {}
  activeModeId = tonumber(payload.activeMode) or 0
  activeState  = tonumber(payload.challengeState) or 0

  local statusLabel = window and window:recursiveGetChildById('statusLabel')
  if statusLabel then
    local baseText = string.format(
      'Total prestiges: %d | Hardcore completions: %d',
      tonumber(payload.totalPrestiges) or 0,
      tonumber(payload.hardcoreCompletions) or 0
    )
    if activeModeId > 0 and activeState == 1 then
      local name = MODE_DISPLAY_NAMES[activeModeId] or ('Mode ' .. activeModeId)
      statusLabel:setText('ONGOING: ' .. name .. '  |  ' .. baseText)
      statusLabel:setColor('#F2C72A')
    else
      statusLabel:setText(baseText)
      statusLabel:setColor('#E7CF7A')
    end
  end

  -- If a challenge is ongoing, auto-focus that mode on open so the user sees their progress first.
  if activeModeId > 0 and activeState == 1 then
    selectedModeId = activeModeId
  end

  rebuildList()
end

local function ensureWindow()
  if window and not window:isDestroyed() then return true end

  local parent = rootWidget
  if modules.game_interface and modules.game_interface.getRootPanel then
    parent = modules.game_interface.getRootPanel() or rootWidget
  end

  window = g_ui.createWidget('PrestigeWindow', parent)
  window:hide()

  local selectBtn = window:recursiveGetChildById('selectButton')
  if selectBtn then
    selectBtn.onClick = function()
      local mode = selectedModeId and findMode(selectedModeId) or nil
      if not mode then return end
      if not mode.unlocked then
        if modules.game_textmessage then
          modules.game_textmessage.displayStatusMessage(mode.lockedReason or 'Mode locked.')
        end
        return
      end
      openConfirm(mode)
    end
  end

  local cancelBtn = window:recursiveGetChildById('cancelButton')
  if cancelBtn then
    cancelBtn.onClick = function() Prestige.hide() end
  end

  return true
end

function Prestige.show()
  ensureWindow()
  window:show()
  window:raise()
  window:focus()
  sendPacket(ACTION_REQUEST)
end

function Prestige.hide()
  closeConfirm()
  if window and not window:isDestroyed() then
    window:hide()
  end
end

local function onExtendedOpcode(protocol, opcode, buffer)
  if opcode ~= OPCODE_PRESTIGE then return end

  local ok, packet = pcall(function() return json.decode(buffer) end)
  if not ok or type(packet) ~= 'table' then return end

  if packet.action == ACTION_OPEN then
    ensureWindow()
    window:show()
    window:raise()
    window:focus()
    applyPayload(packet.data)
    if packet.feedback and packet.feedback ~= '' and modules.game_textmessage then
      modules.game_textmessage.displayStatusMessage(packet.feedback)
    end
    return
  end

  if packet.action == ACTION_RESULT then
    local data = packet.data or {}
    if modules.game_textmessage and data.message and data.message ~= '' then
      modules.game_textmessage.displayStatusMessage(data.message)
    end
    if data.success then
      -- Server will teleport/remove player; close UI.
      Prestige.hide()
    else
      -- Refresh modes list (requirements may have changed)
      if data.modes then
        currentModes = data.modes
        rebuildList()
      end
    end
    return
  end
end

function init()
  g_ui.importStyle('prestige.otui')

  connect(g_game, { onGameEnd = Prestige.hide })

  ProtocolGame.registerExtendedOpcode(OPCODE_PRESTIGE, onExtendedOpcode)
end

function terminate()
  disconnect(g_game, { onGameEnd = Prestige.hide })

  ProtocolGame.unregisterExtendedOpcode(OPCODE_PRESTIGE)

  if confirmWindow and not confirmWindow:isDestroyed() then
    confirmWindow:destroy()
  end
  confirmWindow = nil

  if window and not window:isDestroyed() then
    window:destroy()
  end
  window = nil
end
