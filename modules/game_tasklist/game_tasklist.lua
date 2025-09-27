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
local deleteButton = nil
local MaxTaskList = 15
local zoneSections = {} -- zoneName -> { header=widget, content=widget, expanded=bool }
local selectedListIndex = nil -- index within localTaskList for highlight
local searchQuery = ''
local levelFilterMode = 0 -- 0: All, 1: <= My Level, 2: +/- 5 Levels
local opsRegistered = false -- avoid double registration on hot reloads

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
        local outfitRewardSplit = {}
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
        for split in string.gmatch(rewardSplit[3], "(.-):") do
            table.insert(outfitRewardSplit, split)
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
        for j = 1, rewardsOutfitCnt do
            local base = 3*(j-1)
            local name = outfitRewardSplit[base + 1]
            local lookType = tonumber(outfitRewardSplit[base + 2])
            local addon = tonumber(outfitRewardSplit[base + 3]) or 0
            table.insert(rewardOutfits, {name = name, lookType = lookType, addon = addon})
        end
        -- parse choice rewards (items only for now)
        local choiceRewardSplit = {}
        for split in string.gmatch(rewardSplit[4] or '', "(.-):") do
            table.insert(choiceRewardSplit, split)
        end
        local choiceItems = {}
        for j = 1, rewardsChoiceCnt do
            local base = 4*(j-1)
            local name = choiceRewardSplit[base + 1]
            local cid = tonumber(choiceRewardSplit[base + 2])
            local sid = tonumber(choiceRewardSplit[base + 3])
            local cnt = tonumber(choiceRewardSplit[base + 4])
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

function onLevelFilterChange(widget)
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
  -- level filters
  local myLvl = 0
  local lp = g_game.getLocalPlayer and g_game.getLocalPlayer()
  if lp and lp.getLevel then myLvl = lp:getLevel() or 0 end
  if levelFilterMode == 1 then
    if t.taskMinLvl and t.taskMinLvl > myLvl then return false end
  elseif levelFilterMode == 2 then
    if t.taskMinLvl and math.abs((tonumber(t.taskMinLvl) or 0) - myLvl) > 5 then return false end
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
    header:getChildById('zoneCaret'):setText('▼')

    local content = g_ui.createWidget('ZoneContent', taskListPanel)
    content:setId('zoneContent_'..zone)
    -- restore persisted collapse state
    local key = 'game_tasklist/zone_expanded/'..zone
    local persisted = g_settings.get(key)
    local expanded = (persisted == nil) and true or (tostring(persisted) == '1' or tostring(persisted) == 'true')
    content:setVisible(expanded)
    header:getChildById('zoneCaret'):setText(expanded and '▼' or '►')

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
        local lvlTxt = 'Lvl ' .. tostring(localTaskList[idx].taskMinLvl)
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
      -- progress bar fill
      local goal = tonumber(localTaskList[idx].taskGoalCnt) or 0
      local curr = tonumber(localTaskList[idx].taskCurrentCnt) or 0
      local progressBg = taskItem:getChildById('progressBg')
      local progressFill = progressBg and progressBg:getChildById('progressFill') or nil
      if progressBg and progressFill and goal and goal > 0 then
        local ratio = math.max(0, math.min(1, curr / goal))
        -- delay width calc to next frame so layout sizes are valid
        addEvent(function()
          if progressBg and not progressBg:isDestroyed() and progressFill and not progressFill:isDestroyed() then
            local w = progressBg:getWidth() - 2
            if w < 0 then w = 0 end
            progressFill:setWidth(math.floor(w * ratio))
            progressBg:setVisible(true)
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
  for i=1,#children do
    if children[i] == widget then idx = i break end
  end
  if idx == 0 then return end
  local content = children[idx+1]
  if not content then return end
  local caret = widget:getChildById('zoneCaret')
  local isVisible = content:isVisible()
  content:setVisible(not isVisible)
  if caret then
    caret:setText(isVisible and '►' or '▼')
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
      if caret then caret:setText('▼') end
      g_settings.set('game_tasklist/zone_expanded/'..zone, '1')
    end
  end
end

function collapseAllZones()
  for zone, sect in pairs(zoneSections) do
    if sect and sect.content and sect.content:isVisible() then
      sect.content:setVisible(false)
      local caret = sect.header and sect.header:getChildById('zoneCaret')
      if caret then caret:setText('►') end
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

function onExtendedNpcTaskList(protocol, opcode, buffer)
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

    -- populate level filter options (skin does not support OTUI-defined options)
    local levelFilter = taskListsWindow:getChildById('levelFilter')
    if levelFilter then
      if levelFilter.clearOptions then pcall(function() levelFilter:clearOptions() end) end
      if levelFilter.addOption then
        levelFilter:addOption('All')
        levelFilter:addOption('<= My Level')
        levelFilter:addOption('+/- 5 Levels')
      end
      if levelFilter.setCurrentIndex then levelFilter:setCurrentIndex(0) end
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
    taskRewardItemPanel = taskDescriptionWindow and taskDescriptionWindow:recursiveGetChildById('rewardItemsPanel') or nil
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
        if lastOpcode == ExtendedIds.NpcTaskList then
            protocol:sendExtendedOpcode(ClientOpcodes.ClientSelectTask, tostring(taskId))
            g_game.talk("[Quest] Accepting task " .. tostring(taskId))
        elseif lastOpcode == ExtendedIds.NpcRewardList then
            -- append selected choice index if any, format: taskId:choiceIdx
            local choiceIdx = selectedChoiceByTask and selectedChoiceByTask[tonumber(taskId)] or 0
            local payload = tostring(taskId)
            if choiceIdx and choiceIdx > 0 then
                payload = payload .. ":" .. tostring(choiceIdx)
            end
            protocol:sendExtendedOpcode(ClientOpcodes.ClientSelectReward, payload)
            g_game.talk("[Quest] Claiming reward for task " .. tostring(taskId))
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
    if npcSelectedTask == 0 then
        npcTaskDescription:hide()
    else
        npcTaskDescription:show()
        local taskListToShow = nil
        if lastOpcode == ExtendedIds.NpcTaskList then
            taskListToShow = npcTaskList
        elseif lastOpcode == ExtendedIds.NpcRewardList then
            taskListToShow = npcRewardList
        end
        npcTaskDescription:getChildById('taskTitle'):setText(taskListToShow[npcSelectedTask].taskName)
        npcTaskDescription:getChildById('taskDescription'):setText(taskListToShow[npcSelectedTask].taskDesc)
        npcTaskDescription:getChildById('taskDescription'):setTextAutoResize(true)
        npcTaskDescription:getChildById('rewardExp'):setText("Exp +" .. taskListToShow[npcSelectedTask].taskRewards.exp)
        local moneyLbl = npcTaskDescription:getChildById('rewardMoney')
        local moneyIcon = npcTaskDescription:getChildById('rewardMoneyIcon')
        if taskListToShow[npcSelectedTask].taskRewards.money and taskListToShow[npcSelectedTask].taskRewards.money > 0 then
            moneyLbl:setText("Money +" .. taskListToShow[npcSelectedTask].taskRewards.money .. " gold coins")
            moneyLbl:setVisible(true)
            if moneyIcon then moneyIcon:setVisible(true) end
        else
            moneyLbl:setText("")
            moneyLbl:setVisible(false)
            if moneyIcon then moneyIcon:setVisible(false) end
        end
        -- Outfit and addon for NPC view
        local npcOutfitLbl = npcTaskDescription:getChildById('rewardOutfit')
        if taskListToShow[npcSelectedTask].taskRewards.outfits and #taskListToShow[npcSelectedTask].taskRewards.outfits > 0 then
          local outfit = taskListToShow[npcSelectedTask].taskRewards.outfits[1]
          local text = "Outfit: " .. outfit.name
          if outfit.addon and outfit.addon > 0 then
            text = text .. " (Addon " .. tostring(outfit.addon) .. ")"
          end
          npcOutfitLbl:setText(text)
          npcOutfitLbl:setVisible(true)
        else
          npcOutfitLbl:setText("")
          npcOutfitLbl:setVisible(false)
        end

        -- Check if there are reward items
        if taskListToShow[npcSelectedTask].taskRewards.items and #taskListToShow[npcSelectedTask].taskRewards.items > 0 then
            -- Create reward items
			
			npcRewardItemPanel = npcTaskDescription:recursiveGetChildById('rewardItemsPanel')
			npcRewardItemPanel:destroyChildren()
            npcRewardItemPanel:show()
			
            for i = 1, #taskListToShow[npcSelectedTask].taskRewards.items do
                local rewardItem = g_ui.createWidget('RewardItem', npcRewardItemPanel)
                table.insert(localRewardItemList, rewardItem)
                rewardItem:getChildById('rewardItem'):setItemId(taskListToShow[npcSelectedTask].taskRewards.items[i].itemCid)
                rewardItem:getChildById('rewardItem'):setVirtual(true)
                rewardItem:getChildById('rewardItem'):setItemCount(taskListToShow[npcSelectedTask].taskRewards.items[i].itemCnt)
                rewardItem:getChildById('rewardItemCnt'):setText("x " .. tostring(taskListToShow[npcSelectedTask].taskRewards.items[i].itemCnt))
                rewardItem:getChildById('rewardItemName'):setText(taskListToShow[npcSelectedTask].taskRewards.items[i].name)
            end
        else
            npcRewardItemPanel:hide()
        end
    end
end



function acceptNpcTask()
    g_game.talk("[Quest] acceptNpcTask() pressed; opcode=" .. tostring(lastOpcode))
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
            local tnum = tonumber(rawTaskNumber) or tonumber(rawTaskNumber:match("(%%d+)"))
            g_game.talk("[Quest] Parsed taskNumber raw='" .. rawTaskNumber .. "' -> num=" .. tostring(tnum))
            if tnum and tnum > 0 then
              sendSelectTask(tnum)
            else
              g_game.talk("[Quest] ERROR: could not parse a valid taskNumber from '" .. rawTaskNumber .. "'")
              return
            end
            table.remove(taskListToShow, npcSelectedTask)
            -- request refresh of main accepted quests immediately after selection
            local protocol = g_game.getProtocolGame()
            if protocol then
              protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "")
            end
        end
        
        if npcTaskWidget then
            local npcTaskListPanel = npcTaskWidget:getChildById("npcTaskList"):recursiveGetChildById('npcTaskListPanel')
            local button = npcTaskListPanel:recursiveGetChildById(buttonIdStr..tostring(npcSelectedTask))
            if button then
                npcTaskListPanel:removeChild(button)
            end
        end
        
        if #taskListToShow == 1 then
            sendSelectTask(taskListToShow[1].taskNumber)
            table.remove(taskListToShow, 1)
            -- refresh again to reflect second auto-selection
            local protocol = g_game.getProtocolGame()
            if protocol then
              protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "")
            end
        end
        
        if #taskListToShow == 0 and npcTaskWidget then
            npcTaskWidget:destroy()
            npcTaskWidget = nil
            -- After accepting/claiming, ask server for current accepted task list to update main window
            local protocol = g_game.getProtocolGame()
            if protocol then
              protocol:sendExtendedOpcode(ClientOpcodes.ClientGetTaskList, "")
            end
        end
    end
end


function declineNpcTask()
    lastOpcode = 0
    npcSelectedTask = 0
    npcTaskWidget:hide()
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
  if localTaskList[taskNumber].taskMinLvl then table.insert(tags, 'Lvl '.. tostring(localTaskList[taskNumber].taskMinLvl)) end
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
   if localTaskList[taskNumber].taskRewards.items then
    if #localTaskList[taskNumber].taskRewards.items > 0 then
      taskRewardItemPanel:show()
      for i = 1, #localTaskList[taskNumber].taskRewards.items do
        local rewardItem = g_ui.createWidget('RewardItem', taskRewardItemPanel)
        table.insert(localRewardItemList, rewardItem)
        rewardItem:getChildById('rewardItem'):setItemId(localTaskList[taskNumber].taskRewards.items[i].itemCid)
        rewardItem:getChildById('rewardItem'):setVirtual(true)
        rewardItem:getChildById('rewardItem'):setItemCount(localTaskList[taskNumber].taskRewards.items[i].itemCnt)
        rewardItem:getChildById('rewardItemCnt'):setText("x " .. tostring(localTaskList[taskNumber].taskRewards.items[i].itemCnt))
        rewardItem:getChildById('rewardItemName'):setText(localTaskList[taskNumber].taskRewards.items[i].name)
      end
    else
      taskRewardItemPanel:hide()
    end
  end
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

