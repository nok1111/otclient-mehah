-- skill consts
SKILL_BLOOD_CRAFTING = 1
SKILL_CELESTIAL_GUARD = 2
SKILL_SHADOW_COUNCIL = 3
SKILL_THE_IMMORTALS = 4
SKILL_BRAWLERS_GUILD = 5

local mainToggleButton = nil
local mainWindow = nil
local lastOpen = 0

-- helpers
local skillIdToUI = {
	[SKILL_BLOOD_CRAFTING] = "bloodforging",
	[SKILL_CELESTIAL_GUARD] = "celestialguard",
	[SKILL_SHADOW_COUNCIL] = "shadowcouncil",
	[SKILL_THE_IMMORTALS] = "theimmortals",
	[SKILL_BRAWLERS_GUILD] = "brawlersguild",
}

function init()
	mainToggleButton = modules.client_topmenu.addRightGameToggleButton('jobButton', tr('Reputations'), '/images/topbuttons/reputation', toggle)

	-- profession
	mainWindow = g_ui.displayUI('jobs')
	mainWindow:hide()

	mainWindow.onEscape = hide
	mainWindow:getChildById("closeButton").onClick = hide

	connect(g_game, { onGameEnd = offline })

	ProtocolGame.registerOpcode(GameServerOpcodes.GameServerOpenReputation, parseJobs)
end

function terminate()
	disconnect(g_game, { onGameEnd = offline })
	ProtocolGame.unregisterOpcode(GameServerOpcodes.GameServerOpenReputation, parseJobs)

	mainWindow:destroy()
	mainWindow = nil

	mainToggleButton:destroy()
	mainToggleButton = nil
end

function offline()
	hide()
	mainToggleButton:setOn(false)
end

function show()
	mainWindow:show()
	mainWindow:grabKeyboard()
	mainToggleButton:setOn(true)
	lastOpen = g_clock.millis()
end

function hide()
	mainWindow:hide()
	mainWindow:ungrabKeyboard()
	mainToggleButton:setOn(false)
end

function toggle()
	if mainWindow:isVisible() then
		hide()
	else
		if g_clock.millis() - lastOpen < 1000 then
			return -- limit traffic, dont flood the server
		end 

		sendOpenWindow()
		mainWindow:show()
	end
end

function updateMainJobs(skills, profId, profDesc)
	local professionPanel = mainWindow:getChildById("professionPanel")

	-- update all skills
	for i = 1, #skills do
		professionPanel:recursiveGetChildById(skillIdToUI[i]:lower() .. "Label"):setText(tostring(skills[i].level))
		local bar = professionPanel:recursiveGetChildById(skillIdToUI[i]:lower() .. "Bar")
		bar:setPercent(skills[i].percentage)
		professionPanel:recursiveGetChildById("bloodforgingDescLabel"):setText(tostring("Description: Earned by contributing to the craft of blood-related artifacts and alchemy.Emblem: Represents a blood droplet intertwined with mystical symbols."))
		professionPanel:recursiveGetChildById("celestialguardDescLabel"):setText(tostring("Blood forge description here 2"))
		professionPanel:recursiveGetChildById("shadowcouncilDescLabel"):setText(tostring("Blood forge description here 3"))
		professionPanel:recursiveGetChildById("theimmortalsDescLabel"):setText(tostring("Blood forge description here 4"))
		professionPanel:recursiveGetChildById("brawlersguildDescLabel"):setText(tostring("Blood forge description here 5"))
		if i > 5 or (i < 6 and profId == i) then
			bar:setTooltip("You have " .. 100 - skills[i].percentage .. " percent to go.")
		end
	end

	-- enable chosen profession
	if profId ~= 0 then
		professionPanel:recursiveGetChildById(skillIdToUI[profId]:lower() .. "Button"):enable()
		--professionPanel:recursiveGetChildById("professionNameLabel"):setText(skillIdToUI[profId] .. " (Main Job)")
	
	end

	

	--show()
end

-- protocol
function parseJobs(protocol, msg)
	local skills = {}
	local skillSize = msg:getU8()
	for i = 1, skillSize do
		local skill = {}
		skill.level = msg:getU16()
		skill.percentage = msg:getU8()
		skills[i] = skill
	end

	local professionId = msg:getU8()
	local professionDesc = msg:getString()

	updateMainJobs(skills, professionId, professionDesc)
end

function sendOpenWindow()
	local protocol = g_game.getProtocolGame()
	if not protocol then
		return
	end
	
	local msg = OutputMessage.create()
	msg:addU8(ClientOpcodes.ClientOpenReputationWindow)
	protocol:send(msg)
end
