  taskListsWindow = nil
taskDescriptionWindow = nil

local askWidget = nil
local taskListButton = nil
local localTaskList = {}
local localTaskWdgList = {}

local localRewardItemList = {}
local selectedChoiceByTask = {} -- taskNumber -> choiceIndex (1-based)
local choiceWidgetsByTask = {}   -- taskNumber -> { widget list }
local taskRewardItemPanel = nil
local npcRewardItemPanel = nil
local questCompletedWidget = nil

local lastOpcode = 0
local npcSelectedTask = 0
local currentSelectedTask = 0
local npcTaskDescription = nil
local npcTaskWidget = nil
-- Track selection by taskNumber so we can remap the row if it moves between Active/Completed
local npcSelectedTaskNumber = 0
-- Auto-refresh handle for NPC window
local npcAutoRefreshEvent = nil
local npcTaskList = {}
local npcRewardList = {}
local npcUnifiedActiveList = {}
local npcUnifiedCooldownList = {}
local npcUnifiedSelectedKind = nil -- 'available' | 'active' | 'completed' | 'cooldown'
local deleteButton = nil
local MaxTaskList = 15
local zoneSections = {} -- zoneName -> { header=widget, content=widget, expanded=bool }
local selectedListIndex = nil -- index within localTaskList for highlight
local searchQuery = ''
local levelFilterMode = 0 -- 0: All, 1: <= My Level, 2: +/- 5 Levels
local opsRegistered = false -- avoid double registration on hot reloads
-- Cache of last unified NPC data for optimistic updates
local lastUnified = { available = {}, active = {}, completed = {} }
-- Tunables
local ACCEPT_LOCK_TIMEOUT_MS = 600 -- how long to lock Accept/Claim after sending
local REFRESH_PINGS_MS = { 0, 100, 200, 400 } -- when to ping ClientGetTaskList after accept
local PROCESSING_LABEL = 'Processing...'
-- Debounce/lock while sending accept/claim to server
local actionInFlight = false
-- After accepting from Available, focus the next available quest when UI refreshes
local focusNextAvailableAfterAccept = false
-- If server asks to close the NPC window, defer until we confirm there are no tasks left after refresh
-- We no longer auto-close on server signal; user controls closing via the Close button
local function setAcceptState(label, enabled)
  if not npcTaskWidget then return end
  local ab = npcTaskWidget:recursiveGetChildById('acceptButton')
  if not ab then return end
  if label then pcall(function() ab:setText(tr(label)) end) end
  if enabled ~= nil then pcall(function() ab:setEnabled(enabled) end) end
end

local function dbg(msg)
  local s = '[QuestUI] ' .. tostring(msg)
  -- Print to client console only; do NOT send chat to server to avoid packet spam
  pcall(function() print(s) end)
end

-- Progress bar helper: set width to parent's inner width times pct
local function setProgressBar(p, pb, pct)
  if not p or not pb then return end
  p:setVisible(true)
  local w = 0
  pcall(function()
    w = (p.getWidth and p:getWidth()) or 0
    if w <= 0 and p.getSize then
      local sz = p:getSize(); if sz and sz.width then w = sz.width end
    end
  end)
  local clamped = math.max(0, math.min(1, pct or 0))
  -- Account for 1px border on each side so fill aligns with inner edge
  local inner = math.max(0, (w or 0) - 2)
  local target = (clamped >= 0.999) and inner or math.floor(inner * clamped)
  pcall(function() pb:setWidth(target) end)
  -- If width was not final yet (layout not settled), reapply at next frame for 100%
  if clamped >= 0.999 and addEvent then
    addEvent(function()
      local ww = 0
      pcall(function()
        ww = (p.getWidth and p:getWidth()) or 0
        if ww <= 0 and p.getSize then local sz = p:getSize(); if sz and sz.width then ww = sz.width end end
      end)
      local i2 = math.max(0, (ww or 0) - 2)
      pcall(function() pb:setWidth(i2) end)
    end)
  end
end

-- Build/refresh unified NPC window UI from parsed lists
function buildUnifiedNpcUI(parsed)
  -- Ensure expansion state exists even if this runs before the global is defined
  statusExpanded = statusExpanded or { available = true, inprogress = true, completed = true, cooldown = true }
  -- Reset cooldown ticker state on rebuild
  stopNpcCooldownTicker(); npcCooldownLeftByRow = {}
  if not npcTaskWidget or (npcTaskWidget.isDestroyed and npcTaskWidget:isDestroyed()) then
    npcTaskWidget = g_ui.createWidget('NpcTaskListWidget', modules.game_interface.getRootPanel())
    npcTaskWidget:setText(tr("World Quests"))
    npcTaskWidget:show(); npcTaskWidget:raise(); npcTaskWidget:focus()
  else
    -- Reuse existing window to avoid close/flicker
    npcTaskWidget:setText(tr("World Quests"))
    npcTaskWidget:show(); npcTaskWidget:raise(); npcTaskWidget:focus()
  end
  translateUI(npcTaskWidget)
  npcTaskDescription = npcTaskWidget:getChildById('npcTaskDescription')
  dbg('Bound npcTaskDescription: ' .. tostring(npcTaskDescription ~= nil))
  if npcTaskDescription and npcTaskDescription.hide then npcTaskDescription:hide() end

  local leftRail = npcTaskWidget:getChildById('leftRail') or npcTaskWidget
  if leftRail then
    local function hideById(id)
      local w = npcTaskWidget:recursiveGetChildById(id)
      if w then pcall(function() w:setVisible(false) end); pcall(function() w:setHeight(0) end) end
    end
    hideById('availableHeader'); hideById('npcTaskListAvailable')
    hideById('inProgressHeader')
    hideById('completedHeader'); hideById('npcTaskListCompleted')

    local hostPanel = npcTaskWidget:recursiveGetChildById('npcTaskListInProgress')
    if hostPanel then
      pcall(function()
        local lh = leftRail:getHeight() or 0
        if lh > 0 then hostPanel:setHeight(lh - 48) end
      end)
      local list = hostPanel:recursiveGetChildById('npcTaskListPanel') or hostPanel
      if list.destroyChildren then list:destroyChildren() end

      local function addHeader(kind, titleText, count)
        local se = statusExpanded or { available = true, inprogress = true, completed = true }
        local header = g_ui.createWidget('ZoneHeader', list)
        header:setId(kind == 'available' and 'combinedAvailableHeader' or (kind == 'inprogress' and 'combinedInProgHeader' or 'combinedCompletedHeader'))
        local caret = header:getChildById('zoneCaret')
        local title = header:getChildById('zoneTitle')
        if title then title:setText(string.format('%s (%d)', tr(titleText), count)) end
        if caret then caret:setText(se[kind] ~= false and '+' or '-') end
        header.onClick = function() toggleStatusSection(kind) end
        return header
      end

      -- Available section
      addHeader('available', 'Available', #parsed.available)
      for i = 1, #parsed.available do
        local rec = parsed.available[i]
        local row = g_ui.createWidget('NpcTaskRecord', list)
        row:setId('npcAvail_'.. tostring(i))
        row:getChildById('taskButton'):setText(tr(rec.taskName))
        local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 0)) end
        local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText(tr('Level %d', rec.taskMinLvl or 0)) end
        local badge = row:getChildById('taskBadge'); if badge then
          local tag = tostring(rec.taskBadge or (rec.taskRepeat and 'Repeat' or 'Story'))
          badge:setText(tr(tag))
          local lc = tag:lower()
          if lc == 'story' then badge:setColor('#D4AF37')
          elseif lc == 'repeat' then badge:setColor('#66cc66')
          elseif lc == 'daily' then badge:setColor('#66ccff')
          elseif lc == 'quest' then badge:setColor('#ffffff')
          elseif lc == 'boss' or lc == 'dungeon' then badge:setColor('#ff4d4d')
          else badge:setColor('#D4AF37') end
        end
        local p = row:getChildById('taskProgress') or row:getChildById('progressBg'); if p then p:setVisible(false) end
        row.onClick = modules.game_tasklist.onNpcUnifiedRowClick
      end

      -- In Progress section
      addHeader('inprogress', 'In Progress', #parsed.active)
      for i = 1, #parsed.active do
        local rec = parsed.active[i]
        local row = g_ui.createWidget('NpcTaskRecord', list)
        row:setId('npcInProg_'.. tostring(i))
        row:getChildById('taskButton'):setText(tr(rec.taskName))
        local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 1)) end
        local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText(tr('Level %d', rec.taskMinLvl or 0)) end
        local badge = row:getChildById('taskBadge'); if badge then
          local tag = tostring(rec.taskBadge or (rec.taskRepeat and 'Repeat' or 'Story'))
          badge:setText(tr(tag))
          local lc = tag:lower()
          if lc == 'story' then badge:setColor('#D4AF37')
          elseif lc == 'repeat' then badge:setColor('#66cc66')
          elseif lc == 'daily' then badge:setColor('#66ccff')
          elseif lc == 'boss' or lc == 'dungeon' then badge:setColor('#ff4d4d')
          else badge:setColor('#D4AF37') end
        end
        local p = row:getChildById('taskProgress') or row:getChildById('progressBg')
        local pb = row:getChildById('taskProgressBar') or (p and p:getChildById('progressFill'))
        local cur = tonumber(rec.taskCurrentCnt or 0) or 0
        local goal = tonumber(rec.taskGoalCnt or 0) or 0
        local pct = (goal > 0) and math.max(0, math.min(1, cur / goal)) or 0
        if p and pb then setProgressBar(p, pb, pct) end
        row.onClick = modules.game_tasklist.onNpcUnifiedRowClick
      end

      -- Completed section
      addHeader('completed', 'Completed', #parsed.completed)
      for i = 1, #parsed.completed do
        local rec = parsed.completed[i]
        local row = g_ui.createWidget('NpcTaskRecord', list)
        row:setId('npcCompleted_'.. tostring(i))
        row:getChildById('taskButton'):setText(tr(rec.taskName))
        local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 2)) end
        local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText(tr('Level %d', rec.taskMinLvl or 0)) end
        local badge = row:getChildById('taskBadge'); if badge then
          local tag = tostring(rec.taskBadge or (rec.taskRepeat and 'Repeat' or 'Story'))
          badge:setText(tr(tag))
          local lc = tag:lower()
          if lc == 'story' then badge:setColor('#D4AF37')
          elseif lc == 'repeat' then badge:setColor('#66cc66')
          elseif lc == 'daily' then badge:setColor('#66ccff')
          elseif lc == 'boss' or lc == 'dungeon' then badge:setColor('#ff4d4d')
          else badge:setColor('#D4AF37') end
        end
        local p = row:getChildById('taskProgress'); if p then p:setVisible(false) end
        row.onClick = modules.game_tasklist.onNpcUnifiedRowClick
      end

      -- Cooldown section (render once, after Completed)
      if parsed.cooldown and #parsed.cooldown > 0 then
        addHeader('cooldown', 'On Cooldown', #parsed.cooldown)
        local hasZero = false
        for i = 1, #parsed.cooldown do
          local rec = parsed.cooldown[i]
          local row = g_ui.createWidget('NpcTaskRecord', list)
          row:setId('npcCooldown_'.. tostring(i))
          row:getChildById('taskButton'):setText(tr(rec.taskName))
          local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/0') end
          -- write cooldown into its own label under the name
          local cdLbl = row:getChildById('cooldownText')
          if cdLbl then
            local left = tonumber(rec.taskCooldownLeftSec or 0) or 0
            local hrs = math.floor(left / 3600)
            local mins = math.floor((left % 3600) / 60)
            local secs = left % 60
            local txt
            if left <= 0 then
              txt = tr('Ready')
            elseif hrs > 0 then
              txt = tr('Available in %dh %dm', hrs, mins)
            elseif mins > 0 then
              txt = tr('Available in %dm', mins)
            else
              txt = tr('Available in %ds', secs)
            end
            cdLbl:setText(txt)
          end
          -- show level top-right as usual
          local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText(tr('Level %d', rec.taskMinLvl or 0)) end
          -- register per-row remaining seconds for ticker
          npcCooldownLeftByRow[row:getId()] = tonumber(rec.taskCooldownLeftSec or 0) or 0
          if (npcCooldownLeftByRow[row:getId()] or 0) <= 0 then hasZero = true end
          local badge = row:getChildById('taskBadge')
          if badge then
            local tag = tostring(rec.taskBadge or 'Story')
            badge:setText(tr(tag))
            local lc = tag:lower()
            if lc == 'story' then badge:setColor('#D4AF37')
            elseif lc == 'repeat' then badge:setColor('#66cc66')
            elseif lc == 'daily' then badge:setColor('#66ccff')
            elseif lc == 'quest' then badge:setColor('#ffffff')
            elseif lc == 'boss' or lc == 'dungeon' then badge:setColor('#ff4d4d')
            else badge:setColor('#D4AF37') end
          end
          -- hide progress bar
          local p = row:getChildById('taskProgress'); if p then p:setVisible(false) end
          -- allow selecting to show description (Accept will be disabled)
          row.onClick = modules.game_tasklist.onNpcUnifiedRowClick
        end
        -- start per-minute ticker if any cooldown has time remaining
        local hasActive = false
        for _, v in pairs(npcCooldownLeftByRow) do if (tonumber(v) or 0) > 0 then hasActive = true break end end
        if hasActive and scheduleEvent then npcCooldownTickerEvent = scheduleEvent(tickNpcCooldownOnce, 60000) end
        -- if any row already has zero, request an immediate refresh to move it into Available
        if hasZero then
          local p = g_game.getProtocolGame(); if p then p:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
        end
      end
    end
  end

  -- Expand sections that now contain items
  if (#(parsed.available or {}) > 0 and statusExpanded.available == false) then statusExpanded.available = true; pcall(function() g_settings.set('game_tasklist/npc/available_expanded', '1') end) end
  if (#(parsed.active or {}) > 0 and statusExpanded.inprogress == false) then statusExpanded.inprogress = true; pcall(function() g_settings.set('game_tasklist/npc/inprogress_expanded', '1') end) end
  if (#(parsed.completed or {}) > 0 and statusExpanded.completed == false) then statusExpanded.completed = true; pcall(function() g_settings.set('game_tasklist/npc/completed_expanded', '1') end) end
  if (parsed.cooldown and #parsed.cooldown > 0 and statusExpanded.cooldown == false) then statusExpanded.cooldown = true; pcall(function() g_settings.set('game_tasklist/npc/cooldown_expanded', '1') end) end
  local function safeApply(kind)
    local f = _G.applyStatusVisibility or applyStatusVisibility
    if type(f) == 'function' then pcall(function() f(kind) end) end
  end
  safeApply('available')
  safeApply('inprogress')
  safeApply('completed')
  -- Clear in-flight (server responded / UI rebuilt)
  actionInFlight = false
  -- Do not auto-close here; window remains unless user presses Close
  -- If requested, auto-select next available quest after an Accept
  if focusNextAvailableAfterAccept and parsed and parsed.available and #parsed.available > 0 then
    focusNextAvailableAfterAccept = false
    npcUnifiedSelectedKind = 'available'
    npcSelectedTask = 1
    pcall(function()
      local host = npcTaskWidget:recursiveGetChildById('npcTaskListInProgress')
      local listW = host and (host:recursiveGetChildById('npcTaskListPanel') or host)
      local row = listW and listW:getChildById('npcAvail_1') or nil
      if row and modules.game_tasklist and modules.game_tasklist.onNpcUnifiedRowClick then
        modules.game_tasklist.onNpcUnifiedRowClick(row)
      else
        UpdateNpcTaskDescription()

    -- Auto-refresh helpers (disabled by default to avoid flooding server)
    local function stopNpcAutoRefresh()
      if npcAutoRefreshEvent and removeEvent then
        removeEvent(npcAutoRefreshEvent)
      end
      npcAutoRefreshEvent = nil
    end
    local function startNpcAutoRefresh()
      stopNpcAutoRefresh()
      if not scheduleEvent then return end
      local function tick()
        -- if widget disappeared, stop
        if not npcTaskWidget or (npcTaskWidget.isDestroyed and npcTaskWidget:isDestroyed()) or (npcTaskWidget.isVisible and not npcTaskWidget:isVisible()) then
          stopNpcAutoRefresh(); return
        end
        -- Do not poll while an action is in flight
        if actionInFlight then
          npcAutoRefreshEvent = scheduleEvent(tick, 2000)
          return
        end
        local p = g_game.getProtocolGame()
        if p then p:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
        -- Poll at a gentler cadence to avoid flooding
        npcAutoRefreshEvent = scheduleEvent(tick, 5000)
      end
      npcAutoRefreshEvent = scheduleEvent(tick, 5000)
    end
    -- Disabled by default; uncomment to enable gentle polling if needed
    -- startNpcAutoRefresh()
      end
      setAcceptState('Accept', true)
    end)
  end
  -- Restore button state based on current selection
  local ab = npcTaskWidget and npcTaskWidget:recursiveGetChildById('acceptButton') or nil
  if ab then
    if npcUnifiedSelectedKind == 'completed' then
      setAcceptState('Claim', true)
    elseif npcUnifiedSelectedKind == 'active' then
      setAcceptState('In Progress', false)
    else
      setAcceptState('Accept', true)
    end
  end
end

-- Simple modal reminder to choose a reward when choices exist
local function showChoiceReminder()
  -- reuse AskWidget template; make it neutral and single-button
  pcall(function() if askWidget and not askWidget:isDestroyed() then askWidget:destroy() end end)
  local host = npcTaskWidget or taskListsWindow or modules.game_interface.getRootPanel()
  askWidget = g_ui.createWidget('AskWidget', host)
  if askWidget then
    translateUI(askWidget)
    pcall(function()
      askWidget:setText(tr('Reward Selection Required'))
      if askWidget.setSize then askWidget:setSize({width = 380, height = 110}) end
    end)
    -- try to set first label text
    pcall(function()
      local kids = askWidget:getChildren()
      for i=1,#kids do
        if kids[i].setText then
          kids[i]:setText(tr('Please choose one of the reward options before claiming.'))
          if kids[i].setTextWrap then kids[i]:setTextWrap(true) end
          if kids[i].setTextAutoResize then kids[i]:setTextAutoResize(true) end
          if kids[i].setColor then kids[i]:setColor('#ffffff') end
          if kids[i].setSize then kids[i]:setSize({width = 350, height = 60}) end
          break
        end
      end
    end)
    -- make it a single OK button
    local yesBtn = askWidget:recursiveGetChildById('yesButton')
    local noBtn  = askWidget:recursiveGetChildById('noButton')
    if yesBtn and yesBtn.setText then yesBtn:setText(tr('OK')) end
    if noBtn and noBtn.hide then noBtn:hide() end
    if yesBtn then
      yesBtn.onClick = function()
        if askWidget and not askWidget:isDestroyed() then askWidget:destroy() end
        askWidget = nil
      end
      -- center the OK button horizontally if possible
      pcall(function()
        if yesBtn.setSize then yesBtn:setSize({width = 80, height = 24}) end
        if yesBtn.setAnchors then
          -- fallback if API supports setting anchors via methods
        end
      end)
    end
    askWidget:show(); askWidget:raise(); askWidget:focus()
  end
end

-- Persisted status of expansion for unified sections
local statusExpanded = {
  inprogress = true,
  completed = true,
}

-- Cooldown ticker handle (per-minute UI updater)
npcCooldownTickerEvent = npcCooldownTickerEvent or nil
npcCooldownLeftByRow = npcCooldownLeftByRow or {}

function stopNpcCooldownTicker()
  if npcCooldownTickerEvent and removeEvent then
    removeEvent(npcCooldownTickerEvent)
  end
  npcCooldownTickerEvent = nil
end

function tickNpcCooldownOnce()
  if not npcTaskWidget then return end
  local hostPanel = npcTaskWidget:recursiveGetChildById('npcTaskListInProgress')
  if not hostPanel then return end
  local list = hostPanel:recursiveGetChildById('npcTaskListPanel') or hostPanel
  if not list then return end
  local anyZero = false
  for _, child in ipairs(list:getChildren()) do
    local id = child:getId() or ''
    if id:find('npcCooldown_', 1, true) then
      local left = tonumber(npcCooldownLeftByRow[id] or 0) or 0
      if left > 0 then
        left = math.max(0, left - 60)
        npcCooldownLeftByRow[id] = left
        local lbl = child:getChildById('cooldownText')
        if lbl then
          local mins = math.floor(left / 60)
          local hrs = math.floor(mins / 60)
          mins = mins % 60
          local txt
          if hrs > 0 then
            txt = tr('Available in %dh %dm', hrs, mins)
          else
            if left > 0 and mins == 0 then txt = tr('Available in <1m') else txt = tr('Available in %dm', mins) end
          end
          lbl:setText(txt)
        end
        if left == 0 then anyZero = true end
      end
    end
  end
  if anyZero then
    -- Ask server for a refresh; tasks may move from cooldown to available
    local p = g_game.getProtocolGame()
    if p then p:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
    stopNpcCooldownTicker()
    return
  end
  -- reschedule next tick if there are cooldown rows left with time
  local hasActive = false
  for _, v in pairs(npcCooldownLeftByRow) do if (tonumber(v) or 0) > 0 then hasActive = true break end end
  if hasActive and scheduleEvent then
    npcCooldownTickerEvent = scheduleEvent(tickNpcCooldownOnce, 60000)
  else
    stopNpcCooldownTicker()
  end
end

local function applyStatusVisibility(kind)
  if not npcTaskWidget then return end
  local listHost = npcTaskWidget:recursiveGetChildById('npcTaskListInProgress')
  listHost = listHost and (listHost:recursiveGetChildById('npcTaskListPanel') or listHost) or nil
  if not listHost then return end
  local vis = statusExpanded[kind] ~= false
  local headerId = (kind == 'available' and 'combinedAvailableHeader')
                 or (kind == 'inprogress' and 'combinedInProgHeader')
                 or (kind == 'completed' and 'combinedCompletedHeader')
                 or (kind == 'cooldown' and 'combinedCooldownHeader')
  local prefix = (kind == 'available' and 'npcAvail_')
              or (kind == 'inprogress' and 'npcInProg_')
              or (kind == 'completed' and 'npcCompleted_')
              or (kind == 'cooldown' and 'npcCooldown_')
  for _, child in ipairs(listHost:getChildren()) do
    local id = child:getId() or ''
    if id:find(prefix, 1, true) then
      pcall(function() child:setVisible(vis) end)
    end
    if id == headerId then
      local title = child:recursiveGetChildById('title') or child:getChildById('title')
      if title and title.getText then
        local base = title:getText():gsub('%s*[+%-]%s*$', '')
        pcall(function() title:setText(base .. ' ' .. (vis and '-' or '+')) end)
      end
    end
  end
end

function toggleStatusSection(kind)
  statusExpanded[kind] = not (statusExpanded[kind] ~= false)
  g_settings.set('game_tasklist/npc/'.. kind ..'_expanded', statusExpanded[kind] and '1' or '0')
  applyStatusVisibility(kind)
end

-- Ensure OTUI callback path resolves after function is defined
pcall(function()
  modules = modules or {}
  modules.game_tasklist = modules.game_tasklist or {}
  modules.game_tasklist.onNpcUnifiedRowClick = onNpcUnifiedRowClick
  modules.game_tasklist.toggleStatusSection = toggleStatusSection
end)

function parseIncomingTaskList(buffer)
    local parseTaskList = {}
    local mainSplit = {}
    for split in string.gmatch(buffer, "(.-)|") do
        table.insert(mainSplit, split)
    end

    local cnt = tonumber(mainSplit[1])
    -- Entry diagnostic: ensure function is being hit and show task row count
    pcall(function() print(string.format('[Quest Parser] parseIncomingTaskList cnt=%s', tostring(cnt))) end)
    -- removed chat log to avoid server-bound spam
    for i = 1 , cnt do
        -----------------------------------------------------------------------------------------------------------------------------------------------
        local targetList = nil
        local rewardList = nil
        local rewardItems = {}
        local rewardOutfits = {}
        -----------------------------------------------------------------------------------------------------------------------------------------------
        local taskSplit = {}
        for split in string.gmatch(mainSplit[i+1], "(.-);") do
            table.insert(taskSplit, split)
        end
        -- Per-row diagnostic: peek raw row prefix and basic fields
        do
          local rawRowDbg = tostring(mainSplit[i+1] or '')
          pcall(function() print(string.format('[Quest Parser] Row %d raw prefix: %s', i, rawRowDbg:sub(1, 120))) end)
          -- removed chat log to avoid server-bound spam
        end
        -----------------------------------------------------------------------------------------------------------------------------------------------
        local goalSplit = {}
        local rewardSplit = {}
        local basicRewardSplit = {}
        local itemRewardSplit = {}
        local tailSplit = {}
        for split in string.gmatch(taskSplit[3], "(.-):") do
            table.insert(goalSplit, split)
        end
        -- Debug: detect and log missing rewards segment for this task row
        local rawRow = mainSplit[i+1] or ''
        local seg10 = taskSplit[10]
        if not seg10 or seg10 == '' then
            local tname = tostring(taskSplit[1] or '<nil>')
            local tnum  = tostring(taskSplit[11] or '<nil>')
            local msg = string.format(
              "[Quest Parser] Missing rewards segment (taskSplit[10]) for task #%s \"%s\" at row %d.\nRaw row: %s",
              tnum, tname, i, rawRow
            )
            pcall(function() print(msg) end)
            -- removed chat log to avoid server-bound spam
            -- Skip this malformed row to avoid crash
            goto continue_task
        end
        for split in string.gmatch(taskSplit[10], "(.-)!") do
            table.insert(rewardSplit, split)
        end
        -- Guard: empty/malformed rewards header
        if not rewardSplit[1] or rewardSplit[1] == '' then
            local msg = string.format('[Quest Parser] Empty rewards header for task #%s "%s" at row %d (seg10="%s")',
              tostring(taskSplit[11] or '<nil>'), tostring(taskSplit[1] or '<nil>'), i, tostring(taskSplit[10]))
            pcall(function() print(msg) end)
            -- removed chat log to avoid server-bound spam
            goto continue_task
        end
        for split in string.gmatch(rewardSplit[1], "(.-):") do
            table.insert(basicRewardSplit, split)
        end
        for split in string.gmatch(rewardSplit[2], "(.-):") do
            table.insert(itemRewardSplit, split)
        end
        -- Server packs outfits and choices together into the 3rd rewards segment (between the 2nd and 3rd '!').
        -- We'll split the whole tail once and then slice: first 3*outfitsCnt entries -> outfits (triplets),
        -- remaining 4*choiceCnt entries -> choices (quartets).
        for split in string.gmatch(rewardSplit[3] or '', "(.-):") do
            table.insert(tailSplit, split)
        end
        -- parse goals
        local goalCnt = 1
        local maxGoalCnt = #goalSplit

        local monsterList = {}
        local itemList = {}
        local storageList = {}
        if tonumber(goalSplit[goalCnt]) == 1 and goalCnt < maxGoalCnt then --monster goal
            local monsterCnt = tonumber(goalSplit[goalCnt+1])
            for j = 1, monsterCnt do
                table.insert(monsterList, {name = goalSplit[goalCnt+1 + (2*j-1)], spriteId = tonumber(goalSplit[goalCnt+1 + (2*j-1)+1])})
            end
            goalCnt = goalCnt + 1 + monsterCnt * 2
            goalCnt = goalCnt + 1
        end
        if tonumber(goalSplit[goalCnt]) == 2 and goalCnt < maxGoalCnt then --item goal
            local itemCnt = tonumber(goalSplit[goalCnt+1])
            for j = 1, itemCnt do
                table.insert(itemList, {name = goalSplit[goalCnt+1 + (2*j-1)], itemId = tonumber(goalSplit[goalCnt+1 + (2*j-1)+1])})
            end
            goalCnt = goalCnt + 1 + itemCnt * 2
            goalCnt = goalCnt + 1
        end
        if tonumber(goalSplit[goalCnt]) == 3 and goalCnt < maxGoalCnt then --storage goal
            local storageCnt = tonumber(goalSplit[goalCnt+1])
            for j = 1, storageCnt do
                table.insert(storageList, {starageName = goalSplit[goalCnt+1 + (2*j-1)], starageTaskId = tonumber(goalSplit[goalCnt+1 + (2*j-1)+1])})
            end
        end
        targetList = {monsters = monsterList, items = itemList, storages = storageList}
        -- parse rewards
        local rewardsItemCnt = tonumber(basicRewardSplit[2])
        local rewardsOutfitCnt = tonumber(basicRewardSplit[3])
        local rewardsMoney = tonumber(basicRewardSplit[4]) or 0
        local rewardsChoiceCnt = tonumber(basicRewardSplit[5]) or 0
        local rewardsCodexEssences = tonumber(basicRewardSplit[6]) or 0
        local rewardsCodexCrateCnt = tonumber(basicRewardSplit[7]) or 0
        for j = 1, rewardsItemCnt do
            table.insert(rewardItems, {name = itemRewardSplit[(4*(j-1)) + 1], itemCid = tonumber(itemRewardSplit[(4*(j-1)) + 2]), itemSid = tonumber(itemRewardSplit[(4*(j-1)) + 3]), itemCnt = tonumber(itemRewardSplit[(4*(j-1)) + 4])})
        end
        -- outfits slice (triplets)
        local choiceItems = {}
        local tailIdx = 1
        for j = 1, rewardsOutfitCnt do
            local name = tailSplit[tailIdx];            tailIdx = tailIdx + 1
            local lookType = tonumber(tailSplit[tailIdx]);tailIdx = tailIdx + 1
            local addon = tonumber(tailSplit[tailIdx]) or 0; tailIdx = tailIdx + 1
            table.insert(rewardOutfits, {name = name, lookType = lookType, addon = addon})
        end
        -- choices slice (quartets)
        for j = 1, rewardsChoiceCnt do
            local name = tailSplit[tailIdx];            tailIdx = tailIdx + 1
            local cid  = tonumber(tailSplit[tailIdx]); tailIdx = tailIdx + 1
            local sid  = tonumber(tailSplit[tailIdx]); tailIdx = tailIdx + 1
            local cnt  = tonumber(tailSplit[tailIdx]); tailIdx = tailIdx + 1
            if name and cid and sid and cnt then
              table.insert(choiceItems, {name = name, itemCid = cid, itemSid = sid, itemCnt = cnt})
            end
        end
        -- codex crates slice (triplets: crateType:amount:name)
        local codexCrates = {}
        for j = 1, rewardsCodexCrateCnt do
            local crateType = tonumber(tailSplit[tailIdx]); tailIdx = tailIdx + 1
            local crateAmt  = tonumber(tailSplit[tailIdx]); tailIdx = tailIdx + 1
            local crateName = tailSplit[tailIdx];           tailIdx = tailIdx + 1
            if crateType and crateAmt then
              table.insert(codexCrates, {crateType = crateType, amount = crateAmt, name = crateName or ('Crate ' .. crateType)})
            end
        end
        rewardList = {exp = tonumber(basicRewardSplit[1]), money = rewardsMoney, items = rewardItems, outfits = rewardOutfits, choice = choiceItems, codex_essences = rewardsCodexEssences, codex_crates = codexCrates}
        -----------------------------------------------------------------------------------------------------------------------------------------------
        table.insert(parseTaskList, {taskNumber = taskSplit[11], taskName = taskSplit[1], taskDesc = taskSplit[2], taskGoals = targetList,
                                     taskGoalCnt = tonumber(taskSplit[4]), taskMinLvl = tonumber(taskSplit[5]), taskMaxLvl = tonumber(taskSplit[6]),
                                     taskRepeat = toboolean(taskSplit[7]), taskState = tonumber(taskSplit[8]), taskCurrentCnt = tonumber(taskSplit[9]),
                                     taskRewards = rewardList, taskZone = taskSplit[12], taskSourceNpc = taskSplit[13], taskHintNpc = taskSplit[14],
                                     taskBadge = (taskSplit[15] and #taskSplit[15] > 0) and taskSplit[15] or 'Story'})
::continue_task::
    end
    return parseTaskList
end

-- Search/Filter toolbar handlers and helpers
function onSearchChange(widget)
  searchQuery = (widget and widget.getText and widget:getText() or ''):lower()
  rebuildList()
end

function onStatusFilterChange(widget)
  if widget and widget.getCurrentIndex then
    levelFilterMode = widget:getCurrentIndex() or 0
  else
    levelFilterMode = 0
  end
  rebuildList()
end

function rebuildList()
  if not taskListPanel then return end
  if taskListPanel.destroyChildren then
    taskListPanel:destroyChildren()
  end
  localTaskWdgList = {}
  zoneSections = {}
  buildGroupedTaskList()
end

function applyFilters(t)
  -- name search
  if searchQuery ~= '' then
    local name = tostring(t.taskName or ''):lower()
    if not name:find(searchQuery, 1, true) then
      return false
    end
  end
  -- status filter: 0=All, 1=Active(In Progress), 2=Completed
  -- Note: in this data model taskState=2 -> In Progress, taskState=1 -> Completed
  if levelFilterMode == 1  then
    --print("levelFilterMode: 1")
    if tonumber(t.taskState) == 0  or tonumber(t.taskState) == 1 or tonumber(t.taskState) == 2 then return true end
  elseif levelFilterMode == 2 then
    --print("levelFilterMode: 2")
    if tonumber(t.taskState) ~= 1 then return false end
  elseif levelFilterMode == 3 then
    --print("levelFilterMode: 3")
    if tonumber(t.taskState) ~= 2 then return false end
  end
  return true
end
function onExtendedTaskList(protocol, opcode, buffer)
    -- clear existing widgets and state before rebuilding the list
    -- Clear left list panel entirely (headers, contents, and task widgets)
    if taskListPanel and taskListPanel.destroyChildren then
      taskListPanel:destroyChildren()
    end
    localTaskWdgList = {}
    for i = #localRewardItemList, 1, -1 do
      localRewardItemList[i]:destroy()
      table.remove(localRewardItemList, i)
    end
    for taskNum, _ in pairs(choiceWidgetsByTask) do
      choiceWidgetsByTask[taskNum] = nil
    end
    zoneSections = {}
    taskDescriptionWindow:hide()
    currentSelectedTask = 0

    localTaskList = parseIncomingTaskList(buffer)
    buildGroupedTaskList()
    -- restore previously selected task by taskNumber if any
    if not selectedListIndex or selectedListIndex <= 0 then
      local savedTnum = g_settings.get('game_tasklist/selected_task')
      if savedTnum then
        local t = tostring(savedTnum)
        for i=1,#localTaskList do
          if tostring(localTaskList[i].taskNumber) == t then
            selectedListIndex = i
            break
          end
        end
      end
    end
    if selectedListIndex and selectedListIndex > 0 and selectedListIndex <= #localTaskList then
      -- ensure description reflects restored selection
      taskDescriptionWindow:show()
      deleteButton:show()
      updateTaskDescription(selectedListIndex)
      do
        local raw = tostring(localTaskList[selectedListIndex].taskNumber)
        currentSelectedTask = tonumber(raw) or tonumber(raw:match("(%d+)")) or 0
      end
    end
    taskListsWindow:setText(tr("Adventure Log (%d/%d)", #localTaskList, MaxTaskList))
    -- update cap pill
    local capPill = taskListsWindow:getChildById('capPill')
    if capPill then
      local used = 0
      for i=1,#localTaskList do
        if localTaskList[i].taskState and localTaskList[i].taskState > 0 and localTaskList[i].taskState < 3 then
          used = used + 1
        end
      end
      capPill:setText(tr("Max %d / %d", used, MaxTaskList))
      if used >= MaxTaskList then
        capPill:setStyle('background: #532b2b; color: #ffdddd; border-color: #7a3a3a')
      elseif used >= MaxTaskList - 2 then
        capPill:setStyle('background: #4a4222; color: #fff2cc; border-color: #6b5d2d')
      else
        capPill:mergeStyle({
          ['background'] = 'alpha',
          ['border-color'] = 'alpha',
          ['border-width'] = 0
        })
      end
    end
end

-- Build the left task list grouped by zone with collapsible sections
function buildGroupedTaskList()
  if not taskListPanel then return end
  local groups = {}
  for i = 1, #localTaskList do
    local t = localTaskList[i]
    if t.taskState > 0 and t.taskState < 3 then
      local zone = t.taskZone or 'Unknown Zone'
      -- apply filters
      if applyFilters(t) then
        groups[zone] = groups[zone] or {}
        table.insert(groups[zone], i)
      end
    end
  end
  -- stable order by zone name
  local zones = {}
  for z,_ in pairs(groups) do table.insert(zones, z) end
  table.sort(zones, function(a,b) return tostring(a) < tostring(b) end)

  for _, zone in ipairs(zones) do
    local header = g_ui.createWidget('ZoneHeader', taskListPanel)
    header:setId('zoneHeader_'..zone)
    header:getChildById('zoneTitle'):setText(string.format('%s (%d)', tr(zone), #groups[zone]))
    header:getChildById('zoneCaret'):setText('+')

    local content = g_ui.createWidget('ZoneContent', taskListPanel)
    content:setId('zoneContent_'..zone)
    -- restore persisted collapse state
    local key = 'game_tasklist/zone_expanded/'..zone
    local persisted = g_settings.get(key)
    local expanded = (persisted == nil) and true or (tostring(persisted) == '1' or tostring(persisted) == 'true')
    content:setVisible(expanded)
    header:getChildById('zoneCaret'):setText(expanded and '+' or '-')

    zoneSections[zone] = { header = header, content = content, expanded = true }

    -- sort within zone: in-progress (2), available(1), completed(>=3); then by min level asc
    table.sort(groups[zone], function(aIdx, bIdx)
      local A = localTaskList[aIdx]
      local B = localTaskList[bIdx]
      local function stateOrder(s)
        if s == 2 then return 0 elseif s == 1 then return 1 else return 2 end
      end
      local soA, soB = stateOrder(A.taskState), stateOrder(B.taskState)
      if soA ~= soB then return soA < soB end
      local la, lb = tonumber(A.taskMinLvl) or 0, tonumber(B.taskMinLvl) or 0
      if la ~= lb then return la < lb end
      return tostring(A.taskName) < tostring(B.taskName)
    end)

    for _, idx in ipairs(groups[zone]) do
      local taskItem = g_ui.createWidget('TaskRecord', content)
      table.insert(localTaskWdgList, taskItem)
      taskItem:setId('task'..tostring(idx))
      local taskState = taskItem:getChildById('taskState')
      local taskName = taskItem:getChildById('taskName')
      local taskLevel = taskItem:getChildById('taskLevel')
      if taskName then
        taskName:setText(tr(localTaskList[idx].taskName))
      end
      if taskLevel then
        taskLevel:setText(tr('Level %d', localTaskList[idx].taskMinLvl or 0))
      end
      if taskState then
        taskState:setImageSource('/images/taskList/'..tostring(localTaskList[idx].taskState))
      end
      -- badge
      local badge = taskItem:getChildById('taskBadge')
      if badge then
        local tag = tostring(localTaskList[idx].taskBadge or 'Story')
        badge:setText(tr(tag))
        local lc = tag:lower()
        if lc == 'story' then badge:setColor('#D4AF37')
        elseif lc == 'repeat' then badge:setColor('#66cc66')
        elseif lc == 'daily' then badge:setColor('#66ccff')
        elseif lc == 'quest' then badge:setColor('#ffffff')
        elseif lc == 'boss' or lc == 'dungeon' then badge:setColor('#ff4d4d')
        else badge:setColor('#D4AF37') end
      end
      -- selection highlight (subtle)
      if selectedListIndex == idx then
        taskItem:mergeStyle({
          ['background'] = '#ffffff14',
          ['border-width'] = 1,
          ['border-color'] = '#cccccc55'
        })
        local acc = taskItem:getChildById('selectedAccent')
        if acc then acc:setVisible(true) end
      else
        taskItem:mergeStyle({
          ['background'] = 'alpha',
          ['border-width'] = 0,
          ['border-color'] = 'alpha'
        })
        local acc = taskItem:getChildById('selectedAccent')
        if acc then acc:setVisible(false) end
      end
      -- progress bar fill (use shared helper for consistent sizing)
      local goal = tonumber(localTaskList[idx].taskGoalCnt) or 0
      local curr = tonumber(localTaskList[idx].taskCurrentCnt) or 0
      local progressBg = taskItem:getChildById('progressBg')
      local progressFill = progressBg and progressBg:getChildById('progressFill') or nil
      if progressBg and progressFill and goal and goal > 0 then
        local ratio = math.max(0, math.min(1, curr / goal))
        addEvent(function()
          if progressBg and not progressBg:isDestroyed() and progressFill and not progressFill:isDestroyed() then
            setProgressBar(progressBg, progressFill, ratio)
          end
        end)
      else
        if progressBg then progressBg:setVisible(false) end
      end
    end
  end
end

-- Toggle a zone section open/closed
function onZoneHeaderClick(widget)
  -- zoneContent is the next sibling of the header in our layout
  local parent = widget:getParent()
  if not parent then return end
  local children = parent:getChildren()
  local idx = 0
  for i = 1, #children do
    if children[i] == widget then
      idx = i
      break
    end
  end
  if idx == 0 then return end
  local content = children[idx + 1]
  if not content then return end
  local caret = widget:getChildById('zoneCaret')
  local isVisible = content:isVisible()
  content:setVisible(not isVisible)
  if caret then
    caret:setText(isVisible and '-' or '+')
  end
  -- persist state per zone
  local title = widget:getChildById('zoneTitle')
  local txt = title and title:getText() or ''
  local zone = txt:gsub('%s*%(%d+%)%s*$', '') -- remove count suffix
  if zone and zone ~= '' then
    g_settings.set('game_tasklist/zone_expanded/'..zone, (not isVisible) and '1' or '0')
  end
end

-- Expand All / Collapse All handlers
function expandAllZones()
  for zone, sect in pairs(zoneSections) do
    if sect and sect.content and not sect.content:isVisible() then
      sect.content:setVisible(true)
      local caret = sect.header and sect.header:getChildById('zoneCaret')
      if caret then caret:setText('+') end
      g_settings.set('game_tasklist/zone_expanded/'..zone, '1')
    end
  end
end

function switchTaskTabInWidget(widget, tab)
  if not widget then return end
  local detailsPanel = widget:recursiveGetChildById('detailsPanel')
  local rewardsPanel = widget:recursiveGetChildById('rewardsPanel')
  local detailsTab = widget:recursiveGetChildById('detailsTab')
  local rewardsTab = widget:recursiveGetChildById('rewardsTab')

  if tab == 'details' then
    if detailsPanel then detailsPanel:setVisible(true) end
    if rewardsPanel then rewardsPanel:setVisible(false) end
    if detailsTab then detailsTab:setBackgroundColor('#1a2332'); detailsTab:setBorderColor('#3a4a5f') end
    if rewardsTab then rewardsTab:setBackgroundColor('#0f141c'); rewardsTab:setBorderColor('#2a3344') end
  else
    if detailsPanel then detailsPanel:setVisible(false) end
    if rewardsPanel then rewardsPanel:setVisible(true) end
    if detailsTab then detailsTab:setBackgroundColor('#0f141c'); detailsTab:setBorderColor('#2a3344') end
    if rewardsTab then rewardsTab:setBackgroundColor('#1a2332'); rewardsTab:setBorderColor('#3a4a5f') end
  end
end

function switchTaskTab(tab)
  switchTaskTabInWidget(taskDescriptionWindow, tab)
end

function showTaskDetailsTab()
  switchTaskTab('details')
end

function showTaskRewardsTab()
  switchTaskTab('rewards')
end

function switchNpcTaskTab(tab)
  switchTaskTabInWidget(npcTaskDescription, tab)
end

function showNpcTaskDetailsTab()
  switchNpcTaskTab('details')
end

function showNpcTaskRewardsTab()
  switchNpcTaskTab('rewards')
end

local REWARD_ITEM_HEIGHT = 34
local REWARD_ITEM_MARGIN = 2
local REWARD_PANEL_PADDING = 4

function adjustRewardPanelHeight(panel, itemCount, maxVisible)
  if not panel then return end
  maxVisible = maxVisible or 4
  if itemCount <= 0 then
    panel:setHeight(0)
    return
  end
  local visible = math.min(itemCount, maxVisible)
  local height = visible * REWARD_ITEM_HEIGHT
  if visible > 1 then
    height = height + (visible - 1) * REWARD_ITEM_MARGIN
  end
  height = height + REWARD_PANEL_PADDING
  panel:setHeight(height)
end

function setRewardsExpanded(expanded)
  -- Deprecated: rewards are now shown via the Rewards tab
end

function toggleRewards()
  showTaskRewardsTab()
end

function collapseAllZones()
  for zone, sect in pairs(zoneSections) do
    if sect and sect.content and sect.content:isVisible() then
      sect.content:setVisible(false)
      local caret = sect.header and sect.header:getChildById('zoneCaret')
      if caret then caret:setText('-') end
      g_settings.set('game_tasklist/zone_expanded/'..zone, '0')
    end
  end
end

function onExtendedUpdateTask(protocol, opcode, buffer)
    local mainSplit = {}
    for split in string.gmatch(buffer, "(.-)|") do
        table.insert(mainSplit, split)
    end
    local idx = tonumber(mainSplit[1])
    local state = tonumber(mainSplit[2])
    local cnt = tonumber(mainSplit[3])

    -- When a task progress update arrives, request a unified refresh so the left list
    -- and the right description reflect the latest state immediately.
    local p = g_game.getProtocolGame()
    if p then
      -- small debounce to coalesce multiple updates
      if scheduleEvent then
        scheduleEvent(function()
          local gp = g_game.getProtocolGame(); if gp then gp:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
        end, 100)
      else
        p:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "")
      end
    end
end

-- Parse unified NPC payload sent by server (header VER1; then three or four sections)
local function parseUnifiedNpcPayload(buffer)
  -- Header: VER1;availCount:X;activeCount:Y;completedCount:Z;
  local headerEnd = buffer:find(';', 1, true) -- after VER1
  if not headerEnd then return nil end
  local afterVer = buffer:sub(headerEnd + 1)
  local ac, act, cc, cd = 0, 0, 0, 0
  for key, val in afterVer:gmatch("(availCount):(%d+);") do ac = tonumber(val) or 0 end
  for key, val in afterVer:gmatch("(activeCount):(%d+);") do act = tonumber(val) or 0 end
  for key, val in afterVer:gmatch("(completedCount):(%d+);") do cc = tonumber(val) or 0 end
  for key, val in afterVer:gmatch("(cooldownCount):(%d+);") do cd = tonumber(val) or 0 end
  -- find the start of sections (after the FOURth value terminator ';')
  -- Header format: availCount:X;activeCount:Y;completedCount:Z;cooldownCount:W;
  local posAfterHeader = afterVer:match("^availCount:%d+;activeCount:%d+;completedCount:%d+;cooldownCount:%d+;()")
  local payload
  if posAfterHeader then
    payload = afterVer:sub(posAfterHeader)
  else
    -- Fallback: manually skip four semicolons to be tolerant of reordering as long as delimiters remain
    local idx = 0
    for _ = 1, 4 do
      local nextSemi = afterVer:find(';', idx + 1, true)
      if not nextSemi then return nil end
      idx = nextSemi
    end
    payload = afterVer:sub(idx + 1)
  end
  local sections = {}
  for seg in payload:gmatch("(.-)%|%|") do
    sections[#sections+1] = seg
  end
  local function parseSection(seg)
    local list = {}
    for block in seg:gmatch("(.-)##") do
      if block and #block > 0 then
        -- We may have an optional extra tail field cooldownLeftSec before final '|'
        -- parseIncomingTaskList handles core fields; we parse cooldownLeftSec manually
        local pseudo = "1|" .. block
        local one = parseIncomingTaskList(pseudo)
        if one and #one > 0 then
          local rec = one[1]
          -- Extract last ';' token from block (after Badge) if present
          -- Server encodes cooldown rows as: ...;Badge;cooldownLeftSec;|
          -- Capture the value before the final ';|'. If not found, fallback to old pattern.
          local tail = block:match(";([^;]*);|$") or block:match(";([^;]*)|$")
          local num = tonumber(tail or '0') or 0
          if num and num > 0 then rec.taskCooldownLeftSec = num end
          table.insert(list, rec)
        end
      end
    end
    return list
  end
  local avail = parseSection(sections[1] or "")
  local active = parseSection(sections[2] or "")
  local completed = parseSection(sections[3] or "")
  local cooldown = parseSection(sections[4] or "")
  return {available = avail, active = active, completed = completed, cooldown = cooldown, counts = {ac, act, cc, cd}}
end

function onExtendedNpcTaskList(protocol, opcode, buffer)
  -- Unified format branch (single window with three sections)
  if buffer and buffer:sub(1,5) == 'VER1;' then
    dbg('Unified NPC payload received len=' .. tostring(#(buffer or '')))
    lastOpcode = opcode
    local parsed = parseUnifiedNpcPayload(buffer)
    if not parsed then dbg('parseUnifiedNpcPayload returned nil'); return end
    -- Deduplicate with precedence: Cooldown > Active > Completed > Available
    -- If a task appears in Cooldown, it must be removed from Active, Completed, and Available
    local function dedupeLists(p)
      local seenCooldown = {}
      local seenCompleted = {}
      local seenActive = {}
      local function numOf(t)
        local raw = tostring(t.taskNumber or '')
        local n = tonumber(raw) or tonumber(raw:match('(%d+)')) or raw
        return n
      end
      -- Build cooldown set and unique list
      local uniqCooldown = {}
      for _, t in ipairs(p.cooldown or {}) do
        local k = numOf(t)
        if not seenCooldown[k] then
          table.insert(uniqCooldown, t)
          seenCooldown[k] = true
        end
      end
      p.cooldown = uniqCooldown

      -- Build active set, excluding cooldown
      local uniqActive = {}
      for _, t in ipairs(p.active or {}) do
        local k = numOf(t)
        if not seenCooldown[k] and not seenActive[k] then
          table.insert(uniqActive, t)
          seenActive[k] = true
        end
      end
      p.active = uniqActive

      -- Build completed set, excluding any that are in cooldown or active
      local uniqCompleted = {}
      for _, t in ipairs(p.completed or {}) do
        local k = numOf(t)
        if not seenCooldown[k] and not seenActive[k] and not seenCompleted[k] then
          table.insert(uniqCompleted, t)
          seenCompleted[k] = true
        end
      end
      p.completed = uniqCompleted

      -- Build available set, excluding any that appear in higher-precedence lists
      local uniqAvail, seenAvail = {}, {}
      for _, t in ipairs(p.available or {}) do
        local k = numOf(t)
        if not seenCooldown[k] and not seenCompleted[k] and not seenActive[k] and not seenAvail[k] then
          table.insert(uniqAvail, t)
          seenAvail[k] = true
        end
      end
      p.available = uniqAvail
    end
    dedupeLists(parsed)
    dbg(string.format('Sections: avail=%d active=%d completed=%d', #(parsed.available or {}), #(parsed.active or {}), #(parsed.completed or {})))
    -- cache for optimistic updates
    lastUnified = { available = parsed.available, active = parsed.active, completed = parsed.completed, cooldown = parsed.cooldown }

    -- expose parsed lists globally for selection handling
    npcTaskList = parsed.available
    npcUnifiedActiveList = parsed.active
    npcRewardList = parsed.completed
    npcUnifiedCooldownList = parsed.cooldown or {}

    buildUnifiedNpcUI(parsed)

  -- After a refresh, if a task was previously selected by index but moved sections
  -- (e.g., items removed -> Completed -> Active), remap selection by taskNumber.
  local function remapSelection()
    if not npcSelectedTaskNumber or npcSelectedTaskNumber <= 0 then return end
    local function findIn(list)
      for i = 1, #list do
        local tnum = tonumber(list[i].taskNumber) or 0
        if tnum == npcSelectedTaskNumber then return i end
      end
      return 0
    end
    local idx = findIn(parsed.available or {})
    if idx > 0 then npcUnifiedSelectedKind = 'available'; npcSelectedTask = idx; UpdateNpcTaskDescription(); return end
    idx = findIn(parsed.active or {})
    if idx > 0 then npcUnifiedSelectedKind = 'active'; npcSelectedTask = idx; UpdateNpcTaskDescription(); return end
    idx = findIn(parsed.completed or {})
    if idx > 0 then npcUnifiedSelectedKind = 'completed'; npcSelectedTask = idx; UpdateNpcTaskDescription(); return end
    -- Fallback: ensure a sensible default focus
    if (#(parsed.active or {}) > 0) then npcUnifiedSelectedKind = 'active'; npcSelectedTask = 1
    elseif (#(parsed.available or {}) > 0) then npcUnifiedSelectedKind = 'available'; npcSelectedTask = 1
    elseif (#(parsed.completed or {}) > 0) then npcUnifiedSelectedKind = 'completed'; npcSelectedTask = 1
    else npcSelectedTask = 0 end
    UpdateNpcTaskDescription()
  end
  remapSelection()
    
    -- Combined list host (we reuse npcTaskListInProgress panel as the single list container)
    local leftRail = npcTaskWidget:getChildById('leftRail')
    if leftRail then
      -- Hide standalone section headers/panels on the left rail
      local function hideById(id)
        local w = npcTaskWidget:recursiveGetChildById(id)
        if w then pcall(function() w:setVisible(false) end); pcall(function() w:setHeight(0) end) end
      end
      hideById('availableHeader'); hideById('npcTaskListAvailable')
      hideById('inProgressHeader')
      hideById('completedHeader'); hideById('npcTaskListCompleted')

      local hostPanel = npcTaskWidget:recursiveGetChildById('npcTaskListInProgress')
      if hostPanel then
        -- Expand host panel to fill the left rail now that others are hidden
        pcall(function()
          local lh = leftRail:getHeight() or 0
          if lh > 0 then hostPanel:setHeight(lh - 48) end
        end)
        local list = hostPanel:recursiveGetChildById('npcTaskListPanel') or hostPanel
        if list.destroyChildren then list:destroyChildren() end

        local function addHeader(kind, titleText, count)
          local header = g_ui.createWidget('ZoneHeader', list)
          header:setId(
            kind == 'available' and 'combinedAvailableHeader' or
            (kind == 'inprogress' and 'combinedInProgHeader' or
            (kind == 'completed' and 'combinedCompletedHeader' or 'combinedCooldownHeader'))
          )
          local caret = header:getChildById('zoneCaret')
          local title = header:getChildById('zoneTitle')
          if title then title:setText(string.format('%s (%d)', tr(titleText), count)) end
          if caret then caret:setText(statusExpanded[kind] ~= false and '+' or '-') end
          header.onClick = function() toggleStatusSection(kind) end
          return header
        end

        -- Available section
        addHeader('available', 'Available', #parsed.available)
        for i = 1, #parsed.available do
          local rec = parsed.available[i]
          local row = g_ui.createWidget('NpcTaskRecord', list)
          row:setId('npcAvail_'.. tostring(i))
          row:getChildById('taskButton'):setText(tr(rec.taskName))
          local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 0)) end
          local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText(tr('Level %d', rec.taskMinLvl or 0)) end
          local badge = row:getChildById('taskBadge');
          if badge then
            local tag = tostring(rec.taskBadge or 'Story')
            badge:setText(tr(tag))
            local lc = tag:lower()
            if lc == 'story' then badge:setColor('#D4AF37')
            elseif lc == 'repeat' then badge:setColor('#66cc66')
            elseif lc == 'daily' then badge:setColor('#66ccff')
            elseif lc == 'quest' then badge:setColor('#ffffff')
            elseif lc == 'boss' or lc == 'dungeon' then badge:setColor('#ff4d4d')
            else badge:setColor('#D4AF37') end
          end
          -- Show full progress bar for completed
          local p = row:getChildById('taskProgress') or row:getChildById('progressBg')
          local pb = row:getChildById('taskProgressBar') or (p and p:getChildById('progressFill'))
          if p and pb then setProgressBar(p, pb, 1) end
        end

        -- In Progress section
        addHeader('inprogress', 'In Progress', #parsed.active)
        for i = 1, #parsed.active do
          local rec = parsed.active[i]
          local row = g_ui.createWidget('NpcTaskRecord', list)
          row:setId('npcInProg_'.. tostring(i))
          row:getChildById('taskButton'):setText(tr(rec.taskName))
          local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 1)) end
          local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText(tr('Level %d', rec.taskMinLvl or 0)) end
          local badge = row:getChildById('taskBadge');
          if badge then
            local tag = tostring(rec.taskBadge or (rec.taskRepeat and 'Repeat' or 'Story'))
            badge:setText(tr(tag))
            local lc = tag:lower()
            if lc == 'story' then badge:setColor('#D4AF37')
            elseif lc == 'repeat' then badge:setColor('#66cc66')
            elseif lc == 'daily' then badge:setColor('#66ccff')
            elseif lc == 'quest' then badge:setColor('#ffffff')
            elseif lc == 'boss' or lc == 'dungeon' then badge:setColor('#ff4d4d')
            else badge:setColor('#D4AF37') end
          end
          -- Support both NPC row progress ids and main TaskRecord ids
          local p = row:getChildById('taskProgress') or row:getChildById('progressBg')
          local pb = row:getChildById('taskProgressBar') or (p and p:getChildById('progressFill'))
          local cur = tonumber(rec.taskCurrentCnt or 0) or 0
          local goal = tonumber(rec.taskGoalCnt or 0) or 0
          local pct = (goal > 0) and math.max(0, math.min(1, cur / goal)) or 0
          if p and pb then setProgressBar(p, pb, pct) end
        end

        -- Completed section
        addHeader('completed', 'Completed', #parsed.completed)
        for i = 1, #parsed.completed do
          local rec = parsed.completed[i]
          local row = g_ui.createWidget('NpcTaskRecord', list)
          row:setId('npcCompleted_'.. tostring(i))
          row:getChildById('taskButton'):setText(tr(rec.taskName))
          local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 2)) end
          local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText(tr('Level %d', rec.taskMinLvl or 0)) end
          local badge = row:getChildById('taskBadge'); if badge then badge:setText(tr(rec.taskRepeat and 'Repeat' or 'Story')) end
          local p = row:getChildById('taskProgress'); if p then p:setVisible(false) end
        end

        -- Cooldown section
        addHeader('cooldown', 'On Cooldown', #parsed.cooldown)
        local hasZero2 = false
        for i = 1, #parsed.cooldown do
          local rec = parsed.cooldown[i]
          local row = g_ui.createWidget('NpcTaskRecord', list)
          row:setId('npcCooldown_'.. tostring(i))
          row:getChildById('taskButton'):setText(tr(rec.taskName))
          local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/0') end
          local cdLbl = row:getChildById('cooldownText')
          if cdLbl then
            local left = tonumber(rec.taskCooldownLeftSec or 0) or 0
            local hrs = math.floor(left / 3600)
            local mins = math.floor((left % 3600) / 60)
            local secs = left % 60
            local txt
            if left <= 0 then
              txt = tr('Ready')
            elseif hrs > 0 then
              txt = tr('Available in %dh %dm', hrs, mins)
            elseif mins > 0 then
              txt = tr('Available in %dm', mins)
            else
              txt = tr('Available in %ds', secs)
            end
            cdLbl:setText(txt)
          end
          local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText(tr('Level %d', rec.taskMinLvl or 0)) end
          -- track for ticker
          npcCooldownLeftByRow[row:getId()] = tonumber(rec.taskCooldownLeftSec or 0) or 0
          if (npcCooldownLeftByRow[row:getId()] or 0) <= 0 then hasZero2 = true end
          local badge = row:getChildById('taskBadge');
          if badge then
            local tag = tostring(rec.taskBadge or 'Story')
            badge:setText(tr(tag))
            local lc = tag:lower()
            if lc == 'story' then badge:setColor('#D4AF37')
            elseif lc == 'repeat' then badge:setColor('#66cc66')
            elseif lc == 'daily' then badge:setColor('#66ccff')
            elseif lc == 'quest' then badge:setColor('#ffffff')
            elseif lc == 'boss' or lc == 'dungeon' then badge:setColor('#ff4d4d')
            else badge:setColor('#D4AF37') end
          end
          -- hide progress bar
          local p = row:getChildById('taskProgress'); if p then p:setVisible(false) end
          -- allow selection to show description; Accept will be disabled
          row.onClick = modules.game_tasklist.onNpcUnifiedRowClick
        end
        if hasZero2 then
          local p = g_game.getProtocolGame(); if p then p:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
        end
      end
    end
    if (#parsed.active or 0) > 0 and statusExpanded.inprogress == false then
      statusExpanded.inprogress = true
      pcall(function() g_settings.set('game_tasklist/npc/inprogress_expanded', '1') end)
    end
    if (#parsed.completed or 0) > 0 and statusExpanded.completed == false then
      statusExpanded.completed = true
      pcall(function() g_settings.set('game_tasklist/npc/completed_expanded', '1') end)
    end
    applyStatusVisibility('available')
    applyStatusVisibility('inprogress')
    applyStatusVisibility('completed')
    return
  end

  -- Legacy behavior (separate windows)
    lastOpcode = opcode
    npcTaskList = {}
    npcTaskList = parseIncomingTaskList(buffer)

    -- If no tasks are available, keep the NPC Task Window open for reward/completed views
    -- and subsequent updates; just proceed to (re)build the UI without closing.
    -- This avoids unintended closes in legacy flows when only the available list is empty.
    -- if #npcTaskList == 0 then
    --     return
    -- end

    -- Reuse or create the NPC task window
    if not npcTaskWidget or (npcTaskWidget.isDestroyed and npcTaskWidget:isDestroyed()) then
      npcTaskWidget = g_ui.createWidget('NpcTaskListWidget', modules.game_interface.getRootPanel())
      npcTaskWidget:setPosition({x = 600, y = 300})
    end
    npcTaskWidget:setText(tr("Main Story Quests"))
    translateUI(npcTaskWidget)
    setAcceptState('Accept', true)
    npcTaskWidget:show(); npcTaskWidget:raise(); npcTaskWidget:focus()

    -- Clear old list/description content using the unified list panel
    local listHost = npcTaskWidget:recursiveGetChildById('npcTaskListInProgress') or npcTaskWidget
    local npcTaskListPanel = listHost and (listHost:recursiveGetChildById('npcTaskListPanel') or listHost) or nil
    if npcTaskListPanel and npcTaskListPanel.destroyChildren then npcTaskListPanel:destroyChildren() end
    local descHost = npcTaskWidget:getChildById('npcTaskDescription')
    local npcTaskDescPanel = descHost and descHost:recursiveGetChildById('npcTaskListPanel') or nil
    if npcTaskDescPanel and npcTaskDescPanel.destroyChildren then npcTaskDescPanel:destroyChildren() end
    npcTaskDescription = g_ui.createWidget('NpcTaskDescription', npcTaskDescPanel)
    if npcTaskListPanel then
      for i = 1, #npcTaskList, 1 do
        local taskButton = g_ui.createWidget('NpcTaskWidget', npcTaskListPanel)
        taskButton:setId("npcTaskButton"..tostring(i))
        taskButton:getChildById('taskButton'):setText(npcTaskList[i].taskName)
      end
    end
    do
      local ab = npcTaskWidget:getChildById("acceptButton")
      if #npcTaskList == 0 then
        if ab then ab:hide() end
      else
        if ab then ab:show(); ab:setEnabled(true) end
        -- default select first task so Accept works without clicking
        npcSelectedTask = 1
      end
    end
    UpdateNpcTaskDescription()
end

function onExtendedNpcRewardList(protocol, opcode, buffer)
    lastOpcode = opcode
    npcRewardList = {}
    npcRewardList = parseIncomingTaskList(buffer)

    -- Reuse or create the NPC task window
    if not npcTaskWidget or (npcTaskWidget.isDestroyed and npcTaskWidget:isDestroyed()) then
      npcTaskWidget = g_ui.createWidget('NpcTaskListWidget', modules.game_interface.getRootPanel())
      npcTaskWidget:setPosition({x = 600, y = 300})
    end
    npcTaskWidget:setText(tr("NPC claim reward"))
    translateUI(npcTaskWidget)
    setAcceptState('Claim', true)
    npcTaskWidget:show(); npcTaskWidget:raise(); npcTaskWidget:focus()

    -- Clear old list/description content using the unified list panel
    local listHost = npcTaskWidget:recursiveGetChildById('npcTaskListInProgress') or npcTaskWidget
    local npcTaskListPanel = listHost and (listHost:recursiveGetChildById('npcTaskListPanel') or listHost) or nil
    if npcTaskListPanel and npcTaskListPanel.destroyChildren then npcTaskListPanel:destroyChildren() end
    local descHost = npcTaskWidget:getChildById('npcTaskDescription')
    local npcTaskDescPanel = descHost and descHost:recursiveGetChildById('npcTaskListPanel') or nil
    if npcTaskDescPanel and npcTaskDescPanel.destroyChildren then npcTaskDescPanel:destroyChildren() end
    npcTaskDescription = g_ui.createWidget('NpcTaskDescription', npcTaskDescPanel)
    if npcTaskListPanel then
      for i = 1, #npcRewardList, 1 do
        local taskButton = g_ui.createWidget('NpcTaskWidget', npcTaskListPanel)
        taskButton:setId("npcRewardButton"..tostring(i))
        taskButton:getChildById('taskButton'):setText(npcRewardList[i].taskName)
      end
    end
    do
      local ab = npcTaskWidget:getChildById("acceptButton")
      if #npcRewardList == 0 then
        if ab then ab:hide() end
      else
        if ab then ab:show(); ab:setEnabled(true) end
        -- default select first reward so Claim works without clicking
        npcSelectedTask = 1
      end
    end
    UpdateNpcTaskDescription()
end

function init()
    g_ui.importStyle('npc_tasklist')

   taskListButton = modules.game_mainpanel.addStoreButton('taskListButton', tr('Quest List'), '/images/options/quests_large', toggle,
        false, 2)
    taskListButton:setOn(false)

    if not opsRegistered then
      local function safeRegister(op, cb)
        pcall(function() ProtocolGame.unregisterExtendedOpcode(op) end)
        ProtocolGame.registerExtendedOpcode(op, cb)
      end
      safeRegister(ExtendedIds.TaskList, onExtendedTaskList)
      safeRegister(ExtendedIds.UpdateTask, onExtendedUpdateTask)
      safeRegister(ExtendedIds.NpcTaskList, onExtendedNpcTaskList)
      safeRegister(ExtendedIds.NpcRewardList, onExtendedNpcRewardList)
      safeRegister(ExtendedIds.NpcTaskWindowClose, onExtendedNpcTaskWindowClose)
      safeRegister(ExtendedIds.QuestCompletedImage, onExtendedQuestCompletedImage)
      opsRegistered = true
    end

    taskListsWindow = g_ui.displayUI('game_tasklist', modules.game_interface.getRightPanel())
    questCompletedWidget = g_ui.loadUI('quest_completed_image', modules.game_interface.getMapPanel())
    questCompletedWidget:hide()
    translateUI(taskListsWindow)
    taskDescriptionWindow = taskListsWindow:recursiveGetChildById('taskDescriptionWnd')
    taskDescriptionWindow:hide()
	taskRewardItemPanel = taskDescriptionWindow:recursiveGetChildById('rewardItemsPanel')
    taskListPanel = taskListsWindow:recursiveGetChildById('taskListPanel')
    taskListsWindow:hide()
    deleteButton = taskListsWindow:recursiveGetChildById('deleteButton')
    deleteButton:hide()

    -- populate status filter options (skin does not support OTUI-defined options)
    local statusFilter = taskListsWindow:getChildById('statusFilter') or taskListsWindow:getChildById('levelFilter')
    if statusFilter then
      if statusFilter.clearOptions then pcall(function() statusFilter:clearOptions() end) end
      if statusFilter.addOption then
        statusFilter:addOption(tr('All'))
        statusFilter:addOption(tr('Active'))
        statusFilter:addOption(tr('Completed'))
      end
      if statusFilter.setCurrentIndex then statusFilter:setCurrentIndex(0) end
    end

    if g_game.isOnline() then
      online()
    end
end

function terminate()
    pcall(function() ProtocolGame.unregisterExtendedOpcode(ExtendedIds.TaskList) end)
    pcall(function() ProtocolGame.unregisterExtendedOpcode(ExtendedIds.UpdateTask) end)
    pcall(function() ProtocolGame.unregisterExtendedOpcode(ExtendedIds.NpcTaskList) end)
    pcall(function() ProtocolGame.unregisterExtendedOpcode(ExtendedIds.NpcRewardList) end)
    pcall(function() ProtocolGame.unregisterExtendedOpcode(ExtendedIds.NpcTaskWindowClose) end)
    pcall(function() ProtocolGame.unregisterExtendedOpcode(ExtendedIds.QuestCompletedImage) end)
    opsRegistered = false
    if taskListsWindow then
      taskListsWindow:destroy()
      taskListsWindow = nil
      taskDescriptionWindow = nil
      taskListPanel = nil
      deleteButton = nil
    end
    if npcAutoRefreshEvent and removeEvent then removeEvent(npcAutoRefreshEvent) end
    npcAutoRefreshEvent = nil
    if questCompletedWidget then
      questCompletedWidget:destroy()
      questCompletedWidget = nil
    end
end

function toggle()
    if taskListButton:isOn() then
            hide()
    else
            openWindow()
    end
end

function online()
end

function offline()
    hide()
end

function openWindow()
  -- ensure UI exists in case toggle fired before init finished or after a reload
  if not taskListsWindow or taskListsWindow:isDestroyed() then
    taskListsWindow = g_ui.displayUI('game_tasklist', modules.game_interface.getRightPanel())
    translateUI(taskListsWindow)
    taskDescriptionWindow = taskListsWindow:recursiveGetChildById('taskDescriptionWnd')
    if taskDescriptionWindow then taskDescriptionWindow:hide() end
    taskListPanel = taskListsWindow:recursiveGetChildById('taskListPanel')
    deleteButton = taskListsWindow:recursiveGetChildById('deleteButton')
    if deleteButton then deleteButton:hide() end
  end
  taskListButton:setOn(true)
  taskListsWindow:show()
  taskListsWindow:raise()
  taskListsWindow:focus()
  local protocol = g_game.getProtocolGame()
  if protocol then
    protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "")
  end
end

function hide()
  for i = #localTaskWdgList, 1, -1 do
    localTaskWdgList[i]:destroy()
    table.remove(localTaskWdgList, i)
  end
   for i = #localRewardItemList, 1, -1 do
    localRewardItemList[i]:destroy()
    table.remove(localRewardItemList, i)
  end
  -- clear references to destroyed choice widgets to avoid warnings
  for taskNum, widgets in pairs(choiceWidgetsByTask) do
    choiceWidgetsByTask[taskNum] = nil
  end
  taskListButton:setOn(false)
  taskDescriptionWindow:hide()
  taskListsWindow:hide()
  modules.game_interface.getRootPanel():focus()
end

function yes()
    if askWidget then
        askWidget:destroy()
        askWidget = nil
    end
    -- print("selected task do delete:"..tostring(currentSelectedTask))
    local protocol = g_game.getProtocolGame()
    local tnum = tonumber(currentSelectedTask) or tonumber(tostring(currentSelectedTask):match("(%d+)")) or 0
    if protocol and tnum > 0 then
      protocol:sendExtendedOpcode(ClientOpcodes.ClientDeleteTask, tostring(tnum))
    end
    deleteButton:hide()
    currentSelectedTask = 0
    for i = #localTaskWdgList, 1, -1 do
      localTaskWdgList[i]:destroy()
      table.remove(localTaskWdgList, i)
    end
    for i = #localRewardItemList, 1, -1 do
      localRewardItemList[i]:destroy()
      table.remove(localRewardItemList, i)
    end
    -- clear references for the deleted task (and any others) to avoid stale refs
    for taskNum, widgets in pairs(choiceWidgetsByTask) do
      choiceWidgetsByTask[taskNum] = nil
    end
    -- Optimistically remove the task from the local list so it disappears immediately
    if tnum > 0 then
      local newList = {}
      for _, t in ipairs(localTaskList or {}) do
        local raw = tostring(t.taskNumber or '')
        local n = tonumber(raw) or tonumber(raw:match('(%d+)'))
        if not (n and n == tnum) then table.insert(newList, t) end
      end
      localTaskList = newList
    end
    taskDescriptionWindow:hide()
    -- Rebuild the main list UI to reflect removal immediately
    buildGroupedTaskList()
    if protocol then
      protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "")
    end
end

function no()
    if askWidget then
        askWidget:destroy()
        askWidget = nil
    end
end

function delete()
    if askWidget then
        return
    end
    askWidget = g_ui.createWidget('AskWidget', taskListsWindow)
    askWidget:show()
    askWidget:raise()
    askWidget:focus()
end

function onNpcTaskSelectClick(widget)
    local wdgId = widget:getParent():getId()
    local taskId = 0
    if lastOpcode == ExtendedIds.NpcTaskList then
        taskId = string.sub(wdgId, 14)
    elseif lastOpcode == ExtendedIds.NpcRewardList then
        taskId = string.sub(wdgId, 16)
    end
    npcSelectedTask = tonumber(taskId)
    -- selection debug removed to avoid server chat spam
    -- Persist the actual taskNumber so we can remap selection after server recompute
    do
      local list
      if npcUnifiedSelectedKind == 'available' then list = npcTaskList
      elseif npcUnifiedSelectedKind == 'active' then list = npcActiveList
      elseif npcUnifiedSelectedKind == 'completed' then list = npcRewardList
      end
      if list and list[npcSelectedTask] then
        npcSelectedTaskNumber = tonumber(list[npcSelectedTask].taskNumber) or 0
      end
    end
    UpdateNpcTaskDescription()
	npcTaskWidget:getChildById("acceptButton"):show()
end

function sendSelectTask(taskId)
    local protocol = g_game.getProtocolGame()
    if protocol then
        -- In unified mode, completed list should trigger reward select
        if npcUnifiedSelectedKind == 'completed' then
            local choiceIdx = selectedChoiceByTask and selectedChoiceByTask[tonumber(taskId)] or 0
            -- if server indicates there are choices but user didn't pick, stop and remind
            local hasChoices = false
            for _, rec in ipairs(npcRewardList or {}) do
              if tostring(rec.taskNumber) == tostring(taskId) then
                local ch = (rec.taskRewards and rec.taskRewards.choice) or {}
                hasChoices = (ch and #ch > 0)
                break
              end
            end
            if hasChoices and (not choiceIdx or choiceIdx <= 0) then
              showChoiceReminder(); return
            end
            local payload = tostring(taskId)
            if choiceIdx and choiceIdx > 0 then payload = payload .. ':' .. tostring(choiceIdx) end
            protocol:sendExtendedOpcode(ClientOpcodes.ClientSelectReward, payload)
            -- removed chat log to avoid server-bound spam
            -- proactively refresh unified NPC window so the completed task disappears after claim
            pcall(function()
              for _, delay in ipairs(REFRESH_PINGS_MS) do
                if delay == 0 then
                  protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "")
                elseif scheduleEvent then
                  scheduleEvent(function()
                    local p = g_game.getProtocolGame(); if p then p:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
                  end, delay)
                end
              end
              if scheduleEvent then
                scheduleEvent(function() actionInFlight = false; setAcceptState('Claim', true) end, ACCEPT_LOCK_TIMEOUT_MS)
              end
            end)
            actionInFlight = true; setAcceptState(PROCESSING_LABEL, false)
        elseif lastOpcode == ExtendedIds.NpcTaskList then
            protocol:sendExtendedOpcode(ClientOpcodes.ClientSelectTask, tostring(taskId))
            -- accept debug removed to avoid server chat spam
            -- proactively refresh unified NPC window so the task moves to In Progress without closing
            pcall(function()
          -- Single immediate refresh and one gentle follow-up to avoid spam
          if not actionInFlight then
            protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "")
            if scheduleEvent then
              scheduleEvent(function()
                local p2 = g_game.getProtocolGame(); if p2 then p2:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
              end, 300)
              -- safety: clear lock after timeout if server never answers
              scheduleEvent(function() actionInFlight = false; setAcceptState('Accept', true) end, ACCEPT_LOCK_TIMEOUT_MS)
            end
          end
        end)
        actionInFlight = true; setAcceptState(PROCESSING_LABEL, false)
        elseif lastOpcode == ExtendedIds.NpcRewardList then
            -- append selected choice index if any, format: taskId:choiceIdx
            local choiceIdx = selectedChoiceByTask and selectedChoiceByTask[tonumber(taskId)] or 0
            local hasChoices = false
            for _, rec in ipairs(npcRewardList or {}) do
              if tostring(rec.taskNumber) == tostring(taskId) then
                local ch = (rec.taskRewards and rec.taskRewards.choice) or {}
                hasChoices = (ch and #ch > 0)
                break
              end
            end
            if hasChoices and (not choiceIdx or choiceIdx <= 0) then
              showChoiceReminder(); return
            end
            local payload = tostring(taskId)
            if choiceIdx and choiceIdx > 0 then payload = payload .. ':' .. tostring(choiceIdx) end
            protocol:sendExtendedOpcode(ClientOpcodes.ClientSelectReward, payload)
         --   g_game.talk("[Quest] Claiming reward for task " .. tostring(taskId))
            actionInFlight = true; setAcceptState('Processing...', false)
        end
    end
end

-- server requested to close NPC task window (e.g., max tasks reached or flow end)
function onExtendedNpcTaskWindowClose(protocol, opcode, buffer)
  -- Ignore auto-close; just refresh to reflect latest state and keep the window open
  local proto = g_game.getProtocolGame()
  if proto then proto:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
end

function onExtendedQuestCompletedImage(protocol, opcode, buffer)
  if not questCompletedWidget or questCompletedWidget:isDestroyed() then
    questCompletedWidget = g_ui.loadUI('quest_completed_image', modules.game_interface.getMapPanel())
  end
  if not questCompletedWidget then return end
  questCompletedWidget:raise()
  questCompletedWidget:show()
  g_effects.fadeIn(questCompletedWidget, 250)
  scheduleEvent(function()
    if questCompletedWidget and not questCompletedWidget:isDestroyed() then
      g_effects.fadeOut(questCompletedWidget, 250)
    end
  end, 3000)
end


function UpdateNpcTaskDescription()
  dbg('UpdateNpcTaskDescription enter kind='.. tostring(npcUnifiedSelectedKind) ..' sel='.. tostring(npcSelectedTask))
  if not npcTaskDescription then dbg('UpdateNpcTaskDescription abort: npcTaskDescription nil'); return end
  if not npcUnifiedSelectedKind or npcSelectedTask == 0 then
    if npcTaskDescription.hide then npcTaskDescription:hide() end
    dbg('UpdateNpcTaskDescription early return: no selection or kind')
    return
  end

  local list
  if npcUnifiedSelectedKind == 'available' then
    list = npcTaskList
  elseif npcUnifiedSelectedKind == 'active' then
    list = npcUnifiedActiveList
  elseif npcUnifiedSelectedKind == 'completed' then
    list = npcRewardList
  elseif npcUnifiedSelectedKind == 'cooldown' then
    list = npcUnifiedCooldownList
  else
    if npcTaskDescription.hide then npcTaskDescription:hide() end
    dbg('UpdateNpcTaskDescription no matching list for kind='.. tostring(npcUnifiedSelectedKind))
    return
  end
  if not npcSelectedTask or npcSelectedTask < 1 or npcSelectedTask > #list then npcSelectedTask = 1 end

  local rec = list[npcSelectedTask]
  if not rec then dbg('UpdateNpcTaskDescription abort: rec nil'); return end

  if npcTaskDescription.show then npcTaskDescription:show() end
  switchNpcTaskTab('details')
  local title = npcTaskDescription:recursiveGetChildById('taskTitle')
  local desc = npcTaskDescription:recursiveGetChildById('taskDescription')
  if title then title:setText(tr(rec.taskName)) end
  if desc then desc:setText(tr(rec.taskDesc)); desc:setTextAutoResize(true) end

  -- Debug: log the selected task's current/goal and state as received
  do
    local tnum = tonumber(rec.taskNumber) or 0
    local st = tonumber(rec.taskState) or -1
    local cur = tonumber(rec.taskCurrentCnt) or 0
    local goal = tonumber(rec.taskGoalCnt) or 0
    dbg(string.format('[Client][NPC:%s] Selected task #%d "%s" kind=%s state=%d cur=%d goal=%d',
      tostring(rec.taskSourceNpc or ''), tnum, tostring(rec.taskName), tostring(npcUnifiedSelectedKind), st, cur, goal))
  end

  -- Rewards basic (match main TaskDescription style)
  local expLbl = npcTaskDescription:recursiveGetChildById('rewardExp')
  if expLbl then expLbl:setText(tr('EXP %d', rec.taskRewards.exp or 0)) end
  local moneyLbl = npcTaskDescription:recursiveGetChildById('rewardMoney')
  local moneyIcon = npcTaskDescription:recursiveGetChildById('rewardMoneyIcon')
  local money = (rec.taskRewards and rec.taskRewards.money) or 0
  if money > 0 then
    if moneyLbl then moneyLbl:setText(tr('GOLD %d', money)); moneyLbl:setVisible(true) end
    if moneyIcon then moneyIcon:setVisible(true) end
  else
    if moneyLbl then moneyLbl:setText(''); moneyLbl:setVisible(false) end
    if moneyIcon then moneyIcon:setVisible(false) end
  end

  -- Codex rewards (NPC pane)
  local npcCodexLbl = npcTaskDescription:recursiveGetChildById('rewardCodex')
  if npcCodexLbl then
    local codexParts = {}
    local ce = (rec.taskRewards and rec.taskRewards.codex_essences) or 0
    if ce > 0 then table.insert(codexParts, tr('%d Codex Essences', ce)) end
    local cc = (rec.taskRewards and rec.taskRewards.codex_crates) or {}
    for _, cr in ipairs(cc) do
      table.insert(codexParts, tr('%dx %s', cr.amount, tr(cr.name)))
    end
    if #codexParts > 0 then
      npcCodexLbl:setText(table.concat(codexParts, '  +  '))
      npcCodexLbl:setHeight(15)
      npcCodexLbl:setVisible(true)
    else
      npcCodexLbl:setText('')
      npcCodexLbl:setHeight(0)
      npcCodexLbl:setVisible(false)
    end
  end

  -- Populate Objectives / Progress / Hints / Zone / Source (NPC description panel)
  do
    local goals = rec.taskGoals or {}

    -- Monsters
    local monLbl = npcTaskDescription:recursiveGetChildById('monsterGoals')
    if monLbl then
      if goals.monsters and #goals.monsters > 0 then
        local names = {}
        for i = 1, #goals.monsters do names[#names+1] = tostring(goals.monsters[i].name) end
        monLbl:setText(tr('You have to kill: %s.', table.concat(names, ', ')))
        monLbl:setVisible(true)
      else
        monLbl:setText('')
        monLbl:setVisible(false)
      end
    end

    -- Items
    local itemLbl = npcTaskDescription:recursiveGetChildById('itemGoals')
    if itemLbl then
      if goals.items and #goals.items > 0 then
        local names = {}
        for i = 1, #goals.items do names[#names+1] = tostring(goals.items[i].name) end
        itemLbl:setText(tr('You have to collect: %s.', table.concat(names, ', ')))
        itemLbl:setVisible(true)
      else
        itemLbl:setText('')
        itemLbl:setVisible(false)
      end
    end


    -- Storages
    local storLbl = npcTaskDescription:recursiveGetChildById('storageGoals')
    if storLbl then
      if goals.storages and #goals.storages > 0 then
        local names = {}
        for i = 1, #goals.storages do names[#names+1] = tostring(goals.storages[i].starageName) end
        storLbl:setText(tr('You have to do: %s.', table.concat(names, ', ')))
        storLbl:setVisible(true)
      else
        storLbl:setText('')
        storLbl:setVisible(false)
      end
    end

    -- Objectives header + divider
    local anyObj = (goals.monsters and #goals.monsters > 0) or (goals.items and #goals.items > 0) or (goals.storages and #goals.storages > 0)
    local objTitle = npcTaskDescription:recursiveGetChildById('taskObjectives')
    if objTitle then objTitle:setVisible(anyObj and true or false) end
    local objDiv = npcTaskDescription:recursiveGetChildById('objectivesDivider')
    if objDiv then objDiv:setVisible(anyObj and true or false) end

    -- Progress label (current/goal)
    local cntLbl = npcTaskDescription:recursiveGetChildById('itemCnt')
    if cntLbl then
      local cur = tonumber(rec.taskCurrentCnt or 0) or 0
      local goal = tonumber(rec.taskGoalCnt or 0) or 0
      if goal > 0 then
        cntLbl:setText(string.format('%d/%d', cur, goal))
        cntLbl:setVisible(true)
      else
        cntLbl:setText('')
        cntLbl:setVisible(false)
      end
    end

    -- Hints / Zone / Source
    local hintLbl = npcTaskDescription:recursiveGetChildById('taskHint')
    if hintLbl then
      local hv = tostring(rec.taskHint or rec.taskHintNpc or '')
      hintLbl:setText(tr(hv))
      hintLbl:setVisible(hv ~= '')
    end
    local zoneLbl = npcTaskDescription:recursiveGetChildById('taskZoneName')
    if zoneLbl then
      local zv = tostring(rec.taskZoneName or rec.taskZone or '')
      zoneLbl:setText(tr(zv))
      zoneLbl:setVisible(zv ~= '')
    end
    local srcLbl = npcTaskDescription:recursiveGetChildById('taskSource')
    if srcLbl then
      local sv = tostring(rec.taskSource or rec.taskSourceNpc or '')
      srcLbl:setText(tr(sv))
      srcLbl:setVisible(sv ~= '')
    end
  end

  -- Outfit
  local npcOutfitLbl = npcTaskDescription:recursiveGetChildById('rewardOutfit')
  if npcOutfitLbl then
    local outfits = (rec.taskRewards and rec.taskRewards.outfits) or {}
    if outfits and #outfits > 0 then
      local outfit = outfits[1]
      local text = tr('Outfit: %s', tr(outfit.name))
      if outfit.addon and outfit.addon > 0 then text = tr('%s (Addon %d)', text, outfit.addon) end
      npcOutfitLbl:setText(text)
      npcOutfitLbl:setVisible(true)
    else
      npcOutfitLbl:setText('')
      npcOutfitLbl:setVisible(false)
    end
  end

  -- Items
  npcRewardItemPanel = npcTaskDescription:recursiveGetChildById('rewardItemsPanel')
  local npcBasicRewardsPanel = npcTaskDescription:recursiveGetChildById('basicRewards')
  -- Clear old refs from previous NPC renders to avoid stale references warnings
  for i = #localRewardItemList, 1, -1 do
    localRewardItemList[i] = nil
  end
  if npcRewardItemPanel and npcRewardItemPanel.destroyChildren then npcRewardItemPanel:destroyChildren() end
  local npcRewardTarget = npcRewardItemPanel and (npcRewardItemPanel:getChildById('rewardItemsBox') or npcRewardItemPanel:recursiveGetChildById('rewardItemsBox') or npcRewardItemPanel) or nil
  local items = (rec.taskRewards and rec.taskRewards.items) or {}
  if items and #items > 0 then
    if npcRewardItemPanel and npcRewardItemPanel.show then npcRewardItemPanel:show() end
    if npcBasicRewardsPanel and npcBasicRewardsPanel.show then npcBasicRewardsPanel:show() end
    for i = 1, #items do
      local it = items[i]
      local rewardItem = g_ui.createWidget('TasklistRewardItem', npcRewardTarget)
      -- Do not persist NPC reward item widgets in localRewardItemList to prevent holding references after destroy
      rewardItem:getChildById('rewardItem'):setItemId(it.itemCid)
      rewardItem:getChildById('rewardItem'):setVirtual(true)
      rewardItem:getChildById('rewardItem'):setItemCount(it.itemCnt)
      rewardItem:getChildById('rewardItemCnt'):setText(tr('x %d', it.itemCnt))
      rewardItem:getChildById('rewardItemName'):setText(tr(it.name))
    end
    adjustRewardPanelHeight(npcBasicRewardsPanel, #items, 4)
  else
    if npcRewardItemPanel and npcRewardItemPanel.hide then npcRewardItemPanel:hide() end
    if npcBasicRewardsPanel and npcBasicRewardsPanel.hide then npcBasicRewardsPanel:hide() end
  end

  -- Choice rewards (NPC pane) with same row size as basic rewards
  do
    local choiceContainer = npcTaskDescription:recursiveGetChildById('choiceRewards')
    local choiceTitle = npcTaskDescription:recursiveGetChildById('choiceRewardsTitle')
    local choicePanel = choiceContainer and (choiceContainer:getChildById('rewardItemsPanel') or choiceContainer:recursiveGetChildById('rewardItemsPanel')) or nil
    if choicePanel and choicePanel.destroyChildren then choicePanel:destroyChildren() end
    local choiceTarget = choicePanel and (choicePanel:getChildById('rewardItemsBox') or choicePanel:recursiveGetChildById('rewardItemsBox') or choicePanel) or nil
    local choices = (rec.taskRewards and rec.taskRewards.choice) or {}
    if choicePanel and choices and #choices > 0 then
      if choiceTitle then choiceTitle:setVisible(true) end
      if choiceContainer and choiceContainer.show then choiceContainer:show() end
      local tnum = tonumber(rec.taskNumber) or 0
      local selectedIdx = selectedChoiceByTask[tnum] or 0
      for i = 1, #choices do
        -- Mirror main UI structure exactly: wrapper + ChoiceListItem as inner row
        local wrap = g_ui.createWidget('ChoiceRowWrapper', choiceTarget)
        wrap:setId('npcChoiceWrap'..i)
        local cw = g_ui.createWidget('ChoiceListItem', wrap)
        cw:setId('choiceInner')
        local cid = choices[i].itemCid or choices[i].itemSid or 0
        cw:getChildById('rewardItem'):setItemId(cid)
        cw:getChildById('rewardItem'):setVirtual(true)
        cw:getChildById('rewardItem'):setItemCount(choices[i].itemCnt)
        cw:getChildById('rewardItemCnt'):setText(tr('x %d', choices[i].itemCnt))
        cw:getChildById('rewardItemName'):setText(tr(choices[i].name))
        local function apply()
          selectedChoiceByTask[tnum] = i
          pcall(function() g_settings.set('game_tasklist/choice/'.. tostring(tnum), tostring(i)) end)
          for _, sWrap in ipairs((choiceTarget and choiceTarget.getChildren) and choiceTarget:getChildren() or choicePanel:getChildren()) do
            local inner = sWrap and sWrap:getChildById('choiceInner') or sWrap
            if inner and inner.mergeStyle then
              if sWrap == wrap then
                inner:mergeStyle({ background = '#2f3b4a', ['border-color'] = '#5aa0ff', ['border-width'] = 1 })
              else
                inner:mergeStyle({ background = '#00000033', ['border-color'] = '#333333', ['border-width'] = 1 })
              end
            end
          end
        end
        wrap.onClick = apply
        cw.onClick = apply
        if i == selectedIdx then
          cw:mergeStyle({ background = '#2f3b4a', ['border-color'] = '#5aa0ff', ['border-width'] = 1 })
        else
          cw:mergeStyle({ background = '#00000033', ['border-color'] = '#333333', ['border-width'] = 1 })
        end
      end
      adjustRewardPanelHeight(choiceContainer, #choices, 4)
    else
      if choiceTitle then choiceTitle:setVisible(false) end
      if choiceContainer and choiceContainer.hide then choiceContainer:hide() end
    end
  end
  dbg('UpdateNpcTaskDescription done for index='.. tostring(npcSelectedTask))
end


function acceptNpcTask()
  dbg('acceptNpcTask pressed; opcode='.. tostring(lastOpcode) ..' kind='.. tostring(npcUnifiedSelectedKind) ..' sel='.. tostring(npcSelectedTask))
  -- Unified mode: map selection to the correct list
  if npcUnifiedSelectedKind then
    if actionInFlight then dbg('acceptNpcTask ignored: action in flight'); return end
    local list = (npcUnifiedSelectedKind == 'completed') and npcRewardList or npcTaskList
    if (not npcSelectedTask or npcSelectedTask <= 0) and list and #list > 0 then
      npcSelectedTask = 1
    end
    -- Do not allow accepting a task that is already in progress
    if npcUnifiedSelectedKind == 'active' then
      dbg('acceptNpcTask ignored: task already in progress')
      return
    end
    if list and list[npcSelectedTask] then
      local rawTaskNumber = tostring(list[npcSelectedTask].taskNumber)
      local tnum = tonumber(rawTaskNumber) or tonumber((rawTaskNumber or ''):match("(%d+)"))
      -- Guard: if this is a completed list with choices and no selection, remind instead of sending
      if npcUnifiedSelectedKind == 'completed' then
        local rec = list[npcSelectedTask]
        local hasChoices = rec and rec.taskRewards and rec.taskRewards.choice and #rec.taskRewards.choice > 0
        local sel = selectedChoiceByTask[tonumber(rec.taskNumber) or 0] or 0
        if hasChoices and sel <= 0 then showChoiceReminder(); return end
      end
      if tnum and tnum > 0 then
        -- Optimistic client-side move: if accepting from Available, move the row to In Progress or Completed immediately
        if npcUnifiedSelectedKind == 'available' and lastUnified and lastUnified.available and lastUnified.active and lastUnified.completed then
          local selRec = list[npcSelectedTask]
          local moved = false
          if selRec and selRec.taskNumber then
            local selNum = tostring(selRec.taskNumber)
            for i = #lastUnified.available, 1, -1 do
              local r = lastUnified.available[i]
              if tostring(r.taskNumber) == selNum then
                -- decide target based on immediate progress
                local cur = tonumber(r.taskCurrentCnt or 0) or 0
                local goal = tonumber(r.taskGoalCnt or 0) or 0
                table.remove(lastUnified.available, i)
                if goal > 0 and cur >= goal then
                  r.taskState = 2 -- completed
                  table.insert(lastUnified.completed, r)
                  -- After accept, prefer focusing next available task, not the moved one
                  npcUnifiedSelectedKind = 'available'
                  focusNextAvailableAfterAccept = true
                else
                  r.taskState = 1 -- in progress
                  table.insert(lastUnified.active, r)
                  -- After accept, prefer focusing next available task, not the moved one
                  npcUnifiedSelectedKind = 'available'
                  focusNextAvailableAfterAccept = true
                end
                moved = true
                break
              end
            end
          end
          if moved then
            buildUnifiedNpcUI({ available = lastUnified.available, active = lastUnified.active, completed = lastUnified.completed })
            -- leave selection to focusNextAvailableAfterAccept handler in buildUnifiedNpcUI
          end
        end
        -- Always send the action to server. sendSelectTask() routes to Accept or Claim
        -- and enforces reward choice selection for completed tasks.
        sendSelectTask(tnum)
      else
        dbg("ERROR: could not parse a valid taskNumber from '" .. tostring(rawTaskNumber) .. "'")
        return
      end
      -- Do NOT close NPC widget here; request a refresh so the accepted quest moves to In Progress
      local protocol = g_game.getProtocolGame()
      if protocol then dbg('acceptNpcTask requesting main list refresh'); protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
    end
    return
  end

  -- Legacy mode (kept intact)
  -- default to first entry if user didn't click any
  if (not npcSelectedTask or npcSelectedTask == 0) then
      if lastOpcode == ExtendedIds.NpcTaskList and #npcTaskList > 0 then
          npcSelectedTask = 1
      elseif lastOpcode == ExtendedIds.NpcRewardList and #npcRewardList > 0 then
          npcSelectedTask = 1
      end
  end
  if npcSelectedTask and npcSelectedTask > 0 then
      local taskListToShow = nil
      local buttonIdStr = ""
      if lastOpcode == ExtendedIds.NpcTaskList then
          taskListToShow = npcTaskList
          buttonIdStr = "npcTaskButton"
      elseif lastOpcode == ExtendedIds.NpcRewardList then
          taskListToShow = npcRewardList
          buttonIdStr = "npcRewardButton"
      end
      if taskListToShow and taskListToShow[npcSelectedTask] then
          local rawTaskNumber = tostring(taskListToShow[npcSelectedTask].taskNumber)
          local tnum = tonumber(rawTaskNumber) or tonumber(rawTaskNumber:match("(%d+)"))
          -- removed chat log to avoid server-bound spam
          if tnum and tnum > 0 then
            sendSelectTask(tnum)
          else
            -- removed chat log to avoid server-bound spam
            return
          end
          table.remove(taskListToShow, npcSelectedTask)
          local protocol = g_game.getProtocolGame()
          if protocol then protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
      end
      if npcTaskWidget then
          local npcTaskListPanel = npcTaskWidget:getChildById("npcTaskList"):recursiveGetChildById('npcTaskListPanel')
          local button = npcTaskListPanel:recursiveGetChildById(buttonIdStr..tostring(npcSelectedTask))
          if button then npcTaskListPanel:removeChild(button) end
      end
      if #taskListToShow == 1 then
          sendSelectTask(taskListToShow[1].taskNumber)
          table.remove(taskListToShow, 1)
          local protocol = g_game.getProtocolGame()
          if protocol then protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
      end
      if #taskListToShow == 0 and npcTaskWidget then
          -- Do not close the window; just request a refresh so UI updates in-place
          local protocol = g_game.getProtocolGame()
          if protocol then protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
      end
  end
end


function declineNpcTask()
    lastOpcode = 0
    npcSelectedTask = 0
    if npcTaskWidget then npcTaskWidget:hide() end
    -- Stop auto-refresh when NPC window hidden
    if npcAutoRefreshEvent and removeEvent then removeEvent(npcAutoRefreshEvent) end
    npcAutoRefreshEvent = nil
    -- Stop cooldown ticker when window closes
    stopNpcCooldownTicker(); npcCooldownLeftByRow = {}
end

-- Unified row click (left rail)
function onNpcUnifiedRowClick(self)
  dbg('onNpcUnifiedRowClick id='.. tostring(self and self:getId()))
  if not npcTaskWidget or not self then dbg('rowClick abort: missing widget'); return end
  local id = tostring(self:getId() or '')
  local idx = tonumber(id:match("_(%d+)$")) or 0
  if idx <= 0 then dbg('rowClick abort: bad idx'); return end
  -- clear previous selection visuals from all three lists
  local function clearList(panelId)
    local pnl = npcTaskWidget:recursiveGetChildById(panelId)
    pnl = pnl and (pnl:recursiveGetChildById('npcTaskListPanel') or pnl)
    if not pnl then return end
    for _, child in ipairs(pnl:getChildren()) do
      local acc = child:getChildById('selectedAccent')
      if acc then acc:setVisible(false) end
      child:mergeStyle({ ['background'] = 'alpha', ['border-width'] = 0, ['border-color'] = 'alpha' })
    end
  end
  clearList('npcTaskListAvailable')
  clearList('npcTaskListInProgress')

  -- set new selection and decorate
  local acc = self:getChildById('selectedAccent')
  if acc then acc:setVisible(true) end
  self:mergeStyle({ ['background'] = '#ffffff14', ['border-width'] = 1, ['border-color'] = '#cccccc55' })

  if id:find('npcAvail_', 1, true) then
    npcUnifiedSelectedKind = 'available'
  elseif id:find('npcInProg_', 1, true) then
    npcUnifiedSelectedKind = 'active'
  elseif id:find('npcCompleted_', 1, true) then
    npcUnifiedSelectedKind = 'completed'
  elseif id:find('npcCooldown_', 1, true) then
    npcUnifiedSelectedKind = 'cooldown'
  end
  npcSelectedTask = idx

  -- Update right panel and button
  UpdateNpcTaskDescription()
  local ab = npcTaskWidget:getChildById('acceptButton')
  if ab then
    if npcUnifiedSelectedKind == 'completed' then
      ab:setText('Claim'); ab:setEnabled(true)
    elseif npcUnifiedSelectedKind == 'active' then
      ab:setText('In Progress'); ab:setEnabled(false)
    elseif npcUnifiedSelectedKind == 'cooldown' then
      ab:setText('On Cooldown'); ab:setEnabled(false)
    else
      ab:setText('Accept'); ab:setEnabled(true)
    end
    ab:show()
  end
end

function onTaskClick(widget)
  local taskName = widget:getChildById('taskName')
  local taskLevel = widget:getChildById('taskLevel')
  local taskNumber = tonumber(string.sub(widget:getId(), 5))
  selectedListIndex = taskNumber
  
  for i = #localRewardItemList, 1, -1 do
    localRewardItemList[i]:destroy()
    table.remove(localRewardItemList, i)
  end
  taskDescriptionWindow:show()
  deleteButton:show()
  updateTaskDescription(taskNumber)
  do
    local raw = tostring(localTaskList[taskNumber].taskNumber)
    currentSelectedTask = tonumber(raw) or tonumber(raw:match("(%d+)")) or 0
  end
  -- persist selected task by taskNumber
  if currentSelectedTask and currentSelectedTask > 0 then
    g_settings.set('game_tasklist/selected_task', tostring(currentSelectedTask))
  end
  -- update highlight styles and ensure visible
  for _, w in ipairs(localTaskWdgList) do
    local id = w:getId() or ''
    local idx = tonumber(string.sub(id, 5)) or -1
    if idx == selectedListIndex then
      w:mergeStyle({
        ['background'] = '#ffffff14',
        ['border-width'] = 1,
        ['border-color'] = '#cccccc55'
      })
      local acc = w:getChildById('selectedAccent')
      if acc then acc:setVisible(true) end
      if taskListPanel and taskListPanel.ensureChildVisible then
        taskListPanel:ensureChildVisible(w)
      end
    else
      w:mergeStyle({
        ['background'] = 'alpha',
        ['border-width'] = 0,
        ['border-color'] = 'alpha'
      })
      local acc = w:getChildById('selectedAccent')
      if acc then acc:setVisible(false) end
    end
  end
end

function updateTaskDescription(taskNumber)
  if taskNumber > #localTaskList then
    return
  end
  switchTaskTab('details')
  taskDescriptionWindow:recursiveGetChildById('taskTitle'):setText(tr(localTaskList[taskNumber].taskName))
  local tags = {}
  -- removed repeatable tag: taskRepeat deprecated
  if localTaskList[taskNumber].taskZone then table.insert(tags, tr(localTaskList[taskNumber].taskZone)) end
  if localTaskList[taskNumber].taskMinLvl then table.insert(tags, tr('Level %d', localTaskList[taskNumber].taskMinLvl)) end
  taskDescriptionWindow:recursiveGetChildById('taskTags'):setText(table.concat(tags, ' - '))
  taskDescriptionWindow:recursiveGetChildById('taskDescription'):setText(tr(localTaskList[taskNumber].taskDesc))
  taskDescriptionWindow:recursiveGetChildById('taskDescription'):setTextAutoResize(true)
  taskDescriptionWindow:recursiveGetChildById('taskZoneName'):setText(tr(localTaskList[taskNumber].taskZone))
  taskDescriptionWindow:recursiveGetChildById('taskZoneName'):setTextAutoResize(true)
  taskDescriptionWindow:recursiveGetChildById('taskSource'):setText(tr(localTaskList[taskNumber].taskSourceNpc))
  taskDescriptionWindow:recursiveGetChildById('taskSource'):setTextAutoResize(true)
  taskDescriptionWindow:recursiveGetChildById('taskHint'):setText(tr(localTaskList[taskNumber].taskHintNpc))
  taskDescriptionWindow:recursiveGetChildById('taskHint'):setTextAutoResize(true)
  taskDescriptionWindow:recursiveGetChildById('rewardExp'):setText(tr("EXP %d", localTaskList[taskNumber].taskRewards.exp or 0))
  local moneyLbl = taskDescriptionWindow:recursiveGetChildById('rewardMoney')
  local moneyIcon = taskDescriptionWindow:recursiveGetChildById('rewardMoneyIcon')
  if localTaskList[taskNumber].taskRewards.money and localTaskList[taskNumber].taskRewards.money > 0 then
    moneyLbl:setText(tr("GOLD %d", localTaskList[taskNumber].taskRewards.money))
    moneyLbl:setVisible(true)
    if moneyIcon then moneyIcon:setVisible(true) end
  else
    moneyLbl:setText("")
    moneyLbl:setVisible(false)
    if moneyIcon then moneyIcon:setVisible(false) end
  end
  -- Codex rewards (Quest Log pane)
  local codexLbl = taskDescriptionWindow:recursiveGetChildById('rewardCodex')
  if codexLbl then
    local codexParts = {}
    local ce = (localTaskList[taskNumber].taskRewards and localTaskList[taskNumber].taskRewards.codex_essences) or 0
    if ce > 0 then table.insert(codexParts, tr('%d Codex Essences', ce)) end
    local cc = (localTaskList[taskNumber].taskRewards and localTaskList[taskNumber].taskRewards.codex_crates) or {}
    for _, cr in ipairs(cc) do
      table.insert(codexParts, tr('%dx %s', cr.amount, tr(cr.name)))
    end
    if #codexParts > 0 then
      codexLbl:setText(table.concat(codexParts, '  +  '))
      codexLbl:setHeight(15)
      codexLbl:setVisible(true)
    else
      codexLbl:setText('')
      codexLbl:setHeight(0)
      codexLbl:setVisible(false)
    end
  end
  if localTaskList[taskNumber].taskRewards.outfits and #localTaskList[taskNumber].taskRewards.outfits > 0 then
    local outfit = localTaskList[taskNumber].taskRewards.outfits[1]
    local text = tr('Outfit: %s', tr(outfit.name))
    if outfit.addon and outfit.addon > 0 then
      text = tr('%s (Addon %d)', text, outfit.addon)
    end
    taskDescriptionWindow:recursiveGetChildById('rewardOutfit'):setText(text)
	 taskDescriptionWindow:recursiveGetChildById('rewardOutfit'):setHeight(15)
  else
    taskDescriptionWindow:recursiveGetChildById('rewardOutfit'):setText("")
    taskDescriptionWindow:recursiveGetChildById('rewardOutfit'):setHeight(0)
  end

  -- Render basic rewards (items) into basicRewards panel's inner scroll area
  local basicPanel = taskDescriptionWindow:recursiveGetChildById('basicRewards')
  local basicScroll = basicPanel and (basicPanel:getChildById('rewardItemsPanel') or basicPanel:recursiveGetChildById('rewardItemsPanel')) or nil
  local basicItems = basicScroll
  if basicItems and basicItems.destroyChildren then basicItems:destroyChildren() end
  if localTaskList[taskNumber].taskRewards.items and basicItems then
    local items = localTaskList[taskNumber].taskRewards.items
    if #items > 0 then
      for i = 1, #items do
        local rewardItem = g_ui.createWidget('TasklistRewardItem', basicItems)
        table.insert(localRewardItemList, rewardItem)
        local iid = items[i].itemCid or items[i].itemSid or 0
        rewardItem:getChildById('rewardItem'):setItemId(iid)
        rewardItem:getChildById('rewardItem'):setVirtual(true)
        rewardItem:getChildById('rewardItem'):setItemCount(items[i].itemCnt)
        rewardItem:getChildById('rewardItemCnt'):setText(tr('x %d', items[i].itemCnt))
        rewardItem:getChildById('rewardItemName'):setText(tr(items[i].name))
      end
      adjustRewardPanelHeight(basicPanel, #items, 4)
      if basicPanel.hide then basicPanel:show() end
    else
      if basicPanel.hide then basicPanel:hide() end
    end
  end

  -- Choice rewards rendering with styling and proper container
  local choicePanelContainer = taskDescriptionWindow:recursiveGetChildById('choiceRewards')
  -- resolve the scroll panel first, then its inner list container
  local choiceScroll = choicePanelContainer and (choicePanelContainer:getChildById('rewardItemsPanel') or choicePanelContainer:recursiveGetChildById('rewardItemsPanel')) or nil
  local choicePanel = choiceScroll
  local choiceTitle = taskDescriptionWindow:recursiveGetChildById('choiceRewardsTitle')
  if choicePanel then
    if choiceScroll and choiceScroll.show then choiceScroll:show() end
    if choicePanel.show then choicePanel:show() end
    if choicePanel.destroyChildren then choicePanel:destroyChildren() end
    local choices = (localTaskList[taskNumber].taskRewards and localTaskList[taskNumber].taskRewards.choice) or {}
    -- debug: report choice count for current task
    -- removed chat log to avoid server-bound spam
    if choices and #choices > 0 then
      if choiceTitle then
        choiceTitle:setVisible(true)
        pcall(function() choiceTitle:setText(tr('Choice Rewards: (%d)', #choices)) end)
      end
      if choicePanelContainer and choicePanelContainer.show then choicePanelContainer:show() end
      local tnum = tonumber(localTaskList[taskNumber].taskNumber) or 0
      local selectedIdx = selectedChoiceByTask[tnum] or 0
      -- rely on verticalBox layout in rewardItemsPanel to stack wrappers
      for i=1,#choices do
        -- Wrapper + inner row to mirror left list structure exactly
        local wrap = g_ui.createWidget('ChoiceRowWrapper', choicePanel)
        wrap:setId('choice'..i)
        local cw = g_ui.createWidget('ChoiceListItem', wrap)
        cw:setId('choiceInner') -- same id per row, scoped under wrapper
        -- size/width follow wrapper; ensure small top spacing
        pcall(function() wrap:setHeight(34) end)
        pcall(function() wrap:setMarginTop(2) end)

        local iid = choices[i].itemCid or choices[i].itemSid or 0
        cw:getChildById('rewardItem'):setItemId(iid)
        cw:getChildById('rewardItem'):setVirtual(true)
        cw:getChildById('rewardItem'):setItemCount(choices[i].itemCnt)
        cw:getChildById('rewardItemCnt'):setText(tr('x %d', choices[i].itemCnt))
        cw:getChildById('rewardItemName'):setText(tr(choices[i].name))

        local function applySelection()
          selectedChoiceByTask[tnum] = i
          pcall(function() g_settings.set('game_tasklist/choice/'.. tostring(tnum), tostring(i)) end)
          for _, sWrap in ipairs(choicePanel:getChildren()) do
            local inner = sWrap and sWrap:getChildById('choiceInner') or nil
            if inner then
              if sWrap == wrap then
                inner:mergeStyle({ background = '#2f3b4a', ['border-color'] = '#5aa0ff', ['border-width'] = 1 })
              else
                inner:mergeStyle({ background = '#00000033', ['border-color'] = '#333333', ['border-width'] = 1 })
              end
            end
          end
        end

        wrap.onClick = applySelection
        cw.onClick = applySelection

        if i == selectedIdx then
          cw:mergeStyle({ background = '#2f3b4a', ['border-color'] = '#5aa0ff', ['border-width'] = 1 })
        else
          cw:mergeStyle({ background = '#00000033', ['border-color'] = '#333333', ['border-width'] = 1 })
        end
      end
      adjustRewardPanelHeight(choicePanelContainer, #choices, 4)
      -- let layout engine position wrappers
      -- debug: verify rows created
      -- removed chat log to avoid server-bound spam
    else
      if choiceTitle then
        choiceTitle:setVisible(true)
        pcall(function() choiceTitle:setText(tr('Choice Rewards:')) end)
      end
      if choicePanelContainer and choicePanelContainer.hide then choicePanelContainer:hide() end
    end
  end

  -- Restore rewards expanded/collapsed state
  local persistedRewards = g_settings.get('game_tasklist/rewards_expanded')
  setRewardsExpanded(persistedRewards == nil or tostring(persistedRewards) == '1' or tostring(persistedRewards) == 'true')
  -- restore persisted choice selection if any
  pcall(function()
    local tnum = tonumber(localTaskList[taskNumber].taskNumber) or 0
    local persistedChoice = g_settings.get('game_tasklist/choice/'.. tostring(tnum))
    if persistedChoice then
      selectedChoiceByTask[tnum] = tonumber(persistedChoice) or 0
    end
  end)
  if localTaskList[taskNumber].taskGoals.monsters then
    if #localTaskList[taskNumber].taskGoals.monsters > 0 then
      taskDescriptionWindow:recursiveGetChildById('monsterGoals'):setVisible(true)
      local goalMsg = "You have to kill: "
      for i = 1, #localTaskList[taskNumber].taskGoals.monsters, 1 do
        goalMsg = goalMsg ..  localTaskList[taskNumber].taskGoals.monsters[i].name
        if i < #localTaskList[taskNumber].taskGoals.monsters then
          goalMsg = goalMsg .. ", "
        end
        if i == #localTaskList[taskNumber].taskGoals.monsters then
          goalMsg = goalMsg .. "."
        end
      end
      taskDescriptionWindow:recursiveGetChildById('monsterGoals'):setText(goalMsg)
	  taskDescriptionWindow:recursiveGetChildById('monsterGoals'):setTextAutoResize(true)
    else
      taskDescriptionWindow:recursiveGetChildById('monsterGoals'):setVisible(false)
    end
  else
    taskDescriptionWindow:recursiveGetChildById('monsterGoals'):setVisible(false)
  end
  
  
  local objDivider = taskDescriptionWindow:recursiveGetChildById('objectivesDivider')
  if objDivider then objDivider:setVisible(true) end
  if localTaskList[taskNumber].taskGoals.items then
    if #localTaskList[taskNumber].taskGoals.items > 0 then
      taskDescriptionWindow:recursiveGetChildById('itemGoals'):setVisible(true)
      local goalMsg = "You have to collect: "
      for i = 1, #localTaskList[taskNumber].taskGoals.items, 1 do
        goalMsg = goalMsg ..  localTaskList[taskNumber].taskGoals.items[i].name
        if i < #localTaskList[taskNumber].taskGoals.items then
          goalMsg = goalMsg .. ", "
        end
        if i == #localTaskList[taskNumber].taskGoals.items then
          goalMsg = goalMsg .. "."
        end
      end
      taskDescriptionWindow:recursiveGetChildById('itemGoals'):setText(goalMsg)
	  taskDescriptionWindow:recursiveGetChildById('itemGoals'):setTextAutoResize(true)
    else
      taskDescriptionWindow:recursiveGetChildById('itemGoals'):setVisible(false)
    end
  else
    taskDescriptionWindow:recursiveGetChildById('itemGoals'):setVisible(false)
  end
  
  
   if localTaskList[taskNumber].taskGoals.storages then
    if #localTaskList[taskNumber].taskGoals.storages > 0 then
      taskDescriptionWindow:recursiveGetChildById('storageGoals'):setVisible(true)
      local goalMsg = "You have to do: "
      for i = 1, #localTaskList[taskNumber].taskGoals.storages, 1 do
        goalMsg = goalMsg ..  localTaskList[taskNumber].taskGoals.storages[i].starageName
        if i < #localTaskList[taskNumber].taskGoals.storages then
          goalMsg = goalMsg .. ", "
        end
        if i == #localTaskList[taskNumber].taskGoals.storages then
          goalMsg = goalMsg .. "."
        end
      end
      taskDescriptionWindow:recursiveGetChildById('storageGoals'):setText(goalMsg)
	  taskDescriptionWindow:recursiveGetChildById('storageGoals'):setTextAutoResize(true)
    else
      taskDescriptionWindow:recursiveGetChildById('storageGoals'):setVisible(false)
    end
  else
    taskDescriptionWindow:recursiveGetChildById('storageGoals'):setVisible(false)
  end
  
  
  taskDescriptionWindow:recursiveGetChildById('itemCnt'):setVisible(true)
  local cntMsg = localTaskList[taskNumber].taskCurrentCnt .. "/" ..localTaskList[taskNumber].taskGoalCnt
  taskDescriptionWindow:recursiveGetChildById('itemCnt'):setText(cntMsg)
end

