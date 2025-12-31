Expeditions = Expeditions or {}
Expeditions.opCode = 77
Expeditions.window = nil
Expeditions.panels = {}

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
end

function onGameEnd()
    if Expeditions.window and not Expeditions.window:isDestroyed() then
        Expeditions.window:destroy()
        Expeditions.window = nil
    end
    Expeditions.panels = {}
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
        
        local rewardsLabel = panel:getChildById('rewardsLabel')
        if rewardsLabel then
            rewardsLabel:setText('Rewards: ' .. zone.rewards)
        end
        
        local joinButton = panel:getChildById('joinButton')
        if joinButton then
            joinButton.onClick = function()
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

function joinExpedition(zoneId)
    local data = {
        action = "join_expedition",
        zoneId = zoneId
    }
    
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        protocolGame:sendExtendedOpcode(Expeditions.opCode, json.encode(data))
    end
    
    closeExpeditionPanel()
end

function closeExpeditionPanel()
    if Expeditions.window and not Expeditions.window:isDestroyed() then
        Expeditions.window:hide()
        Expeditions.window:destroy()
        Expeditions.window = nil
    end
    Expeditions.panels = {}
end
