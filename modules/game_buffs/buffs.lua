local ProgressCallback = {
  update = 1,
  finish = 2
}

visibleIcons = 0
showNumbers = 1
buffsWindow = nil
cooldownTopButton = nil
leftframeborder = nil
rightframeborder = nil
buffsPanel = nil
lastPlayer = nil
cooldown = {}
groupCooldown = {}

BuffsBackgrounds = {
  {image = "/images/game/buffs/0"},
  {image = "/images/game/buffs/itemCommon"},
  {image = "/images/game/buffs/itemEpic"},
  {image = "/images/game/buffs/itemLegendary"},
  {image = "/images/game/buffs/itemRare"},
  {image = "/images/game/buffs/tower"}
}

BuffsDebuffsSettings = {iconFile = '/images/game/buffs/buffs', iconSize = {width = 32, height = 32}}

BuffsDebuffs = {}
function BuffsDebuffs.getImageClip(id)
  return tostring(id) .. '.png'
end

function init()
  connect(g_game, { onGameStart = online })
  connect(g_game, { onGameEnd = offline })

  ProtocolGame.registerExtendedOpcode(65, parseAddCooldown) -- parsenewcooldown
  ProtocolGame.registerExtendedOpcode(66, parseremoveBuff) -- parsenewcooldown

  buffsWindow = g_ui.displayUI('buffs')
  buffsWindow:hide()

  buffsPanel = buffsWindow:getChildById('buffsPanel')
  leftframeborder = buffsWindow:getChildById('leftframeborder')
  rightframeborder = buffsWindow:getChildById('rightframeborder')

  g_textures.preload(BuffsDebuffsSettings.iconFile)

  -- Binding Ctrl + B shortcut
  --g_keyboard.bindKeyDown('Ctrl+H', show)

  cooldownTopButton = modules.client_topmenu.addRightGameToggleButton('cooldownTopButton', tr('Show Buffs'), '/images/options/button_buffs', show)
  cooldownTopButton:setOn(true)

  if g_game.isOnline() then
    online()
  end
end

function terminate()
  disconnect(g_game, { onGameStart = online })
  disconnect(g_game, { onGameEnd = offline })
                       --onBuffCooldown     = onBuffCooldown    ]]-- })
  --ProtocolGame.unregisterExtendedOpcode(57, true) 
  ProtocolGame.unregisterExtendedOpcode(66, true) 
  buffsWindow:destroy()
end

--modules.game_cooldown.parseAddCooldown(true, true, json.encode({buffId = 1, timeSeconds = 120, tooltipText = 'Elo', bgId = 1}))
--modules.game_cooldown.parseremoveBuff(true, true, json.encode({buffId = 1}))

-- packets
function parseAddCooldown(protocol, opcode, buffer)
  if not protocol or not opcode or not buffer then return false end

  local json_status, json_data = pcall(function() return json.decode(buffer) end)
  if not json_status then
    g_logger.error("parseAddCooldown JSON error: " .. json_data)
    return
  end

  if not json_data.buffId or not json_data.timeSeconds or not json_data.tooltipText then
    print('parseAddCooldown - table is not complete.')
  end

  if not json_data.bgId or json_data.bgId == 0 then
    json_data.bgId = 1 -- set the default one
  end

	if tonumber(json_data.timeSeconds) == -1 then
		onBuffCooldown    (json_data.buffId, -1, json_data.tooltipText, json_data.bgId)
	else
		onBuffCooldown    (json_data.buffId, json_data.timeSeconds * 1000, json_data.tooltipText, json_data.bgId, json_data.count)
	end
end

function parseremoveBuff(protocol, opcode, buffer)
	if not opcode then return false end
  --local item_id = Struct.unpack('<H', buffer)
	 local json_status, json_data = pcall(function() return json.decode(buffer) end)
  if not json_status then
    g_logger.error("parseremoveBuff JSON error: " .. json_data)
    return
  end

  if not json_data.buffId then
    print('parseremoveBuff - table is not complete.')
  end

  local buffId = tonumber(json_data.buffId)
  if buffId then
		local icon = buffsPanel:getChildById(buffId) 
		if icon then
			local progressRect = icon:getChildById(buffId)
			if progressRect then
				removeBuff(progressRect)
			else
				icon:destroy()
        visibleIcons = (visibleIcons - 1)
			end
			cooldown[buffId] = false  
		end
	end
end

--
function loadIcon(iconId)
  local icon = buffsPanel:getChildById(iconId)
  if not icon then
    icon = g_ui.createWidget('SpellIcon')
    icon:setId(iconId)
    visibleIcons = (visibleIcons + 1)
    resizeWindow()
  end
  local spellSettings = BuffsDebuffsSettings
  if spellSettings then
    icon:getChildById('icon'):setImageSource(spellSettings.iconFile)
    icon:getChildById('icon'):setImageClip(BuffsDebuffs.getImageClip(iconId))
  else
    icon = nil
  end
  return icon
end

function show()
  if buffsWindow:isVisible() then
    buffsWindow:hide()
    cooldownTopButton:setOn(false)
  else
    buffsWindow:show()
    cooldownTopButton:setOn(true)
  end
end

function online()
  if buffsWindow and not buffsWindow:isVisible() then
    buffsWindow:breakAnchors()
buffsWindow:addAnchor(AnchorTop, "gameTopPanel", AnchorBottom)
buffsWindow:addAnchor(AnchorHorizontalCenter, "gameTopPanel", AnchorHorizontalCenter)
buffsWindow:setMarginTop(50) -- or your preferred spacing
buffsWindow:show()

    buffsWindow:setPhantom(g_settings.getBoolean('phantomBuffs'))
    local childs = buffsWindow:recursiveGetChildren()
    for _, child in ipairs(childs) do
      child:setPhantom(g_settings.getBoolean('phantomBuffs'))
    end
    buffsWindow:show()
  elseif buffsWindow and buffsWindow:isVisible() then
    buffsWindow:breakAnchors()
buffsWindow:addAnchor(AnchorTop, "gameTopPanel", AnchorBottom)
buffsWindow:addAnchor(AnchorHorizontalCenter, "gameTopPanel", AnchorHorizontalCenter)
buffsWindow:setMarginTop(50) -- or your preferred spacing
buffsWindow:show()
  end
  if not lastPlayer or lastPlayer ~= g_game.getCharacterName() then
    refresh()
    lastPlayer = g_game.getCharacterName()
  end
end

function offline()
  if buffsWindow and buffsWindow:isVisible() then
    g_settings.set('cooldowns-window-position', buffsWindow:getPosition())
    buffsWindow:hide()
  end
end

function refresh()
  if buffsPanel then
    buffsPanel:destroyChildren()
  end
end

function removeBuff(progressRect)
  removeEvent(progressRect.event)
  if progressRect.icon then
    progressRect.icon:destroy()
    progressRect.icon = nil
    visibleIcons = (visibleIcons - 1)
  end
  progressRect = nil
  resizeWindow()
end

function turnOffCooldown(progressRect)

  removeEvent(progressRect.event)
  if progressRect.icon then
    progressRect.icon:setOn(false)
    progressRect.icon = nil
  end

  progressRect = nil
end

function initCooldown(progressRect, updateCallback, finishCallback)
  progressRect:setPercent(0)
  
  progressRect.callback = {}
  progressRect.callback[ProgressCallback.update] = updateCallback
  progressRect.callback[ProgressCallback.finish] = finishCallback
  updateCallback()
end

function jebaculanekurwy(secondsI)
  local days = math.floor(secondsI / 86400)
  local seconds = secondsI - days * 86400
  local hours = math.floor(seconds / 3600 )
  seconds = seconds - hours * 3600
  local minutes = math.floor(seconds / 60) 
  seconds = seconds - minutes * 60
  if days > 0 then
    return string.format("%dd", days)
  end
  if hours > 0 then
    return string.format("%dh", hours)
  end
  if minutes > 0 then
    return string.format("%dm" , minutes)
  end
  if seconds > 0 then
    return string.format("%ds", seconds)
  end
  --return string.format("%d days, %d hours, %d minutes, %d seconds.",days,hours,minutes,seconds)
end

function updateBuffCooldown(progressRect, duration, timee)
  progressRect:setPercent(progressRect:getPercent() + (10000/duration))
  
  if timee % 1000 == 0 then
    local icid =  progressRect:getId()
  	local ic = buffsPanel:getChildById(icid)

    local timeLeft = jebaculanekurwy(timee / 1000)
    ic:getChildById('counterLabel' .. icid):setText(timeLeft)
    
    if showNumbers == 1 then
      ic:getChildById('counterLabel' .. icid):show()
  	else
      ic:getChildById('counterLabel' .. icid):hide()
  	end
  end
	
  if progressRect:getPercent() < 100 then
    removeEvent(progressRect.event)

    progressRect.event = scheduleEvent(function() 
      progressRect.callback[ProgressCallback.update]() 
    end, 100)
  else
	progressRect.event = scheduleEvent(function() 
      progressRect.callback[ProgressCallback.finish]() 
    end, 200)
  end
end

function onBuffCooldown(iconId, duration, spellName, bgId, count)
  local icon = loadIcon(iconId)
  if not icon then
    return
  end

  icon:setImageSource(BuffsBackgrounds[bgId].image)
  icon:setParent(buffsPanel)
  if duration == 4294967295000 then -- -1 nie dziala xd
	  icon:setTooltip(spellName)
	  cooldown[iconId] = true
	  return
  end
 
  local timee = duration

  local progressRect = icon:getChildById(iconId)
  if not progressRect then
    progressRect = g_ui.createWidget('BuffProgressRect', icon)
    progressRect:setId(iconId)
    progressRect.icon = icon
    progressRect:setHeight(34)
    progressRect:setWidth(34)
    progressRect:setPadding(2) --removed by nok
    progressRect:fill('icon')
    --progressRect:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
    --progressRect:addAnchor(AnchorVerticalCenter, 'parent', AnchorVerticalCenter)
    progressRect:addAnchor(AnchorTop, 'parent', AnchorTop)
    progressRect:addAnchor(AnchorLeft, 'parent', AnchorLeft)
    --progressRect:setMarginBottom(-1)
    progressRect:setMarginTop(4)
    progressRect:setMarginLeft(4)

    local counterLabel = g_ui.createWidget('Label', icon)
	  counterLabel:setId('counterLabel' .. iconId)
    counterLabel:setSize({width = 34, height = 12})
    counterLabel:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
    counterLabel:addAnchor(AnchorBottom, 'parent', AnchorBottom)
    counterLabel:setTextAlign(AlignTopCenter)
    counterLabel:setFont('verdana-11px-rounded')

    if count > 1 then
		icon:recursiveGetChildById('count'):setText(count)
	else
		icon:recursiveGetChildById('count'):setText("")
	end

  else
    progressRect:setPercent(0)
  end
  progressRect:setTooltip(spellName)

  local updateFunc = function()
    updateBuffCooldown(progressRect, duration, timee)
    timee = timee - 100
  end
  local finishFunc = function()
    removeBuff(progressRect)
    cooldown[iconId] = false
  end
  initCooldown(progressRect, updateFunc, finishFunc)
  cooldown[iconId] = true
end

function cooldownSettings(widget, mousePos, mouseButton)
  if mouseButton ~= MouseRightButton then return end
  local cooldownOptions = g_ui.createWidget('PopupMenu')
  cooldownOptions:setGameMenu(true)
	if showNumbers == 1 then
	  cooldownOptions:addOption('Hide numbers', function() showNumbers = 0 end)
	else
	  cooldownOptions:addOption('Show numbers', function() showNumbers = 1 end)
	end
  cooldownOptions:addSeparator()
  cooldownOptions:addOption('Close', function() show() end)
  cooldownOptions:display(mousePos)

  return true
end

function resizeWindow()
  if visibleIcons == 1 then
    buffsWindow:setWidth(52) -- default size, when empty , 50 default
  end
  if visibleIcons < 1 then
    buffsWindow:setWidth(52) -- default size, when empty , 50 default
  end
  if visibleIcons > 1 then
    buffsWindow:setWidth( (((visibleIcons-1)%visibleIcons+1)*50) )
  end
  return true
end
