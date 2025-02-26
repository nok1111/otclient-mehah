local OPCODE = 92

local trackerButton = nil
local trackerWindow = nil
local tasksWindow = nil

local jsonData = ""
local config = {}
local tasks = {}
local activeTasks = {}
local playerLevel = 0
local RewardType = {
  Points = 1,
  Ranking = 2,
  Experience = 3,
  Gold = 4,
  Item = 5,
  Storage = 6,
  Teleport = 7,
}

local ranks = {
  {name = "Rookie", points = 0},  -- No badge reward for the first rank
  {name = "Bronze", points = 12, clientId = 25160, itemName = "Merchant's Badge"},  
  {name = "Silver", points = 24, clientId = 25165, itemName = "Voyager Badge"},  
  {name = "Gold", points = 48, clientId = 25169, itemName = "Harvest Badge"},  
  {name = "Platinum", points = 72, clientId = 25147, itemName = "Forge Badge"},  
  {name = "Diamond", points = 144, clientId = 25155, itemName = "Resilience Badge"},  
  {name = "Ancestral", points = 288, clientId = 25178, itemName = "Soul Badge"},  
  {name = "Mystic", points = 400, clientId = 25182, itemName = "Freedom Badge"},  
  {name = "Abyssal", points = 560, clientId = 25174, itemName = "Alchemist Badge"},  
  {name = "Ascending", points = 720, clientId = 25151, itemName = "Treasure Badge"},  
  {name = "Chaos", points = 880, clientId = 26937, itemName = "Preserver Badge"},  
  {name = "Awakening", points = 1040, clientId = 26942, itemName = "Nullifier Badge"}
}

function init()
	connect(g_game,{
		onGameStart = create,
		onGameEnd = destroy
    })

	ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)

	if g_game.isOnline() then
		create()
	end
end

function terminate()
	disconnect(g_game, {
		onGameStart = create,
		onGameEnd = destroy
    })

	ProtocolGame.unregisterExtendedOpcode(OPCODE, onExtendedOpcode)
	destroy()
end

function create()
  if tasksWindow then
    return
  end
openTasksButton = modules.client_topmenu.addLeftGameToggleButton("openTasksButton", tr("Open Tasks Panel"), "/images/topbuttons/ancestraltask", toggleTasksPanel)
  openTasksButton:setOn(true)
  trackerButton = modules.client_topmenu.addLeftGameToggleButton("trackerButton", tr("Tasks Tracker"), "/images/topbuttons/ancestraltasktracker", toggleTracker)
  trackerButton:setOn(true)
  trackerWindow = g_ui.loadUI("tasks_tracker", modules.game_interface.getRightPanel())
  trackerWindow.miniwindowScrollBar:mergeStyle({["$!on"] = {}})
  trackerWindow:setContentMinimumHeight(120)
  trackerWindow:setup()

  tasksWindow = g_ui.displayUI("tasks")
  tasksWindow:hide()
end

function toggleTasksPanel()
  if tasksWindow:isVisible() then
    tasksWindow:hide()
  else
    tasksWindow:show()
  end
end

function destroy()
  if tasksWindow then
    trackerButton:destroy()
    trackerButton = nil
    trackerPanel = nil
    trackerWindow:destroy()
    trackerWindow = nil

    tasksWindow:destroy()
    tasksWindow = nil
  end

  config = {}
  tasks = {}
  activeTasks = {}
  playerLevel = 0
  jsonData = ""
end

function onExtendedOpcode(protocol, code, buffer)
  local json_status, json_data =
    pcall(
    function()
      return json.decode(buffer)
    end
  )

  if not json_status then
    g_logger.error("[Tasks] JSON error: " .. json_data)
    return
  end

  local action = json_data.action
  local data = json_data.data

  if action == "config" then
    onTasksConfig(data)
  elseif action == "tasks" then
    onTasksList(data)
  elseif action == "active" then
    onTasksActive(data)
  elseif action == "update" then
    onTaskUpdate(data)
  elseif action == "points" then
    onTasksPoints(data)
  elseif action == "ranking" then
    onTasksRanking(data)
  elseif action == "open" then
    show()
  elseif action == "close" then
    hide()
  end
end

function onTasksConfig(data)

  config = data
end

function onTasksList(data)
  for i, data2 in ipairs(data.chunk) do
	tasks[#tasks + 1] = data2
  end
  if data.endPack == false then return end
  local localPlayer = g_game.getLocalPlayer()
  local level = localPlayer:getLevel()
  for taskId, task in ipairs(tasks) do
    local widget = g_ui.createWidget("TaskMenuEntry", tasksWindow.tasksList)
    widget:setId(taskId)
    local outfit = task.outfits[1]
    widget.preview:setOutfit(outfit)
    widget.preview:setCenter(true)
    widget.info.title:setText(task.name)
    widget.info.level:setText("Level " .. task.lvl)
	------------------------------------------
	local requiredKills = task.req
	widget.info.required:setText(requiredKills)
	widget.info.type:setText(task.type)
	widget.info.diff:setText(task.diff)
	------------------------------------------
    if not (task.lvl >= level - config.range and task.lvl <= level + config.range) then
      widget.info.bonus:hide()
    end
  end

  tasksWindow.tasksList.onChildFocusChange = onTaskSelected
  onTaskSelected(nil, tasksWindow.tasksList:getChildByIndex(1))
  playerLevel = g_game.getLocalPlayer():getLevel()
end

function onTasksActive(data)

  for _, active in ipairs(data) do
    local task = tasks[active.taskId]
    local widget = g_ui.createWidget("TrackerButton", trackerWindow.contentsPanel.trackerPanel)
    widget:setId(active.taskId)
    local outfit = task.outfits[1]
    widget.creature:setOutfit(outfit)
    widget.creature:setCenter(true)
    if task.name:len() > 12 then
      widget.label:setText(task.name:sub(1, 9) .. "...")
    else
      widget.label:setText(task.name)
    end
    widget.kills:setText(active.kills .. "/" .. active.required)
    local percent = active.kills * 100 / active.required
    setBarPercent(widget, percent)
    widget.onMouseRelease = onTrackerClick
    activeTasks[active.taskId] = true
  end
end

function onTaskUpdate(data)
  local widget = trackerWindow.contentsPanel.trackerPanel[tostring(data.taskId)]
  if data.status == 1 then
    local task = tasks[data.taskId]
    if not widget then
      widget = g_ui.createWidget("TrackerButton", trackerWindow.contentsPanel.trackerPanel)
      widget:setId(data.taskId)
      local outfit = task.outfits[1]
      widget.creature:setOutfit(outfit)
      widget.creature:setCenter(true)
      if task.name:len() > 12 then
        widget.label:setText(task.name:sub(1, 9) .. "...")
      else
        widget.label:setText(task.name)
      end
      widget.onMouseRelease = onTrackerClick
      activeTasks[data.taskId] = true
    end

    widget.kills:setText(data.kills .. "/" .. data.required)
    local percent = data.kills * 100 / data.required
    setBarPercent(widget, percent)
  elseif data.status == 2 then
    activeTasks[data.taskId] = nil
    if widget then
      widget:destroy()
    end
  end

  local focused = tasksWindow.tasksList:getFocusedChild()
  if focused then
    local taskId = tonumber(focused:getId())
    if taskId == data.taskId then
      if activeTasks[data.taskId] then
        tasksWindow.start:hide()
        tasksWindow.cancel:show()
      else
        tasksWindow.start:show()
        tasksWindow.cancel:hide()
      end
    end
  end
end

function onTasksPoints(points)
	if points < 0 then
		points = 0
	end
	for k = 1, #ranks do
		if points >= ranks[k].points then
			if not ranks[k+1] then
				tasksWindow.main.rankbarpanel.rankBar:setPercent(100)
				tasksWindow.main.rankbarpanel.rankBar:setText("Congratulation!")
			else
				local mathCheck = ranks[k+1].points - points
				local percent = points*100/ranks[k+1].points
				tasksWindow.main.rankbarpanel.rankBar:setPercent(math.floor(percent))
				tasksWindow.main.rankbarpanel.rankBar:setText(ranks[k+1].name.." ("..math.abs(mathCheck)..")")
			end
		end
	end
	tasksWindow.main.points:setText("Current Artifacts Mastery Points: " .. points)
end

function onTasksRanking(data)
  local rank = data.rank or "Rookie"
  tasksWindow.main.ranks:setText("Current Artifacts Mastery: " .. rank)
  tasksWindow.main.rank.rankImage:setImageSource("ranks/" .. rank)
  tasksWindow.main.rankName:setText(rank)

  -- Find the next rank based on current rank name
  local nextBadge = "None"
  local nextItemId = nil

  for i = 1, #ranks do
      if ranks[i].name == rank then -- Match current rank
          local nextRank = ranks[i + 1] -- Get next rank
          if nextRank and nextRank.clientId then
              nextBadge = nextRank.itemName
              nextItemId = nextRank.clientId
          end
          break
      end
  end

  tasksWindow.main.nextBadge:setText("Next Badge Reward: " .. nextBadge)

  local itemContainer = tasksWindow:recursiveGetChildById("itemContainer") -- container
  local itemWidget = tasksWindow:recursiveGetChildById("nextBadgeItem")
  if itemWidget and nextItemId then
      itemWidget:setItemId(nextItemId)
      itemWidget:setVirtual(true)
  else
      if itemWidget and itemContainer then
          itemWidget:setVisible(false) -- Hide the item widget
          itemContainer:setVisible(false) -- Hide the entire container
      else
      end
  end
end

function onTrackerClick(widget, mousePosition, mouseButton)
  local taskId = tonumber(widget:getId())
  local menu = g_ui.createWidget("PopupMenu")
  menu:setGameMenu(true)
  menu:addOption(
    "Abandon this task",
    function()
      cancel(taskId)
    end
  )
  menu:display(menuPosition)

  return true
end

function setBarPercent(widget, percent)
  if percent > 92 then
    widget.killsBar:setBackgroundColor("#00BC00")
  elseif percent > 60 then
    widget.killsBar:setBackgroundColor("#50A150")
  elseif percent > 30 then
    widget.killsBar:setBackgroundColor("#A1A100")
  elseif percent > 8 then
    widget.killsBar:setBackgroundColor("#BF0A0A")
  elseif percent > 3 then
    widget.killsBar:setBackgroundColor("#910F0F")
  else
    widget.killsBar:setBackgroundColor("#850C0C")
  end
  widget.killsBar:setPercent(percent)
end

function onTaskSelected(parent, child, reason)
	if not child then
		return
	end

	local taskId = tonumber(child:getId())
	local task = tasks[taskId]
	local requiredKills = task.req or 0
	tasksWindow.rewards.itemReward.List:destroyChildren()
	tasksWindow.rewards.req:setText("Required Kills: "..requiredKills)
	tasksWindow.rewards.boss:setText("Boss: None")
	for _, reward in ipairs(task.rewards) do
		if reward.type == RewardType.Points then
			tasksWindow.rewards.tp:setText("Tasks Points: " .. reward.value)
		elseif reward.type == RewardType.Ranking then
			tasksWindow.rewards.rp:setText("Ranking Points: " .. reward.value)
		elseif reward.type == RewardType.Experience then
			tasksWindow.rewards.exp:setText("Experience: " .. comma_value(reward.value))
		elseif reward.type == RewardType.Gold then
			tasksWindow.rewards.gold:setText("Gold: " .. comma_value(reward.value))
		elseif reward.type == RewardType.Item then
			local label = g_ui.createWidget('rewardItem', tasksWindow.rewards.itemReward.List)
			label.item:setItemId(reward.id)
			local itemName = ""
			if reward.name:len() >= 12 then
				itemName = reward.name:sub(1, 12) .. ".."
			else
				itemName = reward.name
			end
			label.name:setText(reward.amount .. "x " .. itemName)
		elseif reward.type == RewardType.Teleport then
			local bossName = ""
			if reward.desc:len() >= 16 then
				bossName = reward.desc:sub(1, 16) .. ".."
			else
				bossName = reward.desc
			end
			tasksWindow.rewards.boss:setText("Boss: " .. bossName)
		end
	end

	tasksWindow.monsters.list:destroyChildren()
	for id, monster in ipairs(task.mobs) do
		local widget = g_ui.createWidget("monsterIn", tasksWindow.monsters.list)
		local outfit = task.outfits[id]
		widget.monster:setOutfit(outfit)
		widget.monster:setCenter(true)
		widget:setPhantom(false)
		widget.name:setText(monster)
	end

	if activeTasks[taskId] then
		tasksWindow.start:hide()
		tasksWindow.cancel:show()
	else
		tasksWindow.start:show()
		tasksWindow.cancel:hide()
	end
end

function onSearch()
  scheduleEvent(function()
      local searchInput = tasksWindow.typePanel.search
      local text = searchInput:getText():lower()

      if text:len() >= 1 then
        local children = tasksWindow.tasksList:getChildren()
        for i, child in ipairs(children) do
          local found = false
          for _, mob in ipairs(tasks[i].mobs) do
            if mob:lower():find(text) then
              found = true
              break
            end
          end

          if found then
            child:show()
          else
            child:hide()
          end
        end
      else
        local children = tasksWindow.tasksList:getChildren()
        for _, child in ipairs(children) do
          child:show()
        end
      end
    end, 50)
end

function onSort()
	if not tasksWindow then return end
	if not tasksWindow.typePanel then return end
	
    local type = tasksWindow.typePanel.type:getCurrentOption().text:lower()
    local difficulty = tasksWindow.typePanel.difficulty:getCurrentOption().text:lower()
    local children = tasksWindow.tasksList:getChildren()
    if type == "all" and difficulty == "all" then
        for _, child in ipairs(children) do
            child:show()
        end
        return
    end

    for _, child in ipairs(children) do
        local typeInfo = child.info.type:getText():lower()
        local diffInfo = child.info.diff:getText():lower()
        if (type == "all" or typeInfo:find(type)) and (difficulty == "all" or diffInfo:find(difficulty)) then
            child:show()
        else
            child:hide()
        end
    end
end

function start()
  local focused = tasksWindow.tasksList:getFocusedChild()
  local requiredKills = 100
  local taskId = tonumber(focused:getId())
  local protocolGame = g_game.getProtocolGame()

  if protocolGame then
    protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "start", data = {taskId = taskId, kills = requiredKills}}))
  end
end

function cancel(taskId)
  if not taskId then
    local focused = tasksWindow.tasksList:getFocusedChild()
    if not focused then
      return
    end

    taskId = tonumber(focused:getId())
  end

  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "cancel", data = taskId}))
  end
end

function onTrackerClose()
  trackerButton:setOn(false)
end

function toggleTracker()
  if not trackerWindow then
    return
  end

  if trackerButton:isOn() then
    trackerWindow:close()
    trackerButton:setOn(false)
  else
    trackerWindow:open()
    trackerButton:setOn(true)
  end
end

function toggle()
  if not tasksWindow then
    return
  end
  if tasksWindow:isVisible() then
    return hide()
  end
  show()
end

function show()
  if not tasksWindow then
    return
  end

  local level = g_game.getLocalPlayer():getLevel()
  if playerLevel ~= level then
    local children = tasksWindow.tasksList:getChildren()
    for taskId, child in ipairs(children) do
      local task = tasks[taskId]
      if task.lvl >= level - config.range and task.lvl <= level + config.range then
        child.bonus:show()
      else
        child.bonus:hide()
      end
    end
    playerLevel = level
  end

  local focused = tasksWindow.tasksList:getFocusedChild()
  if focused then
    local taskId = tonumber(focused:getId())
    if activeTasks[taskId] then
      tasksWindow.start:hide()
      tasksWindow.cancel:show()
    else
      tasksWindow.start:show()
      tasksWindow.cancel:hide()
    end
  end

  tasksWindow:show()
  tasksWindow:raise()
  tasksWindow:focus()
end

function hide()
  if not tasksWindow then
    return
  end
  tasksWindow:hide()
end
