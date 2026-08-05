
------ Spell descriptions (client-side, no server packets needed)

PassiveSkills.spellInfo = {
	["Hand of God"] = {desc = "Calls down a pillar of divine fire, dealing massive holy damage to all enemies in a 3x3 area.", cooldown = "30s", mana = "80"},
	["Frost Wave"] = {desc = "Releases a wave of ice that deals frost damage and slows enemies in a line.", cooldown = "12s", mana = "40"},
	["Arcane Missiles"] = {desc = "Fires 1-6 arcane missiles (scales with Arcane Surge charges) at the target.", cooldown = "8s", mana = "30"},
	["Divine Punishment"] = {desc = "Smite your target with holy energy, dealing damage and stunning for 2 seconds.", cooldown = "20s", mana = "60"},
	["Kings Blessing"] = {desc = "Bless yourself or an ally, increasing all attributes by 10% for 30 seconds.", cooldown = "60s", mana = "100"},
	["Guardian of Light"] = {desc = "Summon a guardian of light that protects you, reducing incoming damage by 15%.", cooldown = "45s", mana = "75"},
	["Sacred Ground"] = {desc = "Consecrate the ground beneath you, healing allies and damaging undead in the area.", cooldown = "25s", mana = "50"},
	["Angelic Form"] = {desc = "Transform into an angelic form, gaining wings and increased holy damage for 20 seconds.", cooldown = "120s", mana = "150"},
	["Assassination"] = {desc = "A lethal strike that deals massive physical damage. Bonus damage if target is bleeding.", cooldown = "15s", mana = "35"},
	["Blackout"] = {desc = "Vanish into shadows, becoming invisible and gaining a critical hit bonus on next attack.", cooldown = "30s", mana = "50"},
	["Void Execution"] = {desc = "Execute the target with void energy. Instant kill if target is below 20% health.", cooldown = "40s", mana = "80"},
	["Shockwave"] = {desc = "Release a shockwave that knocks back and damages all nearby enemies.", cooldown = "18s", mana = "45"},
	["Bloodlust"] = {desc = "Enter a bloodlust frenzy, increasing attack speed by 30% and life leech by 10%.", cooldown = "60s", mana = "70"},
	["Fire Within"] = {desc = "Ignite your inner flame, gaining fire damage immunity and reflecting fire damage.", cooldown = "45s", mana = "55"},
	["Draconic Chains"] = {desc = "Chain a target with draconic energy, rooting them and dealing fire damage over time.", cooldown = "20s", mana = "40"},
	["Phoenix Wrath"] = {desc = "Unleash phoenix fire, dealing massive fire damage in a large area. Revives you if you die within 10s.", cooldown = "180s", mana = "200"},
	["Dragon Soul"] = {desc = "Channel your dragon soul, gaining 20% damage reduction and 15% increased damage for 15 seconds.", cooldown = "90s", mana = "120"},
	["Dark Aura"] = {desc = "Emit a dark aura that damages and weakens nearby enemies, reducing their damage by 10%.", cooldown = "30s", mana = "60"},
	["Malediction"] = {desc = "Curse the target, increasing damage taken by 15% and reducing healing by 50% for 10 seconds.", cooldown = "25s", mana = "45"},
	["Dark Plague"] = {desc = "Infect the target with a plague that spreads to nearby enemies, dealing damage over time.", cooldown = "35s", mana = "65"},
	["Summon Void Mender"] = {desc = "Summon a void mender that heals you and nearby allies for 20 seconds.", cooldown = "60s", mana = "90"},
	["Summon Void Guard"] = {desc = "Summon a void guard that fights alongside you and taunts enemies for 30 seconds.", cooldown = "75s", mana = "100"},
	["Zombie Wall"] = {desc = "Raise a wall of zombies that blocks movement and damages enemies who touch it.", cooldown = "40s", mana = "70"},
	["Zen Barrier"] = {desc = "Create a zen barrier that absorbs the next 3 incoming attacks.", cooldown = "50s", mana = "60"},
	["Insect Swarm"] = {desc = "Release a swarm of insects that deals damage over time and reduces target's accuracy.", cooldown = "22s", mana = "40"},
	["Life Bloom"] = {desc = "Heal yourself or an ally instantly and apply a healing-over-time effect for 8 seconds.", cooldown = "15s", mana = "35"},
	["living ground"] = {desc = "Create an area of living ground that entangles and damages enemies who enter.", cooldown = "28s", mana = "50"},
	["Ice Shatter"] = {desc = "Shatter a frozen target, dealing massive frost damage. Only works on frozen enemies.", cooldown = "10s", mana = "30"},
	["Frost Armor"] = {desc = "Encase yourself in frost armor, gaining damage reduction and slowing melee attackers.", cooldown = "40s", mana = "55"},
	["Bear Form"] = {desc = "Transform into a bear, increasing max health by 30% and melee damage for 25 seconds.", cooldown = "120s", mana = "80"},
	["Magnetic Shield"] = {desc = "Create a magnetic shield that attracts and absorbs projectiles for 10 seconds.", cooldown = "35s", mana = "50"},
	["Explosive Shot"] = {desc = "Fire an explosive arrow that deals area damage on impact.", cooldown = "12s", mana = "35"},
	["Explosive Barrel"] = {desc = "Throw an explosive barrel that detonates after 2 seconds, dealing fire damage in an area.", cooldown = "20s", mana = "45"},
	["Ice Arrow"] = {desc = "Fire an arrow of ice that deals frost damage and slows the target.", cooldown = "8s", mana = "25"},
	["Frost Barrel"] = {desc = "Throw a barrel of frost that freezes enemies in a 3x3 area for 3 seconds.", cooldown = "25s", mana = "55"},
	["Falcon Shot"] = {desc = "Fire a falcon-shaped arrow that seeks the target and deals bonus damage to flying enemies.", cooldown = "15s", mana = "40"},
	["Phantom Shot"] = {desc = "Fire a phantom arrow that passes through walls and enemies, dealing damage to all hit.", cooldown = "18s", mana = "45"},
}

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
	PassiveSkills.cachedIsGM = false

	-- Paragon cached data
	PassiveSkills.paragonData = nil
	PassiveSkills.activeTab = "talents"

	-- Pending talent allocations (click to queue, Apply to send)
	PassiveSkills.pendingAllocations = {}
	PassiveSkills.proposedProgress = nil

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
				tr("Confirm Paragon Reset"),
				tr("Are you sure you want to reset all your Paragon points? All stat allocations will be refunded."),
				function()
					PassiveSkills.sendOpcode({ topic = "paragon-reset-request" })
				end
			)
		end
	end

	-- Apply pending talent allocations
	if PassiveSkills.UI.ApplyButton then
		PassiveSkills.UI.ApplyButton.onClick = function()
			PassiveSkills.applyPendingAllocations()
		end
		PassiveSkills.UI.ApplyButton:setVisible(false)
	end

	PassiveSkills.sendOpcode({ topic = "base-data-request" })

	-- Dev mode state init
	PassiveSkills.devMode = false
	PassiveSkills.devNodePositions = {}  -- nodeId -> {x, y} in grid coords
	PassiveSkills.devGridSize = 48       -- snap grid size in pixels
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
	PassiveSkills.updateDevModeVisibility()
end

function PassiveSkills.updateDevModeVisibility()
	local isGM = PassiveSkills.cachedIsGM or false
	if PassiveSkills.UI.devModeCheckBox then
		PassiveSkills.UI.devModeCheckBox:setVisible(isGM)
		if isGM then
			PassiveSkills.UI.devModeCheckBox.onCheckChange = PassiveSkills.onDevModeToggle
		end
	end
	if PassiveSkills.UI.devSaveButton then
		PassiveSkills.UI.devSaveButton:setVisible(isGM)
		if isGM then
			PassiveSkills.UI.devSaveButton.onMousePress = function(widget, mousePos, mouseButton)
				if mouseButton == MouseLeftButton then
					PassiveSkills.onDevSave()
					return true
				end
				return false
			end
		end
	end
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
	PassiveSkills.UI.background:setVisible(true)
	PassiveSkills.UI.internalPanel:setVisible(true)
	if PassiveSkills.UI.legendPanel then
		PassiveSkills.UI.legendPanel:setVisible(true)
	end
	if PassiveSkills.UI.internalVerticalScrollBar then
		PassiveSkills.UI.internalVerticalScrollBar:setVisible(false)
	end
	if PassiveSkills.UI.internalHorizontalScrollBar then
		PassiveSkills.UI.internalHorizontalScrollBar:setVisible(false)
	end
	PassiveSkills.UI.TotalPassivePoints:setVisible(true)
	PassiveSkills.UI.AvaliablePassivePoints:setVisible(true)
	PassiveSkills.UI.CloseButton:setVisible(true)
	if PassiveSkills.UI.ApplyButton then
		PassiveSkills.UI.ApplyButton.onClick = function()
			PassiveSkills.applyPendingAllocations()
		end
		PassiveSkills.UI.ApplyButton:setVisible(true)
	end
	if PassiveSkills.UI.ResetButton then
		PassiveSkills.UI.ResetButton.onClick = PassiveSkills.onResetButtonClick
		PassiveSkills.UI.ResetButton:setVisible(true)
	end

	-- Show dev mode controls if GM
	local isGM = PassiveSkills.cachedIsGM or false
	if PassiveSkills.UI.devModeCheckBox then
		PassiveSkills.UI.devModeCheckBox:setVisible(isGM)
	end
	if PassiveSkills.UI.devSaveButton then
		PassiveSkills.UI.devSaveButton:setVisible(isGM)
	end

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
	PassiveSkills.UI.background:setVisible(false)
	PassiveSkills.UI.internalPanel:setVisible(false)
	if PassiveSkills.UI.legendPanel then
		PassiveSkills.UI.legendPanel:setVisible(false)
	end
	if PassiveSkills.UI.internalVerticalScrollBar then
		PassiveSkills.UI.internalVerticalScrollBar:setVisible(false)
	end
	if PassiveSkills.UI.internalHorizontalScrollBar then
		PassiveSkills.UI.internalHorizontalScrollBar:setVisible(false)
	end
	PassiveSkills.UI.TotalPassivePoints:setVisible(false)
	PassiveSkills.UI.AvaliablePassivePoints:setVisible(false)
	PassiveSkills.UI.CloseButton:setVisible(false)
	PassiveSkills.UI.ApplyButton:setVisible(false)
	PassiveSkills.UI.ResetButton:setVisible(false)
	if PassiveSkills.UI.devModeCheckBox then
		PassiveSkills.UI.devModeCheckBox:setVisible(false)
	end
	if PassiveSkills.UI.devSaveButton then
		PassiveSkills.UI.devSaveButton:setVisible(false)
	end

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
				{ id = "physicalDmg", name = "Phys Dmg", perPoint = 1, unit = "%", capLabel = nil },
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
				{ id = "blockChance", name = "Block Chc", perPoint = 0.3, unit = "%", capLabel = "cap 25%" },
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

	-- Show locked message if Paragon is not active
	if not data.isActive then
		local lockedLabel = g_ui.createWidget("Label", panel)
		lockedLabel:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
		lockedLabel:addAnchor(AnchorTop, 'parent', AnchorTop)
		lockedLabel:setMarginTop(80)
		lockedLabel:setText(tr("Reach Level 300 to unlock the Paragon System."))
		lockedLabel:setColor('#665e78')
		lockedLabel:setTextAutoResize(true)
		if PassiveSkills.UI.ascensionParagonLevel then
			PassiveSkills.UI.ascensionParagonLevel:setText(tr("Paragon Locked"))
		end
		return
	end

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
	levelLabel:setText(tr("PARAGON LEVEL"))
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
	nextLabel:setText(tr("Next: %s", tr(nextType:sub(1,1):upper() .. nextType:sub(2))))
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
		catHeader:setText(tr(catConfig.name):upper() .. " (" .. totalSpent .. ")")
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
			pointsBadge:setText(tr("%d pt", availablePoints))
			pointsBadge:setColor('#f4ca16')
		else
			pointsBadge:setText(tr("0 pt"))
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
			nameLabel:setText(tr(statConfig.name))
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
			local countStr = tostring(statPoints) .. " " .. tr("pts")
			if statConfig.capLabel then
				countStr = countStr .. " (" .. tr(statConfig.capLabel) .. ")"
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
	msTitle:setText(tr("MILESTONES"))
	msTitle:setColor('#d4a847')
	msTitle:setTextAutoResize(true)

	local milestoneData = {
		{ key = "primary", name = tr("Primary"), thresholds = {25, 50, 100, 200}, labels = {tr("Warrior"), tr("+3% Dmg"), tr("+5% Dmg + Aura"), tr("Paragon of War")} },
		{ key = "secondary", name = tr("Secondary"), thresholds = {25, 50, 100, 200}, labels = {tr("Guardian"), tr("+5% HP"), tr("+8% HP + Aura"), tr("Paragon of Fortitude")} },
		{ key = "utility", name = tr("Utility"), thresholds = {25, 50, 100, 200}, labels = {tr("Explorer"), tr("+3% Gains"), tr("+5% Gains + Aura"), tr("Paragon of Fortune")} },
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
			msRow:setText(tr("%s %dpts: %s   [%s]", ms.name, nextThreshold, nextLabel, progressStr))
			msRow:setColor(spent >= nextThreshold and '#d4a847' or '#665e78')
			msRowY = msRowY + 18
		end
	end

	-- Update bottom label
	if PassiveSkills.UI.ascensionParagonLevel then
		PassiveSkills.UI.ascensionParagonLevel:setText(
			tr("Paragon Lv %d | P:%d S:%d U:%d", data.paragonLevel,
				(data.points.primary or 0), (data.points.secondary or 0), (data.points.utility or 0))
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

function PassiveSkills.applyTooltip(nodeData, state, blockReason)
	PassiveSkills.moveToolTip()

	-- Get client-side info (descriptions/effects are not sent from server to save bandwidth)
	local treeId = PassiveSkills.cachedTreeId or 1
	local infoKey = treeId .. ":" .. (nodeData.id or 0)
	local clientInfo = PassiveSkills.nodeInfo and PassiveSkills.nodeInfo[infoKey] or nil

	-- Name / Title (gold, like WoW spell name)
	local nodeName = nodeData.name or (clientInfo and clientInfo.name) or "Unknown"
	if PassiveSkills.Tooltip.title then
		PassiveSkills.Tooltip.title:setText(tr(nodeName))
	else
		PassiveSkills.Tooltip:setText(tr(nodeName))
	end

	-- Subtitle: kind (white/gray) and state (color)
	local kindIcons = {
		core = "Talent", keystone = "Keystone", notable = "Notable",
		nexus = "Nexus", fork = "Choice", star = "Talent",
	}
	local kindLabel = kindIcons[nodeData.kind] or "Talent"

	local stateLabels = {
		maxed = "Rank Maxed", unlocked = "Rank Unlocked",
		available = "Available", blocked = "Blocked", locked = "Locked",
	}
	local stateLabel = state and stateLabels[state] or nil

	local subtitle = kindLabel
	if stateLabel then
		subtitle = subtitle .. " - " .. stateLabel
	end
	if PassiveSkills.Tooltip.subtitle then
		PassiveSkills.Tooltip.subtitle:setText(tr(subtitle))
	end

	-- Class/Requirement line (yellow, like "Requires Evoker")
	local classLine = ""
	if nodeData.requirements then
		if nodeData.requirements.spentInBranch then
			for branchId, points in pairs(nodeData.requirements.spentInBranch) do
				classLine = classLine .. (classLine == "" and "" or "\n") .. tr("Requires %d points in branch %d", points, branchId)
			end
		end
		if nodeData.requirements.unlockedNodes then
			classLine = classLine .. (classLine == "" and "" or "\n") .. tr("Requires linked keystone(s)")
		end
		if nodeData.requirements.level then
			classLine = classLine .. (classLine == "" and "" or "\n") .. tr("Requires Level %d", nodeData.requirements.level)
		end
	end
	if PassiveSkills.Tooltip.classLine then
		PassiveSkills.Tooltip.classLine:setText(classLine)
		PassiveSkills.Tooltip.classLine:setVisible(classLine ~= "")
	end

	-- Red requirement line (like "Spend 19 more points...")
	local reqLine = ""
	if blockReason and blockReason ~= "" then
		reqLine = blockReason
	end
	if nodeData.mutuallyExclusive and (state == "blocked" or state == "locked") then
		reqLine = (reqLine == "" and "" or reqLine .. "\n") .. tr("Mutually exclusive choice.")
	end
	if state == "locked" and reqLine == "" then
		if nodeData.requirements and nodeData.requirements.spentInBranch then
			for branchId, points in pairs(nodeData.requirements.spentInBranch) do
				reqLine = tr("Spend %d more points in branch %d to unlock.", points, branchId)
			end
		else
			reqLine = tr("Requires an unlocked connected node.")
		end
	end
	if PassiveSkills.Tooltip.requirementLine then
		PassiveSkills.Tooltip.requirementLine:setText(reqLine)
		PassiveSkills.Tooltip.requirementLine:setVisible(reqLine ~= "")
	end

	-- Description (white, main body)
	local desc = nodeData.description or (clientInfo and clientInfo.description) or "No description"
	desc = tr(desc):gsub("\\n", "\n")

	-- Build effects as part of description
	local effects = nodeData.effect or (clientInfo and clientInfo.effect) or nil
	if effects and #effects > 0 then
		local extraLines = {}
		for _, eff in ipairs(effects) do
			if eff.type == "spell" then
				local spellName = eff.name or "Unknown"
				local spellInfo = PassiveSkills.spellInfo and PassiveSkills.spellInfo[spellName]
				table.insert(extraLines, "Learn: " .. spellName)
				if spellInfo then
					table.insert(extraLines, spellInfo.desc)
					local parts = {}
					if spellInfo.cooldown then table.insert(parts, "Cooldown: " .. spellInfo.cooldown) end
					if spellInfo.mana then table.insert(parts, "Mana: " .. spellInfo.mana) end
					if #parts > 0 then table.insert(extraLines, table.concat(parts, "  ")) end
				end
			elseif eff.type == "storage" then
				table.insert(extraLines, "+" .. (eff.value or 0) .. "% " .. (eff.name or "Bonus"))
			elseif eff.type == "condition" then
				table.insert(extraLines, "+" .. (eff.value or 0) .. "% " .. (eff.name or "Condition"))
			end
		end
		if #extraLines > 0 then
			desc = desc .. "\n\n" .. table.concat(extraLines, "\n")
		end
	end

	if PassiveSkills.Tooltip.description then
		PassiveSkills.Tooltip.description:setText(desc)
		-- Re-anchor description to the last visible header label to avoid dead space
		if PassiveSkills.Tooltip.description.removeAnchor then
			PassiveSkills.Tooltip.description:removeAnchor(AnchorTop)
			if reqLine ~= "" then
				PassiveSkills.Tooltip.description:addAnchor(AnchorTop, 'requirementLine', AnchorBottom)
				PassiveSkills.Tooltip.description:setMarginTop(2)
			elseif classLine ~= "" then
				PassiveSkills.Tooltip.description:addAnchor(AnchorTop, 'classLine', AnchorBottom)
				PassiveSkills.Tooltip.description:setMarginTop(2)
			else
				PassiveSkills.Tooltip.description:addAnchor(AnchorTop, 'subtitle', AnchorBottom)
				PassiveSkills.Tooltip.description:setMarginTop(2)
			end
		end
	end

	-- Extra info: max level only
	local extra = ""
	if nodeData.maxLevel then
		extra = tr("Max Rank: %s", nodeData.maxLevel)
	end
	if PassiveSkills.Tooltip.extraInfo then
		PassiveSkills.Tooltip.extraInfo:setText(extra)
		if PassiveSkills.Tooltip.extraInfo.removeAnchor then
			PassiveSkills.Tooltip.extraInfo:removeAnchor(AnchorTop)
			PassiveSkills.Tooltip.extraInfo:addAnchor(AnchorTop, 'description', AnchorBottom)
			PassiveSkills.Tooltip.extraInfo:setMarginTop(1)
		end
	end

	-- Adjust panel size based on visible content
	local totalHeight = 12  -- title margin-top
	local maxWidth = 180
	if PassiveSkills.Tooltip.title then
		totalHeight = totalHeight + PassiveSkills.Tooltip.title:getHeight()
		maxWidth = math.max(maxWidth, PassiveSkills.Tooltip.title:getTextSize().width)
	end
	if PassiveSkills.Tooltip.subtitle and subtitle ~= "" then
		totalHeight = totalHeight + PassiveSkills.Tooltip.subtitle:getHeight()
		maxWidth = math.max(maxWidth, PassiveSkills.Tooltip.subtitle:getTextSize().width)
	end
	if PassiveSkills.Tooltip.classLine and classLine ~= "" then
		totalHeight = totalHeight + PassiveSkills.Tooltip.classLine:getHeight()
		maxWidth = math.max(maxWidth, PassiveSkills.Tooltip.classLine:getTextSize().width)
	end
	if PassiveSkills.Tooltip.requirementLine and reqLine ~= "" then
		totalHeight = totalHeight + PassiveSkills.Tooltip.requirementLine:getHeight()
		maxWidth = math.max(maxWidth, PassiveSkills.Tooltip.requirementLine:getTextSize().width)
	end
	if PassiveSkills.Tooltip.description then
		totalHeight = totalHeight + PassiveSkills.Tooltip.description:getHeight() + 2  -- margin to extraInfo
		-- For description width, use text size but clamp; it wraps if too long
		local descSize = PassiveSkills.Tooltip.description:getTextSize()
		maxWidth = math.max(maxWidth, math.min(descSize.width, 400))
	end
	if PassiveSkills.Tooltip.extraInfo and extra ~= "" then
		totalHeight = totalHeight + PassiveSkills.Tooltip.extraInfo:getHeight()
		maxWidth = math.max(maxWidth, PassiveSkills.Tooltip.extraInfo:getTextSize().width)
	end
	local newWidth = math.min(math.max(maxWidth + 28, 220), 480)
	PassiveSkills.Tooltip:setWidth(newWidth)
	-- Ensure the panel is tall enough for all visible labels + padding
	local finalHeight = math.max(totalHeight + 28, 60)
	PassiveSkills.Tooltip:setHeight(finalHeight)
	-- Force re-layout so anchors take effect
	PassiveSkills.Tooltip:updateLayout()
end

function PassiveSkills.onHoverChange(widget, hovered)
	if hovered then
		if not widget.nodeData then return end
		if not PassiveSkills.Tooltip then return end
		PassiveSkills.applyTooltip(widget.nodeData, widget.nodeState, widget.blockReason)
		PassiveSkills.Tooltip:show()
		PassiveSkills.Tooltip:raise()
		connect(rootWidget, { onMouseMove = PassiveSkills.moveToolTip })
	else
		if PassiveSkills.Tooltip then
			PassiveSkills.Tooltip:hide()
		end
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
			tr("Confirm Level Up"),
			tr("Are you sure you want to level up this node?"),
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
	print("[PassiveSkills] Reset button clicked")
	PassiveSkills.sendOpcode({
		topic = "reset-tree-request"
	})
end

function PassiveSkills.handleResetRequirements(data)
	print("[PassiveSkills] handleResetRequirements: " .. tostring(data.requirements))
	local requirements = data.requirements
	local message = tr("To reset the passive skills, you need:") .. "\n" .. requirements

	PassiveSkills.setupConfirmMessage(
		tr("Confirm Tree Reset"),
		message .. "\n\n" .. tr("Are you sure you want to reset all your passive skills?"),
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
		-- In dev mode, internalPanel must NOT be phantom so lines can receive right-clicks
		-- In normal mode, set phantom so clicks pass through properly
		PassiveSkills.UI.internalPanel:setPhantom(not PassiveSkills.devMode)
	end

	local treeId = PassiveSkills.cachedTreeId or 0
	local progress = PassiveSkills.cachedProgress or {}

	if not PassiveSkills.cachedTreeData or PassiveSkills.cachedTreeData == 0 then
		PassiveSkills.UI.FullLockUI:setVisible(true)
		PassiveSkills.UI.FullLockUI:setText(tr("Locked"))
		return
	else
		PassiveSkills.UI.FullLockUI:setVisible(false)
	end

	local currentTreeData = PassiveSkills.cachedTreeData

	-- In dev mode, use a plain white background for better visibility
	if PassiveSkills.devMode then
		PassiveSkills.UI.background:setImageSource("")
		PassiveSkills.UI.background:setBackgroundColor('#ffffff')
		PassiveSkills.UI.background:setOpacity(1.0)
	else
		if currentTreeData.background then
			PassiveSkills.UI.background:setImageSource("images/backgrounds/" .. currentTreeData.background)
		else
			PassiveSkills.UI.background:setImageSource("images/backgrounds/default")
		end
		PassiveSkills.UI.background:setBackgroundColor('#00000000')
		PassiveSkills.UI.background:setOpacity(0.6)
	end

	-- Constellation 2D format (new)
	if currentTreeData.core then
		PassiveSkills.setupConstellationUI(currentTreeData)
		return
	end

	-- Legacy linear format
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
			nodeLevel:setText(tr("%d/%d", currentLevel, nodeData.maxLevel or 1))
		else
			node:addAnchor(AnchorTop, 'parent', AnchorTop)
			node:setMarginTop(PassiveSkills.marginBetweenNodes)

			local nodeLevel = g_ui.createWidget("NodeEntryLevel", PassiveSkills.UI.internalPanel)
			nodeLevel:addAnchor(AnchorLeft, nodeId, AnchorLeft)
			nodeLevel:addAnchor(AnchorTop, nodeId, AnchorTop)
			nodeLevel:addAnchor(AnchorHorizontalCenter, nodeId, AnchorHorizontalCenter)

			local currentLevel = branchProgress[nodeIndex] or 0
			nodeLevel:setText(tr("%d/%d", currentLevel, nodeData.maxLevel or 1))
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


------ Constellation 2D Rendering

function PassiveSkills.getNodeBranchAndIndex(treeData, nodeId)
	if treeData.core and treeData.core.id == nodeId then
		return 0, 0
	end
	if treeData.nexusNodes then
		for index, nodeData in ipairs(treeData.nexusNodes) do
			if nodeData.id == nodeId then
				return 0, index
			end
		end
	end
	for branchId, branchData in ipairs(treeData.branches or {}) do
		for index, nodeData in ipairs(branchData.nodes or {}) do
			if nodeData.id == nodeId then
				return branchId, index
			end
		end
	end
	return nil
end

function PassiveSkills.getNodeLevelFromProgress(progress, branchId, nodeIndex)
	local branchData = progress[branchId] or progress[tostring(branchId)]
	if not branchData then return 0 end
	return branchData[nodeIndex] or branchData[tostring(nodeIndex)] or 0
end

function PassiveSkills.deepCopyTable(t)
	if type(t) ~= "table" then return t end
	local res = {}
	for k, v in pairs(t) do
		res[k] = PassiveSkills.deepCopyTable(v)
	end
	return res
end

function PassiveSkills.buildProposedProgress()
	local treeData = PassiveSkills.cachedTreeData
	local proposed = PassiveSkills.deepCopyTable(PassiveSkills.cachedProgress or {})
	for _, alloc in ipairs(PassiveSkills.pendingAllocations or {}) do
		local branchData = proposed[alloc.branchId]
		if not branchData then
			branchData = {}
			proposed[alloc.branchId] = branchData
		end
		branchData[alloc.nodeIndex] = (branchData[alloc.nodeIndex] or 0) + 1
	end

	-- Auto-unlock fork nodes (server does this for free when a connection is unlocked)
	if treeData then
		local allNodes = {}
		local function addNode(nodeData)
			if nodeData then table.insert(allNodes, nodeData) end
		end
		addNode(treeData.core)
		for _, branchData in ipairs(treeData.branches or {}) do
			for _, nodeData in ipairs(branchData.nodes or {}) do
				addNode(nodeData)
			end
		end
		for _, nodeData in ipairs(treeData.nexusNodes or {}) do
			addNode(nodeData)
		end

		while true do
			local changed = false
			for _, nodeData in ipairs(allNodes) do
				local branchId, nodeIndex = PassiveSkills.getNodeBranchAndIndex(treeData, nodeData.id)
				if branchId then
					local level = PassiveSkills.getNodeLevelFromProgress(proposed, branchId, nodeIndex)
					if level > 0 then
						for _, connId in ipairs(nodeData.connections or {}) do
							local connBranch, connIndex = PassiveSkills.getNodeBranchAndIndex(treeData, connId)
							if connBranch then
								local connData = nil
								if connBranch == 0 then
									if connIndex == 0 then connData = treeData.core
									elseif treeData.nexusNodes then connData = treeData.nexusNodes[connIndex]
									end
								elseif treeData.branches[connBranch] then
									connData = treeData.branches[connBranch].nodes[connIndex]
								end
								if connData and connData.kind == "fork" then
									local connLevel = PassiveSkills.getNodeLevelFromProgress(proposed, connBranch, connIndex)
									if connLevel == 0 and (connData.maxLevel or 1) >= 1 then
										if not proposed[connBranch] then
											proposed[connBranch] = {}
										end
										proposed[connBranch][connIndex] = 1
										changed = true
									end
								end
							end
						end
					end
				end
			end
			if not changed then break end
		end
	end

	return proposed
end

function PassiveSkills.addPendingAllocation(branchId, nodeIndex, cost)
	cost = cost or 1
	table.insert(PassiveSkills.pendingAllocations, {branchId = branchId, nodeIndex = nodeIndex, cost = cost})
end

function PassiveSkills.removePendingAllocation(branchId, nodeIndex)
	for i = #PassiveSkills.pendingAllocations, 1, -1 do
		local alloc = PassiveSkills.pendingAllocations[i]
		if alloc.branchId == branchId and alloc.nodeIndex == nodeIndex then
			table.remove(PassiveSkills.pendingAllocations, i)
			return true
		end
	end
	return false
end

function PassiveSkills.clearPendingAllocations()
	PassiveSkills.pendingAllocations = {}
end

function PassiveSkills.getPendingCost()
	local cost = 0
	for _, alloc in ipairs(PassiveSkills.pendingAllocations or {}) do
		cost = cost + (alloc.cost or 1)
	end
	return cost
end

function PassiveSkills.countPendingAllocations()
	return #PassiveSkills.pendingAllocations
end

function PassiveSkills.getConstellationNodeState(treeData, progress, nodeData, availablePoints)
	local branchId, nodeIndex = PassiveSkills.getNodeBranchAndIndex(treeData, nodeData.id)
	local level = PassiveSkills.getNodeLevelFromProgress(progress, branchId, nodeIndex)
	local maxLevel = nodeData.maxLevel or 1
	if level >= maxLevel then return "maxed", nil end
	if level > 0 then
		local nodeCost = nodeData.costToLevelUp or 1
		if availablePoints >= nodeCost then
			return "available", nil
		end
		return "unlocked", tr("Need %d point(s) to rank up.", nodeCost)
	end

	-- Core node is always available if not yet unlocked
	if nodeData.kind == "core" then
		local coreCost = nodeData.costToLevelUp or 1
		if availablePoints >= coreCost then
			return "available", nil
		end
		return "locked", tr("Need %d point(s).", coreCost)
	end

	-- Connection requirement
	local hasConnection = false
	for _, connId in ipairs(nodeData.connections or {}) do
		if connId == 0 then
			if treeData.core then
				if PassiveSkills.getNodeLevelFromProgress(progress, 0, 0) > 0 then
					hasConnection = true
					break
				end
			end
		else
			local connBranch, connIndex = PassiveSkills.getNodeBranchAndIndex(treeData, connId)
			if connBranch and PassiveSkills.getNodeLevelFromProgress(progress, connBranch, connIndex) > 0 then
				hasConnection = true
				break
			end
		end
	end

	-- Mutual exclusion: block if an exclusive node is already (or proposed to be) allocated
	if nodeData.mutuallyExclusive then
		for _, group in ipairs(nodeData.mutuallyExclusive) do
			for _, exclusiveId in ipairs(group) do
				if exclusiveId ~= nodeData.id then
					local exBranch, exIndex = PassiveSkills.getNodeBranchAndIndex(treeData, exclusiveId)
					if exBranch and PassiveSkills.getNodeLevelFromProgress(progress, exBranch, exIndex) > 0 then
						local exData = nil
						if exBranch == 0 then
							if exIndex == 0 then exData = treeData.core
							elseif treeData.nexusNodes then exData = treeData.nexusNodes[exIndex]
							end
						elseif treeData.branches[exBranch] then
							exData = treeData.branches[exBranch].nodes[exIndex]
						end
						local exName = exData and exData.name or tostring(exclusiveId)
						return "blocked", tr("Mutually exclusive with %s.", exName)
					end
				end
			end
		end
	end

	if not hasConnection then
		return "locked", tr("Requires an unlocked connected node.")
	end

	-- Forks auto-unlock when reached; they cost no passive point
	if nodeData.kind == "fork" then
		return "unlocked", nil
	end

	-- Requirement checks (client-side preview)
	if nodeData.requirements then
		local req = nodeData.requirements
		if req.spentInBranch then
			for reqBranch, reqPoints in pairs(req.spentInBranch) do
				local branchKey = tonumber(reqBranch) or reqBranch
				local branchData = progress[branchKey] or progress[tostring(branchKey)] or {}
				local spent = 0
				for _, lv in pairs(branchData) do
					spent = spent + lv
				end
				if spent < reqPoints then
					return "blocked", tr("Requires %d points in branch %d (%d spent).", reqPoints, reqBranch, spent)
				end
			end
		end
		if req.spentTotal then
			local spentTotal = 0
			for _, nodes in pairs(progress) do
				for _, lv in pairs(nodes) do
					spentTotal = spentTotal + lv
				end
			end
			if spentTotal < req.spentTotal then
				return "blocked", tr("Requires %d total points (%d spent).", req.spentTotal, spentTotal)
			end
		end
		if req.unlockedNodes then
			for _, reqNodeId in ipairs(req.unlockedNodes) do
				local reqBranch, reqIndex = PassiveSkills.getNodeBranchAndIndex(treeData, reqNodeId)
				if not reqBranch or PassiveSkills.getNodeLevelFromProgress(progress, reqBranch, reqIndex) <= 0 then
					return "blocked", tr("Requires linked keystone(s).")
				end
			end
		end
		if req.level then
			local localPlayer = g_game.getLocalPlayer()
			if not localPlayer or localPlayer:getLevel() < req.level then
				return "blocked", tr("Requires character level %d.", req.level)
			end
		end
	end

	local nodeCost = nodeData.costToLevelUp or 1
	if availablePoints < nodeCost then
		return "locked", tr("Need %d point(s).", nodeCost)
	end
	return "available", nil
end

function PassiveSkills.drawConnectionLine(parent, x1, y1, x2, y2, color, connInfo)
	local x1n, y1n, x2n, y2n = tonumber(x1) or 0, tonumber(y1) or 0, tonumber(x2) or 0, tonumber(y2) or 0
	local dx = x2n - x1n
	local dy = y2n - y1n
	local distance = tonumber(math.sqrt(dx * dx + dy * dy)) or 0
	if distance < 1 then return nil end
	local angle = tonumber(math.atan2(dy, dx) * 180 / math.pi) or 0

	local cx = (x1n + x2n) / 2
	local cy = (y1n + y2n) / 2
	local lineX = cx - distance / 2
	local lineY = cy - 1

	local line = g_ui.createWidget("Panel", parent)
	line:addAnchor(AnchorLeft, 'parent', AnchorLeft)
	line:addAnchor(AnchorTop, 'parent', AnchorTop)
	line:setMarginLeft(lineX)
	line:setMarginTop(lineY)
	line:setSize({width = math.floor(distance), height = 2})
	line:setRotation(angle)
	line:setBackgroundColor(color)
	line:setPhantom(true)

	return line
end

-- Generate a unique waypoint ID
function PassiveSkills.generateWaypointId(nodesById)
	local maxId = 0
	for id, _ in pairs(nodesById) do
		if id > maxId then maxId = id end
	end
	local baseId = 10000
	if maxId >= baseId then baseId = maxId + 1 end
	return baseId
end

-- Distance from point to line segment
function PassiveSkills.pointToSegmentDist(px, py, x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1
	local lenSq = dx * dx + dy * dy
	if lenSq < 1 then return math.sqrt((px - x1)^2 + (py - y1)^2) end
	local t = ((px - x1) * dx + (py - y1) * dy) / lenSq
	t = math.max(0, math.min(1, t))
	local projX = x1 + t * dx
	local projY = y1 + t * dy
	return math.sqrt((px - projX)^2 + (py - projY)^2)
end

-- Find the closest connection line to a click point
function PassiveSkills.findClosestConnection(clickX, clickY, nodesById, offsetX, offsetY, nodeSpacingX, nodeSpacingY)
	local bestDist = 999999
	local bestFromNode = nil
	local bestToNode = nil
	local bestConnKey = nil
	local threshold = 25  -- max pixels from line to count as a hit
	local drawnConnections = {}
	for _, fromNode in pairs(nodesById) do
		if fromNode.kind ~= "waypoint" then
			for _, connId in ipairs(fromNode.connections or {}) do
				local toNode = nodesById[connId]
				if toNode and toNode.kind ~= "waypoint" then
					local minId = math.min(fromNode.id, toNode.id)
					local maxId = math.max(fromNode.id, toNode.id)
					local connKey = minId .. "-" .. maxId
					if not drawnConnections[connKey] then
						drawnConnections[connKey] = true
						-- Get all points along the route (including waypoints)
						local points = {}
						table.insert(points, {x = offsetX + fromNode.pos.x * nodeSpacingX, y = offsetY + fromNode.pos.y * nodeSpacingY})
						local route = PassiveSkills.calculateRoute(fromNode, toNode, nodesById)
						for _, wpId in ipairs(route) do
							local wpNode = nodesById[wpId]
							if wpNode then
								table.insert(points, {x = offsetX + wpNode.pos.x * nodeSpacingX, y = offsetY + wpNode.pos.y * nodeSpacingY})
							end
						end
						table.insert(points, {x = offsetX + toNode.pos.x * nodeSpacingX, y = offsetY + toNode.pos.y * nodeSpacingY})
						-- Check distance to each segment
						for i = 1, #points - 1 do
							local d = PassiveSkills.pointToSegmentDist(clickX, clickY, points[i].x, points[i].y, points[i+1].x, points[i+1].y)
							if d < bestDist then
								bestDist = d
								bestFromNode = fromNode
								bestToNode = toNode
								bestConnKey = connKey
							end
						end
					end
				end
			end
		end
	end
	if bestDist <= threshold then
		return bestFromNode, bestToNode, bestConnKey
	end
	return nil
end

-- Check if clicking on an existing waypoint (to remove it)
function PassiveSkills.findWaypointAtPosition(clickX, clickY, nodesById, offsetX, offsetY, nodeSpacingX, nodeSpacingY)
	local threshold = 20
	for id, nodeData in pairs(nodesById) do
		if nodeData.kind == "waypoint" then
			local wpx = offsetX + nodeData.pos.x * nodeSpacingX
			local wpy = offsetY + nodeData.pos.y * nodeSpacingY
			local d = math.sqrt((clickX - wpx)^2 + (clickY - wpy)^2)
			if d <= threshold then
				return nodeData
			end
		end
	end
	return nil
end

-- Find which node owns a waypoint in its routeWaypoints (per-connection)
function PassiveSkills.findWaypointOwner(wpId, nodesById)
	for id, nodeData in pairs(nodesById) do
		if nodeData.routeWaypoints then
			for connKey, wpList in pairs(nodeData.routeWaypoints) do
				for _, rid in ipairs(wpList) do
					if rid == wpId then
						return nodeData
					end
				end
			end
		end
	end
	return nil
end

-- Right-click on panel: create or remove waypoint
function PassiveSkills.onPanelRightClick(mousePos)
	local panel = PassiveSkills.devPanel
	if not panel then return end
	local nodesById = PassiveSkills.devNodesById
	if not nodesById then return end
	local offsetX = PassiveSkills.devOffsetX
	local offsetY = PassiveSkills.devOffsetY
	local nodeSpacingX = PassiveSkills.devNodeSpacingX
	local nodeSpacingY = PassiveSkills.devNodeSpacingY
	local nodeSize = PassiveSkills.devNodeSize

	-- Get click position relative to panel
	local mousePosGlobal = g_window.getMousePosition()
	local panelRect = panel:getRect()
	local clickX = tonumber(mousePosGlobal.x) - tonumber(panelRect.x) or 0
	local clickY = tonumber(mousePosGlobal.y) - tonumber(panelRect.y) or 0

	-- First check if clicking on an existing waypoint (to remove it)
	local existingWp = PassiveSkills.findWaypointAtPosition(clickX, clickY, nodesById, offsetX, offsetY, nodeSpacingX, nodeSpacingY)
	if existingWp then
		-- Find owner and remove
		local owner = PassiveSkills.findWaypointOwner(existingWp.id, nodesById)
		local connInfo = nil
		if owner then
			-- Find the toNode for this connection
			for _, connId in ipairs(owner.connections or {}) do
				local toNode = nodesById[connId]
				if toNode then
					connInfo = {fromNode = owner, toNode = toNode, fromId = owner.id, toId = toNode.id}
					break
				end
			end
		end
		PassiveSkills.removeWaypoint(existingWp.id, connInfo, nodesById)
		return
	end

	-- Find closest connection line
	local fromNode, toNode, connKey = PassiveSkills.findClosestConnection(clickX, clickY, nodesById, offsetX, offsetY, nodeSpacingX, nodeSpacingY)
	if not fromNode then return end

	-- Snap to grid
	local gridX = math.floor((clickX - offsetX) / nodeSpacingX + 0.5)
	local gridY = math.floor((clickY - offsetY) / nodeSpacingY + 0.5)

	-- Create new waypoint node
	local wpId = PassiveSkills.generateWaypointId(nodesById)
	local wpNode = {
		id = wpId,
		name = "Waypoint",
		kind = "waypoint",
		pos = {x = gridX, y = gridY},
		maxLevel = 0,
		connections = {}
	}
	nodesById[wpId] = wpNode

	-- Add to routeWaypoints on fromNode, keyed by connection
	if not fromNode.routeWaypoints then
		fromNode.routeWaypoints = {}
	end
	local minId = math.min(fromNode.id, toNode.id)
	local maxId = math.max(fromNode.id, toNode.id)
	local connKey = minId .. "-" .. maxId
	if not fromNode.routeWaypoints[connKey] then
		fromNode.routeWaypoints[connKey] = {}
	end
	-- Avoid duplicate waypoint IDs
	local alreadyExists = false
	for _, existingId in ipairs(fromNode.routeWaypoints[connKey]) do
		if existingId == wpId then
			alreadyExists = true
			break
		end
	end
	if not alreadyExists then
		table.insert(fromNode.routeWaypoints[connKey], wpId)
	end

	-- Redraw everything
	PassiveSkills.redrawConnections(panel, nodesById, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodeSize,
		PassiveSkills.devProgress, PassiveSkills.devAvailablePoints, PassiveSkills.devTreeData)
end

-- Remove a waypoint
function PassiveSkills.removeWaypoint(wpId, connInfo, nodesById)
	-- Remove from all routeWaypoints lists (per-connection structure)
	for id, nodeData in pairs(nodesById) do
		if nodeData.routeWaypoints then
			for connKey, wpList in pairs(nodeData.routeWaypoints) do
				for i, rid in ipairs(wpList) do
					if rid == wpId then
						table.remove(wpList, i)
						break
					end
				end
			end
		end
	end
	-- Remove from nodesById
	nodesById[wpId] = nil

	-- Redraw
	local panel = PassiveSkills.devPanel
	if panel then
		PassiveSkills.redrawConnections(panel, nodesById,
			PassiveSkills.devOffsetX, PassiveSkills.devOffsetY,
			PassiveSkills.devNodeSpacingX, PassiveSkills.devNodeSpacingY,
			PassiveSkills.devNodeSize,
			PassiveSkills.devProgress, PassiveSkills.devAvailablePoints,
			PassiveSkills.devTreeData)
	end
end

-- Draw a waypoint node (draggable, right-click to remove)
function PassiveSkills.drawWaypointNode(panel, wpNode, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodeSize, connInfo)
	local cx = offsetX + wpNode.pos.x * nodeSpacingX
	local cy = offsetY + wpNode.pos.y * nodeSpacingY
	local wpSize = 20
	local wpX = cx - math.floor(wpSize / 2)
	local wpY = cy - math.floor(wpSize / 2)

	local wp = g_ui.createWidget("Panel", panel)
	wp:setId("waypoint_" .. wpNode.id)
	wp:addAnchor(AnchorLeft, 'parent', AnchorLeft)
	wp:addAnchor(AnchorTop, 'parent', AnchorTop)
	wp:setMarginLeft(wpX)
	wp:setMarginTop(wpY)
	wp:setSize({width = wpSize, height = wpSize})
	wp:setImageSource('/images/icons/node')
	wp:setImageColor('#f4ca16')
	wp:setImageFixedRatio(true)
	wp:setPhantom(false)

	-- Store data
	wp.wpNode = wpNode
	wp.wpConnInfo = connInfo

	-- Dragging state
	local dragging = false
	local dragStartMouseX, dragStartMouseY = 0, 0
	local dragStartNodeX, dragStartNodeY = 0, 0

	wp.onMousePress = function(widget, mousePos, mouseButton)
		if mouseButton == MouseRightButton and PassiveSkills.devMode then
			PassiveSkills.removeWaypoint(wpNode.id, connInfo, PassiveSkills.devNodesById)
			return true
		elseif mouseButton == MouseLeftButton and PassiveSkills.devMode then
			dragging = true
			PassiveSkills.draggingWaypointId = wpNode.id
			local globalPos = g_window.getMousePosition()
			local panelRect = panel:getRect()
			dragStartMouseX = tonumber(globalPos.x) - tonumber(panelRect.x) or 0
			dragStartMouseY = tonumber(globalPos.y) - tonumber(panelRect.y) or 0
			dragStartNodeX = tonumber(wp:getMarginLeft()) or 0
			dragStartNodeY = tonumber(wp:getMarginTop()) or 0
			return true
		end
		return false
	end

	wp.onMouseRelease = function(widget, mousePos, mouseButton)
		if mouseButton == MouseLeftButton and dragging then
			dragging = false
			PassiveSkills.draggingWaypointId = nil
			-- Snap to grid
			local curX = tonumber(wp:getMarginLeft()) or 0
			local curY = tonumber(wp:getMarginTop()) or 0
			local centerX = curX + math.floor(wpSize / 2)
			local centerY = curY + math.floor(wpSize / 2)
			local snappedCenterX = math.floor((centerX - offsetX) / nodeSpacingX + 0.5) * nodeSpacingX + offsetX
			local snappedCenterY = math.floor((centerY - offsetY) / nodeSpacingY + 0.5) * nodeSpacingY + offsetY
			local snappedX = snappedCenterX - math.floor(wpSize / 2)
			local snappedY = snappedCenterY - math.floor(wpSize / 2)
			wp:setMarginLeft(snappedX)
			wp:setMarginTop(snappedY)
			wpNode.pos = {x = (snappedCenterX - offsetX) / nodeSpacingX, y = (snappedCenterY - offsetY) / nodeSpacingY}
			-- Full redraw (now including waypoints)
			PassiveSkills.redrawConnections(panel, PassiveSkills.devNodesById, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodeSize,
				PassiveSkills.devProgress, PassiveSkills.devAvailablePoints, PassiveSkills.devTreeData)
			return true
		end
		return false
	end

	wp.onMouseMove = function(widget, mousePos, mouseMoved)
		if dragging and PassiveSkills.devMode then
			local globalPos = g_window.getMousePosition()
			local panelRect = panel:getRect()
			local curMouseX = tonumber(globalPos.x) - tonumber(panelRect.x) or 0
			local curMouseY = tonumber(globalPos.y) - tonumber(panelRect.y) or 0
			local dx = curMouseX - dragStartMouseX
			local dy = curMouseY - dragStartMouseY
			wp:setMarginLeft(dragStartNodeX + dx)
			wp:setMarginTop(dragStartNodeY + dy)
			-- Update pos and redraw connections (waypoints won't be destroyed because draggingWaypointId is set)
			local curX = tonumber(wp:getMarginLeft()) or 0
			local curY = tonumber(wp:getMarginTop()) or 0
			local centerX = curX + math.floor(wpSize / 2)
			local centerY = curY + math.floor(wpSize / 2)
			wpNode.pos = {x = (centerX - offsetX) / nodeSpacingX, y = (centerY - offsetY) / nodeSpacingY}
			PassiveSkills.redrawConnections(panel, PassiveSkills.devNodesById, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodeSize,
				PassiveSkills.devProgress, PassiveSkills.devAvailablePoints, PassiveSkills.devTreeData)
			return true
		end
		return false
	end

	return wp
end

-- Calculates a route of waypoint node IDs between fromNode and toNode
-- Waypoints are stored per-connection using key "minId-maxId"
function PassiveSkills.calculateRoute(fromNode, toNode, nodesById)
	local route = {}
	local minId = math.min(fromNode.id, toNode.id)
	local maxId = math.max(fromNode.id, toNode.id)
	local connKey = minId .. "-" .. maxId
	local allRoutes = PassiveSkills.cachedRouteWaypoints or {}
	local wpList = allRoutes[connKey]
	if not wpList and fromNode.routeWaypoints then
		wpList = fromNode.routeWaypoints[connKey]
	end
	if not wpList and toNode.routeWaypoints then
		wpList = toNode.routeWaypoints[connKey]
	end
	if wpList then
		for _, wpId in ipairs(wpList) do
			if nodesById[wpId] then
				table.insert(route, wpId)
			end
		end
	end
	return route
end

function PassiveSkills.setupConstellationUI(treeData)
	local scrollPanel = PassiveSkills.UI.internalPanel
	scrollPanel:destroyChildren()

	local cachedProgress = PassiveSkills.cachedProgress or {}
	local cachedAvailablePoints = PassiveSkills.cachedAvailablePoints or 0
	local progress = PassiveSkills.buildProposedProgress()
	local availablePoints = math.max(0, cachedAvailablePoints - PassiveSkills.getPendingCost())

	local nodeSize = 44
	local nodeSpacingX = 48
	local nodeSpacingY = 44
	PassiveSkills.devGridSize = nodeSpacingX  -- grid snap = spacing

	-- Collect all nodes and compute bounds
	local nodesById = {}
	local minX, maxX, minY, maxY = 0, 0, 0, 0
	local function addNode(nodeData)
		if not nodeData or not nodeData.pos then return end
		nodesById[nodeData.id] = nodeData
		minX = math.min(minX, nodeData.pos.x)
		maxX = math.max(maxX, nodeData.pos.x)
		minY = math.min(minY, nodeData.pos.y)
		maxY = math.max(maxY, nodeData.pos.y)
	end

	addNode(treeData.core)
	for _, branchData in ipairs(treeData.branches or {}) do
		for _, nodeData in ipairs(branchData.nodes or {}) do
			addNode(nodeData)
		end
	end
	for _, nodeData in ipairs(treeData.nexusNodes or {}) do
		addNode(nodeData)
	end
	-- Load waypoint nodes from tree data (saved by dev mode)
	local wpNodeCount = 0
	for _, nodeData in ipairs(treeData.waypointNodes or {}) do
		addNode(nodeData)
		wpNodeCount = wpNodeCount + 1
	end
	-- Count routeWaypoints on nodes
	local rwCount = 0
	for _, nodeData in pairs(treeData.branches or {}) do
		for _, n in ipairs(nodeData.nodes or {}) do
			if n.routeWaypoints then
				for _ in pairs(n.routeWaypoints) do rwCount = rwCount + 1 end
			end
		end
	end
	if treeData.core and treeData.core.routeWaypoints then
		for _ in pairs(treeData.core.routeWaypoints) do rwCount = rwCount + 1 end
	end
	print(string.format("[PassiveSkills] setupConstellationUI: waypointNodes=%d, routeWaypoints=%d", wpNodeCount, rwCount))

	local contentWidth = (maxX - minX) * nodeSpacingX + nodeSize * 2
	local contentHeight = (maxY - minY) * nodeSpacingY + nodeSize * 2

	-- Create the container panel first with anchors so it matches parent size
	local panel = g_ui.createWidget("Panel", scrollPanel)
	panel:setId("constellationContainer")
	panel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
	panel:addAnchor(AnchorTop, 'parent', AnchorTop)
	panel:addAnchor(AnchorRight, 'parent', AnchorRight)
	panel:addAnchor(AnchorBottom, 'parent', AnchorBottom)
	-- In dev mode, panel receives clicks so lines can be right-clicked
	-- In normal mode, phantom so clicks pass through to nodes
	if PassiveSkills.devMode then
		panel:setPhantom(false)
		panel:setBackgroundColor('#00000000')
		-- Right-click on panel creates/removes waypoints
		panel.onMousePress = function(widget, mousePos, mouseButton)
			if mouseButton == MouseRightButton and PassiveSkills.devMode then
				PassiveSkills.onPanelRightClick(mousePos)
				return true
			end
			return false
		end
	else
		panel:setPhantom(true)
	end

	-- Now get the actual panel size from the anchored widget
	local panelWidth = panel:getWidth()
	local panelHeight = panel:getHeight()

	-- If content is larger than panel, scale spacing down to fit
	if contentWidth > panelWidth then
		local scale = (panelWidth - nodeSize * 2) / ((maxX - minX) * nodeSpacingX)
		nodeSpacingX = math.floor(nodeSpacingX * scale)
	end
	if contentHeight > panelHeight then
		local scale = (panelHeight - nodeSize * 2) / ((maxY - minY) * nodeSpacingY)
		nodeSpacingY = math.floor(nodeSpacingY * scale)
	end
	PassiveSkills.devGridSize = nodeSpacingX
	contentWidth = (maxX - minX) * nodeSpacingX + nodeSize * 2
	contentHeight = (maxY - minY) * nodeSpacingY + nodeSize * 2
	local offsetX = math.floor((panelWidth - contentWidth) / 2) - minX * nodeSpacingX + math.floor(nodeSize / 2)
	local offsetY = math.floor((panelHeight - contentHeight) / 2) - minY * nodeSpacingY + math.floor(nodeSize / 2)

	local function nodePixelPos(nodeData)
		-- Position node so its center aligns to the grid cell
		local cx = offsetX + nodeData.pos.x * nodeSpacingX
		local cy = offsetY + nodeData.pos.y * nodeSpacingY
		return cx - math.floor(nodeSize / 2), cy - math.floor(nodeSize / 2)
	end

	-- Store for dev mode
	PassiveSkills.devPanel = panel
	PassiveSkills.devNodesById = nodesById
	PassiveSkills.devOffsetX = offsetX
	PassiveSkills.devOffsetY = offsetY
	PassiveSkills.devNodeSpacingX = nodeSpacingX
	PassiveSkills.devNodeSpacingY = nodeSpacingY
	PassiveSkills.devNodeSize = nodeSize
	PassiveSkills.devProgress = progress
	PassiveSkills.devAvailablePoints = availablePoints
	PassiveSkills.devTreeData = treeData

	-- Dev mode: show grid overlay aligned to node positions
	if PassiveSkills.devMode then
		PassiveSkills.createDevGrid(panel, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodeSize)
	end

	-- Draw connections first (so they appear behind nodes)
	local drawnConnections = {}
	for _, fromNode in pairs(nodesById) do
		for _, connId in ipairs(fromNode.connections or {}) do
			local toNode = nodesById[connId]
			if toNode then
				local minId = math.min(fromNode.id, toNode.id)
				local maxId = math.max(fromNode.id, toNode.id)
				local connKey = minId .. "-" .. maxId
				if not drawnConnections[connKey] then
					drawnConnections[connKey] = true
					local x1, y1 = nodePixelPos(fromNode)
					local x2, y2 = nodePixelPos(toNode)
					local cx1, cy1 = x1 + math.floor(nodeSize / 2), y1 + math.floor(nodeSize / 2)
					local cx2, cy2 = x2 + math.floor(nodeSize / 2), y2 + math.floor(nodeSize / 2)

					local state1 = PassiveSkills.getConstellationNodeState(treeData, progress, fromNode, availablePoints)
					local state2 = PassiveSkills.getConstellationNodeState(treeData, progress, toNode, availablePoints)
					local color = '#3a3045'
					if (state1 == "unlocked" or state1 == "maxed") and (state2 == "unlocked" or state2 == "maxed") then
						color = '#f4ca16'
					elseif (state1 == "available" or state1 == "unlocked" or state1 == "maxed") and (state2 == "available") then
						color = '#7a7090'
					end
					-- Calculate route through waypoint nodes if any
					local route = PassiveSkills.calculateRoute(fromNode, toNode, nodesById)
					if #route > 0 then
						print(string.format("[PassiveSkills] calculateRoute: %d->%d connKey=%s route=%d waypoints", fromNode.id, toNode.id, tostring(fromNode.id) .. "-" .. tostring(toNode.id), #route))
					end
					local connInfo = {
						fromId = fromNode.id,
						toId = toNode.id,
						fromNode = fromNode,
						toNode = toNode,
						connKey = connKey
					}
					local prevX, prevY = cx1, cy1
					for _, wpId in ipairs(route) do
						local wpNode = nodesById[wpId]
						if wpNode then
							local wpx = offsetX + wpNode.pos.x * nodeSpacingX
							local wpy = offsetY + wpNode.pos.y * nodeSpacingY
							local segInfo = {
								fromId = fromNode.id,
								toId = toNode.id,
								fromNode = fromNode,
								toNode = toNode,
								connKey = connKey,
								segmentIndex = #route > 0 and 1 or nil
							}
							local segLine = PassiveSkills.drawConnectionLine(panel, prevX, prevY, wpx, wpy, color, segInfo)
							if segLine then
								segLine:setId("connLine_" .. connKey .. "_" .. wpId)
							end
							-- Draw the waypoint visual node
							PassiveSkills.drawWaypointNode(panel, wpNode, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodeSize, connInfo)
							prevX, prevY = wpx, wpy
						end
					end
					local line = PassiveSkills.drawConnectionLine(panel, prevX, prevY, cx2, cy2, color, connInfo)
					if line then
						line:setId("connLine_" .. connKey)
					end
				end
			end
		end
	end

	-- Draw nodes (skip waypoint nodes - they are drawn with connections)
	for _, nodeData in pairs(nodesById) do
		if nodeData.kind ~= "waypoint" then
			PassiveSkills.createConstellationNode(panel, treeData, nodeData, nodePixelPos, cachedProgress, progress, availablePoints, nodeSize)
		end
	end

	PassiveSkills.setupPoints()
end

function PassiveSkills.createConstellationNode(panel, treeData, nodeData, nodePixelPos, cachedProgress, progress, availablePoints, nodeSize)
	nodeSize = nodeSize or 28
	local branchId, nodeIndex = PassiveSkills.getNodeBranchAndIndex(treeData, nodeData.id)
	local cachedLevel = PassiveSkills.getNodeLevelFromProgress(cachedProgress, branchId, nodeIndex)
	local proposedLevel = PassiveSkills.getNodeLevelFromProgress(progress, branchId, nodeIndex)
	local state, blockReason = PassiveSkills.getConstellationNodeState(treeData, progress, nodeData, availablePoints)
	local maxLevel = nodeData.maxLevel or 1
	local level = proposedLevel
	local x, y = nodePixelPos(nodeData)
	x = tonumber(x) or 0
	y = tonumber(y) or 0
	print(string.format("[PassiveSkills] createConstellationNode: id=%s name=%s kind=%s pos=%d,%d", tostring(nodeData.id), tostring(nodeData.name), tostring(nodeData.kind), x, y))

	local node = g_ui.createWidget("NodeEntry", panel)
	node:addAnchor(AnchorLeft, 'parent', AnchorLeft)
	node:addAnchor(AnchorTop, 'parent', AnchorTop)
	node:setMarginLeft(x)
	node:setMarginTop(y)
	node:setSize({width = nodeSize, height = nodeSize})

	-- Border first (behind icon)
	local border = g_ui.createWidget("NodeEntryBorder", node)
	border:setImageSource('images/borders/21')

	-- Border color based on node kind first, then modified by state
	local kindColors = {
		core = '#f4ca16',
		keystone = '#ff8040',
		notable = '#a040ff',
		nexus = '#40ff80',
		fork = '#40a0ff',
		star = '#c0c0c0',
		waypoint = '#808080',
	}
	-- Get base color from kind
	local borderColor = kindColors[nodeData.kind] or '#c0c0c0'

	-- Override with state-based colors (state takes priority for visibility)
	if proposedLevel > cachedLevel then
		-- Pending allocation: green tint
		borderColor = '#60ff60'
	elseif state == "maxed" then
		borderColor = '#f4ca16'
	elseif state == "unlocked" then
		-- Keep kind color but brighten it
		borderColor = kindColors[nodeData.kind] or '#ffffff'
	elseif state == "available" then
		-- Dimmed version of kind color
		local stateColors = {
			core = '#d4b830',
			keystone = '#d46030',
			notable = '#8030c0',
			nexus = '#30c060',
			fork = '#3080c0',
			star = '#909090',
		}
		borderColor = stateColors[nodeData.kind] or '#a098b0'
	elseif state == "blocked" then
		borderColor = '#ff4040'
	elseif state == "locked" then
		borderColor = '#3a3045'
	end
	border:setImageColor(borderColor)

	-- Icon on top of border
	local iconPath = 'images/no_image.png'
	-- Try custom icon from talents/icons folder first
	if nodeData.icon then
		local customPath = 'images/talents/icons/' .. nodeData.icon .. '.png'
		if g_resources.fileExists(customPath) then
			iconPath = customPath
		end
	end
	-- Fallback to existing tree images by branch and node index (cycling 1-6)
	if iconPath == 'images/no_image.png' and branchId and nodeIndex then
		local treeBg = treeData.background or '1'
		local imgIdx = ((nodeIndex - 1) % 6) + 1
		local branchPath = 'images/tree' .. treeBg .. '/branch' .. branchId .. '/' .. imgIdx .. '.png'
		if g_resources.fileExists(branchPath) then
			iconPath = branchPath
		end
	end
	node:setImageSource(iconPath)
	-- Only dim locked nodes, available/unlocked/maxed should be fully visible
	if state == "locked" then
		node:setOpacity(0.5)
	else
		node:setOpacity(1.0)
	end

	-- Level label below-right of node for all nodes
	local label = g_ui.createWidget("NodeEntryLevel2D", panel)
	label:addAnchor(AnchorLeft, 'parent', AnchorLeft)
	label:addAnchor(AnchorTop, 'parent', AnchorTop)
	label:setMarginLeft(x + nodeSize - 6)
	label:setMarginTop(y + nodeSize - 8)
	label:setText(level .. "/" .. maxLevel)
	node.devLevelLabel = label

	-- Store level and position info for interaction
	node.cachedLevel = cachedLevel
	node.proposedLevel = proposedLevel
	node.maxLevel = maxLevel
	node.nodeBranchId = branchId
	node.nodeIndex = nodeIndex

	-- Dev mode: make node draggable; otherwise click to allocate/remove pending points
	if PassiveSkills.devMode and PassiveSkills.devPanel then
		PassiveSkills.makeNodeDraggable(node, nodeData, PassiveSkills.devPanel, nodeSize,
			PassiveSkills.devOffsetX, PassiveSkills.devOffsetY,
			PassiveSkills.devNodeSpacingX, PassiveSkills.devNodeSpacingY,
			PassiveSkills.devNodesById, PassiveSkills.devProgress,
			PassiveSkills.devAvailablePoints, PassiveSkills.devTreeData)
	else
		-- Left click: add pending point. Right click: remove one pending point.
		node.onMousePress = function(widget, mousePos, mouseButton)
			if mouseButton == MouseLeftButton then
				if state == "available" and proposedLevel < maxLevel and nodeData.kind ~= "fork" then
					local nodeCost = nodeData.costToLevelUp or 1
					local remaining = (PassiveSkills.cachedAvailablePoints or 0) - PassiveSkills.getPendingCost()
					if remaining >= nodeCost then
						PassiveSkills.addPendingAllocation(branchId, nodeIndex, nodeCost)
						PassiveSkills.setupTreeUI()
					end
				end
				return true
			elseif mouseButton == MouseRightButton then
				if proposedLevel > cachedLevel then
					PassiveSkills.removePendingAllocation(branchId, nodeIndex)
					PassiveSkills.setupTreeUI()
				end
				return true
			end
			return false
		end
	end

	-- Hover tooltip on node
	node.nodeData = nodeData
	node.nodeState = state
	node.blockReason = blockReason
	node.onHoverChange = PassiveSkills.onHoverChange

	return node
end

function PassiveSkills.setupPoints()
	local proposedAvailable = (PassiveSkills.cachedAvailablePoints or 0) - PassiveSkills.getPendingCost()
	if PassiveSkills.UI.AvaliablePassivePoints then
		PassiveSkills.UI.AvaliablePassivePoints:setText(tr("Available: %s", proposedAvailable))
	end
	if PassiveSkills.UI.TotalPassivePoints then
		PassiveSkills.UI.TotalPassivePoints:setText(tr("Total: %s", PassiveSkills.cachedTotalPoints or 0))
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
		PassiveSkills.cachedAvailablePoints = data.availablePoints
		PassiveSkills.cachedTotalPoints = data.totalPoints
		PassiveSkills.cachedIsGM = data.isGM or false
		-- Fresh data from server clears any unapplied pending allocations
		PassiveSkills.clearPendingAllocations()
		PassiveSkills.setupPoints()
		-- Update dev mode controls visibility based on server GM flag
		PassiveSkills.updateDevModeVisibility()
		-- Request the static tree data separately to avoid oversized packets
		PassiveSkills.sendOpcode({ topic = "tree-data-request" })
	elseif data.topic == "tree-data-reply" then
		PassiveSkills.cachedTreeData = data.treeData
		PassiveSkills.sendOpcode({ topic = "waypoint-data-request" })
	elseif data.topic == "waypoint-data-reply" then
		if PassiveSkills.cachedTreeData then
			PassiveSkills.cachedTreeData.waypointNodes = data.waypointNodes
		end
		PassiveSkills.cachedWaypointNodes = data.waypointNodes
		PassiveSkills.cachedRouteWaypoints = data.routeWaypoints
		PassiveSkills.setupTreeUI()
		-- Make sure the Apply button is visible in the talents tab
		if PassiveSkills.UI.ApplyButton then
			PassiveSkills.UI.ApplyButton:setVisible(true)
		end
	elseif data.topic == "progress-data-update" then
		local branchId = tonumber(data.branchId)
		local nodeId = tonumber(data.nodeId)
		local level = data.level
		if not PassiveSkills.cachedProgress[branchId] then
			PassiveSkills.cachedProgress[branchId] = {}
		end
		PassiveSkills.cachedProgress[branchId][nodeId] = level
		PassiveSkills.cachedAvailablePoints = data.availablePoints
		PassiveSkills.cachedTotalPoints = data.totalPoints
		PassiveSkills.setupTreeUI()
		PassiveSkills.setupPoints()
		--PassiveSkills.setupMessage("Success", string.format("%s in branch %d has been leveled up.", data.nodeName or "Node", branchId))
	elseif data.topic == "points-update" then
		PassiveSkills.cachedAvailablePoints = data.availablePoints
		PassiveSkills.cachedTotalPoints = data.totalPoints
		PassiveSkills.setupPoints()
	elseif data.topic == "message-reply" then
		PassiveSkills.setupMessage(tr(data.title), tr(data.message))
	elseif data.topic == "reset-requirements-reply" then
		PassiveSkills.handleResetRequirements(data)

	-- Paragon Board topics
	elseif data.topic == "paragon-data-reply" then
		PassiveSkills.paragonData = data
		PassiveSkills.buildAscensionUI()
		-- Update skills window Paragon display
		if modules.game_skills and modules.game_skills.updateParagonDisplay then
			modules.game_skills.updateParagonDisplay(data.paragonLevel or 0, data.paragonXP or 0, data.xpNeeded or 0, data.isActive or false)
		end
	elseif data.topic == "paragon-allocate-reply" then
		if not data.success then
			PassiveSkills.setupMessage(tr("Failed"), tr(data.message or "Could not allocate point."))
		end
		-- On success, server already sends paragon-data-reply via sendDataToClient
	elseif data.topic == "dev-save-reply" then
		if data.success then
			PassiveSkills.setupMessage(tr("Dev Mode"), tr("Positions and waypoints saved."))
			-- Request fresh tree data from server to reload with waypoints
			PassiveSkills.sendOpcode({ topic = "base-data-request" })
		else
			PassiveSkills.setupMessage(tr("Dev Mode Error"), tr(data.message or "Failed to save positions."))
		end
	end
end

function PassiveSkills.applyPendingAllocations()
	local allocs = PassiveSkills.pendingAllocations or {}
	if #allocs == 0 then
		return
	end
	-- Convert pending list to per-node count for the server
	local counts = {}
	for _, alloc in ipairs(allocs) do
		local key = alloc.branchId .. ":" .. alloc.nodeIndex
		local count = counts[key] or 0
		counts[key] = count + 1
	end
	-- Send an ordered list of single allocations (server applies one by one)
	local payload = {}
	for key, count in pairs(counts) do
		local branchId, nodeIndex = key:match("(%d+):(%d+)")
		branchId = tonumber(branchId)
		nodeIndex = tonumber(nodeIndex)
		for i = 1, count do
			table.insert(payload, {branchId = branchId, nodeId = nodeIndex})
		end
	end
	PassiveSkills.sendOpcode({
		topic = "apply-allocations",
		allocations = payload
	})
end

------ Dev Mode Functions (GM only)

function PassiveSkills.onDevModeToggle(checkbox, checked)
	PassiveSkills.devMode = checked
	if checked then
		PassiveSkills.setupMessage(tr("Dev Mode"), tr("Dev Mode enabled. Drag nodes to reposition. Grid snap is active. Click Save to persist."))
	else
		PassiveSkills.setupMessage(tr("Dev Mode"), tr("Dev Mode disabled."))
	end
	PassiveSkills.setupTreeUI()
end

function PassiveSkills.onDevSave()
	-- Collect waypoint data from nodesById
	local waypoints = {}
	local nodesById = PassiveSkills.devNodesById
	if nodesById then
		for id, nodeData in pairs(nodesById) do
			if nodeData.kind == "waypoint" then
				waypoints[tostring(id)] = {
					id = nodeData.id,
					pos = {x = nodeData.pos.x, y = nodeData.pos.y}
				}
			end
		end
	end
	-- Build a set of valid waypoint IDs
	local validWpIds = {}
	for id, _ in pairs(waypoints) do
		validWpIds[tonumber(id) or 0] = true
	end
	-- Collect routeWaypoints from all nodes (per-connection structure)
	-- Only include routeWaypoints that reference existing waypoints
	local routeWaypoints = {}
	if nodesById then
		for id, nodeData in pairs(nodesById) do
			if nodeData.routeWaypoints then
				local nodeRoutes = {}
				for connKey, wpList in pairs(nodeData.routeWaypoints) do
					local strList = {}
					for _, wpId in ipairs(wpList) do
						-- Only include if the waypoint exists
						if validWpIds[wpId] then
							table.insert(strList, tostring(wpId))
						end
					end
					if #strList > 0 then
						nodeRoutes[connKey] = strList
					end
				end
				if next(nodeRoutes) then
					routeWaypoints[tostring(id)] = nodeRoutes
				end
			end
		end
	end
	-- Convert positions to string keys to avoid sparse array
	local positions = {}
	for nodeId, pos in pairs(PassiveSkills.devNodePositions or {}) do
		positions[tostring(nodeId)] = {x = pos.x, y = pos.y}
	end

	-- Debug: count what we're sending
	local wpCount = 0
	for _ in pairs(waypoints) do wpCount = wpCount + 1 end
	local rwCount = 0
	for _ in pairs(routeWaypoints) do rwCount = rwCount + 1 end
	local posCount = 0
	for _ in pairs(positions) do posCount = posCount + 1 end
	print(string.format("[PassiveSkills] Dev Save: positions=%d, waypoints=%d, routeWaypoints=%d", posCount, wpCount, rwCount))

	PassiveSkills.sendOpcode({
		topic = "dev-save-positions",
		treeId = PassiveSkills.cachedTreeId,
		positions = positions,
		waypoints = waypoints,
		routeWaypoints = routeWaypoints
	})
end

function PassiveSkills.createDevGrid(panel, offsetX, offsetY, gridSpacingX, gridSpacingY, nodeSize)
	local grid = g_ui.createWidget("Panel", panel)
	grid:setId("devGridOverlay")
	grid:addAnchor(AnchorLeft, 'parent', AnchorLeft)
	grid:addAnchor(AnchorTop, 'parent', AnchorTop)
	grid:addAnchor(AnchorRight, 'parent', AnchorRight)
	grid:addAnchor(AnchorBottom, 'parent', AnchorBottom)
	grid:setPhantom(true)
	grid:setBackgroundColor('#00000000')
	local w = grid:getWidth()
	local h = grid:getHeight()
	-- Vertical lines: aligned to offsetX, step by gridSpacingX
	local gx = offsetX % gridSpacingX
	while gx < w do
		local vline = g_ui.createWidget("Panel", grid)
		vline:addAnchor(AnchorLeft, 'parent', AnchorLeft)
		vline:addAnchor(AnchorTop, 'parent', AnchorTop)
		vline:addAnchor(AnchorBottom, 'parent', AnchorBottom)
		vline:setMarginLeft(gx)
		vline:setMarginTop(0)
		vline:setMarginBottom(0)
		vline:setSize({width = 1, height = h})
		vline:setBackgroundColor('#ffffff18')
		vline:setPhantom(true)
		gx = gx + gridSpacingX
	end
	-- Horizontal lines: aligned to offsetY, step by gridSpacingY
	local gy = offsetY % gridSpacingY
	while gy < h do
		local hline = g_ui.createWidget("Panel", grid)
		hline:addAnchor(AnchorLeft, 'parent', AnchorLeft)
		hline:addAnchor(AnchorTop, 'parent', AnchorTop)
		hline:addAnchor(AnchorRight, 'parent', AnchorRight)
		hline:setMarginLeft(0)
		hline:setMarginTop(gy)
		hline:setMarginRight(0)
		hline:setSize({width = w, height = 1})
		hline:setBackgroundColor('#ffffff18')
		hline:setPhantom(true)
		gy = gy + gridSpacingY
	end
	return grid
end

function PassiveSkills.makeNodeDraggable(node, nodeData, panel, nodeSize, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodesById, progress, availablePoints, treeData)
	local dragging = false
	local dragStartMouseX, dragStartMouseY = 0, 0
	local dragStartNodeX, dragStartNodeY = 0, 0
	local gridSize = PassiveSkills.devGridSize or 58

	node.onMousePress = function(widget, mousePos, mouseButton)
		if mouseButton == MouseLeftButton and PassiveSkills.devMode then
			dragging = true
			dragStartMouseX = mousePos.x
			dragStartMouseY = mousePos.y
			dragStartNodeX = tonumber(node:getMarginLeft()) or 0
			dragStartNodeY = tonumber(node:getMarginTop()) or 0
			return true
		end
		return false
	end

	node.onMouseRelease = function(widget, mousePos, mouseButton)
		if mouseButton == MouseLeftButton and dragging then
			dragging = false
			-- Snap to grid: align node center to nearest grid intersection
			local curX = tonumber(node:getMarginLeft()) or 0
			local curY = tonumber(node:getMarginTop()) or 0
			-- Node center position
			local centerX = curX + math.floor(nodeSize / 2)
			local centerY = curY + math.floor(nodeSize / 2)
			-- Snap center to nearest grid cell (offsetX + N * gridSize)
			local snappedCenterX = math.floor((centerX - offsetX) / nodeSpacingX + 0.5) * nodeSpacingX + offsetX
			local snappedCenterY = math.floor((centerY - offsetY) / nodeSpacingY + 0.5) * nodeSpacingY + offsetY
			-- Convert back to margin (top-left corner)
			local snappedX = snappedCenterX - math.floor(nodeSize / 2)
			local snappedY = snappedCenterY - math.floor(nodeSize / 2)
			node:setMarginLeft(snappedX)
			node:setMarginTop(snappedY)
			-- Convert to grid coordinates and store
			local gridX = (snappedCenterX - offsetX) / nodeSpacingX
			local gridY = (snappedCenterY - offsetY) / nodeSpacingY
			PassiveSkills.devNodePositions[nodeData.id] = {x = gridX, y = gridY}
			-- Also update the nodeData pos so connections redraw correctly
			nodeData.pos = {x = gridX, y = gridY}
			-- Redraw all connections
			PassiveSkills.redrawConnections(panel, nodesById, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodeSize, progress, availablePoints, treeData)
			-- Update level label position
			if node.devLevelLabel then
				node.devLevelLabel:setMarginLeft(snappedX + nodeSize - 6)
				node.devLevelLabel:setMarginTop(snappedY + nodeSize - 8)
			end
			return true
		end
		return false
	end

	node.onMouseMove = function(widget, mousePos, mouseMoved)
		if dragging and PassiveSkills.devMode then
			local dx = mousePos.x - dragStartMouseX
			local dy = mousePos.y - dragStartMouseY
			local newX = dragStartNodeX + dx
			local newY = dragStartNodeY + dy
			node:setMarginLeft(newX)
			node:setMarginTop(newY)
			-- Live redraw connections while dragging (use node center for pos)
			local curX = tonumber(node:getMarginLeft()) or 0
			local curY = tonumber(node:getMarginTop()) or 0
			local centerX = curX + math.floor(nodeSize / 2)
			local centerY = curY + math.floor(nodeSize / 2)
			nodeData.pos = {x = (centerX - offsetX) / nodeSpacingX, y = (centerY - offsetY) / nodeSpacingY}
			PassiveSkills.redrawConnections(panel, nodesById, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodeSize, progress, availablePoints, treeData)
			return true
		end
		return false
	end
end

function PassiveSkills.redrawConnections(panel, nodesById, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodeSize, progress, availablePoints, treeData)
	-- Remove old connection lines (and waypoints, but not the one being dragged)
	local children = panel:getChildren()
	for _, child in ipairs(children) do
		local cid = child:getId() or ""
		if string.find(cid, "^connLine_") then
			child:destroy()
		elseif string.find(cid, "^waypoint_") and not PassiveSkills.draggingWaypointId then
			child:destroy()
		end
	end
	-- Redraw all connections and waypoints
	local drawnConnections = {}
	for _, fromNode in pairs(nodesById) do
		-- Skip waypoint nodes (they don't have their own connections)
		if fromNode.kind ~= "waypoint" then
		for _, connId in ipairs(fromNode.connections or {}) do
			local toNode = nodesById[connId]
			if toNode then
				local minId = math.min(fromNode.id, toNode.id)
				local maxId = math.max(fromNode.id, toNode.id)
				local connKey = minId .. "-" .. maxId
				if not drawnConnections[connKey] then
					drawnConnections[connKey] = true
					-- Node centers are at offsetX + pos.x * nodeSpacingX
					local cx1 = offsetX + fromNode.pos.x * nodeSpacingX
					local cy1 = offsetY + fromNode.pos.y * nodeSpacingY
					local cx2 = offsetX + toNode.pos.x * nodeSpacingX
					local cy2 = offsetY + toNode.pos.y * nodeSpacingY

					local state1 = PassiveSkills.getConstellationNodeState(treeData, progress, fromNode, availablePoints)
					local state2 = PassiveSkills.getConstellationNodeState(treeData, progress, toNode, availablePoints)
					local color = '#3a3045'
					if (state1 == "unlocked" or state1 == "maxed") and (state2 == "unlocked" or state2 == "maxed") then
						color = '#f4ca16'
					elseif (state1 == "available" or state1 == "unlocked" or state1 == "maxed") and (state2 == "available") then
						color = '#7a7090'
					end
					local route = PassiveSkills.calculateRoute(fromNode, toNode, nodesById)
					local connInfo = {
						fromId = fromNode.id,
						toId = toNode.id,
						fromNode = fromNode,
						toNode = toNode,
						connKey = connKey
					}
					local prevX, prevY = cx1, cy1
					for _, wpId in ipairs(route) do
						local wpNode = nodesById[wpId]
						if wpNode then
							local wpx = offsetX + wpNode.pos.x * nodeSpacingX
							local wpy = offsetY + wpNode.pos.y * nodeSpacingY
							local segInfo = {
								fromId = fromNode.id,
								toId = toNode.id,
								fromNode = fromNode,
								toNode = toNode,
								connKey = connKey
							}
							local segLine = PassiveSkills.drawConnectionLine(panel, prevX, prevY, wpx, wpy, color, segInfo)
							if segLine then
								segLine:setId("connLine_" .. connKey .. "_" .. wpId)
							end
							prevX, prevY = wpx, wpy
						end
					end
					local line = PassiveSkills.drawConnectionLine(panel, prevX, prevY, cx2, cy2, color, connInfo)
					if line then
						line:setId("connLine_" .. connKey)
					end
					-- Draw waypoints for this connection
					for _, wpId in ipairs(route) do
						local wpNode = nodesById[wpId]
						if wpNode then
							PassiveSkills.drawWaypointNode(panel, wpNode, offsetX, offsetY, nodeSpacingX, nodeSpacingY, nodeSize, connInfo)
						end
					end
				end
			end
		end
		end  -- end if fromNode.kind ~= "waypoint"
	end
end