-- Global scale applier used by buttons and wheel.
-- Keeps an image-space anchor point stable instead of re-centering on the
-- player. `focusScreen` (optional, absolute mouse pos) anchors zoom under
-- the cursor; without it the view center is used.
function MapTravel.applyScale(newScale, focusScreen)
    local mapPanel = MapTravel.UI and MapTravel.UI.mapPanel
    local canvas = mapPanel and (mapPanel.mapCanvas or (mapPanel.recursiveGetChildById and mapPanel:recursiveGetChildById('mapCanvas')))
    local oldScale = MapTravel.mapScale or 1.0

    -- Capture the image-space point under the anchor (cursor or view center)
    local fx, fy, ax, ay
    if canvas and not canvas:isDestroyed() then
        local pSize = mapPanel:getSize()
        local pPos = mapPanel:getPosition()
        local cPos = canvas:getPosition()
        local topBarH = (mapPanel.topBar and mapPanel.topBar:getHeight()) or 0
        if focusScreen then
            ax = focusScreen.x - pPos.x
            ay = focusScreen.y - pPos.y
        else
            ax = pSize.width / 2
            ay = topBarH + (pSize.height - topBarH) / 2
        end
        fx = (ax - cPos.x) / oldScale
        fy = (ay - cPos.y) / oldScale
    end

    MapTravel.mapScale = newScale
    MapTravel.applyFiltersAndRedraw()

    -- Re-anchor the same image point under the anchor
    if fx and fy and canvas and not canvas:isDestroyed() then
        local pSize = mapPanel:getSize()
        local cSize = canvas:getSize()
        local topBarH = (mapPanel.topBar and mapPanel.topBar:getHeight()) or 0
        local cx, cy
        if cSize.width > pSize.width then
            cx = math.floor(ax - fx * newScale)
            cx = math.min(0, math.max(cx, pSize.width - cSize.width))
        else
            cx = math.max(0, math.floor((pSize.width - cSize.width) / 2))
        end
        if cSize.height > (pSize.height - topBarH) then
            cy = math.floor(ay - fy * newScale)
            cy = math.min(topBarH, math.max(cy, pSize.height - cSize.height))
        else
            cy = math.floor(topBarH + (pSize.height - topBarH - cSize.height) / 2)
        end
        canvas:breakAnchors()
        canvas:setPosition({x = cx, y = cy})
        MapTravel._canvasPositioned = true
        MapTravel.syncScrollbars(canvas, mapPanel)
    end

    MapTravel.updateZoomLabel()
    if MapTravel._debugLabel then
        MapTravel._debugLabel:setText(string.format("zoom %.2f", newScale))
    end
end

function MapTravel.updateZoomLabel()
    local topBar = MapTravel.UI and MapTravel.UI.mapPanel and MapTravel.UI.mapPanel.topBar
    local zl = topBar and (topBar.zoomLabel or (topBar.recursiveGetChildById and topBar:recursiveGetChildById('zoomLabel')))
    if zl then
        zl:setText(string.format("%d%%", math.floor((MapTravel.mapScale or 1.0) * 100 + 0.5)))
    end
    MapTravel.syncRailThumb()
end

-- Left rail helpers
function MapTravel.getRailWidgets()
    local mapPanel = MapTravel.UI and MapTravel.UI.mapPanel
    local rail = mapPanel and (mapPanel.leftRail or (mapPanel.recursiveGetChildById and mapPanel:recursiveGetChildById('leftRail')))
    if not rail then return {} end
    local function child(id)
        return rail[id] or (rail.recursiveGetChildById and rail:recursiveGetChildById(id))
    end
    local track = child('railZoomTrack')
    return {
        rail   = rail,
        zoomIn = child('railZoomIn'),
        zoomOut = child('railZoomOut'),
        track  = track,
        thumb  = track and (track.railZoomThumb or (track.recursiveGetChildById and track:recursiveGetChildById('railZoomThumb'))),
        tMon   = child('railToggleMonsters'),
        tZone  = child('railToggleZones'),
        tUG    = child('railToggleUG'),
    }
end

function MapTravel.syncRailThumb()
    local R = MapTravel.getRailWidgets()
    if not (R.track and R.thumb) then return end
    local minS = MapTravel.getFitScale() or 0.4
    local maxS = 4.0
    local frac = (maxS - (MapTravel.mapScale or 1.0)) / math.max(0.0001, (maxS - minS))
    frac = math.max(0, math.min(1, frac))
    local travel = math.max(0, R.track:getHeight() - R.thumb:getHeight())
    R.thumb:setMarginTop(math.floor(frac * travel))
end

function MapTravel.installLeftRail()
    local R = MapTravel.getRailWidgets()
    if not R.rail then return end

    -- Swallow clicks on the rail background so they don't drag the canvas below
    R.rail.onMousePress = function() return true end
    R.rail.onMouseRelease = function() return true end

    if R.zoomIn then
        R.zoomIn.onClick = function()
            local s = (MapTravel.mapScale or 1.0) * 1.2
            if s > 4.0 then s = 4.0 end
            MapTravel.applyScale(s)
        end
    end
    if R.zoomOut then
        R.zoomOut.onClick = function()
            local s = (MapTravel.mapScale or 1.0) / 1.2
            local minS = MapTravel.getFitScale() or 0.4
            if s < minS then s = minS end
            MapTravel.applyScale(s)
        end
    end

    -- Draggable thumb / clickable track: top = max zoom (4.0), bottom = fit
    if R.track and R.thumb then
        local function zoomFromY(y)
            local tPos = R.track:getPosition()
            local tH = R.track:getHeight()
            local thH = R.thumb:getHeight()
            local frac = (y - tPos.y - thH / 2) / math.max(1, tH - thH)
            frac = math.max(0, math.min(1, frac))
            local minS = MapTravel.getFitScale() or 0.4
            return 4.0 - frac * (4.0 - minS)
        end
        local function attachDrag(w)
            w.onMousePress = function(_, pos, btn)
                if btn ~= MouseLeftButton then return false end
                w._railDrag = true
                MapTravel.applyScale(zoomFromY(pos.y))
                return true
            end
            w.onMouseMove = function(_, pos)
                if not w._railDrag then return false end
                MapTravel.applyScale(zoomFromY(pos.y))
                return true
            end
            w.onMouseRelease = function()
                if w._railDrag then w._railDrag = false return true end
                return false
            end
        end
        attachDrag(R.track)
        attachDrag(R.thumb)
    end

    -- Layer toggles
    MapTravel.filters = MapTravel.filters or {}
    if R.tMon then
        R.tMon:setChecked(MapTravel.filters.showMonsters ~= false)
        R.tMon.onCheckChange = function(_, checked)
            MapTravel.filters.showMonsters = checked
            MapTravel.applyFiltersAndRedraw()
        end
    end
    if R.tZone then
        R.tZone:setChecked(MapTravel.filters.showZones ~= false)
        R.tZone.onCheckChange = function(_, checked)
            MapTravel.filters.showZones = checked
            MapTravel.applyFiltersAndRedraw()
        end
    end
    if R.tUG then
        R.tUG:setChecked(MapTravel.filters.showUGZones == true)
        R.tUG.onCheckChange = function(_, checked)
            MapTravel.filters.showUGZones = checked
            MapTravel.applyFiltersAndRedraw()
        end
    end
end

function focusRootPanel()
    modules.game_interface.getRootPanel():focus()
end

-- Best-effort: keep the client's native top menu above MapTravel window
function MapTravel.raiseNativeTopMenu()
    local root = rootWidget or (g_ui and g_ui.getRootWidget and g_ui:getRootWidget())
    if not root or not root.recursiveGetChildById then return end
    local candidates = { 'topMenu', 'topmenu', 'TopMenu', 'topMenuPanel', 'clientTopMenu', 'client_topmenu' }
    for _, id in ipairs(candidates) do
        local w = root:recursiveGetChildById(id)
        if w and w.raise then
            w:raise()
            if w.setZIndex then
                -- Give it a very high z-index so it stays on top
                w:setZIndex(10000)
            end
            break
        end
    end
end

-- World-to-image transform config (adjust x0,y0 if your image doesn't start at 0,0)
MapTravel.worldImageConfig = MapTravel.worldImageConfig or {
    tilesW = 2048,
    tilesH = 2048,
    imgW   = 10240,
    imgH   = 10240,
    x0     = -257,     -- top-left world tile X of the image
    y0     = -252,     -- top-left world tile Y of the image
    -- Optional extra scale multipliers to fine-tune pixels-per-tile mapping
    -- Increase scaleX/scaleY to move points further right/down respectively.
    -- Example: scaleY = 1.6 if the marker appears ~1.6x higher than expected.
    scaleX = 0.80,
    scaleY = 0.80
    ,
}

local function worldToPixelXY(pos)
    if not pos then return nil end
    local cfg = MapTravel.worldImageConfig
    -- Prefer the live texture size (handles image swaps and async texture load);
    -- fall back to last cached size, then to config
    local imgW = (MapTravel._baseMapSize and MapTravel._baseMapSize.width) or cfg.imgW
    local imgH = (MapTravel._baseMapSize and MapTravel._baseMapSize.height) or cfg.imgH
    local canvas = MapTravel.UI and MapTravel.UI.mapPanel and (MapTravel.UI.mapPanel.mapCanvas or MapTravel.UI.mapPanel) or nil
    if canvas then
        local w = (canvas.getImageWidth and canvas:getImageWidth()) or canvas:getWidth()
        local h = (canvas.getImageHeight and canvas:getImageHeight()) or canvas:getHeight()
        if w and w > 0 and h and h > 0 then
            imgW, imgH = w, h
            MapTravel._baseMapSize = { width = w, height = h }
        end
    end
    local sx = (imgW / cfg.tilesW) * (cfg.scaleX or 1)
    local sy = (imgH / cfg.tilesH) * (cfg.scaleY or 1)
    local px = (pos.x - cfg.x0) * sx
    local py = (pos.y - cfg.y0) * sy
    -- clamp to image
    if px < 0 or py < 0 or px > imgW or py > imgH then
        -- outside image; still return clamped coords
        if px < 0 then px = 0 end
        if py < 0 then py = 0 end
        if px > imgW then px = imgW end
        if py > imgH then py = imgH end
    end
    return { x = px, y = py }
end

-- Scale that fits the whole map image inside the panel (never above 1.0)
function MapTravel.getFitScale()
    local mapPanel = MapTravel.UI and MapTravel.UI.mapPanel
    if not mapPanel or not mapPanel.getSize then return nil end
    local imgW = (MapTravel._baseMapSize and MapTravel._baseMapSize.width) or MapTravel.worldImageConfig.imgW
    local imgH = (MapTravel._baseMapSize and MapTravel._baseMapSize.height) or MapTravel.worldImageConfig.imgH
    if not imgW or imgW <= 0 or not imgH or imgH <= 0 then return nil end
    local pSize = mapPanel:getSize()
    local topBarH = (mapPanel.topBar and mapPanel.topBar:getHeight()) or 0
    return math.min(pSize.width / imgW, math.max(1, pSize.height - topBarH) / imgH)
end

-- Shared mouse wheel zoom handler
function MapTravel.wheelZoom(direction, mousePos)
    -- Match buttons: scrolling forward (direction > 0) zooms IN, backward zooms OUT
    local factor = (direction > 0) and 1.2 or (1/1.2)
    local s = (MapTravel.mapScale or 1.0) * factor
    if s > 4.0 then s = 4.0 end
    local minS = MapTravel.getFitScale() or 0.4
    if s < minS then s = minS end
    MapTravel.applyScale(s, mousePos)
end

-- Resolve UI controls inside the topBar safely
function MapTravel.getFilterControls()
    if not MapTravel.UI or not MapTravel.UI.mapPanel then return {} end

-- Resolve scrollbar widgets
function MapTravel.getScrollWidgets()
    if not MapTravel.UI or not MapTravel.UI.mapPanel then return {} end
    local p = MapTravel.UI.mapPanel
    return {
        hScroll = p.hScroll or (p.recursiveGetChildById and p:recursiveGetChildById('hScroll')),
        vScroll = p.vScroll or (p.recursiveGetChildById and p:recursiveGetChildById('vScroll')),
        hThumb  = (p.hScroll and p.hScroll.hThumb) or (p.recursiveGetChildById and p:recursiveGetChildById('hThumb')),
        vThumb  = (p.vScroll and p.vScroll.vThumb) or (p.recursiveGetChildById and p:recursiveGetChildById('vThumb')),
    }
end

-- Sync thumbs based on current canvas position within bounds
function MapTravel.syncScrollbars(canvas, bounds)
    local S = MapTravel.getScrollWidgets()
    if not canvas or not bounds or not S.hScroll or not S.vScroll then return end
    if not (bounds.getPosition and bounds.getSize and canvas.getPosition and canvas.getSize) then return end

    local bPos = bounds:getPosition(); local bSize = bounds:getSize(); local cPos = canvas:getPosition(); local cSize = canvas:getSize()
    local topBarH = (MapTravel.UI and MapTravel.UI.mapPanel and MapTravel.UI.mapPanel.topBar and MapTravel.UI.mapPanel.topBar:getHeight()) or 0

    -- Auto-hide if not needed
    local needH = cSize.width > bSize.width
    local needV = cSize.height > (bSize.height - topBarH)
    if S.hScroll.setVisible then S.hScroll:setVisible(needH) end
    if S.vScroll.setVisible then S.vScroll:setVisible(needV) end

    -- Horizontal
    local trackW = S.hScroll:getWidth()
    local maxThumbW = math.max(30, math.floor(trackW * math.min(1, bSize.width / math.max(1, cSize.width))))
    if S.hThumb.setWidth then S.hThumb:setWidth(maxThumbW) end
    local minX = bPos.x
    local maxX = bPos.x + bSize.width - cSize.width
    local denomX = math.max(1, (maxX - minX))
    local ratioX = (cPos.x - minX) / denomX
    ratioX = math.max(0, math.min(1, ratioX))
    local travelX = trackW - maxThumbW
    local thumbX = S.hScroll:getPosition().x + math.floor(ratioX * travelX)
    S.hThumb:breakAnchors(); S.hThumb:setPosition({x = thumbX, y = S.hScroll:getPosition().y + math.floor((S.hScroll:getHeight() - S.hThumb:getHeight())/2)})

    -- Vertical
    local trackH = S.vScroll:getHeight()
    local maxThumbH = math.max(30, math.floor(trackH * math.min(1, (bSize.height - topBarH) / math.max(1, cSize.height))))
    if S.vThumb.setHeight then S.vThumb:setHeight(maxThumbH) end
    local minY = bPos.y + topBarH
    local maxY = bPos.y + bSize.height - cSize.height
    local denomY = math.max(1, (maxY - minY))
    local ratioY = (cPos.y - minY) / denomY
    ratioY = math.max(0, math.min(1, ratioY))
    local travelY = trackH - maxThumbH
    local thumbY = S.vScroll:getPosition().y + math.floor(ratioY * travelY)
    S.vThumb:breakAnchors(); S.vThumb:setPosition({x = S.vScroll:getPosition().x + math.floor((S.vScroll:getWidth() - S.vThumb:getWidth())/2), y = thumbY})
end

-- Setup thumbs to drag and pan canvas
function MapTravel.setupScrollbars(canvas, bounds)
    local S = MapTravel.getScrollWidgets()
    if not S.hScroll or not S.vScroll then return end

    -- Horizontal thumb drag
    if S.hThumb then
        S.hThumb.dragging = false
        -- Do not consume mouse wheel on thumbs
        S.hThumb.onMouseWheel = function() return false end
        S.hThumb.onMousePress = function(w, pos, button)
            if button ~= MouseLeftButton then return false end
            w.dragging = true
            w._dragOffsetX = pos.x - w:getPosition().x
            return true
        end
        S.hThumb.onMouseRelease = function(w)
            if w.dragging then w.dragging = false return true end
            return false
        end
        S.hThumb.onMouseMove = function(w, pos)
            if not w.dragging then return false end
            local trackPos = S.hScroll:getPosition(); local trackW = S.hScroll:getWidth()
            local thumbW = w:getWidth()
            local newX = pos.x - (w._dragOffsetX or 0)
            local minX = trackPos.x; local maxX = trackPos.x + trackW - thumbW
            if newX < minX then newX = minX end; if newX > maxX then newX = maxX end
            w:breakAnchors(); w:setPosition({x = newX, y = w:getPosition().y})
            -- Map to canvas x
            if bounds and canvas then
                local bPos = bounds:getPosition(); local bSize = bounds:getSize(); local cSize = canvas:getSize()
                local minCanvasX = bPos.x; local maxCanvasX = bPos.x + bSize.width - cSize.width
                local ratio = (newX - minX) / math.max(1, (maxX - minX))
                local targetX = minCanvasX + ratio * (maxCanvasX - minCanvasX)
                local cPos = canvas:getPosition()
                canvas:breakAnchors(); canvas:setPosition({x = math.floor(targetX), y = cPos.y})
            end
            return true
        end
    end

    -- View-only: place a one-time 'You are here' marker based on client player position
   -- if MapTravel.viewOnly then
        -- Snapshot player position once
        if not MapTravel._playerPosPx then
            local lp = g_game and g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
            local lppos = lp and lp.getPosition and lp:getPosition() or nil
            if lppos then
                MapTravel._playerPosPx = worldToPixelXY(lppos)
            end
        end
        -- Draw marker if we have pixel coords
        if MapTravel._playerPosPx then
            -- Destroy previous marker if any
            if MapTravel._playerMarker and MapTravel._playerMarker.destroy then
                MapTravel._playerMarker:destroy()
                MapTravel._playerMarker = nil
            end
            -- Stop previous effect timer if running
            if MapTravel._playerMarkerEffectTimer and removeEvent then
                removeEvent(MapTravel._playerMarkerEffectTimer)
                MapTravel._playerMarkerEffectTimer = nil
            end
            -- Create marker
            local m = g_ui.createWidget("UIWidget", canvas)
            m:setPhantom(true)
            m:setImageSource("images/icons/imhere")
            m:setImageAutoResize(true)
            -- Scale marker with map zoom
            local baseSize = 80
            local scaledSize = math.max(24, math.floor(baseSize * (MapTravel.mapScale or 1)))
            m:setSize({width = scaledSize, height = scaledSize})
            m:setId("youAreHereMarker")
            if m.setZIndex then m:setZIndex(180) end
            -- Position considering current scale; the imhere arrow tip is at the
            -- icon's bottom-right corner (~89% x, ~96% y of the 28x23 image),
            -- so offset the icon to place the tip exactly on the position
            local mx = (MapTravel._playerPosPx.x * MapTravel.mapScale) - (scaledSize * 0.89)
            local my = (MapTravel._playerPosPx.y * MapTravel.mapScale) - (scaledSize * 0.86)
            m:addAnchor(AnchorTop, "parent", AnchorTop)
            m:addAnchor(AnchorLeft, "parent", AnchorLeft)
            m:setMarginLeft(math.floor(mx))
            m:setMarginTop(math.floor(my))
            MapTravel._playerMarker = m

            -- Attach an effect (like we do on zone creature icons) via a UICreature child
            -- Effect id 240 is 'waypoints bounce' per effects.lua
            if g_attachedEffects and g_attachedEffects.getById then
                local effHost = g_ui.createWidget("UICreature", m)
                effHost:setPhantom(true)
                effHost:setId("youAreHereEffectHost")
                if effHost.setZIndex then effHost:setZIndex(181) end
                effHost:addAnchor(AnchorTop, "parent", AnchorTop)
                effHost:addAnchor(AnchorLeft, "parent", AnchorLeft)
                effHost:setSize(m:getSize())
                effHost:setMarginLeft(0)
                effHost:setMarginTop(0)
				-- print("creating player marker")

                -- Ensure the UICreature has a valid outfit so getCreature() returns an object
                --[[
                if effHost.setOutfit then
                    local lp2 = g_game and g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
                    local outfit = lp2 and lp2.getOutfit and lp2:getOutfit() or nil
                    if outfit then
                        effHost:setOutfit(outfit)
                    else
                        effHost:setOutfit({ type = 10 }) -- fallback looktype
                    end
                end
                ]]
                local creatureObj = effHost.getCreature and effHost:getCreature() or nil
                if creatureObj and creatureObj.attachEffect then
                    local effect = g_attachedEffects.getById(241)
                    if effect then
                        -- print("attach effect")
                        creatureObj:attachEffect(effect)
                    end
                end
            end
        end
   -- end

    -- Vertical thumb drag
    if S.vThumb then
        S.vThumb.dragging = false
        -- Do not consume mouse wheel on thumbs
        S.vThumb.onMouseWheel = function() return false end
        S.vThumb.onMousePress = function(w, pos, button)
            if button ~= MouseLeftButton then return false end
            w.dragging = true
            w._dragOffsetY = pos.y - w:getPosition().y
            return true
        end
        S.vThumb.onMouseRelease = function(w)
            if w.dragging then w.dragging = false return true end
            return false
        end
        S.vThumb.onMouseMove = function(w, pos)
            if not w.dragging then return false end
            local trackPos = S.vScroll:getPosition(); local trackH = S.vScroll:getHeight()
            local thumbH = w:getHeight()
            local newY = pos.y - (w._dragOffsetY or 0)
            local minY = trackPos.y; local maxY = trackPos.y + trackH - thumbH
            if newY < minY then newY = minY end; if newY > maxY then newY = maxY end
            w:breakAnchors(); w:setPosition({x = w:getPosition().x, y = newY})
            -- Map to canvas y
            if bounds and canvas then
                local bPos = bounds:getPosition(); local bSize = bounds:getSize(); local cSize = canvas:getSize()
                local topBarH = (MapTravel.UI and MapTravel.UI.mapPanel and MapTravel.UI.mapPanel.topBar and MapTravel.UI.mapPanel.topBar:getHeight()) or 0
                local minCanvasY = bPos.y + topBarH
                local maxCanvasY = bPos.y + bSize.height - cSize.height
                local ratio = (newY - minY) / math.max(1, (maxY - minY))
                local targetY = minCanvasY + ratio * (maxCanvasY - minCanvasY)
                local cPos = canvas:getPosition()
                canvas:breakAnchors(); canvas:setPosition({x = cPos.x, y = math.floor(targetY)})
            end
            return true
        end
    end
    -- Do not consume mouse wheel on scroll tracks either
    if S.hScroll then S.hScroll.onMouseWheel = function() return false end end
    if S.vScroll then S.vScroll.onMouseWheel = function() return false end end
    -- Initial sync
    MapTravel.syncScrollbars(canvas, bounds)
end
    local panel = MapTravel.UI.mapPanel
    local topBar = panel.topBar or (panel.recursiveGetChildById and panel:recursiveGetChildById('topBar'))
    local rightControls = topBar and (topBar.rightControls or (topBar.recursiveGetChildById and topBar:recursiveGetChildById('rightControls'))) or nil
    return {
        levelFilter = (topBar and (topBar.levelFilter or (topBar.recursiveGetChildById and topBar:recursiveGetChildById('levelFilter'))))
                       or (panel.recursiveGetChildById and panel:recursiveGetChildById('levelFilter')),
        searchBox   = (topBar and (topBar.searchBox   or (topBar.recursiveGetChildById and topBar:recursiveGetChildById('searchBox'))))
                       or (panel.recursiveGetChildById and panel:recursiveGetChildById('searchBox')),
        toggleLocked = rightControls and (rightControls.toggleLocked or (rightControls.recursiveGetChildById and rightControls:recursiveGetChildById('toggleLocked')))
                        or (panel.recursiveGetChildById and panel:recursiveGetChildById('toggleLocked')),
        toggleZones  = rightControls and (rightControls.toggleZones  or (rightControls.recursiveGetChildById  and rightControls:recursiveGetChildById('toggleZones')))
                        or (panel.recursiveGetChildById and panel:recursiveGetChildById('toggleZones')),
        iconZones    = rightControls and (rightControls.iconZones    or (rightControls.recursiveGetChildById  and rightControls:recursiveGetChildById('iconZones'))),
        iconLocked   = rightControls and (rightControls.iconLocked   or (rightControls.recursiveGetChildById  and rightControls:recursiveGetChildById('iconLocked'))),
        resetFilters = topBar and (topBar.resetFilters or (topBar.recursiveGetChildById and topBar:recursiveGetChildById('resetFilters'))),
        centerMap   = topBar and (topBar.centerMap   or (topBar.recursiveGetChildById and topBar:recursiveGetChildById('centerMap'))),
        zoomIn      = topBar and (topBar.zoomIn      or (topBar.recursiveGetChildById and topBar:recursiveGetChildById('zoomIn'))),
        zoomOut     = topBar and (topBar.zoomOut     or (topBar.recursiveGetChildById and topBar:recursiveGetChildById('zoomOut'))),
        scrollSpeed = topBar and (topBar.scrollSpeed or (topBar.recursiveGetChildById and topBar:recursiveGetChildById('scrollSpeed'))),
        closeBtn    = topBar and (topBar.closeBtn    or (topBar.recursiveGetChildById and topBar:recursiveGetChildById('closeBtn'))),
    }
end

-- Ensure controls are initialized and wired; safe to call multiple times
function MapTravel.ensureFilterUI()
    local C = MapTravel.getFilterControls()
    if not C then return end
    -- Utility to suppress callback-triggered redraw loops while syncing UI state
    local function withSuppressed(fn)
        MapTravel._suppressFilterCallbacks = true
        local ok, err = pcall(fn)
        MapTravel._suppressFilterCallbacks = false
        if not ok then print('[MapTravel] ensureFilterUI error:', err) end
    end
    -- Level filter options
    if C.levelFilter and C.levelFilter.clear and C.levelFilter.addOption then
        -- Populate only once using a module flag to avoid flicker/reset
        if not MapTravel._levelFilterPopulated then
            withSuppressed(function()
                C.levelFilter:clear()
                -- Include a special option to hide monsters from here
                local ranges = {"All","Hide monsters","1-50","51-100","101-150","151-200","201-250","251-300","301-350","350+"}
                for _, r in ipairs(ranges) do C.levelFilter:addOption(r) end
            end)
            MapTravel._levelFilterPopulated = true
        end
        -- Always reflect current state in the dropdown
        withSuppressed(function()
            local desired = (MapTravel.filters and MapTravel.filters.showMonsters == false) and 'Hide monsters'
                            or (MapTravel.filters and MapTravel.filters.levelRange or 'All')
            if C.levelFilter.setCurrentOptionByText then
                C.levelFilter:setCurrentOptionByText(desired)
            elseif C.levelFilter.setText then
                C.levelFilter:setText(desired)
            end
        end)

        C.levelFilter.onOptionChange = function()
            if MapTravel._suppressFilterCallbacks then return end
            local txt = C.levelFilter.getText and C.levelFilter:getText() or 'All'
            if txt == 'Hide monsters' then
                MapTravel.filters.showMonsters = false
                -- do not change the remembered levelRange when hiding
            else
                MapTravel.filters.showMonsters = true
                MapTravel.filters.levelRange = txt
                if txt == 'All' then
                    -- behave like reset for monsters: clear search so everything returns
                    MapTravel.filters.search = ''
                    local C2 = MapTravel.getFilterControls()
                    if C2 and C2.searchBox and C2.searchBox.setText then
                        withSuppressed(function() C2.searchBox:setText('') end)
                    end
                end
            end
            -- Immediately reflect the chosen option so the current selection shows
            withSuppressed(function()
                local desired = (MapTravel.filters.showMonsters == false) and 'Hide monsters' or MapTravel.filters.levelRange
                if C.levelFilter.setCurrentOptionByText then
                    C.levelFilter:setCurrentOptionByText(desired)
                elseif C.levelFilter.setText then
                    C.levelFilter:setText(desired)
                end
            end)
            MapTravel.applyFiltersAndRedraw()
        end
    end

    -- Search box
    if C.searchBox then
        withSuppressed(function()
            if C.searchBox.setText then C.searchBox:setText(MapTravel.filters and MapTravel.filters.search or "") end
        end)
        C.searchBox.onTextChange = function()
            if MapTravel._suppressFilterCallbacks then return end
            MapTravel.filters.search = (C.searchBox.getText and C.searchBox:getText()) or ""
            MapTravel.applyFiltersAndRedraw()
        end
    end

    -- Toggles
    if C.toggleLocked then
        withSuppressed(function()
            if C.toggleLocked.setChecked then C.toggleLocked:setChecked(MapTravel.filters and MapTravel.filters.showLocked) end
        end)
        C.toggleLocked.onCheckChange = function(_, checked)
            if MapTravel._suppressFilterCallbacks then return end
            MapTravel.filters.showLocked = checked and true or false
            MapTravel.applyFiltersAndRedraw()
        end
    end
    if C.toggleZones then
        withSuppressed(function()
            if C.toggleZones.setChecked then C.toggleZones:setChecked(MapTravel.filters and MapTravel.filters.showMonsters) end
        end)
        C.toggleZones.onCheckChange = function(_, checked)
            if MapTravel._suppressFilterCallbacks then return end
            MapTravel.filters.showMonsters = checked and true or false
            MapTravel.applyFiltersAndRedraw()
        end
    end

    -- Make icons clickable to toggle corresponding checkbox
    if C.iconZones and C.toggleZones then
        C.iconZones.onClick = function()
            if MapTravel._suppressFilterCallbacks then return end
            if C.toggleZones.setChecked and C.toggleZones.isChecked then
                C.toggleZones:setChecked(not C.toggleZones:isChecked())
            end
            MapTravel.filters.showMonsters = (C.toggleZones.isChecked and C.toggleZones:isChecked()) or false
            MapTravel.applyFiltersAndRedraw()
        end
    end
    if C.iconLocked and C.toggleLocked then
        C.iconLocked.onClick = function()
            if MapTravel._suppressFilterCallbacks then return end
            if C.toggleLocked.setChecked and C.toggleLocked.isChecked then
                C.toggleLocked:setChecked(not C.toggleLocked:isChecked())
            end
            MapTravel.filters.showLocked = (C.toggleLocked.isChecked and C.toggleLocked:isChecked()) or false
            MapTravel.applyFiltersAndRedraw()
        end
    end

    -- Reset filters button
    if C.resetFilters then
        C.resetFilters.onClick = function()
            if MapTravel._suppressFilterCallbacks then return end
            withSuppressed(function()
                MapTravel.filters.levelRange = 'All'
                MapTravel.filters.search = ''
                MapTravel.filters.showLocked = true
                MapTravel.filters.showMonsters = true
                MapTravel.filters.showZones = true
                if C.levelFilter and C.levelFilter.setCurrentOptionByText then C.levelFilter:setCurrentOptionByText('All') end
                if C.searchBox and C.searchBox.setText then C.searchBox:setText('') end
                if C.toggleLocked and C.toggleLocked.setChecked then C.toggleLocked:setChecked(true) end
                if C.toggleZones and C.toggleZones.setChecked then C.toggleZones:setChecked(true) end
            end)
            MapTravel.applyFiltersAndRedraw()
        end
    end

    -- Center map button
    if C.centerMap then
        C.centerMap.onClick = function()
            if not MapTravel.UI or not MapTravel.UI.mapPanel then return end
            local mapPanel = MapTravel.UI.mapPanel
            local canvas = (mapPanel.mapCanvas) or mapPanel
            local root = mapPanel:getParent()
            local bounds = root and root.recursiveGetChildById and root:recursiveGetChildById('mainFrame') or MapTravel.UI
            if bounds and bounds.getPosition and bounds.getSize and canvas.getSize then
                local bPos = bounds:getPosition(); local bSize = bounds:getSize(); local cSize = canvas:getSize()
                local topBarH = (MapTravel.UI.mapPanel.topBar and MapTravel.UI.mapPanel.topBar:getHeight()) or 0
                local cx, cy
                if MapTravel._playerPosPx then
                    -- center the view on the player marker
                    cx = math.floor(bPos.x + bSize.width / 2 - MapTravel._playerPosPx.x * MapTravel.mapScale)
                    cy = math.floor(bPos.y + topBarH + (bSize.height - topBarH) / 2 - MapTravel._playerPosPx.y * MapTravel.mapScale)
                    cx = math.min(bPos.x, math.max(cx, bPos.x + bSize.width - cSize.width))
                    cy = math.min(bPos.y + topBarH, math.max(cy, bPos.y + bSize.height - cSize.height))
                else
                    cx = bPos.x + math.max(0, math.floor((bSize.width - cSize.width) / 2))
                    cy = bPos.y + topBarH + math.max(0, math.floor((bSize.height - topBarH - cSize.height) / 2))
                end
                canvas:breakAnchors(); canvas:setPosition({x = cx, y = cy})
                MapTravel.syncScrollbars(canvas, bounds)
            end
        end
    end

    -- Scroll speed fixed at Normal (control removed from UI)
    MapTravel.scrollStep = 60

    -- Zoom buttons
    if C.zoomIn then
        C.zoomIn.onClick = function()
            local s = MapTravel.mapScale or 1.0
            s = s * 1.2
            if s > 4.0 then s = 4.0 end
            MapTravel.applyScale(s)
        end
    end
    if C.zoomOut then
        C.zoomOut.onClick = function()
            local s = MapTravel.mapScale or 1.0
            s = s / 1.2
            local minS = MapTravel.getFitScale() or 0.4
            if s < minS then s = minS end
            MapTravel.applyScale(s)
        end
    end

    -- Close button
    if C.closeBtn then
        C.closeBtn.onClick = function()
            if MapTravel.hide then
                MapTravel.hide()
            elseif MapTravel.UI and MapTravel.UI.hide then
                MapTravel.UI:hide()
            end
            focusRootPanel()
        end
    end
end

-- Helpers for filters
function MapTravel.parseRecommendedLevel(v)
    if type(v) == 'number' then return v end
    if type(v) == 'string' then
        local num = tonumber(v:match('%d+'))
        return num or 0
    end
    return 0
end

function MapTravel.levelMatchesFilter(level, rangeText)
    if not rangeText or rangeText == 'All' then return true end
    local a,b = rangeText:match('^(%d+)%-(%d+)$')
    if a and b then
        a = tonumber(a); b = tonumber(b)
        return level >= a and level <= b
    end
    local min = rangeText:match('^(%d+)%+$')
    if min then
        return level >= tonumber(min)
    end
    return true
end

function MapTravel.applyFiltersAndRedraw()
    MapTravel.updateMap()
end


------ Initialization and Termination

function MapTravel.init()
	connect(
		g_game,
		{
			onGameStart = MapTravel.onGameStart,
			onGameEnd = MapTravel.onGameEnd
		}
	)
	ProtocolGame.registerExtendedOpcode(MapTravel_OPCODE, MapTravel.onExtendedOpcode)

	-- Bind hotkey to open in view-only mode (no teleport interactions)
	if g_keyboard and g_keyboard.bindKeyDown then
		MapTravel._ctrlMCallback = function()
			if not g_game.isOnline() or not MapTravel.UI then return end
			if MapTravel.UI:isVisible() and MapTravel.viewOnly then
				MapTravel.hide()
				return
			end
			MapTravel.viewOnly = true
			-- ensure UI exists and map is up to date
			MapTravel.updateMap()
			if MapTravel.UI.viewOnlyBadge then
				MapTravel.UI.viewOnlyBadge:setVisible(true)
			end
			MapTravel.show()
		end
		g_keyboard.bindKeyDown('Ctrl+M', MapTravel._ctrlMCallback)
	end

	if g_game.isOnline() then
		MapTravel.onGameStart()
	end

    -- Expose this module table for external callers (e.g., minimap) even when sandboxed
    if modules then
        modules.game_MapTravel = MapTravel
    end
end

function MapTravel.terminate()
	disconnect(
		g_game,
		{
			onGameStart = MapTravel.onGameStart,
			onGameEnd = MapTravel.onGameEnd
		}
	)
	ProtocolGame.unregisterExtendedOpcode(MapTravel_OPCODE)
	-- Unbind hotkey
	if MapTravel._ctrlMCallback and g_keyboard and g_keyboard.unbindKeyDown then
		g_keyboard.unbindKeyDown('Ctrl+M', MapTravel._ctrlMCallback)
		MapTravel._ctrlMCallback = nil
	end
	MapTravel.onGameEnd()
end

function MapTravel.onGameStart()
    if not MapTravel.UI then
        MapTravel.UI = g_ui.displayUI("MapTravel")
        MapTravel.UI:hide()

        -- Keep MapTravel root below native top menu by default
        if MapTravel.UI.setZIndex then MapTravel.UI:setZIndex(10) end

        MapTravel.UI.NodesTooltip = g_ui.displayUI("MapTravelTooltip")
        MapTravel.UI.NodesTooltip:hide()

        MapTravel.UI.onKeyDown = function(widget, keyCode)
            if keyCode == KeyEscape then
                MapTravel.UI:hide()
            end
            return false
        end

        -- Initialize filters defaults and wire up UI controls
        MapTravel.filters = MapTravel.filters or {
            levelRange = "All",
            search = "",
            showLocked = true,
            showMonsters = true,
            showZones = true,
            showUGZones = false,
        }

        -- zoneId -> { name, description, progress, amount } from server (opcode 214)
        MapTravel.activeZoneEvents = MapTravel.activeZoneEvents or {}
        MapTravel.activeZoneBuffs = MapTravel.activeZoneBuffs or {}

        local panel = MapTravel.UI.mapPanel
        if panel then
            -- Resolve nested widgets inside topBar/rightControls
            MapTravel.ensureFilterUI()
        end

        if MapTravel.devMode then
            MapTravel.setupDevMode()
        end
    end
    local data = {topic = "request-MapTravel-Cache"}
    MapTravel.sendOpcode(data)
end

function MapTravel.onGameEnd()
	if MapTravel.UI then
		MapTravel.UI.NodesTooltip:destroy()
		MapTravel.UI.NodesTooltip = nil

		MapTravel.UI:destroy()
		MapTravel.UI = nil
	end
end


------ UI Management

function MapTravel.toggle()
	if MapTravel.UI and MapTravel.UI:isVisible() then
		MapTravel.hide()
	else
		MapTravel.show()
	end
end

function MapTravel.show()
    if not MapTravel.UI then
        return
    end
    if not MapTravel.UI:isVisible() then
        MapTravel.UI:show()
        -- Ask the server for currently active zone events (opcode 214 snapshot)
        if MapTravel.sendOpcode then
            MapTravel.sendOpcode({ topic = "get-zone-events" })
        end
        MapTravel.UI:raise()
        -- MapTravel.UI:focus() -- Allow walking while map is open
        if MapTravel.UI.mapPanel then
            MapTravel.UI.mapPanel:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
            MapTravel.UI.mapPanel:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
        end
        -- Try to raise native top menu above us
        if MapTravel.raiseNativeTopMenu then MapTravel.raiseNativeTopMenu() end
        -- Auto-center map on open using the same logic as the Center button
        do
            if MapTravel.UI and MapTravel.UI.mapPanel then
                local mapPanel = MapTravel.UI.mapPanel
                local canvas = (mapPanel.mapCanvas) or mapPanel
                local root = mapPanel:getParent()
                local bounds = root and root.recursiveGetChildById and root:recursiveGetChildById('mainFrame') or MapTravel.UI
                if bounds and bounds.getPosition and bounds.getSize and canvas.getSize then
                    local bPos = bounds:getPosition(); local bSize = bounds:getSize(); local cSize = canvas:getSize()
                    local topBarH = (MapTravel.UI.mapPanel.topBar and MapTravel.UI.mapPanel.topBar:getHeight()) or 0
                    local cx, cy
                    if MapTravel._playerPosPx then
                        -- center the view on the player marker
                        cx = math.floor(bPos.x + bSize.width / 2 - MapTravel._playerPosPx.x * MapTravel.mapScale)
                        cy = math.floor(bPos.y + topBarH + (bSize.height - topBarH) / 2 - MapTravel._playerPosPx.y * MapTravel.mapScale)
                        -- keep canvas edges covering the panel
                        cx = math.min(bPos.x, math.max(cx, bPos.x + bSize.width - cSize.width))
                        cy = math.min(bPos.y + topBarH, math.max(cy, bPos.y + bSize.height - cSize.height))
                    else
                        cx = bPos.x + math.max(0, math.floor((bSize.width - cSize.width) / 2))
                        cy = bPos.y + topBarH + math.max(0, math.floor((bSize.height - topBarH - cSize.height) / 2))
                    end
                    canvas:breakAnchors(); canvas:setPosition({x = cx, y = cy})
                    MapTravel.syncScrollbars(canvas, bounds)
                end
            end
        end

        -- Show non-view mode hint label on the top bar
        do
            local panel = MapTravel.UI and MapTravel.UI.mapPanel
            local topBar = panel and (panel.topBar or (panel.recursiveGetChildById and panel:recursiveGetChildById('topBar')))
            if topBar then
                -- Only show when not in view mode (if a flag exists, respect it)
                if not MapTravel.viewMode then
                    local hint = topBar:recursiveGetChildById('nonViewHintLabel')
                    if not hint then
                        hint = g_ui.createWidget('UILabel', topBar)
                        hint:setId('nonViewHintLabel')
                        hint:setText('press CTRL + M to open view mode, while traveling')
                        if hint.setFont then hint:setFont('verdana-11px-rounded') end
                        if hint.setColor then hint:setColor('#ffffff') end
                        hint:setHeight(20)
                        if hint.setBackgroundColor then hint:setBackgroundColor('#00000088') end
                        if hint.setAutoResizeToText then hint:setAutoResizeToText(true) end
                        if hint.addAnchor then
                            hint:addAnchor(AnchorTop, 'parent', AnchorTop)
                            hint:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
                            hint:setMarginTop(2) 
                        end
                        
                        if hint.setZIndex then hint:setZIndex(1001) end
                    else
                        hint:show()
                    end
                else
                    local hint = topBar:recursiveGetChildById('nonViewHintLabel')
                    if hint then hint:hide() end
                end
            end
        end
    end
end

function MapTravel.hide()
	if MapTravel.UI then
		MapTravel.UI:hide()
		MapTravel.UI.NodesTooltip:hide()
		-- Clean up the non-view mode hint label if present
		local panel = MapTravel.UI.mapPanel
		local topBar = panel and (panel.topBar or (panel.recursiveGetChildById and panel:recursiveGetChildById('topBar')))
		if topBar and topBar.recursiveGetChildById then
			local hint = topBar:recursiveGetChildById('nonViewHintLabel')
			if hint and hint.destroy then hint:destroy() end
		end
	end
end

function MapTravel.updateMap()
	if not MapTravel.UI then
		return
	end

	local mapPanel = MapTravel.UI.mapPanel
	if not mapPanel then
		return
	end

    -- Always ensure filter controls are wired before redrawing
    MapTravel.ensureFilterUI()

    -- Select canvas: dedicated map content holder to pan, fallback to mapPanel
    local canvas = (mapPanel.mapCanvas) or mapPanel

    -- Destroy only dynamic children inside the canvas; keep UI around mapPanel
    if canvas.getChildren then
        for _, child in ipairs(canvas:getChildren()) do child:destroy() end
    else
        canvas:destroyChildren()
    end

    -- Set world map image on canvas and scale (always from base size)
    if canvas.setImageSource then canvas:setImageSource(MapTravel.mapDirectory) end
    -- Initial scale: fit the whole map in view if the image is larger than the panel
    if not MapTravel.mapScale then
        MapTravel.mapScale = MapTravel.getFitScale() or 1.0
    end
    MapTravel.updateZoomLabel()
    -- Refresh base size from the image natural size every redraw
    do
        local w = (canvas.getImageWidth and canvas:getImageWidth()) or canvas:getWidth()
        local h = (canvas.getImageHeight and canvas:getImageHeight()) or canvas:getHeight()
        if w and w > 0 and h and h > 0 then
            MapTravel._baseMapSize = { width = w, height = h }
        end
    end
    MapTravel._baseMapSize = MapTravel._baseMapSize
        or { width = MapTravel.worldImageConfig.imgW, height = MapTravel.worldImageConfig.imgH }
    if canvas.setWidth then canvas:setWidth(MapTravel._baseMapSize.width * MapTravel.mapScale) end
    if canvas.setHeight then canvas:setHeight(MapTravel._baseMapSize.height * MapTravel.mapScale) end

    -- Refresh player pixel position each redraw (ensures up-to-date 'You are here' marker)
    do
        local lp = g_game and g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
        local lppos = lp and lp.getPosition and lp:getPosition() or nil
        if lppos then
            MapTravel._playerPosPx = worldToPixelXY(lppos)
        else
            MapTravel._playerPosPx = nil
        end
    end

    -- Dev preview removed: no preview square or dev border indicators

    for nodeIndex, nodeConfig in ipairs(MapTravel.mapNodesConfig) do
        local nodeWidget = g_ui.createWidget("MapTravelNode", canvas)
        nodeWidget:addAnchor(AnchorTop, "parent", AnchorTop)
        nodeWidget:addAnchor(AnchorLeft, "parent", AnchorLeft)

        nodeWidget:setMarginTop((nodeConfig.modulePos.marginTop * MapTravel.mapScale))
        nodeWidget:setMarginLeft(nodeConfig.modulePos.marginLeft * MapTravel.mapScale)

		nodeWidget.nameId = nodeConfig.nameId
		nodeWidget.nodeConfig = nodeConfig
		nodeWidget.originalMargin = {
			marginTop = nodeConfig.modulePos.marginTop,
			marginLeft = nodeConfig.modulePos.marginLeft
		}

		nodeWidget.onHoverChange = MapTravel.onNodeHoverChange

        -- Disable wheel zoom on nodes
        nodeWidget.onMouseWheel = nil

		local isUnlocked = (not nodeConfig.discoverable) or MapTravel.unlockedNodes[nodeConfig.nameId]

		local nodeImage = ""
		local nodeEnabled = false
		local nodeVisible = true
		if nodeConfig.discoverable and not isUnlocked then
			nodeEnabled = false
			-- Respect filter: show or hide locked
			nodeVisible = MapTravel.filters and MapTravel.filters.showLocked == true
		else
			if nodeConfig.nameId == MapTravel.currentNodeNameId then
				nodeImage = "images/nodes/current/" .. tostring(nodeConfig.nameId):lower()
				nodeEnabled = true
				nodeVisible = true
			else
				nodeImage = "images/nodes/normal/" .. tostring(nodeConfig.nameId):lower()
				nodeEnabled = true
				nodeVisible = true
			end
		end

		nodeWidget:setImageSource(nodeImage)
		nodeWidget:setEnabled(nodeEnabled)
		nodeWidget:setVisible(nodeVisible)
		-- If showing locked, dim the icon
		if nodeConfig.discoverable and not isUnlocked then
			if MapTravel.filters and MapTravel.filters.showLocked == true then
				if nodeWidget.setOpacity then nodeWidget:setOpacity(0.45) end
			end
		else
			if nodeWidget.setOpacity then nodeWidget:setOpacity(1.0) end
		end

		-- Apply search filter on waypoints (displayName or nameId)
		if MapTravel.filters and MapTravel.filters.search and MapTravel.filters.search ~= "" then
			local q = MapTravel.filters.search:lower()
			local nameA = tostring(nodeConfig.displayName or ""):lower()
			local nameB = tostring(nodeConfig.nameId or ""):lower()
			local matches = (nameA:find(q, 1, true) ~= nil) or (nameB:find(q, 1, true) ~= nil)
			if not matches then
				nodeWidget:setVisible(false)
			end
		end

		MapTravel.originalNodeWidgetWidth = nodeWidget:getWidth()
		MapTravel.originalNodeWidgetHeight = nodeWidget:getHeight()
		nodeWidget:setWidth(MapTravel.originalNodeWidgetWidth * MapTravel.mapScale)
		nodeWidget:setHeight(MapTravel.originalNodeWidgetHeight * MapTravel.mapScale)

		if nodeEnabled and not MapTravel.viewOnly then
			nodeWidget.onClick = function()
				MapTravel.requestTravel(nodeIndex, MapTravel.currentNodeNameId)
			end
		else
			nodeWidget.onClick = nil
		end
	end

    -- Render Zone Nodes (non-interactive markers)
    if MapTravel.zonesConfig and #MapTravel.zonesConfig > 0 then
        for _, zone in ipairs(MapTravel.zonesConfig) do
            local isImageNode = (zone.image ~= nil and zone.image ~= '') and (zone.outfit == nil)
            local widgetType = isImageNode and "MapTravelZoneImageNode" or "MapTravelZoneNode"
            local zoneWidget = g_ui.createWidget(widgetType, canvas)
            zoneWidget:addAnchor(AnchorTop, "parent", AnchorTop)
            zoneWidget:addAnchor(AnchorLeft, "parent", AnchorLeft)

            local mTop = ((zone.modulePos.marginTop or 0) * MapTravel.mapScale)
            local mLeft = (zone.modulePos.marginLeft or 0) * MapTravel.mapScale
            zoneWidget:setMarginTop(mTop)
            zoneWidget:setMarginLeft(mLeft)

            -- Size
            local baseW = MapTravel.zoneNodeSize and MapTravel.zoneNodeSize.width or 36
            local baseH = MapTravel.zoneNodeSize and MapTravel.zoneNodeSize.height or 36
            zoneWidget:setWidth(baseW * MapTravel.mapScale)
            zoneWidget:setHeight(baseH * MapTravel.mapScale)

            -- Outfit (creature looktype) or Image icon
            if not isImageNode and zone.outfit then
                zoneWidget:setOutfit(zone.outfit)
                if zoneWidget.setCenter then
                    zoneWidget:setCenter(true)
                end
                -- Try to keep large outfits centered/fitting in the node
                local baseW = MapTravel.zoneNodeSize and MapTravel.zoneNodeSize.width or zoneWidget:getWidth()
                local baseH = MapTravel.zoneNodeSize and MapTravel.zoneNodeSize.height or zoneWidget:getHeight()
                -- Ensure widget size matches configured node size (already set above, but reaffirm)
                if zoneWidget.setSize then
                    zoneWidget:setSize(string.format("%d %d", math.floor(baseW * MapTravel.mapScale), math.floor(baseH * MapTravel.mapScale)))
                end
                if zoneWidget.setPadding then
                    zoneWidget:setPadding(zone.padding or -math.floor((baseW + baseH) / 16))
                end
                if zoneWidget.setMarginLeft then
                    zoneWidget:setMarginLeft(mLeft + (zone.marginLeftOffset or 0))
                end
                if zoneWidget.setMarginTop then
                    zoneWidget:setMarginTop(mTop + (zone.marginTopOffset or 0))
                end
                -- Adjust creature render size based on thing real size
                if g_things and g_things.getThingType and zone.outfit.type and zoneWidget.setCreatureSize then
                    local thingType = g_things.getThingType(zone.outfit.type, ThingCategoryCreature)
                    if thingType and thingType.getRealSize then
                        local real = thingType:getRealSize() or 64
                        if zone.creatureFixSize then
                            real = zone.creatureFixSize
                        end
                        local base = math.floor((baseW + baseH) / 2)
                        local extra = zone.creatureSizeExtra or 148
                        zoneWidget:setCreatureSize(real + extra)
                    end
                end
                -- Attach visual effect to the UICreature icon if possible
                if zoneWidget.getCreature then
                    local creatureObj = zoneWidget:getCreature()
                    if creatureObj and creatureObj.attachEffect and g_attachedEffects and g_attachedEffects.getById then
                        local chosenEffectId = zone.effectId
                        local effect = chosenEffectId and g_attachedEffects.getById(chosenEffectId) or nil
                        if effect then
                            creatureObj:attachEffect(effect)
                        end
                    end
                end
            elseif isImageNode then
                -- Static image icon
                if zoneWidget.setImageSource then
                    zoneWidget:setImageSource(zone.image)
                end
                -- Allow per-zone scaling via zone.imageScale (default 1)
                local imageScale = zone.imageScale or 1
                zoneWidget:setWidth((baseW * MapTravel.mapScale) * imageScale)
                zoneWidget:setHeight((baseH * MapTravel.mapScale) * imageScale)
                -- Optional offsets
                if zone.imageMarginLeftOffset then
                    zoneWidget:setMarginLeft(mLeft + zone.imageMarginLeftOffset)
                end
                if zone.imageMarginTopOffset then
                    zoneWidget:setMarginTop(mTop + zone.imageMarginTopOffset)
                end
            end

            -- Apply filters to zones: search and level range
            local visible = true
            local q = ""
            if MapTravel.filters then
                -- Layer toggles: Monsters hides outfit (creature) nodes, Zones hides image nodes
                if (MapTravel.filters.showMonsters == false) and (not isImageNode) and zone.outfit then
                    visible = false
                end
                if (MapTravel.filters.showZones == false) and isImageNode then
                    visible = false
                end
                -- Search across display/name
                q = (MapTravel.filters.search or ""):lower()
                if q ~= "" then
                    local zName = tostring(zone.name or zone.displayName or ""):lower()
                    if not zName:find(q, 1, true) then
                        visible = false
                    end
                end
                -- Level filter never hard-hides; only dims below
            end
            zoneWidget:setVisible(visible)

            -- Visual adjustments per filters
            do
                local lvl = MapTravel.parseRecommendedLevel(zone.recommendedLevel)
                local inRange = MapTravel.levelMatchesFilter(lvl, MapTravel.filters and MapTravel.filters.levelRange or "All")
                -- Dim out-of-range monsters to 80% transparency (opacity 0.2)
                if zoneWidget.setOpacity then
                    if inRange then
                        zoneWidget:setOpacity(1.0)
                    else
                        zoneWidget:setOpacity(0)
                    end
                end

                -- Highlight search matches: bigger size and shader Zomg on UICreature nodes
                q = (MapTravel.filters and MapTravel.filters.search or ""):lower()
                local isMatch = false
                if q ~= "" then
                    local zName = tostring(zone.name or zone.displayName or ""):lower()
                    isMatch = zName:find(q, 1, true) ~= nil
                end

                -- Reset size first
                local baseW2 = MapTravel.zoneNodeSize and MapTravel.zoneNodeSize.width or 36
                local baseH2 = MapTravel.zoneNodeSize and MapTravel.zoneNodeSize.height or 36
                local scaleBoost = (isMatch and 1.15 or 1.0)
                local w = (baseW2 * MapTravel.mapScale) * (isImageNode and (zone.imageScale or 1) or 1)
                local h = (baseH2 * MapTravel.mapScale) * (isImageNode and (zone.imageScale or 1) or 1)
                zoneWidget:setWidth(math.floor(w * scaleBoost))
                zoneWidget:setHeight(math.floor(h * scaleBoost))

                -- Shader apply/remove
                local function setCreatureShader(widget, shaderName)
                    if widget.getCreature and g_shaders and g_shaders.getShader then
                        local creatureObj = widget:getCreature()
                        if creatureObj and creatureObj.setShader then
                            if shaderName == false then
                                -- Explicitly set to default outfit shader
                                local def = g_shaders.getShader('Outfit - Default')
                                creatureObj:setShader(def)
                            else
                                local shader = shaderName and g_shaders.getShader(shaderName) or nil
                                creatureObj:setShader(shader)
                            end
                        end
                    end
                end

                if not isImageNode and zone.outfit then
                    if isMatch then
                        setCreatureShader(zoneWidget, 'Zomg')
                    else
                        -- remove shader (default)
                        setCreatureShader(zoneWidget, false)
                    end
                end
            end

            -- Hover tooltip
            zoneWidget.onHoverChange = function(w, hovered)
                MapTravel.onZoneHoverChange(w, hovered, zone)
            end

            -- Disable wheel zoom on zones
            zoneWidget.onMouseWheel = nil
        end
    end

    -- Painted zone rectangles (zones.dat, same data as minimap overlay)
    MapTravel.renderZoneRects(canvas)

    -- Attached-effect markers over zones with an active server-side event
    MapTravel.renderZoneEventMarkers(canvas)

    -- Drag and pan the canvas within mapPanel area (below top bar)
    local boundsWidget = mapPanel
    MapTravel.makeWidgetDraggable(canvas, boundsWidget)

    -- Center canvas initially inside bounds (only the first time or when scaled)
    if not MapTravel._canvasPositioned then
        if mapPanel and mapPanel.getSize and canvas.getSize then
            local pSize = mapPanel:getSize()
            local cSize = canvas:getSize()
            local topBarH = (mapPanel.topBar and mapPanel.topBar:getHeight()) or 0
            local cx, cy
            if MapTravel._playerPosPx then
                -- center the view on the player marker
                cx = math.floor(pSize.width / 2 - MapTravel._playerPosPx.x * MapTravel.mapScale)
                cy = math.floor(topBarH + (pSize.height - topBarH) / 2 - MapTravel._playerPosPx.y * MapTravel.mapScale)
                -- keep canvas edges covering the panel
                cx = math.min(0, math.max(cx, pSize.width - cSize.width))
                cy = math.min(topBarH, math.max(cy, pSize.height - cSize.height))
            else
                cx = math.max(0, math.floor((pSize.width - cSize.width) / 2))
                cy = topBarH + math.max(0, math.floor((pSize.height - topBarH - cSize.height) / 2))
            end
            canvas:breakAnchors()
            canvas:setPosition({x = cx, y = cy})
        end
        MapTravel._canvasPositioned = true
    end

    -- Scrollbars wiring and sync
    MapTravel.setupScrollbars(canvas, boundsWidget)

    -- Mouse wheel zoom, anchored under the cursor
    canvas.onMouseWheel = function(_, mousePos, wheelDirection)
        MapTravel.wheelZoom(wheelDirection == MouseWheelUp and 1 or -1, mousePos)
        return true
    end
    if mapPanel then
        mapPanel.onMouseWheel = function(_, mousePos, wheelDirection)
            MapTravel.wheelZoom(wheelDirection == MouseWheelUp and 1 or -1, mousePos)
            return true
        end
    end

    -- Keep the top bar visually above the canvas regardless of drag position
    if mapPanel and mapPanel.topBar and mapPanel.topBar.raise then
        mapPanel.topBar:raise()
    end

    -- Ensure native top menu remains above this module (best-effort)
    if MapTravel.raiseNativeTopMenu then MapTravel.raiseNativeTopMenu() end

    -- Admin/debug readout (mouse -> img/world, player -> img)
    MapTravel.installAdminTools(canvas, mapPanel)

    -- Left rail: zoom slider + layer toggles
    MapTravel.installLeftRail()
    MapTravel.syncRailThumb()
end

-- Admin/debug tools: live readout of mouse -> image px -> estimated world pos,
-- plus player world pos -> image px. Right-click on the map copies the line.
------------------------------------------------------------
-- Painted-zones overlay (from RME-ZONES "Export Zones Overlay" -> zones.dat)
-- Same data source as the minimap zones overlay module.
------------------------------------------------------------
local MT_ZONES_FILE_CANDIDATES = {
    '/things/1098/zones.dat',
    '/things/zones.dat',
    '/data/things/1098/zones.dat',
    '/data/things/zones.dat',
    '/zones.dat',
}
local MT_ZONES_NAMES_CANDIDATES = {
    '/things/1098/zones.lua',
    '/things/zones.lua',
    '/data/things/1098/zones.lua',
    '/data/things/zones.lua',
    '/zones.lua',
}

local function mtMakeReader(data)
    local pos = 1
    local len = #data
    local r = {}
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

function MapTravel.loadZoneRects()
    MapTravel.zoneRects = {}
    local foundPath
    for _, p in ipairs(MT_ZONES_FILE_CANDIDATES) do
        if g_resources.fileExists(p) then foundPath = p; break end
    end
    if not foundPath then
        print('[MapTravel] zones.dat not found; zone overlay disabled.')
        return false
    end
    local ok, data = pcall(g_resources.readFileContents, foundPath)
    if not ok or not data or #data < 8 then
        print('[MapTravel] failed to read zones.dat at ' .. foundPath)
        return false
    end

    local r = mtMakeReader(data)
    if r:bytes(4) ~= 'ZONO' then
        print('[MapTravel] invalid zones.dat magic')
        return false
    end
    if r:u16() ~= 1 then
        print('[MapTravel] unsupported zones.dat version')
        return false
    end
    local zoneCount = r:u16()
    local totalRects = 0
    for i = 1, zoneCount do
        local id = r:u16()
        local cr, cg, cb = r:u8(), r:u8(), r:u8()
        local rectCount = r:u32()
        local rects = {}
        for j = 1, rectCount do
            rects[#rects + 1] = { x = r:u16(), y = r:u16(), z = r:u8(), w = r:u16(), h = r:u16() }
        end
        totalRects = totalRects + rectCount
        MapTravel.zoneRects[id] = { id = id, color = { cr, cg, cb }, rects = rects }
    end
    print(string.format('[MapTravel] loaded %d zones, %d rectangles from %s', zoneCount, totalRects, foundPath))
    return true
end

function MapTravel.loadZoneNames()
    MapTravel.zoneNames = {}
    MapTravel.zoneInfo = {}
    local foundPath
    for _, p in ipairs(MT_ZONES_NAMES_CANDIDATES) do
        if g_resources.fileExists(p) then foundPath = p; break end
    end
    if not foundPath then return false end
    local ok, data = pcall(g_resources.readFileContents, foundPath)
    if not ok or not data then return false end
    local currentId, captured = nil, true
    for line in data:gmatch('([^\r\n]+)') do
        local idMatch = line:match('^%s*%[(%d+)%]%s*=%s*{')
        if idMatch then
            currentId = tonumber(idMatch)
            captured = false
            MapTravel.zoneInfo[currentId] = { monsters = {} }
        elseif currentId and not captured then
            local nm = line:match('^%s*name%s*=%s*"([^"]+)"')
            if nm then
                MapTravel.zoneNames[currentId] = nm
                MapTravel.zoneInfo[currentId].name = nm
                captured = true
            end
        end
        if currentId then
            local info = MapTravel.zoneInfo[currentId]
            if info and not info.monstersParsed then
                local inner = line:match('monsters%s*=%s*{([^}]*)}')
                if inner then
                    for m in inner:gmatch('"([^"]+)"') do
                        table.insert(info.monsters, m)
                    end
                    info.monstersParsed = true
                end
            end
            if info and not info.boss then
                local boss = line:match('^%s*boss%s*=%s*"([^"]+)"')
                if boss then info.boss = boss end
            end
        end
    end
    return true
end

local function mtZoneColor(r, g, b, alpha)
    return string.format('#%02x%02x%02x%02x', r, g, b, math.floor((alpha or 1.0) * 255 + 0.5))
end

-- Boost zone colors: scale the dominant channel to 255 so every zone reads
-- as a vivid hue instead of the muted RME palette colors.
local function mtVivid(r, g, b)
    local m = math.max(r, g, b, 1)
    local k = 255 / m
    return math.min(255, math.floor(r * k + 0.5)),
           math.min(255, math.floor(g * k + 0.5)),
           math.min(255, math.floor(b * k + 0.5))
end

-- Renders painted zones as a pre-baked PNG layer aligned to the world map
-- via the same affine transform used by worldToPixelXY.
-- zones_overlay_all.png merges every floor (higher z wins on overlap).
function MapTravel.buildZoneTileSetMerged(pz)
    if MapTravel._zoneTileSetMerged and MapTravel._zoneTileSetMergedFloor == pz then
        return MapTravel._zoneTileSetMerged
    end
    local fmap = {}
    for id, zone in pairs(MapTravel.zoneRects or {}) do
        for _, rc in ipairs(zone.rects) do
            local x2 = rc.x + rc.w - 1
            local y2 = rc.y + rc.h - 1
            for ty = rc.y, y2 do
                for tx = rc.x, x2 do
                    fmap[tx * 65536 + ty] = id
                end
            end
        end
    end
    -- player floor wins on overlapping tiles
    for id, zone in pairs(MapTravel.zoneRects or {}) do
        for _, rc in ipairs(zone.rects) do
            if rc.z == pz then
                local x2 = rc.x + rc.w - 1
                local y2 = rc.y + rc.h - 1
                for ty = rc.y, y2 do
                    for tx = rc.x, x2 do
                        fmap[tx * 65536 + ty] = id
                    end
                end
            end
        end
    end
    MapTravel._zoneTileSetMerged = fmap
    MapTravel._zoneTileSetMergedFloor = pz
    local tileCount = 0
    for _ in pairs(fmap) do tileCount = tileCount + 1 end
    print(string.format('[MapTravel] zone tileset: %d tiles (player floor=%d)', tileCount, pz))
    return fmap
end

local function mtPlaceZoneLayer(canvas, imgPath, widgetId, cfg, baseW, baseH, s)
    if not g_resources.fileExists('/modules/game_MapTravel/' .. imgPath) then return nil end
    local sx = (baseW / cfg.tilesW) * (cfg.scaleX or 1)
    local sy = (baseH / cfg.tilesH) * (cfg.scaleY or 1)
    local offX = -(cfg.x0 or 0) * sx
    local offY = -(cfg.y0 or 0) * sy
    local overlay = g_ui.createWidget('UIWidget', canvas)
    overlay:setId(widgetId)
    overlay:breakAnchors()
    overlay:addAnchor(AnchorTop, 'parent', AnchorTop)
    overlay:addAnchor(AnchorLeft, 'parent', AnchorLeft)
    overlay:setMarginTop(math.floor(offY * s))
    overlay:setMarginLeft(math.floor(offX * s))
    overlay:setSize({
        width = math.max(1, math.floor(cfg.tilesW * sx * s)),
        height = math.max(1, math.floor(cfg.tilesH * sy * s)),
    })
    overlay:setImageSource(imgPath)
    overlay:setImageSmooth(true)
    overlay:setPhantom(true)   -- never intercepts clicks/hovers of nodes or canvas
    overlay:setFocusable(false)
    overlay:setBackgroundColor('alpha')
    return overlay
end

function MapTravel.renderZoneRects(canvas)
    if not canvas or canvas:isDestroyed() then return end
    local showSurf = not (MapTravel.filters and MapTravel.filters.showZones == false)
    local showUG = (MapTravel.filters and MapTravel.filters.showUGZones == true)
    if not showSurf and not showUG then return end

    if not MapTravel._zoneDataLoaded then
        MapTravel._zoneDataLoaded = true
        MapTravel.loadZoneRects()
        MapTravel.loadZoneNames()
    end
    if not MapTravel.zoneRects then return end

    local player = g_game.getLocalPlayer()
    local ppos = player and player:getPosition() or nil
    local pz = ppos and ppos.z or 7
    local s = MapTravel.mapScale or 1.0
    MapTravel._zoneHoverSet = MapTravel.buildZoneTileSetMerged(pz)

    local cfg = MapTravel.worldImageConfig
    local baseW = (MapTravel._baseMapSize and MapTravel._baseMapSize.width) or cfg.imgW
    local baseH = (MapTravel._baseMapSize and MapTravel._baseMapSize.height) or cfg.imgH
    local canvas2 = MapTravel.UI.mapPanel and MapTravel.UI.mapPanel.mapCanvas
    if canvas2 and canvas2.getImageWidth then
        local w2 = canvas2:getImageWidth()
        local h2 = canvas2:getImageHeight()
        if w2 and w2 > 0 and h2 and h2 > 0 then baseW, baseH = w2, h2 end
    end

    if showSurf then
        local ov = mtPlaceZoneLayer(canvas, 'images/zones_overlay_surface.png', 'zoneRectsOverlay', cfg, baseW, baseH, s)
        if not ov then print('[MapTravel] surface overlay PNG missing') end
    end
    if showUG then
        local ov = mtPlaceZoneLayer(canvas, 'images/zones_overlay_ug.png', 'zoneRectsOverlayUG', cfg, baseW, baseH, s)
        if not ov then print('[MapTravel] underground overlay PNG missing') end
    end
end

-- Attached-effect markers over zones with an active server-side zone event
-- (effect 901) or zone buff (effect 902). One phantom UICreature host per
-- marker; updates come from opcode 214 pushes + a snapshot on map open.
MapTravel.EVENT_MARKER_EFFECT_ID = 901
MapTravel.BUFF_MARKER_EFFECT_ID = 902
function MapTravel.renderZoneEventMarkers(canvas)
    if not canvas then return end
    if not (g_attachedEffects and g_attachedEffects.getById) then return end
    if not MapTravel._zoneDataLoaded then
        MapTravel._zoneDataLoaded = true
        MapTravel.loadZoneRects()
        MapTravel.loadZoneNames()
    end
    if not MapTravel.zoneRects then return end

    local s = MapTravel.mapScale or 1.0
    -- creatureSize = render scale of the effect; widget = creatureSize * factor
    -- so multi-tile effects have room (tune via eventMarkerCreatureSize/WidgetFactor)
    -- UIEffect draws the .dat effect into a framebuffer sized exactly to the
    -- effect itself -> never clipped. Widget scales it into its rect.
    local size = math.max(48, math.floor((MapTravel.eventMarkerWidgetSize or 128) * s))
    local drawn = 0

    local function centroid(zoneId)
        local zone = MapTravel.zoneRects[tonumber(zoneId)]
        if zone and zone.rects then
            local sumX, sumY, sumA = 0, 0, 0
            for _, rc in ipairs(zone.rects) do
                local a = rc.w * rc.h
                sumX = sumX + (rc.x + rc.w * 0.5) * a
                sumY = sumY + (rc.y + rc.h * 0.5) * a
                sumA = sumA + a
            end
            if sumA > 0 then
                return worldToPixelXY({ x = sumX / sumA, y = sumY / sumA, z = 7 })
            end
        end
        -- Fallback: zonesConfig node position (matched by zone name)
        local zname = MapTravel.zoneNames and MapTravel.zoneNames[tonumber(zoneId)]
        if zname then
            local lname = zname:lower()
            for _, zc in ipairs(MapTravel.zonesConfig or {}) do
                local zn = (zc.name or zc.displayName or ''):lower()
                if zn == lname and zc.modulePos then
                    return {
                        x = (zc.modulePos.marginLeft or 0) + ((MapTravel.zoneNodeSize or {}).width or 36) / 2,
                        y = (zc.modulePos.marginTop or 0) + ((MapTravel.zoneNodeSize or {}).height or 36) / 2,
                    }
                end
            end
        end
        return nil
    end

    local function marker(zoneId, suffix, datEffectId, dxPx)
        local p = centroid(zoneId)
        if not p then return nil end
        local m = g_ui.createWidget("UIEffect", canvas)
        m:setPhantom(true)
        m:setId("zoneEventMarker" .. suffix .. tostring(zoneId))
        m:addAnchor(AnchorTop, "parent", AnchorTop)
        m:addAnchor(AnchorLeft, "parent", AnchorLeft)
        m:setSize({ width = size, height = size })
        m:setMarginLeft(math.floor(p.x * s - size * 0.5 + (dxPx or 0) * s))
        m:setMarginTop(math.floor(p.y * s - size * 0.5))
        if m.setZIndex then m:setZIndex(182) end
        if m.setEffectId then m:setEffectId(datEffectId) end
        drawn = drawn + 1
        return p
    end

    for zoneId, _ in pairs(MapTravel.activeZoneEvents or {}) do
        marker(zoneId, "_ev_", MapTravel.eventMarkerDatEffect or 876, -12)
    end
    for zoneId, _ in pairs(MapTravel.activeZoneBuffs or {}) do
        marker(zoneId, "_bf_", MapTravel.buffMarkerDatEffect or 1540, 0)
    end
    if drawn > 0 then
        print(string.format('[MapTravel] drew %d zone event/buff marker(s)', drawn))
    end
end

function MapTravel.pixelToWorld(px, py)
    local cfg = MapTravel.worldImageConfig
    local imgW = (MapTravel._baseMapSize and MapTravel._baseMapSize.width) or cfg.imgW
    local imgH = (MapTravel._baseMapSize and MapTravel._baseMapSize.height) or cfg.imgH
    local sx = (imgW / cfg.tilesW) * (cfg.scaleX or 1)
    local sy = (imgH / cfg.tilesH) * (cfg.scaleY or 1)
    if sx == 0 or sy == 0 then return nil end
    return { x = px / sx + cfg.x0, y = py / sy + cfg.y0 }
end

function MapTravel.debugUpdateReadout(mousePos)
    local mapPanel = MapTravel.UI and MapTravel.UI.mapPanel
    local canvas = mapPanel and (mapPanel.mapCanvas or mapPanel)
    local lb = MapTravel._debugLabel
    if not canvas or not lb then return end
    local cPos = canvas:getPosition()
    local s = MapTravel.mapScale or 1.0
    local px = (mousePos.x - cPos.x) / s
    local py = (mousePos.y - cPos.y) / s
    local w = MapTravel.pixelToWorld(px, py)

    -- Zone name tooltip under cursor (tile lookup, all floors merged)
    if MapTravel._zoneHoverSet and w then
        local tipsOn = (not MapTravel.filters)
            or MapTravel.filters.showZones ~= false
            or MapTravel.filters.showUGZones == true
        local id = tipsOn
            and MapTravel._zoneHoverSet[math.floor(w.x) * 65536 + math.floor(w.y)]
        local tip = MapTravel.UI and MapTravel.UI.NodesTooltip
        if tip and tip.isDestroyed and tip:isDestroyed() then tip = nil end
        -- throttle: log what the hover resolves every ~1.5s
        local now = os.clock and os.clock() or 0
        if not MapTravel._tipDbgT or (now - MapTravel._tipDbgT) > 1.5 then
            MapTravel._tipDbgT = now
            print(string.format('[MapTravel] hover world(%.0f,%.0f) zone=%s hoverSet=%s tip=%s',
                w.x, w.y, tostring(id), tostring(MapTravel._zoneHoverSet ~= nil), tostring(tip ~= nil)))
        end
        if id and tip then
            if MapTravel._zoneTipId ~= id then
                MapTravel._zoneTipId = id
                local ok, err = pcall(MapTravel.applyPaintedZoneTooltip, id)
                if not ok then print('[MapTravel] zone tooltip error: ' .. tostring(err)) end
            end
            tip:show()
            MapTravel.moveNodeToolTip()
            MapTravel._zoneTipShowing = true
        elseif MapTravel._zoneTipShowing and tip then
            tip:hide()
            MapTravel._zoneTipShowing = false
            MapTravel._zoneTipId = nil
        end
    end

    local line = string.format("img(%d,%d) -> world(%d,%d)",
        math.floor(px), math.floor(py),
        w and math.floor(w.x) or -1, w and math.floor(w.y) or -1)
    local lp = g_game and g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
    local pp = lp and lp.getPosition and lp:getPosition() or nil
    if pp then
        local ppx = MapTravel._playerPosPx
        line = line .. string.format(" | player(%d,%d,%d) -> img(%d,%d)",
            pp.x, pp.y, pp.z,
            ppx and math.floor(ppx.x) or -1, ppx and math.floor(ppx.y) or -1)
    end
    line = line .. string.format(" | zoom %.2f", MapTravel.mapScale or 1.0)
    MapTravel._debugInfo = line
    lb:setText(line)
end

function MapTravel.installAdminTools(canvas, mapPanel)
    if not MapTravel._debugLabel and mapPanel then
        local lb = g_ui.createWidget('UILabel', mapPanel)
        lb:setId('mapTravelDebugPos')
        lb:addAnchor(AnchorBottom, 'parent', AnchorBottom)
        lb:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        lb:setMarginLeft(6)
        lb:setMarginBottom(18)
        lb:setColor('#ffff00')
        lb:setFont('verdana-11px-antialised')
        if lb.setZIndex then lb:setZIndex(210) end
        if lb.setBackgroundColor then lb:setBackgroundColor('#000000aa') end
        MapTravel._debugLabel = lb
    end
    if not canvas then return end
    local prevMove = canvas.onMouseMove
    canvas.onMouseMove = function(w, pos, mv)
        MapTravel.debugUpdateReadout(pos)
        if prevMove then return prevMove(w, pos, mv) end
        return false
    end
    local prevPress = canvas.onMousePress
    canvas.onMousePress = function(w, pos, btn)
        if btn == MouseRightButton then
            local info = MapTravel._debugInfo or ''
            if g_window and g_window.setClipboardText then
                g_window.setClipboardText(info)
            end
            print('[MapTravel] ' .. info)
            return true
        end
        if prevPress then return prevPress(w, pos, btn) end
        return false
    end
end

function MapTravel.makeWidgetDraggable(widget, bounds)
    widget.dragging = false
    widget.dragOffset = {x = 0, y = 0}

    widget.onMousePress = function(w, mousePos, button)
        if button ~= MouseLeftButton then
            return false
        end
        w.dragging = true
        local wPos = w:getPosition()
        w.dragOffset.x = mousePos.x - wPos.x
        w.dragOffset.y = mousePos.y - wPos.y
        return true
    end

    widget.onMouseRelease = function(w, mousePos, button)
        if w.dragging then
            w.dragging = false
            return true
        end
        return false
    end

    widget.onMouseMove = function(w, mousePos, mouseMoved)
        if not w.dragging then
            return false
        end

        local newX = mousePos.x - w.dragOffset.x
        local newY = mousePos.y - w.dragOffset.y

        -- Clamp to bounds widget if provided, otherwise clamp to screen
        local minX, minY, maxX, maxY
        if bounds and bounds.getPosition and bounds.getSize then
            local bPos = bounds:getPosition()
            local bSize = bounds:getSize()
            local wSize = w:getSize()
            -- Horizontal limits
            minX = bPos.x
            maxX = bPos.x + bSize.width - wSize.width
            -- Vertical limits: account for topBar height so dragging never hides the bar
            local topBarH = 0
            if MapTravel and MapTravel.UI and MapTravel.UI.mapPanel and MapTravel.UI.mapPanel.topBar and MapTravel.UI.mapPanel.topBar.getHeight then
                topBarH = MapTravel.UI.mapPanel.topBar:getHeight() or 0
            end
            minY = bPos.y + topBarH
            maxY = bPos.y + bSize.height - wSize.height
        else
            local screenSize = g_window.getSize()
            local wSize = w:getSize()
            minX = 0
            maxX = screenSize.width - wSize.width
            minY = 0
            maxY = screenSize.height - wSize.height
        end

        -- If content is larger than bounds, max may be less than min; normalize to [low, high]
        local lowX, highX = math.min(minX, maxX), math.max(minX, maxX)
        local lowY, highY = math.min(minY, maxY), math.max(minY, maxY)

        if newX < lowX then newX = lowX end
        if newX > highX then newX = highX end
        if newY < lowY then newY = lowY end
        if newY > highY then newY = highY end

        w:breakAnchors()
        w:setPosition({x = newX, y = newY})
        return true
    end
end


------ Extended Opcode Handling

function MapTravel.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= MapTravel_OPCODE then
		return
	end
	local data = json.decode(buffer)
	if not data or not data.topic then
		return
	end

	if data.topic == "full-MapTravel-Cache" then
		MapTravel.buildDiscoveredData(data.discoveredNodes)
		MapTravel.updateMap()
	elseif data.topic == "launch-MapTravel" then
		MapTravel.handleLaunchMapTravel(data)
	elseif data.topic == "close-MapTravel" then
		MapTravel.hide()
		focusRootPanel()
	elseif data.topic == "zone-event" then
		-- single-zone update: data.event == nil clears the marker
		MapTravel.activeZoneEvents = MapTravel.activeZoneEvents or {}
		MapTravel.activeZoneEvents[tonumber(data.zoneId) or data.zoneId] = data.event or nil
		print(string.format('[MapTravel] zone-event zone=%s event=%s',
			tostring(data.zoneId), data.event and tostring(data.event.name) or 'nil'))
		if MapTravel.UI and MapTravel.UI:isVisible() then
			MapTravel.updateMap()
		end
	elseif data.topic == "zone-buff" then
		-- single-zone buff update: data.buff == nil clears the buff marker
		MapTravel.activeZoneBuffs = MapTravel.activeZoneBuffs or {}
		MapTravel.activeZoneBuffs[tonumber(data.zoneId) or data.zoneId] = data.buff or nil
		print(string.format('[MapTravel] zone-buff zone=%s buff=%s',
			tostring(data.zoneId), data.buff and tostring(data.buff.name) or 'nil'))
		if MapTravel.UI and MapTravel.UI:isVisible() then
			MapTravel.updateMap()
		end
	elseif data.topic == "zone-events" then
		-- full snapshot (requested when the map opens)
		MapTravel.activeZoneEvents = {}
		MapTravel.activeZoneBuffs = {}
		for zid, ev in pairs(data.events or {}) do
			local id = tonumber(zid) or zid
			MapTravel.activeZoneEvents[id] = (ev.name and ev) or nil
			if ev.buff then
				MapTravel.activeZoneBuffs[id] = ev.buff
			end
		end
		local ec, bc = 0, 0
		for _ in pairs(MapTravel.activeZoneEvents) do ec = ec + 1 end
		for _ in pairs(MapTravel.activeZoneBuffs) do bc = bc + 1 end
		print(string.format('[MapTravel] zone-events snapshot: %d events, %d buffs', ec, bc))
		if MapTravel.UI and MapTravel.UI:isVisible() then
			MapTravel.updateMap()
		end
	end
end

function MapTravel.handleLaunchMapTravel(data)
    -- Launched by server -> interactive mode
    MapTravel.viewOnly = false
    MapTravel.currentNodeNameId = data.currentNode
    if MapTravel.UI and MapTravel.UI.viewOnlyBadge then
        MapTravel.UI.viewOnlyBadge:setVisible(false)
    end
    MapTravel.updateMap()
    MapTravel.show()
end

function MapTravel.buildDiscoveredData(discoveredNodes)
	MapTravel.unlockedNodes = {}
	if discoveredNodes then
		for _, nodeNameId in ipairs(discoveredNodes) do
			MapTravel.unlockedNodes[nodeNameId] = true
		end
	end
end

function MapTravel.requestTravel(nodeIndex, currentNode)
	local data = {
		topic = "travel",
		nodeIndex = nodeIndex,
		currentNode= currentNode,
	}
	MapTravel.sendOpcode(data)
end

function MapTravel.sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()
	if protocolGame then
		protocolGame:sendExtendedJSONOpcode(MapTravel_OPCODE, data)
	end
end


------ Node Interaction

function MapTravel.onNodeHoverChange(widget, hovered)
	if not MapTravel.UI then
		return
	end

	if widget.nameId == MapTravel.currentNodeNameId then
		return
	end

	if hovered then
		MapTravel.applyNodeTooltip(widget.nodeConfig)
		connect(rootWidget, {onMouseMove = MapTravel.moveNodeToolTip})
		widget:setImageSource("images/nodes/hover/" .. tostring(widget.nameId):lower())
	else
		MapTravel.UI.NodesTooltip:hide()
		disconnect(rootWidget, {onMouseMove = MapTravel.moveNodeToolTip})
		widget:setImageSource("images/nodes/normal/" .. tostring(widget.nameId):lower())
	end

	local originalWidth = widget:getWidth()
	local originalHeight = widget:getHeight()
	widget:setWidth(originalWidth * MapTravel.mapScale)
	widget:setHeight(originalHeight * MapTravel.mapScale)
end

-- Auto-fit the tooltip width to its content (measures real text widths)
function MapTravel.fitTooltipSize()
    local tip = MapTravel.UI and MapTravel.UI.NodesTooltip
    if not tip or (tip.isDestroyed and tip:isDestroyed()) then return end
    local maxW = 60
    for _, child in ipairs(tip:getChildren()) do
        -- MapTravelZoneHeader rows: measure name/level labels + icon
        if child.info then
            local innerW = 46 -- creature/image icon 38 + margin 8
            for _, lbl in ipairs({ child.info.name, child.info.level }) do
                if lbl and lbl.getTextSize then
                    local ts = lbl:getTextSize()
                    if ts then innerW = math.max(innerW, 46 + ts.width) end
                end
            end
            maxW = math.max(maxW, innerW)
        elseif child.text and child.text.getTextSize then
            local ts = child.text:getTextSize()
            if ts then maxW = math.max(maxW, ts.width + 40) end -- icon ~30 + margin
        end
    end
    -- include the panel title text
    if tip.getTextSize then
        local ts = tip:getTextSize()
        if ts then maxW = math.max(maxW, ts.width + 10) end
    end
    local w = math.max(140, math.min(340, maxW + 30)) -- padding 15x2
    tip:setWidth(w)
    -- children must stretch to the panel width: header has no own width in OTUI,
    -- so its right-anchored 'info' collapses unless we set it here
    local innerW = w - 30 -- padding 15x2
    for _, child in ipairs(tip:getChildren()) do
        child:setWidth(innerW)
    end
end

function MapTravel.addTooltipLine(text, iconKey)
	local entry = g_ui.createWidget("MapTravelCostEntry", MapTravel.UI.NodesTooltip)
	entry.text:setText(text)

	local iconPath = MapTravel.icons[iconKey or ""]
	-- allow passing a direct image path (e.g. buff icons) or a buffIcons key
	if not iconPath and iconKey then
		iconPath = (MapTravel.buffIcons and MapTravel.buffIcons[iconKey])
			or (iconKey:sub(1, 1) == '/' and iconKey)
	end
	if iconPath then
		entry.icon:setImageSource(iconPath)
	else
		entry.icon:setImageSource("")
	end
end

-- Row with the real monster/boss sprite (UICreature) resolved by name
-- from MapTravelMonsterLook (generated from the server monster XMLs).
function MapTravel.addMonsterLine(name, isBoss)
	local entry = g_ui.createWidget("MapTravelMonsterEntry", MapTravel.UI.NodesTooltip)
	local lt = MapTravelMonsterLook and MapTravelMonsterLook[name:lower()]
	if lt and entry.creatureIcon and entry.creatureIcon.setOutfit then
		entry.creatureIcon:setOutfit({ type = lt })
		entry.creatureIcon:setVisible(true)
	else
		-- unknown monster: keep the slot but hide the creature (no broken sprite)
		entry.creatureIcon:setVisible(false)
	end
	entry.text:setText((isBoss and "Boss: " or "") .. name)
	if isBoss and entry.text.setColor then
		entry.text:setColor('#de6f6f')
	end
	return entry
end

function MapTravel.applyNodeTooltip(nodeConfig)
	MapTravel.UI.NodesTooltip:destroyChildren()

	MapTravel.UI.NodesTooltip:setText(nodeConfig.displayName)

	if nodeConfig.premium then
		MapTravel.addTooltipLine("Requires Premium Account", "premium")
	end

	if nodeConfig.storagesReqs and #nodeConfig.storagesReqs > 0 then
		for _, storReq in ipairs(nodeConfig.storagesReqs) do
			MapTravel.addTooltipLine(storReq.name, "progressReq")
		end
	end

	if nodeConfig.cost then
		if nodeConfig.cost.gold and nodeConfig.cost.gold > 0 then
			MapTravel.addTooltipLine("Gold: " .. nodeConfig.cost.gold, "gold")
		end

		if nodeConfig.cost.items and #nodeConfig.cost.items > 0 then
			for _, itemInfo in ipairs(nodeConfig.cost.items) do
				local lineText = string.format("%dx %s", itemInfo.amount, itemInfo.name)
				MapTravel.addTooltipLine(lineText, "item")
			end
		end

		if nodeConfig.cost.storage and #nodeConfig.cost.storage > 0 then
			for _, sInfo in ipairs(nodeConfig.cost.storage) do
				local lineText = string.format("%d %s", sInfo.amount, sInfo.name)
				MapTravel.addTooltipLine(lineText, "storage")
			end
		end
	end

	MapTravel.fitTooltipSize()
	MapTravel.UI.NodesTooltip:show()
	MapTravel.moveNodeToolTip()
end

function MapTravel.moveNodeToolTip()
	if not MapTravel.UI or not MapTravel.UI.NodesTooltip or not MapTravel.UI.NodesTooltip:isVisible() then
		return
	end

	local pos = g_window.getMousePosition()
	local windowSize = g_window.getSize()
	local tipSize = MapTravel.UI.NodesTooltip:getSize()

	pos.x = pos.x + 1
	pos.y = pos.y + 1

	if (windowSize.width - (pos.x + tipSize.width)) < 10 then
		pos.x = pos.x - tipSize.width - 3
	else
		pos.x = pos.x + 10
	end

	if (windowSize.height - (pos.y + tipSize.height)) < 10 then
		pos.y = pos.y - tipSize.height - 3
	else
		pos.y = pos.y + 10
	end

	MapTravel.UI.NodesTooltip:setPosition(pos)
	MapTravel.UI.NodesTooltip:raise()
end

-- Zone nodes: only tooltip on hover; no click travel
function MapTravel.onZoneHoverChange(widget, hovered, zone)
    if not MapTravel.UI then
        return
    end

    if hovered then
        MapTravel.applyZoneTooltip(zone)
        connect(rootWidget, {onMouseMove = MapTravel.moveNodeToolTip})
    else
        MapTravel.UI.NodesTooltip:hide()
        disconnect(rootWidget, {onMouseMove = MapTravel.moveNodeToolTip})
    end
end

-- Creates the creature/image header row inside the tooltip (reusable)
function MapTravel.addZoneTooltipHeader(zone)
    -- Create header with creature and texts
    local header = g_ui.createWidget("MapTravelZoneHeader", MapTravel.UI.NodesTooltip)
    -- Choose icon type: outfit (creature) or static image
    if zone.outfit then
        -- Show creature icon, hide image icon
        if header.imageIcon and header.imageIcon.setVisible then
            header.imageIcon:setVisible(false)
        end
        if header.creatureIcon then
            header.creatureIcon:setVisible(true)
            header.creatureIcon:setOutfit(zone.outfit)
            if header.creatureIcon.setCenter then
                header.creatureIcon:setCenter(true)
            end
        end
    elseif zone.image then
        -- Show image icon, hide creature icon
        if header.creatureIcon and header.creatureIcon.setVisible then
            header.creatureIcon:setVisible(false)
        end
        if header.imageIcon then
            header.imageIcon:setVisible(true)
            if header.imageIcon.setImageSource then
                header.imageIcon:setImageSource(zone.image)
            end
        end
    end
    local zoneName = zone.name or "Unknown Zone"
    header.info.name:setText(zoneName)
    if header.info.name.setTextAlign then
        header.info.name:setTextAlign(AlignLeft)
    end
    -- do not set panel title; zone header will carry its own texts
    -- ensure visible color (some skins may override defaults)
    if header.info.name.setColor then
        header.info.name:setColor('#dfdfdf')
    end
    if zone.recommendedLevel then
        header.info.level:setText("Recommended Lv. " .. tostring(zone.recommendedLevel))
    else
        header.info.level:setText("")
    end
    if header.info.level.setColor then
        header.info.level:setColor('#cccccc')
    end
    if header.info.level.setTextAlign then
        header.info.level:setTextAlign(AlignLeft)
    end
    return header
end

function MapTravel.applyZoneTooltip(zone)
    MapTravel.UI.NodesTooltip:destroyChildren()
    -- Ensure no leftover title from travel nodes
    if MapTravel.UI.NodesTooltip.setText then
        MapTravel.UI.NodesTooltip:setText("")
    end
    MapTravel.addZoneTooltipHeader(zone)
    MapTravel.fitTooltipSize()
    MapTravel.UI.NodesTooltip:show()
    MapTravel.moveNodeToolTip()
end

-- Tooltip for painted zones (zones.dat rects): creature icon(s) + level from
-- zonesConfig entries whose name matches the zone name, plus monster list.
function MapTravel.applyPaintedZoneTooltip(zoneId)
    local tip = MapTravel.UI and MapTravel.UI.NodesTooltip
    if not tip or (tip.isDestroyed and tip:isDestroyed()) then return end
    tip:destroyChildren()
    if tip.setText then tip:setText("") end

    local name = MapTravel.zoneNames and MapTravel.zoneNames[zoneId]
    local matched = false
    local lname = name and name:lower() or nil
    local hdrCount = 0
    for _, zc in ipairs(MapTravel.zonesConfig or {}) do
        local zn = (zc.name or zc.displayName or ''):lower()
        if lname and zn == lname then
            local ok, err = pcall(MapTravel.addZoneTooltipHeader, zc)
            if ok then
                hdrCount = hdrCount + 1
                matched = true
            else
                print('[MapTravel] header error: ' .. tostring(err))
            end
        end
    end
    if matched then
        print(string.format('[MapTravel] zone tooltip: "%s" -> %d header(s)', tostring(name), hdrCount))
    end
    if not matched and tip.setText then
        tip:setText(name or string.format('Zone %d', zoneId))
    end

    local info = MapTravel.zoneInfo and MapTravel.zoneInfo[zoneId]
    if info then
        if info.monsters and #info.monsters > 0 then
            local maxShow = 8
            for i, mname in ipairs(info.monsters) do
                if i > maxShow then
                    MapTravel.addTooltipLine(string.format('... +%d more', #info.monsters - maxShow), nil)
                    break
                end
                MapTravel.addMonsterLine(mname, false)
            end
        end
        if info.boss then
            MapTravel.addMonsterLine(info.boss, true)
        end
    end

    -- Active zone event (pushed by the server on opcode 214)
    local ev = MapTravel.activeZoneEvents
        and (MapTravel.activeZoneEvents[zoneId] or MapTravel.activeZoneEvents[tostring(zoneId)])
    if ev then
        local prog = (tonumber(ev.amount) or 0) > 0
            and string.format(' [%d/%d]', ev.progress or 0, ev.amount)
            or ''
        MapTravel.addTooltipLine('Event: ' .. tostring(ev.name or 'Active') .. prog, '/images/icons/star')
    end

    -- Active zone buff (ZoneBuffs -> opcode 214)
    local bf = MapTravel.activeZoneBuffs
        and (MapTravel.activeZoneBuffs[zoneId] or MapTravel.activeZoneBuffs[tostring(zoneId)])
    if bf then
        local rem = tonumber(bf.remaining) or 0
        local remStr = rem > 0 and string.format(' (%dm %ds)', math.floor(rem / 60), rem % 60) or ''
        MapTravel.addTooltipLine('Buff: ' .. tostring(bf.name or 'Active') .. remStr, bf.icon or bf.type)
    end

    MapTravel.fitTooltipSize()
    tip:show()
    MapTravel.moveNodeToolTip()
end


------ Development Mode

function MapTravel.onDevModeHoverChange(widget, hovered)
	if MapTravel.UI and MapTravel.devMode then
		if hovered then
			connect(rootWidget, {onMouseMove = MapTravel.updateDevNodePreviewNodePosition})
		else
			disconnect(rootWidget, {onMouseMove = MapTravel.updateDevNodePreviewNodePosition})
		end
	end
end

function MapTravel.setupDevMode()
	local mapPanel = MapTravel.UI.mapPanel
	if not mapPanel then
		return
	end

	mapPanel.devModePanel:setVisible(true)
	mapPanel.nodesComboBox:setVisible(true)
	mapPanel.mapImageDev:setVisible(true)

	mapPanel.nodesComboBox:clear()

	for _, nodeConfig in ipairs(MapTravel.mapNodesConfig) do
		mapPanel.nodesComboBox:addOption(nodeConfig.nameId)
	end

	mapPanel.nodesComboBox.onOptionChange = function()
		if MapTravel.previewNode then
			MapTravel.previewNode:setImageSource("images/nodes/normal/" .. tostring(mapPanel.nodesComboBox:getText()):lower())
			MapTravel.previewNode:setWidth(MapTravel.previewNode:getWidth() * MapTravel.mapScale)
			MapTravel.previewNode:setHeight(MapTravel.previewNode:getHeight() * MapTravel.mapScale)
		end
	end

	mapPanel.mapImageDev.onHoverChange = MapTravel.onDevModeHoverChange

	mapPanel.mapImageDev.onClick = function(widget, mousePos)
		local globalMouse = g_window.getMousePosition()
		local mapPos = mapPanel:getPosition()

		local marginLeft = globalMouse.x - mapPos.x
		local marginTop = globalMouse.y - mapPos.y
		local marginsText = "{marginTop = " .. marginTop .. ", marginLeft = " .. marginLeft .. "}"

		-- print("Clicked at: " .. marginsText)
		g_window.setClipboardText(marginsText)
	end
end

function MapTravel.updateDevNodePreviewNodePosition()
	if not MapTravel.previewNode or not MapTravel.previewNode:isVisible() then
		return
	end

	local mousePos = g_window.getMousePosition()
	local mapImage = MapTravel.UI.mapPanel

	if mapImage then
		local mapPos = mapImage:getPosition()
		local marginLeft = mousePos.x - mapPos.x
		local marginTop = mousePos.y - mapPos.y

		MapTravel.UI.mapPanel.devModePanel:setText(
			"Dev Mode\nMargin Top: " .. marginTop .. "\nMargin Left: " .. marginLeft
		)

		MapTravel.previewNode:setPosition(
			{
				x = mapPos.x + marginLeft,
				y = mapPos.y + marginTop
			}
		)
	end
end
