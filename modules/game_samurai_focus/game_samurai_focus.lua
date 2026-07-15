modules.game_samurai_focus = modules.game_samurai_focus or {}

local FocusWidget = modules.game_samurai_focus
local OPCODE = 230
local OPCODE_DASH = 231

local dashSafetyEvents = {}

local function onExtendedOpcode(protocol, opcode, buffer)
    if opcode ~= OPCODE then
        return
    end

    local stacks = tonumber(buffer) or 0
    local player = g_game.getLocalPlayer()
    if not player then
        return
    end

    player:setFocusStacks(math.max(0, math.min(3, stacks)))
end

local function onDashOpcode(protocol, opcode, buffer)
    if opcode ~= OPCODE_DASH then
        return
    end

    local creatureId, enabled, distance = buffer:match("^(%d+):(%d):?(%d*)$")
    creatureId = tonumber(creatureId)
    if not creatureId then
        return
    end

    local creature = g_map.getCreatureById(creatureId)
    if not creature then
        return
    end

    if dashSafetyEvents[creatureId] then
        removeEvent(dashSafetyEvents[creatureId])
        dashSafetyEvents[creatureId] = nil
    end

    if enabled == "1" then
        -- scale ghost count with dash distance (2 ghosts per tile, capped)
        distance = tonumber(distance)
        if distance and distance > 0 then
            creature:setDashGhosts(math.min(distance * 2, 12))
        else
            creature:setDashGhosts(4)
        end
        creature:setDash(true)
        -- safety: auto-disable in case the "off" packet is lost
        dashSafetyEvents[creatureId] = scheduleEvent(function()
            dashSafetyEvents[creatureId] = nil
            local c = g_map.getCreatureById(creatureId)
            if c then
                c:setDash(false)
            end
        end, 1500)
    else
        creature:setDash(false)
    end
end

function init()
    ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)
    ProtocolGame.registerExtendedOpcode(OPCODE_DASH, onDashOpcode)
end

function terminate()
    ProtocolGame.unregisterExtendedOpcode(OPCODE, onExtendedOpcode)
    ProtocolGame.unregisterExtendedOpcode(OPCODE_DASH, onDashOpcode)
    for _, event in pairs(dashSafetyEvents) do
        removeEvent(event)
    end
    dashSafetyEvents = {}
end
