local OPCODE = 110

local trackerButton = nil
local trackerWindow = nil
local trackerPanel = nil
local finishedPanel = nil

local tasksWindow = nil
local itemsPanel = nil
local creaturePanel = nil

local selected = nil
local tasks = {}

local levels = {
  {-1, -1},
  {"[Tier 1] Garona"},
  {"[Tier 2] Wilthorns"},
  {"[Tier 3] Rehema"},
  {"[Tier 4] Swantears"},
  {"[Tier 5] Firewind"},
  {"[Tier 5.1] Warlands"}
}

function init()
  connect(
    g_game,
    {
      onGameStart = create,
      onGameEnd = destroy
    }
  )

  ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)

  if g_game.isOnline() then
    create()
  end
end

function terminate()
  disconnect(
    g_game,
    {
      onGameStart = create,
      onGameEnd = destroy
    }
  )

  ProtocolGame.unregisterExtendedOpcode(OPCODE, onExtendedOpcode)
	
  destroy()

end

function create()
  if tasksWindow then
    return
  end

  trackerButton = modules.client_topmenu.addRightGameToggleButton("trackerButton", tr("Tasks Tracker"), "/images/topbuttons/battle", toggleTracker)
  trackerButton:setOn(true)
  trackerWindow = g_ui.loadUI("tasks_tracker", modules.game_interface.getRightPanel())
  local scrollbar = trackerWindow:getChildById("miniwindowScrollBar")
  scrollbar:mergeStyle({["$!on"] = {}})
  trackerPanel = trackerWindow:recursiveGetChildById("trackerPanel")
  finishedPanel = trackerWindow:recursiveGetChildById("finishedPanel")
  trackerWindow:setContentMinimumHeight(120)
  trackerWindow:setup()

  tasksWindow = g_ui.displayUI("tasks")
  tasksWindow:hide()
  tasksWindow:getChildById("monstersTab"):setOn(true)

  itemsPanel = tasksWindow:recursiveGetChildById("itemsPanel")
  creaturePanel = tasksWindow:recursiveGetChildById("panelCreatureView")
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "fetch"}))
  end
end

function destroy()
  if tasksWindow then
    trackerButton:destroy()
    trackerButton = nil
    trackerPanel = nil
    finishedPanel = nil
    trackerWindow:destroy()
    trackerWindow = nil

    itemsPanel = nil
    creaturePanel = nil
    tasksWindow:destroy()
    tasksWindow = nil
  end
  

  tasks = {}
end

function onExtendedOpcode(protocol, code, buffer)
  local json_status, data =
    pcall(
    function()
      return json.decode(buffer)
    end
  )

  if not json_status then
    g_logger.error("[Tasks] JSON error: " .. data)
    return false
  end

  if data.action == "fetch" then
    for k, v in pairs(data.data) do
      tasks[#tasks + 1] = v
    end
    table.sort(
      tasks,
      function(a, b)
        return a.level < b.level
      end
    )
    for i = 1, #tasks do
      addToList(tasks[i])
    end
    local levelWidget = tasksWindow:getChildById("level")
    if levelWidget:getOptionsCount() == 0 then
      levelWidget.onOptionChange = onLevelChange
      for i = 1, #levels do
        if i == 1 then
          levelWidget:addOption("All", i)
        else
          levelWidget:addOption(levels[i][1], i)
        end
      end
      levelWidget:setCurrentIndex(1)
    end
  elseif data.action == "update" then
    updateTask(data.data)
  elseif data.action == "open" then
    show()
  elseif data.action == "close" then
    hide()
  end
end

function addToList(monster)
  if not monster.finished then
    local panel = g_ui.createWidget("LootMonsterBox_classic", itemsPanel)
    panel:setId(monster.raceName)
    panel:setText(monster.raceName)
    local text = ""
    if monster.completed then
      text = text .. "Completed"
    elseif monster.active then
      text = text .. "Kills: " .. monster.kills .. " / " .. monster.killsRequired
    else
      text = text .. "Kills: " .. monster.killsRequired
    end
    text = text .. "\nLevel: " .. monster.level
    panel:getChildById("info"):setText(text)
    if type(monster.outfit) == "table" then
      panel:getChildById("creature"):setOutfit(
        {
          type = monster.outfit.id,
          head = monster.outfit.head,
          body = monster.outfit.body,
          legs = monster.outfit.legs,
          feet = monster.outfit.feet,
          addons = monster.outfit.addons
        }
      )
    else
      panel:getChildById("creature"):setOutfit({type = monster.outfit})
    end
  end
end

function selectMonster(widget)
  local task = nil
  for i = 1, #tasks do
    if tasks[i].raceName == widget:getId() then
      task = tasks[i]
      selected = tasks[i].raceName
      break
    end
  end
  tasksWindow:getChildById("monstersTab"):setOn(false)
  tasksWindow:getChildById("allLootTab"):setOn(false)
  tasksWindow:getChildById("acceptButton"):show()
  tasksWindow:getChildById("itemsPanelListScrollBar"):hide()
  tasksWindow:getChildById("recommended"):hide()
  tasksWindow:getChildById("searchLabel"):hide()
  local searchInput = tasksWindow:getChildById("searchInput")
  searchInput:setText("")
  searchInput:hide()
  itemsPanel:hide()
  creaturePanel:show()
  local creatureView = creaturePanel:getChildById("creatureView")
  creatureView:setText(task.raceName)
  local text = ""
  if task.completed then
    text = text .. "Completed"
    tasksWindow:getChildById("acceptButton"):setText("Finish")
  elseif task.active then
    text = text .. "Kills: " .. task.kills .. " / " .. task.killsRequired
    tasksWindow:getChildById("acceptButton"):setText("Cancel")
  else
    text = text .. "Kills: " .. task.killsRequired
    tasksWindow:getChildById("acceptButton"):setText("Accept")
  end
  text = text .. "\nLevel: " .. task.level
  creatureView:getChildById("info"):setText(text)
  if type(task.outfit) == "table" then
    creatureView:getChildById("creature"):setOutfit(
      {
        type = task.outfit.id,
        head = task.outfit.head,
        body = task.outfit.body,
        legs = task.outfit.legs,
        feet = task.outfit.feet,
        addons = task.outfit.addons
      }
    )
  else
    creatureView:getChildById("creature"):setOutfit({type = task.outfit})
  end

  local rewards = "Rewards for completing this task:"
  for i = 1, #task.rewards do
    local reward = task.rewards[i]
    if reward.type == "boss" then
      rewards = rewards .. "\nBoss Fight"
    else
      rewards = rewards .. "\n" .. reward.type:gsub("^%l", string.upper)
    end

    if reward.type == "item" then
      rewards = rewards .. ": " .. reward.values[1] .. " (x" .. reward.values[2] .. ")"
    else
      rewards = rewards .. ": " .. reward.values
    end
  end
  creaturePanel:getChildById("rewards"):getChildByIndex(1):setText(rewards)

  local p = creaturePanel:getChildById("monstersPanel")
  p:destroyChildren()
  for i = 1, #task.monsters do
    local panel = g_ui.createWidget("ListMonsterBox", p)
    panel:setEnabled(false)
    panel:setText(
      task.monsters[i]:gsub(
        "(%a)(%a+)",
        function(a, b)
          return string.upper(a) .. string.lower(b)
        end
      )
    )
    if type(task.outfits[i]) == "table" then
      panel:getChildById("creature"):setOutfit(
        {
          type = task.outfits[i].id,
          head = task.outfits[i].head,
          body = task.outfits[i].body,
          legs = task.outfits[i].legs,
          feet = task.outfits[i].feet,
          addons = task.outfits[i].addons
        }
      )
    else
      panel:getChildById("creature"):setOutfit({type = task.outfits[i]})
    end
  end
end

function updateTask(data)
  local task = nil
  for i = 1, #tasks do
    if tasks[i].raceName == data.raceName then
      task = tasks[i]
      task.active = data.active
      task.completed = data.completed
      task.finished = data.finished
      task.kills = data.kills
      break
    end
  end

  if task then
    local tButton = trackerPanel:recursiveGetChildById(task.raceName)
    if tButton then
      if data.delete then
        tButton:destroy()
        return
      end
      if task.killsRequired == task.kills then
        tButton:destroy()
        local fButton = g_ui.createWidget("TrackerButton", finishedPanel)
        fButton:setId(task.raceName)
        if type(task.outfit) == "table" then
          task.outfit.type = task.outfit.id
          fButton:getChildById("creature"):setOutfit(task.outfit)
        else
          fButton:getChildById("creature"):setOutfit({type = task.outfit})
        end
        fButton:getChildById("label"):setText(task.raceName)
        fButton:getChildById("kills"):setText(task.kills .. "/" .. task.killsRequired)
        fButton:getChildById("killsBar"):setBackgroundColor("green")
        fButton:getChildById("killsBar"):setPercent(100)
        return
      else
        tButton:getChildById("killsBar"):setBackgroundColor("red")
      end
      tButton:getChildById("kills"):setText(task.kills .. "/" .. task.killsRequired)
      tButton:getChildById("killsBar"):setPercent(task.kills * 100 / task.killsRequired)
    else
      tButton = finishedPanel:recursiveGetChildById(task.raceName)
      if tButton then
        if data.delete then
          tButton:destroy()
          return
        end
      else
        if data.delete then
          return
        end
        if task.killsRequired == task.kills then
          local fButton = g_ui.createWidget("TrackerButton", finishedPanel)
          fButton:setId(task.raceName)
          if type(task.outfit) == "table" then
            task.outfit.type = task.outfit.id
            fButton:getChildById("creature"):setOutfit(task.outfit)
          else
            fButton:getChildById("creature"):setOutfit({type = task.outfit})
          end
          fButton:getChildById("label"):setText(task.raceName)
          fButton:getChildById("kills"):setText(task.kills .. "/" .. task.killsRequired)
          fButton:getChildById("killsBar"):setBackgroundColor("green")
          fButton:getChildById("killsBar"):setPercent(100)
        else
          tButton = g_ui.createWidget("TrackerButton", trackerPanel)
          tButton:setId(task.raceName)
          if type(task.outfit) == "table" then
            task.outfit.type = task.outfit.id
            tButton:getChildById("creature"):setOutfit(task.outfit)
          else
            tButton:getChildById("creature"):setOutfit({type = task.outfit})
          end
          tButton:getChildById("label"):setText(task.raceName)
          tButton:getChildById("kills"):setText(task.kills .. "/" .. task.killsRequired)

          tButton:getChildById("killsBar"):setBackgroundColor("red")
          tButton:getChildById("killsBar"):setPercent(task.kills * 100 / task.killsRequired)
        end
      end
    end
  end
end

function showAvailable()
  tasksWindow:getChildById("monstersTab"):setOn(true)
  tasksWindow:getChildById("allLootTab"):setOn(false)
  tasksWindow:getChildById("acceptButton"):hide()
  tasksWindow:getChildById("itemsPanelListScrollBar"):show()
  tasksWindow:getChildById("recommended"):show()
  tasksWindow:getChildById("searchLabel"):show()
  local searchInput = tasksWindow:getChildById("searchInput")
  searchInput:setText("")
  searchInput:show()
  itemsPanel:show()
  creaturePanel:hide()

  itemsPanel:destroyChildren()
  for i = 1, #tasks do
    if not tasks[i].finished then
      local panel = g_ui.createWidget("LootMonsterBox_classic", itemsPanel)
      panel:setId(tasks[i].raceName)
      panel:setText(tasks[i].raceName)
      local text = ""
      if tasks[i].completed then
        text = text .. "Completed"
      elseif tasks[i].active then
        text = text .. "Kills: " .. tasks[i].kills .. " / " .. tasks[i].killsRequired
      else
        text = text .. "Kills: " .. tasks[i].killsRequired
      end
      text = text .. "\nLevel: " .. tasks[i].level
      panel:getChildById("info"):setText(text)
      if type(tasks[i].outfit) == "table" then
        panel:getChildById("creature"):setOutfit(
          {
            type = tasks[i].outfit.id,
            head = tasks[i].outfit.head,
            body = tasks[i].outfit.body,
            legs = tasks[i].outfit.legs,
            feet = tasks[i].outfit.feet,
            addons = tasks[i].outfit.addons
          }
        )
      else
        panel:getChildById("creature"):setOutfit({type = tasks[i].outfit})
      end
    end
  end
end

function showCompleted()
  tasksWindow:getChildById("monstersTab"):setOn(false)
  tasksWindow:getChildById("allLootTab"):setOn(true)
  tasksWindow:getChildById("acceptButton"):hide()
  tasksWindow:getChildById("itemsPanelListScrollBar"):show()
  tasksWindow:getChildById("recommended"):show()
  tasksWindow:getChildById("searchLabel"):show()
  local searchInput = tasksWindow:getChildById("searchInput")
  searchInput:setText("")
  searchInput:show()
  itemsPanel:show()
  creaturePanel:hide()

  itemsPanel:destroyChildren()
  for i = 1, #tasks do
    if tasks[i].finished then
      local panel = g_ui.createWidget("LootMonsterBox_classic", itemsPanel)
      panel:setEnabled(false)
      panel:setId(tasks[i].raceName)
      panel:setText(tasks[i].raceName)
      local text = ""
      if tasks[i].finished then
        text = text .. "Finished"
      elseif tasks[i].completed then
        text = text .. "Completed"
      elseif tasks[i].active then
        text = text .. "Kills: " .. tasks[i].kills .. " / " .. tasks[i].killsRequired
      else
        text = text .. "Kills: " .. tasks[i].killsRequired
      end
      text = text .. "\nLevel: " .. tasks[i].level
      panel:getChildById("info"):setText(text)
      for j = 1, #tasks[i].outfits do
        if type(tasks[i].outfits[j]) == "table" then
          panel:getChildById("creature"):setOutfit(
            {
              type = tasks[i].outfits[j].id,
              head = tasks[i].outfits[j].head,
              body = tasks[i].outfits[j].body,
              legs = tasks[i].outfits[j].legs,
              feet = tasks[i].outfits[j].feet,
              addons = tasks[i].outfits[j].addons
            }
          )
        else
          panel:getChildById("creature"):setOutfit({type = tasks[i].outfits[j]})
        end
      end
    end
  end
end

function onSearch()
  scheduleEvent(
    function()
      local searchInput = tasksWindow:getChildById("searchInput")
      local text = searchInput:getText():lower()
      if text:len() >= 1 then
        local children = itemsPanel:getChildCount()
        for i = 1, children do
          local child = itemsPanel:getChildByIndex(i)
          local taskId = child:getId():lower()
          if taskId:find(text) then
            child:show()
          else
            child:hide()
          end
        end
      else
        local children = itemsPanel:getChildCount()
        for i = 1, children do
          itemsPanel:getChildByIndex(i):show()
        end
      end
    end,
    50
  )
end

function recommended(force)
  if tasksWindow:getChildById("allLootTab"):isOn() and not force then
    return
  end

  local checked = tasksWindow:getChildById("recommended"):isChecked()
  if not force then
    tasksWindow:getChildById("recommended"):setChecked(not checked)
  end

  local searchInput = tasksWindow:getChildById("searchInput")
  local searchText = searchInput:getText():lower()

  itemsPanel:destroyChildren()

  if not checked then
    local player = g_game.getLocalPlayer()

    if player then
      local level = player:getLevel()
      for i = 1, #tasks do
        if not tasks[i].finished then
          if tasks[i].level >= level - 10 and tasks[i].level <= level + 10 or level >= tasks[i].level then
            local panel = g_ui.createWidget("LootMonsterBox_classic", itemsPanel)
            panel:setId(tasks[i].raceName)
            panel:setText(tasks[i].raceName)
            local text = ""
            if tasks[i].completed then
              text = text .. "Completed"
            elseif tasks[i].active then
              text = text .. "Kills: " .. tasks[i].kills .. " / " .. tasks[i].killsRequired
            else
              text = text .. "Kills: " .. tasks[i].killsRequired
            end
            text = text .. "\nLevel: " .. tasks[i].level
            panel:getChildById("info"):setText(text)
            for j = 1, #tasks[i].outfits do
              if type(tasks[i].outfits[j]) == "table" then
                panel:getChildById("creature"):setOutfit(
                  {
                    type = tasks[i].outfits[j].id,
                    head = tasks[i].outfits[j].head,
                    body = tasks[i].outfits[j].body,
                    legs = tasks[i].outfits[j].legs,
                    feet = tasks[i].outfits[j].feet,
                    addons = tasks[i].outfits[j].addons
                  }
                )
              else
                panel:getChildById("creature"):setOutfit({type = tasks[i].outfits[j]})
              end
            end
            if searchText:len() >= 1 then
              if tasks[i].raceName:lower():find(searchText) then
                panel:show()
              else
                panel:hide()
              end
            end
          end
        end
      end
    end
  else
    if tasksWindow:getChildById("level").currentIndex ~= 1 then
      onLevelChange(nil, nil, tasksWindow:getChildById("level").currentIndex)
    else
      for i = 1, #tasks do
        if not tasks[i].finished then
          local panel = g_ui.createWidget("LootMonsterBox_classic", itemsPanel)
          panel:setId(tasks[i].raceName)
          panel:setText(tasks[i].raceName)
          local text = ""
          if tasks[i].completed then
            text = text .. "Completed"
          elseif tasks[i].active then
            text = text .. "Kills: " .. tasks[i].kills .. " / " .. tasks[i].killsRequired
          else
            text = text .. "Kills: " .. tasks[i].killsRequired
          end
          text = text .. "\nLevel: " .. tasks[i].level
          panel:getChildById("info"):setText(text)
          for j = 1, #tasks[i].outfits do
            if type(tasks[i].outfits[j]) == "table" then
              panel:getChildById("creature"):setOutfit(
                {
                  type = tasks[i].outfits[j].id,
                  head = tasks[i].outfits[j].head,
                  body = tasks[i].outfits[j].body,
                  legs = tasks[i].outfits[j].legs,
                  feet = tasks[i].outfits[j].feet,
                  addons = tasks[i].outfits[j].addons
                }
              )
            else
              panel:getChildById("creature"):setOutfit({type = tasks[i].outfits[j]})
            end
          end
          if searchText:len() >= 1 then
            if tasks[i].raceName:lower():find(searchText) then
              panel:show()
            else
              panel:hide()
            end
          end
        end
      end
    end
  end
end

function onLevelChange(widget, name, id)
  if tasksWindow:getChildById("recommended"):isChecked() then
    return
  end
  itemsPanel:destroyChildren()

  local searchInput = tasksWindow:getChildById("searchInput")
  local searchText = searchInput:getText():lower()
  for i = 1, #tasks do
    if not tasks[i].finished then
      if id == 1 or tasks[i].zone_name == levels[id][1] then
        local panel = g_ui.createWidget("LootMonsterBox_classic", itemsPanel)
        panel:setId(tasks[i].raceName)
        panel:setText(tasks[i].raceName)
        local text = ""
        if tasks[i].completed then
          text = text .. "Completed"
        elseif tasks[i].active then
          text = text .. "Kills: " .. tasks[i].kills .. " / " .. tasks[i].killsRequired
        else
          text = text .. "Kills: " .. tasks[i].killsRequired
        end
        text = text .. "\nLevel: " .. tasks[i].level
        panel:getChildById("info"):setText(text)
        if type(tasks[i].outfit) == "table" then
          panel:getChildById("creature"):setOutfit(
            {
              type = tasks[i].outfit.id,
              head = tasks[i].outfit.head,
              body = tasks[i].outfit.body,
              legs = tasks[i].outfit.legs,
              feet = tasks[i].outfit.feet,
              addons = tasks[i].outfit.addons
            }
          )
        else
          panel:getChildById("creature"):setOutfit({type = tasks[i].outfit})
        end
        if searchText:len() >= 1 then
          if tasks[i].raceName:lower():find(searchText) then
            panel:show()
          else
            panel:hide()
          end
        end
      end
    end
  end
end

function accept()
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    protocolGame:sendExtendedOpcode(OPCODE, json.encode({action = "button", data = selected}))
  end
  hide()
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
  tasksWindow:getChildById("monstersTab"):setOn(true)
  tasksWindow:getChildById("allLootTab"):setOn(false)
  tasksWindow:getChildById("acceptButton"):hide()
  tasksWindow:getChildById("itemsPanelListScrollBar"):show()
  tasksWindow:getChildById("recommended"):show()
  tasksWindow:getChildById("searchLabel"):show()
  local searchInput = tasksWindow:getChildById("searchInput")
  searchInput:setText("")
  searchInput:show()
  itemsPanel:show()
  creaturePanel:hide()

  itemsPanel:destroyChildren()
  for i = 1, #tasks do
    if not tasks[i].finished then
      local panel = g_ui.createWidget("LootMonsterBox_classic", itemsPanel)
      panel:setId(tasks[i].raceName)
      panel:setText(tasks[i].raceName)
      local text = ""
      if tasks[i].completed then
        text = text .. "Completed"
      elseif tasks[i].active then
        text = text .. "Kills: " .. tasks[i].kills .. " / " .. tasks[i].killsRequired
      else
        text = text .. "Kills: " .. tasks[i].killsRequired
      end
      text = text .. "\nLevel: " .. tasks[i].level
      panel:getChildById("info"):setText(text)
      if type(tasks[i].outfit) == "table" then
        panel:getChildById("creature"):setOutfit(
          {
            type = tasks[i].outfit.id,
            head = tasks[i].outfit.head,
            body = tasks[i].outfit.body,
            legs = tasks[i].outfit.legs,
            feet = tasks[i].outfit.feet,
            addons = tasks[i].outfit.addons
          }
        )
      else
        panel:getChildById("creature"):setOutfit({type = tasks[i].outfit})
      end
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
  modules.game_interface.getRootPanel():focus()
end
