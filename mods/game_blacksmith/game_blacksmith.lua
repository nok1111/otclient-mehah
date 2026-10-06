Blacksmith = {}

local BLACKSMITH_OPCODE = 235

local blacksmithWindow = nil
local itemSlot = nil
local placedUid = nil
local inventoryItems = {}
local currentFilter = 'all'
local filterButtons = {}
local anvilClientId = 0
local currentTab = 'refinementPage'
local tabButtons = {}
local materialsData = {}
local smeltingData = {}
local specData = nil
local blacksmithLevel = 0

-- Same palette as item tooltips (mods/game_tooltips/item_tooltip.lua)
local rarityColors = {
  [1] = "#ffffff", -- Common
  [2] = "#02e2fc", -- Orbital
  [3] = "#d300ff", -- Forged
  [4] = "#ff7605", -- Ascended
}

local FILTERS = {
  { id = 'filterAll',       cat = 'all' },
  { id = 'filterWeapons',   cat = 'weapon' },
  { id = 'filterArmor',     cat = 'armor' },
  { id = 'filterAccessory', cat = 'accessory' },
}

local TABS = {
  { button = 'tabRefinement',     page = 'refinementPage' },
  { button = 'tabMaterials',      page = 'materialsPage' },
  { button = 'tabProgression',    page = 'progressionPage' },
  { button = 'tabSpecialization', page = 'specializationPage' },
}

function Blacksmith.init()
  connect(g_game, { onGameEnd = Blacksmith.hide })
  ProtocolGame.registerExtendedOpcode(BLACKSMITH_OPCODE, Blacksmith.onExtendedOpcode)
end

function Blacksmith.terminate()
  disconnect(g_game, { onGameEnd = Blacksmith.hide })
  ProtocolGame.unregisterExtendedOpcode(BLACKSMITH_OPCODE)
  Blacksmith.hide()
end

function Blacksmith.show()
  if not blacksmithWindow then
    local ok, result = pcall(function()
      return g_ui.loadUI('game_blacksmith', modules.game_interface.getRootPanel())
    end)
    if not ok or not result then
      print("[Blacksmith][Client] ERROR: Failed to load game_blacksmith UI: " .. tostring(result))
      return
    end
    blacksmithWindow = result
    print("[Blacksmith][Client] UI loaded")

    -- Click-only flow: no drag & drop. Clicking the placed slot removes
    -- the item from the station.
    itemSlot = blacksmithWindow:recursiveGetChildById('itemSlot')
    if itemSlot then
      itemSlot.onMouseRelease = function(self, mousePosition, mouseButton)
        if mouseButton == MouseLeftButton and placedUid then
          Blacksmith.send('BS_REMOVE', {})
          return true
        end
        return false
      end
    end

    for _, f in ipairs(FILTERS) do
      local btn = blacksmithWindow:recursiveGetChildById(f.id)
      if btn then
        filterButtons[f.cat] = btn
        btn.onClick = function()
          currentFilter = f.cat
          Blacksmith.renderInventory()
        end
      end
    end

    for _, t in ipairs(TABS) do
      local btn = blacksmithWindow:recursiveGetChildById(t.button)
      if btn then
        tabButtons[t.page] = btn
        btn.onClick = function()
          Blacksmith.selectTab(t.page)
        end
      end
    end

    local refineButton = blacksmithWindow:recursiveGetChildById('refineButton')
    if refineButton then
      refineButton.onClick = function()
        if placedUid then
          Blacksmith.setRefining(true)
          Blacksmith.send('BS_REFINE', {})
        end
      end
    end

    blacksmithWindow:hide()
  end

  blacksmithWindow:show()
  blacksmithWindow:raise()
  blacksmithWindow:focus()
  Blacksmith.selectTab(currentTab)
end

function Blacksmith.hide()
  if blacksmithWindow then
    Blacksmith.send('BS_CLOSE', {})
    placedUid = nil
    inventoryItems = {}
    blacksmithWindow:hide()
  end
end

function Blacksmith.send(event, data)
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    protocolGame:sendExtendedOpcode(BLACKSMITH_OPCODE, json.encode({ e = event, d = data }))
  end
end

function Blacksmith.selectTab(pageId)
  currentTab = pageId
  if not blacksmithWindow then return end
  for _, t in ipairs(TABS) do
    local page = blacksmithWindow:recursiveGetChildById(t.page)
    local btn = tabButtons[t.page]
    local active = (t.page == pageId)
    if page then page:setVisible(active) end
    if btn then btn:setColor(active and '#80c7f8' or '#dfdfdf') end
  end
end

local function setLabel(id, text, color)
  local w = blacksmithWindow and blacksmithWindow:recursiveGetChildById(id)
  if w then
    w:setText(text or '')
    if color then w:setColor(color) end
  end
  return w
end

function Blacksmith.setRefining(refining)
  local btn = blacksmithWindow and blacksmithWindow:recursiveGetChildById('refineButton')
  if btn then
    btn:setEnabled(not refining)
    btn:setText(refining and tr('REFINING...') or tr('REFINE'))
  end
end

-- ==================== INVENTORY GRID ====================

function Blacksmith.renderInventory()
  if not blacksmithWindow then return end
  local grid = blacksmithWindow:recursiveGetChildById('invGrid')
  if not grid then return end
  grid:destroyChildren()

  local shown = 0
  for _, it in ipairs(inventoryItems) do
    if currentFilter == 'all' or it.cat == currentFilter then
      local w = g_ui.createWidget('BSGridItem', grid)
      if w then
        w:setItemId(it.clientId or 0)
        local lbl = w:recursiveGetChildById('ilvlLabel')
        if lbl then
          lbl:setText(it.ilvl > 0 and ('iLv.' .. it.ilvl) or '-')
        end
        local color = rarityColors[it.rarityId] or '#ffffff'
        w:setBorderColor(color .. (it.eligible and 'aa' or '44'))
        if not it.eligible then
          w:setOpacity(0.45)
        end
        w:setTooltip((it.name or '') .. '\n' .. (it.ilvl > 0 and ('Item Level ' .. it.ilvl) or 'No Item Level')
          .. (it.eligible and '' or ('\n' .. (it.reason or 'Cannot be refined'))))
        local uid = it.uid
        -- onMouseRelease fires during release propagation regardless of press
        -- tracking; more reliable than onClick for virtual Item widgets.
        w.onMouseRelease = function(self, mousePosition, mouseButton)
          if mouseButton ~= MouseLeftButton or not self:containsPoint(mousePosition) then
            return false
          end
          if it.eligible then
            Blacksmith.send('BS_PLACE', { uid = uid })
          else
            setLabel('statusLabel', it.reason or 'Cannot be refined', '#de6f6f')
          end
          return true
        end
        shown = shown + 1
      end
    end
  end

  local empty = blacksmithWindow:recursiveGetChildById('invEmpty')
  if empty then
    empty:setVisible(shown == 0)
  end
end

-- ==================== PROFESSION PANEL ====================

local function profRow(parent, label, unlocked, reqLevel)
  local row = g_ui.createWidget('BSTierRow', parent)
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

local function setStat(cardId, value, name)
  local card = blacksmithWindow and blacksmithWindow:recursiveGetChildById(cardId)
  if not card then return end
  local v = card:recursiveGetChildById('statValue')
  local n = card:recursiveGetChildById('statName')
  if v then v:setText(tostring(value)) end
  if n then n:setText(name) end
end

function Blacksmith.renderProfession(data)
  if not blacksmithWindow then return end
  local prog = data.progression or {}
  local mastery = prog.mastery or {}
  local spec = prog.specialization or {}

  -- Header card: rank, level, XP bar
  setLabel('profRankName', prog.rank or data.rank or '', '#80c7f8')
  setLabel('profLevelText', tr('Level %d', data.level or 0), '#dfdfdf')
  local xpBar = blacksmithWindow:recursiveGetChildById('profXpBar')
  if xpBar then xpBar:setPercent(data.pct or 0) end
  if (data.nextLevel or 0) > 0 then
    setLabel('profXpLabel', tr('%d / %d XP', data.points or 0, data.nextLevel), '#dfdfdf')
  else
    setLabel('profXpLabel', tr('MAX'), '#dfdfdf')
  end

  -- Stat cards
  setStat('statCardLevel', data.level or 0, tr('LEVEL'))
  setStat('statCardRank', prog.rank or data.rank or '-', tr('RANK'))
  setStat('statCardRefines', mastery.total or 0, tr('REFINEMENTS'))
  setStat('statCardBest', mastery.maxIlvl or 0, tr('BEST iLV'))

  -- Refinement tiers
  local tiersList = blacksmithWindow:recursiveGetChildById('tiersList')
  if tiersList then
    tiersList:destroyChildren()
    for _, t in ipairs(prog.tiers or {}) do
      profRow(tiersList, t.label, t.unlocked, t.reqLevel)
    end
  end

  -- Profession perks
  local perksList = blacksmithWindow:recursiveGetChildById('perksList')
  if perksList then
    perksList:destroyChildren()
    for _, p in ipairs(prog.perks or {}) do
      profRow(perksList, p.label, p.unlocked, p.reqLevel)
    end
  end

  -- Mastery: progress toward the next milestone (between previous and next)
  local maxIlvl = mastery.maxIlvl or 0
  setLabel('masteryText', tr('Highest Item Level refined: %d', maxIlvl), '#dfdfdf')
  local masteryBar = blacksmithWindow:recursiveGetChildById('masteryBar')
  local nextM = mastery.next
  if masteryBar then
    if nextM then
      local prev = 0
      for _, m in ipairs(mastery.milestones or {}) do
        if m.done and m.value > prev then prev = m.value end
      end
      local pct = math.floor((maxIlvl - prev) / math.max(1, nextM - prev) * 100)
      masteryBar:setPercent(math.max(0, math.min(100, pct)))
      setLabel('masteryBarText', tr('Next milestone: iLv %d  (%d/%d)', nextM, maxIlvl, nextM), '#dfdfdf')
    else
      masteryBar:setPercent(100)
      setLabel('masteryBarText', tr('All milestones reached'), '#dfdfdf')
    end
  end

  -- Milestone chips
  local chips = blacksmithWindow:recursiveGetChildById('milestonesRow')
  if chips then
    chips:destroyChildren()
    for _, m in ipairs(mastery.milestones or {}) do
      local chip = g_ui.createWidget('BSMilestoneChip', chips)
      if chip then
        chip:setBorderColor(m.done and '#00BC00' or '#ffffff33')
        local lbl = chip:recursiveGetChildById('chipLabel')
        if lbl then
          lbl:setText('iLv ' .. m.value)
          lbl:setColor(m.done and '#00BC00' or '#dfdfdf88')
        end
        chip:setTooltip(m.done and tr('Completed') or tr('Not completed'))
      end
    end
  end

  -- Specialization status
  if spec.current then
    local key = tostring(spec.current)
    setLabel('specStatus',
      tr('Active: %s', key:sub(1,1):upper() .. key:sub(2)),
      '#00BC00')
  elseif spec.unlocked then
    setLabel('specStatus', tr('Available - pick one in the Specialization tab'), '#80c7f8')
  else
    setLabel('specStatus', tr('Locked - unlocks at Blacksmith Level %d', spec.reqLevel or 15), '#dfdfdf88')
  end
end

-- ==================== MATERIALS / FORGE TAB ====================

function Blacksmith.renderMaterials()
  if not blacksmithWindow then return end

  local matScroll = blacksmithWindow:recursiveGetChildById('matScroll')
  if matScroll then
    matScroll:destroyChildren()
    for _, mat in ipairs(materialsData) do
      local row = g_ui.createWidget('BSMatRow', matScroll)
      if row then
        local icon = row:recursiveGetChildById('matItemIcon')
        local name = row:recursiveGetChildById('matItemName')
        local count = row:recursiveGetChildById('matItemCount')
        if icon then icon:setItemId(mat.clientId or 0) end
        if name then name:setText(mat.name or '') end
        if count then
          count:setText(string.format('x%d', mat.count or 0))
          count:setColor((mat.count or 0) > 0 and '#dfdfdf' or '#de6f6f')
        end
        if name and (mat.count or 0) == 0 then
          name:setColor('#dfdfdf88')
        end
      end
    end
  end

  local forgeScroll = blacksmithWindow:recursiveGetChildById('forgeScroll')
  if not forgeScroll then return end
  forgeScroll:destroyChildren()

  for _, rec in ipairs(smeltingData) do
    local row = g_ui.createWidget('BSSmeltRow', forgeScroll)
    if row then
      local oreIcon = row:recursiveGetChildById('smeltOreIcon')
      local oreLabel = row:recursiveGetChildById('smeltOreLabel')
      local fuelIcon = row:recursiveGetChildById('smeltFuelIcon')
      local fuelLabel = row:recursiveGetChildById('smeltFuelLabel')
      local resultIcon = row:recursiveGetChildById('smeltResultIcon')
      local resultLabel = row:recursiveGetChildById('smeltResultLabel')
      local info = row:recursiveGetChildById('smeltInfo')
      local btn = row:recursiveGetChildById('smeltButton')

      if oreIcon then oreIcon:setItemId(rec.oreClientId or 0) end
      if oreLabel then
        oreLabel:setText(string.format('x%d (%d)', rec.oreNeed or 0, rec.oreHave or 0))
        oreLabel:setColor((rec.oreHave or 0) >= (rec.oreNeed or 0) and '#dfdfdf' or '#de6f6f')
        oreLabel:setTooltip(rec.oreName or '')
      end
      if fuelIcon then fuelIcon:setItemId(rec.fuelClientId or 0) end
      if fuelLabel then
        fuelLabel:setText(string.format('x%d (%d)', rec.fuelNeed or 0, rec.fuelHave or 0))
        fuelLabel:setColor((rec.fuelHave or 0) >= (rec.fuelNeed or 0) and '#dfdfdf' or '#de6f6f')
        fuelLabel:setTooltip(rec.fuelName or '')
      end
      if resultIcon then resultIcon:setItemId(rec.resultClientId or 0) end
      if resultLabel then
        resultLabel:setText(string.format('%s x%d', rec.resultName or '', rec.resultCount or 1))
      end

      local locked = blacksmithLevel < (rec.reqLevel or 0)
      if info then
        if locked then
          info:setText(tr('Lv.%d', rec.reqLevel or 0))
          info:setColor('#de6f6f')
        else
          info:setText(tr('+%d XP', rec.xp or 0))
          info:setColor('#00BC00')
        end
      end
      if btn then
        btn.onClick = function()
          if locked then
            setLabel('statusLabel', tr('Requires Blacksmith Level %d', rec.reqLevel or 0), '#de6f6f')
          else
            Blacksmith.send('BS_SMELT', { recipe = rec.index })
          end
        end
      end
    end
  end
end

-- ==================== SPECIALIZATION TAB ====================

local SPEC_LABELS = {
  weapon = 'weapons',
  armor = 'armor',
  accessory = 'accessories',
}

function Blacksmith.renderSpecialization()
  if not blacksmithWindow then return end
  local list = blacksmithWindow:recursiveGetChildById('specList')
  if not list then return end
  list:destroyChildren()

  local current = specData and specData.current or 0
  local unlocked = specData and specData.unlocked or false
  local reqLevel = specData and specData.reqLevel or 15

  for _, spec in ipairs(specData and specData.list or {}) do
    local card = g_ui.createWidget('BSSpecCard', list)
    if card then
      local icon = card:recursiveGetChildById('specIcon')
      local name = card:recursiveGetChildById('specName')
      local cat = card:recursiveGetChildById('specCat')
      local perks = card:recursiveGetChildById('specPerks')
      local btn = card:recursiveGetChildById('specButton')

      if icon then icon:setItemId(spec.iconClientId or 0) end
      if name then
        name:setText(spec.key:sub(1,1):upper() .. spec.key:sub(2))
      end
      if cat then
        cat:setText(tr('%s items', SPEC_LABELS[spec.cat] or spec.cat))
      end
      if perks then
        perks:setText(tr('-%d%% materials and +%d%% XP when refining %s',
          spec.materialBonus or 0, spec.xpBonus or 0, SPEC_LABELS[spec.cat] or spec.cat))
      end
      if btn then
        local isCurrent = spec.id == current
        btn:setText(isCurrent and tr('ACTIVE') or tr('SELECT'))
        btn:setColor(isCurrent and '#00BC00' or '#dfdfdf')
        local specId = spec.id
        btn.onClick = function()
          if isCurrent then return end
          if not unlocked then
            setLabel('statusLabel', tr('Specializations unlock at Blacksmith Level %d', reqLevel), '#de6f6f')
            return
          end
          Blacksmith.send('BS_CHOOSE_SPEC', { spec = specId })
        end
      end
      if spec.id == current then
        card:setBorderColor('#00BC00')
      end
    end
  end

  local cur = blacksmithWindow:recursiveGetChildById('specCurrent')
  if cur then
    if not unlocked then
      cur:setText(tr('Locked - reach Blacksmith Level %d (current: %d)', reqLevel, specData and specData.level or 0))
      cur:setColor('#dfdfdf88')
    elseif current > 0 then
      local name = ''
      for _, spec in ipairs(specData.list or {}) do
        if spec.id == current then name = spec.key:sub(1,1):upper() .. spec.key:sub(2) end
      end
      cur:setText(tr('Active specialization: %s', name))
      cur:setColor('#00BC00')
    else
      cur:setText(tr('No specialization chosen'))
      cur:setColor('#c0c0c0')
    end
  end
end

-- ==================== MAIN UPDATE ====================

function Blacksmith.updateWindow(data)
  if not blacksmithWindow or not data then return end

  -- Header
  local prog = data.progression or {}
  setLabel('headerLevel', tr('Level %d', data.level or 0), '#80c7f8')
  setLabel('headerRank', prog.rank or data.rank or '', '#dfdfdf')
  local xpBar = blacksmithWindow:recursiveGetChildById('xpBar')
  if xpBar then
    xpBar:setPercent(data.pct or 0)
  end
  setLabel('xpLabel', tr('%d / %d XP', data.points or 0, data.nextLevel or 0), '#c0c0c0')

  -- Profession side panel
  Blacksmith.renderProfession(data)

  -- Materials list
  local list = blacksmithWindow:recursiveGetChildById('materialsList')
  if list then list:destroyChildren() end

  local emptyState = blacksmithWindow:recursiveGetChildById('emptyState')
  local filledState = blacksmithWindow:recursiveGetChildById('filledState')

  if data.empty then
    placedUid = nil
    if itemSlot then itemSlot:setItemId(0) end
    if emptyState then emptyState:setVisible(true) end
    if filledState then filledState:setVisible(false) end
    setLabel('xpGainLabel', '')
    setLabel('effLabel', '')
    setLabel('resultLabel', '')
    setLabel('statusLabel', data.note or '', '#de6f6f')
    Blacksmith.setRefining(false)
    local btn = blacksmithWindow:recursiveGetChildById('refineButton')
    if btn then btn:setEnabled(false) end
    return
  end

  if emptyState then emptyState:setVisible(false) end
  if filledState then filledState:setVisible(true) end

  local item = data.item
  if item then
    placedUid = item.uid
    if itemSlot then itemSlot:setItemId(item.clientId or 0) end
    local color = rarityColors[item.rarityId] or '#dfdfdf'
    setLabel('itemNameLabel', item.name or '', color)
    setLabel('itemInfoLabel', tr('Item Level %d', item.ilvl or 0), '#c0c0c0')
    setLabel('currentRarity', item.rarity or '', color)
  end

  if data.target then
    setLabel('targetRarity', data.target.rarity or '', rarityColors[data.target.rarityId] or '#dfdfdf')
    setLabel('targetSub', tr('TARGET'), '#c0c0c0')
    setLabel('resultLabel', tr('Result: %s (Item Level %d)', data.target.rarity or '', data.target.ilvl or 0),
      rarityColors[data.target.rarityId] or '#dfdfdf')
  elseif data.maxRarity then
    setLabel('targetRarity', tr('MAX RARITY'), '#ff7605')
    setLabel('targetSub', '', '#c0c0c0')
    setLabel('resultLabel', '')
  else
    setLabel('targetRarity', '-', '#dfdfdf')
    setLabel('resultLabel', '')
  end

  for _, mat in ipairs(data.materials or {}) do
    local row = g_ui.createWidget('MaterialRow', list)
    if row then
      local icon = row:recursiveGetChildById('matIcon')
      local name = row:recursiveGetChildById('matName')
      local count = row:recursiveGetChildById('matCount')
      local mark = row:recursiveGetChildById('matMark')
      local enough = (mat.have or 0) >= (mat.need or 0)
      if icon then icon:setItemId(mat.clientId or 0) end
      if name then name:setText(mat.name or '') end
      if count then
        count:setText(string.format('%d / %d', mat.have or 0, mat.need or 0))
        count:setColor(enough and '#00BC00' or '#de6f6f')
      end
      if mark then
        mark:setText(enough and 'v' or 'x')
        mark:setColor(enough and '#00BC00' or '#de6f6f')
      end
    end
  end

  setLabel('xpGainLabel', data.xp and tr('Blacksmith XP: +%d', data.xp) or '', '#00BC00')
  local effParts = {}
  if (data.efficiency or 0) > 0 then
    effParts[#effParts + 1] = tr('Material Efficiency -%d%%', data.efficiency)
  end
  if (data.xpBonus or 0) > 0 then
    effParts[#effParts + 1] = tr('XP Bonus +%d%%', data.xpBonus)
  end
  if data.specActive and data.specKey then
    local key = tostring(data.specKey)
    effParts[#effParts + 1] = tr('%s active', key:sub(1,1):upper() .. key:sub(2))
  end
  setLabel('effLabel', table.concat(effParts, '   '), '#c0c0c0')

  local status = ''
  if data.maxRarity then
    status = tr('This item has reached the maximum refinement tier.')
  elseif data.reason then
    status = data.reason
  end
  setLabel('statusLabel', status, '#de6f6f')

  Blacksmith.setRefining(false)
  local btn = blacksmithWindow:recursiveGetChildById('refineButton')
  if btn then
    btn:setEnabled(data.canRefine == true)
  end
end

function Blacksmith.onInventory(data)
  inventoryItems = (data and data.items) or {}
  Blacksmith.renderInventory()
end

function Blacksmith.onMaterials(data)
  materialsData = (data and data.materials) or {}
  smeltingData = (data and data.smelting) or {}
  if data and data.level then blacksmithLevel = data.level end
  Blacksmith.renderMaterials()
end

function Blacksmith.onSpec(data)
  specData = data
  if data and data.level then blacksmithLevel = data.level end
  Blacksmith.renderSpecialization()
  Blacksmith.renderMaterials() -- smelt lock state depends on player level
end

function Blacksmith.onResult(data)
  Blacksmith.setRefining(false)
  if data and data.success then
    if data.smelt then
      setLabel('statusLabel',
        tr('Forged %dx %s (+%d XP)', data.count or 1, data.name or '', data.xp or 0),
        '#00BC00')
      return
    end
    local matText = ''
    for _, mat in ipairs(data.materials or {}) do
      matText = matText .. (#matText > 0 and ', ' or '') .. string.format('-%d %s', mat.need or 0, mat.name or '')
    end
    setLabel('statusLabel',
      tr('Refined to %s! (+%d XP)  Consumed: %s', data.rarity or '', data.xp or 0, matText),
      '#00BC00')
  end
end

function Blacksmith.onRejected(data)
  Blacksmith.setRefining(false)
  -- The server re-sends BS_UPDATE after a rejection, which restores
  -- placedUid / slot visuals if a session still exists.
  setLabel('statusLabel', data and data.reason or tr('Cannot refine'), '#de6f6f')
end

function Blacksmith.onExtendedOpcode(protocol, opcode, buffer)
  if opcode ~= BLACKSMITH_OPCODE then return end

  local ok, packet = pcall(function() return json.decode(buffer) end)
  if not ok or type(packet) ~= 'table' then return end

  local event = packet.e
  local data = packet.d

  if event == 'BS_OPEN_WINDOW' then
    Blacksmith.show()
    local w = blacksmithWindow and blacksmithWindow:recursiveGetChildById('anvilIcon')
    if w and data.anvilClientId and data.anvilClientId > 0 then
      anvilClientId = data.anvilClientId
      w:setItemId(anvilClientId)
    end
    Blacksmith.updateWindow({ empty = true, level = data.level, pct = data.pct,
      nextLevel = data.nextLevel, points = data.points, rank = data.rank,
      progression = data.progression })
  elseif event == 'BS_UPDATE' then
    Blacksmith.updateWindow(data)
  elseif event == 'BS_INVENTORY' then
    Blacksmith.onInventory(data)
  elseif event == 'BS_MATERIALS' then
    Blacksmith.onMaterials(data)
  elseif event == 'BS_SPEC' then
    Blacksmith.onSpec(data)
  elseif event == 'BS_RESULT' then
    Blacksmith.onResult(data)
  elseif event == 'BS_REJECTED' then
    Blacksmith.onRejected(data)
  end
end
