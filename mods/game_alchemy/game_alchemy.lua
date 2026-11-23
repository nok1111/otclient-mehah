Alchemy = {}

local ALCHEMY_OPCODE = 239 -- 237 = game_dominion, 238 = guild management

local alchemyWindow = nil
local snapshot = nil      -- last AL_OPEN_WINDOW / AL_UPDATE payload
local cauldron = nil      -- last AL_CAULDRON payload ({order, cdRemaining, hint, unstable})
local currentTab = 'botPage'
local tabButtons = {}
local cauldronClientId = 0

-- boticario tab state
local botSearch = ''
local selectedRecipe = nil  -- recipe entry currently shown in the detail pane
local brewAmount = 1

-- cauldron tab state
local matCells = {}         -- reagent itemId -> cell widget (fixed slots)
local brewCdLeft = 0        -- seconds left on the discovery cooldown
local cdFetchedAt = 0       -- os.clock() when cdRemaining was received
local cdTickEvent = nil
local cdTick = nil          -- forward decl: recursive ticker

-- progress/spec tab state
local specData = nil

-- chunked payload accumulators (server splits big lists: {part,total,list})
local recipeParts = nil
local reagentParts = nil

local ODD_DEFS = {
  { key = 'weak',     label = 'Weak',     color = '#c0c0c0' },
  { key = 'standard', label = 'Standard', color = '#dfdfdf' },
  { key = 'potent',   label = 'Potent',   color = '#80c7f8' },
  { key = 'perfect',  label = 'Perfect',  color = '#ff7605' },
}

local TABS = {
  { button = 'tabBot',      page = 'botPage' },
  { button = 'tabCauldron', page = 'cauldronPage' },
  { button = 'tabSpec',     page = 'specPage' },
  { button = 'tabProg',     page = 'progressPage' },
}

-- fixed grid order for the cauldron reagent slots
local GROUP_ORDER = { herbs = 1, samples = 2, essences = 3, vessels = 4, brews = 5 }

local BLACKOUT_SHADER = 'Blackout'

-- Shown by mods/game_tooltips when hovering a locked recipe icon (the widget
-- exposes getItemTooltip()). Must carry the full payload shape buildItemTooltip
-- reads (same fields game_blacksmith uses) or it errors on nil fields.
local LOCKED_TOOLTIP = {
  id = 0, name = '?????', desc = 'An unknown recipe - discover it at the cauldron.',
  iLvl = 0, rarity = 0, count = 1, type = 'Common',
  first = 0, second = 0, third = 0, weight = 0, uLvl = 0,
  maxAttributes = 0, attributes = {},
}

-- ============================================================
-- helpers
-- ============================================================

local function setLabel(id, text, color)
  local w = alchemyWindow and alchemyWindow:recursiveGetChildById(id)
  if w then
    w:setText(text or '')
    if color then w:setColor(color) end
  end
  return w
end

local function fmtTime(secs)
  secs = math.max(0, math.floor(secs or 0))
  local h = math.floor(secs / 3600)
  local m = math.floor((secs % 3600) / 60)
  local s = secs % 60
  if h > 0 then return string.format('%dh %dm', h, m) end
  if m > 0 then return string.format('%dm %ds', m, s) end
  return string.format('%ds', s)
end

local function fmtGold(n)
  local s = tostring(n or 0)
  local out = s:reverse():gsub('(%d%d%d)', '%1,'):reverse()
  return out:gsub('^,', '')
end

-- step opacity toward a target over `ms` (30ms ticks), then call onDone
local function fadeTo(w, target, ms, onDone)
  local start = w:getOpacity()
  local elapsed = 0
  local function step()
    if w:isDestroyed() then return end
    elapsed = elapsed + 30
    local t = math.min(elapsed / ms, 1)
    w:setOpacity(start + (target - start) * t)
    if t < 1 then scheduleEvent(step, 30)
    elseif onDone then onDone() end
  end
  scheduleEvent(step, 30)
end

-- overlays correct.png/incorrect.png on a reagent/mix cell; fades in to 85%
-- (15% transparency), holds, fades out — total lifetime ~2s
local function flashIcon(cell, img)
  if not cell then return end
  local old = cell:recursiveGetChildById('mixCheck')
  if old then old:destroy() end
  local w = g_ui.createWidget('UIWidget', cell)
  w:setId('mixCheck')
  w:setImageSource('/images/icons/' .. img)
  w:setSize('16 16')
  w:setPhantom(true)
  w:setOpacity(0)
  w:addAnchor(AnchorTop, 'parent', AnchorTop)
  w:addAnchor(AnchorRight, 'parent', AnchorRight)
  w:setMarginTop(1)
  w:setMarginRight(2)
  fadeTo(w, 0.85, 300)
  scheduleEvent(function()
    if w and not w:isDestroyed() then
      fadeTo(w, 0, 300, function() if not w:isDestroyed() then w:destroy() end end)
    end
  end, 1700)
  scheduleEvent(function()
    if w and not w:isDestroyed() then w:destroy() end
  end, 2000)
end

-- ============================================================
-- lifecycle
-- ============================================================

function Alchemy.init()
  connect(g_game, { onGameEnd = Alchemy.hide })
  ProtocolGame.registerExtendedOpcode(ALCHEMY_OPCODE, Alchemy.onExtendedOpcode)
end

function Alchemy.terminate()
  disconnect(g_game, { onGameEnd = Alchemy.hide })
  ProtocolGame.unregisterExtendedOpcode(ALCHEMY_OPCODE)
  Alchemy.hide()
end

function Alchemy.show()
  if not alchemyWindow then
    local ok, result = pcall(function()
      return g_ui.loadUI('game_alchemy', modules.game_interface.getRootPanel())
    end)
    if not ok or not result then
      print('[Alchemy][Client] ERROR: Failed to load game_alchemy UI: ' .. tostring(result))
      return
    end
    alchemyWindow = result
    Alchemy.wireUp()
    alchemyWindow:hide()
  end

  alchemyWindow:show()
  alchemyWindow:raise()
  alchemyWindow:focus()
  Alchemy.selectTab(currentTab)
  Alchemy.startCdTicker()
end

-- One-time widget wiring done on first show (widgets exist by then).
function Alchemy.wireUp()
  for _, t in ipairs(TABS) do
    local btn = alchemyWindow:recursiveGetChildById(t.button)
    if btn then
      tabButtons[t.page] = btn
      btn.onClick = function()
        Alchemy.selectTab(t.page)
      end
    end
  end

  -- boticario: search box
  local search = alchemyWindow:recursiveGetChildById('botSearch')
  if search then
    search.onTextChange = function(self, text)
      botSearch = (text or ''):lower()
      Alchemy.renderRecipeGrid()
    end
  end

  local brewBtn = alchemyWindow:recursiveGetChildById('brewButton')
  if brewBtn then
    brewBtn.onClick = function()
      if selectedRecipe then
        Alchemy.send('AL_CRAFT', { recipeId = selectedRecipe.index, amount = brewAmount })
      end
    end
  end

  local brewMax = alchemyWindow:recursiveGetChildById('brewMaxButton')
  if brewMax then
    brewMax.onClick = function()
      if selectedRecipe then
        brewAmount = math.max(1, selectedRecipe.maxBatch or 1)
        Alchemy.updateBatchWidgets()
      end
    end
  end

  local detSlider = alchemyWindow:recursiveGetChildById('detSlider')
  if detSlider then
    detSlider.onValueChange = function(self, value)
      brewAmount = math.max(1, math.round(value))
      Alchemy.updateBatchWidgets()
    end
  end

  -- cauldron
  local mixBrew = alchemyWindow:recursiveGetChildById('mixBrewButton')
  if mixBrew then
    mixBrew.onClick = function()
      Alchemy.send('AL_BREW', {})
    end
  end

  local clearBtn = alchemyWindow:recursiveGetChildById('caulClearButton')
  if clearBtn then
    clearBtn.onClick = function()
      Alchemy.send('AL_REMOVE', { all = true })
    end
  end

  local closeButton = alchemyWindow:recursiveGetChildById('closeButton')
  if closeButton then
    closeButton.onClick = function()
      Alchemy.hide()
    end
  end
end

function Alchemy.hide()
  if cdTickEvent then
    removeEvent(cdTickEvent)
    cdTickEvent = nil
  end
  if alchemyWindow then
    Alchemy.send('AL_CLOSE', {})
    alchemyWindow:hide()
  end
end

function Alchemy.send(event, data)
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    protocolGame:sendExtendedOpcode(ALCHEMY_OPCODE, json.encode({ e = event, d = data }))
  end
end

function Alchemy.selectTab(pageId)
  currentTab = pageId
  if not alchemyWindow then return end
  for _, t in ipairs(TABS) do
    local page = alchemyWindow:recursiveGetChildById(t.page)
    local btn = tabButtons[t.page]
    local active = (t.page == pageId)
    if page then page:setVisible(active) end
    if btn then btn:setColor(active and '#80c7f8' or '#dfdfdf') end
  end
  if pageId == 'cauldronPage' then
    Alchemy.send('AL_MIX_INFO', {})
  end
end

-- ============================================================
-- snapshot -> all tabs
-- ============================================================

-- Merge a {part,total,list} chunk; returns the full list once all parts
-- arrived, plus the accumulator to keep otherwise.
local function accumulate(parts, data)
  parts = parts or {}
  parts[data.part or 1] = data.list or {}
  local received = 0
  for _ in pairs(parts) do received = received + 1 end
  if received >= (data.total or 1) then
    local all = {}
    for i = 1, data.total or 1 do
      for _, v in ipairs(parts[i] or {}) do all[#all + 1] = v end
    end
    return all, nil
  end
  return nil, parts
end

function Alchemy.applySnapshot(data)
  if not alchemyWindow or not data then return end
  -- meta packet only: recipes/reagents arrive as AL_RECIPES/AL_REAGENTS chunks
  snapshot = snapshot or {}
  for _, k in ipairs({ 'level', 'pct', 'nextLevel', 'points', 'rank', 'gold',
    'buffs', 'oil', 'spec', 'progression', 'cauldronClientId', 'brewCd' }) do
    snapshot[k] = data[k]
  end
  specData = data.spec
  recipeParts = nil
  reagentParts = nil

  if data.cauldronClientId and data.cauldronClientId > 0 then
    cauldronClientId = data.cauldronClientId
  end
  if data.brewCd then
    brewCdLeft = data.brewCd
    cdFetchedAt = os.clock()
    Alchemy.updateBrewButton()
  end

  -- header
  setLabel('headerLevel', tr('Alchemy Lv. %d', data.level or 0), '#80c7f8')
  setLabel('headerRank', trServerMsg(data.rank or ''), '#dfdfdf')
  setLabel('headerGold', tr('%s gold', fmtGold(data.gold or 0)), '#c0c0c0')
  local xpBar = alchemyWindow:recursiveGetChildById('xpBar')
  if xpBar then xpBar:setPercent(data.pct or 0) end
  if (data.nextLevel or 0) > 0 then
    setLabel('xpLabel', tr('%d / %d XP', data.points or 0, data.nextLevel), '#c0c0c0')
  else
    setLabel('xpLabel', tr('MAX'), '#c0c0c0')
  end

  Alchemy.renderProgress()
  Alchemy.renderSpec()
end

-- AL_RECIPES {part,total,list}
function Alchemy.onRecipes(data)
  if not data then return end
  snapshot = snapshot or {}
  local all
  all, recipeParts = accumulate(recipeParts, data)
  if not all then return end
  snapshot.recipes = all

  -- keep the detail pane in sync after a refresh (index is stable)
  if selectedRecipe then
    for _, r in ipairs(all) do
      if r.index == selectedRecipe.index then selectedRecipe = r break end
    end
  end

  Alchemy.renderRecipeGrid()
  Alchemy.renderRecipeDetail()
end

-- AL_REAGENTS {part,total,list}
function Alchemy.onReagents(data)
  if not data then return end
  snapshot = snapshot or {}
  local all
  all, reagentParts = accumulate(reagentParts, data)
  if not all then return end
  snapshot.reagents = all
  Alchemy.renderMatGrid()
end

-- ============================================================
-- BOTICARIO tab: recipe grid + detail
-- ============================================================

function Alchemy.renderRecipeGrid()
  if not alchemyWindow or not snapshot then return end
  local grid = alchemyWindow:recursiveGetChildById('botGrid')
  if not grid then return end
  grid:destroyChildren()

  for _, r in ipairs(snapshot.recipes or {}) do
    local nameOk = botSearch == ''
      or (r.name and r.name:lower():find(botSearch, 1, true) ~= nil)
    if nameOk then
      local cell = g_ui.createWidget('AlRecCell', grid)
      if cell then
        local icon = cell:recursiveGetChildById('gIcon')
        local name = cell:recursiveGetChildById('gName')
        local tier = cell:recursiveGetChildById('gTier')

        if icon then
          icon:setItemId(r.clientId or 0)
          -- locked recipes show as a black silhouette (unlockable-character look)
          icon:setShader(r.locked and BLACKOUT_SHADER or '')
          if r.locked then icon:setOpacity(0.85) end
          -- game_tooltips resolves virtual UIItems by clientId -> would leak
          -- the hidden recipe name; give locked icons a mystery tooltip
          icon.getItemTooltip = r.locked and function() return LOCKED_TOOLTIP end or nil
        end
        if name then
          name:setText(r.locked and tr('?????')
            or string.format('%s x%d', r.name or '?', r.count or 1))
          name:setColor(r.locked and '#dfdfdf88' or '#dfdfdf')
        end
        if tier then tier:setText(tr('Lv.%d', r.requiredSkill or 0)) end

        if selectedRecipe and selectedRecipe.index == r.index then
          cell:setBorderColor('#80c7f8')
          cell:setBackgroundColor('#355d8933')
        end

        local recipe = r
        cell.onMouseRelease = function(self, pos, mb)
          if mb ~= MouseLeftButton or not self:containsPoint(pos) then return false end
          Alchemy.selectRecipe(recipe)
          return true
        end
      end
    end
  end
end

function Alchemy.selectRecipe(r)
  selectedRecipe = r
  brewAmount = 1
  Alchemy.renderRecipeGrid() -- refresh selection highlight
  Alchemy.renderRecipeDetail()
end

local function fillOdds(rowId, odds)
  local row = alchemyWindow and alchemyWindow:recursiveGetChildById(rowId)
  if not row then return end
  row:destroyChildren()
  if not odds then return end
  for _, def in ipairs(ODD_DEFS) do
    local cell = g_ui.createWidget('AlOddCell', row)
    if cell then
      local nm = cell:recursiveGetChildById('oddName')
      local pc = cell:recursiveGetChildById('oddPct')
      if nm then
        nm:setText(def.label)
        nm:setColor(def.color)
      end
      if pc then
        -- server odds are already percentages (0-100)
        pc:setText(string.format('%d%%', math.floor((odds[def.key] or 0) + 0.5)))
        pc:setColor(def.color)
      end
    end
  end
end

local function fillIngs(rowId, ings)
  local row = alchemyWindow and alchemyWindow:recursiveGetChildById(rowId)
  if not row then return end
  row:destroyChildren()
  for _, ing in ipairs(ings or {}) do
    local cell = g_ui.createWidget('AlIngCell', row)
    if cell then
      local icon = cell:recursiveGetChildById('iIcon')
      local cnt = cell:recursiveGetChildById('iCnt')
      local nm = cell:recursiveGetChildById('iName')
      if icon then icon:setItemId(ing.clientId or 0) end
      if cnt then
        cnt:setText(string.format('%d/%d', ing.have or 0, ing.need or 1))
        cnt:setColor((ing.have or 0) >= (ing.need or 1) and '#00BC00' or '#de6f6f')
      end
      if nm then nm:setText(ing.name or '') end
    end
  end
end

function Alchemy.renderRecipeDetail()
  if not alchemyWindow then return end
  local r = selectedRecipe
  local visible = r ~= nil
  for _, id in ipairs({ 'detOdds', 'detIngs', 'detBatch', 'brewButton', 'brewMaxButton' }) do
    local w = alchemyWindow:recursiveGetChildById(id)
    if w then w:setVisible(visible) end
  end
  if not r then
    setLabel('detName', tr('Select a recipe'), '#dfdfdf')
    setLabel('detTier', '')
    setLabel('detDesc', '')
    setLabel('detMeta', '')
    local icon = alchemyWindow:recursiveGetChildById('detIcon')
    if icon then icon:setItemId(0) end
    return
  end

  local icon = alchemyWindow:recursiveGetChildById('detIcon')
  if icon then
    icon:setItemId(r.clientId or 0)
    icon:setShader(r.locked and BLACKOUT_SHADER or '')
    icon.getItemTooltip = r.locked and function() return LOCKED_TOOLTIP end or nil
  end
  setLabel('detName', r.locked and tr('?????') or (r.name or '?'),
    r.locked and '#dfdfdf88' or '#dfdfdf')
  setLabel('detTier', tr('%s - Lv.%d', trServerMsg(r.category or ''), r.requiredSkill or 0), '#80c7f8')

  if r.locked then
    setLabel('detDesc', tr('A hidden recipe. Mix its ingredients in the cauldron to discover it.'), '#c0c0c0')
    setLabel('detMeta', tr('Needs %d reagents', r.ingCount or 0), '#c0c0c0')
  else
    local desc = r.desc and trServerMsg(r.desc) or ''
    if r.effectText and r.effectText ~= '' then
      desc = (desc ~= '' and (desc .. '  ') or '') .. r.effectText
    end
    setLabel('detDesc', desc, '#c0c0c0')
    local meta = tr('Yield x%d  -  +%d XP', (r.count or 1), r.craftPoints or 0)
    if (r.fame or 0) > 0 then meta = meta .. tr('  -  +%d fame', r.fame) end
    setLabel('detMeta', meta, '#c0c0c0')
  end

  -- odds
  fillOdds('detOddsRow', r.odds)
  local oddsPanel = alchemyWindow:recursiveGetChildById('detOdds')
  if oddsPanel then oddsPanel:setVisible(visible and r.hasPotency and not r.locked) end
  if r.odds and (r.odds.specBonus or 0) > 0 then
    setLabel('detOddsNote', tr('specialization bonus: +%d roll level', r.odds.specBonus), '#80c7f8')
  else
    setLabel('detOddsNote', '', '#c0c0c0')
  end

  -- ingredients
  local ingsPanel = alchemyWindow:recursiveGetChildById('detIngs')
  if ingsPanel then ingsPanel:setVisible(visible and not r.locked) end
  fillIngs('detIngRow', r.ingredients)

  -- batch
  local batchPanel = alchemyWindow:recursiveGetChildById('detBatch')
  if batchPanel then batchPanel:setVisible(visible and not r.locked) end
  local slider = alchemyWindow:recursiveGetChildById('detSlider')
  if slider then
    local maxB = math.max(1, r.maxBatch or 1)
    slider:setRange(1, maxB)
    slider:setValue(math.min(brewAmount, maxB))
    brewAmount = math.min(brewAmount, maxB)
  end
  local smax = alchemyWindow:recursiveGetChildById('detSliderMax')
  if smax then smax:setText(tostring(math.max(1, r.maxBatch or 1))) end
  Alchemy.updateBatchWidgets()

  -- brew button state
  local btn = alchemyWindow:recursiveGetChildById('brewButton')
  if btn then
    local ok = r.canCraft and not r.locked
    btn:setEnabled(ok)
    btn:setColor(ok and '#dfdfdf' or '#dfdfdf88')
    if r.levelLocked then
      setLabel('statusLabel', tr('Requires Alchemy Level %d', r.requiredSkill or 0), '#de6f6f')
    end
  end
  local maxBtn = alchemyWindow:recursiveGetChildById('brewMaxButton')
  if maxBtn then maxBtn:setVisible(visible and not r.locked) end
end

function Alchemy.updateBatchWidgets()
  if not alchemyWindow or not selectedRecipe then return end
  local r = selectedRecipe
  local maxB = math.max(1, r.maxBatch or 1)
  brewAmount = math.max(1, math.min(brewAmount, maxB))
  setLabel('detBatchTitle', tr('BATCH x%d (max %d)', brewAmount, maxB))
  local cost = (r.cost or 0) * brewAmount
  local yield = (r.count or 1) * brewAmount
  setLabel('detCost', tr('Cost: %s gold - yields %d', fmtGold(cost), yield), '#c0c0c0')
end

-- ============================================================
-- CAULDRON tab: reagent grid + ordered mix
-- ============================================================

local GROUP_LABELS = {
  herbs = 'herb', samples = 'sample', essences = 'essence',
  vessels = 'vessel', brews = 'brew',
}

function Alchemy.renderMatGrid()
  if not alchemyWindow or not snapshot then return end
  local grid = alchemyWindow:recursiveGetChildById('matGrid')
  if not grid then return end
  grid:destroyChildren()
  matCells = {}

  -- fixed positions: stable sort by group, then item id
  local sorted = {}
  for _, rg in ipairs(snapshot.reagents or {}) do sorted[#sorted + 1] = rg end
  table.sort(sorted, function(a, b)
    local ga = GROUP_ORDER[a.group] or 9
    local gb = GROUP_ORDER[b.group] or 9
    if ga ~= gb then return ga < gb end
    return (a.id or 0) < (b.id or 0)
  end)

  for _, rg in ipairs(sorted) do
    local cell = g_ui.createWidget('AlMatCell', grid)
    if cell then
      matCells[rg.id] = cell
      local icon = cell:recursiveGetChildById('mIcon')
      local name = cell:recursiveGetChildById('mName')
      local have = cell:recursiveGetChildById('mHave')

      if icon then icon:setItemId(rg.clientId or 0) end
      if name then
        name:setText(rg.name or '')
        name:setColor((rg.have or 0) > 0 and '#dfdfdf' or '#dfdfdf88')
      end
      local cost = rg.brewCost or 1
      if have then
        have:setText('x' .. cost)
        have:setColor((rg.have or 0) >= cost and '#c0c0c0' or '#de6f6f')
      end
      if (rg.have or 0) < cost then cell:setOpacity(0.45) end
      cell:setTooltip(string.format('%s (%s)\n%s\nYou have %d - each brew consumes %d', rg.name or '',
        GROUP_LABELS[rg.group] or '', rg.source or '', rg.have or 0, cost))

      local itemId = rg.id
      cell.onMouseRelease = function(self, pos, mb)
        if mb ~= MouseLeftButton or not self:containsPoint(pos) then return false end
        Alchemy.send('AL_PLACE', { itemId = itemId })
        return true
      end
    end
  end

  -- re-apply the order badges for any mix already placed
  Alchemy.updateOrderBadges()
end

function Alchemy.updateOrderBadges()
  if not alchemyWindow then return end
  local inMix = {}
  for _, p in ipairs(cauldron and cauldron.order or {}) do
    inMix[p.id] = true
  end
  for id, cell in pairs(matCells) do
    local badge = cell:recursiveGetChildById('mOrder')
    local pos = inMix[id]
    if badge then
      badge:setText(pos and '✓' or '')
      badge:setColor('#80c7f8')
    end
    if pos then
      cell:setBorderColor('#80c7f8')
      cell:setBackgroundColor('#355d8944')
    else
      cell:setBorderColor('#ffffff22')
      cell:setBackgroundColor('#00000066')
    end
  end
end

function Alchemy.renderCauldron(data)
  if not alchemyWindow then return end
  cauldron = data or {}

  -- cooldown
  brewCdLeft = data.cdRemaining or 0
  cdFetchedAt = os.clock()

  -- mix strip: always 3 slots so the player sees the recipe size at a glance
  local row = alchemyWindow:recursiveGetChildById('seqRow')
  if row then
    row:destroyChildren()
    for i = 1, 3 do
      local p = (cauldron.order or {})[i]
      local w = g_ui.createWidget('AlIngCell', row)
      if w then
        local icon = w:recursiveGetChildById('iIcon')
        local cnt = w:recursiveGetChildById('iCnt')
        local nm = w:recursiveGetChildById('iName')
        if p then
          if icon then icon:setItemId(p.clientId or 0) end
          if cnt then
            cnt:setText('x' .. (p.brewCost or 1))
            cnt:setColor('#80c7f8')
          end
          if nm then nm:setText(p.name or '') end
          w:setTooltip(tr('%s - click to remove from the mix', p.name or ''))
          local itemId = p.id
          w.mixItemId = itemId
          w.onMouseRelease = function(self, pos, mb)
            if mb ~= MouseLeftButton or not self:containsPoint(pos) then return false end
            Alchemy.send('AL_REMOVE', { itemId = itemId })
            return true
          end
        else
          if cnt then
            cnt:setText('?')
            cnt:setColor('#dfdfdf88')
          end
          w:setBorderWidth(1)
          w:setBorderColor('#ffffff33')
          w:setBackgroundColor('#00000033')
          w:setTooltip(tr('Empty slot - click a reagent on the left to add it'))
        end
      end
    end
  end

  Alchemy.updateOrderBadges()

  -- correct/incorrect overlay: server marks placed ids shared with a real
  -- recipe; placed ids NOT shared get the incorrect icon
  local correct = {}
  for _, id in ipairs(cauldron.correct or {}) do correct[id] = true end
  local showMarks = next(correct) ~= nil
  for id, cell in pairs(matCells) do
    if correct[id] then flashIcon(cell, 'correct.png') end
  end
  if row then
    for _, w in ipairs(row:getChildren()) do
      if w.mixItemId then
        if correct[w.mixItemId] then flashIcon(w, 'correct.png')
        elseif showMarks then flashIcon(w, 'incorrect.png') end
      end
    end
    -- also mark placed cells in the reagent grid that don't belong
    if showMarks then
      local placed = {}
      for _, p in ipairs(cauldron.order or {}) do placed[p.id] = true end
      for id, cell in pairs(matCells) do
        if placed[id] and not correct[id] then flashIcon(cell, 'incorrect.png') end
      end
    end
  end

  -- hint line
  if cauldron.hint == 'empty' or #(cauldron.order or {}) == 0 then
    setLabel('caulHint', tr('Click reagents to add them to the mix to discover new recipes.'), '#c0c0c0')
  elseif cauldron.unstable then
    setLabel('caulHint',
      tr('Unstable mix - something wants to form... BREW to discover a new recipe!'),
      '#ff7605')
  elseif cauldron.knownMatch then
    setLabel('caulHint',
      tr('This mix forms %s - you already know that recipe. Brewing just wastes the reagents.',
        cauldron.knownMatch), '#c0c0c0')
  else
    setLabel('caulHint', '', '#de6f6f')
  end

  Alchemy.updateBrewButton()
end

function Alchemy.updateBrewButton()
  if not alchemyWindow then return end
  local left = Alchemy.cdLeft()
  local btn = alchemyWindow:recursiveGetChildById('mixBrewButton')
  local hasMix = cauldron and #(cauldron.order or {}) > 0
  local disc = snapshot and snapshot.progression and snapshot.progression.discovery or {}
  local allLearned = (disc.total or 0) > 0 and (disc.learned or 0) >= disc.total
  if btn then
    local ok = hasMix and left <= 0 and not allLearned
    btn:setEnabled(ok)
    btn:setColor(ok and '#dfdfdf' or '#dfdfdf88')
  end
  if left > 0 then
    setLabel('brewCdLabel', tr('Cauldron settling: %s left', fmtTime(left)), '#de6f6f')
  elseif allLearned then
    setLabel('brewCdLabel', tr('You already know every recipe the cauldron can reveal.'), '#80c7f8')
  else
    setLabel('brewCdLabel', tr('Every brew consumes reagents by tier (5 ordinary / 2 rare / 1 high). Discoveries lock the cauldron 24h.'), '#c0c0c0')
  end
end

-- seconds left on the discovery cooldown (locally counted down)
function Alchemy.cdLeft()
  return math.max(0, brewCdLeft - (os.clock() - cdFetchedAt))
end

-- 1s ticker for the cooldown label
cdTick = function()
  cdTickEvent = nil
  if not alchemyWindow or not alchemyWindow:isVisible() then return end
  Alchemy.updateBrewButton()
  cdTickEvent = scheduleEvent(cdTick, 1000)
end

function Alchemy.startCdTicker()
  if cdTickEvent then removeEvent(cdTickEvent) end
  cdTickEvent = scheduleEvent(cdTick, 1000)
end

-- ============================================================
-- SPEC tab
-- ============================================================

function Alchemy.renderSpec()
  if not alchemyWindow or not snapshot then return end
  local spec = specData or snapshot.spec or {}
  local current = spec.current or 0
  local unlocked = spec.unlocked == true
  local reqLevel = spec.reqLevel or 15

  if current > 0 then
    local nm = ''
    for _, s in ipairs(spec.list or {}) do
      if s.id == current then nm = s.name end
    end
    setLabel('specStatus', tr('SPECIALIZATION - active: %s', nm), '#00BC00')
  elseif unlocked then
    setLabel('specStatus', tr('SPECIALIZATION - pick one (permanent)'), '#80c7f8')
  else
    setLabel('specStatus', tr('SPECIALIZATION - unlocks at Alchemy Lv.%d', reqLevel), '#c0c0c0')
  end

  local specList = alchemyWindow:recursiveGetChildById('specList')
  if specList then
    specList:destroyChildren()
    for _, s in ipairs(spec.list or {}) do
      local card = g_ui.createWidget('AlSpecCard', specList)
      if card then
        local icon = card:recursiveGetChildById('specIcon')
        local name = card:recursiveGetChildById('specName')
        local perksL = card:recursiveGetChildById('specPerks')
        local btn = card:recursiveGetChildById('specButton')
        if icon then icon:setItemId(s.iconClientId or 0) end
        if name then name:setText(trServerMsg(s.name or '')) end
        if perksL then perksL:setText(trServerMsg(s.desc or '')) end
        if btn then
          local isCurrent = s.id == current
          btn:setText(isCurrent and tr('ACTIVE')
            or (not unlocked and tr('Lv.%d', reqLevel) or tr('SELECT')))
          btn:setColor(isCurrent and '#00BC00' or '#dfdfdf')
          btn:setEnabled(unlocked and not isCurrent and current == 0)
          local specId = s.id
          btn.onClick = function()
            if isCurrent or current > 0 then return end
            if not unlocked then
              setLabel('statusLabel', tr('Specializations unlock at Alchemy Level %d', reqLevel), '#de6f6f')
              return
            end
            Alchemy.send('AL_CHOOSE_SPEC', { spec = specId })
          end
        end
        if s.id == current then card:setBorderColor('#00BC00') end
      end
    end
  end
end

-- ============================================================
-- PROGRESS tab
-- ============================================================

local function perkRow(parent, label, unlocked, reqLevel)
  local row = g_ui.createWidget('AlTierRow', parent)
  if not row then return end
  local mark = row:recursiveGetChildById('rowMark')
  local name = row:recursiveGetChildById('rowName')
  local req = row:recursiveGetChildById('rowReq')
  if mark then
    mark:setText(unlocked and 'v' or 'x')
    mark:setColor(unlocked and '#00BC00' or '#de6f6f')
  end
  if name then
    name:setText(label or '')
    name:setColor(unlocked and '#dfdfdf' or '#dfdfdf88')
  end
  if req then
    req:setText(unlocked and tr('UNLOCKED') or tr('Lv.%d', reqLevel or 0))
    req:setColor(unlocked and '#00BC00' or '#c0c0c0')
  end
end

function Alchemy.renderProgress()
  if not alchemyWindow or not snapshot then return end
  local prog = snapshot.progression or {}

  local perks = alchemyWindow:recursiveGetChildById('perksList')
  if perks then
    perks:destroyChildren()
    for _, p in ipairs(prog.perks or {}) do
      perkRow(perks, p.label, p.unlocked, p.reqLevel)
    end
    if prog.odds then
      perkRow(perks, tr('Potency: %d%% weak / %d%% potent / %d%% perfect',
        math.floor((prog.odds.weak or 0) + 0.5),
        math.floor((prog.odds.potent or 0) + 0.5),
        math.floor((prog.odds.perfect or 0) + 0.5)), true, 0)
    end
  end

  local disc = prog.discovery or {}
  local bar = alchemyWindow:recursiveGetChildById('discBar')
  if bar then
    bar:setPercent((disc.total or 0) > 0 and (disc.learned or 0) / disc.total * 100 or 0)
  end
  setLabel('discLabel', tr('%d / %d hidden recipes learned - mix reagents at the cauldron to discover more',
    disc.learned or 0, disc.total or 0), '#c0c0c0')
end

-- ============================================================
-- results / rejects
-- ============================================================

function Alchemy.onResult(data)
  if not data then return end
  local txt
  if data.success then
    local parts = {}
    if data.spec then
      parts[#parts + 1] = tr('Specialization learned: %s', data.name or data.spec)
    else
      parts[#parts + 1] = tr('Brewed %dx %s', data.count or 1, data.name or '')
      if data.potency and data.potency ~= 'standard' then
        parts[#parts + 1] = tr('[%s]', data.potency:upper())
      end
      if (data.craftPoints or 0) > 0 then
        parts[#parts + 1] = tr('+%d XP', data.craftPoints)
      end
    end
    if data.discovery then
      parts[#parts + 1] = tr('DISCOVERY: %s', data.discovery)
    end
    txt = table.concat(parts, ' ')
    setLabel('statusLabel', txt, '#00BC00')
    setLabel('mixMsg', txt, '#00BC00')
  else
    local color = (data.known or data.wrongOrder) and '#ff7605' or '#de6f6f'
    txt = trServerMsg(data.reason or 'Brew failed')
    setLabel('statusLabel', txt, color)
    setLabel('mixMsg', txt, color)
  end
end

function Alchemy.onRejected(data)
  setLabel('statusLabel', trServerMsg(data and data.reason or 'Not possible'), '#de6f6f')
end

-- ============================================================
-- opcode dispatch
-- ============================================================

function Alchemy.onExtendedOpcode(protocol, opcode, buffer)
  if opcode ~= ALCHEMY_OPCODE then return end

  local ok, packet = pcall(function() return json.decode(buffer) end)
  if not ok or type(packet) ~= 'table' then return end

  local event = packet.e
  local data = packet.d

  if event == 'AL_OPEN_WINDOW' then
    Alchemy.show()
    Alchemy.applySnapshot(data)
  elseif event == 'AL_UPDATE' then
    Alchemy.applySnapshot(data)
  elseif event == 'AL_CAULDRON' then
    Alchemy.renderCauldron(data or {})
  elseif event == 'AL_RECIPES' then
    Alchemy.onRecipes(data)
  elseif event == 'AL_REAGENTS' then
    Alchemy.onReagents(data)
  elseif event == 'AL_RESULT' then
    Alchemy.onResult(data)
  elseif event == 'AL_REJECTED' then
    Alchemy.onRejected(data)
  end
end
