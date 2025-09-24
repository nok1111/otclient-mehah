-- Resolve UI controls inside the topBar safely
function MapTravel.getFilterControls()
    if not MapTravel.UI or not MapTravel.UI.mapPanel then return {} end
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

    -- Preserve static UI children (topBar, badges, dev widgets) and destroy only dynamic map children
    if mapPanel.getChildren then
        local keep = {
            topBar = true,
            viewOnlyBadge = true,
            mapImageDev = true,
            devModePanel = true,
            nodesComboBox = true,
        }
        for _, child in ipairs(mapPanel:getChildren()) do
            local id = child.getId and child:getId() or ""
            if not keep[id] then
                child:destroy()
            end
        end
    else
        mapPanel:destroyChildren()
    end

	mapPanel:setImageSource(MapTravel.mapDirectory)
	MapTravel.originalWidth = mapPanel:getWidth()
	MapTravel.originalHeight = mapPanel:getHeight()
	mapPanel:setWidth(MapTravel.originalWidth * MapTravel.mapScale)
	mapPanel:setHeight(MapTravel.originalHeight * MapTravel.mapScale)

	if MapTravel.devMode then
		MapTravel.previewNode = g_ui.createWidget("UIWidget", mapPanel)
		MapTravel.previewNode:setBorderWidth(1)
		MapTravel.previewNode:show()
		MapTravel.previewNode:setImageAutoResize(true)
		MapTravel.previewNode:setPhantom(true)
		MapTravel.UI.mapPanel:setBorderWidth(1)
		MapTravel.UI.mapPanel:setBorderColor("red")
		MapTravel.UI.mapPanel.mapImageDev:setImageSource(MapTravel.mapFilledDirectory or "")
	end

    -- Top offset to account for topBar height if present
    local topBarHeight = 0
    if MapTravel.UI and MapTravel.UI.mapPanel and MapTravel.UI.mapPanel.topBar then
        topBarHeight = MapTravel.UI.mapPanel.topBar:getHeight() or 0
    end

	for nodeIndex, nodeConfig in ipairs(MapTravel.mapNodesConfig) do
		local nodeWidget = g_ui.createWidget("MapTravelNode", mapPanel)
		nodeWidget:addAnchor(AnchorTop, "parent", AnchorTop)
		nodeWidget:addAnchor(AnchorLeft, "parent", AnchorLeft)

		nodeWidget:setMarginTop((nodeConfig.modulePos.marginTop * MapTravel.mapScale) + topBarHeight)
		nodeWidget:setMarginLeft(nodeConfig.modulePos.marginLeft * MapTravel.mapScale)

		nodeWidget.nameId = nodeConfig.nameId
		nodeWidget.nodeConfig = nodeConfig
		nodeWidget.originalMargin = {
			marginTop = nodeConfig.modulePos.marginTop,
			marginLeft = nodeConfig.modulePos.marginLeft
		}

		nodeWidget.onHoverChange = MapTravel.onNodeHoverChange

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
            local zoneWidget = g_ui.createWidget(widgetType, mapPanel)
            zoneWidget:addAnchor(AnchorTop, "parent", AnchorTop)
            zoneWidget:addAnchor(AnchorLeft, "parent", AnchorLeft)

            local mTop = ((zone.modulePos.marginTop or 0) * MapTravel.mapScale) + topBarHeight
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
        end
    end
    MapTravel.makeWidgetDraggable(mapPanel, true)
end

function MapTravel.makeWidgetDraggable(widget, boundToScreen)
    widget.dragging = false
    widget.dragOffset = {x = 0, y = 0}
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

		if boundToScreen then
			local screenSize = g_window.getSize()
			local widgetSize = w:getSize()

			local maxX = screenSize.width - widgetSize.width
			if newX < 0 then
				newX = 0
			end
			if newX > maxX then
				newX = maxX
			end

			local maxY = screenSize.height - widgetSize.height
			if newY < 0 then
				newY = 0
			end
			if newY > maxY then
				newY = maxY
			end
		end
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
