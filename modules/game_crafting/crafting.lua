SERVER_CRAFT_RESULT = 1
SERVER_CRAFTING_WINDOW = 2

SKILL_BLACKSMITH = 1
SKILL_ALCHEMY = 2
SKILL_COOKING = 3
SKILL_ENCHANTING = 4
SKILL_TEMPORAL_CRAFTING = 9


balance = 0

-- helpers
local skillIdToUI = {
	[SKILL_BLACKSMITH] = "Blacksmith",
	[SKILL_ALCHEMY] = "Alchemy",
	[SKILL_COOKING] = "Cooking",
	[SKILL_ENCHANTING] = "Enchanting",
	[SKILL_TEMPORAL_CRAFTING] = "Temporal Crafting",
}

local skillIdToImage = {
	[SKILL_BLACKSMITH] = "/data/images/game/profession/blacksmith",
	[SKILL_ALCHEMY] = "/data/images/game/profession/alchemy",
	[SKILL_COOKING] = "/data/images/game/profession/farming",
	[SKILL_ENCHANTING] = "/data/images/game/profession/diplomacy",
	[SKILL_TEMPORAL_CRAFTING] = "/data/images/game/profession/chrono",
}

local craftingWindow = nil
local messageWindow = nil
--craftingButton = nil

function init()
--craftingButton = modules.client_topmenu.addRightGameToggleButton('craftingButton', tr('Crafting'), '/game_crafting/img/hammer', toggle)
--craftingButton:setOn(false)
	-- crafting
	craftingWindow = g_ui.displayUI('crafting')
	craftingWindow:hide()

	craftingWindow.onEscape = hide
	craftingWindow:getChildById("closeButton").onClick = hide

	-- setup buttons
	craftingWindow:getChildById("craftButton").onClick = function() craftItem(false) end
	craftingWindow:getChildById("craftAllButton").onClick = function() craftItem(true) end

	

	craftingWindow:recursiveGetChildById("recipeList").onChildFocusChange = onRecipeSelected
	craftingWindow:recursiveGetChildById("leftButton").onClick = onRecipeSelected
	craftingWindow:recursiveGetChildById("rightButton").onClick = onRecipeSelected

	connect(g_game, { onGameEnd = hide })

	ProtocolGame.registerOpcode(GameServerOpcodes.GameServerOpenCrafting, parseServerInfo)
end

function terminate()
	disconnect(g_game, { onGameEnd = hide })
	ProtocolGame.unregisterOpcode(GameServerOpcodes.GameServerOpenCrafting, parseServerInfo)

	craftingWindow:destroy()
	craftingWindow = nil
end

function show()
	craftingWindow:show()
	craftingWindow:grabKeyboard()
end

function hide()
	craftingWindow:hide()
	craftingWindow:ungrabKeyboard()
    modules.game_interface.getRootPanel():focus()
end


function onRecipeSelected(w, child)
	-- update recipe details
	local recipe = child.recipe
	if not recipe then
		return
	end
	
	local recipeList = craftingWindow:recursiveGetChildById("recipeList")
	recipeList:setImageSource("/images/ui/panel_flat - Copy.png")
	
	
	
	
	
	
	
	craftingWindow:getChildById("cost"):setText(recipe.cost .. " Gold")
	
	craftingWindow:getChildById("leftButton").onClick = function()
		local amount = craftingWindow:getChildById("amount")
		local costamount = recipe.cost
		local value = tonumber(amount:getText())
		if not value or value == 1 then
			return
		end

		amount:setText(tostring(value - 1))
		craftingWindow:getChildById("cost"):setText(costamount * (value - 1) .. " Gold")
		craftingWindow:getChildById("balance"):setText(tostring(balance .. " Gold"))
	end

	craftingWindow:getChildById("rightButton").onClick = function()
		local amount = craftingWindow:getChildById("amount")
		local costamount = recipe.cost
		local value = tonumber(amount:getText())
		if not value or value + 1 > amount.maxAmount then
			return
		end

		amount:setText(tostring(math.min(100, value + 1)))
		craftingWindow:getChildById("cost"):setText(costamount * (value + 1) .. " Gold")
		craftingWindow:getChildById("balance"):setText(tostring(balance .. " Gold"))
	end

	local item = craftingWindow:recursiveGetChildById("recipeItem")
	item:setItemId(recipe.spriteId)
	item:setVirtual(true)
	item:setItemCount(recipe.count)
	

		
	
	
	craftingWindow:getChildById("balance"):setText(tostring(balance .. " Gold"))

	-- ingredients
	local panel = craftingWindow:recursiveGetChildById("ingredientsPanel")
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

	craftingWindow:recursiveGetChildById("craftButton"):setEnabled(child.maxCraftAmount > 0)
	craftingWindow:recursiveGetChildById("craftAllButton"):setEnabled(child.maxCraftAmount > 0)
	craftingWindow:recursiveGetChildById("leftButton"):setEnabled(child.maxCraftAmount > 0)
	craftingWindow:recursiveGetChildById("rightButton"):setEnabled(child.maxCraftAmount > 0)

	craftingWindow:getChildById("amount").maxAmount = child.maxCraftAmount
	craftingWindow:getChildById("amount"):setText("1")
	craftingWindow:getChildById("amount"):setMaxLength(3)
	
	--craftingWindow:getChildById("cost"):setText("0")
	--craftingWindow:getChildById("balance"):setText("0")

	craftingWindow:recursiveGetChildById("recipeDesc"):setText(recipe.desc)

	local label = craftingWindow:recursiveGetChildById("recipeLabel")
	label:setText(recipe.name)
	label:setWidth(label:getTextSize().width)
end

function craftItem(all)
	local recipeList = craftingWindow:recursiveGetChildById("recipeList")
	local focusedChild = recipeList:getFocusedChild()

	local amount = craftingWindow:getChildById("amount")

	if all then
		amount:setText(amount.maxAmount)
		amount = amount.maxAmount
	else
		-- craft amount specified
		amount = tonumber(amount:getText())
	end

	sendCraftItem(focusedChild.recipeId, amount, craftingWindow.profId)
end

function updateCraftingWindow(skill, recipes)
	-- updates and shows crafting window
	craftingWindow:getChildById("skillLabel"):setText(tostring(skill.level))
	craftingWindow:getChildById("skillBar"):setPercent(tostring(skill.percentage))
	craftingWindow:getChildById("professionIcon"):setImageSource(skillIdToImage[skill.profId])
	craftingWindow:setText(skillIdToUI[skill.profId])
	craftingWindow.profId = skill.profId
	
	craftingWindow:getChildById("balance"):setText(tostring(balance))

	local recipeList = craftingWindow:recursiveGetChildById("recipeList")
	recipeList:destroyChildren()

	for i, recipe in ipairs(recipes) do
		local widget = g_ui.createWidget('Recipe', recipeList)
		widget:setImageSource("/images/ui/list1.png")
		widget:setText("T" .. recipe.tier .. " " .. recipe.name)
		widget.recipe = recipe
		widget.recipeId = i

		local MIN_LEVEL = recipe.requiredSkill
		local MAX_STORAGE_VALUE = 700
		local NOT_LEARNED_YET = " ??? - Not Learned Yet"
		local LEVEL_TOO_LOW = "??? - Level too low"

		if skill.level < MIN_LEVEL or (recipe.recipestorage >= MAX_STORAGE_VALUE and recipe.storagevalue ~= 1) then
			-- disable recipe
			widget:setEnabled(false)
			--widget:hide()
			if skill.level < MIN_LEVEL then
				widget:setText(LEVEL_TOO_LOW)
				widget:setImageSource("/images/ui/list2.png")
			elseif skill.level < MIN_LEVEL and recipe.recipestorage >= MAX_STORAGE_VALUE and recipe.storagevalue ~= 1 then
				widget:setText(widget:getText() .. LEVEL_TOO_LOW)
				widget:setImageSource("/images/ui/list2.png")
			elseif recipe.recipestorage >= MAX_STORAGE_VALUE and recipe.storagevalue ~= 1 then
				widget:setText(NOT_LEARNED_YET)
				widget:setImageSource("/images/ui/panel_flat - Copy.png")
			elseif recipe.recipestorage >= MAX_STORAGE_VALUE and recipe.storagevalue >= 1 then
				widget:setText(NOT_LEARNED_YET)
				widget:setImageSource("/images/ui/list3.png")
				--widget:setImageColor('#FFFFFF')
			end
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
			recipe.cost = msg:getU16()
			recipe.recipestorage = msg:getU16()
			recipe.storagevalue = msg:getU16()
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
		balance = msg:getU32()
		--print(balance)
		updateCraftingWindow(skill, recipes)
	end
end

function sendCraftItem(recipeId, amount, profId)
	local protocol = g_game.getProtocolGame()
	if not protocol then
		return
	end
	
	local msg = OutputMessage.create()
	msg:addU8(ClientOpcodes.ClientCraftRecipe)
	msg:addU32(recipeId) -- recipe id
	msg:addU16(amount) -- times of crafts
	msg:addU8(profId)
	protocol:send(msg)
end
