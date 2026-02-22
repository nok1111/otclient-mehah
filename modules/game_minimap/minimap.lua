local iconTopMenu = nil
-- @ Minimap
local minimapWidget = nil -- bot fix
local otmm = true
local oldPos = nil
local fullscreenWidget
local virtualFloor = 7
local currentDayTime = {
    h = 12,
    m = 0
}

local function refreshVirtualFloors()
    -- UI indicators were removed; make this a safe no-op
    return
end

local function syncMinimapPosition(pos)
    local player = g_game.getLocalPlayer()
    if not player then
        return
    end

    pos = pos or player:getPosition()
    if not pos then
        return
    end

    local minimapWidget = mapController.ui.minimapBorder.minimap
    if not (minimapWidget) or minimapWidget:isDragging() then
        return
    end

    if not minimapWidget.fullMapView then
        minimapWidget:setCameraPosition(pos)
    end

    minimapWidget:setCrossPosition(pos)
    virtualFloor = pos.z
    refreshVirtualFloors()
end

local function onPositionChange()
    syncMinimapPosition()
end

local function onWalk(oldPos, newPos)
    syncMinimapPosition(newPos)
end

local function onTeleport(player, newPos, oldPos)
    local localPlayer = g_game.getLocalPlayer()
    if localPlayer and player and player ~= localPlayer then
        return
    end

    syncMinimapPosition(newPos)
end

mapController = Controller:new()
-- Mount minimap under RightPanel (consistent with main panel)
mapController:setUI('minimap', modules.game_interface.getRightPanel())

function onChangeWorldTime(hour, minute)
    -- Day/night UI removed; keep stub to avoid nil references
    return
end

function mapController:onInit()
    local mm = self.ui.minimapBorder.minimap
    local function hideIfExists(id)
        local w = mm:getChildById(id)
        if w then w:hide() end
    end
    hideIfExists('floorUpButton')
    hideIfExists('floorDownButton')
    hideIfExists('zoomInButton')
    hideIfExists('zoomOutButton')
    hideIfExists('resetButton')
end

function mapController:onGameStart()

    mapController:registerEvents(LocalPlayer, {
        onPositionChange = onPositionChange,
        onWalk = onWalk
    }):execute()

    mapController:registerEvents(g_game, {
        onTeleport = onTeleport
    })

    -- Load Map
    g_minimap.clean()

    local minimapFile = '/minimap'
    local loadFnc = nil

    if otmm then
        minimapFile = minimapFile .. '.otmm'
        loadFnc = g_minimap.loadOtmm
    else
        minimapFile = minimapFile .. '_' .. g_game.getClientVersion() .. '.otcm'
        loadFnc = g_map.loadOtcm
    end

    if g_resources.fileExists(minimapFile) then
        loadFnc(minimapFile)
    end

    self.ui.minimapBorder.minimap:load()
    syncMinimapPosition()
end

function mapController:onGameEnd()
    -- Save Map
    if otmm then
        g_minimap.saveOtmm('/minimap.otmm')
    else
        g_map.saveOtcm('/minimap_' .. g_game.getClientVersion() .. '.otcm')
    end

    self.ui.minimapBorder.minimap:save()
end

function mapController:onTerminate()
    if iconTopMenu then
        iconTopMenu:destroy()
        iconTopMenu = nil
    end
end

function zoomIn()
    mapController.ui.minimapBorder.minimap:zoomIn()
end

function zoomOut()
    mapController.ui.minimapBorder.minimap:zoomOut()
end

function fullscreen()
    local minimapWidget = mapController.ui.minimapBorder.minimap
    if not minimapWidget then
        minimapWidget = fullscreenWidget
    end
    local zoom;

    if not minimapWidget then
        return
    end

    if minimapWidget.fullMapView then
        fullscreenWidget = nil
        minimapWidget:setParent(mapController.ui.minimapBorder)
        minimapWidget:fill('parent')
        mapController.ui:show()
        zoom = minimapWidget.zoomMinimap
        g_keyboard.unbindKeyDown('Escape')
        minimapWidget.fullMapView = false
    else
        fullscreenWidget = minimapWidget
        mapController.ui:hide(true)
        minimapWidget:setParent(modules.game_interface.getRootPanel())
        minimapWidget:fill('parent')
        zoom = minimapWidget.zoomFullmap
        g_keyboard.bindKeyDown('Escape', fullscreen)
        minimapWidget.fullMapView = true
    end

    local pos = oldPos or minimapWidget:getCameraPosition()
    oldPos = minimapWidget:getCameraPosition()
    minimapWidget:setZoom(zoom)
    minimapWidget:setCameraPosition(pos)
end

function upLayer()
    if virtualFloor == 0 then
        return
    end

    mapController.ui.minimapBorder.minimap:floorUp(1)
    virtualFloor = virtualFloor - 1
    refreshVirtualFloors()
end

function downLayer()
    if virtualFloor == 15 then
        return
    end

    mapController.ui.minimapBorder.minimap:floorDown(1)
    virtualFloor = virtualFloor + 1
    refreshVirtualFloors()
end

function onClickRoseButton(dir)
    if dir == 'north' then
        mapController.ui.minimapBorder.minimap:move(0, 1)
    elseif dir == 'north-east' then
        mapController.ui.minimapBorder.minimap:move(-1, 1)
    elseif dir == 'east' then
        mapController.ui.minimapBorder.minimap:move(-1, 0)
    elseif dir == 'south-east' then
        mapController.ui.minimapBorder.minimap:move(-1, -1)
    elseif dir == 'south' then
        mapController.ui.minimapBorder.minimap:move(0, -1)
    elseif dir == 'south-west' then
        mapController.ui.minimapBorder.minimap:move(1, -1)
    elseif dir == 'west' then
        mapController.ui.minimapBorder.minimap:move(1, 0)
    elseif dir == 'north-west' then
        mapController.ui.minimapBorder.minimap:move(1, 1)
    end
end

function resetMap()
    mapController.ui.minimapBorder.minimap:reset()
    local player = g_game.getLocalPlayer()
    if player then
        virtualFloor = player:getPosition().z
        refreshVirtualFloors()
    end
end

function getMiniMapUi()
    return mapController.ui.minimapBorder.minimap
end

-- Open the MapTravel UI in view-only mode (waypoints view)
function openWaypointsView()
    print('[Minimap] Map button clicked -> openWaypointsView')
    -- Ensure MapTravel module/table exists; try lazy-load if missing
    if not MapTravel or type(MapTravel) ~= 'table' then
        if type(ensureModuleLoaded) == 'function' then
            print('[Minimap] Attempting to load module: game_MapTravel')
            pcall(ensureModuleLoaded, 'game_MapTravel')
        end
    end

    -- Resolve module reference (global or namespaced)
    local MT = MapTravel
    if (not MT or type(MT) ~= 'table') and modules and modules.game_MapTravel then
        MT = modules.game_MapTravel
        -- propagate for legacy callers
        MapTravel = MapTravel or MT
    end

    if not MT or type(MT) ~= 'table' then
            print('[Minimap] MapTravel module not found')
            return
    end

    -- Initialize if not already
    if (not MT.UI) and MT.init then
        print('[Minimap] Initializing MapTravel module')
        pcall(MT.init)
    end
    if (not MT.UI) and MT.onGameStart and g_game.isOnline() then
        print('[Minimap] Calling MapTravel.onGameStart to build UI')
        pcall(MT.onGameStart)
    end

    -- Re-resolve MT after init in case the module exported itself under modules.game_MapTravel
    if modules and modules.game_MapTravel then
        MT = modules.game_MapTravel
        MapTravel = MapTravel or MT
    end

    -- Do not toggle/close; always ensure it is shown in view-only mode

    MT.viewOnly = true
    if g_game.isOnline() then
        if MT.updateMap then MT.updateMap() else print('[Minimap] MapTravel.updateMap missing') end
        if MT.UI and MT.UI.viewOnlyBadge and MT.UI.viewOnlyBadge.setVisible then
            MT.UI.viewOnlyBadge:setVisible(true)
        end
        if MT.show then
            print('[Minimap] Calling MapTravel.show()')
            MT.show()
        else
            print('[Minimap] MapTravel.show missing')
        end
    else
        print('[Minimap] Not online; skipping open')
    end
end

function extendedView(extendedView)
 
end

function toggle()
    if iconTopMenu:isOn() then
        mapController.ui:hide()
        iconTopMenu:setOn(false)
    else
        mapController.ui:show()
        iconTopMenu:setOn(true)
    end
end
