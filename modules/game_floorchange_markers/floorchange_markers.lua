local floorMarkers = {}
local updateEvent = nil
local scanRadius = 30
local scanInterval = 500

local arrowIcon = '/images/icons/stair'

local function getMinimapWidget()
    if modules and modules.game_minimap and modules.game_minimap.getMiniMapUi then
        local ok, w = pcall(modules.game_minimap.getMiniMapUi)
        if ok and w and not w:isDestroyed() then
            return w
        end
    end
    return nil
end

local function posKey(pos)
    return string.format('%d_%d_%d', pos.x, pos.y, pos.z)
end

local function removeMarker(key)
    local widget = floorMarkers[key]
    if widget and not widget:isDestroyed() then
        widget:destroy()
    end
    floorMarkers[key] = nil
end

local function clearAllMarkers()
    for key, widget in pairs(floorMarkers) do
        if widget and not widget:isDestroyed() then
            widget:destroy()
        end
    end
    floorMarkers = {}
end

local function createMarker(pos)
    local key = posKey(pos)
    if floorMarkers[key] then
        return
    end

    local minimap = getMinimapWidget()
    if not minimap then
        return
    end

    local widget = g_ui.createWidget('FloorChangeMarkerWidget', minimap)
    if not widget then
        widget = g_ui.createWidget('UIWidget', minimap)
        if not widget then
            return
        end
        widget:setSize({ width = 16, height = 16 })
    end
    widget:setImageSource(arrowIcon)
    widget:setTooltip('Floor change')
    minimap:centerInPosition(widget, pos)
    floorMarkers[key] = widget
end

local function scanFloorChanges()
    local player = g_game.getLocalPlayer()
    if not player then
        return
    end

    local minimap = getMinimapWidget()
    if not minimap or not minimap:isVisible() then
        return
    end

    local camPos = minimap:getCameraPosition()
    if not camPos then
        return
    end

    local seen = {}
    local half = scanRadius
    for x = -half, half do
        for y = -half, half do
            local pos = { x = camPos.x + x, y = camPos.y + y, z = camPos.z }
            local tile = g_map.getTile(pos)
            if tile and tile.hasFloorChange and tile:hasFloorChange() then
                local key = posKey(pos)
                seen[key] = true
                if not floorMarkers[key] then
                    createMarker(pos)
                end
            end
        end
    end

    for key, widget in pairs(floorMarkers) do
        if not seen[key] then
            removeMarker(key)
        end
    end
end

local function onPositionChange()
    scanFloorChanges()
end

local function onGameStart()
    clearAllMarkers()
    scanFloorChanges()
    if not updateEvent then
        updateEvent = scheduleEvent(scanFloorChanges, scanInterval)
    end
end

local function onGameEnd()
    if updateEvent then
        removeEvent(updateEvent)
        updateEvent = nil
    end
    clearAllMarkers()
end

function init()
    local sampleTile = g_map.getTile(g_game.getLocalPlayer() and g_game.getLocalPlayer():getPosition() or {x=0,y=0,z=0})
    if sampleTile and not sampleTile.hasFloorChange then
        g_logger.warning('[FloorChange Markers] Tile:hasFloorChange() not available; rebuild C++ to enable.')
    end

    connect(LocalPlayer, {
        onPositionChange = onPositionChange
    })
    connect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd
    })
    if g_game.isOnline() and g_game.getLocalPlayer() then
        onGameStart()
    end
end

function terminate()
    disconnect(LocalPlayer, {
        onPositionChange = onPositionChange
    })
    disconnect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd
    })
    if updateEvent then
        removeEvent(updateEvent)
        updateEvent = nil
    end
    clearAllMarkers()
end
