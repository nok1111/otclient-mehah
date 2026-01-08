--[[
═══════════════════════════════════════════════════════════════
    TASK BOARD V2 - DYNAMIC TASK SYSTEM
    Client module adapted to existing game_tasks structure
═══════════════════════════════════════════════════════════════
]]

local OPCODE = 92

local openTasksButton = nil
local tasksWindow = nil
local taskTrackerWindow = nil
local activeDialogs = {}  -- Track active message boxes

local availableTasks = {}
local activeTask = nil
local playerFame = 0
local fameLevel = 1
local fameExp = 0
local fameExpRequired = 100
local dailyBonusAvailable = false
local dailyBonusFame = 20
local rerollsUsed = 0
local locksUsed = 0
local rerollsAvailable = 0
local maxRerolls = 0
local locksAvailable = 0
local maxLocks = 0
local rerollGoldCost = 10000
local lockGoldCost = 5000
local isPremium = false

function init()
	connect(g_game,{
		onGameStart = create,
		onGameEnd = destroy
    })

	ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)
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
  
  if not openTasksButton then
    openTasksButton = modules.game_mainpanel.addStoreButton('openTasksButton', tr('Task Board'), '/images/options/task_large', toggleTasksPanel, false, 3)
    openTasksButton:setOn(false)
  end

  tasksWindow = g_ui.displayUI("tasks")
  tasksWindow:hide()
end

function toggleTasksPanel()
  if not tasksWindow then return end
  
  if tasksWindow:isVisible() then
    -- Destroy all active dialogs when closing
    for i, dialog in ipairs(activeDialogs) do
      if dialog and not dialog:isDestroyed() then
        dialog:destroy()
      end
    end
    activeDialogs = {}
    
    tasksWindow:hide()
    openTasksButton:setOn(false)
  else
    sendTaskBoardRequest("open")
    tasksWindow:show()
    tasksWindow:raise()
    tasksWindow:focus()
    openTasksButton:setOn(true)
  end
end

function destroy()
  -- Destroy all active dialogs
  for i, dialog in ipairs(activeDialogs) do
    if dialog and not dialog:isDestroyed() then
      dialog:destroy()
    end
  end
  activeDialogs = {}
  
  if tasksWindow then
    tasksWindow:destroy()
    tasksWindow = nil
  end
  
  if openTasksButton then
    openTasksButton:destroy()
    openTasksButton = nil
  end
  
  if taskTrackerWindow then
    taskTrackerWindow:destroy()
    taskTrackerWindow = nil
  end

  availableTasks = {}
  activeTask = nil
  playerFame = 0
  fameLevel = 1
  fameExp = 0
  fameExpRequired = 100
end

function onExtendedOpcode(protocol, code, buffer)
  local json_status, json_data = pcall(function()
    return json.decode(buffer)
  end)

  if not json_status then
    g_logger.error("[Task Board] JSON error: " .. json_data)
    return
  end

  local action = json_data.action
  local data = json_data.data

  if action == "init" then
    onTaskBoardInit(data)
  elseif action == "task_progress" then
    onTaskProgress(data)
  elseif action == "task_complete" then
    onTaskComplete(data)
  elseif action == "fame_update" then
    onFameUpdate(data)
  elseif action == "error" then
    onTaskBoardError(data)
  end
end

function sendTaskBoardRequest(action, data)
    local packet = {
        action = action,
        data = data or {}
    }
    
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        protocolGame:sendExtendedOpcode(OPCODE, json.encode(packet))
    end
end

function onTaskBoardInit(data)
    availableTasks = data.available_tasks or {}
    activeTask = data.active_task
    playerFame = data.player_fame or 0
    fameLevel = data.fame_level or 1
    fameExp = data.fame_exp or 0
    fameExpRequired = data.fame_exp_required or 100
    dailyBonusAvailable = data.daily_bonus_available or false
    dailyBonusFame = data.daily_bonus_fame or 20
    rerollsUsed = data.rerolls_used or 0
    locksUsed = data.locks_used or 0
    rerollsAvailable = data.rerolls_available or 0
    maxRerolls = data.max_rerolls or 0
    locksAvailable = data.locks_available or 0
    maxLocks = data.max_locks or 0
    rerollGoldCost = data.reroll_gold_cost or 10000
    lockGoldCost = data.lock_gold_cost or 5000
    isPremium = data.is_premium or false
    rerollsAvailable = data.rerolls_available or 0
    maxRerolls = data.max_rerolls or 5
    
    print("[Task Board] Init received:")
    print("  - Available tasks count: " .. table.size(availableTasks))
    print("  - Active task: " .. (activeTask and activeTask.name or "None"))
    if activeTask then
        print("    Active task slot: " .. (activeTask.slot or "NO SLOT"))
    end
    for slot, task in pairs(availableTasks) do
        print("  - Slot " .. slot .. ": " .. (task.name or "NO NAME"))
    end
    
    if tasksWindow and tasksWindow:isVisible() then
        refreshTaskBoard()
    end
end

function onTaskProgress(data)
    activeTask = data
    if tasksWindow and tasksWindow:isVisible() then
        refreshActiveTask()
    end
    updateTaskTracker()
end

function onTaskComplete(data)
    -- Hide task tracker when task completes
    if taskTrackerWindow then
        taskTrackerWindow:hide()
    end
    
    -- Uncheck the checkbox
    if tasksWindow then
        local checkbox = tasksWindow:recursiveGetChildById('trackQuestsCheckbox')
        if checkbox then
            checkbox:setChecked(false)
        end
    end
    
    local message = "Task Completed!\n\n"
    
    -- Mostrar solo los 2 rewards que vengan (sin repetir)
    if data.rewards.gold then
        message = message .. "Gold: " .. data.rewards.gold .. "\n"
    end
    
    if data.rewards.fame then
        message = message .. "Fame: " .. data.rewards.fame .. "\n"
    end
    
    if data.rewards.experience then
        message = message .. "Experience: " .. data.rewards.experience .. "\n"
    end
    
    -- Mostrar rolls como reward principal (no bonus)
    if data.rewards.bonus_rerolls and data.rewards.bonus_rerolls > 0 then
        message = message .. "Free Rerolls: +" .. data.rewards.bonus_rerolls .. "\n"
    end
    
    if data.rewards.bonus_locks and data.rewards.bonus_locks > 0 then
        message = message .. "Free Locks: +" .. data.rewards.bonus_locks .. "\n"
    end
    
    if data.daily_bonus_claimed then
        message = message .. "\nDaily Bonus: +" .. data.daily_bonus_amount .. " Fame!"
    end
    
    if data.fame_level_up then
        message = message .. "\n\nFame Level Up! New Level: " .. data.new_fame_level
    end
    
    local dialog = displayInfoBox("Task Complete", message)
    table.insert(activeDialogs, dialog)
    
    scheduleEvent(function()
        sendTaskBoardRequest("open")
    end, 1000)
end

function onFameUpdate(data)
    playerFame = data.fame
    if tasksWindow and tasksWindow:isVisible() then
        updateFameDisplay()
    end
end

function onTaskBoardError(data)
    local dialog = displayInfoBox("Task Board", data.message)
    table.insert(activeDialogs, dialog)
end

function refreshTaskBoard()
    if not tasksWindow then return end
    
    updateFameDisplay()
    refreshAvailableTasks()
    refreshActiveTask()
    updateDailyBonus()
    updateActionButtons()
    updateRerollsDisplay()
    updatePremiumDisplay()
end

function updateFameDisplay()
    local headerPanel = tasksWindow:recursiveGetChildById('headerPanel')
    if not headerPanel then return end
    
    local fameLabel = headerPanel:recursiveGetChildById('fameLabel')
    if fameLabel then
        fameLabel:setText('Fame: ' .. formatNumber(playerFame))
    end
    
    local fameLevelLabel = headerPanel:recursiveGetChildById('fameLevelLabel')
    if fameLevelLabel then
        fameLevelLabel:setText('Level ' .. fameLevel .. ' (' .. fameExp .. '/' .. fameExpRequired .. ')')
    end
end

function refreshAvailableTasks()
    local taskCardsContainer = tasksWindow:recursiveGetChildById('taskCardsContainer')
    if not taskCardsContainer then return end
    
    taskCardsContainer:destroyChildren()
    
    -- Debug: printear info de todas las tasks disponibles
    print("[Tasks Client] Refreshing available tasks:")
    print("  Total tasks in availableTasks table: " .. table.size(availableTasks))
    
    for slot = 1, 3 do
        local task = availableTasks[tostring(slot)]
        if task then
            -- Debug print detallado
            print(string.format("[Tasks Client] Slot %d: tier=%s, level_range=%s, zone=%s",
                slot, task.tier or "?", task.level_range or "?", task.zone_name or "?"))
            if task.monsters then
                print(string.format("  Monsters: %d total", #task.monsters))
                for _, m in ipairs(task.monsters) do
                    print(string.format("    - %s: %d kills", m.name, m.kills))
                end
            end
            if task.main_creature then
                print(string.format("  Main creature outfit_id: %d", task.main_creature.outfit_id))
            end
            
            local taskCard = createTaskCard(task, slot)
            if taskCard then
                taskCardsContainer:addChild(taskCard)
            end
        else
            print(string.format("[Tasks Client] Slot %d: NO TASK FOUND", slot))
        end
    end
end

function createTaskCard(task, slot)
    local taskCard = g_ui.createWidget('TaskCard')
    if not taskCard then return nil end
    taskCard:setId('taskCard' .. slot)
    
    -- Create invisible panel for particle effect overlay
    local effectPanel = g_ui.createWidget('Panel', taskCard)
    effectPanel:setId('effectPanel')
    effectPanel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
    effectPanel:addAnchor(AnchorRight, 'parent', AnchorRight)
    effectPanel:addAnchor(AnchorTop, 'parent', AnchorTop)
    effectPanel:addAnchor(AnchorBottom, 'parent', AnchorBottom)
    effectPanel:setPhantom(true)
    effectPanel:setVisible(true)
    
    -- Check if this card is the active task
    local isActiveTask = activeTask and activeTask.slot == slot
    
    print("[Task Board] Creating card for slot " .. slot .. " - Task: " .. task.name)
    print("  - Active task: " .. (activeTask and activeTask.name or "None"))
    print("  - Active task slot: " .. (activeTask and tostring(activeTask.slot) or "None"))
    print("  - isActiveTask: " .. tostring(isActiveTask))
    
    -- Set tier-specific card window background
    local cardWindowImages = {
        normal = '/images/ui/windows/normal',
        rare = '/images/ui/windows/rare',
        epic = '/images/ui/windows/epic',
        legendary = '/images/ui/windows/legendary'
    }
    taskCard:setImageSource(cardWindowImages[task.tier] or '/images/ui/panel_flat')
    taskCard:setImageSize({width = 210, height = 370})
    taskCard:setImageBorder(5)
    
    -- Tier Badge
    local tierBadge = taskCard:recursiveGetChildById('tierBadge')
    if tierBadge then
        tierBadge:setText(task.tier:upper())
        local tierColors = {
            normal = '#888888',
            rare = '#0070DD',
            epic = '#A335EE',
            legendary = '#FF8000'
        }
        tierBadge:setColor(tierColors[task.tier] or '#ffffff')
    end
    
    -- Task Name
    local taskName = taskCard:recursiveGetChildById('taskName')
    if taskName then
        taskName:setText(task.name)
    end
    
   
    
    -- Limpiar creatures previas
    local headerImagePanel = taskCard:recursiveGetChildById('headerImagePanel')
    if headerImagePanel then
        -- Remover creatures viejas si existen
        local oldCreatures = headerImagePanel:getChildren()
        for _, child in ipairs(oldCreatures) do
            if child:getId():find('creature') then
                child:destroy()
            end
        end
    end
    
    -- Crear y posicionar creatures según cantidad (1-3)
    if task.outfits and #task.outfits > 0 and headerImagePanel then
        print("[CLIENT DEBUG] task.outfits count: " .. #task.outfits)
        for i, outfit in ipairs(task.outfits) do
            print(string.format("[CLIENT DEBUG] outfit[%d]: type=%s, name=%s, level=%s", 
                i, 
                tostring(outfit.type), 
                tostring(outfit.name), 
                tostring(outfit.level)))
        end
        local outfitCount = #task.outfits
        
        if outfitCount == 1 then
            -- 1 creature: centrada
            local creature = g_ui.createWidget('Creature', headerImagePanel)
            creature:setId('creature1')
            creature:setImageSource('/images/ui/windows/transparent')
            creature:setOutfit(task.outfits[1])
            creature:centerIn('parent')
            creature:setMarginTop(0)
            -- Tooltip
            if task.outfits[1].name then
                local tooltipText = task.outfits[1].name
                if task.outfits[1].level then
                    tooltipText = tooltipText
                end
                creature:setTooltip(tooltipText)
            end
            
        elseif outfitCount == 2 then
            -- 2 creatures: pareja (izquierda y derecha del primero)
            local creature1 = g_ui.createWidget('Creature', headerImagePanel)
            creature1:setId('creature1')
            creature1:setImageSource('/images/ui/windows/transparent')
            creature1:setOutfit(task.outfits[1])
            creature1:centerIn('parent')
            creature1:setMarginLeft(-25)
            creature1:setMarginTop(0)
            -- Tooltip
            if task.outfits[1].name then
                local tooltipText = task.outfits[1].name
                if task.outfits[1].level then
                    tooltipText = tooltipText
                end
                creature1:setTooltip(tooltipText)
            end
            
            local creature2 = g_ui.createWidget('Creature', headerImagePanel)
            creature2:setId('creature2')
            creature2:setImageSource('/images/ui/windows/transparent')
            creature2:setOutfit(task.outfits[2])
            creature2:centerIn('parent')
            creature2:setMarginLeft(25)
            creature2:setMarginTop(0)
            -- Tooltip
            if task.outfits[2].name then
                local tooltipText = task.outfits[2].name
                if task.outfits[2].level then
                    tooltipText = tooltipText
                end
                creature2:setTooltip(tooltipText)
            end
            
        elseif outfitCount >= 3 then
            -- 3 creatures: trio (izquierda, centro, derecha)
            local creature2 = g_ui.createWidget('Creature', headerImagePanel)
            creature2:setId('creature2')
            creature2:setImageSource('/images/ui/windows/transparent')
            creature2:setOutfit(task.outfits[2])
            creature2:centerIn('parent')
            creature2:setMarginLeft(-40)
            creature2:setMarginTop(0)
            -- Tooltip

            
            if task.outfits[2].name then
                local tooltipText = task.outfits[2].name
                if task.outfits[2].level then
                    tooltipText = tooltipText
                end
                creature2:setTooltip(tooltipText)
                print("------Tooltip para creature2: " .. tooltipText)
            else
                print("------No se encontró nombre para creature2")
            end

            local creature1 = g_ui.createWidget('Creature', headerImagePanel)
            creature1:setId('creature1')
            creature1:setImageSource('/images/ui/windows/transparent')
            creature1:setOutfit(task.outfits[1])
            creature1:centerIn('parent')
            creature1:setMarginTop(0)
            -- Tooltip
            if task.outfits[1].name then
                local tooltipText = task.outfits[1].name
                if task.outfits[1].level then
                    tooltipText = tooltipText
                end
                creature1:setTooltip(tooltipText)
            end
            
            local creature3 = g_ui.createWidget('Creature', headerImagePanel)
            creature3:setId('creature3')
            creature3:setImageSource('/images/ui/windows/transparent')
            creature3:setOutfit(task.outfits[3])
            creature3:centerIn('parent')
            creature3:setMarginLeft(40)
            creature3:setMarginTop(0)
            -- Tooltip
            if task.outfits[3].name then
                local tooltipText = task.outfits[3].name
                if task.outfits[3].level then
                    tooltipText = tooltipText
                end
                creature3:setTooltip(tooltipText)
            end

            
        end
    end
    
    -- Mostrar solo total de kills (sin nombres de monsters)
    local killsLabel = taskCard:recursiveGetChildById('killsLabel')
    if killsLabel then
        killsLabel:setText('Kills: ' .. task.total_kills)
    end
    
    -- Level range label
    local zoneLabel = taskCard:recursiveGetChildById('zoneLabel')
    if zoneLabel then
        zoneLabel:setText('Level: ' .. task.level_range)
    end
    
    -- Zone name label (restaurado)
    local zoneNameLabel = taskCard:recursiveGetChildById('zoneNameLabel')
    if zoneNameLabel and task.zone_name then
        zoneNameLabel:setText(task.zone_name)
    end
    
    -- Modifiers with Icons
    local modifiersList = taskCard:recursiveGetChildById('modifiersList')
    if modifiersList then
        modifiersList:destroyChildren()
        for _, modifier in ipairs(task.modifiers) do
            local modPanel = g_ui.createWidget('Panel', modifiersList)
            modPanel:setHeight(28)
            
            -- Modifier Icon
            local modIcon = g_ui.createWidget('UIWidget', modPanel)
            modIcon:setId('modIcon')
            modIcon:setSize({width = 16, height = 16})
            modIcon:addAnchor(AnchorLeft, 'parent', AnchorLeft)
            modIcon:addAnchor(AnchorTop, 'parent', AnchorTop)
            modIcon:setMarginLeft(20)
            modIcon:setMarginTop(6)
            
            local modIconPath = '/images/icons/' .. (modifier.icon or 'modifier_positive')
            modIcon:setImageSource(modIconPath)
            
            -- Modifier Text
            local modLabel = g_ui.createWidget('Label', modPanel)
            modLabel:addAnchor(AnchorLeft, 'modIcon', AnchorRight)
            modLabel:addAnchor(AnchorTop, 'parent', AnchorTop)
            modLabel:addAnchor(AnchorRight, 'parent', AnchorRight)
            modLabel:setMarginTop(8)
            modLabel:setMarginLeft(5)
            modLabel:setMarginRight(5)
            modLabel:setHeight(28)
            
            local modColor = modifier.type == 'positive' and '#00ff00' or (modifier.type == 'negative' and '#ff0000' or '#ffaa00')
            modLabel:setText(modifier.description)
            modLabel:setColor(modColor)
            modLabel:setTextWrap(true)
            modLabel:setTooltip(modifier.name)
        end
    end
    
    -- Sistema de 2 rewards dinámicos
    local rewardTypes = {}
    
    if task.rewards.gold then
        table.insert(rewardTypes, {
            icon = '/images/icons/gold-bars',
            text = formatNumber(task.rewards.gold),
            color = '#FFD700'
        })
    end
    
    if task.rewards.fame then
        table.insert(rewardTypes, {
            icon = '/images/icons/fame',
            text = tostring(task.rewards.fame),
            color = '#ff9100ff'
        })
    end
    
    if task.rewards.experience then
        table.insert(rewardTypes, {
            icon = '/images/icons/experience',
            text = formatNumber(task.rewards.experience),
            color = '#00BFFF'
        })
    end
    
    if task.rewards.bonus_rerolls and task.rewards.bonus_rerolls > 0 then
        table.insert(rewardTypes, {
            icon = '/images/icons/reroll',
            text = '+' .. task.rewards.bonus_rerolls,
            color = '#00FF00'
        })
    end
    
    if task.rewards.bonus_locks and task.rewards.bonus_locks > 0 then
        table.insert(rewardTypes, {
            icon = '/images/icons/lock',
            text = '+' .. task.rewards.bonus_locks,
            color = '#FFD700'
        })
    end
    
    -- Mostrar los 2 primeros rewards (siempre habrá exactamente 2)
    local reward1Panel = taskCard:recursiveGetChildById('reward1Panel')
    if reward1Panel and rewardTypes[1] then
        local icon = reward1Panel:recursiveGetChildById('reward1Icon')
        local label = reward1Panel:recursiveGetChildById('reward1Label')
        
        if icon then icon:setImageSource(rewardTypes[1].icon) end
        if label then
            label:setText(rewardTypes[1].text)
            label:setColor(rewardTypes[1].color)
        end
        reward1Panel:setVisible(true)
    else
        if reward1Panel then reward1Panel:setVisible(false) end
    end
    
    local reward2Panel = taskCard:recursiveGetChildById('reward2Panel')
    if reward2Panel and rewardTypes[2] then
        local icon = reward2Panel:recursiveGetChildById('reward2Icon')
        local label = reward2Panel:recursiveGetChildById('reward2Label')
        
        if icon then icon:setImageSource(rewardTypes[2].icon) end
        if label then
            label:setText(rewardTypes[2].text)
            label:setColor(rewardTypes[2].color)
        end
        reward2Panel:setVisible(true)
    else
        if reward2Panel then reward2Panel:setVisible(false) end
    end
    
    local lockButton = taskCard:recursiveGetChildById('lockButton')
    if lockButton then
        -- Disable lock button if there's an active task
        if activeTask then
            lockButton:setEnabled(false)
            lockButton:setOpacity(0.5)
            lockButton:setText('LOCKED')
            lockButton:setImageColor('#888888')
        else
            lockButton:setEnabled(true)
            lockButton:setOpacity(1.0)
            if task.locked then
                lockButton:setText('UNLOCK')
                lockButton:setImageColor('#00BFFF')  -- Blue color for unlock
            else
                lockButton:setText('LOCK')
                lockButton:setImageColor('#ffffff')
            end
            lockButton.onClick = function() onLockClick(slot, not task.locked) end
        end
    end
    
    -- Visual effects for active/inactive cards
    if isActiveTask then
        -- ACTIVE TASK - Add glowing border overlay
        local selectedOverlay = g_ui.createWidget('UIWidget', taskCard)
        selectedOverlay:setId('selectedOverlay')
        selectedOverlay:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
        selectedOverlay:addAnchor(AnchorVerticalCenter, 'parent', AnchorVerticalCenter)
       -- selectedOverlay:setSize({width = 210, height = 370})
        selectedOverlay:setImageSource('/images/ui/windows/card_selected')
        selectedOverlay:setPhantom(true)  -- Don't block clicks
        selectedOverlay:setOpacity(1)
        selectedOverlay:setMarginBottom(5)

        

    elseif activeTask then
        -- INACTIVE CARD (another task is active) - Dim it
        taskCard:setOpacity(0.35)  -- Reduced opacity
        
        -- Add dark overlay
        local overlay = g_ui.createWidget('Panel', taskCard)
        overlay:setId('inactiveOverlay')
        overlay:addAnchor(AnchorFill, 'parent', AnchorFill)
        overlay:setBackgroundColor('#000000')
        overlay:setOpacity(0.4)
        overlay:setPhantom(true)  -- Don't block clicks
    else
        -- NO ACTIVE TASK - Normal display
        taskCard:setOpacity(1.0)
    end
    
    local startButton = taskCard:recursiveGetChildById('startButton')
    if startButton then
        if isActiveTask then
            -- This is the active task - check if complete
            local isTaskComplete = true
            if task.monsters then
                for _, monster in ipairs(task.monsters) do
                    local current = monster.current or 0
                    if current < monster.kills then
                        isTaskComplete = false
                        break
                    end
                end
            end
            
            if isTaskComplete then
                -- Task is complete - show Complete button
                startButton:setText('Complete')
                startButton:setImageColor('#00ff00')
                startButton.onClick = function() onCompleteClick() end
            else
                -- Task not complete - show Abandon button
                startButton:setText('Abandon')
                startButton:setImageColor('#ff0000')
                startButton.onClick = function() onAbandonClick() end
            end
        else
            -- Not active - show Start button
            startButton:setText('Start')
            startButton:setImageColor('#00ff00')
            if activeTask then
                -- Another task is active, disable this one
                startButton:setEnabled(false)
                startButton:setOpacity(0.5)
            elseif task.locked then
                -- Task is locked, disable start button
                startButton:setEnabled(false)
                startButton:setOpacity(0.5)
            else
                startButton:setEnabled(true)
                startButton:setOpacity(1.0)
            end
            startButton.onClick = function() onStartClick(slot) end
        end
    end
    
    if task.locked then
        local lockedOverlay = taskCard:recursiveGetChildById('lockedOverlay')
        if lockedOverlay then
            lockedOverlay:setVisible(true)
        end
    end
    
    return taskCard
end

function refreshActiveTask()
    local activeTaskPanel = tasksWindow:recursiveGetChildById('activeTaskPanel')
    if not activeTaskPanel then return end
    
    local activeTaskStatus = activeTaskPanel:recursiveGetChildById('activeTaskStatus')
    local progressContainer = activeTaskPanel:recursiveGetChildById('progressContainer')
    local completeButton = activeTaskPanel:recursiveGetChildById('completeButton')
    
    if not activeTask then
        if activeTaskStatus then 
            activeTaskStatus:setText('No active task')
            activeTaskStatus:setColor('#888888')
        end
        if progressContainer then progressContainer:destroyChildren() end
        if completeButton then
            completeButton:setVisible(false)
        end
        return
    end
    
    if activeTaskStatus then 
        activeTaskStatus:setText(activeTask.name)
        activeTaskStatus:setColor('#00BFFF')
    end
    
    -- Check if task is complete
    local isComplete = true
    local totalProgress = 0
    local totalRequired = 0
    
    if activeTask.monsters then
        for _, monster in ipairs(activeTask.monsters) do
            local current = monster.current or 0
            totalProgress = totalProgress + current
            totalRequired = totalRequired + monster.kills
            if current < monster.kills then
                isComplete = false
            end
        end
    end
    
    -- Show complete button only when task is finished
    if completeButton then
        completeButton:setVisible(isComplete)
        completeButton:setEnabled(true)
        if isComplete then
            completeButton:setImageColor('#00ff00')
        end
    end
    
    if progressContainer then
        progressContainer:destroyChildren()
        
        for _, monster in ipairs(activeTask.monsters) do
            local progressWidget = g_ui.createWidget('Panel', progressContainer)
            progressWidget:setHeight(28)
            
            local monsterLabel = g_ui.createWidget('Label', progressWidget)
            monsterLabel:setText(monster.name .. ': ' .. (monster.current or 0) .. ' / ' .. monster.kills)
            monsterLabel:setTextAlign(AlignLeft)
            monsterLabel:setFont('verdana-11px-rounded')
            monsterLabel:addAnchor(AnchorTop, 'parent', AnchorTop)
            monsterLabel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
            monsterLabel:addAnchor(AnchorRight, 'parent', AnchorRight)
            monsterLabel:setMarginTop(2)
            monsterLabel:setMarginLeft(5)
            
            local progressBar = g_ui.createWidget('ProgressBar', progressWidget)
            progressBar:setValue(monster.current or 0, 0, monster.kills)
            progressBar:setHeight(10)
            progressBar:addAnchor(AnchorTop, 'parent', AnchorTop)
            progressBar:addAnchor(AnchorLeft, 'parent', AnchorLeft)
            progressBar:addAnchor(AnchorRight, 'parent', AnchorRight)
            progressBar:setMarginTop(18)
            progressBar:setMarginLeft(5)
            progressBar:setMarginRight(5)
            progressBar:setBackgroundColor('#00ff00')
        end
    end
end

function updateDailyBonus()
    local dailyBonusLabel = tasksWindow:recursiveGetChildById('dailyBonusLabel')
    if dailyBonusLabel then
        if dailyBonusAvailable then
            dailyBonusLabel:setText('Daily Bonus: +' .. dailyBonusFame .. ' Fame (Available)')
            dailyBonusLabel:setColor('#00ff00')
        else
            dailyBonusLabel:setText('Daily Bonus: Already Claimed')
            dailyBonusLabel:setColor('#888888')
        end
    end
end

function updateRerollsDisplay()
    if not tasksWindow then return end
    
    local rerollsAvailableLabel = tasksWindow:recursiveGetChildById('rerollsAvailableLabel')
    if rerollsAvailableLabel then
        local displayText = 'Free Rerolls: ' .. rerollsAvailable .. '/' .. maxRerolls
        rerollsAvailableLabel:setText(displayText)
        
        if rerollsAvailable > 0 then
            rerollsAvailableLabel:setColor('#00ff00')
        else
            rerollsAvailableLabel:setColor('#ff0000')
        end
    end
end

function updatePremiumDisplay()
    if not tasksWindow then return end
    
    local premiumLabel = tasksWindow:recursiveGetChildById('premiumLabel')
    if premiumLabel then
        local lockText = locksAvailable == 1 and 'lock' or 'locks'
        local displayText = 'Premium: ' .. locksAvailable .. ' free ' .. lockText
        premiumLabel:setText(displayText)
        
        if isPremium then
            premiumLabel:setColor('#FFD700')
        else
            premiumLabel:setColor('#888888')
        end
    end
end

function updateActionButtons()
    local rerollButton = tasksWindow:recursiveGetChildById('rerollButton')
    local rerollCostAmount = tasksWindow:recursiveGetChildById('rerollCostAmount')
    local fameCostIcon = tasksWindow:recursiveGetChildById('fameCostIcon')
    
    if rerollButton and rerollCostAmount then
        -- Disable reroll if there's an active task
        if activeTask then
            rerollButton:setEnabled(false)
            rerollCostAmount:setText('None')
            rerollCostAmount:setColor('#ff0000')
            if fameCostIcon then
                fameCostIcon:hide()
            end
        elseif rerollsAvailable > 0 then
            rerollCostAmount:setText('0')
            rerollCostAmount:setColor('#00ff00')
            if fameCostIcon then
                fameCostIcon:show()
                fameCostIcon:setImageSource('/images/icons/gold-bars')
            end
            rerollButton:setEnabled(true)
        else
            rerollCostAmount:setText(formatNumber(rerollGoldCost))
            rerollCostAmount:setColor('#FFD700')
            if fameCostIcon then
                fameCostIcon:show()
                fameCostIcon:setImageSource('/images/icons/gold-bars')
            end
            rerollButton:setEnabled(true)
        end
    end
end

function onRerollClick()
    if activeTask then
        local dialog = displayInfoBox('Task Board', 'You must abandon your active task before rerolling.')
        table.insert(activeDialogs, dialog)
        return
    end
    
    if rerollsAvailable > 0 then
        sendTaskBoardRequest('reroll', {use_free = true})
    else
        local confirmMessage = 'Reroll all tasks for ' .. formatNumber(rerollGoldCost) .. ' gold?'
        local dialog
        dialog = displayGeneralBox('Reroll Tasks', confirmMessage, {
            {text = 'Yes', callback = function()
                sendTaskBoardRequest('reroll', {use_free = false})
                dialog:destroy()
            end},
            {text = 'No', callback = function()
                dialog:destroy()
            end}
        }, function() end)
        table.insert(activeDialogs, dialog)
    end
end

function onRerollPremiumClick()
    if not isPremium then
        local dialog = displayInfoBox('Task Board', 'Premium account required')
        table.insert(activeDialogs, dialog)
        return
    end
    
    if rerollsUsed >= 1 then
        local dialog = displayInfoBox('Task Board', 'Premium reroll already used today')
        table.insert(activeDialogs, dialog)
        return
    end
    
    sendTaskBoardRequest('reroll', {use_premium = true})
end

function onLockClick(slot, lockState)
    if lockState then
        if locksAvailable <= 0 then
            local dialog = displayInfoBox('Task Board', 'No locks available. You have used ' .. locksUsed .. '/' .. maxLocks .. ' locks today.')
            table.insert(activeDialogs, dialog)
            return
        end
        
        local confirmMessage = 'Lock this task for ' .. formatNumber(lockGoldCost) .. ' gold?\n\nLocked tasks will not be replaced when rerolling.\n\nLocks used: ' .. locksUsed .. '/' .. maxLocks
        
        local dialog
        dialog = displayGeneralBox('Lock Task', confirmMessage, {
            {text = 'Yes', callback = function()
                sendTaskBoardRequest('lock', {slot = slot, lock_state = true})
                dialog:destroy()
            end},
            {text = 'No', callback = function()
                dialog:destroy()
            end}
        }, function() end)
        table.insert(activeDialogs, dialog)
    else
        sendTaskBoardRequest('lock', {slot = slot, lock_state = false})
    end
end

function onStartClick(slot)
    if activeTask then
        local dialog = displayInfoBox('Task Board', 'You already have an active task')
        table.insert(activeDialogs, dialog)
        return
    end
    
    sendTaskBoardRequest('start', {slot = slot})
end

function onAbandonClick()
    if not activeTask then
        return
    end
    
    local dialog
    dialog = displayGeneralBox(
        'Abandon Task',
        'Are you sure you want to abandon this task?\n\nProgress will be reset and the card will become available again.',
        {
            {text = 'Yes', callback = function()
                sendTaskBoardRequest('abandon')
                dialog:destroy()
            end},
            {text = 'No', callback = function()
                dialog:destroy()
            end}
        },
        function() end
    )
    table.insert(activeDialogs, dialog)
end

function onCompleteClick()
    if not activeTask then
        return
    end
    
    sendTaskBoardRequest('complete')
end

function onTrackQuestsToggle(checked)
    if checked then
        -- Create tracker window on first use
        if not taskTrackerWindow then
            taskTrackerWindow = g_ui.loadUI('task_tracker', modules.game_interface.getMapPanel())
            if not taskTrackerWindow then
                print("[Task Board] Failed to create task tracker window")
                local checkbox = tasksWindow:recursiveGetChildById('trackQuestsCheckbox')
                if checkbox then
                    checkbox:setChecked(false)
                end
                return
            end
        end
        
        if activeTask then
            updateTaskTracker()
            taskTrackerWindow:show()
        else
            local dialog = displayInfoBox('Task Board', 'No active task to track')
            table.insert(activeDialogs, dialog)
            -- Uncheck the checkbox
            local checkbox = tasksWindow:recursiveGetChildById('trackQuestsCheckbox')
            if checkbox then
                checkbox:setChecked(false)
            end
        end
    else
        if taskTrackerWindow then
            taskTrackerWindow:hide()
        end
    end
end

function updateTaskTracker()
    if not taskTrackerWindow or not taskTrackerWindow:isVisible() then
        return
    end
    
    if not activeTask then
        taskTrackerWindow:hide()
        if tasksWindow then
            local checkbox = tasksWindow:recursiveGetChildById('trackQuestsCheckbox')
            if checkbox then
                checkbox:setChecked(false)
            end
        end
        return
    end
    
    -- Update task name
    local taskNameLabel = taskTrackerWindow:getChildById('taskNameLabel')
    if taskNameLabel then
        taskNameLabel:setText(activeTask.name or 'Task')
    end
    
    -- Update monster progress
    local progressContainer = taskTrackerWindow:getChildById('progressContainer')
    if progressContainer then
        progressContainer:destroyChildren()
        
        if activeTask.monsters then
            for _, monster in ipairs(activeTask.monsters) do
                local current = monster.current or 0
                local total = monster.kills
                local isComplete = current >= total
                
                -- Container panel for each monster
                local monsterPanel = g_ui.createWidget('Panel', progressContainer)
                monsterPanel:setHeight(40)
                
                -- Monster creature icon
                if monster.outfit then
                    local creature = g_ui.createWidget('Creature', monsterPanel)
                    creature:setImageSource('/images/ui/windows/transparent')
                    creature:setOutfit(monster.outfit)
                    creature:setSize({width = 32, height = 32})
                    creature:addAnchor(AnchorLeft, 'parent', AnchorLeft)
                    creature:addAnchor(AnchorTop, 'parent', AnchorTop)
                    creature:setMarginLeft(5)
                    creature:setMarginTop(4)
                    if monster.name then
                        creature:setTooltip(monster.name)
                    end
                end
                
                -- Monster label and progress container
                local infoPanel = g_ui.createWidget('Panel', monsterPanel)
                infoPanel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
                infoPanel:addAnchor(AnchorTop, 'parent', AnchorTop)
                infoPanel:addAnchor(AnchorRight, 'parent', AnchorRight)
                infoPanel:setMarginLeft(42)
                infoPanel:setMarginTop(2)
                infoPanel:setHeight(36)
                
                -- Monster label
                local monsterLabel = g_ui.createWidget('Label', infoPanel)
                monsterLabel:setText(monster.name .. ': ' .. current .. ' / ' .. total)
                monsterLabel:setFont('verdana-11px-rounded')
                monsterLabel:setColor(isComplete and '#00ff00' or '#ffffff')
                monsterLabel:setHeight(16)
                monsterLabel:addAnchor(AnchorTop, 'parent', AnchorTop)
                monsterLabel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
                monsterLabel:addAnchor(AnchorRight, 'parent', AnchorRight)
                
                -- Progress bar
                local progressBar = g_ui.createWidget('ProgressBar', infoPanel)
                progressBar:setHeight(12)
                progressBar:setPercent(total > 0 and (current / total * 100) or 0)
                progressBar:addAnchor(AnchorTop, 'prev', AnchorBottom)
                progressBar:addAnchor(AnchorLeft, 'parent', AnchorLeft)
                progressBar:addAnchor(AnchorRight, 'parent', AnchorRight)
                progressBar:setMarginTop(4)
                if isComplete then
                    progressBar:setBackgroundColor('#00ff00')
                end
            end
        end
    end
end

function formatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

print("[Task Board V2] Loaded successfully")
