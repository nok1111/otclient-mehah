
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

-- Tooltip values mirror the server-side scaling. Keep in sync with:
--   src/const.h: DifficultyLife / DifficultyDamage / DifficultyXP
--   data/scripts/dungeons/dungeons.lua: Dungeons.difficultyBonuses
-- health/damage are displayed as "Monster Health/Damage %d%%" (multiplier as %).
-- exp/reward are displayed as "+%d%%" (bonus over base loot amount / xp).
-- fame is displayed as a flat amount.
Dungeons.difficultyConfig = {
	[1] = {name = "Normal",  health = 100, damage = 100},
	[2] = {name = "Dificil",    health = 130, damage = 115, exp = 40,  reward = 25,  fame = 5},
	[3] = {name = "Experto",  health = 170, damage = 132, exp = 90,  reward = 55,  fame = 10},
	[4] = {name = "Maestro",  health = 220, damage = 152, exp = 150, reward = 100, fame = 20},
	[5] = {name = "Tormento", health = 285, damage = 175, exp = 220, reward = 160, fame = 35},
	[6] = {name = "Infierno",    health = 370, damage = 200, exp = 300, reward = 230, fame = 60},
}

-- Numeric values are indexes into the dungeons icon sprite-sheet.
-- "fame" is special-cased: it uses its own image-source from the OTUI.
Dungeons.attributeIcons = {
	health = 27,
	damage = 12,
	exp = 17,
	reward = 15,
	fame = "image",
}

Dungeons.vocationalIcons = {
	[0] = 64,
	[1] = 32, -- Sorcerer
	[2] = 16, -- Templar
	[3] = 11, -- Nightblade
	[4] = 19, -- Dragon Knight
	[5] = 35, -- Warlock
	[6] = 50, -- Stellar
	[7] = 28, -- Monk
	[8] = 34, -- Druid
	[9] = 31, -- Light Dancer
	[10] = 9, -- Archer
}

Dungeons.vocationNames = {
	[0] = "Ninguno",
	[1] = "Mago",
	[2] = "Templario",
	[3] = "Nightblade",
	[4] = "Caballero Dragon",
	[5] = "Brujo",
	[6] = "Stellar",
	[7] = "Monje",
	[8] = "Druida",
	[9] = "Light Dancer",
	[10] = "Arquero",

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
	
	Keybind.new("Dungeons", tr("Dungeons List"), "Ctrl+Shift+D", "")
	Keybind.bind("Dungeons", tr("Dungeons List"), {{type = KEY_DOWN, callback = Dungeons.toggleList}})
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

function Dungeons.translateUI(widget)
	if not widget then
		return
	end

	local text = widget:getText()
	if text and text ~= "" then
		widget:setText(tr(text))
	end

	local tooltip = widget.tooltip
	if tooltip and tooltip ~= "" then
		widget.tooltip = tr(tooltip)
	end

	for _, child in ipairs(widget:getChildren()) do
		Dungeons.translateUI(child)
	end
end

function Dungeons.create()
	if Dungeons.UI then
		return
	end
	Dungeons.UI = g_ui.displayUI("dungeons")
	Dungeons.UI:hide()
	Dungeons.UI.onEscape = Dungeons.hide

	Dungeons.listUI = g_ui.displayUI("dungeonList")
	Dungeons.listUI:hide()
	Dungeons.listUI.onEscape = Dungeons.hideList
	Dungeons.listUI:recursiveGetChildById("closeButton").onClick = function()
		Dungeons.hideList()
	end

	Dungeons.killCounter = g_ui.loadUI("killcounter", modules.game_interface.getMapPanel())
	Dungeons.killCounter:hide()

	Dungeons.difficultyTooltip = g_ui.displayUI("difficultyTooltip")
	Dungeons.difficultyTooltip:hide()

	Dungeons.challengeNotifi = g_ui.loadUI("challenge", modules.game_interface.getMapPanel())
	g_effects.fadeOut(Dungeons.challengeNotifi, 1)

	Dungeons.registerDiffculityButtons()
	Dungeons.generateLootTooltip()

	Dungeons.translateUI(Dungeons.UI)
	Dungeons.translateUI(Dungeons.listUI)
	Dungeons.translateUI(Dungeons.killCounter)
	Dungeons.translateUI(Dungeons.difficultyTooltip)
	Dungeons.translateUI(Dungeons.challengeNotifi)

	Dungeons.UI:recursiveGetChildById("closeButton").onClick = function()
		Dungeons.hide()
	end

	Dungeons.UI:recursiveGetChildById("queueButton").onClick = function()
		Dungeons.joinQueue()
	end

	Dungeons.UI:recursiveGetChildById("leaderboardButton").onClick = function()
		Dungeons.sendOpcode({topic = "requestLeaderboard", data = {id = Dungeons.selectedDungeonId, difficulty = Dungeons.selectedDungeonDifficulty}})
		Dungeons.UI.leaderboardPanel.diffculityLabel:setText(tr("Difficulty Tier: %s", tr(Dungeons.difficultyConfig[Dungeons.selectedDungeonDifficulty].name)))
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
	
	-- Request dungeon list from server
	Dungeons.sendOpcode({topic = "requestDungeonList"})
	
	-- Add dungeon button to main panel (store-style)
	if modules.game_mainpanel then
		Dungeons.dungeonButton = modules.game_mainpanel.addStoreButton('dungeonsButton',
			tr('Dungeons'),
			'/images/topbuttons/dungeon',
			Dungeons.toggleList,
			false,
			5)
		if Dungeons.dungeonButton and Dungeons.dungeonButton.setOn then
			Dungeons.dungeonButton:setOn(false)
		end
	end
end

function Dungeons.destroy()
	-- Remove dungeon button
	if Dungeons.dungeonButton then
		Dungeons.dungeonButton:destroy()
		Dungeons.dungeonButton = nil
	end
	
	if Dungeons.UI then
		Dungeons.UI:destroy()
		Dungeons.UI = nil
	end

	if Dungeons.listUI then
		Dungeons.listUI:destroy()
		Dungeons.listUI = nil
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
	modules.game_interface.getRootPanel():focus()
end

function Dungeons.toggleList()
	if not Dungeons.listUI then
		return
	end
	if Dungeons.listUI:isVisible() then
		Dungeons.hideList()
	else
		Dungeons.showList()
	end
end

function Dungeons.showList()
	if not Dungeons.listUI then
		return
	end
	Dungeons.listUI:show()
	Dungeons.listUI:raise()
	Dungeons.listUI:focus()
	if Dungeons.dungeonButton and Dungeons.dungeonButton.setOn then
		Dungeons.dungeonButton:setOn(true)
	end
end

function Dungeons.hideList()
	if not Dungeons.listUI then
		return
	end
	Dungeons.listUI:hide()
	if Dungeons.dungeonButton and Dungeons.dungeonButton.setOn then
		Dungeons.dungeonButton:setOn(false)
	end
	modules.game_interface.getRootPanel():focus()
end

function Dungeons.onDungeonList(data)
	if not Dungeons.listUI then
		return
	end
	
	local dungeonListPanel = Dungeons.listUI:recursiveGetChildById("dungeonListPanel")
	dungeonListPanel:destroyChildren()
	
	if not data.dungeons or #data.dungeons == 0 then
		local label = g_ui.createWidget("Label", dungeonListPanel)
		label:setText(tr("No dungeons available"))
		label:setTextAlign(AlignCenter)
		return
	end
	
	for _, dungeon in ipairs(data.dungeons) do
		local widget = g_ui.createWidget("DungeonListEntry", dungeonListPanel)
		widget:recursiveGetChildById("dungeonName"):setText(tr(dungeon.title))
		widget:recursiveGetChildById("dungeonLevel"):setText(tr("Level: %s", dungeon.level))
		widget:recursiveGetChildById("dungeonParty"):setText(tr("Party: %s", tr(dungeon.party)))
		
		-- Set header image with 70% opacity
		local headerImage = widget:recursiveGetChildById("dungeonHeaderImage")
		if headerImage then
			headerImage:setImageSource("/images/dungeons/" .. dungeon.title)
		end
		
		if dungeon.cooldown and dungeon.cooldown > 0 then
			local cdLabel = widget:recursiveGetChildById("cooldownLabel")
			cdLabel:setText(tr("CD: %s", Dungeons.SecondsToShortTime(dungeon.cooldown)))
			cdLabel:setVisible(true)
		end
		
		local dungeonTitle = dungeon.title
		local highlightOverlay = widget:recursiveGetChildById("highlightOverlay")
		local isHovered = false
		local hoverTimer = nil
		
		local function checkMouseLeave()
			if not widget or not isHovered then return end
			
			local mousePos = g_window.getMousePosition()
			local widgetRect = widget:getRect()
			
			-- Verificar si el mouse está fuera del widget
			if mousePos.x < widgetRect.x or 
			   mousePos.x > widgetRect.x + widgetRect.width or
			   mousePos.y < widgetRect.y or
			   mousePos.y > widgetRect.y + widgetRect.height then
				isHovered = false
				highlightOverlay:setVisible(false)
				if hoverTimer then
					removeEvent(hoverTimer)
					hoverTimer = nil
				end
			else
				-- Si todavía está dentro, verificar de nuevo en 50ms
				hoverTimer = scheduleEvent(checkMouseLeave, 50)
			end
		end
		
		-- Mouse enter/move
		widget.onMouseMove = function(self, mousePos, mouseMoved)
			if not isHovered then
				isHovered = true
				highlightOverlay:setVisible(true)
				highlightOverlay:setBackgroundColor('#ffffff22')
				highlightOverlay:setBorderWidth(2)
				highlightOverlay:setBorderColor('#ffed2b')
				
				-- Empezar a verificar si el mouse sale
				if hoverTimer then
					removeEvent(hoverTimer)
				end
				hoverTimer = scheduleEvent(checkMouseLeave, 50)
			end
			
			return false
		end
		
		widget.onMouseRelease = function(self, mousePos, mouseButton)
			if mouseButton == MouseLeftButton then
				print(tr("Dungeon clicked: %s", dungeonTitle))
				Dungeons.hideList()
				scheduleEvent(function()
					print(tr("Requesting dungeon data for: %s", dungeonTitle))
					Dungeons.sendOpcode({topic = "dungeonBaseData-request", data = {dungeonName = dungeonTitle}})
					Dungeons.sendOpcode({topic = "openDungeon", data = {dungeonName = dungeonTitle}})
				end, 50)
				return true
			end
			return false
		end
	end
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

		if iconWidget and labelWidget and config[attribute] then
			local formattedText
			if attribute == "health" or attribute == "damage" then
				formattedText = tr("Monster %s %d%%", tr(attribute:gsub("^%l", string.upper)), config[attribute])
			elseif attribute == "fame" then
				formattedText = tr("Fame Reward") .. " +" .. config[attribute]
			elseif attribute == "reward" then
				formattedText = tr("Loot Amount") .. " +" .. config[attribute] .. "%"
			else
				formattedText = tr("Bonus XP") .. " +" .. config[attribute] .. "%"
			end

			if type(value) == "number" then
				Dungeons.setIconImageType(iconWidget, value)
			end
			labelWidget:setText(formattedText)
			iconWidget:setVisible(true)
			labelWidget:setVisible(true)
		elseif iconWidget and labelWidget then
			iconWidget:setVisible(false)
			labelWidget:setVisible(false)
		end
	end

	tooltip:setText(tr(config.name))

	local totalHeight = 25
	for _, attribute in pairs({"health", "damage", "exp", "reward", "fame"}) do
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
			line = tr("Difficulty level %d: Default - You can view items with %d%% chance drop rate or higher", difficulty, threshold)
		elseif difficulty == #Dungeons.lootChanceThresholds then
			line = tr("Difficulty level %d unlocked: You can view all droppable items", difficulty)
		else
			line = tr("Difficulty level %d unlocked: You can view items with %d%% chance drop rate or higher", difficulty, threshold)
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
	elseif topic == "lives" then
		Dungeons.onDungeonLives(data)
	elseif topic == "wave" then
		Dungeons.onDungeonWave(data)
	elseif topic == "challenge" then
		Dungeons.onChallengeCompleted(data)
	elseif topic == "solo" then
		Dungeons.buildLeaderboardSolo(data)
	elseif topic == "group" then
		Dungeons.buildLeaderboardGroup(data)
	elseif topic == "closeWindow" then
		Dungeons.hide()
	elseif topic == "dungeonList" then
		Dungeons.onDungeonList(data)
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
	if not Dungeons.UI then
		return
	end
	
	Dungeons.show()
	Dungeons.UI.bottomPanel.challengePoints:setText(data.challengePoints)

	Dungeons.UI:recursiveGetChildById("dungeonName"):setText(tr(data.title))
	Dungeons.UI:recursiveGetChildById("banner"):setImageSource("/images/dungeons/" .. data.title)

	-- Queue
	local queuePlayers = data.queue.players
	local queueStatusWidget = Dungeons.UI:recursiveGetChildById("queueStatus")
	queueStatusWidget:setText(queuePlayers == 0 and tr("Open") or tr("%s Player(s)", queuePlayers))
	if queuePlayers >= 6 then
		queueStatusWidget:setColor("red")
	elseif queuePlayers >= 3 then
		queueStatusWidget:setColor("orange")
	else
		queueStatusWidget:setColor("green")
	end

	local queueButton = Dungeons.UI:recursiveGetChildById("queueButton")
	if not data.queue.playerStatus then 
		queueButton:setText(tr("Join"))
	else
		queueButton:setText(tr("Leave Queue"))
	end

	-- Recall base data from cache
	if not Dungeons.cache[data.title] then
		Dungeons.sendOpcode({topic = "dungeonBaseData-request", data = {dungeonName = data.title}})
	else
		Dungeons.onDungeonBaseData(Dungeons.cache[data.title])
		Dungeons.updateLootPanel(data.title, data.difficulty)
	end

	-- Daily Mutation Panel (replaces legacy challenges)
	local challengesPanel = Dungeons.UI:recursiveGetChildById("challenges")
	challengesPanel:destroyChildren()
	local mutation = data.dailyMutation
	if not mutation or not mutation.key or mutation.key == "" then
		Dungeons.UI:recursiveGetChildById("noChallangesPanel"):setVisible(true)
	else
		Dungeons.UI:recursiveGetChildById("noChallangesPanel"):setVisible(false)
		local widget = g_ui.createWidget("MutationPanel", challengesPanel)

		local iconWidget = widget:getChildById("icon")
		local iconPath = "/images/dungeons/mutations/" .. (mutation.icon or mutation.key)
		iconWidget:setImageSource(iconPath)

		widget:getChildById("name"):setText(tr(mutation.name or mutation.key))
		widget:getChildById("description"):setText(tr(mutation.description or ""))
		widget:setTooltip(tr(mutation.description or ""))
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
			leaderWidget.PlayerLevel:parseColoredText(tr("Lvl: %s", data.party.leader.level))
			leaderWidget.PlayerName:setTooltip(tr("Party Leader"))
			local vocationIconId = Dungeons.vocationalIcons[data.party.leader.vocation]
			if vocationIconId then
				Dungeons.setIconImageType(leaderWidget.VocationalIcon, vocationIconId)

				leaderWidget.VocationalIcon:setTooltip(tr("Vocation: %s", tr(Dungeons.vocationNames[data.party.leader.vocation])))
			end
		end
		for _, member in ipairs(data.party.members) do
			local widget = g_ui.createWidget("PartyEntry", partyPanel)
			widget.PlayerName:setText(member.name)
			widget.PlayerLevel:setText(tr("Lvl: %s", member.level))
			local vocationIconId = Dungeons.vocationalIcons[member.vocation]
			if vocationIconId then
				Dungeons.setIconImageType(widget.VocationalIcon, vocationIconId)

				widget.VocationalIcon:setTooltip(tr("Vocation: %s", tr(Dungeons.vocationNames[member.vocation])))
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
	Dungeons.UI:recursiveGetChildById("partyRequirement"):setText(tr(data.req.party))
	Dungeons.UI:recursiveGetChildById("goldRequirement"):setText("0")

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

	-- Monsters Panel
	local monstersPanel = Dungeons.UI:recursiveGetChildById("monsters")
	monstersPanel:destroyChildren()
	if data.bossName and data.bossOutfit then
		local bossWidget = g_ui.createWidget("MonsterEntry", monstersPanel)
		bossWidget.creature:setOutfit(data.bossOutfit)
		bossWidget.name:parseColoredText("[color=#ffed2b]" .. data.bossName .. "[/color]")
		bossWidget.name:setTooltip(tr("Dungeon Boss"))
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
			leaderWidget.PlayerLevel:parseColoredText(tr("Lvl: %s", data.party.leader.level))
			leaderWidget.PlayerName:setTooltip(tr("Party Leader"))
			local vocationIconId = Dungeons.vocationalIcons[data.party.leader.vocation]
			if vocationIconId then
				Dungeons.setIconImageType(leaderWidget.VocationalIcon, vocationIconId)

				leaderWidget.VocationalIcon:setTooltip(tr("Vocation: %s", tr(Dungeons.vocationNames[data.party.leader.vocation])))
			end
		end
		if data.party.members then
			for _, member in ipairs(data.party.members) do
				local widget = g_ui.createWidget("PartyEntry", partyPanel)
				widget.PlayerName:setText(member.name)
				widget.PlayerLevel:setText(tr("Lvl: %s", member.level))
				local vocationIconId = Dungeons.vocationalIcons[member.vocation]
				if vocationIconId then
					Dungeons.setIconImageType(widget.VocationalIcon, vocationIconId)

					widget.VocationalIcon:setTooltip(tr("Vocation: %s", tr(Dungeons.vocationNames[member.vocation])))
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
		queueStatus:setText(queuePlayers == 0 and tr("Open") or tr("%s Player(s)", queuePlayers))
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
	queueButton:setText(tr("Join"))
end

function Dungeons.onDungeonQueue(data)
	local queueButton = Dungeons.UI:recursiveGetChildById("queueButton")
	if data.joined then
		queueButton:setText(tr("Leave Queue"))
	else
		queueButton:setText(tr("Join"))
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
	queueButton:setText(tr("Join"))
	Dungeons.killCounter:show()

	local bonusObjectives = Dungeons.killCounter:getChildById("bonusObjectives")
	for i = bonusObjectives:getChildCount(), 2, -1 do
		bonusObjectives:getChildByIndex(i):destroy()
	end
	local objectivesHeight = 0
	if data.objectives then
		local h = 16
		for _, obj in ipairs(data.objectives) do
			local w = g_ui.createWidget("ObjectiveCheckBox", bonusObjectives)
			w:addAnchor(AnchorTop, "prev", AnchorBottom)
			w:setMarginTop(5)
			w:setText(tr(obj))
			h = h + 25
		end
		bonusObjectives:setHeight(h)
		bonusObjectives:setMarginTop(5)
		objectivesHeight = h
	else
		bonusObjectives:setHeight(0)
		bonusObjectives:setMarginTop(0)
	end

	-- Daily Mutation display
	local mutationDisplay = Dungeons.killCounter:getChildById("mutationDisplay")
	local mutationHeight = 0
	if data.mutation and data.mutation.key and data.mutation.key ~= "" then
		local iconWidget = mutationDisplay:getChildById("icon")
		iconWidget:setImageSource("/images/dungeons/mutations/" .. tostring(data.mutation.icon or data.mutation.key))
		mutationDisplay:getChildById("name"):setText(tr(tostring(data.mutation.name or "")))
		mutationDisplay:getChildById("description"):setText(tr(tostring(data.mutation.description or "")))
		mutationDisplay:setVisible(true)
		mutationHeight = mutationDisplay:getHeight() + 6
	else
		mutationDisplay:setVisible(false)
	end

	Dungeons.killCounter:setHeight(190 + objectivesHeight + mutationHeight)

	local bar = Dungeons.killCounter:getChildById("bar")
	bar:setVisible(false)

	local label = Dungeons.killCounter:getChildById("label")
	label:setText(tr("0%"))
	local mainObjective = Dungeons.killCounter:getChildById("mainObjective")
	local bossObjective = Dungeons.killCounter:getChildById("bossObjective")
	local monstersLeftLabel = Dungeons.killCounter:getChildById("monstersLeft")

	local isOnlyBoss = data.type == "only_boss"
	local isWaveBoss = data.type == "wave_boss"
	Dungeons.isOnlyBoss = isOnlyBoss
	Dungeons.isWaveBoss = isWaveBoss
	Dungeons.totalWaves = tonumber(data.totalWaves) or 0
	if isOnlyBoss then
		bar:setVisible(false)
		label:setVisible(false)
		mainObjective:setVisible(false)
		mainObjective:setChecked(true)
		bossObjective:setText(tr("Kill %s", data.boss))
		bossObjective:setEnabled(true)
		bossObjective:setChecked(false)
		monstersLeftLabel:setVisible(false)
	elseif isWaveBoss then
		bar:setVisible(false)
		label:setVisible(false)
		mainObjective:setVisible(true)
		mainObjective:setText(tr("Survive %s waves", Dungeons.totalWaves))
		mainObjective:setChecked(false)
		bossObjective:setText(tr("Kill %s", data.boss))
		bossObjective:setEnabled(false)
		bossObjective:setChecked(false)
		monstersLeftLabel:setVisible(true)
		monstersLeftLabel:setText(tr("Wave: 0 / %s", Dungeons.totalWaves))
	else
		label:setVisible(true)
		mainObjective:setVisible(true)
		mainObjective:setText(tr("Kill monsters to spawn %s", data.boss))
		mainObjective:setChecked(false)
		bossObjective:setText(tr("Kill %s", data.boss))
		bossObjective:setEnabled(false)
		bossObjective:setChecked(false)
		monstersLeftLabel:setVisible(true)
		monstersLeftLabel:setText(tr("Monsters Remaining: %s", data.left))
	end
	Dungeons.killCounter:getChildById("timeLeft"):setText(tr("Time Left: %s", Dungeons.MsToShortTime(data.duration)))

	Dungeons.timeLeft = data.duration
	timeLeftEvent = scheduleEvent(Dungeons.doTimeLeft, 100)
end

function Dungeons.onDungeonObjective(data)
	local bonusObjectives = Dungeons.killCounter:getChildById("bonusObjectives")
	local objWidget = bonusObjectives:getChildByIndex(data.id + 1)
	objWidget:setChecked(data.finished)
end

function Dungeons.onDungeonWave(data)
	if not Dungeons.killCounter then return end
	local mainObjective = Dungeons.killCounter:getChildById("mainObjective")
	local bossObjective = Dungeons.killCounter:getChildById("bossObjective")
	local monstersLeftLabel = Dungeons.killCounter:getChildById("monstersLeft")

	local current = tonumber(data.current) or 0
	local total = tonumber(data.total) or Dungeons.totalWaves or 0
	local left = tonumber(data.left) or 0

	if data.bossSpawned then
		if mainObjective then mainObjective:setChecked(true) end
		if bossObjective then bossObjective:setEnabled(true) end
		if monstersLeftLabel then
			monstersLeftLabel:setText(tr("Wave: %s / %s  (Boss!)", total, total))
		end
		if Dungeons.challengeNotifi then
			local textWidget = Dungeons.challengeNotifi:getChildById("text")
			textWidget:setText(tr("Boss has arrived!"))
			Dungeons.challengeNotifi:setWidth(math.max(263, 96 + textWidget:getTextSize().width))
			g_effects.fadeIn(Dungeons.challengeNotifi, 250)
			scheduleEvent(function()
				if Dungeons.challengeNotifi then
					g_effects.fadeOut(Dungeons.challengeNotifi, 250)
				end
			end, 3000)
		end
		return
	end

	if monstersLeftLabel then
		if current <= 0 then
			monstersLeftLabel:setText(tr("Wave: 0 / %s", total))
		else
			monstersLeftLabel:setText(tr("Wave: %s / %s   Left: %s", current, total, left))
		end
	end
end

function Dungeons.onDungeonKilled(data)
	if Dungeons.isOnlyBoss or Dungeons.isWaveBoss then
		-- For wave_boss we still want to handle the boss-killed finish message.
		if Dungeons.isWaveBoss and data and data.boss then
			local bossObjective = Dungeons.killCounter:getChildById("bossObjective")
			bossObjective:setChecked(true)
			if Dungeons.challengeNotifi then
				local textWidget = Dungeons.challengeNotifi:getChildById("text")
				textWidget:setText(tr("You completed the dungeon!"))
				Dungeons.challengeNotifi:setWidth(math.max(263, 96 + textWidget:getTextSize().width))
				g_effects.fadeIn(Dungeons.challengeNotifi, 250)
				scheduleEvent(function()
					if Dungeons.challengeNotifi then
						g_effects.fadeOut(Dungeons.challengeNotifi, 250)
					end
				end, 3000)
			end
		end
		return
	end
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
		Dungeons.killCounter:getChildById("label"):setText(tr("%s%%", math.min(100, data.percent)))
		if data.percent >= 100 then
			Dungeons.killCounter:getChildById("mainObjective"):setChecked(true)
			bossObjective:setEnabled(true)
			local textWidget = Dungeons.challengeNotifi:getChildById("text")
			textWidget:setText(tr("You can kill the boss now!"))
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
		textWidget:setText(tr("You completed the dungeon!"))
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
		Dungeons.killCounter:getChildById("monstersLeft"):setText(tr("Monsters Alive: %s", data.left))
	end
end

function Dungeons.onDungeonFinish(data)
	Dungeons.killCounter:hide()
	if timeLeftEvent then
		removeEvent(timeLeftEvent)
	end
end

function Dungeons.onDungeonLives(data)
	if not Dungeons.killCounter then return end
	local label = Dungeons.killCounter:getChildById("livesLeft")
	if not label then return end
	local current = tonumber(data.current) or 0
	local max = tonumber(data.max) or 0
	label:setText(tr("Team Lives: %d / %d", current, max))
	if current <= 1 then
		label:setColor("#ff3030")
	else
		label:setColor("#ff6464")
	end
end

function Dungeons.doTimeLeft()
	Dungeons.timeLeft = Dungeons.timeLeft - 100
	if Dungeons.killCounter then Dungeons.killCounter:getChildById("timeLeft"):setText(tr("Time Left: %s", Dungeons.MsToShortTime(Dungeons.timeLeft))) end
	if Dungeons.timeLeft > 0 then
		timeLeftEvent = scheduleEvent(Dungeons.doTimeLeft, 100)
	end
end

function Dungeons.onChallengeCompleted(data)
	local textWidget = Dungeons.challengeNotifi:getChildById("text")
	textWidget:setText(tr("%s challenge completed!", data))
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