Enchanting = {}

local ENCHANTING_OPCODE = 240

local enchantingWindow = nil
local snapshot = nil
local ritualState = nil    -- last EN_RITUAL payload
local infusionState = nil  -- last EN_INFUSION payload
local selInfSlot = 1
local selInfEssence = nil
local recipes = {}         -- accumulated recipe list
local recipeParts = nil
local currentTab = 'enchPage'
local tabButtons = {}
local selectedRecipe = nil
local selectedEnchant = nil

local TABS = {
  { button = 'tabEnch',    page = 'enchPage' },
  { button = 'tabInfuse',  page = 'infusePage' },
  { button = 'tabRitual',  page = 'ritualPage' },
  { button = 'tabSpec',    page = 'specPage' },
  { button = 'tabProg',    page = 'progressPage' },
}

local BLACKOUT_SHADER = 'Blackout'

local LOCKED_TOOLTIP = {
  id = 0, name = '?????', desc = 'An unknown inscription - complete its ritual to learn it.',
  iLvl = 0, rarity = 0, count = 1, type = 'Common',
  first = 0, second = 0, third = 0, weight = 0, uLvl = 0,
  maxAttributes = 0, attributes = {},
}

-- ---------------------------------------------------------------
local function sendEvent(e, d)
  local protocol = g_game.getProtocolGame()
  if protocol then
    protocol:sendExtendedOpcode(ENCHANTING_OPCODE, json.encode({ e = e, d = d or {} }))
  end
end

local function setLabel(id, text, color)
  local w = enchantingWindow and enchantingWindow:recursiveGetChildById(id)
  if w then
    w:setText(text or '')
    if color then w:setColor(color) end
  end
end

-- Panels don't fire onClick in this client; emulate it with onMouseRelease.
local function onClick(widget, fn)
  widget.onMouseRelease = function(self, pos, mb)
    if mb == MouseLeftButton and self:containsPoint(pos) then
      fn()
      return true
    end
    return false
  end
end

local function fmtGold(n)
  n = tonumber(n) or 0
  if n >= 1000000 then return string.format('%.1fkk', n / 1000000) end
  if n >= 1000 then return string.format('%.1fk', n / 1000) end
  return tostring(n)
end

local function accumulate(parts, chunk)
  parts = parts or {}
  parts[chunk.part] = chunk.list
  local done = true
  for i = 1, chunk.total do
    if not parts[i] then done = false break end
  end
  if not done then return parts, nil end
  local out = {}
  for i = 1, chunk.total do
    for _, it in ipairs(parts[i]) do out[#out + 1] = it end
  end
  return nil, out
end

-- ---------------------------------------------------------------
function Enchanting.init()
  ProtocolGame.registerExtendedOpcode(ENCHANTING_OPCODE, Enchanting.onExtendedOpcode)
  connect(g_game, { onGameEnd = Enchanting.hide })
  LOCKED_TOOLTIP.desc = tr('An unknown inscription - complete its ritual to learn it.')
end

function Enchanting.terminate()
  disconnect(g_game, { onGameEnd = Enchanting.hide })
  ProtocolGame.unregisterExtendedOpcode(ENCHANTING_OPCODE, Enchanting.onExtendedOpcode)
  Enchanting.hide()
end

function Enchanting.hide()
  if enchantingWindow then
    sendEvent('EN_CLOSE')
    enchantingWindow:destroy()
    enchantingWindow = nil
  end
  snapshot, ritualState, infusionState, recipes = nil, nil, nil, {}
  recipeParts, selectedRecipe, selectedEnchant = nil, nil, nil
end

function Enchanting.toggle()
  if enchantingWindow then
    Enchanting.hide()
  else
    sendEvent('EN_OPEN')
  end
end

function Enchanting.craftSelected()
  if selectedRecipe then
    sendEvent('EN_CRAFT', { recipeId = selectedRecipe.id })
  end
end

function Enchanting.channelRitual()
  sendEvent('EN_CHANNEL')
end

-- ---------------------------------------------------------------
local function buildWindow()
  enchantingWindow = g_ui.loadUI('game_enchanting', modules.game_interface.getRootPanel())
  tabButtons = {}
  for _, t in ipairs(TABS) do
    local btn = enchantingWindow:recursiveGetChildById(t.button)
    if btn then
      tabButtons[t.button] = btn
      btn.onClick = function() Enchanting.showTab(t.page) end
    end
  end
  local closeBtn = enchantingWindow:recursiveGetChildById('closeButton')
  if closeBtn then closeBtn.onClick = Enchanting.hide end
  enchantingWindow.onEscape = Enchanting.hide
  local woBackBtn = enchantingWindow:recursiveGetChildById('woBackBtn')
  if woBackBtn then woBackBtn.onClick = Enchanting.closeCraftOrder end
  local craftBtn = enchantingWindow:recursiveGetChildById('craftBtn')
  if craftBtn then craftBtn.onClick = Enchanting.craftSelected end
  local ritChannelBtn = enchantingWindow:recursiveGetChildById('ritChannelBtn')
  if ritChannelBtn then ritChannelBtn.onClick = Enchanting.channelRitual end
  Enchanting.showTab(currentTab)
end

function Enchanting.showTab(pageId)
  currentTab = pageId
  for _, t in ipairs(TABS) do
    local page = enchantingWindow:recursiveGetChildById(t.page)
    if page then page:setVisible(t.page == pageId) end
    local btn = tabButtons[t.button]
    if btn then btn:setOn(t.page == pageId) end
  end
  if pageId == 'ritualPage' then sendEvent('EN_RITUAL_INFO') end
  if pageId == 'infusePage' then sendEvent('EN_INFUSION_OPEN') end
end

-- ---------------------------------------------------------------
-- CRAFT TAB (recipe library + work order)
local function renderRecipeList()
  local list = enchantingWindow:recursiveGetChildById('recipeList')
  if not list then return end
  list:destroyChildren()
  local hint = enchantingWindow:recursiveGetChildById('recipeLibHint')
  if hint then hint:setVisible(#recipes == 0) end
  for _, r in ipairs(recipes) do
    local row = g_ui.createWidget('EnchRecipeRow', list)
    row.recipe = r
    local icon = row:getChildById('icon')
    icon:setItemId(r.clientId)
    if r.locked then
      icon:setShader(BLACKOUT_SHADER)
      if icon.getItemTooltip then icon.tooltipData = LOCKED_TOOLTIP end
    else
      icon:setShader('')
    end
    row:getChildById('name'):setText(r.name)
    local badge = row:getChildById('tier')
    local cat = trServerMsg(r.category or 'Misc')
    if r.skillLocked then
      badge:setText(tr('%s  \194\183  Enchanting %d', cat, r.requiredSkill or 0))
      badge:setColor('#de6f6f')
      row:getChildById('name'):setColor('#de6f6f')
      badge:setTooltip(tr('Requires Enchanting %d', r.requiredSkill or 0))
    elseif r.locked then
      badge:setText(cat .. '  \194\183  ' .. tr('Ritual'))
      badge:setColor('#c0c0c0')
      row:getChildById('name'):setColor('#c0c0c0')
      badge:setTooltip(tr('Unknown - complete its Ritual'))
    else
      badge:setText(cat .. '  \194\183  ' .. tr('T%d', r.tier or 0))
      badge:setColor('#c0c0c0')
    end
    onClick(row, function()
      selectedRecipe = r
      Enchanting.renderRecipeDetail()
    end)
  end
end

function Enchanting.renderRecipeDetail()
  local r = selectedRecipe
  local hint = enchantingWindow:recursiveGetChildById('craftHint')
  local rod = enchantingWindow:recursiveGetChildById('craftRod')
  local panel = enchantingWindow:recursiveGetChildById('craftOrderPanel')
  if not panel then return end
  if not r then
    panel:setVisible(false)
    if hint then hint:setVisible(true) end
    if rod then rod:setVisible(true) end
    return
  end
  if hint then hint:setVisible(false) end
  if rod then rod:setVisible(false) end
  panel:setVisible(true)
  local icon = panel:recursiveGetChildById('woIcon')
  if icon then
    icon:setItemId(r.clientId)
    icon:setShader(r.locked and BLACKOUT_SHADER or '')
  end
  setLabel('woName', r.name)
  setLabel('woCategory', trServerMsg(r.category or 'Misc'))
  setLabel('woDesc', trServerMsg(r.desc or ''))
  local req = enchantingWindow:recursiveGetChildById('woReq')
  if req then
    req:setText(r.skillLocked and tr('Requires Enchanting %d', r.requiredSkill or 0)
      or r.locked and tr('Unknown inscription - perform its Ritual')
      or tr('Enchanting %d  \194\183  %d xp', r.requiredSkill or 0, r.craftPoints or 0))
    req:setColor(r.skillLocked and '#de6f6f' or '#80c7f8')
  end
  local list = enchantingWindow:recursiveGetChildById('detIngs')
  if list then
    list:destroyChildren()
    for _, ing in ipairs(r.ingredients or {}) do
      local row = g_ui.createWidget('EnchIngRow', list)
      row:getChildById('icon'):setItemId(ing.clientId)
      local lbl = row:getChildById('txt')
      lbl:setText(string.format('%s  %d/%d', ing.name, ing.count or 0, ing.required))
      lbl:setColor((ing.count or 0) >= ing.required and '#dfdfdf' or '#de6f6f')
    end
  end
  local btn = panel:recursiveGetChildById('craftBtn')
  btn:setEnabled(not r.locked and not r.skillLocked)
  btn:setText(r.locked and tr('Locked (Ritual)') or r.skillLocked and tr('Req. level %d', r.requiredSkill) or tr('Craft'))
end

function Enchanting.closeCraftOrder()
  selectedRecipe = nil
  Enchanting.renderRecipeDetail()
end

-- ---------------------------------------------------------------
-- ENCHANT TAB (item slot + eligible enchants)
-- Shared helper: fill a blacksmith-style inventory grid of clickable item cells
local function fillInvGrid(gridId, emptyId, inventory, onPick)
  local grid = enchantingWindow:recursiveGetChildById(gridId)
  if not grid then return end
  grid:destroyChildren()
  local shown = 0
  for _, it in ipairs(inventory or {}) do
    local w = g_ui.createWidget('EnchGridItem', grid)
    if w then
      w:setItemId(it.clientId or 0)
      local lbl = w:recursiveGetChildById('ilvlLabel')
      if lbl then lbl:setText((it.ilvl or 0) > 0 and tr('iLv.%d', it.ilvl) or '-') end
      w:setTooltip(it.name .. (it.enchanted and tr(' (enchanted)') or ''))
      if it.enchanted then w:setOpacity(0.5) end
      local uid = it.uid
      onClick(w, function() onPick(uid) end)
      shown = shown + 1
    end
  end
  local empty = enchantingWindow:recursiveGetChildById(emptyId)
  if empty then empty:setVisible(shown == 0) end
end

-- ---------------------------------------------------------------
-- RITUAL TAB (push-your-luck inscription)
local function renderRitual()
  local d = ritualState
  local list = enchantingWindow:recursiveGetChildById('ritList')
  if not list then return end
  list:destroyChildren()
  if not d then return end
  local hint = enchantingWindow:recursiveGetChildById('ritListHint')
  if hint then hint:setVisible(#(d.list or {}) == 0) end
  for _, r in ipairs(d.list or {}) do
    local row = g_ui.createWidget('EnchRecipeRow', list)
    local icon = row:getChildById('icon')
    icon:setItemId(r.clientId)
    if not r.learned then icon:setShader(BLACKOUT_SHADER) else icon:setShader('') end
    row:getChildById('name'):setText(r.learned and r.name or tr('?????'))
    row:getChildById('name'):setColor(r.learned and '#00BC00' or '#dfdfdf')
    row:getChildById('tier'):setText(r.learned and tr('Learned') or r.selected and tr('Channeling') or tr('Unknown'))
    row:getChildById('tier'):setColor(r.learned and '#00BC00' or r.selected and '#80c7f8' or '#c0c0c0')
    if r.selected then row:setBackgroundColor('#355d8955') end
    onClick(row, function() sendEvent("EN_RITUAL_SELECT", { recipeId = r.id }) end)
  end

  local btn = enchantingWindow:recursiveGetChildById('ritChannelBtn')
  if d.target then
    local sel = nil
    for _, r in ipairs(d.list or {}) do if r.id == d.target then sel = r end end
    setLabel('ritTargetName', sel and sel.name or tr('?????'))
    local icon = enchantingWindow:recursiveGetChildById('ritIcon')
    if icon and sel then
      icon:setItemId(sel.clientId)
      icon:setShader(sel.learned and '' or BLACKOUT_SHADER)
    end
    local mats = enchantingWindow:recursiveGetChildById('ritMats')
    mats:destroyChildren()
    for _, m in ipairs(d.mats or {}) do
      local row = g_ui.createWidget('EnchIngRow', mats)
      row:getChildById('icon'):setItemId(m.clientId)
      local lbl = row:getChildById('txt')
      lbl:setText(string.format('%s  %d/%d', m.name, m.count or 0, m.required))
      lbl:setColor((m.count or 0) >= m.required and '#dfdfdf' or '#de6f6f')
    end
    local bar = enchantingWindow:recursiveGetChildById('ritBar')
    if bar then bar:setPercent(math.min(100, d.chance or 0)) end
    setLabel('ritChance', tr('Channel chance: %d%%', d.chance or 0))
    setLabel('ritResonance', tr('resonance %d (+%d%% per attempt)', d.resonance or 0, (d.resonance or 0) * 10))
    local can = true
    for _, m in ipairs(d.mats or {}) do
      if (m.count or 0) < m.required then can = false break end
    end
    btn:setEnabled(can and not d.learned)
    btn:setText(d.learned and tr('Inscription learned') or tr('CHANNEL'))
    btn.onClick = function() sendEvent('EN_CHANNEL') end
  else
    setLabel('ritTargetName', tr('Select an inscription'))
    setLabel('ritChance', tr('Channel chance: --'))
    setLabel('ritResonance', tr('resonance 0'))
    local icon = enchantingWindow:recursiveGetChildById('ritIcon')
    if icon then icon:setItemId(0) end
    local bar = enchantingWindow:recursiveGetChildById('ritBar')
    if bar then bar:setPercent(0) end
    local mats = enchantingWindow:recursiveGetChildById('ritMats')
    if mats then mats:destroyChildren() end
    btn:setEnabled(false)
    btn:setText(tr('CHANNEL'))
  end
end

-- ---------------------------------------------------------------
-- INFUSE TAB (essence infusion, blacksmith-style layout)
local function renderInfusion()
  local d = infusionState
  fillInvGrid('infGrid', 'infEmpty', d and d.inventory or nil,
    function(uid) sendEvent('EN_PLACE_INFUSION', { uid = uid }) end)

  local slotWidget = enchantingWindow:recursiveGetChildById('infItemSlot')
  local nameLabel = enchantingWindow:recursiveGetChildById('infItemName')
  if d and not d.empty and d.item then
    slotWidget:setItemId(d.item.clientId or 0)
    nameLabel:setText(tr('%s (iLv.%s - %s)', d.item.name, tostring(d.item.ilvl), d.slotKind or '?'))
    nameLabel:setColor('#dfdfdf')
  else
    slotWidget:setItemId(0)
    nameLabel:setText(tr('Select an item from your inventory'))
    nameLabel:setColor('#c0c0c0')
  end
  onClick(slotWidget, function()
    if d and not d.empty then sendEvent('EN_REMOVE_INFUSION') end
  end)
  setLabel('infBlock', d and d.blockReason and trServerMsg(d.blockReason) or '')

  -- infusion slot rows
  local slotsPanel = enchantingWindow:recursiveGetChildById('infSlots')
  slotsPanel:destroyChildren()
  if d and not d.empty then
    for _, s in ipairs(d.slots or {}) do
      local row = g_ui.createWidget('EnchInfSlotRow2', slotsPanel)
      local icon = row:recursiveGetChildById('slotIcon')
      local title = row:recursiveGetChildById('slotTitle')
      local desc = row:recursiveGetChildById('slotDesc')
      local b1 = row:recursiveGetChildById('slotBtn')
      local b2 = row:recursiveGetChildById('slotBtn2')
      icon:setItemId(s.clientId or 0)
      title:setText(tr('Slot %d', s.index))
      title:setColor(s.unlocked and '#dfdfdf' or '#de6f6f')
      if s.essenceId then
        desc:setText(tr('%s: %s (q%d)', s.essenceName or '?', s.desc or tostring(s.value), s.quality or 0))
        desc:setColor(s.color or '#80c7f8')
      else
        desc:setText(s.unlocked and tr('Empty - select an essence') or (s.reqText and trServerMsg(s.reqText) or tr('Locked')))
        desc:setColor('#c0c0c0')
      end
      local has = s.essenceId ~= nil
      b1:setVisible(has)
      b2:setVisible(has)
      if has then
        b1:setText(tr('Reroll'))
        b2:setText(tr('Extract'))
        b1.onClick = function() sendEvent('EN_REROLL', { slot = s.index }) end
        b2.onClick = function() sendEvent('EN_EXTRACT', { slot = s.index }) end
      end
      if s.unlocked and not has then
        onClick(row, function()
          selInfSlot = s.index
          renderInfusion()
        end)
      end
      if s.index == (selInfSlot or 1) then
        row:setBorderColor('#80c7f8')
      end
    end
  end

  -- essences grid
  local essPanel = enchantingWindow:recursiveGetChildById('infEssences')
  essPanel:destroyChildren()
  if d and not d.empty then
    for _, e in ipairs(d.essences or {}) do
      local w = g_ui.createWidget('EnchGridItem', essPanel)
      if w then
        w:setItemId(e.clientId or 0)
        local lbl = w:recursiveGetChildById('ilvlLabel')
        if lbl then lbl:setText('x' .. tostring(e.count or 0)) end
        local tip = tr('%s\n%s\nOwned: %d', e.name, e.desc or '', e.count or 0)
        if e.options then
          for _, o in ipairs(e.options) do tip = tip .. '\n - ' .. o end
        end
        if not e.applies then tip = tip .. tr('\n(No effect on this item slot)') end
        w:setTooltip(tip)
        local canUse = e.applies and (e.count or 0) > 0
        if selInfEssence == e.id then
          w:setBorderWidth(2)
          w:setBorderColor('#80c7f8')
          w:setBackgroundColor('#355d89cc')
        else
          w:setBorderColor(e.applies and (e.color or '#ffffff33') or '#de6f6f55')
          w:setBackgroundColor(canUse and '#00000088' or '#00000033')
        end
        if canUse then
          local eid = e.id
          onClick(w, function()
            selInfEssence = eid
            renderInfusion()
          end)
        end
      end
    end
  end

  -- apply button + preview
  local applyBtn = enchantingWindow:recursiveGetChildById('infApplyBtn')
  local selEssence, slotState = nil, nil
  for _, e in ipairs((d and d.essences) or {}) do
    if e.id == selInfEssence then selEssence = e break end
  end
  for _, s in ipairs((d and d.slots) or {}) do
    if s.index == (selInfSlot or 1) then slotState = s break end
  end
  local canApply = selEssence and selEssence.applies and (selEssence.count or 0) > 0
    and d and not d.empty and slotState and slotState.unlocked and not slotState.essenceId
  if applyBtn then
    applyBtn:setEnabled(canApply and true or false)
    applyBtn:setText(selEssence and tr('Enchant %s', selEssence.name) or tr('Enchant'))
    applyBtn:setColor(canApply and '#80c7f8' or '#dfdfdf88')
    applyBtn:setBackgroundColor(canApply and '#355d89' or '#00000055')
    applyBtn.onClick = function()
      if canApply then
        sendEvent('EN_INFUSE', { essence = selEssence.id, slot = slotState.index })
      end
    end
  end
  local prev = enchantingWindow:recursiveGetChildById('infPreview')
  if prev then
    prev:setText(selEssence and slotState and slotState.unlocked and not slotState.essenceId
      and tr('Essence into slot %d - %s', slotState.index, selEssence.desc or '') or '')
  end
end

-- ---------------------------------------------------------------
-- PROGRESS TAB
local function renderProgress()
  local s = snapshot or {}
  setLabel('progLevel', tr('Enchanting level %d', s.level or 0))
  local bar = enchantingWindow:recursiveGetChildById('progBar')
  if bar then bar:setPercent(s.pct or 0) end
  setLabel('progXp', tr('%s / %s to next level', tostring(s.points or 0), tostring(s.nextLevel or tr('max'))))
  local ins = s.progression and s.progression.inscriptions
  if ins then
    setLabel('progDisc', tr('Inscriptions learned: %d / %d', ins.learned or 0, ins.total or 0))
  end

  -- specialization cards
  local current = s.spec or 0
  local reqLevel = s.specMinLevel or 15
  local unlocked = (s.level or 0) >= reqLevel
  local names = { [1] = 'Runesmith', [2] = 'Salvager', [3] = 'Invoker' }
  if current > 0 then
    setLabel('specStatus', tr('SPECIALIZATION - active: %s', trServerMsg(names[current] or '?')), '#00BC00')
  elseif unlocked then
    setLabel('specStatus', tr('SPECIALIZATION - pick one (permanent)'), '#80c7f8')
  else
    setLabel('specStatus', tr('SPECIALIZATION - unlocks at Enchanting Lv.%d', reqLevel), '#c0c0c0')
  end
  local specList = enchantingWindow:recursiveGetChildById('specList')
  if specList then
    specList:destroyChildren()
    for _, sp in ipairs(s.specList or {}) do
      local card = g_ui.createWidget('EnchSpecCard', specList)
      if card then
        local icon = card:recursiveGetChildById('specIcon')
        local name = card:recursiveGetChildById('specName')
        local perks = card:recursiveGetChildById('specPerks')
        local btn = card:recursiveGetChildById('specButton')
        if icon then icon:setItemId(sp.iconClientId or 0) end
        if name then name:setText(trServerMsg(sp.name or '')) end
        if perks then perks:setText(trServerMsg(sp.desc or '')) end
        if btn then
          local isCurrent = sp.id == current
          btn:setText(isCurrent and tr('ACTIVE') or (not unlocked and tr('Lv.%d', reqLevel) or tr('SELECT')))
          btn:setEnabled(unlocked and not isCurrent and current == 0)
          local specId = sp.id
          btn.onClick = function()
            if isCurrent or current > 0 or not unlocked then return end
            sendEvent('EN_CHOOSE_SPEC', { spec = specId })
          end
        end
        if sp.id == current then card:setBorderColor('#00BC00') end
      end
    end
  end
end

-- ---------------------------------------------------------------
local function applyMeta(data)
  snapshot = data
  setLabel('headerLevel', tr('Lv %d', data.level or 0))
  setLabel('headerGold', tr('%s gp', fmtGold(data.gold or 0)))
  local rod = enchantingWindow and enchantingWindow:recursiveGetChildById('craftRod')
  if rod and (data.stationClientId or 0) > 0 then rod:setItemId(data.stationClientId) end
  renderProgress()
end

function Enchanting.onExtendedOpcode(protocol, opcode, buffer)
  if opcode ~= ENCHANTING_OPCODE then return end
  local ok, msg = pcall(json.decode, buffer)
  if not ok or not msg or not msg.e then return end

  if msg.e == 'EN_OPEN_WINDOW' or msg.e == 'EN_UPDATE' then
    if not enchantingWindow then buildWindow() end
    applyMeta(msg.d)
  elseif msg.e == 'EN_RECIPES' then
    local acc, full = accumulate(recipeParts, msg.d)
    recipeParts = acc
    if full then
      recipes = full
      if enchantingWindow then renderRecipeList() end
    end
  elseif msg.e == 'EN_RITUAL' then
    ritualState = msg.d
    if enchantingWindow then renderRitual() end
  elseif msg.e == 'EN_INFUSION' then
    infusionState = msg.d
    if enchantingWindow then renderInfusion() end
  elseif msg.e == 'EN_INFUSED' then
    local d = msg.d or {}
    if d.ok then
      local what = d.extracted and tr('Enchantment extracted') or
        ((d.rerolled and tr('Rerolled: ') or tr('Enchanted: ')) .. (d.enchant or '') ..
         (d.quality and tr(' (quality %d%s)', d.quality, d.perfect and tr(' - PERFECT') or '') or ''))
      modules.game_textmessage.displayFailureMessage(what)
    elseif d.reason then
      modules.game_textmessage.displayFailureMessage(d.reason)
    end
  elseif msg.e == 'EN_RESULT' then
    local d = msg.d or {}
    if d.message then
      modules.game_textmessage.displayFailureMessage(d.message)
    elseif d.success and d.name then
      modules.game_textmessage.displayFailureMessage(tr('Crafted %dx %s!', d.count or 1, d.name))
    elseif not d.success and d.reason then
      modules.game_textmessage.displayFailureMessage(d.reason)
    end
  elseif msg.e == 'EN_REJECTED' then
    modules.game_textmessage.displayFailureMessage((msg.d and msg.d.reason) or tr('Rejected'))
  end
end
