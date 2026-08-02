modules.game_bard_resonance = modules.game_bard_resonance or {}

local OPCODE = 233

local function onExtendedOpcode(protocol, opcode, buffer)
    if opcode ~= OPCODE then
        return
    end

    local disStr, harStr, vulnStr = buffer:match("^(%d+):(%d+):(%d)$")
    local dis = tonumber(disStr) or 0
    local har = tonumber(harStr) or 0
    local vuln = tonumber(vulnStr) or 0

    local player = g_game.getLocalPlayer()
    if not player then
        return
    end

    player:setBardDissonance(math.max(0, math.min(100, dis)))
    player:setBardHarmony(math.max(0, math.min(100, har)))
    player:setBardCrescendoVuln(vuln == 1)
end

function init()
    ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)
end

function terminate()
    ProtocolGame.unregisterExtendedOpcode(OPCODE, onExtendedOpcode)
end
