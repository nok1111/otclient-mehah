-- Global scale applier used by buttons and wheel
function MapTravel.applyScale(newScale)
    MapTravel.mapScale = newScale
    MapTravel._canvasPositioned = false
    MapTravel.applyFiltersAndRedraw()
end

-- World-to-image transform config (adjust x0,y0 if your image doesn't start at 0,0)
MapTravel.worldImageConfig = MapTravel.worldImageConfig or {
    tilesW = 2048,
    tilesH = 2048,
    imgW   = 1347,
    imgH   = 1371,
    x0     = 50,     -- top-left world tile X of the image
    y0     = -250,     -- top-left world tile Y of the image
}

local function worldToPixelXY(pos)
    if not pos then return nil end
    local cfg = MapTravel.worldImageConfig
    local sx = cfg.imgW / cfg.tilesW
    local sy = cfg.imgH / cfg.tilesH
    local px = (pos.x - cfg.x0) * sx
    local py = (pos.y - cfg.y0) * sy
    -- clamp to image
    if px < 0 or py < 0 or px > cfg.imgW or py > cfg.imgH then
        -- outside image; still return clamped coords
        if px < 0 then px = 0 end
        if py < 0 then py = 0 end
        if px > cfg.imgW then px = cfg.imgW end
        if py > cfg.imgH then py = cfg.imgH end
    end
    return { x = px, y = py }
end

-- Shared mouse wheel zoom handler
function MapTravel.wheelZoom(direction)
    -- Match buttons: scrolling forward (direction > 0) zooms IN, backward zooms OUT
    local factor = (direction > 0) and 1.2 or (1/1.2)
    local s = (MapTravel.mapScale or 1.0) * factor
    if s > 4.0 then s = 4.0 end
    if s < 0.4 then s = 0.4 end
    MapTravel.applyScale(s)
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
    if MapTravel.viewOnly then
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
            -- Create marker
            local m = g_ui.createWidget("UIWidget", canvas)
            m:setPhantom(true)
            m:setImageSource("images/icons/wow_source")
            m:setImageAutoResize(true)
            m:setSize({width = 64, height = 64})
            m:setId("youAreHereMarker")
            if m.setZIndex then m:setZIndex(180) end
            -- Position considering current scale and center the icon
            local mx = (MapTravel._playerPosPx.x * MapTravel.mapScale) - (m:getWidth() / 2)
            local my = (MapTravel._playerPosPx.y * MapTravel.mapScale) - (m:getHeight() / 2)
            m:addAnchor(AnchorTop, "parent", AnchorTop)
            m:addAnchor(AnchorLeft, "parent", AnchorLeft)
            m:setMarginLeft(math.floor(mx))
            m:setMarginTop(math.floor(my))
            MapTravel._playerMarker = m
        end
    end

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
            local desired = (MapTravel.filters and MapTravel.filters.showZones == false) and 'Hide monsters'
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
                MapTravel.filters.showZones = false
                -- do not change the remembered levelRange when hiding
            else
                MapTravel.filters.showZones = true
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
                local desired = (MapTravel.filters.showZones == false) and 'Hide monsters' or MapTravel.filters.levelRange
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
            if C.toggleZones.setChecked then C.toggleZones:setChecked(MapTravel.filters and MapTravel.filters.showZones) end
        end)
        C.toggleZones.onCheckChange = function(_, checked)
            if MapTravel._suppressFilterCallbacks then return end
            MapTravel.filters.showZones = checked and true or false
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
            MapTravel.filters.showZones = (C.toggleZones.isChecked and C.toggleZones:isChecked()) or false
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
                local cx = bPos.x + math.max(0, math.floor((bSize.width - cSize.width) / 2))
                local cy = bPos.y + topBarH + math.max(0, math.floor((bSize.height - topBarH - cSize.height) / 2))
                canvas:breakAnchors(); canvas:setPosition({x = cx, y = cy})
                MapTravel.syncScrollbars(canvas, bounds)
            end
        end
    end

    -- Scroll speed control
    if C.scrollSpeed and C.scrollSpeed.clear and C.scrollSpeed.addOption then
        withSuppressed(function()
            C.scrollSpeed:clear()
            for _, opt in ipairs({'Slow','Normal','Fast'}) do C.scrollSpeed:addOption(opt) end
            local current = (MapTravel.scrollStep == 40 and 'Slow') or (MapTravel.scrollStep == 60 and 'Normal') or (MapTravel.scrollStep == 90 and 'Fast') or 'Normal'
            if C.scrollSpeed.setCurrentOptionByText then C.scrollSpeed:setCurrentOptionByText(current) end
        end)
        C.scrollSpeed.onOptionChange = function()
            if MapTravel._suppressFilterCallbacks then return end
            local txt = C.scrollSpeed.getText and C.scrollSpeed:getText() or 'Normal'
            MapTravel.scrollStep = (txt == 'Slow' and 40) or (txt == 'Fast' and 90) or 60
        end
    end

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
            if s < 0.4 then s = 0.4 end
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
		MapTravel.hotkeyBinding = g_keyboard.bindKeyDown('Ctrl+M', function()
            if MapTravel.UI and MapTravel.UI:isVisible() then
                MapTravel.hide()
                return
            end
            MapTravel.viewOnly = true
            -- ensure UI exists and map is up to date
            if g_game.isOnline() then
                MapTravel.updateMap()
                if MapTravel.UI and MapTravel.UI.viewOnlyBadge then
                    MapTravel.UI.viewOnlyBadge:setVisible(true)
                end
                MapTravel.show()
            end
        end)
	end

	if g_game.isOnline() then
		MapTravel.onGameStart()
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
	if MapTravel.hotkeyBinding and g_keyboard and g_keyboard.unbindKeyDown then
		g_keyboard.unbindKeyDown(MapTravel.hotkeyBinding)
		MapTravel.hotkeyBinding = nil
	end
	MapTravel.onGameEnd()
end

function MapTravel.onGameStart()
    if not MapTravel.UI then
        MapTravel.UI = g_ui.displayUI("MapTravel")
        MapTravel.UI:hide()

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
            showZones = true,
        }

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
		MapTravel.UI:raise()
		-- MapTravel.UI:focus() -- Allow walking while map is open
		if MapTravel.UI.mapPanel then
			MapTravel.UI.mapPanel:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			MapTravel.UI.mapPanel:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
		end
	end
end

function MapTravel.hide()
	if MapTravel.UI then
		MapTravel.UI:hide()
		MapTravel.UI.NodesTooltip:hide()
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
    MapTravel.mapScale = MapTravel.mapScale or 1.0
    -- Cache base size once from the image natural size
    if not MapTravel._baseMapSize then
        local w = canvas:getWidth()
        local h = canvas:getHeight()
        MapTravel._baseMapSize = { width = w, height = h }
    end
    if canvas.setWidth then canvas:setWidth(MapTravel._baseMapSize.width * MapTravel.mapScale) end
    if canvas.setHeight then canvas:setHeight(MapTravel._baseMapSize.height * MapTravel.mapScale) end

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
				nodeImage = "images/nodes/current/" .. nodeConfig.nameId
				nodeEnabled = true
				nodeVisible = true
			else
				nodeImage = "images/nodes/normal/" .. nodeConfig.nameId
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
                -- Hide monsters toggle first: hide only outfit (monster) nodes when OFF
                if (MapTravel.filters.showZones == false) and (not isImageNode) and zone.outfit then
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
                        zoneWidget:setOpacity(0.2)
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
    -- Drag and pan the canvas within mapPanel area (below top bar)
    local boundsWidget = mapPanel
    MapTravel.makeWidgetDraggable(canvas, boundsWidget)

    -- Center canvas initially inside bounds (only the first time or when scaled)
    if not MapTravel._canvasPositioned then
        if mapPanel and mapPanel.getSize and canvas.getSize then
            local pSize = mapPanel:getSize()
            local cSize = canvas:getSize()
            local topBarH = (mapPanel.topBar and mapPanel.topBar:getHeight()) or 0
            local cx = math.max(0, math.floor((pSize.width - cSize.width) / 2))
            local cy = topBarH + math.max(0, math.floor((pSize.height - topBarH - cSize.height) / 2))
            canvas:breakAnchors()
            canvas:setPosition({x = cx, y = cy})
        end
        MapTravel._canvasPositioned = true
    end

    -- Scrollbars wiring and sync
    MapTravel.setupScrollbars(canvas, boundsWidget)

    -- Disable mouse wheel zoom on canvas and container
    canvas.onMouseWheel = nil
    if mapPanel then mapPanel.onMouseWheel = nil end
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
            minX = bPos.x
            minY = bPos.y
            maxX = bPos.x + bSize.width - wSize.width
            maxY = bPos.y + bSize.height - wSize.height
        else
            local screenSize = g_window.getSize()
            local wSize = w:getSize()
            minX = 0
            minY = 0
            maxX = screenSize.width - wSize.width
            maxY = screenSize.height - wSize.height
        end

        if newX < minX then newX = minX end
        if newX > maxX then newX = maxX end
        if newY < minY then newY = minY end
        if newY > maxY then newY = maxY end

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
		widget:setImageSource("images/nodes/hover/" .. widget.nameId)
	else
		MapTravel.UI.NodesTooltip:hide()
		disconnect(rootWidget, {onMouseMove = MapTravel.moveNodeToolTip})
		widget:setImageSource("images/nodes/normal/" .. widget.nameId)
	end

	local originalWidth = widget:getWidth()
	local originalHeight = widget:getHeight()
	widget:setWidth(originalWidth * MapTravel.mapScale)
	widget:setHeight(originalHeight * MapTravel.mapScale)
end

function MapTravel.addTooltipLine(text, iconKey)
	local entry = g_ui.createWidget("MapTravelCostEntry", MapTravel.UI.NodesTooltip)
	entry.text:setText(text)

	local iconPath = MapTravel.icons[iconKey or ""]
	if iconPath then
		entry.icon:setImageSource(iconPath)
	else
		entry.icon:setImageSource("")
	end
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

function MapTravel.applyZoneTooltip(zone)
    MapTravel.UI.NodesTooltip:destroyChildren()
    -- Ensure no leftover title from travel nodes
    if MapTravel.UI.NodesTooltip.setText then
        MapTravel.UI.NodesTooltip:setText("")
    end

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
        -- Ensure info is anchored to creature icon
        if header.info and header.info.breakAnchors and header.info.addAnchor then
            header.info:breakAnchors()
            header.info:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
            header.info:addAnchor(AnchorLeft, "creatureIcon", AnchorRight)
            header.info:addAnchor(AnchorRight, "parent", AnchorRight)
            header.info:setMarginLeft(8)
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
        -- Anchor info to the image icon's right
        if header.info and header.info.breakAnchors and header.info.addAnchor then
            header.info:breakAnchors()
            header.info:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
            header.info:addAnchor(AnchorLeft, "imageIcon", AnchorRight)
            header.info:addAnchor(AnchorRight, "parent", AnchorRight)
            header.info:setMarginLeft(8)
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

    MapTravel.UI.NodesTooltip:show()
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
			MapTravel.previewNode:setImageSource("images/nodes/normal/" .. mapPanel.nodesComboBox:getText())
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

		print("Clicked at: " .. marginsText)
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
