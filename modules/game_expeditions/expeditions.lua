Expeditions = Expeditions or {}
Expeditions.opCode = 77
Expeditions.window = nil
Expeditions.panels = {}

local countdownEvent

function init()
    connect(g_game, {
        onGameEnd = onGameEnd,
        onExtendedOpcode = onExtendedOpcode
    })
    
    ProtocolGame.registerExtendedOpcode(Expeditions.opCode, onExtendedOpcode)
end

function terminate()
    disconnect(g_game, {
        onGameEnd = onGameEnd,
        onExtendedOpcode = onExtendedOpcode
    })
    
    ProtocolGame.unregisterExtendedOpcode(Expeditions.opCode)
    
    if Expeditions.window and not Expeditions.window:isDestroyed() then
        Expeditions.window:destroy()
        Expeditions.window = nil
    end
    
    -- Stop countdown updates
    if countdownEvent then
        removeEvent(countdownEvent)
        countdownEvent = nil
    end
end

function onGameEnd()
    if Expeditions.window and not Expeditions.window:isDestroyed() then
        Expeditions.window:destroy()
        Expeditions.window = nil
    end
    Expeditions.panels = {}
    
    -- Stop countdown updates
    if countdownEvent then
        removeEvent(countdownEvent)
        countdownEvent = nil
    end
end

function onExtendedOpcode(protocol, opcode, buffer)
    if opcode == Expeditions.opCode then
        local status, data = pcall(function() return json.decode(buffer) end)
        if not status then
            print("[Expeditions] Error decoding data: " .. tostring(data))
            return
        end
        
        if data.type == "show_expeditions" then
            showExpeditionPanel(data)
        elseif data.type == "show_teleports" then
            showTeleportPanel(data)
        elseif data.action == "close" then
            closeExpeditionPanel()
        end
    end
end

function ensureWindow()
    if Expeditions.window and not Expeditions.window:isDestroyed() then
        return true
    end
    
    local okImport, importErr = pcall(function()
        g_ui.importStyle('expeditions.otui')
    end)
    if not okImport then
        print("[Expeditions] Failed to import style: " .. tostring(importErr))
        return false
    end
    
    local okCreate, winOrErr = pcall(function()
        return g_ui.createWidget('ExpeditionWindow', rootWidget)
    end)
    if not okCreate or not winOrErr then
        print("[Expeditions] Failed to create window: " .. tostring(winOrErr))
        return false
    end
    
    Expeditions.window = winOrErr
    Expeditions.window:hide()
    modules.game_interface.getRootPanel():focus()
    return true
end

function showExpeditionPanel(data)
    if not ensureWindow() then
        print("[Expeditions] Failed to create window")
        return
    end
    
    if not Expeditions.window then
        print("[Expeditions] Window is nil after ensureWindow")
        return
    end
    
    local titleLabel = Expeditions.window:getChildById('titleLabel')
    if titleLabel then
        titleLabel:setText(data.tierName or 'Daily Expeditions')
    end
    
    local panelContainer = Expeditions.window:getChildById('panelContainer')
    if not panelContainer then
        print("[Expeditions] panelContainer not found")
        return
    end
    
    panelContainer:destroyChildren()
    Expeditions.panels = {}
    
    -- Set close button handler
    local closeButton = Expeditions.window:getChildById('closeButton')
    if closeButton then
        closeButton.onClick = function()
            closeExpeditionPanel()
        end
    end
    
    -- Store data for sliding navigation
    Expeditions.allZones = data.zones or {}
    Expeditions.currentOffset = 0  -- Which panel is the first visible (0-based)
    
    local numZones = #Expeditions.allZones
    local panelWidth = 280
    local panelHeight = 400
    local panelSpacing = 15
    local windowMargin = 40
    
    -- Window size based on max 3 visible panels
    local maxVisiblePanels = math.min(numZones, 3)
    local windowWidth = (panelWidth * maxVisiblePanels) + (panelSpacing * math.max(0, maxVisiblePanels - 1)) + windowMargin + 100
    local windowHeight = 540
    
    Expeditions.window:setWidth(windowWidth)
    Expeditions.window:setHeight(windowHeight)
    
    -- Set container size for 3 panels
    local containerWidth = (panelWidth * maxVisiblePanels) + (panelSpacing * (maxVisiblePanels - 1))
    local containerHeight = panelHeight
    panelContainer:setWidth(containerWidth)
    panelContainer:setHeight(containerHeight)
    
    -- Setup navigation buttons
    local prevButton = Expeditions.window:getChildById('prevButton')
    local nextButton = Expeditions.window:getChildById('nextButton')
    
    if prevButton then
        prevButton.onClick = function()
            Expeditions.slideLeft()
        end
    end
    
    if nextButton then
        nextButton.onClick = function()
            Expeditions.slideRight()
        end
    end
    
    -- Show navigation buttons only if more than 3 zones
    if prevButton then prevButton:setVisible(numZones > 3) end
    if nextButton then nextButton:setVisible(numZones > 3) end
    
    -- Show initial view
    Expeditions.updatePanels()
    
    Expeditions.window:show()
    Expeditions.window:raise()
    Expeditions.window:focus()
    
    -- Start countdown updates
    if not countdownEvent then
        countdownEvent = cycleEvent(updateCountdowns, 1000)
    end
end

function updateCountdowns()
    if not Expeditions.window or not Expeditions.window:isVisible() then
        return
    end
    
    local now = os.time()
    
    for _, panel in ipairs(Expeditions.panels) do
        if panel.buffEndTime and panel.buffData then
            local remaining = panel.buffEndTime - now
            
            if remaining > 0 then
                local buffStatusPanel = panel:getChildById('buffStatusPanel')
                local buffStatusLabel = buffStatusPanel and buffStatusPanel:getChildById('buffStatusLabel')
                
                if buffStatusLabel then
                    local hours = math.floor(remaining / 3600)
                    local minutes = math.floor((remaining % 3600) / 60)
                    local seconds = remaining % 60
                    local timeStr
                    
                    if hours > 0 then
                        timeStr = string.format("%dh %02dm %02ds", hours, minutes, seconds)
                    else
                        timeStr = string.format("%02dm %02ds", minutes, seconds)
                    end
                    
                    buffStatusLabel:setText(string.format('%s\n[%s]', panel.buffData.name, timeStr))
                end
            else
                -- Buff expired
                panel.buffEndTime = nil
                panel.buffData = nil
            end
        end
    end
end

function Expeditions.updatePanels()
    if not Expeditions.window then return end
    
    local panelContainer = Expeditions.window:getChildById('panelContainer')
    if not panelContainer then return end
    
    panelContainer:destroyChildren()
    Expeditions.panels = {}
    
    local numZones = #Expeditions.allZones
    local startIdx = Expeditions.currentOffset + 1
    local endIdx = math.min(startIdx + 2, numZones)  -- Always show 3 panels
    
    local panelWidth = 280
    local panelSpacing = 15
    
    for i = startIdx, endIdx do
        local zone = Expeditions.allZones[i]
        local panelIndex = i - startIdx
        local panel = g_ui.createWidget('ExpeditionPanel', panelContainer)
        
        -- Calculate horizontal position
        local x = panelIndex * (panelWidth + panelSpacing)
        local y = 0
        
        panel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        panel:addAnchor(AnchorTop, 'parent', AnchorTop)
        panel:setMarginLeft(x)
        panel:setMarginTop(y)
        
        print("[DEBUG] Offset " .. Expeditions.currentOffset .. " | Zone " .. i .. ": " .. zone.name .. " | Position: x=" .. x)
        
        local header = panel:getChildById('header')
        if header then
            header:setImageSource('/images/ui/' .. (zone.headerImage or 'expedition_default'))
        end
        
        local levelPanel = panel:getChildById('levelPanel')
        if levelPanel then
            local levelLabel = levelPanel:getChildById('levelLabel')
            if levelLabel and zone.minLevel then
                if zone.maxLevel then
                    levelLabel:setText('Level ' .. zone.minLevel .. ' - ' .. zone.maxLevel)
                else
                    levelLabel:setText('Level ' .. zone.minLevel .. '+')
                end
            end
        end
        
        local nameLabel = panel:getChildById('nameLabel')
        if nameLabel then
            nameLabel:setText(zone.name)
        end
        
        local pvpLabel = panel:getChildById('pvpLabel')
        if pvpLabel and zone.pvpType then
            if zone.pvpType == "non-pvp" then
                pvpLabel:setText('Non PVP Zone')
                pvpLabel:setColor('#90EE90')  -- Green
            elseif zone.pvpType == "pvp-enabled" then
                pvpLabel:setText('PVP Enabled Zone')
                pvpLabel:setColor('#FFD700')  -- Yellow
            elseif zone.pvpType == "pvp-enforced" then
                pvpLabel:setText('PVP Enforced Zone')
                pvpLabel:setColor('#FF4444')  -- Red
            end
        end
        
        local descLabel = panel:getChildById('descLabel')
        if descLabel then
            descLabel:setText(zone.description)
        end
        
        local buffStatusPanel = panel:getChildById('buffStatusPanel')
        local buffIcon = buffStatusPanel and buffStatusPanel:getChildById('buffIcon')
        local buffStatusLabel = buffStatusPanel and buffStatusPanel:getChildById('buffStatusLabel')
        local buffDescLabel = buffStatusPanel and buffStatusPanel:getChildById('buffDescLabel')
        
        if buffStatusLabel then
            -- Handle zone buff status
            if zone.buffStatus then
                local status = zone.buffStatus
                
                if status.state == "active" then
                    -- Buff is currently active - show with timer, icon, and description
                    local hours = math.floor(status.remaining / 3600)
                    local minutes = math.floor((status.remaining % 3600) / 60)
                    local seconds = status.remaining % 60
                    local timeStr
                    
                    if hours > 0 then
                        timeStr = string.format("%dh %02dm %02ds", hours, minutes, seconds)
                    else
                        timeStr = string.format("%02dm %02ds", minutes, seconds)
                    end
                    
                    buffStatusLabel:setText(string.format('%s\n[%s]', status.name, timeStr))
                    buffStatusLabel:setColor(status.color or '#FFD700')
                    
                    -- Show buff description in white
                    if buffDescLabel then
                        buffDescLabel:setText(status.description or '')
                        buffDescLabel:setVisible(true)
                    end
                    
                    -- Show and set buff icon
                    if buffIcon then
                        buffIcon:setVisible(true)
                        -- Map buff types to icon paths
                        local iconPaths = {
                            bloodPact = '/images/icons/fire',
                            bountyHunt = '/images/icons/fire',
                            doubleExp = '/images/icons/fire',
                            monsterRush = '/images/icons/fire',
                            orbShower = '/images/icons/fire',
                            rapidRegen = '/images/icons/fire',
                            speedDemon = '/images/icons/fire',
                            survivalInstinct = '/images/icons/fire',
                            bloodMoon = '/images/icons/fire',
                            codexKnowledge = '/images/icons/fire'
                        }
                        local iconPath = iconPaths[status.type] or '/images/icons/fire'
                        buffIcon:setImageSource(iconPath)
                    end
                    
                    -- Store buff data for countdown
                    panel.buffData = status
                    panel.buffEndTime = os.time() + status.remaining
                    panel.lastUpdateTime = os.time()
                    
                elseif status.state == "cooldown" then
                    -- Buff ended, in cooldown period
                    local hours = math.floor(status.remaining / 3600)
                    local minutes = math.floor((status.remaining % 3600) / 60)
                    local seconds = status.remaining % 60
                    local timeStr
                    
                    if hours > 0 then
                        timeStr = string.format("%dh %02dm %02ds", hours, minutes, seconds)
                    else
                        timeStr = string.format("%02dm %02ds", minutes, seconds)
                    end
                    
                    buffStatusLabel:setText(string.format('Buff Cooldown\n[%s]', timeStr))
                    buffStatusLabel:setColor('#FF6600')  -- Orange-red for cooldown
                    
                    if buffDescLabel then
                        buffDescLabel:setText(string.format("'%s' ended. Next buff available in:", status.lastBuffName or "Last buff"))
                        buffDescLabel:setVisible(true)
                        buffDescLabel:setColor('#FFAA00')
                    end
                    
                    if buffIcon then
                        buffIcon:setVisible(false)
                    end
                    
                    -- Store cooldown data for countdown
                    panel.buffData = {name = "Cooldown"}
                    panel.buffEndTime = os.time() + status.remaining
                    panel.lastUpdateTime = os.time()
                    
                elseif status.state == "upcoming" then
                    -- Zone has buff rotation enabled, but no active buff
                    buffStatusLabel:setText(status.message or 'Next buff rotation coming soon')
                    buffStatusLabel:setColor('#FFAA00')  -- Orange for upcoming
                    if buffIcon then
                        buffIcon:setVisible(false)
                    end
                    if buffDescLabel then
                        buffDescLabel:setVisible(false)
                    end
                    
                elseif status.state == "none" then
                    -- No buffs available in this zone
                    buffStatusLabel:setText(status.message or 'No buffs available in this zone')
                    buffStatusLabel:setColor('#888888')  -- Gray for disabled
                    if buffIcon then
                        buffIcon:setVisible(false)
                    end
                    if buffDescLabel then
                        buffDescLabel:setVisible(false)
                    end
                end
            else
                -- Fallback: show static rewards if buffStatus not present
                buffStatusLabel:setText('Rewards: ' .. (zone.rewards or 'Unknown'))
                buffStatusLabel:setColor('#90EE90')
                if buffIcon then
                    buffIcon:setVisible(false)
                end
                if buffDescLabel then
                    buffDescLabel:setVisible(false)
                end
            end
        end
        
        local joinButton = panel:getChildById('joinButton')
        if joinButton then
            joinButton.onClick = function()
                -- Send expedition ID directly
                joinExpedition(zone.id)
            end
        end
        
        table.insert(Expeditions.panels, panel)
    end
    
    -- Update button states and colors
    local prevButton = Expeditions.window:getChildById('prevButton')
    local nextButton = Expeditions.window:getChildById('nextButton')
    
    if prevButton then
        local canGoPrev = Expeditions.currentOffset > 0
        prevButton:setEnabled(canGoPrev)
        -- Cyan when enabled, gray when disabled
        prevButton:setImageColor(canGoPrev and '#00FFFF' or '#666666')
        local prevArrow = prevButton:getChildById('prevArrow')
        if prevArrow then
            prevArrow:setOpacity(canGoPrev and 1.0 or 0.5)
        end
    end
    
    if nextButton then
        -- Can slide right if there are more panels after the 3rd visible one
        local maxOffset = numZones - 3
        local canGoNext = Expeditions.currentOffset < maxOffset
        nextButton:setEnabled(canGoNext)
        -- Cyan when enabled, gray when disabled
        nextButton:setImageColor(canGoNext and '#00FFFF' or '#666666')
        local nextArrow = nextButton:getChildById('nextArrow')
        if nextArrow then
            nextArrow:setOpacity(canGoNext and 1.0 or 0.5)
        end
    end
end

function Expeditions.slideLeft()
    if Expeditions.currentOffset > 0 then
        Expeditions.currentOffset = Expeditions.currentOffset - 1
        Expeditions.updatePanels()
    end
end

function Expeditions.slideRight()
    local numZones = #Expeditions.allZones
    local maxOffset = numZones - 3
    if Expeditions.currentOffset < maxOffset then
        Expeditions.currentOffset = Expeditions.currentOffset + 1
        Expeditions.updatePanels()
    end
end

function showTeleportPanel(data)
    if not ensureWindow() then
        print("[Expeditions] Failed to create window")
        return
    end
    
    if not Expeditions.window then
        print("[Expeditions] Window is nil after ensureWindow")
        return
    end
    
    local titleLabel = Expeditions.window:getChildById('titleLabel')
    if titleLabel then
        titleLabel:setText(data.tierName or 'Teleporter')
    end
    
    local panelContainer = Expeditions.window:getChildById('panelContainer')
    if not panelContainer then
        print("[Expeditions] panelContainer not found")
        return
    end
    
    panelContainer:destroyChildren()
    Expeditions.panels = {}
    
    -- Set close button handler
    local closeButton = Expeditions.window:getChildById('closeButton')
    if closeButton then
        closeButton.onClick = function()
            closeExpeditionPanel()
        end
    end
    
    -- Store data for sliding navigation
    Expeditions.allZones = data.zones or {}
    Expeditions.currentOffset = 0
    
    local numZones = #Expeditions.allZones
    local panelWidth = 210
    local panelHeight = 320
    local panelSpacing = 15
    local windowMargin = 40
    
    -- Window size based on max 3 visible panels
    local maxVisiblePanels = math.min(numZones, 3)
    local windowWidth = (panelWidth * maxVisiblePanels) + (panelSpacing * math.max(0, maxVisiblePanels - 1)) + windowMargin + 100
    local windowHeight = 460
    
    Expeditions.window:setWidth(windowWidth)
    Expeditions.window:setHeight(windowHeight)
    
    -- Set container size for 3 panels
    local containerWidth = (panelWidth * maxVisiblePanels) + (panelSpacing * (maxVisiblePanels - 1))
    local containerHeight = panelHeight
    panelContainer:setWidth(containerWidth)
    panelContainer:setHeight(containerHeight)
    
    -- Setup navigation buttons
    local prevButton = Expeditions.window:getChildById('prevButton')
    local nextButton = Expeditions.window:getChildById('nextButton')
    
    if prevButton then
        prevButton.onClick = function()
            Expeditions.slideLeftTeleport()
        end
    end
    
    if nextButton then
        nextButton.onClick = function()
            Expeditions.slideRightTeleport()
        end
    end
    
    -- Show navigation buttons only if more than 3 zones
    if prevButton then prevButton:setVisible(numZones > 3) end
    if nextButton then nextButton:setVisible(numZones > 3) end
    
    -- Show initial view
    Expeditions.updateTeleportPanels()
    
    Expeditions.window:show()
    Expeditions.window:raise()
    Expeditions.window:focus()
    
    -- Start countdown updates
    if not countdownEvent then
        countdownEvent = cycleEvent(updateCountdowns, 1000)
    end
end

function Expeditions.updateTeleportPanels()
    if not Expeditions.window then return end
    
    local panelContainer = Expeditions.window:getChildById('panelContainer')
    if not panelContainer then return end
    
    panelContainer:destroyChildren()
    Expeditions.panels = {}
    
    local numZones = #Expeditions.allZones
    local startIdx = Expeditions.currentOffset + 1
    local endIdx = math.min(startIdx + 2, numZones)  -- Always show 3 panels
    
    local panelWidth = 210
    local panelSpacing = 15
    
    for i = startIdx, endIdx do
        local zone = Expeditions.allZones[i]
        local panelIndex = i - startIdx
        local panel = g_ui.createWidget('TeleportPanel', panelContainer)
        
        -- Calculate horizontal position
        local x = panelIndex * (panelWidth + panelSpacing)
        local y = 0
        
        panel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        panel:addAnchor(AnchorTop, 'parent', AnchorTop)
        panel:setMarginLeft(x)
        panel:setMarginTop(y)
        
        print("[DEBUG] Teleport Offset " .. Expeditions.currentOffset .. " | Zone " .. i .. ": " .. zone.name .. " | Position: x=" .. x)
        
        local header = panel:getChildById('header')
        if header then
            header:setImageSource('/images/ui/' .. (zone.headerImage or 'expedition_default'))
        end
        
        local nameLabel = panel:getChildById('nameLabel')
        if nameLabel then
            nameLabel:setText(zone.name)
        end
        
        local descLabel = panel:getChildById('descLabel')
        if descLabel then
            descLabel:setText(zone.description)
        end
        
        local teleportButton = panel:getChildById('teleportButton')
        if teleportButton then
            teleportButton.onClick = function()
                joinTeleport(zone.id)
            end
        end
        
        table.insert(Expeditions.panels, panel)
    end
    
    -- Update button states
    local prevButton = Expeditions.window:getChildById('prevButton')
    local nextButton = Expeditions.window:getChildById('nextButton')
    
    if prevButton then
        local canGoPrev = Expeditions.currentOffset > 0
        prevButton:setEnabled(canGoPrev)
        prevButton:setImageColor(canGoPrev and '#00FFFF' or '#666666')
        local prevArrow = prevButton:getChildById('prevArrow')
        if prevArrow then
            prevArrow:setOpacity(canGoPrev and 1.0 or 0.5)
        end
    end
    
    if nextButton then
        local maxOffset = numZones - 3
        local canGoNext = Expeditions.currentOffset < maxOffset
        nextButton:setEnabled(canGoNext)
        nextButton:setImageColor(canGoNext and '#00FFFF' or '#666666')
        local nextArrow = nextButton:getChildById('nextArrow')
        if nextArrow then
            nextArrow:setOpacity(canGoNext and 1.0 or 0.5)
        end
    end
end

function Expeditions.slideLeftTeleport()
    if Expeditions.currentOffset > 0 then
        Expeditions.currentOffset = Expeditions.currentOffset - 1
        Expeditions.updateTeleportPanels()
    end
end

function Expeditions.slideRightTeleport()
    local numZones = #Expeditions.allZones
    local maxOffset = numZones - 3
    if Expeditions.currentOffset < maxOffset then
        Expeditions.currentOffset = Expeditions.currentOffset + 1
        Expeditions.updateTeleportPanels()
    end
end

function joinTeleport(zoneId)
    local data = {
        action = "join_teleport",
        zoneId = zoneId
    }
    
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        protocolGame:sendExtendedOpcode(Expeditions.opCode, json.encode(data))
    end
    
    closeExpeditionPanel()
end

function joinExpedition(expeditionId)
    local data = {
        action = "join_expedition",
        expeditionId = expeditionId
    }
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        protocolGame:sendExtendedOpcode(Expeditions.opCode, json.encode(data))
    end
end

function closeExpeditionPanel()
    if Expeditions.window and not Expeditions.window:isDestroyed() then
        Expeditions.window:hide()
        Expeditions.window:destroy()
        Expeditions.window = nil
    end
    Expeditions.panels = {}
    
    -- Stop countdown updates
    if countdownEvent then
        removeEvent(countdownEvent)
        countdownEvent = nil
    end
    modules.game_interface.getRootPanel():focus()
end
