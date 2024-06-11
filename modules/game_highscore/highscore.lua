highscoreButton = nil
window = nil
HIGHSCORE_OPCODE = 151
local refreshMemoryTime = 60

function init()
	highscoreButton = modules.client_topmenu.addLeftGameButton('highscoreButton', tr('highscore'), '/images/options/button_prey', toggle, false, 8)
	
	g_ui.importStyle('highscorewindow')

	window = g_ui.createWidget('HighscoreWindow', rootWidget)
	window:hide()
	
    ProtocolGame.registerExtendedOpcode(HIGHSCORE_OPCODE, onHighscoreJSONOpcode)
	
end

function terminate()
  if highscoreButton then
    highscoreButton:destroy()
  end
    ProtocolGame.unregisterExtendedOpcode(HIGHSCORE_OPCODE, onHighscoreJSONOpcode)
end

highscoreInfo = {}
highscoreRefresh = 0

local parsingTables = {}

function onHighscoreJSONOpcode(protocol, code, json_data_convert)
    local json_data = json.decode(json_data_convert)
    local action = json_data['action']
    local data = json_data['data']
    if not action or not data or not data['opcodeData'] then return false end	
	
	local getData
	if data['opcodeDataFirst'] and data['opcodeDataFirst'] == "true" then
		if not parsingTables[code] then parsingTables[code] = {} end
		parsingTables[code][action] = {data={},collect=""}
	end
	parsingTables[code][action].collect = parsingTables[code][action].collect ..""..data['opcodeData']
	if data['opcodeDataLast'] and data['opcodeDataLast'] == "true" then
		getData = json.decode(parsingTables[code][action].collect)
	end
	
if not getData then return end	
    if action == 'refreshHighscore' then
        highscoreInfo = getData['info']
        highscoreRefresh = getData['refresh']
		show()
	elseif action == 'messageBox' then
		sendMessageBox(getData.title, getData.message)
	end
end

function toggle()
  if window:isVisible() then
    hideWindow()
	highscoreButton:setOn(false)
  else
	if os.time() - highscoreRefresh > refreshMemoryTime then
		sendAction(HIGHSCORE_OPCODE, "openHighscore", {})
	else
		show()
	end
	highscoreButton:setOn(true)
  end
end
subList = nil
function hideList()
	if not subList then return end
	local hide = true
	for iPos,childPos in pairs(rootWidget:recursiveGetChildrenByPos(g_window.getMousePosition())) do
		if string.find(childPos:getId(), "subListCategory") then 
			hide = false
		end
	end
	if hide then
		subList:destroy()
		subList = nil
	else
		scheduleEvent(hideList,100)
	end
end
function refreshHighscoreCategory()
	if not highscoreInfo then return end
		local caregoryPanel = window:recursiveGetChildById('buttonCreate')
		
		local windowSize = 0
		caregoryPanel:destroyChildren()
		for i,child in pairs(highscoreInfo) do	
			local button = g_ui.createWidget('categoryButton', caregoryPanel)
			button:setText(child.name)
			local getIcon = child.icon or child.name
			button:setIcon("/images/ranks/"..getIcon)
			button:setId("subListCategory")
			button.marginGet = windowSize
			local getButtonSize = button:getTextSize().width + 28
			windowSize = windowSize + getButtonSize + 4
			button:setWidth(getButtonSize)
			if child.subCategory then
				button.onClick = function ()
				if subList then
					subList:destroy()
					subList = nil
				end
				subList = g_ui.createWidget('subCategoryList', window)
					subList:addAnchor(AnchorTop, 'buttonCreate', AnchorBottom)
					subList:addAnchor(AnchorLeft, 'buttonCreate', AnchorLeft)
					subList:setWidth(100)
					subList:setId("subListCategory")
					hideList()
				local subHeight = 0
				local subWidth = 0
				for _i,_child in pairs(child.subCategory) do
				subHeight = subHeight + 16
					local subListCategory = g_ui.createWidget('subListCategory', subList)
						subListCategory:setId("subListCategory")
						subListCategory:setText(_child.name)
						subWidth = subListCategory:getTextSize().width > subWidth and subListCategory:getTextSize().width or subWidth
						local getIcon = _child.icon or _child.name
						subListCategory:setIcon("/images/ranks/"..getIcon)
						subListCategory.onClick = function ()
							subList:destroy()
							subList = nil
							refreshHighscorePanel(_child.name, _child.info)
						end
				
					end
				subList:setHeight(subHeight)
				subList:setWidth(subWidth + 28)
				subList:setMarginLeft(button.marginGet - (((subWidth + 28) - (button:getTextSize().width + 28))/2))
				end
			else
				button.onClick = function ()
					refreshHighscorePanel(child.name, child.info)
				end
			end
		end
	window:setWidth(windowSize+30)
	if #window:recursiveGetChildById('availableHighscore'):getChildren() < 1 and highscoreInfo[1] then
		refreshHighscorePanel(highscoreInfo[1].name, highscoreInfo[1].info)
	end
	end

function refreshHighscorePanel(valueName, refreshInfo)
	local highscoreList = window:recursiveGetChildById('availableHighscore')
	if not highscoreList then return end
	
	highscoreList:destroyChildren()
	for i,child in pairs(refreshInfo) do	
		local highscore = g_ui.createWidget('HighscoreLabel', highscoreList)
		if i < 4 then
			highscore:getChildById('numberLogo'):setIcon("/images/ranks/rank"..i)
		else
			highscore:getChildById('numberLogo'):setText(i.."th")
		end
		highscore:getChildById('rank'):setText(child.name)
		highscore:getChildById('value'):setText(valueName.. ": "..child.value)
		if not child.looktype then
			highscore:getChildById('rank'):setTextOffset(topoint('6 0'))
		else
			highscore:getChildById('rank'):setTextOffset(topoint('46 0'))
		end
		highscore:getChildById('outfit'):setOutfit({type=child.looktype, head=child.lookhead, body=child.lookbody, legs=child.looklegs, feet=child.lookfeet, addons=child.lookaddons})
	end
end

function switchPanel(visiblePanel)
	for i,child in pairs(allPanels) do
		window:recursiveGetChildById(child):setVisible(false)
	end
	window:recursiveGetChildById(visiblePanel):setVisible(true)
end

function sendMessageBox(title, message)
	if confirmWindow then
	confirmWindow:destroy() 
	end
	local okFunc = function() confirmWindow:destroy() confirmWindow = nil end
	confirmWindow = displayGeneralBox(title, message, {{text=tr('Ok'), callback=okFunc}, anchor=AnchorHorizontalCenter}, okFunc)
end

confirmWindow = nil

function show()
	refreshHighscoreCategory()
    window:raise()
    window:show()
    window:focus()
end

function hideWindow()
      window:hide()
end