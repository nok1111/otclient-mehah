local messageWindow = nil
local indexDescription = nil
local indexList = nil
local OPCODE_MESSAGES = 75
local OPCODE_CENTREMESSAGES = 76
local xxx = {--we can use this table,yy
  {image1 = "/images/tutorial.png"},
  {image2 = "/images/game/buffs/itemCommon"},
  {image3 = "/images/game/buffs/itemEpic"},
  {image4 = "/images/game/buffs/itemLegendary"},
  {image5 = "/images/game/buffs/itemRare"}
}

-- for server side
function createWindowMessage(title, text, picture)
    return tittle .. "-" .. text .. "-" .. picture
end
-- for server side

function init()
    -- LOAD THE UI's
    messageWindow = g_ui.displayUI('game_sendmessages')
    centerMessage = g_ui.displayUI('game_centermessage')
    -- HIDE THE UI's
    messageWindow:hide()
    messageWindow:setVisible(false)
	messageWindow:setParent( modules.game_interface.gameMapPanel)
	messageWindow:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
	
    centerMessage:hide()
    centerMessage:setVisible(false)    
	centerMessage:setParent( modules.game_interface.gameMapPanel)
	centerMessage:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
	centerMessage:addAnchor(AnchorTop, 'parent', AnchorTop)
    -- define our HOTKEY to SHOW/HIDE
    --g_keyboard.bindKeyPress('Ctrl+J', toggle)
    g_keyboard.bindKeyPress('Ctrl+H', toggle2)    
    -- OP CODES
    g_game.enableFeature(GameExtendedOpcode)
    ProtocolGame.registerExtendedOpcode(OPCODE_MESSAGES, sendMessageWindows)
    ProtocolGame.registerExtendedOpcode(OPCODE_CENTREMESSAGES, sendCentreMessage)
    
    connect(g_game, {
        onGameStart = refresh,
        onGameEnd = offline
    })
end

function terminate()
    g_keyboard.unbindKeyPress('Ctrl+J')
    ProtocolGame.unregisterExtendedOpcode(OPCODE_MESSAGES)
    ProtocolGame.unregisterExtendedOpcode(OPCODE_CENTREMESSAGES)
    

    messageWindow:destroy()
    centerMessage:destroy()
  
    disconnect(g_game, {
        onGameStart = refresh,
        onGameEnd = offline
    })
end

function refresh()
    local player = g_game.getLocalPlayer()
    if not player then
        return
    end
    if messageWindow:isVisible() then
        messageWindow:hide()
    end
end

function offline()
    messageWindow:hide()
end

function sendMessageNow(str)
    centerMessage:hide()
    local msg_title = centerMessage:recursiveGetChildById('messageTitle')
    msg_title:setText(str)
    --msg_title:setColor("#00ff00")
    centerMessage:show()
	--center
end

function sendCentreMessage(protocol, opcode, buffer)
    buffer = tostring(buffer)
    local function removeMessage()
        g_effects.fadeOut(centerMessage, 1500)
    end
    addslowmotionitemevent = scheduleEvent(removeMessage, 5000)
    sendMessageNow(buffer)    
    g_effects.fadeIn(centerMessage, 1500)
end

function sendMessageWindows(protocol, opcode, buffer)
    buffer = tostring(buffer)
    messageWindow:hide()
    sendWindowNow(buffer)    
end

function sendWindowNow(str)
    messageWindow:hide()
    local cfg = convertMessage(str)
    
    local msg_title = messageWindow:recursiveGetChildById('messageTitle')
    msg_title:setText(cfg[1])
    --msg_title:setColor("#fca103")
    
    local msg_text = messageWindow:recursiveGetChildById('messageText')
    local children = msg_text:getChildren()
    for k = 1, #children do
        children[k]:destroy()
    end    
    msg_text:setBorderWidth(0)
    --local desc = g_ui.createWidget('NewsText', msg_text)
    msg_text:setText(cfg[2])    
    
    local msg_picture = messageWindow:recursiveGetChildById('messagePicture')    
    msg_picture:setImageSource(cfg[3])  
    messageWindow:show()
	messageWindow:focus()
	--messageWindow:grabMouse()
end

function closeWindow()
    messageWindow:hide()
	--messageWindow:ungrabMouse() its fine
end
--[[
nop, doenst have any option to set background. just:
title-message-image as text on 75 or 
]]
function convertMessage(str)
    local info, cfg = str:split("-"), {}
    cfg[1] = info[1]
    cfg[2] = info[2]
    cfg[3] = info[3] 
    return cfg
end
