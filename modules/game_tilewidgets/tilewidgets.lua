-- modules/game_tilewidgets/tilewidgets.lua

modules.game_tilewidgets = {}
local M = modules.game_tilewidgets

local registry = {}
local desired = {}
local ensureEvent = nil
local ENSURE_INTERVAL_MS = 500 -- interval for reattaching labels when tiles re-enter awareness
local ENSURE_BATCH = 120       -- max items processed per tick (prevents long frames)
local ensureIndex = 0          -- round-robin index into desired keys
local onGameStartHandler = nil -- keep reference so we can disconnect properly
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

local function startEnsureLoop()
  if ensureEvent then return end
  local function loop()
    ensureEvent = nil
    if not g_game.isOnline() then
      -- stop loop while offline
      return
    end
    local keys = {}
    for k in pairs(desired) do keys[#keys+1] = k end
    local total = #keys
    if total == 0 then
      -- nothing to do; stop until items are added again
      return
    end
    -- round-robin process up to ENSURE_BATCH entries
    ensureIndex = (ensureIndex % total) + 1
    local processed = 0
    local lp = g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
    local playerPos = lp and lp:getPosition() or nil
    local playerZ = playerPos and playerPos.z or nil
    -- modest culling radius to avoid touching far tiles unnecessarily
    local CULL_RADIUS = 30
    while processed < ENSURE_BATCH and processed < total do
      local idx = ((ensureIndex + processed - 1) % total) + 1
      local key = keys[idx]
      local entry = desired[key]
      if entry then
        local sameFloor = (playerZ == nil) or (entry.pos and entry.pos.z == playerZ)
        if not sameFloor then
          -- destroy if present on different floor
          if registry[key] then destroyWidget(registry[key]); registry[key] = nil end
        else
          -- cull by distance if we know player pos
          local within = true
          if playerPos and entry.pos then
            local dx = math.abs((entry.pos.x or 0) - playerPos.x)
            local dy = math.abs((entry.pos.y or 0) - playerPos.y)
            within = (dx <= CULL_RADIUS and dy <= CULL_RADIUS)
          end
          if within then
            M.ensureLabelAttached(entry.pos, entry.text, entry.opts)
          end
        end
      end
      processed = processed + 1
    end
    ensureEvent = scheduleEvent(loop, ENSURE_INTERVAL_MS)
  end
  ensureEvent = scheduleEvent(loop, ENSURE_INTERVAL_MS)
end

function M.init()
  registry = {}
  desired = {}
  -- Clear any attached tile widgets when the game session ends
  connect(g_game, { onGameEnd = M.clearAll })
  -- Attach configured widgets when game starts (store handler to disconnect)
  onGameStartHandler = function()
    if TileWidgetsConfig then M.attachFromConfig(TileWidgetsConfig) end
  end
  connect(g_game, { onGameStart = onGameStartHandler })
  -- If already online (module reloaded), attach immediately
  if g_game.isOnline() and TileWidgetsConfig then
    M.attachFromConfig(TileWidgetsConfig)
  end
  -- Start ensure only when there is work; it will stop itself when desired is empty
  startEnsureLoop()
end

function M.terminate()
  -- Remove session hooks and clear widgets
  disconnect(g_game, { onGameEnd = M.clearAll })
  if onGameStartHandler then
    disconnect(g_game, { onGameStart = onGameStartHandler })
    onGameStartHandler = nil
  end
  if ensureEvent then
    removeEvent(ensureEvent)
    ensureEvent = nil
  end
  M.clearAll()
end

-- Ensures tile exists; retries if not yet in awareness
local function attachWhenReady(pos, createFn)
  -- Try once; if tile is missing, the ensure loop will handle it later.
  if not g_game.isOnline() then return nil end
  local tile = g_map.getTile(pos)
  if not tile then return nil end
  return createFn(tile)
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
  -- ensure loop might be stopped; restart if needed
  if not ensureEvent then
    startEnsureLoop()
  end
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
