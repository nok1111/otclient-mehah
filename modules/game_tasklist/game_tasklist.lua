taskListsWindow = nil
taskDescriptionWindow = nil

local askWidget = nil
local taskListButton = nil
local localTaskList = {}
local localTaskWdgList = {}

local localRewardItemList = {}
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

function printOutTask(tmpTaskList)
    for i = 1, #tmpTaskList, 1 do
        print("Task number: "..tostring(tmpTaskList[i].taskNumber))
        print("Task name: "..tostring(tmpTaskList[i].taskName))
        print("Task description: "..tostring(tmpTaskList[i].taskDesc))

        if tmpTaskList[i].taskGoals then
            print("\tTask goals:")
            if tmpTaskList[i].taskGoals.monsters then
                for j = 1, #tmpTaskList[i].taskGoals.monsters, 1 do
                    print("\tMonster name: "..tostring(tmpTaskList[i].taskGoals.monsters[j].name))
                    print("\tMonster id: "..tostring(tmpTaskList[i].taskGoals.monsters[j].spriteId))
                end
            end
            if tmpTaskList[i].taskGoals.items then
                for j = 1, #tmpTaskList[i].taskGoals.items, 1 do
                    print("\tItem name: "..tostring(tmpTaskList[i].taskGoals.items[j].name))
                    print("\tItem id: "..tostring(tmpTaskList[i].taskGoals.items[j].itemId))
                end
            end
            if tmpTaskList[i].taskGoals.storages then
                for j = 1, #tmpTaskList[i].taskGoals.storages, 1 do
                    print("\tStorage name: "..tostring(tmpTaskList[i].taskGoals.storages[j].name))
                    print("\tStorage id: "..tostring(tmpTaskList[i].taskGoals.storages[j].itemId))
                end
            end
        end
        print("Task goal cnt: "..tostring(tmpTaskList[i].taskGoalCnt))
        print("Task min level: "..tostring(tmpTaskList[i].taskMinLvl))
        print("Task max level: "..tostring(tmpTaskList[i].taskMaxLvl))
        print("Task can be repeat: "..tostring(tmpTaskList[i].taskRepeat))
        print("Task state: "..tostring(tmpTaskList[i].taskState))
        print("Task counter state: "..tostring(tmpTaskList[i].taskCurrentCnt))
        if tmpTaskList[i].taskRewards then
            print("\tTask rewards:")
            if tmpTaskList[i].taskRewards.exp then
                print("\tTask exp reward: "..tostring(tmpTaskList[i].taskRewards.exp))
            end
            if tmpTaskList[i].taskRewards.items then
                for j = 1, #tmpTaskList[i].taskRewards.items, 1 do
                    print("\tReward name: "..tostring(tmpTaskList[i].taskRewards.items[j].name))
                    print("\tReward cid: "..tostring(tmpTaskList[i].taskRewards.items[j].itemCid))
                    print("\tReward sid: "..tostring(tmpTaskList[i].taskRewards.items[j].itemSid))
                    print("\tReward cnt: "..tostring(tmpTaskList[i].taskRewards.items[j].itemCnt))
                end
            end
            if tmpTaskList[i].taskRewards.outfits then
                for j = 1, #tmpTaskList[i].taskRewards.outfits, 1 do
                    print("\tOutfit name: "..tostring(tmpTaskList[i].taskRewards.outfits[j].name))
                    print("\tOutfit looktype: "..tostring(tmpTaskList[i].taskRewards.outfits[j].lookType))
                end
            end
        end
				print("Task zone: "..tostring(tmpTaskList[i].taskZone))
				print("Task Source: "..tostring(tmpTaskList[i].taskSourceNpc))
				print("Task Hint: "..tostring(tmpTaskList[i].taskHintNpc))
    end
end

function parseIncomingTaskList(buffer)
    print("buffer:"..tostring(buffer))
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
        local rewardOutfitaskListWindowts = {}
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
        --parsing all goalstaskName----------------------------------------------------------------------------------------------------------------------------
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
        --parsing all rewards----------------------------------------------------------------------------------------------------------------------------
        local rewardsItemCnt = tonumber(basicRewardSplit[2])
        local rewardsOutfitCnt = tonumber(basicRewardSplit[3])
        for j = 1, rewardsItemCnt do
            table.insert(rewardItems, {name = itemRewardSplit[(4*(j-1)) + 1], itemCid = tonumber(itemRewardSplit[(4*(j-1)) + 2]), itemSid = tonumber(itemRewardSplit[(4*(j-1)) + 3]), itemCnt = tonumber(itemRewardSplit[(4*(j-1)) + 4])})
        end
        for j = 1, rewardsOutfitCnt do
            table.insert(rewardOutfits, {name = outfitRewardSplit[(2*(j-1)) + 1], lookType = tonumber(outfitRewardSplit[(2*(j-1)) + 2]) })
        end
        rewardList = {exp = tonumber(basicRewardSplit[1]), items = rewardItems, outfits = rewardOutfits}
        -----------------------------------------------------------------------------------------------------------------------------------------------
        table.insert(parseTaskList, {taskNumber = taskSplit[11], taskName = taskSplit[1], taskDesc = taskSplit[2], taskGoals = targetList,
                                     taskGoalCnt = tonumber(taskSplit[4]), taskMinLvl = tonumber(taskSplit[5]), taskMaxLvl = tonumber(taskSplit[6]),
                                     taskRepeat = toboolean(taskSplit[7]), taskState = tonumber(taskSplit[8]), taskCurrentCnt = tonumber(taskSplit[9]),
                                     taskRewards = rewardList, taskZone = taskSplit[12], taskSourceNpc = taskSplit[13], taskHintNpc = taskSplit[14]})
    end
    return parseTaskList
end

function onExtendedTaskList(protocol, opcode, buffer)
    localTaskList = parseIncomingTaskList(buffer)
   -- printOutTask(localTaskList)
    for i = 1, #localTaskList, 1 do
      if localTaskList[i].taskState > 0 and localTaskList[i].taskState < 3 then
          local taskItem = g_ui.createWidget('TaskRecord', taskListPanel)
          table.insert(localTaskWdgList, taskItem)
          taskItem:setId("task"..tostring(i))
          local taskState = taskItem:getChildById('taskState')
          local taskName = taskItem:getChildById('taskName')
          local taskLevel = taskItem:getChildById('taskLevel')
          if taskName then
            taskName:setText(localTaskList[i].taskName)
          end
          if taskLevel then
            local lvlTxt = "Lvl " .. tostring(localTaskList[i].taskMinLvl) -- .. "-" .. tostring(localTaskList[i].taskMaxLvl)
            taskLevel:setText(lvlTxt)
          end
          if taskState then
            taskState:setImageSource("/images/taskList/"..tostring(localTaskList[i].taskState))
          end
      end
    end
    local widgetTitle = "Quest Log ("
    widgetTitle = widgetTitle .. tostring(#localTaskList) .. "/15)"
    taskListsWindow:setText(widgetTitle)
end

function onExtendedUpdateTask(protocol, opcode, buffer)
    local mainSplit = {}
    for split in string.gmatch(buffer, "(.-)|") do
        table.insert(mainSplit, split)
    end
    local idx = tonumber(mainSplit[1])
    local state = tonumber(mainSplit[2])
    local cnt = tonumber(mainSplit[3])

    --localTaskList[idx].taskState = state
    --localTaskList[idx].taskCurrentCnt = cnt
end

function onExtendedNpcTaskList(protocol, opcode, buffer)
    lastOpcode = opcode
    npcTaskList = {}
    npcTaskList = parseIncomingTaskList(buffer)

    if npcTaskWidget ~= nil then
        npcTaskWidget:destroy()
    end

    npcTaskWidget = g_ui.createWidget('NpcTaskListWidget', modules.game_interface.getRootPanel())
    local posWidget = {x = 600, y = 300}
    npcTaskWidget:setText("World Quests")
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
      npcTaskWidget:getChildById("acceptButton"):show()
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
     -- npcTaskWidget:getChildById("acceptButton"):show()
    end
    UpdateNpcTaskDescription()
end

function init()
    g_ui.importStyle('npc_tasklist')

    taskListButton = modules.game_mainpanel.addStoreButton('taskListButton', tr('Quest List'), '/images/options/quests_large', toggle,
        false)
    taskListButton:setOn(false)

    ProtocolGame.registerExtendedOpcode(ExtendedIds.TaskList, onExtendedTaskList)
    ProtocolGame.registerExtendedOpcode(ExtendedIds.UpdateTask, onExtendedUpdateTask)
    ProtocolGame.registerExtendedOpcode(ExtendedIds.NpcTaskList, onExtendedNpcTaskList)
    ProtocolGame.registerExtendedOpcode(ExtendedIds.NpcRewardList, onExtendedNpcRewardList)

    taskListsWindow = g_ui.displayUI('game_tasklist', modules.game_interface.getRightPanel())
    taskDescriptionWindow = taskListsWindow:recursiveGetChildById('taskDescriptionWnd')
    taskDescriptionWindow:hide()
	taskRewardItemPanel = taskDescriptionWindow:recursiveGetChildById('rewardItemsPanel')
    taskListPanel = taskListsWindow:recursiveGetChildById('taskListPanel')
    taskListsWindow:hide()
    deleteButton = taskListsWindow:recursiveGetChildById('deleteButton')
    deleteButton:hide()

    if g_game.isOnline() then
      online()
    end
end

function terminate()
    ProtocolGame.unregisterExtendedOpcode(ExtendedIds.TaskList)
    ProtocolGame.unregisterExtendedOpcode(ExtendedIds.UpdateTask)
    ProtocolGame.unregisterExtendedOpcode(ExtendedIds.NpcTaskList)
    ProtocolGame.unregisterExtendedOpcode(ExtendedIds.NpcRewardList)

    taskListsWindow:destroy()
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
    print("selected task do delete:"..tostring(currentSelectedTask))
    local protocol = g_game.getProtocolGame()
    if protocol and currentSelectedTask > 0 then
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
    UpdateNpcTaskDescription()
	npcTaskWidget:getChildById("acceptButton"):show()
end

function sendSelectTask(taskId)
    local protocol = g_game.getProtocolGame()
    if protocol then
        if lastOpcode == ExtendedIds.NpcTaskList then
            protocol:sendExtendedOpcode(ClientOpcodes.ClientSelectTask, tostring(taskId))
        elseif lastOpcode == ExtendedIds.NpcRewardList then
            protocol:sendExtendedOpcode(ClientOpcodes.ClientSelectReward, tostring(taskId))
        end
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
                rewardItem:getChildById('rewardItemCnt'):setText("x " .. tostring(taskListToShow[npcSelectedTask].taskRewards.items[i].itemCnt))
                rewardItem:getChildById('rewardItemName'):setText(taskListToShow[npcSelectedTask].taskRewards.items[i].name)
            end
        else
            npcRewardItemPanel:hide()
        end
    end
end



function acceptNpcTask()
    print("npcSelectedTask:"..tostring(npcSelectedTask))
    if npcSelectedTask and npcSelectedTask > 0 then -- Check if npcSelectedTask is not nil and > 0
        local taskListToShow = nil
        local buttonIdStr = ""
        if lastOpcode == ExtendedIds.NpcTaskList then
            taskListToShow = npcTaskList
            buttonIdStr = "npcTaskButton"
        elseif lastOpcode == ExtendedIds.NpcRewardList then
            taskListToShow = npcRewardList
            buttonIdStr = "npcRewardButton"
        end

        -- Check if taskListToShow has the selected task
        if taskListToShow and taskListToShow[npcSelectedTask] then
            sendSelectTask(taskListToShow[npcSelectedTask].taskNumber)
            local npcTaskListPanel = npcTaskWidget:recursiveGetChildById("npcTaskListPanel")
            if npcTaskListPanel then -- Check if npcTaskListPanel is found
                local button = npcTaskListPanel:recursiveGetChildById(buttonIdStr..tostring(npcSelectedTask))
                if button then -- Check if the button is found
                    npcTaskListPanel:removeChild(button)
					npcTaskWidget:getChildById("acceptButton"):hide()
                else
                    print("Button not found: "..buttonIdStr..tostring(npcSelectedTask))
                end
            else
                print("npcTaskListPanel not found")
            end
            npcTaskDescription:hide()
            if npcTaskListPanel and npcTaskListPanel:hasChildren() then
                --npcTaskWidget:getChildById("acceptButton"):show()
            else
                npcTaskWidget:getChildById("acceptButton"):hide()
            end
        else
            print("Selected task not found in the task list.")
        end
    else
        print("No task selected.")
    end
end


function declineNpcTask()
    lastOpcode = 0
    npcSelectedTask = 0
    npcTaskWidget:hide()
end

function onTaskClick(widget)
  print("Task clicked")
  local taskName = widget:getChildById('taskName')
  local taskLevel = widget:getChildById('taskLevel')
  print(tostring(taskName:getText()).."|"..tostring(taskLevel:getText()).."|"..tostring(widget:getId()).."|"..string.sub(widget:getId(), 5))
  local taskNumber = tonumber(string.sub(widget:getId(), 5))
  
  for i = #localRewardItemList, 1, -1 do
    localRewardItemList[i]:destroy()
    table.remove(localRewardItemList, i)
  end
  taskDescriptionWindow:show()
  deleteButton:show()
  updateTaskDescription(taskNumber)
  currentSelectedTask = tonumber(localTaskList[taskNumber].taskNumber)
end

function updateTaskDescription(taskNumber)
  if taskNumber > #localTaskList then
    return
  end
  taskDescriptionWindow:getChildById('taskDescription'):setText(localTaskList[taskNumber].taskDesc)
  taskDescriptionWindow:getChildById('taskDescription'):setTextAutoResize(true)
  taskDescriptionWindow:getChildById('taskZoneName'):setText(localTaskList[taskNumber].taskZone)
  taskDescriptionWindow:getChildById('taskZoneName'):setTextAutoResize(true)
  taskDescriptionWindow:getChildById('taskSource'):setText(localTaskList[taskNumber].taskSourceNpc)
  taskDescriptionWindow:getChildById('taskSource'):setTextAutoResize(true)
  taskDescriptionWindow:getChildById('taskHint'):setText(localTaskList[taskNumber].taskHintNpc)
  taskDescriptionWindow:getChildById('taskHint'):setTextAutoResize(true)
  taskDescriptionWindow:getChildById('rewardExp'):setText("Experience gain: "..localTaskList[taskNumber].taskRewards.exp)
  if localTaskList[taskNumber].taskRewards.outfits and #localTaskList[taskNumber].taskRewards.outfits > 0 then
    taskDescriptionWindow:getChildById('rewardOutfit'):setText("Outfit: "..localTaskList[taskNumber].taskRewards.outfits[1].name)
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

