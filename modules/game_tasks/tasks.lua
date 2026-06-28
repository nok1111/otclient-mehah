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
  translateUI(tasksWindow)
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

    -- Copy outfits from availableTasks to activeTask (server doesn't send them in active_task)

    
    if activeTask and (not activeTask.outfits or #activeTask.outfits == 0) then
        -- Fallback: derive outfits from the matching available task slot
        local foundTask = availableTasks[tostring(activeTask.slot)]
        if foundTask and foundTask.outfits then
            activeTask.outfits = foundTask.outfits
        end
    end

    
    if tasksWindow and tasksWindow:isVisible() then
        refreshTaskBoard()
    end
    
    -- Auto-show tracker if has active task
    if activeTask then
        if not taskTrackerWindow then
            taskTrackerWindow = g_ui.loadUI('task_tracker', modules.game_interface.getMapPanel())
            translateUI(taskTrackerWindow)
        end
        if taskTrackerWindow then
            updateTaskTracker()
            taskTrackerWindow:show()
        end
    end
end

function onTaskProgress(data)
    -- Fallback: preserve previously known outfits if the server omitted them
    if (not data.outfits or #data.outfits == 0) and activeTask and activeTask.outfits then
        data.outfits = activeTask.outfits
    end
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
    
    if data.rewards.codex_essences and data.rewards.codex_essences > 0 then
        message = message .. "Codex Essences: +" .. data.rewards.codex_essences .. "\n"
    end
    
    if data.rewards.codex_crate_type and data.rewards.codex_crate_type > 0 then
        local crateNames = {[1] = "Bronze Crate", [2] = "Silver Crate", [3] = "Golden Crate"}
        local crateName = crateNames[data.rewards.codex_crate_type] or "Crate"
        local crateAmount = data.rewards.codex_crate_amount or 1
        message = message .. crateName .. ": x" .. crateAmount .. "\n"
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
        fameLabel:setText(tr('Fame: %s', formatNumber(playerFame)))
    end
    
    local fameLevelLabel = headerPanel:recursiveGetChildById('fameLevelLabel')
    if fameLevelLabel then
        fameLevelLabel:setText(tr('Level %s (%s/%s)', fameLevel, fameExp, fameExpRequired))
    end
end

function refreshAvailableTasks()
    local taskCardsContainer = tasksWindow:recursiveGetChildById('taskCardsContainer')
    if not taskCardsContainer then return end
    
    taskCardsContainer:destroyChildren()
    
    for slot = 1, 3 do
        local task = availableTasks[tostring(slot)]
        if task then
            local taskCard = createTaskCard(task, slot)
            if taskCard then
                taskCardsContainer:addChild(taskCard)
            end
        end
    end
end

function createTaskCard(task, slot)
    local taskCard = g_ui.createWidget('TaskCard')
    if not taskCard then return nil end
    translateUI(taskCard)
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
    
    -- Tier Badge (overridden by category="dungeon" so the player spots it instantly)
    local tierBadge = taskCard:recursiveGetChildById('tierBadge')
    if tierBadge then
        if task.category == 'dungeon' then
            -- Short label so it fits the badge slot next to the title.
            tierBadge:setText(task.is_boss and tr('BOSS') or tr('DUNGEON'))
            tierBadge:setColor('#FF3030')
        else
            tierBadge:setText(tr(task.tier:upper()))
            local tierColors = {
                normal = '#888888',
                rare = '#0070DD',
                epic = '#A335EE',
                legendary = '#FF8000'
            }
            tierBadge:setColor(tierColors[task.tier] or '#ffffff')
        end
    end

    -- Task Name
    local taskName = taskCard:recursiveGetChildById('taskName')
    if taskName then
        taskName:setText(tr(task.name))
        if task.category == 'dungeon' then
            taskName:setColor('#FF6464')
        else
            taskName:setColor('#ffffff')
        end
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
        -- marginLeft offsets per total outfit count (1, 2 or 3 creatures)
        -- offsetsByCount[count][outfitIndex] = horizontal offset
        local offsetsByCount = {
            [1] = { 0 },
            [2] = { -25, 25 },
            [3] = { 0, -40, 40 }  -- outfit[1]=center, outfit[2]=left, outfit[3]=right
        }
        -- drawOrderByCount[count] = list of outfit indices in render order
        -- (earlier = farther back). Z-order wanted: left BEHIND, then center,
        -- then right on top. So we paint outfit[2] first, outfit[1] next,
        -- and outfit[3] last.
        local drawOrderByCount = {
            [1] = { 1 },
            [2] = { 1, 2 },
            [3] = { 2, 1, 3 }
        }
        local count = math.min(#task.outfits, 3)
        local offsets = offsetsByCount[count]
        local drawOrder = drawOrderByCount[count]

        for _, i in ipairs(drawOrder) do
            local outfit = task.outfits[i]
            local creature = g_ui.createWidget('Creature', headerImagePanel)
            creature:setId('creature' .. i)
            creature:setImageSource('/images/ui/windows/transparent')
            creature:setOutfit(outfit)
            creature:centerIn('parent')
            creature:setMarginLeft(offsets[i] or 0)
            creature:setMarginTop(0)
            if outfit.name then
                creature:setTooltip(tr(outfit.name))
            end
        end
    end
    
    -- Mostrar solo total de kills (sin nombres de monsters)
    local killsLabel = taskCard:recursiveGetChildById('killsLabel')
    if killsLabel then
        killsLabel:setText(tr('Kills: %s', task.total_kills))
    end
    
    -- Level range label
    local zoneLabel = taskCard:recursiveGetChildById('zoneLabel')
    if zoneLabel then
        zoneLabel:setText(tr('Level: %s', task.level_range))
    end
    
    -- Zone name label (restaurado)
    local zoneNameLabel = taskCard:recursiveGetChildById('zoneNameLabel')
    if zoneNameLabel and task.zone_name then
        zoneNameLabel:setText(tr(task.zone_name))
        if task.category == 'dungeon' then
            zoneNameLabel:setColor('#FFB060')
        else
            zoneNameLabel:setColor('#cccccc')
        end
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
            local modDesc = modifier.description
            if modDesc:find('%s', 1, true) then
                modLabel:setText(tr(modDesc, modifier.value))
            else
                modLabel:setText(tr(modDesc))
            end
            modLabel:setColor(modColor)
            modLabel:setTextWrap(true)
            modLabel:setTooltip(tr(modifier.name))
        end
    end
    
    -- Reward icons: Codex (rare/bonus) goes first so it never gets hidden by the 2-slot UI cap.
    local rewardTypes = {}

    if task.rewards.codex_crate_type and task.rewards.codex_crate_type > 0 then
        local crateIcons = {
            [1] = '/images/icons/bronce_crate',
            [2] = '/images/icons/silver_crate',
            [3] = '/images/icons/golden_crate'
        }
        local crateColors = {
            [1] = '#a75401a2',
            [2] = '#13b5caff',
            [3] = '#FFD700'
        }
        table.insert(rewardTypes, {
            icon = crateIcons[task.rewards.codex_crate_type] or crateIcons[1],
            text = 'x' .. (task.rewards.codex_crate_amount or 1),
            color = crateColors[task.rewards.codex_crate_type] or '#FFFFFF'
        })
    end

    if task.rewards.codex_essences and task.rewards.codex_essences > 0 then
        table.insert(rewardTypes, {
            icon = '/images/codex/essence_icon',
            text = tostring(task.rewards.codex_essences),
            color = '#A020F0'
        })
    end

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
            label:setText(tr(rewardTypes[1].text))
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
            label:setText(tr(rewardTypes[2].text))
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
            lockButton:setText(tr('LOCKED'))
            lockButton:setImageColor('#888888')
        else
            lockButton:setEnabled(true)
            lockButton:setOpacity(1.0)
            if task.locked then
                lockButton:setText(tr('UNLOCK'))
                lockButton:setImageColor('#00BFFF')  -- Blue color for unlock
            else
                lockButton:setText(tr('LOCK'))
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
                startButton:setText(tr('Complete'))
                startButton:setImageColor('#00ff00')
                startButton.onClick = function() onCompleteClick() end
            else
                -- Task not complete - show Abandon button
                startButton:setText(tr('Abandon'))
                startButton:setImageColor('#ff0000')
                startButton.onClick = function() onAbandonClick() end
            end
        else
            -- Not active - show Start button
            startButton:setText(tr('Start'))
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
            activeTaskStatus:setText(tr('No active task'))
            activeTaskStatus:setColor('#888888')
        end
        if progressContainer then progressContainer:destroyChildren() end
        if completeButton then
            completeButton:setVisible(false)
        end
        return
    end
    
    if activeTaskStatus then 
        activeTaskStatus:setText(tr(activeTask.name))
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
            monsterLabel:setText(tr('%s: %s / %s', monster.name, monster.current or 0, monster.kills))
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
            dailyBonusLabel:setText(tr('Daily Bonus: +%s Fame (Available)', dailyBonusFame))
            dailyBonusLabel:setColor('#00ff00')
        else
            dailyBonusLabel:setText(tr('Daily Bonus: Already Claimed'))
            dailyBonusLabel:setColor('#888888')
        end
    end
end

function updateRerollsDisplay()
    if not tasksWindow then return end
    
    local rerollsAvailableLabel = tasksWindow:recursiveGetChildById('rerollsAvailableLabel')
    if rerollsAvailableLabel then
        local displayText = tr('Free Rerolls: %s/%s', rerollsAvailable, maxRerolls)
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
        local lockText = locksAvailable == 1 and tr('lock') or tr('locks')
        local displayText = tr('Premium: %s free %s', locksAvailable, lockText)
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
            rerollCostAmount:setText(tr('None'))
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
        }, function() 
            sendTaskBoardRequest('reroll', {use_free = false})
            dialog:destroy()
        end, function() 
            dialog:destroy()
        end)
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
        if locksAvailable > 0 then
            sendTaskBoardRequest('lock', {slot = slot, lock_state = true, use_free = true})
            return
        end

        local confirmMessage = 'No free locks left.\n\nLock this task for ' .. formatNumber(lockGoldCost) .. ' gold?\n\nLocked tasks will not be replaced when rerolling.'

        local dialog
        dialog = displayGeneralBox('Lock Task', confirmMessage, {
            {text = 'Yes', callback = function()
                sendTaskBoardRequest('lock', {slot = slot, lock_state = true, use_free = false})
                dialog:destroy()
            end},
            {text = 'No', callback = function()
                dialog:destroy()
            end}
        }, function()
            sendTaskBoardRequest('lock', {slot = slot, lock_state = true, use_free = false})
            dialog:destroy()
        end, function()
            dialog:destroy()
        end)
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
                -- Hide tracker when abandoning
                if taskTrackerWindow then
                    taskTrackerWindow:hide()
                end
                sendTaskBoardRequest('abandon')
                dialog:destroy()
            end},
            {text = 'No', callback = function()
                dialog:destroy()
            end}
        },
        function()
            if taskTrackerWindow then
                taskTrackerWindow:hide()
            end
            sendTaskBoardRequest('abandon')
            dialog:destroy()
        end,
        function()
            dialog:destroy()
        end
    )
    table.insert(activeDialogs, dialog)
end

function onCompleteClick()
    if not activeTask then
        return
    end
    
    sendTaskBoardRequest('complete')
end


function updateTaskTracker()
    if not taskTrackerWindow then
        return
    end
    
    if not activeTask then
        taskTrackerWindow:hide()
        return
    end
    
    -- Update task name
    local taskNameLabel = taskTrackerWindow:getChildById('taskNameLabel')
    if taskNameLabel then
        taskNameLabel:setText(tr(activeTask.name or 'Task'))
    end
    
    -- Update monster progress
    local progressContainer = taskTrackerWindow:getChildById('progressContainer')
    if progressContainer then
        progressContainer:destroyChildren()
        
        if activeTask.monsters then
            -- Build outfit lookup table
            local outfitLookup = {}
            if activeTask.outfits then
                for idx, outfit in ipairs(activeTask.outfits) do
                    outfitLookup[idx] = outfit
                end
            end
            
            for i, monster in ipairs(activeTask.monsters) do
                local current = monster.current or 0
                local total = monster.kills
                local isComplete = current >= total
                
                -- Create monster entry using predefined widget
                local entry = g_ui.createWidget('MonsterProgressEntry', progressContainer)
                
                local creatureWidget = entry:getChildById('creature')
                if creatureWidget then
                    local outfit = outfitLookup[i]
                    if outfit then
                        creatureWidget:setOutfit(outfit)
                        if monster.name then
                            creatureWidget:setTooltip(tr(monster.name))
                        end
                    end
                end
                
                -- Set name label
                local nameLabel = entry:getChildById('nameLabel')
                if nameLabel then
                    nameLabel:setText(tr('%s: %s / %s', monster.name, current, total))
                    nameLabel:setColor(isComplete and '#00ff00' or '#ffffff')
                end
                
                -- Set progress bar
                local progressBar = entry:getChildById('progressBar')
                if progressBar then
                    progressBar:setPercent(total > 0 and (current / total * 100) or 0)
                    if isComplete then
                        progressBar:setBackgroundColor('#00ff00')
                    end
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
