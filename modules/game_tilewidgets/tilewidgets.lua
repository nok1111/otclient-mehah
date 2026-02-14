-- modules/game_tilewidgets/tilewidgets.lua

modules.game_tilewidgets = {}
local M = modules.game_tilewidgets

local registry = {}
local onGameStartHandler = nil -- keep reference so we can disconnect properly
local onPlayerPosChange = nil  -- handler for z-level changes
-- minimalist, event-driven version (no background loops)

local function posKey(pos)
  return string.format('%d:%d:%d', pos.x, pos.y, pos.z)
end

function M.attachFromConfig(cfg)
  if not cfg then return end
  if cfg.labels then
    for _, e in ipairs(cfg.labels) do
      if e.pos and e.text then
        M.addLabel(e.pos, e.text, e.opts)
      end
    end
  end
end

local function destroyWidget(w)
  if w and not w:isDestroyed() then
    w:destroy()
  end
end

function M.init()
  registry = {}
  -- Clear any attached tile widgets when the game session ends
  connect(g_game, { onGameEnd = M.clearAll })
  -- Attach configured widgets when game starts (store handler to disconnect)
  onGameStartHandler = function()
    -- attach only for current floor
    M.attachForCurrentFloor()
    -- connect to local player position changes to track z-level changes
    local lp = g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
    if lp then
      onPlayerPosChange = function(newPos, oldPos)
        if not oldPos or not newPos then return end
        if newPos.z ~= oldPos.z then
          M.clearAll()
          M.attachForCurrentFloor()
        end
      end
      connect(lp, { onPositionChange = onPlayerPosChange })
    end
  end
  connect(g_game, { onGameStart = onGameStartHandler })
  -- If already online (module reloaded), attach immediately
  if g_game.isOnline() then
    onGameStartHandler()
  end
end

function M.terminate()
  -- Remove session hooks and clear widgets
  disconnect(g_game, { onGameEnd = M.clearAll })
  if onGameStartHandler then
    disconnect(g_game, { onGameStart = onGameStartHandler })
    onGameStartHandler = nil
  end
  -- disconnect player hook if any
  local lp = g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
  if lp and onPlayerPosChange then
    disconnect(lp, { onPositionChange = onPlayerPosChange })
    onPlayerPosChange = nil
  end
  M.clearAll()
end

-- Try to attach immediately if tile is available and same Z
local function attachIfReady(pos, text, opts)
  if not g_game.isOnline() then return nil end
  local lp = g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
  local playerPos = lp and lp:getPosition() or nil
  if playerPos and pos and pos.z and playerPos.z and pos.z ~= playerPos.z then
    return nil
  end
  local tile = g_map.getTile(pos)
  if not tile then return nil end
  local key = posKey(pos)
  local w = g_ui.createWidget((opts and opts.style) or 'Panel')
  w:setPhantom(true)
  w:setFocusable(false)
  if w.setText then w:setText(text or '') end
  if w.setFont and opts and opts.font then w:setFont(opts.font) end
  if w.setBackgroundColor and opts and opts.bg then w:setBackgroundColor(opts.bg) end
  if w.setColor and opts and opts.color then w:setColor(opts.color) end
  if w.setTextAlign then w:setTextAlign(AlignCenter) end
  if w.setSize then
    local wth = (opts and opts.width) or 90
    local hgt = (opts and opts.height) or 22
    w:setSize({ width = wth, height = hgt })
  end
  if w.setMarginBottom then w:setMarginBottom((opts and opts.marginBottom) or 40) end
  if w.setMarginTop then w:setMarginTop((opts and opts.marginTop) or 0) end
  if w.setMarginLeft then w:setMarginLeft((opts and opts.marginLeft) or 0) end
  if w.setMarginRight then w:setMarginRight((opts and opts.marginRight) or 0) end
  tile:attachWidget(w)
  registry[key] = w
  return w
end

-- Public API
function M.addLabel(pos, text, opts)
  opts = opts or {}
  -- remove any previous widget at the same position
  M.remove(pos)
  return attachIfReady(pos, text, opts)
end

-- Note: image-based tile widgets intentionally unsupported in this minimal version

function M.update(pos, newText)
  local w = registry[posKey(pos)]
  if w and w.setText then w:setText(newText or '') end
end

function M.remove(pos)
  local key = posKey(pos)
  destroyWidget(registry[key])
  registry[key] = nil
end

function M.clearAll()
  for k, w in pairs(registry) do
    destroyWidget(w)
    registry[k] = nil
  end
end

-- Attach labels from config filtered to the player's current floor
function M.attachForCurrentFloor()
  if not g_game.isOnline() then return end
  local lp = g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
  local playerPos = lp and lp:getPosition() or nil
  if not playerPos then return end
  if not TileWidgetsConfig or not TileWidgetsConfig.labels then return end
  for _, e in ipairs(TileWidgetsConfig.labels) do
    local p = e.pos
    if p and p.z == playerPos.z then
      -- distance-based culling
      local dx = math.abs((p.x or 0) - playerPos.x)
      local dy = math.abs((p.y or 0) - playerPos.y)
      local RADIUS = 16
      if dx <= RADIUS and dy <= RADIUS then
        -- try to attach (silently skips if tile not ready)
        attachIfReady(p, e.text, e.opts)
      end
    end
  end
end
