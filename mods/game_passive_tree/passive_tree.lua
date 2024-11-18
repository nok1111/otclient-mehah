g_logger.debug("Attempting to load Passive Tree mod")

local window = nil
local passiveTreeButton = nil
local PASSIVE_TREE_OPCODE = 220  

function init()
    g_logger.debug("Passive Tree init() called")
    
 
    passiveTreeButton = modules.game_mainpanel.addToggleButton(
        'passiveTreeButton', 
        tr('Passive Tree'),
        '/images/options/passive',
        toggle,
        false,  
        3      
    )
    passiveTreeButton:setOn(false)

    
    window = g_ui.displayUI('passive_tree', modules.game_interface.getRightPanel())
    if not window then
        g_logger.error("Failed to create passive tree window")
        return
    end
    window:hide()

    connect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

    if g_game.isOnline() then
        online()
    end
end

function toggle()
    if window:isVisible() then
        window:hide()
        passiveTreeButton:setOn(false)
    else
        window:show()
        window:raise()
        window:focus()
        passiveTreeButton:setOn(true)
    end
end

function online()
    passiveTreeButton:show()
end

function offline()
    passiveTreeButton:hide()
    window:hide()
end

function terminate()
    if window then
        window:destroy()
        window = nil
    end
    
    if passiveTreeButton then
        passiveTreeButton:destroy()
        passiveTreeButton = nil
    end
    
    disconnect(g_game, {
        onGameStart = online,
        onGameEnd = offline,
        onLogin = function()
            ProtocolGame.registerExtendedOpcode(PASSIVE_TREE_OPCODE, onExtendedOpcode)
        end
    })
end

function show()
    window:show()
    window:raise()
    window:focus()
end

function hide()
    window:hide()
end


function onExtendedOpcode(protocol, opcode, buffer)
    if opcode ~= PASSIVE_TREE_OPCODE then return end
    
    local success, data = pcall(json.decode, buffer)
    if success then
        if data.error then
            g_logger.error("Passive Tree Error: " .. data.error)
        else
            g_logger.info("Passive Tree: " .. (data.message or "Success"))
        end
    end
end


function applyPassiveTree(nodeName, value)
    if not g_game.isOnline() then
        g_logger.error("Not connected to game")
        return
    end
    
    local protocol = g_game.getProtocolGame()
    if not protocol then
        g_logger.error("No game protocol")
        return
    end
    

    local data = {
        node = nodeName,
        value = value
    }
    

    local jsonData = json.encode(data)
    protocol:sendExtendedOpcode(PASSIVE_TREE_OPCODE, jsonData)
end