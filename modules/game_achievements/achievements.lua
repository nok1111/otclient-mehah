--[[
  Achievement System - Client Module
  Handles UI and communication with server
]]--

achievementWindow = nil
achievementButton = nil

-- Extended Opcode IDs
local OPCODE_ACHIEVEMENT_LIST = 81      -- ExtendedIds.AchievementList
local OPCODE_ACHIEVEMENT_UPDATE = 82    -- ExtendedIds.AchievementUpdate
local OPCODE_ACHIEVEMENT_COMPLETE = 83  -- ExtendedIds.AchievementComplete
local OPCODE_ACHIEVEMENT_CLAIM = 84     -- ExtendedIds.AchievementClaim
local OPCODE_ACHIEVEMENT_DETAILS = 85   -- ExtendedIds.AchievementDetails
local OPCODE_ACHIEVEMENT_STATS = 86     -- ExtendedIds.AchievementStats

-- Achievement data cache
local achievements = {}
local categories = {
  {id = "all", name = "All", color = "#FFFFFF", icon = "all"},
  {id = "combat", name = "Combat", color = "#FFFFFF", icon = "sword"},
  {id = "exploration", name = "Exploration", color = "#FFFFFF", icon = "map"},
  {id = "collection", name = "Collection", color = "#FFFFFF", icon = "bag"},
  {id = "social", name = "Social", color = "#FFFFFF", icon = "people"},
  {id = "skills", name = "Skills", color = "#FFFFFF", icon = "star"},
  {id = "pets", name = "Pets", color = "#FFFFFF", icon = "pet"},
  {id = "professions", name = "Professions", color = "#FFFFFF", icon = "hammer"},
  {id = "crafting", name = "Crafting", color = "#FFA500", icon = "anvil"},
  {id = "gathering", name = "Gathering", color = "#32CD32", icon = "pickaxe"},
  {id = "dungeons", name = "Dungeons", color = "#FFFFFF", icon = "dungeon"},
  {id = "fame", name = "Fame", color = "#FFFFFF", icon = "star"},
  {id = "special", name = "Special", color = "#FFFFFF", icon = "crown"}
}

local currentCategory = "all"
local playerStats = {
  completed = 0,
  claimed = 0,
  totalPoints = 0
}

function init()
  connect(g_game, {
    onGameStart = onGameStart,
    onGameEnd = onGameEnd
  })

  ProtocolGame.registerExtendedOpcode(OPCODE_ACHIEVEMENT_LIST, onReceiveAchievementList)
  ProtocolGame.registerExtendedOpcode(OPCODE_ACHIEVEMENT_UPDATE, onReceiveAchievementUpdate)
  ProtocolGame.registerExtendedOpcode(OPCODE_ACHIEVEMENT_COMPLETE, onReceiveAchievementComplete)
  ProtocolGame.registerExtendedOpcode(OPCODE_ACHIEVEMENT_STATS, onReceiveStats)

  achievementButton = modules.client_topmenu.addRightGameToggleButton('achievementButton',
    tr('Achievements') .. ' (Ctrl+H)', '/images/topbuttons/achievements',
    toggle, false, 8)
  achievementButton:setOn(false)
  
  g_keyboard.bindKeyDown('Ctrl+H', toggle)

  if g_game.isOnline() then
    onGameStart()
  end
end

function terminate()
  disconnect(g_game, {
    onGameStart = onGameStart,
    onGameEnd = onGameEnd
  })

  ProtocolGame.unregisterExtendedOpcode(OPCODE_ACHIEVEMENT_LIST)
  ProtocolGame.unregisterExtendedOpcode(OPCODE_ACHIEVEMENT_UPDATE)
  ProtocolGame.unregisterExtendedOpcode(OPCODE_ACHIEVEMENT_COMPLETE)
  ProtocolGame.unregisterExtendedOpcode(OPCODE_ACHIEVEMENT_STATS)

  g_keyboard.unbindKeyDown('Ctrl+H')
  
  if achievementButton then
    achievementButton:destroy()
    achievementButton = nil
  end

  if achievementWindow then
    achievementWindow:destroy()
    achievementWindow = nil
  end
end

function onGameStart()
  -- Window will be created on first toggle
  -- Request initial data from server
  requestAchievementData()
end

function onGameEnd()
  if achievementWindow then
    achievementWindow:hide()
  end
  
  -- Clear data
  achievements = {}
  playerStats = {completed = 0, claimed = 0, totalPoints = 0}
end

function toggle()
  if not g_game.isOnline() then return end
  
  if not achievementWindow then
    achievementWindow = g_ui.displayUI('achievements')
    if not achievementWindow then
      g_logger.error('[Achievements] Failed to load achievements.otui')
      return
    end
    achievementWindow:hide() -- Hide immediately after creation
    setupWindow()
  end

  if achievementWindow:isVisible() then
    achievementWindow:hide()
    achievementButton:setOn(false)
  else
    achievementWindow:show()
    achievementWindow:raise()
    achievementWindow:focus()
    achievementButton:setOn(true)
    
    -- Request fresh data when opening
    requestAchievementData()
  end
end

function setupWindow()
  if not achievementWindow then return end
  
  -- Setup category buttons
  local categoryPanel = achievementWindow:getChildById('categoryPanel')
  if categoryPanel then
    for _, category in ipairs(categories) do
      local btn = categoryPanel:getChildById('cat_' .. category.id)
      if btn then
        btn.onClick = function()
          selectCategory(category.id)
        end
      end
    end
  end
  
  -- Setup close button
  local closeButton = achievementWindow:getChildById('closeButton')
  if closeButton then
    closeButton.onClick = function()
      toggle()
    end
  end
  
  -- Select first category (All)
  selectCategory("all")
end

function selectCategory(categoryId)
  currentCategory = categoryId
  
  -- Update button states (pressed/unpressed)
  local categoryPanel = achievementWindow:getChildById('categoryPanel')
  if categoryPanel then
    for _, category in ipairs(categories) do
      local btn = categoryPanel:getChildById('cat_' .. category.id)
      if btn then
        if category.id == categoryId then
          btn:setOn(true)
          btn:setEnabled(false) -- Disable active category
        else
          btn:setOn(false)
          btn:setEnabled(true) -- Enable inactive categories
        end
      end
    end
  end
  
  -- Update achievement list
  updateAchievementList()
  
  -- Request data from server
  requestAchievementData()
end

function updateAchievementList()
  if not achievementWindow then return end
  
  -- Get the list panel (it's inside achievementListPanel)
  local achievementListPanel = achievementWindow:getChildById('achievementListPanel')
  if not achievementListPanel then
    g_logger.error('[Achievements] achievementListPanel not found')
    return
  end
  
  local listPanel = achievementListPanel:getChildById('achievementList')
  if not listPanel then 
    g_logger.error('[Achievements] achievementList panel not found')
    return 
  end
  
  -- Clear current list
  listPanel:destroyChildren()
  
  -- Filter achievements by category
  local categoryAchievements = {}
  for _, achievement in pairs(achievements) do
    if currentCategory == "all" or achievement.category == currentCategory then
      table.insert(categoryAchievements, achievement)
    end
  end
  
  -- Sort by ID
  table.sort(categoryAchievements, function(a, b)
    return a.id < b.id
  end)
  
  -- Create achievement widgets
  for _, achievement in ipairs(categoryAchievements) do
    createAchievementWidget(listPanel, achievement)
  end
  
  -- Update stats
  updateStatsDisplay()
end

function createAchievementWidget(parent, achievement)
  local widget = g_ui.createWidget('AchievementItem', parent)
  if not widget then 
    g_logger.error('[Achievements] Failed to create AchievementItem widget')
    return 
  end
  
  -- Set name
  local nameLabel = widget:recursiveGetChildById('achievementName')
  if nameLabel then
    nameLabel:setText(achievement.name or "Unknown")
    
    -- Add secret marker if needed
    if achievement.secret and not achievement.completed then
      nameLabel:setText('??? (Secret)')
    end
  end
  
  -- Set description
  local descLabel = widget:recursiveGetChildById('achievementDesc')
  if descLabel then
    if achievement.secret and not achievement.completed then
      descLabel:setText('This is a secret achievement.')
    else
      descLabel:setText(achievement.description or "")
    end
  end
  
  -- Set points
  local pointsLabel = widget:recursiveGetChildById('achievementPoints')
  if pointsLabel then
    pointsLabel:setText((achievement.points or 0) .. ' pts')
  end
  
  -- Set progress
  local progressBackground = widget:recursiveGetChildById('progressBackground')
  local progressBar = progressBackground and progressBackground:getChildById('progressBar')
  local progressLabel = progressBackground and progressBackground:getChildById('progressLabel')
  
  if progressBar and progressLabel and achievement.progress then
    local current = achievement.progress.current or 0
    local required = achievement.progress.required or 1
    local percent = math.floor((current / required) * 100)
    
    progressBar:setPercent(percent)
    progressLabel:setText(string.format('%d / %d (%d%%)', current, required, percent))
    
    -- Change color when completed
    if percent >= 100 then
      progressBar:setBackgroundColor('#00ff00') -- Bright green when complete
    else
      progressBar:setBackgroundColor('#00aa00') -- Normal green
    end
  end
  
  -- Set status icon/color
  local statusIcon = widget:recursiveGetChildById('statusIcon')
  if statusIcon then
    if achievement.claimed then
      statusIcon:setText('✓')
      statusIcon:setColor('#FFD700') -- Gold
      widget:setBackgroundColor('#004400') -- Dark green tint
    elseif achievement.completed then
      statusIcon:setText('!')
      statusIcon:setColor('#44FF44') -- Green
      widget:setBackgroundColor('#444400') -- Dark yellow tint
    else
      statusIcon:setText('?')
      statusIcon:setColor('#666666') -- Gray
    end
  end
  
  -- Claim button
  local claimButton = widget:recursiveGetChildById('claimButton')
  if claimButton then
    if achievement.completed and not achievement.claimed then
      claimButton:setEnabled(true)
      claimButton:setVisible(true)
      claimButton.onClick = function()
        claimAchievement(achievement.id)
      end
    else
      claimButton:setEnabled(false)
      claimButton:setVisible(false)
    end
  end
  
  -- Icon (if using creature/item/image)
  local iconPanel = widget:getChildById('iconPanel')
  local iconWidget = iconPanel and iconPanel:getChildById('achievementIcon')
  local imageWidget = iconPanel and iconPanel:getChildById('achievementImage')
  
  if achievement.icon then
    local success, err = pcall(function()
      if achievement.icon.type == 'creature' and iconWidget then
        iconWidget:setOutfit({type = achievement.icon.value})
        iconWidget:setVisible(true)
        if imageWidget then imageWidget:setVisible(false) end
      elseif achievement.icon.type == 'item' and iconWidget then
        iconWidget:setItemId(achievement.icon.value)
        iconWidget:setVisible(true)
        if imageWidget then imageWidget:setVisible(false) end
      elseif achievement.icon.type == 'image' and imageWidget then
        -- Handle PNG image icons
        imageWidget:setImageSource(achievement.icon.value)
        imageWidget:setVisible(true)
        if iconWidget then iconWidget:setVisible(false) end
      end
    end)
    
    if not success then
      g_logger.warning('[Achievements] Failed to set icon for achievement ' .. achievement.id .. ': ' .. tostring(err))
    end
  end
end

function updateStatsDisplay()
  if not achievementWindow then return end
  
  local statsLabel = achievementWindow:getChildById('statsLabel')
  if statsLabel then
    statsLabel:setText(string.format(
      'Completed: %d | Claimed: %d | Points: %d',
      playerStats.completed,
      playerStats.claimed,
      playerStats.totalPoints
    ))
  end
end

-- Network functions
function requestAchievementData()
  if not g_game.isOnline() then return end
  
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    if currentCategory == "all" then
      -- Request all categories
      for _, category in ipairs(categories) do
        if category.id ~= "all" then
          protocolGame:sendExtendedOpcode(OPCODE_ACHIEVEMENT_DETAILS, category.id)
        end
      end
    else
      -- Request achievement list for current category
      protocolGame:sendExtendedOpcode(OPCODE_ACHIEVEMENT_DETAILS, currentCategory)
    end
  end
end

function claimAchievement(achievementId)
  if not g_game.isOnline() then return end
  
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    local data = json.encode({id = achievementId})
    protocolGame:sendExtendedOpcode(OPCODE_ACHIEVEMENT_CLAIM, data)
  end
end

-- Opcode handlers
function onReceiveAchievementList(protocol, opcode, buffer)
  local data = json.decode(buffer)
  if not data then return end
  
  -- Update achievements cache
  if data.achievements then
    for _, achievement in ipairs(data.achievements) do
      achievements[achievement.id] = achievement
    end
  end
  
  -- Update list if window is open
  if achievementWindow and achievementWindow:isVisible() then
    updateAchievementList()
  end
end

function onReceiveAchievementUpdate(protocol, opcode, buffer)
  local data = json.decode(buffer)
  if not data then return end
  
  -- Update specific achievement
  if data.id and achievements[data.id] then
    if data.progress then
      achievements[data.id].progress = data.progress
    end
    
    -- Refresh display
    if achievementWindow and achievementWindow:isVisible() then
      updateAchievementList()
    end
  end
end

function onReceiveAchievementComplete(protocol, opcode, buffer)
  local data = json.decode(buffer)
  if not data then return end
  
  -- Show completion notification
  modules.game_textmessage.displayGameMessage(string.format(
    'Achievement Unlocked: %s (+%d points)!',
    data.name or 'Unknown',
    data.points or 0
  ))
  
  -- Play sound/effect (if available)
  pcall(function()
    g_sounds.getChannel(SoundChannels.Ambient):enqueue('achievement_complete.ogg', 1.0)
  end)
  
  -- Update achievement data
  if data.id and achievements[data.id] then
    achievements[data.id].completed = true
  end
  
  -- Refresh display
  if achievementWindow and achievementWindow:isVisible() then
    updateAchievementList()
  end
end

function onReceiveStats(protocol, opcode, buffer)
  local data = json.decode(buffer)
  if not data then return end
  
  playerStats = {
    completed = data.completed or 0,
    claimed = data.claimed or 0,
    totalPoints = data.points or 0
  }
  
  -- Update display
  if achievementWindow and achievementWindow:isVisible() then
    updateStatsDisplay()
  end
end
