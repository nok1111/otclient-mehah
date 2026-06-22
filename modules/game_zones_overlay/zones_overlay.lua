--[[
  game_zones_overlay
  Loads /things/zones.dat (binary, produced by RME-ZONES "Export Zones Overlay")
  and overlays the painted zones onto the in-game minimap.
  Toggle: button placed next to the Map button in the minimap controls bar.
]]

ZonesOverlay = {}
-- Expose toggle/reload/hideZone/showZone at the module table level so other sandboxed modules
-- can call modules.game_zones_overlay.toggle(), hideZone(id), showZone(id)
local _M = _G or _ENV
local function exportApi()
    if not modules or not modules.game_zones_overlay then return end
    modules.game_zones_overlay.toggle = function() ZonesOverlay.toggle() end
    modules.game_zones_overlay.reload = function() ZonesOverlay.reload() end
    modules.game_zones_overlay.hideZone = function(id) ZonesOverlay.hideZone(id) end
    modules.game_zones_overlay.showZone = function(id) ZonesOverlay.showZone(id) end
end

function ZonesOverlay.hideZone(id)
    HIDDEN_ZONE_IDS[id] = true
    if ZonesOverlay.enabled then rebuildOverlay() end
end

function ZonesOverlay.showZone(id)
    HIDDEN_ZONE_IDS[id] = nil
    if ZonesOverlay.enabled then rebuildOverlay() end
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

-- Performance settings
local REBUILD_INTERVAL_MS = 250     -- throttle overlay rebuilds (minimap camera scrolls frequently)
local MAX_FILL_WIDGETS = 500        -- cap on colored fill rectangles (zones)
local MAX_EDGE_WIDGETS = 200        -- cap on border line widgets
local ENABLE_BORDERS = true         -- global kill-switch for border rendering

-- Zones that should never be rendered (by ID)
local HIDDEN_ZONE_IDS = {
    [95] = true,
}

-- Active / inactive zone visuals
local ACTIVE_ZONE_PALETTE = {
    { 255, 215, 0   }, -- gold
    { 255, 80, 80   }, -- red
    { 50, 255, 50   }, -- lime
    { 0, 255, 255   }, -- cyan
    { 255, 0, 255   }, -- magenta
    { 255, 165, 0   }, -- orange
    { 160, 32, 240  }, -- purple
    { 30, 144, 255  }, -- blue
}
local ACTIVE_FILL_ALPHA = 0.45            -- player is inside this zone
local INACTIVE_FILL_ALPHA = 0.18          -- other visible zones are dimmed
local ACTIVE_BORDER_ALPHA = 0.0
local INACTIVE_BORDER_ALPHA = 0.0

ZonesOverlay.enabled = false
ZonesOverlay.zones = {}         -- [id] = { id, color = {r,g,b}, rects = { {x,y,z,w,h}, ... } }
ZonesOverlay.zoneNames = {}     -- [id] = "Zone Display Name"
ZonesOverlay.overlayWidget = nil
ZonesOverlay.toggleButton = nil
ZonesOverlay.connectedEvents = false

-- Widget pool to avoid destroying/recreating every frame
ZonesOverlay._widgetPool = {}  -- { fills = {widget...}, edges = {widget...} }
ZonesOverlay._activeZoneWidgets = {} -- [zoneId] = { fill=widget, edges={widget...} }
ZonesOverlay._lastRebuildKey = ''
ZonesOverlay._nextRebuildTime = 0
ZonesOverlay._visibleFills = 0
ZonesOverlay._visibleEdges = 0

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

local function getActiveZoneIds(sets, playerPos)
    local active = {}
    if not playerPos then return active end
    local key = playerPos.x * 65536 + playerPos.y
    for zoneId, byFloor in pairs(sets) do
        local fmap = byFloor[playerPos.z]
        if fmap and fmap[key] then
            active[zoneId] = true
        end
    end
    return active
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

local function recycleWidget(widget, kind)
    if not widget or widget:isDestroyed() then return end
    widget:hide()
    widget:setTooltip(nil)
    local pool = ZonesOverlay._widgetPool[kind]
    if not pool then
        pool = {}; ZonesOverlay._widgetPool[kind] = pool
    end
    pool[#pool + 1] = widget
end

local function acquireWidget(kind, parent)
    local pool = ZonesOverlay._widgetPool[kind]
    if pool and #pool > 0 then
        local widget = table.remove(pool)
        widget:show()
        return widget
    end
    return g_ui.createWidget('UIWidget', parent)
end

local function releaseZoneWidgets(zoneId)
    local group = ZonesOverlay._activeZoneWidgets[zoneId]
    if not group then return end
    if group.fills then
        for _, f in ipairs(group.fills) do
            recycleWidget(f, 'fills')
        end
    end
    if group.edges then
        for _, e in ipairs(group.edges) do
            recycleWidget(e, 'edges')
        end
    end
    ZonesOverlay._activeZoneWidgets[zoneId] = nil
end

local function clearOverlayChildren()
    -- Recycle instead of destroy so rebuilds reuse existing widgets.
    for zoneId, _ in pairs(ZonesOverlay._activeZoneWidgets) do
        releaseZoneWidgets(zoneId)
    end
    ZonesOverlay._visibleFills = 0
    ZonesOverlay._visibleEdges = 0
end

local function destroyAllOverlayWidgets()
    -- Full cleanup used on terminate or when we want to reset everything.
    clearOverlayChildren()
    for _, widget in ipairs(ZonesOverlay._widgetPool.fills or {}) do
        if not widget:isDestroyed() then widget:destroy() end
    end
    for _, widget in ipairs(ZonesOverlay._widgetPool.edges or {}) do
        if not widget:isDestroyed() then widget:destroy() end
    end
    ZonesOverlay._widgetPool = {}
end

local function colorToString(r, g, b, alpha)
    local a = math.floor((alpha or 1.0) * 255 + 0.5)
    return string.format('#%02x%02x%02x%02x', r, g, b, a)
end

local function positionWidget(widget, px, py, pw, ph, rect)
    if not widget._zo_anchored then
        widget:breakAnchors()
        widget:addAnchor(AnchorTop, 'parent', AnchorTop)
        widget:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        widget._zo_anchored = true
    end
    widget:setMarginTop(py - rect.y)
    widget:setMarginLeft(px - rect.x)
    widget:setSize({ width = math.max(1, math.floor(pw + 0.5)), height = math.max(1, math.floor(ph + 0.5)) })
end

local function emitFill(px, py, pw, ph, fillCol, label, overlay, rect)
    if ZonesOverlay._visibleFills >= MAX_FILL_WIDGETS then return nil end
    local widget = acquireWidget('fills', overlay)
    widget:setPhantom(false)
    widget:setBackgroundColor(fillCol)
    widget:setTooltip(label)
    positionWidget(widget, px, py, pw, ph, rect)
    ZonesOverlay._visibleFills = ZonesOverlay._visibleFills + 1
    return widget
end

local function emitEdge(px, py, pw, ph, borderCol, overlay, rect, group)
    if ZonesOverlay._visibleEdges >= MAX_EDGE_WIDGETS then return nil end
    local widget = acquireWidget('edges', overlay)
    widget:setPhantom(true)
    widget:setBackgroundColor(borderCol)
    widget:setTooltip(nil)
    positionWidget(widget, px, py, pw, ph, rect)
    ZonesOverlay._visibleEdges = ZonesOverlay._visibleEdges + 1
    if group then
        group.edges[#group.edges + 1] = widget
    end
    return widget
end

local function emitSimpleBorder(rx1, ry1, rx2, ry2, floor, borderCol, half, pxPerTile, borderPx, overlay, rect, mm, group)
    local tlc = mm:getTilePoint({ x = rx1, y = ry1, z = floor })
    local brc = mm:getTilePoint({ x = rx2, y = ry2, z = floor })
    if not tlc or not brc or tlc.x < 0 or brc.x < 0 then return 0 end
    local px = tlc.x - half
    local py = tlc.y - half
    local pw = (brc.x - tlc.x) + pxPerTile
    local ph = (brc.y - tlc.y) + pxPerTile
    local edgeW = math.max(1, math.floor(pw + 0.5))
    local edgeH = math.max(1, math.floor(ph + 0.5))
    local count = 0
    -- top
    if emitEdge(px, py, edgeW, borderPx, borderCol, overlay, rect, group) then count = count + 1 end
    -- bottom
    if emitEdge(px, py + ph - borderPx, edgeW, borderPx, borderCol, overlay, rect, group) then count = count + 1 end
    -- left
    if emitEdge(px, py, borderPx, edgeH, borderCol, overlay, rect, group) then count = count + 1 end
    -- right
    if emitEdge(px + pw - borderPx, py, borderPx, edgeH, borderCol, overlay, rect, group) then count = count + 1 end
    return count
end

local function currentTimeMs()
    if g_clock and g_clock.millis then
        return g_clock.millis()
    end
    return math.floor(os.time() * 1000)
end

local function rebuildOverlay()
    local now = currentTimeMs()
    if now < ZonesOverlay._nextRebuildTime then return end
    ZonesOverlay._nextRebuildTime = now + REBUILD_INTERVAL_MS

    local mm = getMinimapWidget()
    if not mm then return end
    if not ZonesOverlay.enabled then
        if ZonesOverlay.overlayWidget and not ZonesOverlay.overlayWidget:isDestroyed() then
            ZonesOverlay.overlayWidget:hide()
        end
        return
    end

    local player = g_game.getLocalPlayer()
    if not player then return end
    local camPos = mm.getCameraPosition and mm:getCameraPosition() or player:getPosition()
    if not camPos then return end
    local floor = camPos.z
    local zoom = mm:getZoom() or 1
    local key = string.format('%d,%d,%d,%.3f', camPos.x, camPos.y, floor, zoom)
    if key == ZonesOverlay._lastRebuildKey then return end
    ZonesOverlay._lastRebuildKey = key

    local okOv, ovErr = pcall(ensureOverlayWidget, mm)
    if not okOv then print('[ZonesOverlay] ensureOverlayWidget error: ' .. tostring(ovErr)); return end
    local overlay = ZonesOverlay.overlayWidget
    if not overlay then return end
    overlay:show()
    ZonesOverlay._visibleFills = 0
    ZonesOverlay._visibleEdges = 0

    -- Determine visible map area in tile coordinates.
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
    local areaTiles = (maxX - minX + 1) * (maxY - minY + 1)
    if areaTiles > 40000 then
        -- Too far zoomed out: hide everything.
        clearOverlayChildren()
        return
    end

    local sets = buildTileSets()
    local playerPos = player and player:getPosition() or nil
    local activeZoneIds = getActiveZoneIds(sets, playerPos)
    -- Build a deterministic index per active zone so overlapping active zones get slightly different gold shades.
    local activeZoneIndex = {}
    local activeList = {}
    for zoneId, _ in pairs(activeZoneIds) do
        activeZoneIndex[zoneId] = #activeList + 1
        activeList[#activeList + 1] = zoneId
    end
    local function activeZoneColor(zoneId)
        local idx = activeZoneIndex[zoneId] or 1
        local color = ACTIVE_ZONE_PALETTE[((idx - 1) % #ACTIVE_ZONE_PALETTE) + 1]
        -- Slightly vary the color if we have more active zones than palette entries.
        local cycle = math.floor((idx - 1) / #ACTIVE_ZONE_PALETTE)
        local shift = cycle * 25
        return { math.min(255, color[1] + shift), math.min(255, color[2] + shift), math.min(255, color[3] + shift) }
    end

    local scale = mm:getScale() or 1
    local pxPerTile = math.max(1, math.floor(scale + 0.5))
    local borderPx = 1
    local half = math.max(1, math.floor(pxPerTile / 2))
    local labelFallbackFmt = 'Zone %d'

    -- Track which zones are still visible so we can recycle unused ones.
    local desiredZones = {}

    for _, zone in pairs(ZonesOverlay.zones) do
        if HIDDEN_ZONE_IDS[zone.id] then
            desiredZones[zone.id] = false
        else
            local isActive = activeZoneIds[zone.id] == true
            local color = isActive and activeZoneColor(zone.id) or zone.color
            local fillAlpha = isActive and ACTIVE_FILL_ALPHA or INACTIVE_FILL_ALPHA
            local borderAlpha = isActive and ACTIVE_BORDER_ALPHA or INACTIVE_BORDER_ALPHA
            local fillCol = colorToString(color[1], color[2], color[3], fillAlpha)
            local borderCol = colorToString(color[1], color[2], color[3], borderAlpha)
            local label = nil
            if isActive then
                local idx = activeZoneIndex[zone.id] or 1
                local base = ZonesOverlay.zoneNames[zone.id] or string.format(labelFallbackFmt, zone.id)
                label = string.format('%s (active #%d)', base, idx)
            end

            -- Collect visible rectangles for this zone.
            local visibleRects = {}
            for _, rc in ipairs(zone.rects) do
                if rc.z == floor and rc.w <= MAX_DRAW_TILES_W and rc.h <= MAX_DRAW_TILES_H then
                    local rx1, ry1 = rc.x, rc.y
                    local rx2, ry2 = rc.x + rc.w - 1, rc.y + rc.h - 1
                    if rx2 >= minX and rx1 <= maxX and ry2 >= minY and ry1 <= maxY then
                        visibleRects[#visibleRects + 1] = rc
                    end
                end
            end

            if #visibleRects == 0 then
                desiredZones[zone.id] = false
            else
                desiredZones[zone.id] = true
                local group = ZonesOverlay._activeZoneWidgets[zone.id]
                if not group then
                    group = { fills = {}, edges = {} }
                    ZonesOverlay._activeZoneWidgets[zone.id] = group
                end

                -- Recycle leftover fill widgets from previous frame; we'll reacquire exactly what we need.
                for _, f in ipairs(group.fills) do
                    recycleWidget(f, 'fills')
                end
                group.fills = {}

                -- Render fills. One widget per visible rectangle.
                for _, rc in ipairs(visibleRects) do
                    local rx1, ry1 = rc.x, rc.y
                    local rx2, ry2 = rc.x + rc.w - 1, rc.y + rc.h - 1
                    local tlc = mm:getTilePoint({ x = rx1, y = ry1, z = floor })
                    local brc = mm:getTilePoint({ x = rx2, y = ry2, z = floor })
                    if tlc and brc and tlc.x >= 0 and brc.x >= 0 then
                        local px = tlc.x - half
                        local py = tlc.y - half
                        local pw = (brc.x - tlc.x) + pxPerTile
                        local ph = (brc.y - tlc.y) + pxPerTile
                        if pw >= 1 and ph >= 1 then
                            local fill = emitFill(px, py, pw, ph, fillCol, label, overlay, rect)
                            if fill then
                                group.fills[#group.fills + 1] = fill
                            end
                        end
                    end
                end

                -- Recycle leftover edge widgets before drawing new ones.
                for _, e in ipairs(group.edges) do
                    recycleWidget(e, 'edges')
                end
                group.edges = {}

                -- Borders: single bounding box around the whole visible zone area.
                if ENABLE_BORDERS and pxPerTile >= 2 and #visibleRects > 0 then
                    local bx1, by1 = visibleRects[1].x, visibleRects[1].y
                    local bx2, by2 = visibleRects[1].x + visibleRects[1].w - 1, visibleRects[1].y + visibleRects[1].h - 1
                    for i = 2, #visibleRects do
                        local rc = visibleRects[i]
                        local rx1, ry1 = rc.x, rc.y
                        local rx2, ry2 = rc.x + rc.w - 1, rc.y + rc.h - 1
                        if rx1 < bx1 then bx1 = rx1 end
                        if ry1 < by1 then by1 = ry1 end
                        if rx2 > bx2 then bx2 = rx2 end
                        if ry2 > by2 then by2 = ry2 end
                    end
                    emitSimpleBorder(bx1, by1, bx2, by2, floor, borderCol, half, pxPerTile, borderPx, overlay, rect, mm, group)
                end
            end
        end
    end

    -- Recycle widgets from zones that are no longer visible on this floor/viewport.
    for zoneId, group in pairs(ZonesOverlay._activeZoneWidgets) do
        if not desiredZones[zoneId] then
            releaseZoneWidgets(zoneId)
        end
    end

    if ZonesOverlay._visibleFills >= MAX_FILL_WIDGETS or ZonesOverlay._visibleEdges >= MAX_EDGE_WIDGETS then
        print(string.format('[ZonesOverlay] hit caps: fills=%d/%d edges=%d/%d', ZonesOverlay._visibleFills, MAX_FILL_WIDGETS, ZonesOverlay._visibleEdges, MAX_EDGE_WIDGETS))
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
        clearOverlayChildren()
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
        rebuildOverlay()
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
    destroyAllOverlayWidgets()
    if ZonesOverlay.overlayWidget and not ZonesOverlay.overlayWidget:isDestroyed() then
        ZonesOverlay.overlayWidget:destroy()
    end
    ZonesOverlay.overlayWidget = nil
    ZonesOverlay._activeZoneWidgets = {}
    ZonesOverlay._widgetPool = {}
    ZonesOverlay._visibleFills = 0
    ZonesOverlay._visibleEdges = 0
    if ZonesOverlay.connectedEvents then
        disconnect(LocalPlayer, { onPositionChange = onMinimapChanged })
        disconnect(g_game, { onGameStart = onMinimapChanged, onTeleport = onMinimapChanged })
        ZonesOverlay.connectedEvents = false
    end
    ZonesOverlay.zones = {}
end
