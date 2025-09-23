

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

	mapPanel:destroyChildren()

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

	for nodeIndex, nodeConfig in ipairs(MapTravel.mapNodesConfig) do
		local nodeWidget = g_ui.createWidget("MapTravelNode", mapPanel)
		nodeWidget:addAnchor(AnchorTop, "parent", AnchorTop)
		nodeWidget:addAnchor(AnchorLeft, "parent", AnchorLeft)

		nodeWidget:setMarginTop(nodeConfig.modulePos.marginTop * MapTravel.mapScale)
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
			nodeVisible = false
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

		MapTravel.originalNodeWidgetWidth = nodeWidget:getWidth()
		MapTravel.originalNodeWidgetHeight = nodeWidget:getHeight()
		nodeWidget:setWidth(MapTravel.originalNodeWidgetWidth * MapTravel.mapScale)
		nodeWidget:setHeight(MapTravel.originalNodeWidgetHeight * MapTravel.mapScale)

		if nodeEnabled then
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

			local mTop = (zone.modulePos.marginTop or 0) * MapTravel.mapScale
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
	MapTravel.currentNodeNameId = data.currentNode
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
