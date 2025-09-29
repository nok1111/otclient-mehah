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

local lastOpcode = 0
local npcSelectedTask = 0
local currentSelectedTask = 0
local npcTaskDescription = nil
local npcTaskWidget = nil
local npcTaskList = {}
local npcRewardList = {}
local npcUnifiedActiveList = {}
local npcUnifiedSelectedKind = nil -- 'available' | 'active' | 'completed'
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
local function setAcceptState(label, enabled)
  if not npcTaskWidget then return end
  local ab = npcTaskWidget:recursiveGetChildById('acceptButton')
  if not ab then return end
  if label then pcall(function() ab:setText(label) end) end
  if enabled ~= nil then pcall(function() ab:setEnabled(enabled) end) end
end

local function dbg(msg)
  local s = '[QuestUI] ' .. tostring(msg)
  pcall(function() g_game.talk(s) end)
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
  -- Use parent inner width (account for 1px border each side) so the fill reaches the inner right edge
  local inner = math.max(0, (w or 0) - 2)
  local target
  if clamped >= 0.999 then
    target = inner -- exactly fill inner width at 100%
  else
    target = math.floor(inner * clamped)
  end
  pcall(function() pb:setWidth(target) end)
end

-- Build/refresh unified NPC window UI from parsed lists
function buildUnifiedNpcUI(parsed)
  -- Ensure expansion state exists even if this runs before the global is defined
  statusExpanded = statusExpanded or { available = true, inprogress = true, completed = true }
  if npcTaskWidget ~= nil then pcall(function() npcTaskWidget:destroy() end) end
  npcTaskWidget = g_ui.createWidget('NpcTaskListWidget', modules.game_interface.getRootPanel())
  npcTaskWidget:setText("World Quests")
  npcTaskWidget:show(); npcTaskWidget:raise(); npcTaskWidget:focus()
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
        if title then title:setText(string.format('%s (%d)', titleText, count)) end
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
        row:getChildById('taskButton'):setText(rec.taskName)
        local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 0)) end
        local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText('level '.. tostring(rec.taskMinLvl or 0)) end
        local badge = row:getChildById('taskBadge'); if badge then badge:setText(rec.taskRepeat and 'Repeat' or 'Story') end
        local p = row:getChildById('taskProgress') or row:getChildById('progressBg'); if p then p:setVisible(false) end
        row.onClick = modules.game_tasklist.onNpcUnifiedRowClick
      end

      -- In Progress section
      addHeader('inprogress', 'In Progress', #parsed.active)
      for i = 1, #parsed.active do
        local rec = parsed.active[i]
        local row = g_ui.createWidget('NpcTaskRecord', list)
        row:setId('npcInProg_'.. tostring(i))
        row:getChildById('taskButton'):setText(rec.taskName)
        local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 1)) end
        local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText('level '.. tostring(rec.taskMinLvl or 0)) end
        local badge = row:getChildById('taskBadge'); if badge then badge:setText(rec.taskRepeat and 'Repeat' or 'Story') end
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
        row:getChildById('taskButton'):setText(rec.taskName)
        local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 2)) end
        local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText('level '.. tostring(rec.taskMinLvl or 0)) end
        local badge = row:getChildById('taskBadge'); if badge then badge:setText(rec.taskRepeat and 'Repeat' or 'Story') end
        local p = row:getChildById('taskProgress'); if p then p:setVisible(false) end
        row.onClick = modules.game_tasklist.onNpcUnifiedRowClick
      end
    end
  end

  -- Expand sections that now contain items
  if (#(parsed.available or {}) > 0 and statusExpanded.available == false) then statusExpanded.available = true; pcall(function() g_settings.set('game_tasklist/npc/available_expanded', '1') end) end
  if (#(parsed.active or {}) > 0 and statusExpanded.inprogress == false) then statusExpanded.inprogress = true; pcall(function() g_settings.set('game_tasklist/npc/inprogress_expanded', '1') end) end
  if (#(parsed.completed or {}) > 0 and statusExpanded.completed == false) then statusExpanded.completed = true; pcall(function() g_settings.set('game_tasklist/npc/completed_expanded', '1') end) end
  local function safeApply(kind)
    local f = _G.applyStatusVisibility or applyStatusVisibility
    if type(f) == 'function' then pcall(function() f(kind) end) end
  end
  safeApply('available')
  safeApply('inprogress')
  safeApply('completed')
  -- Clear in-flight (server responded / UI rebuilt)
  actionInFlight = false
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
    pcall(function()
      askWidget:setText('Reward Selection Required')
      if askWidget.setSize then askWidget:setSize({width = 380, height = 110}) end
    end)
    -- try to set first label text
    pcall(function()
      local kids = askWidget:getChildren()
      for i=1,#kids do
        if kids[i].setText then
          kids[i]:setText('Please choose one of the reward options before claiming.')
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
    if yesBtn and yesBtn.setText then yesBtn:setText('OK') end
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

local function applyStatusVisibility(kind)
  if not npcTaskWidget then return end
  local listHost = npcTaskWidget:recursiveGetChildById('npcTaskListInProgress')
  listHost = listHost and (listHost:recursiveGetChildById('npcTaskListPanel') or listHost) or nil
  if not listHost then return end
  local vis = statusExpanded[kind] ~= false
  local headerId = (kind == 'available' and 'combinedAvailableHeader')
                 or (kind == 'inprogress' and 'combinedInProgHeader')
                 or (kind == 'completed' and 'combinedCompletedHeader')
  local prefix  = (kind == 'available' and 'npcAvail_')
                 or (kind == 'inprogress' and 'npcInProg_')
                 or (kind == 'completed' and 'npcCompleted_')
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
        -----------------------------------------------------------------------------------------------------------------------------------------------
        local goalSplit = {}
        local rewardSplit = {}
        local basicRewardSplit = {}
        local itemRewardSplit = {}
        local tailSplit = {}
        for split in string.gmatch(taskSplit[3], "(.-):") do
            table.insert(goalSplit, split)
        end
        for split in string.gmatch(taskSplit[10], "(.-)!") do
            table.insert(rewardSplit, split)
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
        rewardList = {exp = tonumber(basicRewardSplit[1]), money = rewardsMoney, items = rewardItems, outfits = rewardOutfits, choice = choiceItems}
        -----------------------------------------------------------------------------------------------------------------------------------------------
        table.insert(parseTaskList, {taskNumber = taskSplit[11], taskName = taskSplit[1], taskDesc = taskSplit[2], taskGoals = targetList,
                                     taskGoalCnt = tonumber(taskSplit[4]), taskMinLvl = tonumber(taskSplit[5]), taskMaxLvl = tonumber(taskSplit[6]),
                                     taskRepeat = toboolean(taskSplit[7]), taskState = tonumber(taskSplit[8]), taskCurrentCnt = tonumber(taskSplit[9]),
                                     taskRewards = rewardList, taskZone = taskSplit[12], taskSourceNpc = taskSplit[13], taskHintNpc = taskSplit[14]})
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
    print("levelFilterMode: 1")
    if tonumber(t.taskState) == 0  or tonumber(t.taskState) == 1 or tonumber(t.taskState) == 2 then return true end
  elseif levelFilterMode == 2 then
    print("levelFilterMode: 2")
    if tonumber(t.taskState) ~= 1 then return false end
  elseif levelFilterMode == 3 then
    print("levelFilterMode: 3")
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
      currentSelectedTask = tonumber(localTaskList[selectedListIndex].taskNumber) or 0
    end
    local widgetTitle = "Adventure Log ("
    widgetTitle = widgetTitle .. tostring(#localTaskList) .. "/" .. MaxTaskList .. ")"
    taskListsWindow:setText(widgetTitle)
    -- update cap pill
    local capPill = taskListsWindow:getChildById('capPill')
    if capPill then
      local used = 0
      for i=1,#localTaskList do
        if localTaskList[i].taskState and localTaskList[i].taskState > 0 and localTaskList[i].taskState < 3 then
          used = used + 1
        end
      end
      capPill:setText(string.format('Max %d / %d', used, MaxTaskList))
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
    header:getChildById('zoneTitle'):setText(string.format('%s (%d)', zone, #groups[zone]))
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
        taskName:setText(localTaskList[idx].taskName)
      end
      if taskLevel then
        local lvlTxt = 'level ' .. tostring(localTaskList[idx].taskMinLvl)
        taskLevel:setText(lvlTxt)
      end
      if taskState then
        taskState:setImageSource('/images/taskList/'..tostring(localTaskList[idx].taskState))
      end
      -- badge
      local badge = taskItem:getChildById('taskBadge')
      if badge then
        local txt = localTaskList[idx].taskRepeat and 'Repeat' or 'Story'
        badge:setText(txt)
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

-- Toggle rewards panel visibility
function setRewardsExpanded(expanded)
  if not taskDescriptionWindow then return end
  local ids = {
    'rewardExpIcon','rewardExp','rewardMoneyIcon','rewardMoney','rewardOutfit',
    'basicRewardsTitle','basicRewards','choiceRewardsTitle','choiceRewards'
  }
  for _, id in ipairs(ids) do
    local w = taskDescriptionWindow:recursiveGetChildById(id)
    if w then w:setVisible(expanded) end
  end
  local btn = taskListsWindow and taskListsWindow:recursiveGetChildById('rewardsToggle') or nil
  if btn then btn:setText(expanded and '-' or '+') end
  g_settings.set('game_tasklist/rewards_expanded', expanded and '1' or '0')
end

function toggleRewards()
  if not taskDescriptionWindow then return end
  local basic = taskDescriptionWindow:recursiveGetChildById('basicRewards')
  local expanded = true
  if basic then expanded = not basic:isVisible() end
  setRewardsExpanded(expanded)
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

    -- intentionally not mutating localTaskList directly; server pushes full refreshes
end

-- Parse unified NPC payload sent by server (header VER1; then three sections)
local function parseUnifiedNpcPayload(buffer)
  -- Header: VER1;availCount:X;activeCount:Y;completedCount:Z;
  local headerEnd = buffer:find(';', 1, true) -- after VER1
  if not headerEnd then return nil end
  local afterVer = buffer:sub(headerEnd + 1)
  local ac, act, cc = 0, 0, 0
  for key, val in afterVer:gmatch("(availCount):(%d+);") do ac = tonumber(val) or 0 end
  for key, val in afterVer:gmatch("(activeCount):(%d+);") do act = tonumber(val) or 0 end
  for key, val in afterVer:gmatch("(completedCount):(%d+);") do cc = tonumber(val) or 0 end
  -- find the start of sections (after the third value terminator ';')
  local startIdx = afterVer:find(';', 1, true)
  if startIdx then startIdx = afterVer:find(';', startIdx + 1, true) end
  if startIdx then startIdx = afterVer:find(';', startIdx + 1, true) end
  if not startIdx then return nil end
  local sections = {}
  local payload = afterVer:sub(startIdx + 1)
  for seg in payload:gmatch("(.-)%|%|") do
    sections[#sections+1] = seg
  end
  local function parseSection(seg)
    local list = {}
    for block in seg:gmatch("(.-)##") do
      if block and #block > 0 then
        local pseudo = "1|" .. block
        local one = parseIncomingTaskList(pseudo)
        if one and #one > 0 then table.insert(list, one[1]) end
      end
    end
    return list
  end
  local avail = parseSection(sections[1] or "")
  local active = parseSection(sections[2] or "")
  local completed = parseSection(sections[3] or "")
  return {available = avail, active = active, completed = completed, counts = {ac, act, cc}}
end

function onExtendedNpcTaskList(protocol, opcode, buffer)
  -- Unified format branch (single window with three sections)
  if buffer and buffer:sub(1,5) == 'VER1;' then
    dbg('Unified NPC payload received len=' .. tostring(#(buffer or '')))
    lastOpcode = opcode
    local parsed = parseUnifiedNpcPayload(buffer)
    if not parsed then dbg('parseUnifiedNpcPayload returned nil'); return end
    -- Deduplicate: if a task appears in Completed, ensure it is not in Active; and never in Available if present elsewhere
    local function dedupeLists(p)
      local seenCompleted = {}
      local seenActive = {}
      local function numOf(t)
        local raw = tostring(t.taskNumber or '')
        local n = tonumber(raw) or tonumber(raw:match('(%d+)')) or raw
        return n
      end
      -- build completed set
      local uniqCompleted, tmp = {}, {}
      for _, t in ipairs(p.completed or {}) do
        local k = numOf(t)
        if not seenCompleted[k] then
          table.insert(uniqCompleted, t)
          seenCompleted[k] = true
        end
      end
      p.completed = uniqCompleted
      -- filter active against completed and self-dup
      local uniqActive = {}
      for _, t in ipairs(p.active or {}) do
        local k = numOf(t)
        if not seenCompleted[k] and not seenActive[k] then
          table.insert(uniqActive, t)
          seenActive[k] = true
        end
      end
      p.active = uniqActive
      -- filter available against both
      local uniqAvail = {}
      for _, t in ipairs(p.available or {}) do
        local k = numOf(t)
        if not seenCompleted[k] and not seenActive[k] then
          -- also avoid duplicate within available
          if not tmp[k] then table.insert(uniqAvail, t); tmp[k] = true end
        end
      end
      p.available = uniqAvail
    end
    dedupeLists(parsed)
    dbg(string.format('Sections: avail=%d active=%d completed=%d', #(parsed.available or {}), #(parsed.active or {}), #(parsed.completed or {})))
    -- cache for optimistic updates
    lastUnified = { available = parsed.available, active = parsed.active, completed = parsed.completed }

    buildUnifiedNpcUI(parsed)
    
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
          header:setId(kind == 'available' and 'combinedAvailableHeader' or (kind == 'inprogress' and 'combinedInProgHeader' or 'combinedCompletedHeader'))
          local caret = header:getChildById('zoneCaret')
          local title = header:getChildById('zoneTitle')
          if title then title:setText(string.format('%s (%d)', titleText, count)) end
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
          row:getChildById('taskButton'):setText(rec.taskName)
          local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 0)) end
          local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText('level '.. tostring(rec.taskMinLvl or 0)) end
          local badge = row:getChildById('taskBadge'); if badge then badge:setText(rec.taskRepeat and 'Repeat' or 'Story') end
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
          row:getChildById('taskButton'):setText(rec.taskName)
          local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 1)) end
          local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText('level '.. tostring(rec.taskMinLvl or 0)) end
          local badge = row:getChildById('taskBadge'); if badge then badge:setText(rec.taskRepeat and 'Repeat' or 'Story') end
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
          row:getChildById('taskButton'):setText(rec.taskName)
          local st = row:getChildById('taskState'); if st then st:setImageSource('/images/taskList/'.. tostring(rec.taskState or 2)) end
          local lvl = row:getChildById('taskLevel'); if lvl then lvl:setText('level '.. tostring(rec.taskMinLvl or 0)) end
          local badge = row:getChildById('taskBadge'); if badge then badge:setText(rec.taskRepeat and 'Repeat' or 'Story') end
          local p = row:getChildById('taskProgress'); if p then p:setVisible(false) end
        end
      end
    end

    -- Default selection: if any available, prep Accept; else if completed, prep Claim
    local ab = npcTaskWidget:getChildById('acceptButton')
    if ab then
      if #parsed.available > 0 then ab:setText('Accept') else ab:setText('Claim') end
      ab:show(); ab:setEnabled(false)
      dbg('Accept button shown disabled')
    end

    -- Store lists in existing globals for reuse by existing handlers
    npcTaskList = parsed.available
    npcUnifiedActiveList = parsed.active
    npcRewardList = parsed.completed
    npcSelectedTask = 0
    dbg('Stored lists. avail='.. tostring(#npcTaskList) ..' active='.. tostring(#npcUnifiedActiveList) ..' completed='.. tostring(#npcRewardList))

    -- Restore persisted expansion states
    local ip = g_settings.get('game_tasklist/npc/inprogress_expanded')
    local cp = g_settings.get('game_tasklist/npc/completed_expanded')
    local av = g_settings.get('game_tasklist/npc/available_expanded')
    statusExpanded.available  = (av == nil) and true or (tostring(av) == '1' or tostring(av) == 'true')
    statusExpanded.inprogress = (ip == nil) and true or (tostring(ip) == '1' or tostring(ip) == 'true')
    statusExpanded.completed  = (cp == nil) and true or (tostring(cp) == '1' or tostring(cp) == 'true')
    -- If there are items, prefer expanding by default to avoid confusion, but only override if user hasn't explicitly expanded in this session
    if (#parsed.available or 0) > 0 and statusExpanded.available == false then
      statusExpanded.available = true
      pcall(function() g_settings.set('game_tasklist/npc/available_expanded', '1') end)
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

    -- If no tasks are available, hide the NPC Task Window
    if #npcTaskList == 0 then
        if npcTaskWidget then
            npcTaskWidget:destroy()
            npcTaskWidget = nil
        end
        return
    end

    if npcTaskWidget ~= nil then
        npcTaskWidget:destroy()
    end

    npcTaskWidget = g_ui.createWidget('NpcTaskListWidget', modules.game_interface.getRootPanel())
    local posWidget = {x = 600, y = 300}
    npcTaskWidget:setText("Main Story Quests")
    npcTaskWidget:getChildById("acceptButton"):setText("Accept")
    npcTaskWidget:setPosition(posWidget)
    npcTaskWidget:show()
    npcTaskWidget:raise()
    npcTaskWidget:focus()

    local npcTaskListPanel = npcTaskWidget:getChildById("npcTaskList"):recursiveGetChildById('npcTaskListPanel')
    local npcTaskDescPanel = npcTaskWidget:getChildById('npcTaskDescription'):recursiveGetChildById('npcTaskListPanel')
    npcTaskDescription = g_ui.createWidget('NpcTaskDescription', npcTaskDescPanel)
    for i = 1, #npcTaskList, 1 do
      local taskButton = g_ui.createWidget('NpcTaskWidget', npcTaskListPanel)
      taskButton:setId("npcTaskButton"..tostring(i))
       taskButton:getChildById('taskButton'):setText(npcTaskList[i].taskName)
    end
    if #npcTaskList == 0 then
      npcTaskWidget:getChildById("acceptButton"):hide()
    else
      local ab = npcTaskWidget:getChildById("acceptButton")
      ab:show()
      ab:setEnabled(true)
      -- default select first task so Accept works without clicking
      npcSelectedTask = 1
    end
    UpdateNpcTaskDescription()
end

function onExtendedNpcRewardList(protocol, opcode, buffer)
    lastOpcode = opcode
    npcRewardList = {}
    npcRewardList = parseIncomingTaskList(buffer)

    if npcTaskWidget ~= nil then
        npcTaskWidget:destroy()
    end

    npcTaskWidget = g_ui.createWidget('NpcTaskListWidget', modules.game_interface.getRootPanel())
    local posWidget = {x = 600, y = 300}
    npcTaskWidget:setText("NPC claim reward")
    npcTaskWidget:getChildById("acceptButton"):setText("Claim")
    npcTaskWidget:setPosition(posWidget)
    npcTaskWidget:show()
    npcTaskWidget:raise()
    npcTaskWidget:focus()

    local npcTaskListPanel = npcTaskWidget:getChildById("npcTaskList"):recursiveGetChildById('npcTaskListPanel')
    local npcTaskDescPanel = npcTaskWidget:getChildById('npcTaskDescription'):recursiveGetChildById('npcTaskListPanel')
    npcTaskDescription = g_ui.createWidget('NpcTaskDescription', npcTaskDescPanel)
    for i = 1, #npcRewardList, 1 do
      local taskButton = g_ui.createWidget('NpcTaskWidget', npcTaskListPanel)
      taskButton:setId("npcRewardButton"..tostring(i))
      taskButton:getChildById('taskButton'):setText(npcRewardList[i].taskName)
    end
    if #npcRewardList == 0 then
      npcTaskWidget:getChildById("acceptButton"):hide()
    else
     local ab = npcTaskWidget:getChildById("acceptButton")
     ab:show()
     ab:setEnabled(true)
      -- default select first reward so Claim works without clicking
      npcSelectedTask = 1
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
      opsRegistered = true
    end

    taskListsWindow = g_ui.displayUI('game_tasklist', modules.game_interface.getRightPanel())
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
        statusFilter:addOption('All')
        statusFilter:addOption('Active')
        statusFilter:addOption('Completed')
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
    opsRegistered = false
    if taskListsWindow then
      taskListsWindow:destroy()
      taskListsWindow = nil
      taskDescriptionWindow = nil
      taskListPanel = nil
      deleteButton = nil
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
    if protocol and ((tonumber(currentSelectedTask) or 0) > 0) then
      protocol:sendExtendedOpcode(ClientOpcodes.ClientDeleteTask, tostring(currentSelectedTask))
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
    taskDescriptionWindow:hide()
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
    g_game.talk("[Quest] Selected index " .. tostring(npcSelectedTask) .. " (opcode=".. tostring(lastOpcode) .. ")")
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
            g_game.talk("[Quest] Claiming reward for task " .. tostring(taskId))
            actionInFlight = true; setAcceptState(PROCESSING_LABEL, false)
        elseif lastOpcode == ExtendedIds.NpcTaskList then
            protocol:sendExtendedOpcode(ClientOpcodes.ClientSelectTask, tostring(taskId))
            g_game.talk("[Quest] Accepting task " .. tostring(taskId))
            -- proactively refresh unified NPC window so the task moves to In Progress without closing
            pcall(function()
              -- fire refresh pings according to schedule
              for _, delay in ipairs(REFRESH_PINGS_MS) do
                if delay == 0 then
                  protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "")
                elseif scheduleEvent then
                  scheduleEvent(function()
                    local p = g_game.getProtocolGame(); if p then p:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
                  end, delay)
                end
              end
              -- safety: clear lock after timeout if server never answers
              if scheduleEvent then
                scheduleEvent(function() actionInFlight = false; setAcceptState('Accept', true) end, ACCEPT_LOCK_TIMEOUT_MS)
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
            g_game.talk("[Quest] Claiming reward for task " .. tostring(taskId))
            actionInFlight = true; setAcceptState('Processing...', false)
        end
    end
end

-- server requested to close NPC task window (e.g., max tasks reached or flow end)
function onExtendedNpcTaskWindowClose(protocol, opcode, buffer)
  if npcTaskWidget then
    npcTaskWidget:destroy()
    npcTaskWidget = nil
  end
  -- refresh accepted quest list
  local proto = g_game.getProtocolGame()
  if proto then
    proto:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "")
  end
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
  end

  if type(list) ~= 'table' or #list == 0 then dbg('UpdateNpcTaskDescription abort: list invalid/empty'); return end
  if not npcSelectedTask or npcSelectedTask < 1 or npcSelectedTask > #list then npcSelectedTask = 1 end

  local rec = list[npcSelectedTask]
  if not rec then dbg('UpdateNpcTaskDescription abort: rec nil'); return end

  if npcTaskDescription.show then npcTaskDescription:show() end
  local title = npcTaskDescription:getChildById('taskTitle')
  local desc = npcTaskDescription:getChildById('taskDescription')
  if title then title:setText(rec.taskName) end
  if desc then desc:setText(rec.taskDesc); desc:setTextAutoResize(true) end

  -- Rewards basic (match main TaskDescription style)
  local expLbl = npcTaskDescription:getChildById('rewardExp')
  if expLbl then expLbl:setText('EXP  ' .. tostring(rec.taskRewards.exp or 0)) end
  local moneyLbl = npcTaskDescription:getChildById('rewardMoney')
  local moneyIcon = npcTaskDescription:getChildById('rewardMoneyIcon')
  local money = (rec.taskRewards and rec.taskRewards.money) or 0
  if money > 0 then
    if moneyLbl then moneyLbl:setText('GOLD  ' .. tostring(money)); moneyLbl:setVisible(true) end
    if moneyIcon then moneyIcon:setVisible(true) end
  else
    if moneyLbl then moneyLbl:setText(''); moneyLbl:setVisible(false) end
    if moneyIcon then moneyIcon:setVisible(false) end
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
        monLbl:setText('You have to kill: ' .. table.concat(names, ', ') .. '.')
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
        itemLbl:setText('You have to collect: ' .. table.concat(names, ', ') .. '.')
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
        storLbl:setText('You have to do: ' .. table.concat(names, ', ') .. '.')
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
      hintLbl:setText(hv)
      hintLbl:setVisible(hv ~= '')
    end
    local zoneLbl = npcTaskDescription:recursiveGetChildById('taskZoneName')
    if zoneLbl then
      local zv = tostring(rec.taskZoneName or rec.taskZone or '')
      zoneLbl:setText(zv)
      zoneLbl:setVisible(zv ~= '')
    end
    local srcLbl = npcTaskDescription:recursiveGetChildById('taskSource')
    if srcLbl then
      local sv = tostring(rec.taskSource or rec.taskSourceNpc or '')
      srcLbl:setText(sv)
      srcLbl:setVisible(sv ~= '')
    end
  end

  -- Outfit
  local npcOutfitLbl = npcTaskDescription:getChildById('rewardOutfit')
  if npcOutfitLbl then
    local outfits = (rec.taskRewards and rec.taskRewards.outfits) or {}
    if outfits and #outfits > 0 then
      local outfit = outfits[1]
      local text = 'Outfit: ' .. tostring(outfit.name)
      if outfit.addon and outfit.addon > 0 then text = text .. ' (Addon ' .. tostring(outfit.addon) .. ')' end
      npcOutfitLbl:setText(text)
      npcOutfitLbl:setVisible(true)
    else
      npcOutfitLbl:setText('')
      npcOutfitLbl:setVisible(false)
    end
  end

  -- Items
  npcRewardItemPanel = npcTaskDescription:recursiveGetChildById('rewardItemsPanel')
  -- Clear old refs from previous NPC renders to avoid stale references warnings
  for i = #localRewardItemList, 1, -1 do
    localRewardItemList[i] = nil
  end
  if npcRewardItemPanel and npcRewardItemPanel.destroyChildren then npcRewardItemPanel:destroyChildren() end
  local npcRewardTarget = npcRewardItemPanel and (npcRewardItemPanel:getChildById('rewardItemsBox') or npcRewardItemPanel:recursiveGetChildById('rewardItemsBox') or npcRewardItemPanel) or nil
  local items = (rec.taskRewards and rec.taskRewards.items) or {}
  if items and #items > 0 then
    if npcRewardItemPanel and npcRewardItemPanel.show then npcRewardItemPanel:show() end
    for i = 1, #items do
      local it = items[i]
      local rewardItem = g_ui.createWidget('RewardItem', npcRewardTarget)
      -- Do not persist NPC reward item widgets in localRewardItemList to prevent holding references after destroy
      rewardItem:getChildById('rewardItem'):setItemId(it.itemCid)
      rewardItem:getChildById('rewardItem'):setVirtual(true)
      rewardItem:getChildById('rewardItem'):setItemCount(it.itemCnt)
      rewardItem:getChildById('rewardItemCnt'):setText('x ' .. tostring(it.itemCnt))
      rewardItem:getChildById('rewardItemName'):setText(it.name)
    end
  else
    if npcRewardItemPanel and npcRewardItemPanel.hide then npcRewardItemPanel:hide() end
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
        cw:getChildById('rewardItemCnt'):setText('x '.. tostring(choices[i].itemCnt))
        cw:getChildById('rewardItemName'):setText(choices[i].name)
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
                  npcUnifiedSelectedKind = 'completed'
                  npcSelectedTask = math.max(1, #lastUnified.completed)
                else
                  r.taskState = 1 -- in progress
                  table.insert(lastUnified.active, r)
                  npcUnifiedSelectedKind = 'active'
                  npcSelectedTask = math.max(1, #lastUnified.active)
                end
                moved = true
                break
              end
            end
          end
          if moved then
            buildUnifiedNpcUI({ available = lastUnified.available, active = lastUnified.active, completed = lastUnified.completed })
            -- auto-focus moved row in its new section
            pcall(function()
              local host = npcTaskWidget:recursiveGetChildById('npcTaskListInProgress')
              local listW = host and (host:recursiveGetChildById('npcTaskListPanel') or host)
              local rowId = (npcUnifiedSelectedKind == 'active') and ('npcInProg_'.. tostring(npcSelectedTask)) or ('npcCompleted_'.. tostring(npcSelectedTask))
              local row = listW and listW:getChildById(rowId) or nil
              if row and modules.game_tasklist and modules.game_tasklist.onNpcUnifiedRowClick then
                modules.game_tasklist.onNpcUnifiedRowClick(row)
              else
                UpdateNpcTaskDescription()
              end
            end)
          end
        end
        -- Only send select-task to server when not in Completed context.
        -- If moved to Completed (or currently viewing Completed), require explicit user Claim.
        if npcUnifiedSelectedKind ~= 'completed' then
          sendSelectTask(tnum)
        else
          dbg('Skipped auto-select for completed task; waiting for explicit Claim')
        end
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
          g_game.talk("[Quest] Parsed taskNumber raw='" .. rawTaskNumber .. "' -> num=" .. tostring(tnum))
          if tnum and tnum > 0 then
            sendSelectTask(tnum)
          else
            g_game.talk("[Quest] ERROR: could not parse a valid taskNumber from '" .. rawTaskNumber .. "'")
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
          npcTaskWidget:destroy(); npcTaskWidget = nil
          local protocol = g_game.getProtocolGame()
          if protocol then protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "") end
      end
  end
end


function declineNpcTask()
    lastOpcode = 0
    npcSelectedTask = 0
    npcTaskWidget:hide()
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
  currentSelectedTask = tonumber(localTaskList[taskNumber].taskNumber)
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
  taskDescriptionWindow:getChildById('taskTitle'):setText(localTaskList[taskNumber].taskName)
  local tags = {}
  if localTaskList[taskNumber].taskRepeat then table.insert(tags, 'Repeatable') end
  if localTaskList[taskNumber].taskZone then table.insert(tags, localTaskList[taskNumber].taskZone) end
  if localTaskList[taskNumber].taskMinLvl then table.insert(tags, 'level '.. tostring(localTaskList[taskNumber].taskMinLvl)) end
  taskDescriptionWindow:getChildById('taskTags'):setText(table.concat(tags, ' • '))
  taskDescriptionWindow:getChildById('taskDescription'):setText(localTaskList[taskNumber].taskDesc)
  taskDescriptionWindow:getChildById('taskDescription'):setTextAutoResize(true)
  taskDescriptionWindow:getChildById('taskZoneName'):setText(localTaskList[taskNumber].taskZone)
  taskDescriptionWindow:getChildById('taskZoneName'):setTextAutoResize(true)
  taskDescriptionWindow:getChildById('taskSource'):setText(localTaskList[taskNumber].taskSourceNpc)
  taskDescriptionWindow:getChildById('taskSource'):setTextAutoResize(true)
  taskDescriptionWindow:getChildById('taskHint'):setText(localTaskList[taskNumber].taskHintNpc)
  taskDescriptionWindow:getChildById('taskHint'):setTextAutoResize(true)
  taskDescriptionWindow:getChildById('rewardExp'):setText("EXP  "..(localTaskList[taskNumber].taskRewards.exp or 0))
  local moneyLbl = taskDescriptionWindow:getChildById('rewardMoney')
  local moneyIcon = taskDescriptionWindow:getChildById('rewardMoneyIcon')
  if localTaskList[taskNumber].taskRewards.money and localTaskList[taskNumber].taskRewards.money > 0 then
    moneyLbl:setText("GOLD  " .. localTaskList[taskNumber].taskRewards.money)
    moneyLbl:setVisible(true)
    if moneyIcon then moneyIcon:setVisible(true) end
  else
    moneyLbl:setText("")
    moneyLbl:setVisible(false)
    if moneyIcon then moneyIcon:setVisible(false) end
  end
  if localTaskList[taskNumber].taskRewards.outfits and #localTaskList[taskNumber].taskRewards.outfits > 0 then
    local outfit = localTaskList[taskNumber].taskRewards.outfits[1]
    local text = "Outfit: " .. outfit.name
    if outfit.addon and outfit.addon > 0 then
      text = text .. " (Addon " .. tostring(outfit.addon) .. ")"
    end
    taskDescriptionWindow:getChildById('rewardOutfit'):setText(text)
	 taskDescriptionWindow:getChildById('rewardOutfit'):setHeight(15)
  else
    taskDescriptionWindow:getChildById('rewardOutfit'):setText("")
    taskDescriptionWindow:getChildById('rewardOutfit'):setHeight(0)
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
        local rewardItem = g_ui.createWidget('RewardItem', basicItems)
        table.insert(localRewardItemList, rewardItem)
        local iid = items[i].itemCid or items[i].itemSid or 0
        rewardItem:getChildById('rewardItem'):setItemId(iid)
        rewardItem:getChildById('rewardItem'):setVirtual(true)
        rewardItem:getChildById('rewardItem'):setItemCount(items[i].itemCnt)
        rewardItem:getChildById('rewardItemCnt'):setText('x ' .. tostring(items[i].itemCnt))
        rewardItem:getChildById('rewardItemName'):setText(items[i].name)
      end
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
    pcall(function()
      g_game.talk(string.format('[QuestUI] Task #%s choice count = %d', tostring(localTaskList[taskNumber].taskNumber), tonumber(#choices or 0)))
    end)
    if choices and #choices > 0 then
      if choiceTitle then
        choiceTitle:setVisible(true)
        pcall(function() choiceTitle:setText(tr('Choice Rewards:') .. ' ('.. tostring(#choices) ..')') end)
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
        cw:getChildById('rewardItemCnt'):setText('x '..tostring(choices[i].itemCnt))
        cw:getChildById('rewardItemName'):setText(choices[i].name)

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
      -- let layout engine position wrappers
      -- debug: verify rows created
      pcall(function()
        g_game.talk(string.format('[QuestUI] Choice rows created = %d', tonumber(choicePanel:getChildCount() or 0)))
      end)
    else
      if choiceTitle then
        choiceTitle:setVisible(true)
        pcall(function() choiceTitle:setText(tr('Choice Rewards: (0)')) end)
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
      taskDescriptionWindow:getChildById('monsterGoals'):setVisible(true)
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
      taskDescriptionWindow:getChildById('monsterGoals'):setText(goalMsg)
	  taskDescriptionWindow:getChildById('monsterGoals'):setTextAutoResize(true)
    else
      taskDescriptionWindow:getChildById('monsterGoals'):setVisible(false)
    end
  else
    taskDescriptionWindow:getChildById('monsterGoals'):setVisible(false)
  end
  
  
  local objDivider = taskDescriptionWindow:getChildById('objectivesDivider')
  if objDivider then objDivider:setVisible(true) end
  if localTaskList[taskNumber].taskGoals.items then
    if #localTaskList[taskNumber].taskGoals.items > 0 then
      taskDescriptionWindow:getChildById('itemGoals'):setVisible(true)
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
      taskDescriptionWindow:getChildById('itemGoals'):setText(goalMsg)
	  taskDescriptionWindow:getChildById('itemGoals'):setTextAutoResize(true)
    else
      taskDescriptionWindow:getChildById('itemGoals'):setVisible(false)
    end
  else
    taskDescriptionWindow:getChildById('itemGoals'):setVisible(false)
  end
  
  
   if localTaskList[taskNumber].taskGoals.storages then
    if #localTaskList[taskNumber].taskGoals.storages > 0 then
      taskDescriptionWindow:getChildById('storageGoals'):setVisible(true)
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
      taskDescriptionWindow:getChildById('storageGoals'):setText(goalMsg)
	  taskDescriptionWindow:getChildById('storageGoals'):setTextAutoResize(true)
    else
      taskDescriptionWindow:getChildById('storageGoals'):setVisible(false)
    end
  else
    taskDescriptionWindow:getChildById('storageGoals'):setVisible(false)
  end
  
  
  taskDescriptionWindow:getChildById('itemCnt'):setVisible(true)
  local cntMsg = localTaskList[taskNumber].taskCurrentCnt .. "/" ..localTaskList[taskNumber].taskGoalCnt
  taskDescriptionWindow:getChildById('itemCnt'):setText(cntMsg)
end

