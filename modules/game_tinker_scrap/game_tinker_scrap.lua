modules.game_tinker_scrap = modules.game_tinker_scrap or {}

local OPCODE = 234

local function onExtendedOpcode(protocol, opcode, buffer)
    if opcode ~= OPCODE then
        return
    end

    local stacks = tonumber(buffer) or 0
    local player = g_game.getLocalPlayer()
    if not player then
        return
    end

    player:setScrapStacks(math.max(0, math.min(5, stacks)))
end

function init()
    ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)
end

function terminate()
    ProtocolGame.unregisterExtendedOpcode(OPCODE, onExtendedOpcode)
end
