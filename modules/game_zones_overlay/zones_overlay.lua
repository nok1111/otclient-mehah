--[[
  game_zones_overlay
  Loads /things/zones.dat (binary, produced by RME-ZONES "Export Zones Overlay")
  and overlays the painted zones onto the in-game minimap.
  Toggle: button placed next to the Map button in the minimap controls bar.
]]

ZonesOverlay = {}
-- Expose toggle/reload at the module table level so other sandboxed modules
-- can call modules.game_zones_overlay.toggle()
local _M = _G or _ENV
local function exportApi()
    if not modules or not modules.game_zones_overlay then return end
    modules.game_zones_overlay.toggle = function() ZonesOverlay.toggle() end
    modules.game_zones_overlay.reload = function() ZonesOverlay.reload() end
end

local ZONES_FILE_CANDIDATES = {
    '/things/1098/zones.dat',
    '/things/zones.dat',
    '/data/things/1098/zones.dat',
    '/data/things/zones.dat',
    '/zones.dat',
}
local ZONES_NAMES_CANDIDATES = {
    '/things/1098/zones.lua',
    '/things/zones.lua',
    '/data/things/1098/zones.lua',
    '/data/things/zones.lua',
    '/zones.lua',
}
local DEFAULT_ALPHA = 0.35      -- fill opacity
local BORDER_ALPHA  = 0.85      -- border opacity
local MAX_DRAW_TILES_W = 96     -- safety cap: don't spawn widgets if rect bbox is huge in tiles
local MAX_DRAW_TILES_H = 96

ZonesOverlay.enabled = false
ZonesOverlay.zones = {}         -- [id] = { id, color = {r,g,b}, rects = { {x,y,z,w,h}, ... } }
ZonesOverlay.zoneNames = {}     -- [id] = "Zone Display Name"
ZonesOverlay.overlayWidget = nil
ZonesOverlay.toggleButton = nil
ZonesOverlay.lastCameraPos = nil
ZonesOverlay.connectedEvents = false

------------------------------------------------------------
-- Binary reader
------------------------------------------------------------
local function makeReader(data)
    local pos = 1
    local len = #data
    local r = {}
    function r:remaining() return len - pos + 1 end
    function r:u8()
        if pos > len then return nil end
        local b = string.byte(data, pos); pos = pos + 1; return b
    end
    function r:u16()
        if pos + 1 > len then return nil end
        local b1, b2 = string.byte(data, pos, pos + 1); pos = pos + 2
        return b1 + b2 * 256
    end
    function r:u32()
        if pos + 3 > len then return nil end
        local b1, b2, b3, b4 = string.byte(data, pos, pos + 3); pos = pos + 4
        return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
    end
    function r:bytes(n)
        if pos + n - 1 > len then return nil end
        local s = string.sub(data, pos, pos + n - 1); pos = pos + n; return s
    end
    return r
end

-- Pattern-parse the server's zones.lua to extract zone names.
-- Heuristic: when a top-level entry "[N] = {" is found, the FIRST
-- 'name = "X"' that follows (before any deeper structures) is taken
-- as the zone display name. This matches the structure of the TFS
-- zones.lua in this project.
function ZonesOverlay.loadNames()
    ZonesOverlay.zoneNames = {}
    local foundPath
    for _, p in ipairs(ZONES_NAMES_CANDIDATES) do
        if g_resources.fileExists(p) then foundPath = p; break end
    end
    if not foundPath then
        print('[ZonesOverlay] zones.lua not found (names disabled). Tried:')
        for _, p in ipairs(ZONES_NAMES_CANDIDATES) do print('  ' .. p) end
        return false
    end
    local ok, data = pcall(g_resources.readFileContents, foundPath)
    if not ok or not data then return false end

    local count = 0
    local currentId, captured = nil, true
    for line in data:gmatch('([^\r\n]+)') do
        local idMatch = line:match('^%s*%[(%d+)%]%s*=%s*{')
        if idMatch then
            currentId = tonumber(idMatch)
            captured = false
        elseif currentId and not captured then
            local nm = line:match('^%s*name%s*=%s*"([^"]+)"')
            if nm then
                ZonesOverlay.zoneNames[currentId] = nm
                captured = true
                count = count + 1
            end
        end
    end
    print(string.format('[ZonesOverlay] loaded %d zone names from %s', count, foundPath))
    return true
end

function ZonesOverlay.loadFile()
    ZonesOverlay.zones = {}
    local foundPath
    for _, p in ipairs(ZONES_FILE_CANDIDATES) do
        if g_resources.fileExists(p) then foundPath = p; break end
    end
    if not foundPath then
        print('[ZonesOverlay] zones.dat not found. Tried:')
        for _, p in ipairs(ZONES_FILE_CANDIDATES) do print('  ' .. p) end
        if g_resources.getWriteDir then
            print('[ZonesOverlay] writeDir = ' .. tostring(g_resources.getWriteDir()))
        end
        if g_resources.getSearchPaths then
            local paths = g_resources.getSearchPaths() or {}
            print('[ZonesOverlay] search paths:')
            for _, sp in ipairs(paths) do print('  ' .. tostring(sp)) end
        end
        return false
    end
    local ok, data = pcall(g_resources.readFileContents, foundPath)
    if not ok or not data or #data < 8 then
        print('[ZonesOverlay] failed to read or file too small at ' .. foundPath)
        return false
    end
    print('[ZonesOverlay] reading ' .. foundPath .. ' (' .. #data .. ' bytes)')

    local r = makeReader(data)
    local magic = r:bytes(4)
    if magic ~= 'ZONO' then
        print('[ZonesOverlay] invalid magic header: ' .. tostring(magic))
        return false
    end
    local version = r:u16()
    if version ~= 1 then
        print('[ZonesOverlay] unsupported version: ' .. tostring(version))
        return false
    end
    local zoneCount = r:u16()
    local totalRects = 0
    for i = 1, zoneCount do
        local id = r:u16()
        local cr = r:u8()
        local cg = r:u8()
        local cb = r:u8()
        local rectCount = r:u32()
        local rects = {}
        for j = 1, rectCount do
            local x = r:u16()
            local y = r:u16()
            local z = r:u8()
            local w = r:u16()
            local h = r:u16()
            rects[#rects + 1] = { x = x, y = y, z = z, w = w, h = h }
        end
        totalRects = totalRects + rectCount
        ZonesOverlay.zones[id] = { id = id, color = { cr, cg, cb }, rects = rects }
    end
    print(string.format('[ZonesOverlay] loaded %d zones, %d rectangles', zoneCount, totalRects))
    ZonesOverlay._tileSets = nil
    return true
end

-- Build per-zone, per-floor tile lookup so we can detect zone boundaries.
-- Key per tile is (x * 65536 + y) for fast hash access.
local function buildTileSets()
    if ZonesOverlay._tileSets then return ZonesOverlay._tileSets end
    local sets = {}
    for id, zone in pairs(ZonesOverlay.zones) do
        local byFloor = {}
        for _, rc in ipairs(zone.rects) do
            local fmap = byFloor[rc.z]
            if not fmap then fmap = {}; byFloor[rc.z] = fmap end
            local x2 = rc.x + rc.w - 1
            local y2 = rc.y + rc.h - 1
            for ty = rc.y, y2 do
                local row = ty
                for tx = rc.x, x2 do
                    fmap[tx * 65536 + row] = true
                end
            end
        end
        sets[id] = byFloor
    end
    ZonesOverlay._tileSets = sets
    return sets
end

------------------------------------------------------------
-- Minimap integration
------------------------------------------------------------
local function getMinimapWidget()
    -- Cross-sandbox access: minimap module exposes getMiniMapUi() via its env.
    local mm
    if modules and modules.game_minimap and modules.game_minimap.getMiniMapUi then
        local ok, w = pcall(modules.game_minimap.getMiniMapUi)
        if ok then mm = w end
    end
    if mm and not mm:isDestroyed() then return mm end
    -- Fallback: walk root widget
    local root = rootWidget or g_ui.getRootWidget()
    if root then
        local function find(widget)
            if not widget then return nil end
            if widget.getId and widget:getId() == 'minimap' and widget.getTileRect then
                return widget
            end
            if widget.getChildren then
                for _, c in ipairs(widget:getChildren()) do
                    local r = find(c)
                    if r then return r end
                end
            end
            return nil
        end
        return find(root)
    end
    return nil
end

local function ensureOverlayWidget(mm)
    if ZonesOverlay.overlayWidget and not ZonesOverlay.overlayWidget:isDestroyed() then
        return ZonesOverlay.overlayWidget
    end
    -- Overlay is a child of UIMinimap. UIWidget::draw paints drawSelf (minimap
    -- tiles) first, then drawChildren, so children render on top. We enable
    -- clipping so rectangles that fall outside the minimap area are cut.
    local w = g_ui.createWidget('UIWidget', mm)
    w:setId('zonesOverlay')
    w:setPhantom(true)
    w:setBackgroundColor('alpha')
    w:setFocusable(false)
    w:fill('parent')
    w:setClipping(true)
    ZonesOverlay.overlayWidget = w
    return w
end

local function clearOverlayChildren()
    local w = ZonesOverlay.overlayWidget
    if not w or w:isDestroyed() then return end
    w:destroyChildren()
end

local function colorToString(r, g, b, alpha)
    local a = math.floor((alpha or 1.0) * 255 + 0.5)
    return string.format('#%02x%02x%02x%02x', r, g, b, a)
end

local function rebuildOverlay()
    local mm = getMinimapWidget()
    if not mm then print('[ZonesOverlay] rebuild: no minimap widget'); return end
    if not ZonesOverlay.enabled then
        if ZonesOverlay.overlayWidget and not ZonesOverlay.overlayWidget:isDestroyed() then
            ZonesOverlay.overlayWidget:hide()
        end
        return
    end

    local player = g_game.getLocalPlayer()
    if not player then print('[ZonesOverlay] rebuild: no local player'); return end
    local camPos = mm.getCameraPosition and mm:getCameraPosition() or player:getPosition()
    if not camPos then print('[ZonesOverlay] rebuild: no camera pos'); return end
    local floor = camPos.z

    local okOv, ovErr = pcall(ensureOverlayWidget, mm)
    if not okOv then print('[ZonesOverlay] ensureOverlayWidget error: ' .. tostring(ovErr)); return end
    local overlay = ZonesOverlay.overlayWidget
    if not overlay then return end
    overlay:show()
    clearOverlayChildren()
    local drawn = 0

    -- Determine visible map area in tile coordinates using top-left & bottom-right widget points.
    local rect = mm:getPaddingRect()
    if not rect then rect = mm:getRect() end
    local topLeftTile = mm:getTilePosition({ x = rect.x, y = rect.y })
    local botRightTile = mm:getTilePosition({ x = rect.x + rect.width - 1, y = rect.y + rect.height - 1 })
    if not topLeftTile or not botRightTile then
        topLeftTile = { x = camPos.x - 50, y = camPos.y - 50, z = floor }
        botRightTile = { x = camPos.x + 50, y = camPos.y + 50, z = floor }
    end
    local minX = math.min(topLeftTile.x, botRightTile.x) - 1
    local maxX = math.max(topLeftTile.x, botRightTile.x) + 1
    local minY = math.min(topLeftTile.y, botRightTile.y) - 1
    local maxY = math.max(topLeftTile.y, botRightTile.y) + 1
    -- Hard cap on visible area to avoid runaway widget spawn at extreme zoom-out.
    local areaTiles = (maxX - minX + 1) * (maxY - minY + 1)
    if areaTiles > 40000 then
        -- Too far zoomed out: don't render anything.
        return
    end

    local sets = buildTileSets()
    local scale = mm:getScale() or 1
    local pxPerTile = math.max(1, math.floor(scale + 0.5))
    local borderPx = 1

    local function emitFill(px, py, pw, ph, fillCol)
        local widget = g_ui.createWidget('UIWidget', overlay)
        -- Not phantom: needs to receive hover for tooltip.
        widget:setBackgroundColor(fillCol)
        widget:breakAnchors()
        widget:addAnchor(AnchorTop, 'parent', AnchorTop)
        widget:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        widget:setMarginTop(py - rect.y)
        widget:setMarginLeft(px - rect.x)
        widget:setSize({ width = pw, height = ph })
        return widget
    end

    local function emitEdge(px, py, pw, ph, borderCol)
        local widget = g_ui.createWidget('UIWidget', overlay)
        widget:setPhantom(true)
        widget:setBackgroundColor(borderCol)
        widget:breakAnchors()
        widget:addAnchor(AnchorTop, 'parent', AnchorTop)
        widget:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        widget:setMarginTop(py - rect.y)
        widget:setMarginLeft(px - rect.x)
        widget:setSize({ width = math.max(1, pw), height = math.max(1, ph) })
        return widget
    end

    for _, zone in pairs(ZonesOverlay.zones) do
        local color = zone.color
        local fillCol = colorToString(color[1], color[2], color[3], DEFAULT_ALPHA)
        local borderCol = colorToString(color[1], color[2], color[3], BORDER_ALPHA)
        local zoneFloor = sets[zone.id] and sets[zone.id][floor] or nil
        for _, rc in ipairs(zone.rects) do
            if rc.z == floor and rc.w <= MAX_DRAW_TILES_W and rc.h <= MAX_DRAW_TILES_H then
                -- Intersect rect with visible bbox
                local rx1, ry1 = rc.x, rc.y
                local rx2, ry2 = rc.x + rc.w - 1, rc.y + rc.h - 1
                if rx2 >= minX and rx1 <= maxX and ry2 >= minY and ry1 <= maxY then
                    -- Use getTilePoint (returns the tile CENTER on screen) plus the
                    -- minimap scale (pixels-per-tile). getTileRect can't be used because
                    -- it returns a sprite-sized rect (32*scale), not minimap-tile-sized.
                    local tlc = mm:getTilePoint({ x = rx1, y = ry1, z = floor })
                    local brc = mm:getTilePoint({ x = rx2, y = ry2, z = floor })
                    local scale = mm:getScale() or 1
                    if tlc and brc and tlc.x >= 0 and brc.x >= 0 then
                        local half = math.max(1, math.floor(pxPerTile / 2))
                        local px = tlc.x - half
                        local py = tlc.y - half
                        local pw = (brc.x - tlc.x) + pxPerTile
                        local ph = (brc.y - tlc.y) + pxPerTile
                        if pw >= 1 and ph >= 1 then
                            local label = ZonesOverlay.zoneNames[zone.id] or string.format('Zone %d', zone.id)
                            emitFill(px, py, pw, ph, fillCol):setTooltip(label)
                            drawn = drawn + 1

                            -- Outline only the tiles whose outward neighbor isn't in this zone.
                            -- Coalesce contiguous boundary tiles into a single widget for perf.
                            -- Skip entirely when each tile is sub-pixel (zoomed out far).
                            if zoneFloor and pxPerTile >= 2 then
                                local function inZone(tx, ty) return zoneFloor[tx * 65536 + ty] == true end

                                -- Helper: emit a horizontal segment that spans tiles [tx1..tx2] on row ty
                                local function emitH(tx1, tx2, ty, isTop)
                                    local pa = mm:getTilePoint({ x = tx1, y = ty, z = floor })
                                    local pb = mm:getTilePoint({ x = tx2, y = ty, z = floor })
                                    if not pa or not pb or pa.x < 0 or pb.x < 0 then return end
                                    local x = pa.x - half
                                    local y = pa.y - half + (isTop and 0 or (pxPerTile - borderPx))
                                    local w = (pb.x - pa.x) + pxPerTile
                                    emitEdge(x, y, w, borderPx, borderCol)
                                end
                                local function emitV(ty1, ty2, tx, isLeft)
                                    local pa = mm:getTilePoint({ x = tx, y = ty1, z = floor })
                                    local pb = mm:getTilePoint({ x = tx, y = ty2, z = floor })
                                    if not pa or not pb or pa.x < 0 or pb.x < 0 then return end
                                    local x = pa.x - half + (isLeft and 0 or (pxPerTile - borderPx))
                                    local y = pa.y - half
                                    local h = (pb.y - pa.y) + pxPerTile
                                    emitEdge(x, y, borderPx, h, borderCol)
                                end

                                -- Top / Bottom: scan along x, group consecutive missing-neighbor runs
                                local function scanHoriz(ry, neighborY, isTop)
                                    local runStart = nil
                                    for tx = rx1, rx2 + 1 do
                                        local missing = (tx <= rx2) and (not inZone(tx, neighborY))
                                        if missing then
                                            if not runStart then runStart = tx end
                                        elseif runStart then
                                            emitH(runStart, tx - 1, ry, isTop)
                                            runStart = nil
                                        end
                                    end
                                end
                                scanHoriz(ry1, ry1 - 1, true)
                                scanHoriz(ry2, ry2 + 1, false)

                                -- Left / Right: scan along y
                                local function scanVert(rx, neighborX, isLeft)
                                    local runStart = nil
                                    for ty = ry1, ry2 + 1 do
                                        local missing = (ty <= ry2) and (not inZone(neighborX, ty))
                                        if missing then
                                            if not runStart then runStart = ty end
                                        elseif runStart then
                                            emitV(runStart, ty - 1, rx, isLeft)
                                            runStart = nil
                                        end
                                    end
                                end
                                scanVert(rx1, rx1 - 1, true)
                                scanVert(rx2, rx2 + 1, false)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function onMinimapChanged()
    if ZonesOverlay.enabled then
        rebuildOverlay()
    end
end

------------------------------------------------------------
-- Toggle button injection
------------------------------------------------------------
local function addToggleButton()
    -- Button is declared in game_minimap/minimap.otui and triggers our toggle.
    -- We just locate it to update its checked state.
    if ZonesOverlay.toggleButton and not ZonesOverlay.toggleButton:isDestroyed() then
        return
    end
    local mm = getMinimapWidget()
    if not mm then return end
    local border = mm:getParent()
    if not border then return end
    local panel = border:getParent()
    if not panel then return end
    local controls = panel:getChildById('controls')
    if not controls then return end
    local mapBtn = controls:getChildById('mapButton')
    if mapBtn then
        mapBtn:setTooltip('Toggle zone overlay')
        ZonesOverlay.toggleButton = mapBtn
    end
end

function ZonesOverlay.toggle()
    ZonesOverlay.enabled = not ZonesOverlay.enabled
    print('[ZonesOverlay] toggle -> ' .. tostring(ZonesOverlay.enabled))
    if ZonesOverlay.toggleButton and not ZonesOverlay.toggleButton:isDestroyed() then
        ZonesOverlay.toggleButton:setChecked(ZonesOverlay.enabled)
    end
    if ZonesOverlay.enabled then
        if not next(ZonesOverlay.zones) then
            ZonesOverlay.loadFile()
        end
        rebuildOverlay()
    else
        if ZonesOverlay.overlayWidget and not ZonesOverlay.overlayWidget:isDestroyed() then
            ZonesOverlay.overlayWidget:hide()
        end
    end
end

function ZonesOverlay.reload()
    ZonesOverlay.loadFile()
    if ZonesOverlay.enabled then rebuildOverlay() end
end

------------------------------------------------------------
-- Lifecycle
------------------------------------------------------------
local function tickRefresh()
    if not ZonesOverlay.connectedEvents then return end
    if ZonesOverlay.enabled then
        local mm = getMinimapWidget()
        if mm then
            local cam = mm:getCameraPosition()
            local zoom = mm:getZoom()
            local key = cam and (cam.x .. ',' .. cam.y .. ',' .. cam.z .. ',' .. zoom) or ''
            if key ~= ZonesOverlay._lastKey then
                ZonesOverlay._lastKey = key
                rebuildOverlay()
            end
        end
    end
    scheduleEvent(tickRefresh, 250)
end

local function tryWireUp()
    addToggleButton()
    if not ZonesOverlay.connectedEvents then
        connect(LocalPlayer, { onPositionChange = onMinimapChanged })
        connect(g_game, { onGameStart = onMinimapChanged, onTeleport = onMinimapChanged })
        ZonesOverlay.connectedEvents = true
        scheduleEvent(tickRefresh, 250)
    end
end

function ZonesOverlay.init()
    exportApi()
    ZonesOverlay.loadFile()
    ZonesOverlay.loadNames()
    -- Defer UI wiring until minimap module is loaded.
    scheduleEvent(tryWireUp, 200)
    scheduleEvent(tryWireUp, 1000)
end

function ZonesOverlay.terminate()
    -- toggleButton is the existing Map button; do not destroy it, just unhook.
    if ZonesOverlay.toggleButton and not ZonesOverlay.toggleButton:isDestroyed() then
        ZonesOverlay.toggleButton.onClick = nil
    end
    ZonesOverlay.toggleButton = nil
    if ZonesOverlay.overlayWidget and not ZonesOverlay.overlayWidget:isDestroyed() then
        ZonesOverlay.overlayWidget:destroy()
    end
    ZonesOverlay.overlayWidget = nil
    if ZonesOverlay.connectedEvents then
        disconnect(LocalPlayer, { onPositionChange = onMinimapChanged })
        disconnect(g_game, { onGameStart = onMinimapChanged, onTeleport = onMinimapChanged })
        ZonesOverlay.connectedEvents = false
    end
    ZonesOverlay.zones = {}
end
