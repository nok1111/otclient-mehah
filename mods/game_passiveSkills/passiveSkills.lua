
------ Initialization and Termination

function PassiveSkills.init()
	connect(
		g_game,
		{
			onGameStart = PassiveSkills.onGameStart,
			onGameEnd = PassiveSkills.onGameEnd
		}
	)
	ProtocolGame.registerExtendedOpcode(PassiveSkills.opCode, PassiveSkills.onExtendedOpcode)
	if g_game.isOnline() then
		PassiveSkills.onGameStart()
	end
end

function PassiveSkills.terminate()
	disconnect(
		g_game,
		{
			onGameStart = PassiveSkills.onGameStart,
			onGameEnd = PassiveSkills.onGameEnd
		}
	)
	ProtocolGame.unregisterExtendedOpcode(PassiveSkills.opCode)
	PassiveSkills.onGameEnd()
end

function PassiveSkills.onGameStart()
	PassiveSkills.UI = g_ui.displayUI("passiveSkills")
	PassiveSkills.UI:hide()

	if not PassiveSkills.Button then
		PassiveSkills.Button = modules.game_mainpanel.addStoreButton("PassiveSkills", tr("Talent Tree"), "/images/options/large_stats", PassiveSkills.toggle, false, 9)
		PassiveSkills.Button:setOn(false)
	end

	PassiveSkills.Tooltip = g_ui.displayUI("NodeTooltip")
	PassiveSkills.Tooltip:hide()

	PassiveSkills.setupDialogButtons()

	if PassiveSkills.UI.ResetButton then
		PassiveSkills.UI.ResetButton.onClick = PassiveSkills.onResetButtonClick
	end

	PassiveSkills.cachedProgress = nil
	PassiveSkills.cachedTreeId = nil
	PassiveSkills.cachedTreeData = nil
	PassiveSkills.cachedAvailablePoints = nil
	PassiveSkills.cachedTotalPoints = nil
	PassiveSkills.sendOpcode({ topic = "base-data-request" })
end

function PassiveSkills.onGameEnd()
	if PassiveSkills.Tooltip then
		PassiveSkills.Tooltip:destroy()
		PassiveSkills.Tooltip = nil
	end

	if PassiveSkills.Button then
		PassiveSkills.Button:destroy()
		PassiveSkills.Button = nil
	end

	if PassiveSkills.UI then
		PassiveSkills.UI:destroy()
		PassiveSkills.UI = nil
	end
end



------ UI Management and Toggling

function PassiveSkills.toggle()
	if PassiveSkills.UI:isVisible() then
		PassiveSkills.hide()
	else
		PassiveSkills.show()
	end
end

function PassiveSkills.show()
	PassiveSkills.UI:show()
	PassiveSkills.UI:raise()
	PassiveSkills.UI:focus()
	PassiveSkills.Button:setOn(true)
end

function PassiveSkills.hide()
	PassiveSkills.UI:hide()
	PassiveSkills.Button:setOn(false)
end



------ Tooltip Management

function PassiveSkills.moveToolTip()
	if not PassiveSkills.Tooltip or not PassiveSkills.Tooltip:isVisible() then
		return
	end

	local pos = g_window.getMousePosition()
	local windowSize = g_window.getSize()
	local tipSize = PassiveSkills.Tooltip:getSize()

	pos.x = pos.x + 1
	pos.y = pos.y + 1

	if windowSize.width - (pos.x + tipSize.width) < 10 then
		pos.x = pos.x - tipSize.width - 3
	else
		pos.x = pos.x + 10
	end

	if windowSize.height - (pos.y + tipSize.height) < 10 then
		pos.y = pos.y - tipSize.height - 3
	else
		pos.y = pos.y + 10
	end

	PassiveSkills.Tooltip:setPosition(pos)
	PassiveSkills.Tooltip:raise()
end

function PassiveSkills.applyTooltip(nodeData)
	PassiveSkills.moveToolTip()
	PassiveSkills.Tooltip:setText(nodeData.name)
	print(nodeData.description )
	PassiveSkills.Tooltip.description:setText(nodeData.description)
	PassiveSkills.Tooltip.maxLevel:setText("Max Level: " .. (nodeData.maxLevel or 1))
	local totalHeight = PassiveSkills.Tooltip.description:getHeight() +  PassiveSkills.Tooltip.maxLevel:getHeight() + 80  -- Adjust as needed
	PassiveSkills.Tooltip:setHeight(totalHeight)
end

function PassiveSkills.onHoverChange(widget, hovered)
	if hovered then
		PassiveSkills.applyTooltip(widget.nodeData)
		PassiveSkills.Tooltip:show()
		connect(rootWidget, { onMouseMove = PassiveSkills.moveToolTip })
	else
		PassiveSkills.Tooltip:hide()
		disconnect(rootWidget, { onMouseMove = PassiveSkills.moveToolTip })
	end
end



------ Nodes Interactions

function PassiveSkills.onNodeButtonClick(branchId, nodeId)
	if g_keyboard.isCtrlPressed() then
		PassiveSkills.sendOpcode({
			topic = "node-levelup-request",
			branchId = branchId,
			nodeId = nodeId
		})
	else
		PassiveSkills.setupConfirmMessage(
			"Confirm Level Up",
			"Are you sure you want to level up this node?",
			function()
				PassiveSkills.sendOpcode({
					topic = "node-levelup-request",
					branchId = branchId,
					nodeId = nodeId
				})
			end
		)
	end
end

function PassiveSkills.onResetButtonClick()
	PassiveSkills.sendOpcode({
		topic = "reset-tree-request"
	})
end

function PassiveSkills.handleResetRequirements(data)
	local requirements = data.requirements
	local message = "To reset the passive skills, you need:\n" .. requirements

	PassiveSkills.setupConfirmMessage(
		"Confirm Tree Reset",
		message .. "\n\nAre you sure you want to reset all your passive skills?",
		function()
			PassiveSkills.sendOpcode({
				topic = "confirm-reset-request"
			})
		end
	)
end



------ Setup Tree

function PassiveSkills.setupTreeUI()
	if PassiveSkills.UI.internalPanel then
		PassiveSkills.UI.internalPanel:destroyChildren()
	end

	local treeId = PassiveSkills.cachedTreeId or 0
	local progress = PassiveSkills.cachedProgress or {}

	if not PassiveSkills.cachedTreeData or PassiveSkills.cachedTreeData == 0 then
		PassiveSkills.UI.FullLockUI:setVisible(true)
		PassiveSkills.UI.FullLockUI:setText("Locked")
		return
	else
		PassiveSkills.UI.FullLockUI:setVisible(false)
	end

	local currentTreeData = PassiveSkills.cachedTreeData

	if PassiveSkills.UI.treeName then
		PassiveSkills.UI.treeName:setText(currentTreeData.name)
	end

	if currentTreeData.background then
		PassiveSkills.UI.background:setImageSource("images/backgrounds/" .. currentTreeData.background)
	else
		PassiveSkills.UI.background:setImageSource("images/backgrounds/default")
	end

	-- Centering logic
	local totalBranches = #currentTreeData.branches
	local totalWidth = totalBranches * PassiveSkills.nodeWidth + (totalBranches + 1) * PassiveSkills.marginBetweenBranches
	local parentWidth = PassiveSkills.UI.internalPanel:getWidth()
	local treeLeftOffset = math.max(0, math.floor((parentWidth - totalWidth) / 2))

	for branchIndex, branchData in ipairs(currentTreeData.branches) do
		PassiveSkills.createBranch(treeId, branchIndex, branchData, progress[branchIndex] or {}, treeLeftOffset)
	end
end

function PassiveSkills.createBranch(treeId, branchIndex, branchData, branchProgress, treeLeftOffset)
	local leftMargin = (treeLeftOffset or 0) + (branchIndex - 1) * (PassiveSkills.nodeWidth + PassiveSkills.marginBetweenBranches) + PassiveSkills.marginBetweenBranches
	local prevButton = nil

	for nodeIndex, nodeData in ipairs(branchData.nodes) do
		local nodeId = 'branch' .. branchIndex .. '/' .. nodeIndex

		local node = g_ui.createWidget("NodeEntry", PassiveSkills.UI.internalPanel)
		node:setId(nodeId)
		node:setImageSource('images/tree' .. treeId .. '/branch' .. branchIndex .. '/' .. nodeIndex)
		node:addAnchor(AnchorLeft, 'parent', AnchorLeft)
		node:setMarginLeft(leftMargin)

		local nodeEntryBorder = g_ui.createWidget("NodeEntryBorder", node)
		nodeEntryBorder:setImageSource('images/borders/' .. branchData.border)
		nodeEntryBorder:setImageColor(branchData.color)

		local nodeLevel = g_ui.createWidget("NodeEntryLevel", PassiveSkills.UI.internalPanel)
		nodeLevel:addAnchor(AnchorLeft, nodeId, AnchorLeft)
		nodeLevel:addAnchor(AnchorTop, nodeId, AnchorTop)

		local currentLevel = branchProgress[nodeIndex] or 0
		nodeLevel:setText(currentLevel .. "/" .. (nodeData.maxLevel or 1))

		if prevButton then
			node:addAnchor(AnchorTop, prevButton:getId(), AnchorBottom)
			node:setMarginTop(PassiveSkills.marginBetweenNodes)
			node:setMarginBottom(PassiveSkills.marginBetweenNodes)

			local separator = g_ui.createWidget("VerticalSeparator", PassiveSkills.UI.internalPanel)
			separator:setId('separator_' .. nodeId)
			separator:addAnchor(AnchorTop, prevButton:getId(), AnchorBottom)
			separator:addAnchor(AnchorBottom, node:getId(), AnchorTop)
			separator:addAnchor(AnchorHorizontalCenter, node:getId(), AnchorHorizontalCenter)
			separator:setWidth(2)
			separator:setMarginBottom(4)
		else
			node:addAnchor(AnchorTop, 'parent', AnchorTop)
			node:setMarginTop(PassiveSkills.marginBetweenNodes)
		end

		local button = g_ui.createWidget("NodeButton", PassiveSkills.UI.internalPanel)
		button:setId('button_' .. nodeId)
		button:addAnchor(AnchorTop, node:getId(), AnchorBottom)
		button:addAnchor(AnchorHorizontalCenter, node:getId(), AnchorHorizontalCenter)
		button:setMarginTop(5)

		button.onClick = function()
			PassiveSkills.onNodeButtonClick(branchIndex, nodeIndex)
		end

		nodeEntryBorder.nodeData = nodeData
		nodeEntryBorder.onHoverChange = PassiveSkills.onHoverChange

		prevButton = button
	end
end

function PassiveSkills.setupPoints()
	if PassiveSkills.UI.AvaliablePassivePoints then
		PassiveSkills.UI.AvaliablePassivePoints:setText("Available Passive Points: " .. PassiveSkills.cachedAvailablePoints or 0)
	end
	if PassiveSkills.UI.TotalPassivePoints then
		PassiveSkills.UI.TotalPassivePoints:setText("Total Passive Points: " .. PassiveSkills.cachedTotalPoints or 0)
	end
end



------ Dialogs and Messages

function PassiveSkills.setupDialogButtons()
	if PassiveSkills.UI.MessageBase and PassiveSkills.UI.MessageBase.ConfirmButton then
		PassiveSkills.UI.MessageBase.ConfirmButton.onClick = function()
			PassiveSkills.UI.MessageBase:setVisible(false)
			PassiveSkills.UI.LockUI:setVisible(false)
		end
	end

	if PassiveSkills.UI.ConfirmMessageBase and PassiveSkills.UI.ConfirmMessageBase.CancelButton then
		PassiveSkills.UI.ConfirmMessageBase.CancelButton.onClick = function()
			PassiveSkills.UI.ConfirmMessageBase:setVisible(false)
			PassiveSkills.UI.LockUI:setVisible(false)
		end
	end

	if PassiveSkills.UI then
		PassiveSkills.UI.onKeyDown = function(widget, keyCode)
			if keyCode == KeyEnter and PassiveSkills.UI.MessageBase and PassiveSkills.UI.MessageBase:isVisible() then
				PassiveSkills.UI.MessageBase:setVisible(false)
				PassiveSkills.UI.LockUI:setVisible(false)
				return true
			end
			return false
		end
	end
end

function PassiveSkills.setupMessage(title, message)
	if not PassiveSkills.UI.MessageBase or not PassiveSkills.UI.LockUI then
		return
	end
	PassiveSkills.UI.LockUI:setVisible(true)
	PassiveSkills.UI.MessageBase:setVisible(true)
	PassiveSkills.UI.MessageBase:setText(title)
	PassiveSkills.UI.MessageBase.Text:setText(message)
	local height = PassiveSkills.UI.MessageBase.Text:getTextSize().height + 150  -- Adjust as needed
	PassiveSkills.UI.MessageBase:setHeight(height)
end

function PassiveSkills.setupConfirmMessage(title, message, onConfirm)
	if not PassiveSkills.UI.ConfirmMessageBase or not PassiveSkills.UI.LockUI then
		return
	end
	PassiveSkills.UI.LockUI:setVisible(true)
	PassiveSkills.UI.ConfirmMessageBase:setVisible(true)
	PassiveSkills.UI.ConfirmMessageBase:setText(title)
	PassiveSkills.UI.ConfirmMessageBase.Text:setText(message)
	local height = PassiveSkills.UI.ConfirmMessageBase.Text:getTextSize().height + 150  -- Adjust as needed
	PassiveSkills.UI.ConfirmMessageBase:setHeight(height)

	PassiveSkills.UI.ConfirmMessageBase.ConfirmButton.onClick = function()
		if onConfirm then
			onConfirm()
		end
		PassiveSkills.UI.ConfirmMessageBase:setVisible(false)
		PassiveSkills.UI.LockUI:setVisible(false)
	end
end



------ Total Buffs Functions

function PassiveSkills.displayTotalBuffs()
	if not PassiveSkills.UI or not PassiveSkills.UI.totalBuffsPanel then
		return
	end

	PassiveSkills.UI.totalBuffsPanel:destroyChildren()

	local progress = PassiveSkills.cachedProgress or {}

	for branchIndex, branchData in ipairs(PassiveSkills.cachedTreeData.branches) do
		local branchProgress = progress[branchIndex] or {}

		for nodeIndex, nodeData in ipairs(branchData.nodes) do
			local currentLevel = branchProgress[nodeIndex] or 0

			if currentLevel > 0 then
				local isFirst = #PassiveSkills.UI.totalBuffsPanel:getChildren() == 0

				local buffLabel = g_ui.createWidget("Label", PassiveSkills.UI.totalBuffsPanel)
				buffLabel:setText("- " .. nodeData.name .. " (" .. currentLevel .. ")")
				buffLabel:setTextWrap(true)
				buffLabel:setTextAutoResize(true)
				buffLabel:setPhantom(false)
				buffLabel:setMarginTop(isFirst and 0 or 10)

				if nodeData.totalBuffsDesc and nodeData.totalBuffsDesc.desc then
					local descTemplate = nodeData.totalBuffsDesc.desc
					local varSet = nodeData.totalBuffsDesc.vars or {}

					local formatted = descTemplate
					for k, v in pairs(varSet) do
						local value = currentLevel * v
						formatted = formatted:gsub("%[%[%s*" .. k .. "%s*%]%]", tostring(value))
					end

					local descLabel = g_ui.createWidget("Label", PassiveSkills.UI.totalBuffsPanel)
					descLabel:setText(formatted)
					descLabel:setTextWrap(true)
					descLabel:setTextAutoResize(true)
					descLabel:setPhantom(false)
					descLabel:setColor('green')
				else
					local descLabel = g_ui.createWidget("Label", PassiveSkills.UI.totalBuffsPanel)
					descLabel:setText(nodeData.description )
					descLabel:setTextWrap(true)
					descLabel:setTextAutoResize(true)
					descLabel:setPhantom(false)
					descLabel:setColor('green')
				end
			end
		end
	end
end



------ Opcode Handling and Communication

function PassiveSkills.sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()
	if protocolGame then
		protocolGame:sendExtendedJSONOpcode(PassiveSkills.opCode, data)
	end
end

function PassiveSkills.onExtendedOpcode(protocol, opcode, buffer)
	local data = json.decode(buffer)
	if data.topic == "base-data-reply" then
		local formattedProgress = {}
		for branchIdStr, nodes in pairs(data.progress or {}) do
			local branchId = tonumber(branchIdStr)
			if branchId then
				formattedProgress[branchId] = {}
				for nodeIdStr, level in pairs(nodes) do
					local nodeId = tonumber(nodeIdStr)
					if nodeId then
						formattedProgress[branchId][nodeId] = level
					end
				end
			end
		end
		PassiveSkills.cachedProgress = formattedProgress
		PassiveSkills.cachedTreeId = data.treeId
		PassiveSkills.cachedTreeData = data.treeData
		PassiveSkills.cachedAvailablePoints = data.availablePoints
		PassiveSkills.cachedTotalPoints = data.totalPoints
		PassiveSkills.setupPoints()
		PassiveSkills.setupTreeUI()
		if PassiveSkills.cachedTreeData ~= 0 then PassiveSkills.displayTotalBuffs() end
	elseif data.topic == "progress-data-update" then
		local branchId = tonumber(data.branchId)
		local nodeId = tonumber(data.nodeId)
		local level = data.level
		if not PassiveSkills.cachedProgress[branchId] then
			PassiveSkills.cachedProgress[branchId] = {}
		end
		if not PassiveSkills.cachedProgress[branchId][nodeId] then
			PassiveSkills.cachedProgress[branchId][nodeId] = {}
		end
		PassiveSkills.cachedProgress[branchId][nodeId] = level
		PassiveSkills.cachedAvailablePoints = data.availablePoints
		PassiveSkills.cachedTotalPoints = data.totalPoints
		PassiveSkills.setupTreeUI()
		PassiveSkills.setupPoints()
		PassiveSkills.displayTotalBuffs()
	elseif data.topic == "points-update" then
		PassiveSkills.cachedAvailablePoints = data.availablePoints
		PassiveSkills.cachedTotalPoints = data.totalPoints
		PassiveSkills.setupPoints()
	elseif data.topic == "message-reply" then
		PassiveSkills.setupMessage(data.title, data.message)
	elseif data.topic == "reset-requirements-reply" then
		PassiveSkills.handleResetRequirements(data)
	end
end