g_logger.debug("Attempting to load Passive Tree mod")

local window = nil
local passiveTreeButton = nil
local PASSIVE_TREE_OPCODE = 220  
local nodeValues = nil

function init()
    g_logger.debug("Passive Tree init() called")
    
    -- Initialize nodeValues once
    nodeValues = {
        node1 = 0,
        node2 = 0
    }
    
    -- Create button first
    passiveTreeButton = modules.game_mainpanel.addToggleButton(
        'passiveTreeButton', 
        tr('Passive Tree'),
        '/images/options/passive',
        toggle,
        false,
        3
    )
    passiveTreeButton:setOn(false)

    -- Then create window with right panel
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
    -- Request current levels from server
    requestLevels()
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
        onGameEnd = offline
    })
end

function requestLevels()
    if not g_game.isOnline() then return end
    local protocol = g_game.getProtocolGame()
    if not protocol then return end
    
    protocol:sendExtendedOpcode(PASSIVE_TREE_OPCODE, json.encode({
        action = "requestLevels"
    }))
end

function applyPassiveTree(nodeName)
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
        action = "upgrade",
        node = nodeName
    }
    
    local jsonData = json.encode(data)
    protocol:sendExtendedOpcode(PASSIVE_TREE_OPCODE, jsonData)
end

function onExtendedOpcode(protocol, opcode, buffer)
    if opcode ~= PASSIVE_TREE_OPCODE then return end
    
    local success, data = pcall(json.decode, buffer)
    if success then
        if data.error then
            g_logger.error("Passive Tree Error: " .. data.error)
        else
            -- When we receive initial levels
            if data.levels then
                -- Update nodeValues
                nodeValues.node1 = data.levels.node1
                nodeValues.node2 = data.levels.node2
                
                -- Update UI
                local node1Button = window:recursiveGetChildById("node1")
                local node2Button = window:recursiveGetChildById("node2")
                
                if node1Button then
                    node1Button:setText('HP +5\nLevel: ' .. nodeValues.node1)
                end
                if node2Button then
                    node2Button:setText('MP +5\nLevel: ' .. nodeValues.node2)
                end
            -- When we receive a single node update
            elseif data.node and data.level then
                -- Update nodeValues for the specific node
                nodeValues[data.node] = data.level
                
                -- Update UI for the specific node
                local button = window:recursiveGetChildById(data.node)
                if button then
                    local effectText = (data.node == "node1") and "HP +5" or "MP +5"
                    button:setText(effectText .. '\nLevel: ' .. data.level)
                end
            end
        end
    end
end

function updateAllNodes()
    g_logger.debug("Updating all nodes. Current values: node1=" .. nodeValues.node1 .. ", node2=" .. nodeValues.node2)
    updateNodeText("node1")
    updateNodeText("node2")
end

function updateNodeText(nodeName)
    local button = window:recursiveGetChildById(nodeName)
    if button then
        local effectText = (nodeName == "node1") and "HP +5" or "MP +5"
        local level = tonumber(nodeValues[nodeName]) or 0
        button:setText(tr(effectText) .. '\nLevel: ' .. level)
    end
end