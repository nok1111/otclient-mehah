acceptstoneWindow = nil

-- player click the stone and send op code, send him party list
opcode_getParty = 88

-- player clicks on player and send player confirmation
opcode_summonplayer = 89

-- summoned player recieves the accept box 
opcode_acceptwindow = 90

-- summoned player responso
opcode_acceptwindowclick = 91

opcode_closewindow = 92

function init()
	-- LOAD THE UI's
	acceptstoneWindow = g_ui.displayUI('acceptsummon')
	stoneWindow = g_ui.displayUI('summonstone')
		

	-- HIDE THE UI's
	acceptstoneWindow:hide()
	stoneWindow:hide()

	-- load list
	partyList = stoneWindow:getChildById('rewardList')

	-- register op codes
	---- send pary list
	ProtocolGame.registerExtendedOpcode(opcode_getParty, sendPartyList)	
	---- close window
	ProtocolGame.registerExtendedOpcode(opcode_closewindow, closeStoneWindow)	
	---- send invited player accept/decline summon window
	ProtocolGame.registerExtendedOpcode(opcode_acceptwindow, sendAcceptWindow)			
	-- test it 
	g_keyboard.bindKeyDown('Ctrl+J', toggle)
	
	connect(g_game, {
		onGameStart = refresh,
		onGameEnd = offline,
	})
end

function sendPartyList(protocol, opcode, buffer)
	buffer = tostring(buffer)	
	local children = partyList:getChildren()
	for k = 1, #children do
		children[k]:destroy()
	end	
	local splitboth = buffer:split(":")
	local itemLocation = splitboth[1]
	local split_players = splitboth[2]:split("-")
	
	for i = 1, #split_players do
		local add_dungeon = g_ui.createWidget('lootButton1', partyList)
		local dungeonName = add_dungeon:getChildById('dungeonLabelTitle')
		local splitinfo = split_players[i]:split("+")
		
		local player_info = {
			name = splitinfo[1],
			feet = tonumber(splitinfo[2]),
			legs = tonumber(splitinfo[3]),
			body = tonumber(splitinfo[4]),
			type = tonumber(splitinfo[5]),
			auxType = 0,	
			addons = tonumber(splitinfo[6]),
			head = tonumber(splitinfo[7]),	
			infight = splitinfo[8],				
			
		}
		add_dungeon:setId(player_info.name)
		--add_dungeon:setTooltip(player_info.name)
		dungeonName:setText(player_info.name)	
		
		
		local outfitCreatureBox = add_dungeon:getChildById('outfitCreatureBox')
		outfitCreatureBox:setCreature(outfitCreature)
		outfitCreatureBox:setOutfit({
			feet=player_info.feet,
			legs=player_info.legs,
			body=player_info.body,
			type=player_info.type,
			auxType=player_info.auxType,
			addons=player_info.addons,
			head=player_info.head
		})
		local infightPicture = add_dungeon:getChildById('skullicon')
		add_dungeon:setTooltip("This player can be summoned.")
		infightPicture:setImageSource("/images/game/skulls/skull_green")
		if player_info.infight == "true" then
			add_dungeon:setTooltip("This player is in a fight.")
			infightPicture:setImageSource("/images/game/states/combat")
		end
		
		local listedDungeon = add_dungeon
		listedDungeon.onClick = function(self)
			local summonPlayer = add_dungeon:getChildById('dungeonLabelTitle'):getText()
			local protocolGame = g_game.getProtocolGame()
			if protocolGame then
				protocolGame:sendExtendedOpcode(opcode_summonplayer, itemLocation .. "-" .. summonPlayer)
			end
		end			
	end	
	stoneWindow:show()		
end

local inviter, player = "", ""

function sendAcceptWindow(protocol, opcode, buffer)
	buffer = tostring(buffer)
	stoneWindow:hide()
	acceptstoneWindow:hide()
	local splitnames = buffer:split("-")

	inviter = splitnames[1]
	player = splitnames[2]
	
	if inviter and player then
		local description = acceptstoneWindow:getChildById('descriptionText')
		description:setText(inviter .. " is trying to summon you, do you accept?")
	end
	acceptstoneWindow:show()
end


function acceptButton()
	local protocolGame = g_game.getProtocolGame()
	if protocolGame then
		acceptstoneWindow:hide()
		protocolGame:sendExtendedOpcode(opcode_acceptwindowclick, "true-" .. inviter .. "-" .. player)
	end	
end

function declineButton()
	local protocolGame = g_game.getProtocolGame()
	if protocolGame then
		acceptstoneWindow:hide()
		protocolGame:sendExtendedOpcode(opcode_acceptwindowclick, "false-" .. inviter .. "-" .. player)
	end	
end

function closeStoneWindow(protocol, opcode, buffer)
	stoneWindow:hide()
	
end

function closeStone()
	stoneWindow:hide()
end

function terminate()
	--trackerWindow:destroy()
  
	disconnect(g_game, {
		onGameStart = refresh,
		onGameEnd = offline
	})
end

function toggle()
	if stoneWindow:isVisible() then
		stoneWindow:hide()
	else
		stoneWindow:show()
	end
end

function refresh()
	local player = g_game.getLocalPlayer()
	if not player then
		return
	end
end

function offline()
	stoneWindow:hide()
end