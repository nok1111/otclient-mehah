
------ Constants & Global Variables

DUNGEON_OPCODE = 109
Dungeons = {}

Dungeons.cache = {}
Dungeons.runsCache ={}
Dungeons.timeLeft = 0


------ Configuration & Data Tables

Dungeons.lootChanceThresholds = {
	[1] = 80,
	[2] = 60,
	[3] = 40,
	[4] = 20,
	[5] = 10,
	[6] = 0
}

Dungeons.difficultyConfig = {
	[1] = {name = "Normal", health = 100, damage = 100},
	[2] = {name = "Hard", health = 120, damage = 120, exp = 80, gold = 80},
	[3] = {name = "Expert", health = 140, damage = 140, exp = 100, gold = 100, loot = 10},
	[4] = {name = "Master", health = 160, damage = 160, exp = 120, gold = 120, loot = 20},
	[5] = {name = "Torment", health = 180, damage = 180, exp = 140, gold = 140, loot = 30},
	[6] = {name = "Hell", health = 200, damage = 200, exp = 160, gold = 160, loot = 40},
}

Dungeons.attributeIcons = {
	health = 27,
	damage = 12,
	exp = 17,
	gold = 15,
	loot = 16,
}

Dungeons.vocationalIcons = {
	[0] = 64,
	[1] = 31, -- Sorcerer
	[2] = 34, -- Druid
	[3] = 9, -- Paladin
	[4] = 1, -- Knight
	[5] = 35, -- Master Sorcerer
	[6] = 41, -- Elder Druid
	[7] = 22, -- Royal Paladin
	[8] = 4, -- Elite Knight
}

Dungeons.vocationNames = {
	[0] = "None",
	[1] = "Sorcerer",
	[2] = "Druid",
	[3] = "Paladin",
	[4] = "Knight",
	[5] = "Master Sorcerer",
	[6] = "Elder Druid",
	[7] = "Royal Paladin",
	[8] = "Elite Knight"
}

Dungeons.IconsConfig = {
	maxIconsInLine = 8,
	iconSize = 19,
}


------ Lifecycle Methods

function Dungeons.init()
	connect(
		g_game,
		{
			onGameStart = Dungeons.create,
			onGameEnd = Dungeons.destroy
		}
	)

	ProtocolGame.registerExtendedOpcode(DUNGEON_OPCODE, Dungeons.onExtendedOpcode)

	if g_game.isOnline() then
		Dungeons.create()
	end
end

function Dungeons.terminate()
	disconnect(
		g_game,
		{
			onGameStart = Dungeons.create,
			onGameEnd = Dungeons.destroy
		}
	)

	ProtocolGame.unregisterExtendedOpcode(DUNGEON_OPCODE, Dungeons.onExtendedOpcode)

	Dungeons.destroy()
end

function Dungeons.create()
	if Dungeons.UI then
		return
	end
	Dungeons.UI = g_ui.displayUI("dungeons")
	Dungeons.UI:hide()

	Dungeons.killCounter = g_ui.loadUI("killcounter", modules.game_interface.getMapPanel())
	Dungeons.killCounter:hide()

	Dungeons.difficultyTooltip = g_ui.displayUI("difficultyTooltip")
	Dungeons.difficultyTooltip:hide()

	Dungeons.challengeNotifi = g_ui.loadUI("challenge", modules.game_interface.getMapPanel())
	g_effects.fadeOut(Dungeons.challengeNotifi, 1)

	Dungeons.registerDiffculityButtons()
	Dungeons.generateLootTooltip()

	Dungeons.UI:recursiveGetChildById("closeButton").onClick = function()
		Dungeons.hide()
	end

	Dungeons.UI:recursiveGetChildById("queueButton").onClick = function()
		Dungeons.joinQueue()
	end

	Dungeons.UI:recursiveGetChildById("leaderboardButton").onClick = function()
		Dungeons.sendOpcode({topic = "requestLeaderboard", data = {id = Dungeons.selectedDungeonId, difficulty = Dungeons.selectedDungeonDifficulty}})
		Dungeons.UI.leaderboardPanel.diffculityLabel:setText("Difficulty Tier: " .. Dungeons.difficultyConfig[Dungeons.selectedDungeonDifficulty].name)
		Dungeons.UI.leaderboardPanel:setVisible(true)
	end

	Dungeons.UI.leaderboardPanel.onClick = function()
		Dungeons.UI.leaderboardPanel:setVisible(false)
	end

	for i = 1, 6 do
		local dungeonDifficultyButton = Dungeons.UI:recursiveGetChildById("difficulty" .. i)
		dungeonDifficultyButton.onHoverChange = Dungeons.onHoverChange
	end

	Dungeons.setIconImageType(Dungeons.UI.bottomPanel.challengePoints.challengePointsIcon, 62)
end

function Dungeons.destroy()
	if Dungeons.UI then
		Dungeons.UI:destroy()
		Dungeons.UI = nil
	end

	if Dungeons.difficultyTooltip then
		Dungeons.difficultyTooltip:destroy()
		Dungeons.difficultyTooltip = nil
	end

	if Dungeons.killCounter then
		Dungeons.killCounter:destroy()
		Dungeons.killCounter = nil
	end

	if Dungeons.challengeNotifi then
		Dungeons.challengeNotifi:destroy()
		Dungeons.challengeNotifi = nil
	end
end


------ UI Setup & Management

function Dungeons.registerDiffculityButtons()
	local difficultiesButtons = {}
	for i = 1, 6 do
		difficultiesButtons[i] = Dungeons.UI:recursiveGetChildById("difficulty" .. i)
		if not difficultiesButtons[i] then
			return
		end
	end
	local function onButtonClick(clickedIndex)
		g_sounds.getChannel(SoundChannels.Effect):play("sounds/click.ogg", 0, 1)
		for i = 1, 6 do
			if i == clickedIndex then
				difficultiesButtons[i]:setChecked(true)
				Dungeons.selectedDungeonDifficulty = i
			else
				difficultiesButtons[i]:setChecked(false)
			end
		end
	end
	for i = 1, 6 do
		difficultiesButtons[i].onClick = function()
			onButtonClick(i)
		end
	end
end

function Dungeons.show()
	if not Dungeons.UI then
		return
	end
	Dungeons.UI:show()
	Dungeons.UI:raise()
	Dungeons.UI:focus()

	Dungeons.selectedDungeonId = 0

	for i = 2, 6 do
		local dungeonDifficultyButton = Dungeons.UI:recursiveGetChildById("difficulty" .. i)
		dungeonDifficultyButton:setChecked(false)
	end

	Dungeons.selectedDungeonDifficulty = 1
	Dungeons.UI:recursiveGetChildById("difficulty1"):setChecked(true)
end

function Dungeons.hide()
	if not Dungeons.UI then
		return
	end
	Dungeons.UI:hide()
end


------ Tooltip Handling

function Dungeons.moveToolTip()
	if not Dungeons.difficultyTooltip or not Dungeons.difficultyTooltip:isVisible() then
		return
	end

	local pos = g_window.getMousePosition()
	local windowSize = g_window.getSize()
	local tipSize = Dungeons.difficultyTooltip:getSize()

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

	Dungeons.difficultyTooltip:setPosition(pos)
	Dungeons.difficultyTooltip:raise()
end

function Dungeons.applyTooltip(difficultyLevel)
	Dungeons.moveToolTip()
	local config = Dungeons.difficultyConfig[difficultyLevel]
	if not config then
		return
	end

	local tooltip = Dungeons.difficultyTooltip
	for attribute, value in pairs(Dungeons.attributeIcons) do
		local iconWidget = tooltip:getChildById(attribute .. "Icon")
		local labelWidget = tooltip:getChildById(attribute .. "Label")

		if config[attribute] then
			local formattedText
			if attribute == "health" or attribute == "damage" then
				formattedText = string.format("Monster %s %d%%", attribute:gsub("^%l", string.upper), config[attribute])
			else
				formattedText = string.format("%s +%d%%", attribute == "exp" and "Bonus XP" or attribute == "gold" and "Gold Drop" or "Loot Chance", config[attribute])
			end

			Dungeons.setIconImageType(iconWidget, value)
			labelWidget:setText(formattedText)
			iconWidget:setVisible(true)
			labelWidget:setVisible(true)
		else
			iconWidget:setVisible(false)
			labelWidget:setVisible(false)
		end
	end

	tooltip:setText(config.name)

	local totalHeight = 25
	for _, attribute in pairs({"health", "damage", "exp", "gold", "loot"}) do
		if config[attribute] then
			totalHeight = totalHeight + 16
		end
	end
	tooltip:setHeight(totalHeight)
end

function Dungeons.onHoverChange(widget, hovered)
	if hovered then
		local difficultyLevel = widget:getId():gsub("difficulty", "")
		if difficultyLevel then
			Dungeons.applyTooltip(tonumber(difficultyLevel))
			Dungeons.difficultyTooltip:show()
			connect(rootWidget, { onMouseMove = Dungeons.moveToolTip })
		end
	else
		Dungeons.difficultyTooltip:hide()
		disconnect(rootWidget, { onMouseMove = Dungeons.moveToolTip })
	end
end

function Dungeons.generateLootTooltip()
	local tooltipLines = {}
	for difficulty, threshold in ipairs(Dungeons.lootChanceThresholds) do
		local line
		if difficulty == 1 then
			line = string.format("Difficulty level %d: Default - You can view items with %d%% chance drop rate or higher", difficulty, threshold)
		elseif difficulty == #Dungeons.lootChanceThresholds then
			line = string.format("Difficulty level %d unlocked: You can view all droppable items", difficulty)
		else
			line = string.format("Difficulty level %d unlocked: You can view items with %d%% chance drop rate or higher", difficulty, threshold)
		end
		table.insert(tooltipLines, line)
	end

	local tooltipMessage = table.concat(tooltipLines, "\n")

	if Dungeons.UI and Dungeons.UI.lootTooltip then
		Dungeons.UI.lootTooltip:setTooltip(tooltipMessage)
	end
end


------ Extended Opcode Handling

function Dungeons.onExtendedOpcode(protocol, code, buffer)
	if not g_game.isOnline() then
		return
	end
	local json_status, json_data =
		pcall(
		function()
			return json.decode(buffer)
		end
	)

	if not json_status then
		g_logger.error("[Dungeons] JSON error: " .. json_data)
		return false
	end

	local topic = json_data.topic
	local data = json_data.data
	if topic == "dungeonData" then
		Dungeons.onDungeonData(data)
		Dungeons.selectedDungeonId = data.id
	elseif topic == "dungeonBaseData-reply" then
		Dungeons.cache[data.title] = data
		Dungeons.updateLootPanel(data.title, data.difficulty)
		Dungeons.onDungeonBaseData(data)
	elseif topic == "partyListUpdate" then
		Dungeons.updatePartyList(data)
	elseif topic == "queue" then
		Dungeons.onDungeonQueue(data)
	elseif topic == "stopQueue" then
		Dungeons.onStopQueue()
	elseif topic == "prepare" then
		Dungeons.onDungeonPrepare()
	elseif topic == "queueUpdate" then
		Dungeons.onDungeonQueueUpdate(data)
	elseif topic == "start" then
		Dungeons.onDungeonStart(data)
	elseif topic == "finish" then
		Dungeons.onDungeonFinish(data)
	elseif topic == "objective" then
		Dungeons.onDungeonObjective(data)
	elseif topic == "killed" then
		Dungeons.onDungeonKilled(data)
	elseif topic == "challenge" then
		Dungeons.onChallengeCompleted(data)
	elseif topic == "solo" then
		Dungeons.buildLeaderboardSolo(data)
	elseif topic == "group" then
		Dungeons.buildLeaderboardGroup(data)
	elseif topic == "closeWindow" then
		Dungeons.hide()
	end
end

function Dungeons.sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()
	if protocolGame then
		protocolGame:sendExtendedJSONOpcode(DUNGEON_OPCODE, data)
	end
end


------ Dungeon Data Response & Updating

function Dungeons.onDungeonData(data)
	Dungeons.show()
	Dungeons.UI.bottomPanel.challengePoints:setText(data.challengePoints)

	Dungeons.UI:recursiveGetChildById("dungeonName"):setText(data.title)
	Dungeons.UI:recursiveGetChildById("banner"):setImageSource("/images/dungeons/" .. data.title)

	-- Queue
	local queuePlayers = data.queue.players
	local queueStatusWidget = Dungeons.UI:recursiveGetChildById("queueStatus")
	queueStatusWidget:setText(queuePlayers == 0 and "Open" or queuePlayers .. " Player(s)")
	if queuePlayers >= 6 then
		queueStatusWidget:setColor("red")
	elseif queuePlayers >= 3 then
		queueStatusWidget:setColor("orange")
	else
		queueStatusWidget:setColor("green")
	end

	local queueButton = Dungeons.UI:recursiveGetChildById("queueButton")
	if not data.queue.playerStatus then 
		queueButton:setText("Join")
	else
		queueButton:setText("Leave Queue")
	end

	-- Recall base data from cache
	if not Dungeons.cache[data.title] then
		Dungeons.sendOpcode({topic = "dungeonBaseData-request", data = {dungeonName = data.title}})
	else
		Dungeons.onDungeonBaseData(Dungeons.cache[data.title])
		Dungeons.updateLootPanel(data.title, data.difficulty)
	end

	-- Challenges Panel
	local challengesPanel = Dungeons.UI:recursiveGetChildById("challenges")
	challengesPanel:destroyChildren()
	if not data.challenges then
		Dungeons.UI:recursiveGetChildById("noChallangesPanel"):setVisible(true)
	else
		Dungeons.UI:recursiveGetChildById("noChallangesPanel"):setVisible(false)
		for i = 1, #data.challenges do
			local challenge = data.challenges[i]
			local widget = g_ui.createWidget("ChallengePanel", challengesPanel)
			widget:setText(challenge.title)
			widget:getChildById("checkbox"):setChecked(challenge.completed)
			widget:getChildById("description"):setText("(" .. challenge.points .. " points)\n" .. challenge.desc)
			widget:setHeight(widget:getChildById("description"):getHeight()+28)
		end
	end

	-- Party Panel
	local partyPanel = Dungeons.UI:recursiveGetChildById("party")
	partyPanel:destroyChildren()
	if not data.party or (not data.party.leader and #data.party.members == 0) then
		Dungeons.UI:recursiveGetChildById("noPartyPanel"):setVisible(true)
	else
		Dungeons.UI:recursiveGetChildById("noPartyPanel"):setVisible(false)
		if data.party.leader then
			local leaderWidget = g_ui.createWidget("PartyEntry", partyPanel)
			leaderWidget.PlayerName:parseColoredText("[color=#ffed2b]" .. data.party.leader.name .. "[/color]")
			leaderWidget.PlayerLevel:parseColoredText("Lvl: " .. data.party.leader.level)
			leaderWidget.PlayerName:setTooltip("Party Leader")
			local vocationIconId = Dungeons.vocationalIcons[data.party.leader.vocation]
			if vocationIconId then
				Dungeons.setIconImageType(leaderWidget.VocationalIcon, vocationIconId)

				leaderWidget.VocationalIcon:setTooltip("Vocation: " .. Dungeons.vocationNames[data.party.leader.vocation])
			end
		end
		for _, member in ipairs(data.party.members) do
			local widget = g_ui.createWidget("PartyEntry", partyPanel)
			widget.PlayerName:setText(member.name)
			widget.PlayerLevel:setText("Lvl: " .. member.level)
			local vocationIconId = Dungeons.vocationalIcons[member.vocation]
			if vocationIconId then
				Dungeons.setIconImageType(widget.VocationalIcon, vocationIconId)

				widget.VocationalIcon:setTooltip("Vocation: " .. Dungeons.vocationNames[member.vocation])
			end
		end
	end

	-- Difficulties locking
	for i = 1, 6 do
		local lockWidget = Dungeons.UI:recursiveGetChildById("difficulty" .. i .. "Lock")
		if lockWidget then
			lockWidget:setVisible(data.difficulty < i)
		end
	end
end

function Dungeons.onDungeonBaseData(data)
	Dungeons.UI:recursiveGetChildById("levelRequirement"):setText(data.req.level .. "+")
	Dungeons.UI:recursiveGetChildById("partyRequirement"):setText(data.req.party)
	Dungeons.UI:recursiveGetChildById("goldRequirement"):setText(Dungeons.comma_value(data.req.gold))

	if not data.req.quests then
		Dungeons.UI:recursiveGetChildById("noQuestsPanel"):setVisible(true)
		Dungeons.UI:recursiveGetChildById("questsRequirement"):setText("")
	else
		Dungeons.UI:recursiveGetChildById("noQuestsPanel"):setVisible(false)
		local txt = ""
		for i = 1, #data.req.quests do
			txt = txt .. data.req.quests[i]
			if i > 1 and i == #data.req.quests then
				txt = txt .. "."
			elseif #data.req.quests > 1 then
				txt = txt .. ", "
			end
		end
		Dungeons.UI:recursiveGetChildById("questsRequirement"):setText(txt)
	end

	local maxSlots = 6
	local hasItems = data.req.items and #data.req.items > 0
	Dungeons.UI:recursiveGetChildById("noItemsPanel"):setVisible(not hasItems)
	for i = 1, maxSlots do
		local slot = Dungeons.UI:recursiveGetChildById("itemRequirement" .. i)
		if slot then
			slot:setItemId(0)
		end
	end
	if hasItems then
		local maxItems = math.min(#data.req.items, maxSlots)
		for i = 1, maxItems do
			local slot = Dungeons.UI:recursiveGetChildById("itemRequirement" .. i)
			local reqItem = data.req.items[i]
			slot:setItemId(reqItem.clientId)
			slot:setItemCount(reqItem.count)
			slot:setVisible(true)
		end
	end

	-- Monsters Panel
	local monstersPanel = Dungeons.UI:recursiveGetChildById("monsters")
	monstersPanel:destroyChildren()
	if data.bossName and data.bossOutfit then
		local bossWidget = g_ui.createWidget("MonsterEntry", monstersPanel)
		bossWidget.creature:setOutfit(data.bossOutfit)
		bossWidget.name:parseColoredText("[color=#ffed2b]" .. data.bossName .. "[/color]")
		bossWidget.name:setTooltip("Dungeon Boss")
	end

	if data.monsters and #data.monsters > 0 then
		for _, monster in ipairs(data.monsters) do
			local monsterWidget = g_ui.createWidget("MonsterEntry", monstersPanel)
			monsterWidget.creature:setOutfit(monster.outfit)
			monsterWidget.name:setText(monster.name)
			monsterWidget.name:setTooltip(monster.name)
		end
	end
end

function Dungeons.updatePartyList(data)
	-- Party Panel
	if Dungeons.UI then
	local partyPanel = Dungeons.UI:recursiveGetChildById("party")
	partyPanel:destroyChildren()

		Dungeons.UI:recursiveGetChildById("noPartyPanel"):setVisible(false)
		if data.party.leader then
			local leaderWidget = g_ui.createWidget("PartyEntry", partyPanel)
			leaderWidget.PlayerName:parseColoredText("[color=#ffed2b]" .. data.party.leader.name .. "[/color]")
			leaderWidget.PlayerLevel:parseColoredText("Lvl: " .. data.party.leader.level)
			leaderWidget.PlayerName:setTooltip("Party Leader")
			local vocationIconId = Dungeons.vocationalIcons[data.party.leader.vocation]
			if vocationIconId then
				Dungeons.setIconImageType(leaderWidget.VocationalIcon, vocationIconId)

				leaderWidget.VocationalIcon:setTooltip("Vocation: " .. Dungeons.vocationNames[data.party.leader.vocation])
			end
		end
		if data.party.members then
			for _, member in ipairs(data.party.members) do
				local widget = g_ui.createWidget("PartyEntry", partyPanel)
				widget.PlayerName:setText(member.name)
				widget.PlayerLevel:setText("Lvl: " .. member.level)
				local vocationIconId = Dungeons.vocationalIcons[member.vocation]
				if vocationIconId then
					Dungeons.setIconImageType(widget.VocationalIcon, vocationIconId)

					widget.VocationalIcon:setTooltip("Vocation: " .. Dungeons.vocationNames[member.vocation])
				end
			end
		end

		if not data.party.members and not data.party.leader then
			Dungeons.UI:recursiveGetChildById("noPartyPanel"):setVisible(true)
		end
	end
end

function Dungeons.updateLootPanel(dungeonTitle, unlockedDifficulties)
	local cachedData = Dungeons.cache[dungeonTitle]
	if not cachedData or not cachedData.loot then
		return
	end

	local lootPanel = Dungeons.UI:recursiveGetChildById("loot")
	lootPanel:destroyChildren()

	local lastDifficulty = unlockedDifficulties or 1
	local minChance = Dungeons.lootChanceThresholds[lastDifficulty] or 0

	for _, loot in ipairs(cachedData.loot) do
		local widget
		if loot.chance >= minChance then
			widget = g_ui.createWidget("LootItemEntry", lootPanel)
			widget.itemPanel.item:setItemId(loot.clientId)
			widget.itemPanel.item:setItemCount(loot.count)
			widget.chance:setText(loot.chance .. "%")
		else
			widget = g_ui.createWidget("UIWidget", lootPanel)
			widget:setImageSource("question_mark")
			widget:setBorderWidth(1)
		end
	end
end


------ Queue Handling

function Dungeons.joinQueue()
	Dungeons.sendOpcode({topic = "queue", data = {id = Dungeons.selectedDungeonId, difficulty = Dungeons.selectedDungeonDifficulty}})
	g_sounds.getChannel(SoundChannels.Effect):play("sounds/click.ogg", 0, 1)
end

function Dungeons.leaveQueue()
	Dungeons.sendOpcode({topic = "leaveQueue"})
end

function Dungeons.onDungeonQueueUpdate(data)
	if Dungeons.selectedDungeonId == data.id then
		local queue = Dungeons.UI:recursiveGetChildById("queueStatus")
		local queuePlayers = data.queue
		local queueStatus = Dungeons.UI:recursiveGetChildById("queueStatus")
		queueStatus:setText(queuePlayers == 0 and "Open" or queuePlayers .. " Player(s)")
		if queuePlayers >= 6 then
			queueStatus:setColor("red")
		elseif queuePlayers >= 3 then
			queueStatus:setColor("orange")
		else
			queueStatus:setColor("green")
		end
	end
end

function Dungeons.onStopQueue()
	local queueButton = Dungeons.UI:recursiveGetChildById("queueButton")
	queueButton:setText("Join")
end

function Dungeons.onDungeonQueue(data)
	local queueButton = Dungeons.UI:recursiveGetChildById("queueButton")
	if data.joined then
		queueButton:setText("Leave Queue")
	else
		queueButton:setText("Join")
	end
end

function Dungeons.onDungeonPrepare()
	addEvent(function() Dungeons.onStopQueue() end, 100)
	if Dungeons.UI:isVisible() then
		Dungeons.hide()
	end
end


------ Dungeon Flow (Start, Objectives, Finish)

function Dungeons.onDungeonStart(data)
	if Dungeons.UI:isVisible() then
		Dungeons.hide()
	end
	local queueButton = Dungeons.UI:recursiveGetChildById("queueButton")
	queueButton:setText("Join")
	Dungeons.killCounter:show()

	local bonusObjectives = Dungeons.killCounter:getChildById("bonusObjectives")
	for i = bonusObjectives:getChildCount(), 2, -1 do
		bonusObjectives:getChildByIndex(i):destroy()
	end
	if data.objectives then
		local h = 16
		for _, obj in ipairs(data.objectives) do
			local w = g_ui.createWidget("ObjectiveCheckBox", bonusObjectives)
			w:addAnchor(AnchorTop, "prev", AnchorBottom)
			w:setMarginTop(5)
			w:setText(obj)
			h = h + 25
		end
		bonusObjectives:setHeight(h)
		bonusObjectives:setMarginTop(5)
		Dungeons.killCounter:setHeight(170 + h)
	else
		bonusObjectives:setHeight(0)
		bonusObjectives:setMarginTop(0)
		Dungeons.killCounter:setHeight(170)
	end

	local bar = Dungeons.killCounter:getChildById("bar")
	bar:setVisible(false)

	Dungeons.killCounter:getChildById("label"):setText("0%")
	local mainObjective = Dungeons.killCounter:getChildById("mainObjective")
	mainObjective:setText("Kill monsters to spawn " .. data.boss)
	mainObjective:setChecked(false)
	local bossObjective = Dungeons.killCounter:getChildById("bossObjective")
	bossObjective:setText("Kill " .. data.boss)
	bossObjective:setEnabled(false)
	bossObjective:setChecked(false)
	Dungeons.killCounter:getChildById("monstersLeft"):setText("Monsters Remaining:  " .. data.left)
	Dungeons.killCounter:getChildById("timeLeft"):setText("Time Left:  " .. Dungeons.MsToShortTime(data.duration))

	Dungeons.timeLeft = data.duration
	timeLeftEvent = scheduleEvent(Dungeons.doTimeLeft, 100)
end

function Dungeons.onDungeonObjective(data)
	local bonusObjectives = Dungeons.killCounter:getChildById("bonusObjectives")
	local objWidget = bonusObjectives:getChildByIndex(data.id + 1)
	objWidget:setChecked(data.finished)
end

function Dungeons.onDungeonKilled(data)
	local bar = Dungeons.killCounter:getChildById("bar")
	local bossObjective = Dungeons.killCounter:getChildById("bossObjective")
	bar:setVisible(true)
	if data.percent then
		local percent = math.min(100, data.percent)
		local maxWidth = 260
		local maxHeight = 50
		local newWidth = maxWidth * (percent / 100)
		local newHeight = maxHeight
		bar:setWidth(newWidth)
		bar:setHeight(newHeight)
		Dungeons.killCounter:getChildById("label"):setText(math.min(100, data.percent) .. "%")
		if data.percent >= 100 then
			Dungeons.killCounter:getChildById("mainObjective"):setChecked(true)
			bossObjective:setEnabled(true)
			local textWidget = Dungeons.challengeNotifi:getChildById("text")
			textWidget:setText("You can kill the boss now!")
			Dungeons.challengeNotifi:setWidth(math.max(263, 96 + textWidget:getTextSize().width))
			g_effects.fadeIn(Dungeons.challengeNotifi, 250)
			scheduleEvent(
				function()
					if Dungeons.challengeNotifi then
						g_effects.fadeOut(Dungeons.challengeNotifi, 250)
					end
				end,
				3000
			)
		end
	elseif data.boss then
		bossObjective:setChecked(true)
		local textWidget = Dungeons.challengeNotifi:getChildById("text")
		textWidget:setText("You completed the dungeon!")
		Dungeons.challengeNotifi:setWidth(math.max(263, 96 + textWidget:getTextSize().width))
		g_effects.fadeIn(Dungeons.challengeNotifi, 250)
		scheduleEvent(
			function()
				if Dungeons.challengeNotifi then
					g_effects.fadeOut(Dungeons.challengeNotifi, 250)
				end
			end,
			3000
		)
	end
	if data.left then
		Dungeons.killCounter:getChildById("monstersLeft"):setText("Monsters Alive: " .. data.left)
	end
end

function Dungeons.onDungeonFinish(data)
	Dungeons.killCounter:hide()
	if timeLeftEvent then
		removeEvent(timeLeftEvent)
	end
end

function Dungeons.doTimeLeft()
	Dungeons.timeLeft = Dungeons.timeLeft - 100
	if Dungeons.killCounter then Dungeons.killCounter:getChildById("timeLeft"):setText("Time Left: " .. Dungeons.MsToShortTime(Dungeons.timeLeft)) end
	if Dungeons.timeLeft > 0 then
		timeLeftEvent = scheduleEvent(Dungeons.doTimeLeft, 100)
	end
end

function Dungeons.onChallengeCompleted(data)
	local textWidget = Dungeons.challengeNotifi:getChildById("text")
	textWidget:setText(data .. " challenge completed!")
	Dungeons.challengeNotifi:setWidth(math.max(263, 96 + textWidget:getTextSize().width))
	g_effects.fadeIn(Dungeons.challengeNotifi, 250)
	scheduleEvent(
		function()
			if Dungeons.challengeNotifi then
				g_effects.fadeOut(Dungeons.challengeNotifi, 250)
			end
		end,
		3000
	)
end


------ Leaderboard Building

function Dungeons.buildLeaderboardSolo(data)
	local runners = data.top
	local soloTable = Dungeons.UI:recursiveGetChildById("soloTable")
	soloTable:clearData()

	for i = 1, #runners do
		local runner = runners[i]

		local custom = {}
		if runner.self then
			custom.backgroundColor = "#2daadb"
		end

		soloTable:addRow(
			{
				{text = runner.self or i},
				{text = runner.name},
				{text = Dungeons.MsToShortTime(runner.time)}
			},
			nil,
			custom
		)

	end
end

function Dungeons.buildLeaderboardGroup(data)
	local runners = data.top
	local groupTable = Dungeons.UI:recursiveGetChildById("groupTable")
	groupTable:clearData()

	for i = 1, #runners do
		local group = runners[i]
		local names = select(2, string.gsub(group.name, "\n", ""))
		local height = names * 21
		if names == 1 then
			height = height + 8
		end

		local custom = {}
		if group.self then
			custom.backgroundColor = "#2daadb"
		end

		groupTable:addRow(
			{
				{text = group.self or i},
				{text = group.name},
				{text = Dungeons.MsToShortTime(group.time)}
			},
			height,
			custom
		)
	end
end


------ Utility & Helper Functions

function Dungeons.getImageClip(id)
	if not id then
		return "0 0 " .. Dungeons.IconsConfig.iconSize .. " " .. Dungeons.IconsConfig.iconSize
	end
	
	return (((id - 1) % Dungeons.IconsConfig.maxIconsInLine) * Dungeons.IconsConfig.iconSize) .. " " .. ((math.ceil(id / Dungeons.IconsConfig.maxIconsInLine) - 1)*Dungeons.IconsConfig.iconSize) .. " " .. Dungeons.IconsConfig.iconSize .. " " .. Dungeons.IconsConfig.iconSize
end

function Dungeons.setIconImageType(widget, id)
	if not id then
		return false
	end
	
	widget:setImageClip(Dungeons.getImageClip(id))
end

function Dungeons.comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1.%2")
		if (k == 0) then
			break
		end
	end
	return formatted
end

function Dungeons.SecondsToShortTime(seconds)
	if seconds <= 0 then
		return "00:00:00"
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))
		return hours .. ":" .. mins .. ":" .. secs
	end
end

function Dungeons.MsToShortTime(ms)
	if ms <= 0 then
		return "00:00.000"
	else
		local mins = string.format("%02.f", math.floor(ms / 1000 / 60))
		local secs = string.format("%02.f", math.floor(ms / 1000 % 60))
		local millis = string.format("%d", (ms % 1000) / 100)
		return mins .. ":" .. secs .. "." .. millis
	end
end