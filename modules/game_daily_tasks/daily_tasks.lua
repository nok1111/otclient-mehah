modules.game_daily_tasks = modules.game_daily_tasks or {}

local DailyTasks = modules.game_daily_tasks

local OPCODE = 218

local window = nil

local ACTION_OPEN        = 'open'
local ACTION_CLAIM_TASK  = 'claim_task'
local ACTION_CLAIM_DAILY = 'claim_daily'

local DIFF_COLORS = {
  easy   = '#9FD49F',
  medium = '#E7CF7A',
  hard   = '#E0836B',
}

local PROFESSION_LABELS = {
  alchemy    = 'Alchemy',
  enchanting = 'Enchanting',
  blacksmith = 'Blacksmith',
  gathering  = 'Gathering',
}

local PROFESSION_COLORS = {
  alchemy    = '#B4E7FF',
  enchanting = '#D7B4FF',
  blacksmith = '#FFB87A',
  gathering  = '#B8E986',
}

-- Category / profession -> icon from /images/game/buffs/
local BUFF = '/images/game/buffs/'
local CATEGORY_ICONS = {
  kill_zone   = BUFF .. '2.png',
  boss        = BUFF .. '1.png',
  dungeon     = BUFF .. '3_off.png',
  tower_floor = BUFF .. '21.png',
  kill_task   = BUFF .. '31.png',
  zone_event  = BUFF .. '16.png',
  gathering   = BUFF .. '11.png',
  mixed       = BUFF .. '17.png',
  crafting    = BUFF .. '20.png',
}

local PROFESSION_ICONS = {
  alchemy    = BUFF .. '4.png',
  enchanting = BUFF .. '4.png',
  blacksmith = BUFF .. '4.png',
  gathering  = BUFF .. '4.png',
}

local function resolveTaskIcon(task)
  if task.profession and PROFESSION_ICONS[task.profession] then
    return PROFESSION_ICONS[task.profession]
  end
  if task.category and CATEGORY_ICONS[task.category] then
    return CATEGORY_ICONS[task.category]
  end
  return BUFF .. 'arcana.png'
end

local function sendAction(action, data)
  local proto = g_game.getProtocolGame()
  if not proto then return end
  proto:sendExtendedOpcode(OPCODE, json.encode({
    action = action,
    data = data or {},
    slot = data and data.slot or nil,
  }))
end

local function ensureWindow()
  if window and not window:isDestroyed() then
    return true
  end
  local parent = rootWidget
  if modules.game_interface and modules.game_interface.getRootPanel then
    parent = modules.game_interface.getRootPanel() or rootWidget
  end
  window = g_ui.createWidget('DailyTasksWindow', parent)
  window:hide()

  local claim = window:getChildById('claimDailyButton')
  if claim then
    claim.onClick = function()
      local proto = g_game.getProtocolGame()
      if not proto then return end
      proto:sendExtendedOpcode(OPCODE, json.encode({ action = ACTION_CLAIM_DAILY }))
    end
  end
  return true
end

local function clearList()
  if not window then return end
  local list = window:getChildById('tasksList')
  if not list then return end
  list:destroyChildren()
end

local cachedState = nil

local function buildTaskRow(list, task)
  local row = g_ui.createWidget('DailyTaskRow', list)

  -- Title + description
  row:getChildById('title'):setText(task.title or 'Task')
  row:getChildById('desc'):setText(task.description or '-')

  -- Difficulty badge
  local diffLabel = row:getChildById('diffLabel')
  if diffLabel then
    diffLabel:setText((task.difficulty or 'task'):upper())
    diffLabel:setColor(DIFF_COLORS[task.difficulty] or '#FFFFFF')
  end

  -- Profession tag
  local profLabel = row:getChildById('professionLabel')
  if profLabel then
    if task.profession and PROFESSION_LABELS[task.profession] then
      profLabel:setText('. ' .. PROFESSION_LABELS[task.profession])
      profLabel:setColor(PROFESSION_COLORS[task.profession] or '#C5E1FF')
      profLabel:setVisible(true)
    else
      profLabel:setText('')
      profLabel:setVisible(false)
    end
  end

  -- Category icon (always present; hidden when a submission item overlays it)
  local categoryIcon = row:getChildById('categoryIcon')
  if categoryIcon then
    categoryIcon:setImageSource(resolveTaskIcon(task))
  end

  -- Rewards cluster (icons + values).
  -- Priority: flat field → nested rewards → state-level default → hardcoded fallback.
  -- NOTE: uses tonumber guards so "0" strings or nil values are handled.
  local function pickNum(...)
    for i = 1, select('#', ...) do
      local v = tonumber(select(i, ...))
      if v and v > 0 then return v end
    end
    return 0
  end
  local ap = pickNum(
    task.apReward,
    task.rewards and task.rewards.achievementPoints,
    cachedState and cachedState.perTaskAP,
    3  -- matches server CONFIG.perTaskAchievementPoints
  )
  local ess = pickNum(
    task.essReward,
    task.rewards and task.rewards.codexEssence,
    cachedState and cachedState.perTaskEss,
    5  -- matches server CONFIG.perTaskCodexEssence
  )

  local rewardsPanel = row:recursiveGetChildById('rewardsPanel')
  local apIcon   = row:recursiveGetChildById('apIcon')
  local apValue  = row:recursiveGetChildById('apValue')
  local essIcon  = row:recursiveGetChildById('essIcon')
  local essValue = row:recursiveGetChildById('essValue')

  print(string.format(
    '[daily_tasks] row reward values -> ap=%s ess=%s | apValue=%s essValue=%s',
    tostring(ap), tostring(ess),
    tostring(apValue and apValue:getId() or 'nil'),
    tostring(essValue and essValue:getId() or 'nil')
  ))
  if apValue then
    apValue:setText('+' .. ap)
    apValue:setColor('#FFD56B')
  end
  if essValue then
    essValue:setText('+' .. ess)
    essValue:setColor('#D7B4FF')
  end

  local apTip = string.format('Achievement Points reward: +%d\n\nSpent to unlock achievements and perks.', ap)
  local essTip = string.format('Codex Essence reward: +%d\n\nUsed by the Codex system to level up your knowledge.', ess)
  if apIcon then apIcon:setTooltip(apTip) end
  if apValue then apValue:setTooltip(apTip) end
  if essIcon then essIcon:setTooltip(essTip) end
  if essValue then essValue:setTooltip(essTip) end

  -- Progress bar
  local bar = row:getChildById('progress')
  local target = tonumber(task.target) or 0
  local progress = tonumber(task.progress) or 0
  if target > 0 then
    bar:setValue(progress, 0, target)
  else
    bar:setPercent(0)
  end
  bar:setText(string.format('%d / %d', progress, target))

  local btn = row:getChildById('claimButton')
  if task.claimed then
    btn:setText('Completed')
    btn:setEnabled(false)
  elseif task.submission then
    -- Submission: player must click to hand over items.
    if task.completable then
      btn:setText('Turn In')
      btn:setEnabled(true)
    else
      btn:setText(string.format('Need %d', (task.target or 0) - (task.progress or 0)))
      btn:setEnabled(false)
    end
    btn.onClick = function()
      if not task.completable then return end
      local proto = g_game.getProtocolGame()
      if not proto then return end
      proto:sendExtendedOpcode(OPCODE, json.encode({
        action = ACTION_CLAIM_TASK,
        slot = task.slot,
      }))
    end
  elseif task.completable then
    -- Non-submission tasks auto-claim server-side; this button is a fallback.
    btn:setText('Claim')
    btn:setEnabled(true)
    btn.onClick = function()
      local proto = g_game.getProtocolGame()
      if not proto then return end
      proto:sendExtendedOpcode(OPCODE, json.encode({
        action = ACTION_CLAIM_TASK,
        slot = task.slot,
      }))
    end
  else
    btn:setText('In Progress')
    btn:setEnabled(false)
  end
end

local function applyState(state)
  if not ensureWindow() then return end
  state = state or {}
  cachedState = state
  local tasks = state.tasks or {}

  local headerPanel = window:getChildById('headerPanel')
  local header = headerPanel and headerPanel:getChildById('headerLabel')
  local subHeader = headerPanel and headerPanel:getChildById('headerSubLabel')
  local progress = headerPanel and headerPanel:getChildById('dailyProgress')
  local claimBtn = window:getChildById('claimDailyButton')

  local completed = tonumber(state.completed) or 0
  local required = tonumber(state.required) or 4

  if header then
    header:setText(string.format('Daily Tasks  -  %d / %d', completed, required))
  end
  if subHeader then
    if state.bigRewardClaimed then
      subHeader:setText('Daily Golden Crate already claimed. Come back tomorrow!')
      subHeader:setColor('#9FD49F')
    elseif completed >= required then
      subHeader:setText('You can now claim your Golden Crate!')
      subHeader:setColor('#E7CF7A')
    else
      subHeader:setText(string.format('Complete %d tasks to unlock the Golden Crate.', required))
      subHeader:setColor('#C5E1FF')
    end
  end

  if progress then
    progress:setValue(math.min(completed, required), 0, math.max(1, required))
    progress:setText(string.format('%d / %d', completed, required))
  end

  if claimBtn then
    if state.bigRewardClaimed then
      claimBtn:setText('Daily Reward Claimed')
      claimBtn:setEnabled(false)
    elseif completed >= required then
      claimBtn:setText('Claim Golden Crate')
      claimBtn:setEnabled(true)
    else
      claimBtn:setText(string.format('Claim Golden Crate (%d/%d)', completed, required))
      claimBtn:setEnabled(false)
    end
  end

  clearList()
  local list = window:getChildById('tasksList')
  if list then
    for _, task in ipairs(tasks) do
      buildTaskRow(list, task)
    end
  end
end

local function onExtendedOpcode(protocol, opcode, buffer)
  if opcode ~= OPCODE then return end
  local ok, packet = pcall(function() return json.decode(buffer) end)
  if not ok or type(packet) ~= 'table' then return end

  if packet.action == 'open' then
    if ensureWindow() then
      window:show()
      window:raise()
      window:focus()
    end
    applyState(packet.data)
  elseif packet.action == 'state' then
    applyState(packet.data)
  end

  if packet.feedback and packet.feedback ~= '' then
    local tm = modules.game_textmessage
    if tm and tm.displayStatusMessage then
      tm.displayStatusMessage(packet.feedback)
    end
  end
end

function DailyTasks.show()
  if not ensureWindow() then return end
  window:show()
  window:raise()
  window:focus()
  sendAction(ACTION_OPEN)
end

function DailyTasks.hide()
  if window and not window:isDestroyed() then
    window:hide()
  end
end

function DailyTasks.toggle()
  if not ensureWindow() then return end
  if window:isVisible() then
    DailyTasks.hide()
  else
    DailyTasks.show()
  end
end

function init()
  g_ui.importStyle('daily_tasks.otui')

  connect(g_game, { onGameEnd = DailyTasks.hide })

  ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)
end

function terminate()
  disconnect(g_game, { onGameEnd = DailyTasks.hide })
  ProtocolGame.unregisterExtendedOpcode(OPCODE)

  if window and not window:isDestroyed() then
    window:destroy()
  end
  window = nil
end
