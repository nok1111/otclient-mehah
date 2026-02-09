
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
		PassiveSkills.Button = modules.game_mainpanel.addStoreButton("PassiveSkills",
		tr("Talent Tree"), '/images/options/large_stats', PassiveSkills.toggle, false, 4)
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

	-- Paragon cached data
	PassiveSkills.paragonData = nil
	PassiveSkills.activeTab = "talents"

	-- Tab button handlers
	if PassiveSkills.UI.tabTalents then
		PassiveSkills.UI.tabTalents.onClick = function()
			PassiveSkills.showTalentsTab()
		end
	end
	if PassiveSkills.UI.tabAscension then
		PassiveSkills.UI.tabAscension.onClick = function()
			PassiveSkills.showAscensionTab()
		end
	end

	-- Ascension reset button
	if PassiveSkills.UI.ascensionResetButton then
		PassiveSkills.UI.ascensionResetButton.onClick = function()
			PassiveSkills.setupConfirmMessage(
				"Confirm Paragon Reset",
				"Are you sure you want to reset all your Paragon points? All stat allocations will be refunded.",
				function()
					PassiveSkills.sendOpcode({ topic = "paragon-reset-request" })
				end
			)
		end
	end

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


------ Tab Switching

function PassiveSkills.showTalentsTab()
	if PassiveSkills.activeTab == "talents" then return end
	PassiveSkills.activeTab = "talents"

	-- Show talent elements
	PassiveSkills.UI.treeName:setVisible(true)
	PassiveSkills.UI.totalBuffsPanel:setVisible(true)
	PassiveSkills.UI.totalBuffsScrollBar:setVisible(true)
	PassiveSkills.UI.background:setVisible(true)
	PassiveSkills.UI.internalPanel:setVisible(true)
	PassiveSkills.UI.internalVerticalScrollBar:setVisible(true)
	PassiveSkills.UI.internalHorizontalScrollBar:setVisible(true)
	PassiveSkills.UI.TotalPassivePoints:setVisible(true)
	PassiveSkills.UI.AvaliablePassivePoints:setVisible(true)
	PassiveSkills.UI.CloseButton:setVisible(true)
	PassiveSkills.UI.ResetButton:setVisible(true)

	-- Hide ascension elements
	PassiveSkills.UI.ascensionContent:setVisible(false)
	PassiveSkills.UI.ascensionScrollBar:setVisible(false)
	PassiveSkills.UI.ascensionParagonLevel:setVisible(false)
	PassiveSkills.UI.ascensionCloseButton:setVisible(false)
	PassiveSkills.UI.ascensionResetButton:setVisible(false)

	-- Update tab colors
	PassiveSkills.UI.tabTalents:setColor('#f4ca16')
	PassiveSkills.UI.tabAscension:setColor('#aaaaaa')
end

function PassiveSkills.showAscensionTab()
	if PassiveSkills.activeTab == "ascension" then return end
	PassiveSkills.activeTab = "ascension"

	-- Hide talent elements
	PassiveSkills.UI.treeName:setVisible(false)
	PassiveSkills.UI.totalBuffsPanel:setVisible(false)
	PassiveSkills.UI.totalBuffsScrollBar:setVisible(false)
	PassiveSkills.UI.background:setVisible(false)
	PassiveSkills.UI.internalPanel:setVisible(false)
	PassiveSkills.UI.internalVerticalScrollBar:setVisible(false)
	PassiveSkills.UI.internalHorizontalScrollBar:setVisible(false)
	PassiveSkills.UI.TotalPassivePoints:setVisible(false)
	PassiveSkills.UI.AvaliablePassivePoints:setVisible(false)
	PassiveSkills.UI.CloseButton:setVisible(false)
	PassiveSkills.UI.ResetButton:setVisible(false)

	-- Show ascension elements
	PassiveSkills.UI.ascensionContent:setVisible(true)
	PassiveSkills.UI.ascensionScrollBar:setVisible(true)
	PassiveSkills.UI.ascensionParagonLevel:setVisible(true)
	PassiveSkills.UI.ascensionCloseButton:setVisible(true)
	PassiveSkills.UI.ascensionResetButton:setVisible(true)

	-- Update tab colors
	PassiveSkills.UI.tabTalents:setColor('#aaaaaa')
	PassiveSkills.UI.tabAscension:setColor('#f4ca16')

	-- Request paragon data from server
	PassiveSkills.sendOpcode({ topic = "paragon-data-request" })
end


------ Paragon Board Config (client-side mirror)

PassiveSkills.paragonConfig = {
	categories = {
		{
			key = "primary",
			name = "Primary",
			color = "#ff6060",
			barColor = "#cc3030",
			stats = {
				{ id = "attack", name = "Attack", perPoint = 2, unit = "flat", capLabel = nil },
				{ id = "elemDmg", name = "Elem Dmg", perPoint = 1, unit = "flat", capLabel = nil },
				{ id = "atkSpeed", name = "Atk Speed", perPoint = 0.3, unit = "%", capLabel = "cap 30%" },
				{ id = "critDmg", name = "Crit Dmg", perPoint = 2, unit = "flat", capLabel = nil },
			},
		},
		{
			key = "secondary",
			name = "Secondary",
			color = "#60a0ff",
			barColor = "#3060cc",
			stats = {
				{ id = "defense", name = "Defense", perPoint = 2, unit = "flat", capLabel = nil },
				{ id = "maxHP", name = "Max HP", perPoint = 50, unit = "flat", capLabel = nil },
				{ id = "maxMana", name = "Max Mana", perPoint = 40, unit = "flat", capLabel = nil },
				{ id = "healing", name = "Healing", perPoint = 0.3, unit = "%", capLabel = "cap 25%" },
			},
		},
		{
			key = "utility",
			name = "Utility",
			color = "#60dd60",
			barColor = "#30aa30",
			stats = {
				{ id = "expGain", name = "EXP Gain", perPoint = 1, unit = "%", capLabel = nil },
				{ id = "craftingExp", name = "Craft Exp", perPoint = 1, unit = "%", capLabel = nil },
				{ id = "fameGain", name = "Fame Gain", perPoint = 1, unit = "%", capLabel = nil },
				{ id = "codexKnowledge", name = "Codex Kn.", perPoint = 0.3, unit = "%", capLabel = "cap 25%" },
			},
		},
	},
}


------ Paragon Board Rendering

function PassiveSkills.buildAscensionUI()
	if not PassiveSkills.UI or not PassiveSkills.UI.ascensionContent then return end
	if not PassiveSkills.paragonData then return end

	local panel = PassiveSkills.UI.ascensionContent
	panel:destroyChildren()

	local data = PassiveSkills.paragonData

	-- Header: Paragon Level
	local header = g_ui.createWidget("Panel", panel)
	header:setId("paragonHeader")
	header:setHeight(70)
	header:setBackgroundColor('#1a152080')
	header:setBorderWidth(1)
	header:setBorderColor('#3a2f50')

	local levelLabel = g_ui.createWidget("Label", header)
	levelLabel:setId("levelLabel")
	levelLabel:addAnchor(AnchorTop, 'parent', AnchorTop)
	levelLabel:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
	levelLabel:setMarginTop(6)
	levelLabel:setText("PARAGON LEVEL")
	levelLabel:setColor('#8878a0')
	levelLabel:setTextAutoResize(true)

	local levelNumber = g_ui.createWidget("Label", header)
	levelNumber:setId("levelNumber")
	levelNumber:addAnchor(AnchorTop, 'levelLabel', AnchorBottom)
	levelNumber:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
	levelNumber:setMarginTop(2)
	levelNumber:setText(tostring(data.paragonLevel))
	levelNumber:setColor('#f0d878')
	levelNumber:setTextAutoResize(true)
	levelNumber:setFont('verdana-11px-antialised')

	-- XP Bar
	local xpBg = g_ui.createWidget("Panel", header)
	xpBg:setId("xpBarBg")
	xpBg:addAnchor(AnchorBottom, 'parent', AnchorBottom)
	xpBg:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
	xpBg:setMarginBottom(6)
	xpBg:setSize({width = 400, height = 8})
	xpBg:setBackgroundColor('#1a1525')
	xpBg:setBorderWidth(1)
	xpBg:setBorderColor('#2a2040')

	local xpPercent = data.xpNeeded > 0 and (data.paragonXP / data.xpNeeded) or 0
	local xpFillWidth = math.max(1, math.floor(398 * xpPercent))

	local xpFill = g_ui.createWidget("Panel", xpBg)
	xpFill:setId("xpBarFill")
	xpFill:addAnchor(AnchorLeft, 'parent', AnchorLeft)
	xpFill:addAnchor(AnchorTop, 'parent', AnchorTop)
	xpFill:addAnchor(AnchorBottom, 'parent', AnchorBottom)
	xpFill:setMarginLeft(1)
	xpFill:setMarginTop(1)
	xpFill:setMarginBottom(1)
	xpFill:setWidth(xpFillWidth)
	xpFill:setBackgroundColor('#8050c0')

	-- XP Text
	local xpText = g_ui.createWidget("Label", header)
	xpText:addAnchor(AnchorBottom, 'xpBarBg', AnchorTop)
	xpText:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
	xpText:setMarginBottom(2)
	local xpStr = PassiveSkills.formatNumber(data.paragonXP) .. " / " .. PassiveSkills.formatNumber(data.xpNeeded) .. " XP"
	xpText:setText(xpStr)
	xpText:setColor('#7868a0')
	xpText:setTextAutoResize(true)

	-- Next point type indicator
	local nextType = data.nextPointType or "primary"
	local nextLabel = g_ui.createWidget("Label", header)
	nextLabel:addAnchor(AnchorTop, 'levelLabel', AnchorTop)
	nextLabel:addAnchor(AnchorRight, 'parent', AnchorRight)
	nextLabel:setMarginRight(10)
	nextLabel:setText("Next: " .. nextType:sub(1,1):upper() .. nextType:sub(2))
	nextLabel:setTextAutoResize(true)
	local typeColors = { primary = "#ff6060", secondary = "#60a0ff", utility = "#60dd60" }
	nextLabel:setColor(typeColors[nextType] or '#ffffff')

	-- Categories (3 panels side by side)
	local categoriesRow = g_ui.createWidget("Panel", panel)
	categoriesRow:setId("categoriesRow")
	categoriesRow:setHeight(300)

	local categoryWidth = 205
	for catIdx, catConfig in ipairs(PassiveSkills.paragonConfig.categories) do
		local catKey = catConfig.key
		local catData = data.stats[catKey] or {}
		local availablePoints = data.points[catKey] or 0
		local totalSpent = data.totalSpent[catKey] or 0

		local catPanel = g_ui.createWidget("Panel", categoriesRow)
		catPanel:setId("cat_" .. catKey)
		catPanel:addAnchor(AnchorTop, 'parent', AnchorTop)
		catPanel:setMarginTop(0)
		catPanel:setWidth(categoryWidth)
		catPanel:setHeight(290)
		catPanel:setBackgroundColor('#1a152060')
		catPanel:setBorderWidth(1)
		catPanel:setBorderColor('#2a2040')

		if catIdx == 1 then
			catPanel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
		elseif catIdx == 2 then
			catPanel:addAnchor(AnchorLeft, 'cat_' .. PassiveSkills.paragonConfig.categories[1].key, AnchorRight)
			catPanel:setMarginLeft(8)
		else
			catPanel:addAnchor(AnchorLeft, 'cat_' .. PassiveSkills.paragonConfig.categories[2].key, AnchorRight)
			catPanel:setMarginLeft(8)
		end

		-- Category header
		local catHeader = g_ui.createWidget("Label", catPanel)
		catHeader:addAnchor(AnchorTop, 'parent', AnchorTop)
		catHeader:addAnchor(AnchorLeft, 'parent', AnchorLeft)
		catHeader:addAnchor(AnchorRight, 'parent', AnchorRight)
		catHeader:setMarginTop(6)
		catHeader:setMarginLeft(8)
		catHeader:setText(catConfig.name:upper() .. " (" .. totalSpent .. ")")
		catHeader:setColor(catConfig.color)
		catHeader:setTextAutoResize(true)

		-- Available points badge
		local pointsBadge = g_ui.createWidget("Label", catPanel)
		pointsBadge:addAnchor(AnchorTop, 'parent', AnchorTop)
		pointsBadge:addAnchor(AnchorRight, 'parent', AnchorRight)
		pointsBadge:setMarginTop(6)
		pointsBadge:setMarginRight(8)
		pointsBadge:setTextAutoResize(true)
		if availablePoints > 0 then
			pointsBadge:setText(availablePoints .. " pt")
			pointsBadge:setColor('#f4ca16')
		else
			pointsBadge:setText("0 pt")
			pointsBadge:setColor('#665e78')
		end

		-- Separator line
		local sep = g_ui.createWidget("Panel", catPanel)
		sep:addAnchor(AnchorTop, 'parent', AnchorTop)
		sep:addAnchor(AnchorLeft, 'parent', AnchorLeft)
		sep:addAnchor(AnchorRight, 'parent', AnchorRight)
		sep:setMarginTop(26)
		sep:setHeight(1)
		sep:setBackgroundColor('#ffffff10')

		-- Stats
		for statIdx, statConfig in ipairs(catConfig.stats) do
			local statData = catData[statIdx] or { points = 0, cap = 0 }
			local statPoints = statData.points or 0
			local statCap = statData.cap or 0
			local statValue = statPoints * statConfig.perPoint

			local statRow = g_ui.createWidget("Panel", catPanel)
			statRow:setId("stat_" .. catKey .. "_" .. statIdx)
			statRow:addAnchor(AnchorLeft, 'parent', AnchorLeft)
			statRow:addAnchor(AnchorRight, 'parent', AnchorRight)
			statRow:setMarginLeft(8)
			statRow:setMarginRight(8)

			local rowTopMargin = 32 + (statIdx - 1) * 62
			statRow:addAnchor(AnchorTop, 'parent', AnchorTop)
			statRow:setMarginTop(rowTopMargin)
			statRow:setHeight(56)

			-- Stat name
			local nameLabel = g_ui.createWidget("Label", statRow)
			nameLabel:addAnchor(AnchorTop, 'parent', AnchorTop)
			nameLabel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
			nameLabel:setMarginTop(4)
			nameLabel:setText(statConfig.name)
			nameLabel:setColor('#a098b0')
			nameLabel:setTextAutoResize(true)

			-- Stat value
			local valueLabel = g_ui.createWidget("Label", statRow)
			valueLabel:addAnchor(AnchorTop, 'parent', AnchorTop)
			valueLabel:addAnchor(AnchorRight, 'parent', AnchorRight)
			valueLabel:setMarginTop(4)
			local valueStr = ""
			if statConfig.unit == "%" then
				valueStr = string.format("+%.1f%%", statValue)
			else
				valueStr = "+" .. tostring(math.floor(statValue))
			end
			valueLabel:setText(valueStr)
			valueLabel:setColor(catConfig.color)
			valueLabel:setTextAutoResize(true)

			-- Progress bar background
			local barBg = g_ui.createWidget("Panel", statRow)
			barBg:addAnchor(AnchorTop, 'parent', AnchorTop)
			barBg:addAnchor(AnchorLeft, 'parent', AnchorLeft)
			barBg:setMarginTop(22)
			barBg:setSize({width = 150, height = 6})
			barBg:setBackgroundColor('#1a1525')
			barBg:setBorderWidth(1)
			barBg:setBorderColor('#2a2040')

			-- Progress bar fill
			local barPercent = 0
			if statCap > 0 then
				barPercent = math.min(1, statPoints / statCap)
			else
				barPercent = math.min(1, statPoints / math.max(1, statPoints + 10))
			end
			local barFillWidth = math.max(0, math.floor(148 * barPercent))

			if barFillWidth > 0 then
				local barFill = g_ui.createWidget("Panel", barBg)
				barFill:addAnchor(AnchorLeft, 'parent', AnchorLeft)
				barFill:addAnchor(AnchorTop, 'parent', AnchorTop)
				barFill:addAnchor(AnchorBottom, 'parent', AnchorBottom)
				barFill:setMarginLeft(1)
				barFill:setMarginTop(1)
				barFill:setMarginBottom(1)
				barFill:setWidth(barFillWidth)
				barFill:setBackgroundColor(catConfig.barColor)
			end

			-- Points count
			local countLabel = g_ui.createWidget("Label", statRow)
			countLabel:addAnchor(AnchorTop, 'parent', AnchorTop)
			countLabel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
			countLabel:setMarginTop(30)
			local countStr = tostring(statPoints) .. " pts"
			if statConfig.capLabel then
				countStr = countStr .. " (" .. statConfig.capLabel .. ")"
			end
			countLabel:setText(countStr)
			countLabel:setColor('#554e68')
			countLabel:setTextAutoResize(true)

			-- Add button [+]
			local addBtn = g_ui.createWidget("Button", statRow)
			addBtn:addAnchor(AnchorTop, 'parent', AnchorTop)
			addBtn:addAnchor(AnchorRight, 'parent', AnchorRight)
			addBtn:setMarginTop(18)
			addBtn:setSize({width = 22, height = 22})
			addBtn:setText("+")

			if availablePoints > 0 and (statCap == 0 or statPoints < statCap) then
				addBtn:setEnabled(true)
				addBtn:setColor('#f4ca16')
			else
				addBtn:setEnabled(false)
				addBtn:setColor('#665e78')
			end

			local capturedCatKey = catKey
			local capturedStatIdx = statIdx
			addBtn.onClick = function()
				PassiveSkills.sendOpcode({
					topic = "paragon-allocate-request",
					category = capturedCatKey,
					statIndex = capturedStatIdx,
				})
			end
		end
	end

	-- Milestones section
	local milestonesPanel = g_ui.createWidget("Panel", panel)
	milestonesPanel:setId("milestonesPanel")
	milestonesPanel:setHeight(110)
	milestonesPanel:setBackgroundColor('#1a152040')
	milestonesPanel:setBorderWidth(1)
	milestonesPanel:setBorderColor('#2a2040')

	local msTitle = g_ui.createWidget("Label", milestonesPanel)
	msTitle:addAnchor(AnchorTop, 'parent', AnchorTop)
	msTitle:addAnchor(AnchorLeft, 'parent', AnchorLeft)
	msTitle:setMarginTop(6)
	msTitle:setMarginLeft(10)
	msTitle:setText("MILESTONES")
	msTitle:setColor('#d4a847')
	msTitle:setTextAutoResize(true)

	local milestoneData = {
		{ key = "primary", name = "Primary", thresholds = {25, 50, 100, 200}, labels = {"Warrior", "+3% Dmg", "+5% Dmg + Aura", "Paragon of War"} },
		{ key = "secondary", name = "Secondary", thresholds = {25, 50, 100, 200}, labels = {"Guardian", "+5% HP", "+8% HP + Aura", "Paragon of Fortitude"} },
		{ key = "utility", name = "Utility", thresholds = {25, 50, 100, 200}, labels = {"Explorer", "+3% Gains", "+5% Gains + Aura", "Paragon of Fortune"} },
	}

	local msRowY = 24
	for _, ms in ipairs(milestoneData) do
		local spent = data.totalSpent[ms.key] or 0
		local claimed = data.milestones[ms.key] or 0

		-- Find next unclaimed milestone
		local nextThreshold = nil
		local nextLabel = nil
		for i, t in ipairs(ms.thresholds) do
			if claimed < t then
				nextThreshold = t
				nextLabel = ms.labels[i]
				break
			end
		end

		if nextThreshold then
			local msRow = g_ui.createWidget("Label", milestonesPanel)
			msRow:addAnchor(AnchorTop, 'parent', AnchorTop)
			msRow:addAnchor(AnchorLeft, 'parent', AnchorLeft)
			msRow:addAnchor(AnchorRight, 'parent', AnchorRight)
			msRow:setMarginTop(msRowY)
			msRow:setMarginLeft(10)
			msRow:setTextAutoResize(true)

			local progressStr = spent .. " / " .. nextThreshold
			msRow:setText(ms.name .. " " .. nextThreshold .. "pts: " .. nextLabel .. "   [" .. progressStr .. "]")
			msRow:setColor(spent >= nextThreshold and '#d4a847' or '#665e78')
			msRowY = msRowY + 18
		end
	end

	-- Update bottom label
	if PassiveSkills.UI.ascensionParagonLevel then
		PassiveSkills.UI.ascensionParagonLevel:setText(
			"Paragon Lv " .. data.paragonLevel ..
			" | P:" .. (data.points.primary or 0) ..
			" S:" .. (data.points.secondary or 0) ..
			" U:" .. (data.points.utility or 0)
		)
	end
end

function PassiveSkills.formatNumber(n)
	if n >= 1000000 then
		return string.format("%.1fM", n / 1000000)
	elseif n >= 1000 then
		return string.format("%.1fK", n / 1000)
	end
	return tostring(n)
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
	--print(nodeData.description )
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
			nodeId = nodeId,
			_noSuccessPopup = true -- custom flag to suppress popup
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

			local nodeLevel = g_ui.createWidget("NodeEntryLevel", PassiveSkills.UI.internalPanel)
			nodeLevel:addAnchor(AnchorLeft, nodeId, AnchorLeft)
			nodeLevel:addAnchor(AnchorTop, nodeId, AnchorTop)
			nodeLevel:addAnchor(AnchorHorizontalCenter, nodeId, AnchorHorizontalCenter)

			local currentLevel = branchProgress[nodeIndex] or 0
			nodeLevel:setText(currentLevel .. "/" .. (nodeData.maxLevel or 1))
		else
			node:addAnchor(AnchorTop, 'parent', AnchorTop)
			node:setMarginTop(PassiveSkills.marginBetweenNodes)

			local nodeLevel = g_ui.createWidget("NodeEntryLevel", PassiveSkills.UI.internalPanel)
			nodeLevel:addAnchor(AnchorLeft, nodeId, AnchorLeft)
			nodeLevel:addAnchor(AnchorTop, nodeId, AnchorTop)
			nodeLevel:addAnchor(AnchorHorizontalCenter, nodeId, AnchorHorizontalCenter)

			local currentLevel = branchProgress[nodeIndex] or 0
			nodeLevel:setText(currentLevel .. "/" .. (nodeData.maxLevel or 1))
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
		--PassiveSkills.setupMessage("Success", string.format("%s in branch %d has been leveled up.", data.nodeName or "Node", branchId))
	elseif data.topic == "points-update" then
		PassiveSkills.cachedAvailablePoints = data.availablePoints
		PassiveSkills.cachedTotalPoints = data.totalPoints
		PassiveSkills.setupPoints()
	elseif data.topic == "message-reply" then
		PassiveSkills.setupMessage(data.title, data.message)
	elseif data.topic == "reset-requirements-reply" then
		PassiveSkills.handleResetRequirements(data)

	-- Paragon Board topics
	elseif data.topic == "paragon-data-reply" then
		PassiveSkills.paragonData = data
		PassiveSkills.buildAscensionUI()
	elseif data.topic == "paragon-allocate-reply" then
		if data.success then
			-- Request fresh data to rebuild UI
			PassiveSkills.sendOpcode({ topic = "paragon-data-request" })
		else
			PassiveSkills.setupMessage("Failed", data.message or "Could not allocate point.")
		end
	end
end