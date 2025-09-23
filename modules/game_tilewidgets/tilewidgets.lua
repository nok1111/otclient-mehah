-- modules/game_tilewidgets/tilewidgets.lua

modules.game_tilewidgets = {}
local M = modules.game_tilewidgets

local registry = {}
local desired = {}
local ensureEvent = nil
local ENSURE_INTERVAL_MS = 500 -- interval for reattaching labels when tiles re-enter awareness
-- no fade effects

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
  desired = {}
  -- Clear any attached tile widgets when the game session ends
  connect(g_game, { onGameEnd = M.clearAll })
  -- Attach configured widgets when game starts
  connect(g_game, { onGameStart = function()
    if TileWidgetsConfig then M.attachFromConfig(TileWidgetsConfig) end
  end })
  -- If already online (module reloaded), attach immediately
  if g_game.isOnline() and TileWidgetsConfig then
    M.attachFromConfig(TileWidgetsConfig)
  end
  -- Start periodic ensure loop (labels only)
  local function loop()
    ensureEvent = nil
    if g_game.isOnline() then
      local lp = g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
      local playerPos = lp and lp:getPosition() or nil
      local playerZ = playerPos and playerPos.z or nil
      for key, entry in pairs(desired) do
        if playerZ and entry.pos and entry.pos.z then
          if entry.pos.z ~= playerZ then
            -- Different floor: ensure it's not present
            local w = registry[key]
            if w then
              destroyWidget(w)
              registry[key] = nil
            end
            -- skip creation on other floors
          else
            -- Same floor: ensure attached
            M.ensureLabelAttached(entry.pos, entry.text, entry.opts)
          end
        else
          -- Fallback if we can't read player Z
          M.ensureLabelAttached(entry.pos, entry.text, entry.opts)
        end
      end
    end
    ensureEvent = scheduleEvent(loop, ENSURE_INTERVAL_MS)
  end
  ensureEvent = scheduleEvent(loop, ENSURE_INTERVAL_MS)
end

function M.terminate()
  -- Remove session hooks and clear widgets
  disconnect(g_game, { onGameEnd = M.clearAll })
  disconnect(g_game, { onGameStart = function() end }) -- ensure disconnect of anonymous connect
  if ensureEvent then
    removeEvent(ensureEvent)
    ensureEvent = nil
  end
  M.clearAll()
end

-- Ensures tile exists; retries if not yet in awareness
local function attachWhenReady(pos, createFn)
  -- If not online yet, wait a bit and try again to avoid unnecessary g_map calls
  if not g_game.isOnline() then
    scheduleEvent(function() attachWhenReady(pos, createFn) end, 500)
    return
  end
  local tile = g_map.getTile(pos)
  if not tile then
    scheduleEvent(function() attachWhenReady(pos, createFn) end, 500)
    return
  end
  local w = createFn(tile)
  return w
end

-- Create label only if it's missing or detached; avoids flicker
function M.ensureLabelAttached(pos, text, opts)
  local key = posKey(pos)
  local tile = g_map.getTile(pos)
  -- Respect floor: only attach on same Z as player
  local lp = g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
  local playerPos = lp and lp:getPosition() or nil
  if playerPos and pos and pos.z and playerPos.z and pos.z ~= playerPos.z then
    local existing = registry[key]
    if existing then
      destroyWidget(existing)
      registry[key] = nil
    end
    return
  end
  if not tile then
    -- will be retried by the ensure loop later
    return
  end
  local w = registry[key]
  if w and not w:isDestroyed() and w.getParent and w:getParent() == tile then
    return w
  end
  -- Create without removing (to avoid flicker if a stale widget is still fading out)
  local function create(tileArg)
    local neww = g_ui.createWidget(opts and opts.style or 'Panel')
    neww:setPhantom(true)
    neww:setFocusable(false)
    if neww.setText then neww:setText(text or '') end
    if neww.setFont and opts and opts.font then neww:setFont(opts.font) end
    if neww.setBackgroundColor and opts and opts.bg then neww:setBackgroundColor(opts.bg) end
    if neww.setColor and opts and opts.color then neww:setColor(opts.color) end
    if neww.setTextAlign then neww:setTextAlign(AlignCenter) end
    if neww.setSize then
      local wth = (opts and opts.width) or 90
      local hgt = (opts and opts.height) or 22
      neww:setSize({ width = wth, height = hgt })
    end
    if neww.setMarginBottom then neww:setMarginBottom((opts and opts.marginBottom) or 40) end
    if neww.setMarginTop then neww:setMarginTop((opts and opts.marginTop) or 0) end
    if neww.setMarginLeft then neww:setMarginLeft((opts and opts.marginLeft) or 0) end
    if neww.setMarginRight then neww:setMarginRight((opts and opts.marginRight) or 0) end
    tileArg:attachWidget(neww)
    registry[key] = neww
    return neww
  end
  return attachWhenReady(pos, create)
end

-- Public API
function M.addLabel(pos, text, opts)
  opts = opts or {}
  local key = posKey(pos)
  M.remove(pos)

  local function create(tile)
    local w = g_ui.createWidget(opts.style or 'Panel')
    w:setPhantom(true)
    w:setFocusable(false)
    if w.setText then w:setText(text or '') end
    if w.setFont and opts.font then w:setFont(opts.font) end
    if w.setBackgroundColor and opts.bg then w:setBackgroundColor(opts.bg) end
    if w.setColor and opts.color then w:setColor(opts.color) end
    if w.setTextAlign then w:setTextAlign(AlignCenter) end

    if w.setSize then
      w:setSize({ width = opts.width or 90, height = opts.height or 22 })
    end

    if w.setMarginBottom then w:setMarginBottom(opts.marginBottom or 40) end
    if w.setMarginTop then w:setMarginTop(opts.marginTop or 0) end
    if w.setMarginLeft then w:setMarginLeft(opts.marginLeft or 0) end
    if w.setMarginRight then w:setMarginRight(opts.marginRight or 0) end

    tile:attachWidget(w)
    registry[key] = w
    return w
  end

  -- Track desired label for auto-reattach
  local p = pos
  if p and p.x and p.y and p.z then
    p = { x = p.x, y = p.y, z = p.z }
  end
  desired[key] = { pos = p, text = text, opts = opts }
  -- Only attach immediately if on the same floor; otherwise wait for ensure loop
  local lp = g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
  local playerPos = lp and lp:getPosition() or nil
  if playerPos and p and p.z and playerPos.z and p.z ~= playerPos.z then
    return nil
  end
  return attachWhenReady(pos, create)
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
  desired[key] = nil
end

function M.clearAll()
  for k, w in pairs(registry) do
    destroyWidget(w)
    registry[k] = nil
  end
  desired = {}
end
