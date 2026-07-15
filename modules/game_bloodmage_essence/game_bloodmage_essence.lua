modules.game_bloodmage_essence = modules.game_bloodmage_essence or {}

local BloodMageWidget = modules.game_bloodmage_essence
local OPCODE = 232

local function onExtendedOpcode(protocol, opcode, buffer)
    if opcode ~= OPCODE then
        return
    end

    local essenceStr, frenzyStr, orbsStr = buffer:match("^(%d+):(%d):(%d)$")
    local essence = tonumber(essenceStr) or 0
    local frenzy = tonumber(frenzyStr) or 0
    local orbs = tonumber(orbsStr) or 0

    local player = g_game.getLocalPlayer()
    if not player then
        return
    end

    player:setBloodEssence(math.max(0, math.min(100, essence)))
    player:setBloodFrenzy(frenzy == 1)
    player:setBloodOrbs(math.max(0, orbs))
end

function init()
    ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)
end

function terminate()
    ProtocolGame.unregisterExtendedOpcode(OPCODE, onExtendedOpcode)
end
