-- Faction reputation window. Server: data/lib/reputations.lua
-- (Reputations.sendList -> ExtendedOPCodes.CODE_REPUTATIONS, JSON payload
-- { action = "open"|"update"|"close", data = { {id, name, zone, cur, max,
--   status, tier, color?, tierMin, nextTierMin}, ... } }).

local CODE_REPUTATIONS = 236

local STATUS_COLORS = {
  hated = '#de6f6f',
  stranger = '#c0c0c0',
  known = '#FFFF00',
  friend = '#00BC00',
  friendly = '#00BC00',
}
local DEFAULT_STATUS_COLOR = '#dfdfdf'

local window
local listPanel
local emptyLabel
local rows = {}

local function updateRow(row, entry)
  local cur = tonumber(entry.cur) or 0
  local max = tonumber(entry.max) or 0
  local low = tonumber(entry.tierMin) or 0
  local high = tonumber(entry.nextTierMin) or max
  if cur >= max then
    low, high = 0, math.max(max, 1)
  end

  row.name:setText(tr(entry.name or entry.id))
  local zone = entry.zone or ''
  if zone ~= '' then
    row:setTooltip(tr(zone))
  else
    row:removeTooltip()
  end

  row.bar:setValue(math.min(cur, high), low, math.max(high, low + 1))
  row.bar:setText(string.format('%d / %d', cur, high))

  row.status:setText(tr(entry.status or ''))
  row.status:setColor(entry.color or STATUS_COLORS[entry.tier] or DEFAULT_STATUS_COLOR)
end

local function refresh(list)
  local seen = {}
  for index, entry in ipairs(list) do
    if type(entry) == 'table' and entry.id then
      local row = rows[entry.id]
      if not row then
        row = g_ui.createWidget('ReputationRow', listPanel)
        row.name = row:getChildById('name')
        row.bar = row:getChildById('bar')
        row.status = row:getChildById('status')
        rows[entry.id] = row
      end
      listPanel:moveChildToIndex(row, index)
      updateRow(row, entry)
      seen[entry.id] = true
    end
  end

  for id, row in pairs(rows) do
    if not seen[id] then
      row:destroy()
      rows[id] = nil
    end
  end

  emptyLabel:setVisible(next(rows) == nil)
end

function show()
  if not window then return end
  window:show()
  window:raise()
  window:focus()
end

function hide()
  if window then
    window:hide()
  end
end

local function onExtendedOpcode(protocol, opcode, buffer)
  local ok, payload = pcall(json.decode, buffer)
  if not ok or type(payload) ~= 'table' then
    g_logger.error('game_reputations: invalid payload: ' .. tostring(payload))
    return
  end

  if payload.action == 'open' then
    refresh(payload.data or {})
    show()
  elseif payload.action == 'update' then
    refresh(payload.data or {})
  elseif payload.action == 'close' then
    hide()
  end
end

function init()
  g_ui.importStyle('game_reputations')
  window = g_ui.createWidget('ReputationsWindow', rootWidget)
  window:hide()
  listPanel = window:recursiveGetChildById('reputationList')
  emptyLabel = window:recursiveGetChildById('emptyLabel')

  ProtocolGame.registerExtendedOpcode(CODE_REPUTATIONS, onExtendedOpcode)
  connect(g_game, { onGameEnd = hide })
end

function terminate()
  disconnect(g_game, { onGameEnd = hide })
  ProtocolGame.unregisterExtendedOpcode(CODE_REPUTATIONS)
  rows = {}
  if window then
    window:destroy()
    window = nil
  end
end
