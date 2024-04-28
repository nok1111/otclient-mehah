SERVER_CRAFT_RESULT = 1
SERVER_CRAFTING_WINDOW = 2

SKILL_BLOOD_CRAFTING = 1
SKILL_CELESTIAL_GUARD = 2
SKILL_SHADOW_COUNCIL = 3
SKILL_THE_IMMORTALS = 4
SKILL_BRAWLERS_GUILD = 5


-- helpers
local skillIdToUI = {
	[SKILL_BLOOD_CRAFTING] = "Blood Forging",
	[SKILL_CELESTIAL_GUARD] = "Celestial Guard",
	[SKILL_SHADOW_COUNCIL] = "Shadow Council",
	[SKILL_THE_IMMORTALS] = "The Inmortals",
	[SKILL_BRAWLERS_GUILD] = "Brawlers Guild",
}

local skillIdToImage = {
	[SKILL_BLOOD_CRAFTING] = "/data/images/game/profession/blood",
	[SKILL_CELESTIAL_GUARD] = "/data/images/game/profession/alchemy",
	[SKILL_SHADOW_COUNCIL] = "/data/images/game/profession/farming",
	[SKILL_THE_IMMORTALS] = "/data/images/game/profession/diplomacy",
	[SKILL_BRAWLERS_GUILD] = "/data/images/game/profession/diplomacy",
}

local forgingWindow = nil
local messageWindow = nil
--craftingButton = nil

function init()
	--craftingButton = modules.client_topmenu.addRightGameToggleButton('craftingButton', tr('Forging'), '/game_crafting/img/hammer', toggle)
--craftingButton:setOn(false)
	-- crafting
	forgingWindow = g_ui.displayUI('forging')
	forgingWindow:hide()

	forgingWindow.onEscape = hide
	forgingWindow:getChildById("closeButton").onClick = hide

	-- setup buttons
	forgingWindow:getChildById("craftButton").onClick = function() craftItem(false) end
	forgingWindow:getChildById("craftAllButton").onClick = function() craftItem(true) end

	forgingWindow:getChildById("leftButton").onClick = function()
		local amount = forgingWindow:getChildById("amount")
		local value = tonumber(amount:getText())
		if not value or value == 1 then
			return
		end

		amount:setText(tostring(value - 1))
	end

	forgingWindow:getChildById("rightButton").onClick = function()
		local amount = forgingWindow:getChildById("amount")
		local value = tonumber(amount:getText())
		if not value or value + 1 > amount.maxAmount then
			return
		end

		amount:setText(tostring(math.min(100, value + 1)))
	end

	forgingWindow:recursiveGetChildById("recipeList").onChildFocusChange = onRecipeSelected

	connect(g_game, { onGameEnd = hide })

	ProtocolGame.registerOpcode(GameServerOpcodes.GameServerOpenForging, parseServerInfo)
end

function terminate()
	disconnect(g_game, { onGameEnd = hide })
	ProtocolGame.unregisterOpcode(GameServerOpcodes.GameServerOpenForging, parseServerInfo)

	forgingWindow:destroy()
	forgingWindow = nil
end

function show()
	forgingWindow:show()
	forgingWindow:grabKeyboard()
end

function hide()
	forgingWindow:hide()
	forgingWindow:ungrabKeyboard()
        modules.game_interface.getRootPanel():focus()
end

function onRecipeSelected(w, child)
	-- update recipe details
	local recipe = child.recipe
	if not recipe then
		return
	end

	local item = forgingWindow:recursiveGetChildById("recipeItem")
	item:setItemId(recipe.spriteId)
	item:setVirtual(true)
	item:setItemCount(recipe.count)

	-- ingredients
	local panel = forgingWindow:recursiveGetChildById("ingredientsPanel")
	panel:destroyChildren()
	for _, ingredient in ipairs(recipe.ingredients) do
		local widget = g_ui.createWidget('Item', panel)
		widget:setItemId(ingredient.spriteId)
		widget:setVirtual(true)
		widget:setItemCount(ingredient.count)
		widget:setTooltip("You got " .. ingredient.playerCount .. "/" .. ingredient.count .. " required " .. ingredient.name)
	end

	local items = {}
	-- copy the list
	for _, item in pairs(recipe.ingredients) do
		items[#items + 1] = {playerAmount = item.playerCount, required = item.count}
	end

	child.maxCraftAmount = 0
	local proceed = true
	while proceed do
		for _, item in pairs(items) do
			if item.playerAmount < item.required then
				proceed = false
				break
			end
		end
		
		if not proceed then
			break
		end

		for _, item in pairs(items) do
			item.playerAmount = item.playerAmount - item.required
		end
		child.maxCraftAmount = child.maxCraftAmount + 1
	end

	forgingWindow:recursiveGetChildById("craftButton"):setEnabled(child.maxCraftAmount > 0)
	forgingWindow:recursiveGetChildById("craftAllButton"):setEnabled(child.maxCraftAmount > 0)
	forgingWindow:recursiveGetChildById("leftButton"):setEnabled(child.maxCraftAmount > 0)
	forgingWindow:recursiveGetChildById("rightButton"):setEnabled(child.maxCraftAmount > 0)

	forgingWindow:getChildById("amount").maxAmount = child.maxCraftAmount
	forgingWindow:getChildById("amount"):setText("1")

	forgingWindow:recursiveGetChildById("recipeDesc"):setText(recipe.desc)

	local label = forgingWindow:recursiveGetChildById("recipeLabel")
	label:setText(recipe.name)
	label:setWidth(label:getTextSize().width)
end

function craftItem(all)
	local recipeList = forgingWindow:recursiveGetChildById("recipeList")
	local focusedChild = recipeList:getFocusedChild()

	local amount = forgingWindow:getChildById("amount")

	if all then
		amount:setText(amount.maxAmount)
		amount = amount.maxAmount
	else
		-- craft amount specified
		amount = tonumber(amount:getText())
	end

	sendCraftItem(focusedChild.recipeId, amount, forgingWindow.profId)
end

function updateforgingWindow(skill, recipes)
	-- updates and shows crafting window
	forgingWindow:getChildById("skillLabel"):setText(tostring(skill.level))
	forgingWindow:getChildById("skillBar"):setPercent(tostring(skill.percentage))
	forgingWindow:getChildById("professionIcon"):setImageSource(skillIdToImage[skill.profId])
	forgingWindow:setText(skillIdToUI[skill.profId])
	forgingWindow.profId = skill.profId

	local recipeList = forgingWindow:recursiveGetChildById("recipeList")
	recipeList:destroyChildren()

	for i, recipe in ipairs(recipes) do
		local widget = g_ui.createWidget('Recipe', recipeList)
		widget:setText("T" .. recipe.tier .. " " .. recipe.name)
		widget.recipe = recipe
		widget.recipeId = i

		if skill.level < recipe.requiredSkill then
			-- disable recipe
			widget:setEnabled(false)
			widget:setText(widget:getText() .. " (disabled)")
		end
	end

	recipeList:focusChild(recipeList:getFirstChild())

	show()
end

function showMessageBox(success, err)
	local messageWindow = displayInfoBox(tr(success and 'Success' or 'Failed'), success and "You successfuly crafted desired items." or err)
	messageWindow:grabKeyboard()
end

-- protocol
function parseServerInfo(protocol, msg)
	local action = msg:getU8()
	if action == SERVER_CRAFT_RESULT then
		-- result of crafting
		local success = msg:getU8() == 1
		local err = ""
		if not success then
			err = msg:getString()
		end

		showMessageBox(success, err)
	elseif action == SERVER_CRAFTING_WINDOW then
		-- parse crafting window
		local skill = {}
		skill.level = msg:getU16()
		skill.percentage = msg:getU8()
		skill.profId = msg:getU8()

		local recipes = {}
		local size = msg:getU8()
		for i = 1, size do
			local recipe = {ingredients = {}}
			recipe.spriteId = msg:getU16() -- client id
			recipe.count = msg:getU16() -- amount of crafted recipe
			recipe.name = msg:getString()
			recipe.tier = msg:getU8()
			recipe.desc = msg:getString()
			recipe.requiredSkill = msg:getU16()

			-- ingredients
			local ingrSize = msg:getU8()
			for i = 1, ingrSize do
				local ingredient = {}
				ingredient.name = msg:getString()
				ingredient.spriteId = msg:getU16()
				ingredient.count = msg:getU32() -- required count
				ingredient.playerCount = msg:getU32() -- amount of player item
				recipe.ingredients[i] = ingredient
			end
			recipes[i] = recipe
		end

		updateforgingWindow(skill, recipes)
	end
end

function sendCraftItem(recipeId, amount, profId)
	local protocol = g_game.getProtocolGame()
	if not protocol then
		return
	end
	
	local msg = OutputMessage.create()
	msg:addU8(ClientOpcodes.ClientForgeRecipe)
	msg:addU32(recipeId) -- recipe id
	msg:addU16(amount) -- times of crafts
	msg:addU8(profId)
	protocol:send(msg)
end
