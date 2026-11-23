--[[
  Territorial Dominion - headless data layer (extended opcode 237).
  The UI now lives inside modules/game_guildmanagement (Dominion tab).
  This module only owns the protocol channel + caches and is consumed by
  game_MapTravel (territory markers) and the guildmanagement Dominion panel.
]]

local OPCODE = 237

Dominion = {}

Dominion.territories = {}      -- [id] = serialized territory table
Dominion.selectedId = nil
Dominion.detail = nil          -- last dominion-detail payload {id, contributions, history}
Dominion.onDataChanged = nil   -- hook, set by the UI host (game_guildmanagement)

function send(payload)
  local pg = g_game.getProtocolGame()
  if pg then pg:sendExtendedJSONOpcode(OPCODE, payload) end
end
Dominion.send = send

function Dominion.requestSnapshot()
  send({ topic = 'dominion-request-snapshot' })
end

function Dominion.requestDetail(id)
  send({ topic = 'dominion-detail-request', territoryId = id })
end

function Dominion.selectTerritory(id)
  Dominion.selectedId = id
  Dominion.requestDetail(id)
  if Dominion.onDataChanged then
    pcall(Dominion.onDataChanged)
  end
end

-- MapTravel entry point: opens the shared window on the Dominion tab
function Dominion.show()
  local gm = modules and modules.game_guildmanagement
  if gm and gm.openDominionTab then
    gm.openDominionTab()
  end
end

local function changed()
  if Dominion.onDataChanged then
    pcall(Dominion.onDataChanged)
  end
end

-- Contest area effect: anchored on the node's core tile (server sends
-- state='contested' + corePos via dominion-update). Client-side only —
-- tiles are AttachableObject so no NPC anchor is needed.
-- clone of the zone-event circle (dat effect 1178) registered under a
-- dominion-only id so detach doesn't collide with zone-event usage
local CONTEST_EFFECT_ID = 2000
local contestEffectId = nil -- resolved in init: clone id, else raw 1178

local function contestEffect()
  if not contestEffectId then return nil end
  return g_attachedEffects.getById(contestEffectId)
end
local contestedTiles = {} -- [tid] = Position

local function syncContestEffect(t)
  if not t then return end
  -- hotspot anchor = clicked item pos (real pos in active map); corePos is
  -- the config node pos which may be off-map
  local pos = (t.state == 'contested' and t.siege and t.siege.anchor) or t.corePos
  if not pos then return end
  local tile = g_map.getTile(pos)
  if not tile then
    contestedTiles[t.id] = t.state == 'contested' and pos or nil
    return
  end
  if t.state == 'contested' then
    local eff = contestEffect()
    if eff then
      pcall(function() tile:attachEffect(eff) end)
      print(string.format('[Dominion] contest effect attached at %d,%d,%d (tid %d)',
        pos.x, pos.y, pos.z, t.id))
    else
      print('[Dominion] WARN: contest effect id not registered')
    end
    contestedTiles[t.id] = pos
  else
    pcall(function() tile:detachEffectById(contestEffectId or CONTEST_EFFECT_ID) end)
    contestedTiles[t.id] = nil
  end
end

local function syncAllContestEffects()
  for id, t in pairs(Dominion.territories) do
    if t.id then syncContestEffect(t) end
  end
end

-- retry for tiles that were out of view when the update arrived
local function retryContestEffects()
  for tid, pos in pairs(contestedTiles) do
    local tile = g_map.getTile(pos)
    if tile and not tile:getAttachedEffectById(contestEffectId or CONTEST_EFFECT_ID) then
      local eff = contestEffect()
      if eff then pcall(function() tile:attachEffect(eff) end) end
    end
  end
  scheduleEvent(retryContestEffects, 2000)
end
scheduleEvent(retryContestEffects, 2000)

local function onExtendedOpcode(protocol, code, buffer)
  if code ~= OPCODE then return false end
  local ok, data = pcall(function() return json.decode(buffer) end)
  if not ok or type(data) ~= 'table' then return true end

  if data.topic == 'dominion-snapshot' then
    Dominion.territories = {}
    for _, t in ipairs(data.territories or {}) do
      Dominion.territories[t.id] = t
      syncContestEffect(t)
    end
    changed()
  elseif data.topic == 'dominion-update' then
    if data.territory then
      Dominion.territories[data.territory.id] = data.territory
      syncContestEffect(data.territory)
    end
    changed()
  elseif data.topic == 'dominion-detail' then
    Dominion.detail = data
    changed()
  elseif data.topic == 'dominion-action-result' then
    if data.ok == false and data.message then
      -- surface claim/siege errors in console; the host UI also shows them
      local w = data.message
      if w then print('[Dominion] ' .. w) end
    end
    Dominion.requestSnapshot()
  end
  return true
end

function init()
  -- try the dominion-only clone first; fall back to the raw dat effect
  local ok, err = pcall(function()
    g_attachedEffects.registerByThing(CONTEST_EFFECT_ID, 'dominion_contest', 1178, ThingCategoryEffect)
  end)
  if ok and g_attachedEffects.getById(CONTEST_EFFECT_ID) then
    contestEffectId = CONTEST_EFFECT_ID
  elseif g_attachedEffects.getById(1178) then
    contestEffectId = 1178
    print('[Dominion] clone registration failed (' .. tostring(err) .. '), using raw effect 1178')
  else
    print('[Dominion] ERROR: no contest effect available: ' .. tostring(err))
  end

  ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)
  connect(g_game, { onGameStart = function()
    addEvent(function() Dominion.requestSnapshot() end)
  end })
end

function terminate()
  ProtocolGame.unregisterExtendedOpcode(OPCODE)
  disconnect(g_game, { onGameStart = function() Dominion.requestSnapshot() end })
end

modules.game_dominion = Dominion
