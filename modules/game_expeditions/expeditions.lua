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
    
    for i, zone in ipairs(data.zones or {}) do
        local panel = g_ui.createWidget('ExpeditionPanel', panelContainer)
        
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
    
    Expeditions.window:show()
    Expeditions.window:raise()
    Expeditions.window:focus()
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
        Expeditions.window:destroy()
        Expeditions.window = nil
    end
    Expeditions.panels = {}
end
