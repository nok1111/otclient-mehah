local npcCategories = {}

local categoryIcons = {
    vendor = '/images/game/npcicons/icon_vendor',
    quest = '/images/game/npcicons/icon_quest',
    fame = '/images/game/npcicons/icon_fame',
    food = '/images/game/npcicons/icon_food',
    tools = '/images/game/npcicons/icon_tools',
    default = '/images/game/npcicons/icon_default',
}

local npcMarkers = {}
local updateEvent = nil
local logCounter = 0

local function getCategory(name)
    return npcCategories[name] or 'default'
end

local function getMinimapWidget()
    if modules and modules.game_minimap and modules.game_minimap.getMiniMapUi then
        local ok, w = pcall(modules.game_minimap.getMiniMapUi)
        if ok and w and not w:isDestroyed() then
            return w
        end
        if not ok then
            g_logger.warning('[NPC Markers] getMiniMapUi failed: ' .. tostring(w))
        end
    end
    return nil
end

local function updateMarkerPosition(creature)
    local id = creature:getId()
    local widget = npcMarkers[id]
    if not widget or widget:isDestroyed() then
        return
    end

    local minimap = getMinimapWidget()
    if not minimap or not minimap:isVisible() then
        widget:hide()
        return
    end

    local pos = creature:getPosition()
    local camPos = minimap:getCameraPosition()
    if not pos or not camPos or pos.z ~= camPos.z then
        widget:hide()
        return
    end

    local point = minimap:getTilePoint(pos)
    if not point or point.x < 0 then
        widget:hide()
        return
    end

    widget:show()
end

local function createMarker(creature)
    local minimap = getMinimapWidget()
    if not minimap then
        g_logger.warning('[NPC Markers] createMarker: no minimap widget')
        return
    end

    local id = creature:getId()
    if npcMarkers[id] then
        return
    end

    local name = creature:getName()
    local category = getCategory(name)
    local widget = g_ui.createWidget('NpcMarkerWidget', minimap)
    if not widget then
        g_logger.warning('[NPC Markers] failed to create NpcMarkerWidget, falling back to UIWidget')
        widget = g_ui.createWidget('UIWidget', minimap)
        if not widget then
            g_logger.error('[NPC Markers] failed to create any marker widget')
            return
        end
        widget:setSize({ width = 16, height = 16 })
    end
    widget:setImageSource(categoryIcons[category])
    widget:setTooltip(name .. ' [' .. category .. ']')
    local pos = creature:getPosition()
    minimap:centerInPosition(widget, pos)
    npcMarkers[id] = widget
    print('[NPC Markers] created marker for ' .. name .. ' (' .. category .. ')')
    updateMarkerPosition(creature)
end

local function removeMarker(creature)
    local id = creature:getId()
    local widget = npcMarkers[id]
    if widget and not widget:isDestroyed() then
        widget:destroy()
    end
    npcMarkers[id] = nil
end

local function applyWorldIcon(creature)
    if not creature:isNpc() then
        return
    end
    local name = creature:getName()
    local category = getCategory(name)
    creature:setCustomIconTexture(categoryIcons[category])
end

local function onCreatureAppear(creature)
    if not creature or not creature:isNpc() then
        return
    end
    applyWorldIcon(creature)
    createMarker(creature)
end

local function onCreatureDisappear(creature)
    if not creature then
        return
    end
    removeMarker(creature)
end

local function onCreaturePositionChange(creature)
    if not creature or not creature:isNpc() then
        return
    end
    updateMarkerPosition(creature)
end

local function updateAllMarkers()
    local minimap = getMinimapWidget()
    if not minimap or not minimap:isVisible() then
        for id, widget in pairs(npcMarkers) do
            if not widget:isDestroyed() then
                widget:hide()
            end
        end
        updateEvent = scheduleEvent(updateAllMarkers, 100)
        return
    end

    local count = 0
    for id, widget in pairs(npcMarkers) do
        count = count + 1
        local creature = g_map.getCreatureById(id)
        if creature and not creature:isRemoved() then
            updateMarkerPosition(creature)
        elseif not widget:isDestroyed() then
            widget:destroy()
            npcMarkers[id] = nil
        end
    end

    logCounter = logCounter + 1
    if logCounter >= 20 then
        logCounter = 0
        print('[NPC Markers] updateAllMarkers: ' .. count .. ' markers, minimap visible: ' .. tostring(minimap:isVisible()))
    end

    updateEvent = scheduleEvent(updateAllMarkers, 100)
end

local function loadCategories()
    local path = '/npc/npc_categories.lua'
    if not g_resources.fileExists(path) then
        g_logger.warning('[NPC Markers] categories file not found: ' .. path)
        return
    end

    local content = g_resources.readFileContents(path)
    local func, err = loadstring(content)
    if not func then
        g_logger.error('[NPC Markers] failed to parse categories: ' .. tostring(err))
        return
    end

    local ok, result = pcall(func)
    if not ok then
        g_logger.error('[NPC Markers] error loading categories: ' .. tostring(result))
        return
    end

    npcCategories = result or {}
    print('[NPC Markers] loaded ' .. table.size(npcCategories) .. ' NPC categories')
end

local function refreshExistingCreatures()
    local player = g_game.getLocalPlayer()
    if not player then
        return
    end
    local pos = player:getPosition()
    if not pos then
        return
    end

    local spectators = g_map.getSpectators(pos, false)
    for _, creature in ipairs(spectators) do
        if creature:isNpc() then
            applyWorldIcon(creature)
            createMarker(creature)
        end
    end
end

local function onGameStart()
    refreshExistingCreatures()
    if updateEvent then
        removeEvent(updateEvent)
        updateEvent = nil
    end
    updateEvent = scheduleEvent(updateAllMarkers, 100)
end

local function onGameEnd()
    if updateEvent then
        removeEvent(updateEvent)
        updateEvent = nil
    end
    for id, widget in pairs(npcMarkers) do
        if widget and not widget:isDestroyed() then
            widget:destroy()
        end
    end
    npcMarkers = {}
end

function init()
    print('[NPC Markers] init')
    loadCategories()

    connect(Creature, {
        onAppear = onCreatureAppear,
        onDisappear = onCreatureDisappear,
        onPositionChange = onCreaturePositionChange
    })

    connect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd
    })

    -- If game is already running, refresh immediately
    if g_game.isOnline() and g_game.getLocalPlayer() then
        print('[NPC Markers] game already online, refreshing existing creatures')
        onGameStart()
    end
end

function terminate()
    disconnect(Creature, {
        onAppear = onCreatureAppear,
        onDisappear = onCreatureDisappear,
        onPositionChange = onCreaturePositionChange
    })

    disconnect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd
    })

    onGameEnd()
end
