--[[
  Achievement System - Client Module
  Handles UI and communication with server
]]--

achievementWindow = nil
achievementButton = nil
achievementPopup = nil
activePopupEvent = nil

-- Extended Opcode IDs
local OPCODE_ACHIEVEMENT_LIST = 81      -- ExtendedIds.AchievementList
local OPCODE_ACHIEVEMENT_UPDATE = 82    -- ExtendedIds.AchievementUpdate
local OPCODE_ACHIEVEMENT_COMPLETE = 83  -- ExtendedIds.AchievementComplete
local OPCODE_ACHIEVEMENT_CLAIM = 84     -- ExtendedIds.AchievementClaim
local OPCODE_ACHIEVEMENT_DETAILS = 85   -- ExtendedIds.AchievementDetails
local OPCODE_ACHIEVEMENT_STATS = 86     -- ExtendedIds.AchievementStats
local OPCODE_ACHIEVEMENT_REWARDS = 87   -- ExtendedIds.AchievementRewards

-- Achievement data cache
local achievements = {}
local rewardsData = {}
local rewardsAvailablePoints = 0
local rewardsPlayerSex = 0
local rewardsCurrentPage = 1
local rewardsTotalPages = 1
local currentTab = "achievements"
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
  totalPoints = 0,
  availablePoints = 0
}

function init()
  g_ui.importStyle('achievements')

  connect(g_game, {
    onGameStart = onGameStart,
    onGameEnd = onGameEnd
  })

  ProtocolGame.registerExtendedOpcode(OPCODE_ACHIEVEMENT_LIST, onReceiveAchievementList)
  ProtocolGame.registerExtendedOpcode(OPCODE_ACHIEVEMENT_UPDATE, onReceiveAchievementUpdate)
  ProtocolGame.registerExtendedOpcode(OPCODE_ACHIEVEMENT_COMPLETE, onReceiveAchievementComplete)
  ProtocolGame.registerExtendedOpcode(OPCODE_ACHIEVEMENT_STATS, onReceiveStats)
  ProtocolGame.registerExtendedOpcode(OPCODE_ACHIEVEMENT_REWARDS, onReceiveRewards)

  achievementButton = modules.game_mainpanel.addStoreButton('achievementButton',
    tr('Achievements'), '/images/topbuttons/achievements',
    toggle, false, 6)
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
  ProtocolGame.unregisterExtendedOpcode(OPCODE_ACHIEVEMENT_REWARDS)

  g_keyboard.unbindKeyDown('Ctrl+H')
  
  if achievementButton then
    achievementButton:destroy()
    achievementButton = nil
  end

  if achievementWindow then
    achievementWindow:destroy()
    achievementWindow = nil
  end

  if activePopupEvent then
    removeEvent(activePopupEvent)
    activePopupEvent = nil
  end

  if achievementPopup then
    achievementPopup:destroy()
    achievementPopup = nil
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
  rewardsData = {}
  rewardsAvailablePoints = 0
  currentTab = "achievements"
  playerStats = {completed = 0, claimed = 0, totalPoints = 0, availablePoints = 0}
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
    if currentTab == "achievements" then
      requestAchievementData()
    else
      requestRewardsData()
    end
  end
end

function setupWindow()
  if not achievementWindow then return end
  
  -- Setup tab buttons
  local tabAchievements = achievementWindow:recursiveGetChildById('tabAchievements')
  if tabAchievements then
    tabAchievements.onClick = function()
      showAchievementsTab()
    end
  end
  
  local tabRewards = achievementWindow:recursiveGetChildById('tabRewards')
  if tabRewards then
    tabRewards.onClick = function()
      showRewardsTab()
    end
  end
  
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
  showAchievementsTab()
end

function showAchievementsTab()
  if not achievementWindow then return end
  currentTab = "achievements"
  
  -- Show achievement panels
  local categoryPanel = achievementWindow:getChildById('categoryPanel')
  local achievementListPanel = achievementWindow:getChildById('achievementListPanel')
  local rewardsContent = achievementWindow:getChildById('rewardsContent')
  
  if categoryPanel then categoryPanel:setVisible(true) end
  if achievementListPanel then achievementListPanel:setVisible(true) end
  if rewardsContent then rewardsContent:setVisible(false) end
  
  -- Update tab button styles
  local tabAchievements = achievementWindow:recursiveGetChildById('tabAchievements')
  local tabRewards = achievementWindow:recursiveGetChildById('tabRewards')
  if tabAchievements then
    tabAchievements:setImageClip(torect('0 68 116 34'))
    tabAchievements:setColor('#FFD700')
  end
  if tabRewards then
    tabRewards:setImageClip(torect('0 0 116 34'))
    tabRewards:setColor('#dfdfdf')
  end
  
  requestAchievementData()
end

function showRewardsTab()
  if not achievementWindow then return end
  currentTab = "rewards"
  
  -- Hide achievement panels, show rewards
  local categoryPanel = achievementWindow:getChildById('categoryPanel')
  local achievementListPanel = achievementWindow:getChildById('achievementListPanel')
  local rewardsContent = achievementWindow:getChildById('rewardsContent')
  
  if categoryPanel then categoryPanel:setVisible(false) end
  if achievementListPanel then achievementListPanel:setVisible(false) end
  if rewardsContent then rewardsContent:setVisible(true) end
  
  -- Update tab button styles
  local tabAchievements = achievementWindow:recursiveGetChildById('tabAchievements')
  local tabRewards = achievementWindow:recursiveGetChildById('tabRewards')
  if tabAchievements then
    tabAchievements:setImageClip(torect('0 0 116 34'))
    tabAchievements:setColor('#dfdfdf')
  end
  if tabRewards then
    tabRewards:setImageClip(torect('0 68 116 34'))
    tabRewards:setColor('#FFD700')
  end
  
  requestRewardsData()
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
  
  -- Set hint label (how to get achievement)
  local hintLabel = widget:recursiveGetChildById('hintLabel')
  if hintLabel then
    local hintText = achievement.hint or getDefaultHint(achievement)
    hintLabel:setText(hintText)
  end
end

function getDefaultHint(achievement)
  -- Generate hint based on achievement type/category
  if not achievement.progress then
    return "Complete the required task"
  end
  
  local progressType = achievement.progress.type
  local required = achievement.progress.required or 1
  
  -- Map progress types to hints
  local hints = {
    kills = "Kill " .. required .. " monsters",
    humanoid_kills = "Defeat " .. required .. " humanoid creatures",
    lizard_kills = "Defeat " .. required .. " lizard creatures", 
    elemental_kills = "Defeat " .. required .. " elemental creatures",
    undead_kills = "Defeat " .. required .. " undead creatures",
    wild_kills = "Defeat " .. required .. " wild creatures",
    boss_kills = "Defeat " .. required .. " different bosses",
    level = "Reach level " .. required,
    blacksmith_level = "Reach Blacksmith level " .. required,
    mining_level = "Reach Mining level " .. required,
    herbalism_level = "Reach Herbalism level " .. required,
    woodcutting_level = "Reach Woodcutting level " .. required,
    enchanting_level = "Reach Enchanting level " .. required,
    alchemy_level = "Reach Alchemy level " .. required,
    crafted_blacksmith = "Craft " .. required .. " Blacksmith items",
    crafted_alchemy = "Craft " .. required .. " Alchemy items",
    crafted_enchanting = "Craft " .. required .. " Enchanting items",
    crafted_refinery = "Craft " .. required .. " Refinery items",
    pets = "Collect " .. required .. " different pets",
    pet_level = "Raise a pet to level " .. required,
    gold = "Accumulate " .. required .. " gold coins",
    distance = "Travel " .. required .. " sqm total",
    deaths = "Die " .. required .. " times (hopefully less!)",
    logins = "Login " .. required .. " days",
    playtime = "Play for " .. required .. " hours"
  }
  
  return hints[progressType] or "Complete the required objective"
end

function updateStatsDisplay()
  if not achievementWindow then return end
  
  local statsLabel = achievementWindow:recursiveGetChildById('statsLabel')
  if statsLabel then
    statsLabel:setText(string.format(
      'Completed: %d | Claimed: %d | Points: %d | Available: %d',
      playerStats.completed,
      playerStats.claimed,
      playerStats.totalPoints,
      playerStats.availablePoints
    ))
  end
end

-- Network functions
function requestAchievementData()
  if not g_game.isOnline() then return end
  
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    -- Always request player stats first
    protocolGame:sendExtendedOpcode(OPCODE_ACHIEVEMENT_STATS, "")
    
    -- Only request specific category data, not all at once
    -- "all" category shows cached data, user must click specific categories to load them
    if currentCategory ~= "all" then
      protocolGame:sendExtendedOpcode(OPCODE_ACHIEVEMENT_DETAILS, currentCategory)
    end
  end
end

function requestRewardsData(page)
  if not g_game.isOnline() then return end
  page = page or 1
  
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    local data = json.encode({action = "list", page = page})
    protocolGame:sendExtendedOpcode(OPCODE_ACHIEVEMENT_REWARDS, data)
    protocolGame:sendExtendedOpcode(OPCODE_ACHIEVEMENT_STATS, "")
  end
end

function purchaseReward(rewardId)
  if not g_game.isOnline() then return end
  
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    local data = json.encode({action = "buy", id = rewardId, page = rewardsCurrentPage})
    protocolGame:sendExtendedOpcode(OPCODE_ACHIEVEMENT_REWARDS, data)
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
  
  -- Show visual popup notification
  showAchievementPopup(data.name or 'Unknown', data.points or 0)
  
  -- Also show text message as backup
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
    totalPoints = data.points or 0,
    availablePoints = data.availablePoints or 0
  }
  
  -- Update display
  if achievementWindow and achievementWindow:isVisible() then
    updateStatsDisplay()
  end
end

-- Show achievement unlock popup with animation
function showAchievementPopup(achievementName, points)
  -- Create popup if it doesn't exist
  if not achievementPopup then
    achievementPopup = g_ui.createWidget('AchievementPopup', modules.game_interface.getRootPanel())
    if not achievementPopup then
      g_logger.error('[Achievements] Failed to create achievement popup')
      return
    end
  end
  
  -- Cancel any existing popup animation
  if activePopupEvent then
    removeEvent(activePopupEvent)
    activePopupEvent = nil
  end
  
  -- Update popup text
  local nameLabel = achievementPopup:recursiveGetChildById('popupAchievementName')
  if nameLabel then
    nameLabel:setText(achievementName)
  end
  
  local pointsLabel = achievementPopup:recursiveGetChildById('popupPoints')
  if pointsLabel then
    pointsLabel:setText('+' .. points .. ' points')
  end
  
  -- Show popup with fade in animation
  achievementPopup:setVisible(true)
  achievementPopup:setOpacity(0)
  
  -- Fade in over 0.3 seconds
  local fadeInSteps = 10
  local fadeInDelay = 30 -- milliseconds
  local fadeInStep = 0
  
  local function fadeIn()
    fadeInStep = fadeInStep + 1
    local opacity = (fadeInStep / fadeInSteps)
    achievementPopup:setOpacity(opacity)
    
    if fadeInStep < fadeInSteps then
      scheduleEvent(fadeIn, fadeInDelay)
    else
      -- Keep visible for 4 seconds, then fade out
      activePopupEvent = scheduleEvent(fadeOutPopup, 4000)
    end
  end
  
  fadeIn()
end

-- Fade out and hide popup
function fadeOutPopup()
  if not achievementPopup then return end
  
  local fadeOutSteps = 10
  local fadeOutDelay = 30
  local fadeOutStep = 0
  
  local function fadeOut()
    fadeOutStep = fadeOutStep + 1
    local opacity = 1.0 - (fadeOutStep / fadeOutSteps)
    achievementPopup:setOpacity(opacity)
    
    if fadeOutStep < fadeOutSteps then
      scheduleEvent(fadeOut, fadeOutDelay)
    else
      achievementPopup:setVisible(false)
      activePopupEvent = nil
    end
  end
  
  fadeOut()
end

-- =============================================
-- REWARDS SHOP FUNCTIONS
-- =============================================

function onReceiveRewards(protocol, opcode, buffer)
  local data = json.decode(buffer)
  if not data then return end
  
  -- Handle purchase result message
  if data.type == "purchaseResult" then
    if data.success then
      modules.game_textmessage.displayGameMessage('Purchase successful!')
    else
      modules.game_textmessage.displayGameMessage(data.message or 'Purchase failed.')
    end
    return
  end
  
  if data.rewards then
    rewardsData = data.rewards
  end
  
  if data.playerSex ~= nil then
    rewardsPlayerSex = data.playerSex
  end
  
  if data.availablePoints then
    rewardsAvailablePoints = data.availablePoints
    playerStats.availablePoints = data.availablePoints
  end
  
  if data.page then
    rewardsCurrentPage = data.page
  end
  if data.totalPages then
    rewardsTotalPages = data.totalPages
  end
  
  -- Update rewards display if window is open and on rewards tab
  if achievementWindow and achievementWindow:isVisible() and currentTab == "rewards" then
    updateRewardsList()
    updateStatsDisplay()
  end
end

function updateRewardsList()
  if not achievementWindow then return end
  
  local rewardsContent = achievementWindow:getChildById('rewardsContent')
  if not rewardsContent then return end
  
  -- Update points label
  local rewardsPointsLabel = rewardsContent:recursiveGetChildById('rewardsPointsLabel')
  if rewardsPointsLabel then
    rewardsPointsLabel:setText('Available Points: ' .. rewardsAvailablePoints)
  end
  
  -- Get the list panel
  local rewardsList = rewardsContent:recursiveGetChildById('rewardsList')
  if not rewardsList then return end
  
  -- Clear current list
  rewardsList:destroyChildren()
  
  -- Create reward widgets
  for _, reward in ipairs(rewardsData) do
    createRewardWidget(rewardsList, reward)
  end
  
  -- Page navigation
  if rewardsTotalPages > 1 then
    local navWidget = g_ui.createWidget('Panel', rewardsList)
    navWidget:setHeight(40)
    navWidget:setLayout(UIHorizontalLayout.create(navWidget))
    navWidget:getLayout():setSpacing(10)
    
    if rewardsCurrentPage > 1 then
      local prevBtn = g_ui.createWidget('Button', navWidget)
      prevBtn:setText('< Prev')
      prevBtn:setWidth(80)
      prevBtn:setHeight(30)
      prevBtn.onClick = function() requestRewardsData(rewardsCurrentPage - 1) end
    end
    
    local pageLabel = g_ui.createWidget('Label', navWidget)
    pageLabel:setText('Page ' .. rewardsCurrentPage .. ' / ' .. rewardsTotalPages)
    pageLabel:setColor('#FFFFFF')
    pageLabel:setTextAlign(AlignCenter)
    pageLabel:setWidth(120)
    pageLabel:setHeight(30)
    
    if rewardsCurrentPage < rewardsTotalPages then
      local nextBtn = g_ui.createWidget('Button', navWidget)
      nextBtn:setText('Next >')
      nextBtn:setWidth(80)
      nextBtn:setHeight(30)
      nextBtn.onClick = function() requestRewardsData(rewardsCurrentPage + 1) end
    end
  end
end

function createRewardWidget(parent, reward)
  local widget = g_ui.createWidget('RewardItem', parent)
  if not widget then return end
  
  -- Set outfit preview with player colors and full addons
  local outfitPreview = widget:getChildById('outfitPreview')
  if outfitPreview then
    local success, err = pcall(function()
      local looktype = reward.looktype
      if rewardsPlayerSex == 0 and reward.looktype_female then
        looktype = reward.looktype_female
      end
      local outfitTable = {type = looktype, addons = 3}
      local localPlayer = g_game.getLocalPlayer()
      if localPlayer then
        local playerOutfit = localPlayer:getOutfit()
        outfitTable.head = playerOutfit.head
        outfitTable.body = playerOutfit.body
        outfitTable.legs = playerOutfit.legs
        outfitTable.feet = playerOutfit.feet
      end
      outfitPreview:setOutfit(outfitTable)
    end)
    if not success then
      g_logger.warning('[Achievements] Failed to set preview: ' .. tostring(err))
    end
  end
  
  -- Set name
  local nameLabel = widget:recursiveGetChildById('rewardName')
  if nameLabel then
    nameLabel:setText(reward.name or "Unknown")
  end
  
  -- Set description
  local descLabel = widget:recursiveGetChildById('rewardDesc')
  if descLabel then
    descLabel:setText(reward.description or "")
  end
  
  -- Set cost
  local costLabel = widget:recursiveGetChildById('rewardCost')
  if costLabel then
    costLabel:setText('Cost: ' .. (reward.cost or 0) .. ' pts')
    if rewardsAvailablePoints >= (reward.cost or 0) and not reward.owned then
      costLabel:setColor('#00FF00')
    elseif reward.owned then
      costLabel:setColor('#888888')
    else
      costLabel:setColor('#FF4444')
    end
  end
  
  -- Buy button / Owned label
  local buyButton = widget:recursiveGetChildById('buyButton')
  local ownedLabel = widget:recursiveGetChildById('ownedLabel')
  
  if reward.owned then
    -- Already owned - green theme
    if buyButton then
      buyButton:setVisible(false)
    end
    if ownedLabel then
      ownedLabel:setVisible(true)
    end
    widget:setBackgroundColor('#1a3320')
    widget:setBorderColor('#44FF44')
    if nameLabel then
      nameLabel:setColor('#44FF44')
    end
    if descLabel then
      descLabel:setText('You already own this outfit.')
      descLabel:setColor('#88CC88')
    end
    if costLabel then
      costLabel:setText('Purchased')
      costLabel:setColor('#44FF44')
    end
  else
    -- Not owned
    if ownedLabel then
      ownedLabel:setVisible(false)
    end
    if buyButton then
      buyButton:setVisible(true)
      if rewardsAvailablePoints >= (reward.cost or 0) then
        buyButton:setEnabled(true)
      else
        buyButton:setEnabled(false)
      end
      buyButton.onClick = function()
        buyButton:setEnabled(false)
        buyButton:setText('...')
        purchaseReward(reward.id)
      end
    end
  end
end
