Blacksmith = {}

local BLACKSMITH_OPCODE = 235

local blacksmithWindow = nil
local itemSlot = nil
local placedUid = nil
local inventoryItems = {}
local currentFilter = 'all'
local filterButtons = {}
local anvilClientId = 0
local currentTab = 'craftPage'
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

-- Item sprite shaders (modules/game_shaders) per rarity, same names the
-- server sets via item:setShader.
local rarityShaders = {
  [2] = 'Orbital',
  [3] = 'Forged',
  [4] = 'Ascended',
}

local FILTERS = {
  { id = 'filterAll',       cat = 'all' },
  { id = 'filterWeapons',   cat = 'weapon' },
  { id = 'filterArmor',     cat = 'armor' },
  { id = 'filterAccessory', cat = 'accessory' },
}

local TABS = {
  { button = 'tabCraft',          page = 'craftPage' },
  { button = 'tabStudy',          page = 'studyPage' },
  { button = 'tabRefinement',     page = 'refinementPage' },
  -- Infusion moved to the Enchanting station window (game_enchanting mod)
  { button = 'tabMaterials',      page = 'materialsPage' },
  { button = 'tabProgression',    page = 'progressionPage' },
  { button = 'tabSpecialization', page = 'specializationPage' },
}

local infusionState = nil
local forgeState = nil
local forgeCommission = nil -- { entry, reqLvl, info } while the commission slip is open
local infSelectedSlot = 1
local infSelectedEssence = nil

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

    local specJump = blacksmithWindow:recursiveGetChildById('specJumpBtn')
    if specJump then
      specJump.onClick = function()
        Blacksmith.selectTab('specializationPage')
      end
    end

    -- Infusion: click the station slot to remove the placed item
    local infSlot = blacksmithWindow:recursiveGetChildById('infItemSlot')
    if infSlot then
      infSlot.onMouseRelease = function(self, mousePosition, mouseButton)
        if mouseButton == MouseLeftButton and infusionState and not infusionState.empty then
          Blacksmith.send('BS_REMOVE_INFUSION', {})
          return true
        end
        return false
      end
    end

    local infApply = blacksmithWindow:recursiveGetChildById('infApplyBtn')
    if infApply then
      infApply.onClick = function()
        if infSelectedEssence then
          Blacksmith.send('BS_INFUSE', { slot = infSelectedSlot, essence = infSelectedEssence })
        end
      end
    end

    -- Forge: click the station slot to remove the placed item
    local forgeSlot = blacksmithWindow:recursiveGetChildById('forgeItemSlot')
    if forgeSlot then
      forgeSlot.onMouseRelease = function(self, mousePosition, mouseButton)
        if mouseButton == MouseLeftButton and forgeState and not forgeState.empty then
          Blacksmith.send('BS_REMOVE_FORGE', {})
          return true
        end
        return false
      end
    end

    local forgeDecon = blacksmithWindow:recursiveGetChildById('forgeDeconBtn')
    if forgeDecon then
      forgeDecon.onClick = function()
        if forgeState and not forgeState.empty then
          Blacksmith.send('BS_FORGE_DECONSTRUCT', {})
        end
      end
    end

    -- commission slip: slider drives reqLvl -> live cost preview
    -- (debounced: a drag emits dozens of ticks; only send on settle)
    local craftInfoEvent = nil
    local cpSlider = blacksmithWindow:recursiveGetChildById('cpSlider')
    if cpSlider then
      cpSlider.onValueChange = function(self, value)
        if not forgeCommission then return end
        forgeCommission.reqLvl = math.round(value)
        local lvl = blacksmithWindow:recursiveGetChildById('cpLevel')
        if lvl then lvl:setText(tr('Level %d', forgeCommission.reqLvl)) end
        if craftInfoEvent then
          removeEvent(craftInfoEvent)
          craftInfoEvent = nil
        end
        craftInfoEvent = scheduleEvent(function()
          craftInfoEvent = nil
          if forgeCommission then
            Blacksmith.send('BS_FORGE_CRAFT_INFO', { itemId = forgeCommission.entry.itemId, reqLvl = forgeCommission.reqLvl })
          end
        end, 150)
      end
    end
    local cpCraft = blacksmithWindow:recursiveGetChildById('cpCraftBtn')
    if cpCraft then
      cpCraft.onClick = function()
        if forgeCommission then
          Blacksmith.send('BS_FORGE_CRAFT', { itemId = forgeCommission.entry.itemId, reqLvl = forgeCommission.reqLvl })
        end
      end
    end
    local cpBack = blacksmithWindow:recursiveGetChildById('cpBackBtn')
    if cpBack then
      cpBack.onClick = function()
        Blacksmith.closeForgeCommission()
      end
    end

    local closeButton = blacksmithWindow:recursiveGetChildById('closeButton')
    if closeButton then
      closeButton.onClick = function()
        Blacksmith.hide()
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
  infusionState = nil
  infSelectedSlot = 1
  infSelectedEssence = nil
  forgeState = nil
  forgeCommission = nil
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
  if pageId == 'infusionPage' then
    Blacksmith.send('BS_INFUSION_OPEN', {})
  elseif pageId == 'studyPage' or pageId == 'craftPage' then
    Blacksmith.send('BS_FORGE_OPEN', {})
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
        if w.setShader then
          pcall(function() w:setShader(rarityShaders[it.rarityId] or '') end)
        end
        local lbl = w:recursiveGetChildById('ilvlLabel')
        if lbl then
          lbl:setText(it.ilvl > 0 and tr('iLv.%d', it.ilvl) or '-')
        end
        local color = rarityColors[it.rarityId] or '#ffffff'
        w:setBorderColor(color .. (it.eligible and 'aa' or '44'))
        if not it.eligible then
          w:setOpacity(0.45)
        end
        -- Rich tooltip via mods/game_tooltips: a widget exposing
        -- getItemTooltip() gets the styled tooltip (rarity color/background).
        -- The item name already carries its rarity prefix, so only the
        -- fields already in the inventory payload are needed.
        local tip = {
          id = it.clientId or 0,
          name = it.name or '',
          desc = (not it.eligible) and trServerMsg(it.reason or 'Cannot be refined') or '',
          iLvl = it.ilvl or 0,
          rarity = it.rarityId or 0,
          count = 1,
          type = 'Common',
          first = 0,
          second = 0,
          third = 0,
          weight = 0,
          uLvl = 0,
          maxAttributes = 0,
          attributes = {},
        }
        w.getItemTooltip = function() return tip end
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
            setLabel('statusLabel', trServerMsg(it.reason or 'Cannot be refined'), '#de6f6f')
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
  setLabel('profRankName', trServerMsg(prog.rank or data.rank or ''), '#80c7f8')
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
          lbl:setText(tr('iLv %d', m.value))
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
        name:setText(trServerMsg(spec.key:sub(1,1):upper() .. spec.key:sub(2)))
      end
      if cat then
        cat:setText(tr('%s items', tr(SPEC_LABELS[spec.cat] or spec.cat)))
      end
      if perks then
        perks:setText(tr('-%d%% materials and +%d%% XP when refining %s\nRequired to ascend %s to the final tier',
          spec.materialBonus or 0, spec.xpBonus or 0, tr(SPEC_LABELS[spec.cat] or spec.cat),
          tr(SPEC_LABELS[spec.cat] or spec.cat)))
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
      cur:setText(tr('Active specialization: %s', trServerMsg(name)))
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
  setLabel('headerRank', trServerMsg(prog.rank or data.rank or ''), '#dfdfdf')
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
    setLabel('statusLabel', trServerMsg(data.note or ''), '#de6f6f')
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
    if itemSlot then
      itemSlot:setItemId(item.clientId or 0)
      if itemSlot.setShader then
        pcall(function() itemSlot:setShader(rarityShaders[item.rarityId] or '') end)
      end
    end
    local color = rarityColors[item.rarityId] or '#dfdfdf'
    setLabel('itemNameLabel', item.name or '', color)
    setLabel('itemInfoLabel', tr('Item Level %d', item.ilvl or 0), '#c0c0c0')
    setLabel('currentRarity', item.rarity or '', color)
  end

  if data.target then
    setLabel('targetRarity', data.target.rarity or '', rarityColors[data.target.rarityId] or '#dfdfdf')
    setLabel('targetSub', tr('TARGET'), '#c0c0c0')
    local ilvlText
    if data.target.ilvlMax and data.target.ilvlMax > (data.target.ilvlMin or 0) then
      ilvlText = tr('Item Level %d-%d', data.target.ilvlMin, data.target.ilvlMax)
    else
      ilvlText = tr('Item Level %d', data.target.ilvl or 0)
    end
    setLabel('resultLabel', string.format('%s: %s (%s)', tr('Result'), data.target.rarity or '', ilvlText),
      rarityColors[data.target.rarityId] or '#dfdfdf')
  elseif data.maxRarity then
    setLabel('targetRarity', tr('MAX RARITY'), '#ff7605')
    setLabel('targetSub', '', '#c0c0c0')
    setLabel('resultLabel', '')
  else
    setLabel('targetRarity', '-', '#dfdfdf')
    setLabel('resultLabel', '')
  end

  local statParts = {}
  for _, s in ipairs(data.statGains or {}) do
    if s.max and s.max > (s.min or 0) then
      statParts[#statParts + 1] = string.format('+%s %d-%d', s.name, s.min, s.max)
    else
      statParts[#statParts + 1] = string.format('+%s %d', s.name, s.max or s.min or 0)
    end
  end
  setLabel('statGainLabel', table.concat(statParts, '  '), '#00BC00')

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
    effParts[#effParts + 1] = tr('%s active', trServerMsg(key:sub(1,1):upper() .. key:sub(2)))
  end
  setLabel('effLabel', table.concat(effParts, '   '), '#c0c0c0')

  local status = ''
  if data.maxRarity then
    status = tr('This item has reached the maximum refinement tier.')
  elseif data.reason then
    status = trServerMsg(data.reason)
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
    local bonus = (data.ilvlBonusPct or 0) > 0 and tr(' iLv +%d%%', data.ilvlBonusPct) or ''
    setLabel('statusLabel',
      tr('Refined to %s!%s (+%d XP)  Consumed: %s', data.rarity or '', bonus, data.xp or 0, matText),
      '#00BC00')
  end
end

-- ==================== INFUSION ====================

local function infSlotRow(parent, slot, data)
  -- one infusion slot row: [icon] title | desc | action button
  local row = g_ui.createWidget('InfSlotRow', parent)
  if not row then return end
  local icon  = row:recursiveGetChildById('slotIcon')
  local title = row:recursiveGetChildById('slotTitle')
  local desc  = row:recursiveGetChildById('slotDesc')
  local btn   = row:recursiveGetChildById('slotBtn')
  local btn2  = row:recursiveGetChildById('slotBtn2')
  local selected = (infSelectedSlot == slot.index)
  row:setBackgroundColor(selected and '#355d8955' or '#00000066')
  row:setBorderColor(selected and '#80c7f8' or '#ffffff22')

  local locked = not slot.unlocked
  if icon then icon:setItemId(locked and 0 or (slot.essenceId or 0)) end
  if btn2 then btn2:setVisible(false) end
  if locked then
    title:setText(tr('Slot %d - locked', slot.index))
    title:setColor('#c0c0c0')
    desc:setText(slot.reqText and trServerMsg(slot.reqText) or tr('Locked'))
    btn:setVisible(false)
  elseif slot.essenceId then
    title:setText(slot.essenceName .. (slot.perfect and '  [PERFECT]' or ''))
    title:setColor(slot.color or '#dfdfdf')
    desc:setText(slot.desc or '')
    btn:setVisible(true)
    btn:setText(tr('Extract'))
    btn.onClick = function()
      Blacksmith.send('BS_EXTRACT', { slot = slot.index })
    end
    -- reroll: consumes 1 essence of the same family for a fresh roll
    if btn2 then
      local essCount = 0
      for _, e in ipairs((data and data.essences) or {}) do
        if e.id == slot.essenceId then essCount = e.count or 0 break end
      end
      btn2:setVisible(true)
      btn2:setText(tr('Reroll'))
      btn2:setEnabled(essCount > 0)
      btn2:setTooltip(essCount > 0
        and tr('Reroll this infusion (costs 1x %s)', slot.essenceName or '')
        or tr('Need 1x %s to reroll', slot.essenceName or ''))
      btn2.onClick = function()
        Blacksmith.send('BS_REROLL', { slot = slot.index })
      end
    end
  else
    title:setText(tr('Slot %d - empty%s', slot.index, selected and '  (target)' or ''))
    title:setColor(selected and '#80c7f8' or '#c0c0c0')
    desc:setText(selected and tr('Click an essence below to infuse') or tr('Click to select this slot'))
    btn:setVisible(false)
    -- whole row selects the slot (no Select button; onMouseRelease is the
    -- reliable pattern for dynamically created widgets in this client).
    local idx = slot.index
    row.onMouseRelease = function(self, pos, mb)
      if mb ~= MouseLeftButton or not self:containsPoint(pos) then return false end
      infSelectedSlot = idx
      Blacksmith.renderInfusion()
      return true
    end
  end
  return row
end

function Blacksmith.renderInfusion()
  if not blacksmithWindow then return end
  local data = infusionState
  if not data then return end

  -- inventory grid (same items as refinement; server rejects non-infusible)
  local grid = blacksmithWindow:recursiveGetChildById('infGrid')
  if grid then
    grid:destroyChildren()
    local shown = 0
    for _, it in ipairs(data.inventory or {}) do
      if it.cat == 'weapon' or it.cat == 'armor' then
        local w = g_ui.createWidget('BSGridItem', grid)
        if w then
          w:setItemId(it.clientId or 0)
          local lbl = w:recursiveGetChildById('ilvlLabel')
          if lbl then lbl:setText(it.ilvl > 0 and tr('iLv.%d', it.ilvl) or '-') end
          local uid = it.uid
          w.onMouseRelease = function(self, pos, btn)
            if btn ~= MouseLeftButton or not self:containsPoint(pos) then return false end
            Blacksmith.send('BS_PLACE_INFUSION', { uid = uid })
            return true
          end
          shown = shown + 1
        end
      end
    end
    local empty = blacksmithWindow:recursiveGetChildById('infEmpty')
    if empty then empty:setVisible(shown == 0) end
  end

  -- station
  local slotWidget = blacksmithWindow:recursiveGetChildById('infItemSlot')
  local nameLabel = blacksmithWindow:recursiveGetChildById('infItemName')
  if data.empty or not data.item then
    if slotWidget then slotWidget:setItemId(0) end
    if nameLabel then
      nameLabel:setText(tr('Select an item from your inventory'))
      nameLabel:setColor('#c0c0c0')
    end
  else
    if slotWidget then slotWidget:setItemId(data.item.clientId or 0) end
    if nameLabel then
      nameLabel:setText(tr('%s (iLv.%s - %s)', data.item.name, tostring(data.item.ilvl), data.slotKind or '?'))
      nameLabel:setColor('#dfdfdf')
    end
  end

  -- slots
  local slotsPanel = blacksmithWindow:recursiveGetChildById('infSlots')
  if slotsPanel then
    slotsPanel:destroyChildren()
    for _, slot in ipairs(data.slots or {}) do
      infSlotRow(slotsPanel, slot, data)
    end
  end

  -- essences: grid of icons, tooltip carries name/desc/count
  local essPanel = blacksmithWindow:recursiveGetChildById('infEssences')
  if essPanel then
    essPanel:destroyChildren()
    for _, e in ipairs(data.essences or {}) do
      local w = g_ui.createWidget('BSGridItem', essPanel)
      if w then
        w:setItemId(e.clientId or 0)
        local lbl = w:recursiveGetChildById('ilvlLabel')
        if lbl then lbl:setText('x' .. tostring(e.count or 0)) end
        local tip = tr('%s\n%s\nOwned: %d', e.name, e.desc or '', e.count or 0)
        if e.options then
          for _, optName in ipairs(e.options) do
            tip = tip .. '\n - ' .. optName
          end
        end
        if not e.applies then
          tip = tip .. tr('\n(No effect on this item slot)')
        end
        w:setTooltip(tip)
        local canUse = e.applies and (e.count or 0) > 0 and not data.empty
        local selected = (infSelectedEssence == e.id)
        if selected then
          w:setBorderWidth(2)
          w:setBorderColor('#80c7f8')
          w:setBackgroundColor('#355d89cc')
        else
          w:setBorderColor(e.applies and (e.color or '#ffffff33') or '#de6f6f55')
          w:setBackgroundColor(canUse and '#00000088' or '#00000033')
        end
        if canUse then
          local eid = e.id
          w.onMouseRelease = function(self, pos, btn)
            if btn ~= MouseLeftButton or not self:containsPoint(pos) then return false end
            infSelectedEssence = eid
            Blacksmith.renderInfusion()
            return true
          end
        end
      end
    end
  end

  -- apply button + preview line
  local applyBtn = blacksmithWindow:recursiveGetChildById('infApplyBtn')
  local selEssence = nil
  for _, e in ipairs(data.essences or {}) do
    if e.id == infSelectedEssence then selEssence = e break end
  end
  local slotState = nil
  for _, s in ipairs(data.slots or {}) do
    if s.index == infSelectedSlot then slotState = s break end
  end
  local canApply = selEssence and selEssence.applies and (selEssence.count or 0) > 0
    and not data.empty and slotState and slotState.unlocked and not slotState.essenceId
  if applyBtn then
    applyBtn:setEnabled(canApply and true or false)
    applyBtn:setText(selEssence and tr('Infuse %s', selEssence.name) or tr('Infuse'))
    applyBtn:setColor(canApply and '#80c7f8' or '#dfdfdf88')
    applyBtn:setBackgroundColor(canApply and '#355d89' or '#00000055')
  end

  local prev = blacksmithWindow:recursiveGetChildById('infPreview')
  if prev then
    if data.empty then
      prev:setText('')
      prev:setColor('#80c7f8')
    elseif data.blockReason then
      prev:setText(trServerMsg(data.blockReason))
      prev:setColor('#de6f6f')
    elseif selEssence then
      prev:setText(tr('%s -> Slot %d  |  %s  |  Extract cost: %s gold',
        selEssence.name, infSelectedSlot, selEssence.desc or '', tostring(data.extractCost or 0)))
      prev:setColor('#80c7f8')
    else
      prev:setText(tr('Select a slot and an essence  |  Extract cost: %s gold',
        tostring(data.extractCost or 0)))
      prev:setColor('#80c7f8')
    end
  end
end

-- ==================== FORGE ====================

local function forgeLibRow(parent, entry)
  local row = g_ui.createWidget('ForgeLibRow', parent)
  if not row then return end
  local icon  = row:recursiveGetChildById('libIcon')
  local title = row:recursiveGetChildById('libTitle')
  local desc  = row:recursiveGetChildById('libDesc')
  local btn   = row:recursiveGetChildById('libBtn')
  if icon then icon:setItemId(entry.clientId or 0) end
  if title then
    title:setText(entry.name or '?')
    title:setColor(entry.mastered and '#00BC00' or '#dfdfdf')
  end
  if desc then
    local tierTxt = tr('%s (%d knowledge)', trServerMsg(entry.tierName or ''), entry.knowledge or 0)
    if entry.mastered then
      desc:setText(tr('%s  |  best iLv %d', tierTxt, entry.maxIlvl or 0))
    else
      desc:setText(tierTxt)
    end
  end
  if btn then
    if entry.mastered then
      btn:setVisible(true)
      btn:setText(tr('Craft'))
      btn:setEnabled(true)
      btn.onClick = function()
        Blacksmith.startForgeCommission(entry)
      end
    else
      btn:setVisible(false)
    end
  end
  return row
end

function Blacksmith.renderForge()
  if not blacksmithWindow then return end
  local data = forgeState
  if not data then return end

  -- craft station swaps between hint and commission view
  local hint = blacksmithWindow:recursiveGetChildById('craftHint')
  local anvil = blacksmithWindow:recursiveGetChildById('craftAnvil')
  local craftP = blacksmithWindow:recursiveGetChildById('forgeCraftPanel')
  if hint then hint:setVisible(forgeCommission == nil) end
  if anvil then anvil:setVisible(forgeCommission == nil) end
  if craftP then craftP:setVisible(forgeCommission ~= nil) end

  -- inventory grid: every upgradable item can be deconstructed
  local grid = blacksmithWindow:recursiveGetChildById('forgeGrid')
  if grid then
    grid:destroyChildren()
    local shown = 0
    for _, it in ipairs(data.inventory or {}) do
      local w = g_ui.createWidget('BSGridItem', grid)
      if w then
        w:setItemId(it.clientId or 0)
        local lbl = w:recursiveGetChildById('ilvlLabel')
        if lbl then lbl:setText(it.ilvl > 0 and tr('iLv.%d', it.ilvl) or '-') end
        local uid = it.uid
        w:setTooltip(it.name .. (it.eligible == false and ('\n' .. trServerMsg(it.reason or '')) or ''))
        w.onMouseRelease = function(self, pos, btn)
          if btn ~= MouseLeftButton or not self:containsPoint(pos) then return false end
          Blacksmith.send('BS_PLACE_FORGE', { uid = uid })
          return true
        end
        shown = shown + 1
      end
    end
    local empty = blacksmithWindow:recursiveGetChildById('forgeEmpty')
    if empty then empty:setVisible(shown == 0) end
  end

  -- station
  local slotWidget = blacksmithWindow:recursiveGetChildById('forgeItemSlot')
  local nameLabel  = blacksmithWindow:recursiveGetChildById('forgeItemName')
  local know       = blacksmithWindow:recursiveGetChildById('forgeKnow')
  local prog       = blacksmithWindow:recursiveGetChildById('forgeProg')
  local yield      = blacksmithWindow:recursiveGetChildById('forgeYield')
  local decon      = blacksmithWindow:recursiveGetChildById('forgeDeconBtn')

  if data.empty or not data.item then
    if slotWidget then slotWidget:setItemId(0) end
    if nameLabel then nameLabel:setText(tr('Select an item to deconstruct')) end
    if know then know:setText('') end
    if prog then prog:setPercent(0) end
    if yield then yield:setText('') end
    if decon then decon:setEnabled(false) end
  else
    if slotWidget then slotWidget:setItemId(data.item.clientId or 0) end
    if nameLabel then
      nameLabel:setText(('%s (iLv.%s - %s)'):format(data.item.name, tostring(data.item.ilvl), data.item.cat or '?'))
    end
    local tierTxt = data.tierName or 'Unknown'
    local k = data.knowledge or 0
    local tierStart = data.tierStart or 0
    if data.nextTierReq then
      local span = math.max(1, data.nextTierReq - tierStart)
      if know then
        know:setText(tr('Knowledge: %d/%d - %s', k - tierStart, span, tierTxt))
      end
      if prog then prog:setPercent(math.floor((k - tierStart) / span * 100)) end
    else
      if know then know:setText(tr('Knowledge: %d - MASTERED', k)) end
      if prog then prog:setPercent(100) end
    end
    if yield then
      local parts = { tr('%dx %s', (data.yield and data.yield.barCount) or 0,
        (data.yield and data.yield.barName) or 'bars') }
      if data.yield and data.yield.essenceName then
        parts[#parts + 1] = tr('%d%% chance of %s', data.yield.essenceChance or 0, data.yield.essenceName)
      end
      if data.specMatch then
        parts[#parts + 1] = tr('+2 Knowledge (spec bonus)')
      else
        parts[#parts + 1] = tr('+1 Knowledge (off-spec)')
      end
      yield:setText(tr('Yield: %s', table.concat(parts, '  +  ')))
      yield:setColor(data.specMatch and '#00BC00' or '#c0c0c0')
    end
    if decon then decon:setEnabled(true) end
  end

  -- library
  local libPanel = blacksmithWindow:recursiveGetChildById('forgeLibrary')
  local libHint = blacksmithWindow:recursiveGetChildById('forgeLibHint')
  if libHint then libHint:setVisible(#(data.library or {}) == 0) end
  if libPanel then
    libPanel:destroyChildren()
    for _, entry in ipairs(data.library or {}) do
      forgeLibRow(libPanel, entry)
    end
  end
end

function Blacksmith.onForge(data)
  forgeState = data
  -- keep an open commission in sync with the refreshed library entry
  if forgeCommission and data.library then
    for _, e in ipairs(data.library) do
      if e.itemId == forgeCommission.entry.itemId then
        forgeCommission.entry = e
        break
      end
    end
  end
  Blacksmith.renderForge()
end

function Blacksmith.onForgeDone(data)
  if not data then return end
  if not data.ok then
    setLabel('statusLabel', trServerMsg(data.reason or 'Forge action failed'), '#de6f6f')
    return
  end
  if data.crafted then
    Blacksmith.closeForgeCommission()
    setLabel('statusLabel', tr('Crafted %s (iLv %s)!', data.name or '', tostring(data.ilvl or '?')), '#00BC00')
  else
    local extra = data.tierUp and tr('  TIER UP: %s!', data.tierName or '') or ''
    local best = data.newBest and tr('  NEW best iLv %d', data.maxIlvl or 0) or ''
    local learned = data.learned and tr('  +%d Knowledge%s (%s)', data.knowledgeGain or 1,
      data.specMatch and ' spec bonus' or '', data.tierName or '') or ''
    setLabel('statusLabel',
      tr('Deconstructed %s -> %s%s%s%s', data.name or '', data.gained or '', learned, extra, best), '#00BC00')
  end
end

-- commission slip: station state for crafting a mastered item
function Blacksmith.startForgeCommission(entry)
  if not blacksmithWindow or not entry or not entry.mastered then return end
  forgeCommission = { entry = entry, reqLvl = math.max(15, entry.reqMax or 15) }
  local hint = blacksmithWindow:recursiveGetChildById('craftHint')
  local anvil = blacksmithWindow:recursiveGetChildById('craftAnvil')
  local panel = blacksmithWindow:recursiveGetChildById('forgeCraftPanel')
  if not panel then return end
  if hint then hint:setVisible(false) end
  if anvil then anvil:setVisible(false) end
  panel:setVisible(true)
  local icon = panel:recursiveGetChildById('cpIcon')
  if icon then icon:setItemId(entry.clientId or 0) end
  local name = panel:recursiveGetChildById('cpName')
  if name then name:setText(entry.name or '') end
  local lvl = panel:recursiveGetChildById('cpLevel')
  if lvl then lvl:setText(tr('Level %d', forgeCommission.reqLvl)) end
  local info = panel:recursiveGetChildById('cpInfo')
  if info then info:setText('') end
  local costs = panel:recursiveGetChildById('cpCosts')
  if costs then costs:destroyChildren() end
  local sliderTitle = panel:recursiveGetChildById('cpSliderTitle')
  local slider = panel:recursiveGetChildById('cpSlider')
  -- if the best studied specimen never reaches req 15 there is no real
  -- range: hide the slider instead of showing a dead one
  local maxReq = math.max(15, entry.reqMax or 15)
  if sliderTitle then
    sliderTitle:setText(maxReq > 15
      and tr('Forge for a hero of level')
      or tr('This piece can only be forged basic'))
  end
  local cpMax = panel:recursiveGetChildById('cpMax')
  if cpMax then cpMax:setText(tostring(maxReq)) end
  local sliderRow = panel:recursiveGetChildById('cpSliderRow')
  if sliderRow then sliderRow:setVisible(maxReq > 15) end
  if slider then
    slider:setRange(15, maxReq)
    slider:setValue(forgeCommission.reqLvl) -- fires onValueChange -> preview request
  end
  -- fallback if the slider range made the value a no-op
  Blacksmith.send('BS_FORGE_CRAFT_INFO', { itemId = entry.itemId, reqLvl = forgeCommission.reqLvl })
end

function Blacksmith.closeForgeCommission()
  forgeCommission = nil
  local hint = blacksmithWindow and blacksmithWindow:recursiveGetChildById('craftHint')
  local anvil = blacksmithWindow and blacksmithWindow:recursiveGetChildById('craftAnvil')
  local panel = blacksmithWindow and blacksmithWindow:recursiveGetChildById('forgeCraftPanel')
  if panel then panel:setVisible(false) end
  if hint then hint:setVisible(true) end
  if anvil then anvil:setVisible(true) end
end

local function forgeCostRow(parent, clientId, text, have, need)
  local row = g_ui.createWidget('MaterialRow', parent)
  if not row then return end
  local icon = row:recursiveGetChildById('matIcon')
  if icon then icon:setItemId(clientId or 0) end
  local name = row:recursiveGetChildById('matName')
  if name then name:setText(text or '') end
  local count = row:recursiveGetChildById('matCount')
  if count then
    count:setText(tr('(%d)', have or 0))
    count:setColor((have or 0) >= (need or 0) and '#00BC00' or '#de6f6f')
  end
  return row
end

local function forgeFeeRow(parent, text, have, need)
  local row = g_ui.createWidget('FeeRow', parent)
  if not row then return end
  local name = row:recursiveGetChildById('feeName')
  if name then name:setText(text or '') end
  local count = row:recursiveGetChildById('feeCount')
  if count then
    count:setText(tr('(%d)', have or 0))
    count:setColor((have or 0) >= (need or 0) and '#00BC00' or '#de6f6f')
  end
  return row
end

function Blacksmith.onForgeCraftInfo(data)
  if not blacksmithWindow or not forgeCommission or not data or not data.ok then return end
  if data.itemId ~= forgeCommission.entry.itemId then return end
  forgeCommission.reqLvl = data.reqLvl
  forgeCommission.info = data
  local panel = blacksmithWindow:recursiveGetChildById('forgeCraftPanel')
  if not panel then return end
  local lvl = panel:recursiveGetChildById('cpLevel')
  if lvl then lvl:setText(tr('Level %d', data.reqLvl)) end
  local info = panel:recursiveGetChildById('cpInfo')
  if info then
    local stats = ''
    if data.stats then
      local parts = {}
      for _, s in ipairs(data.stats) do
        parts[#parts + 1] = '+' .. s.name .. ' ' .. (s.max or s.min or 0)
      end
      if #parts > 0 then stats = '  |  ' .. table.concat(parts, ' ') end
    end
    local cap = (data.maxIlvl and data.maxIlvl > 0) and tr('  ·  best iLv %d', data.maxIlvl) or ''
    local boostParts = {}
    if (data.boostKnow or 0) > 0 then
      boostParts[#boostParts + 1] = tr('+%d knowledge', data.boostKnow)
    end
    if (data.boostSpec or 0) > 0 then
      boostParts[#boostParts + 1] = tr('+%d spec', data.boostSpec)
    end
    local boost = #boostParts > 0 and ('  (' .. table.concat(boostParts, ' ') .. ')') or ''
    info:setText(tr('iLv ~%d%s%s%s', data.ilvl or 1, boost, cap, stats))
  end
  local c = data.cost or {}
  local costs = panel:recursiveGetChildById('cpCosts')
  if costs then
    costs:destroyChildren()
    if (c.barCount or 0) > 0 then
      forgeCostRow(costs, c.barClientId, tr('%dx %s', c.barCount, c.barName or 'bar'), c.barHave, c.barCount)
    end
    if c.essenceName then
      forgeCostRow(costs, c.essenceClientId, tr('1x %s', c.essenceName), c.essenceHave, 1)
    end
    if (c.guardian or 0) > 0 then
      forgeCostRow(costs, c.guardianClientId, tr('%dx %s', c.guardian, c.guardianName or 'essence'), c.guardianHave, c.guardian)
    end
    if (c.gold or 0) > 0 then
      forgeFeeRow(costs, tr('Forge fee: %d gold', c.gold), data.goldHave or 0, c.gold)
    end
  end
  local btn = panel:recursiveGetChildById('cpCraftBtn')
  if btn then btn:setEnabled(data.canCraft == true) end
end

function Blacksmith.onInfusion(data)
  infusionState = data
  -- keep selected slot sane
  if data.slots then
    local valid = false
    for _, s in ipairs(data.slots) do
      if s.index == infSelectedSlot and s.unlocked then valid = true end
    end
    if not valid then
      for _, s in ipairs(data.slots) do
        if s.unlocked and not s.essenceId then infSelectedSlot = s.index valid = true break end
      end
      if not valid then infSelectedSlot = 1 end
    end
  end
  -- keep selected essence sane
  if data.empty or not data.essences then
    infSelectedEssence = nil
  else
    local stillValid = false
    for _, e in ipairs(data.essences) do
      if e.id == infSelectedEssence and e.applies and (e.count or 0) > 0 then
        stillValid = true
        break
      end
    end
    if not stillValid then infSelectedEssence = nil end
  end
  Blacksmith.renderInfusion()
end

function Blacksmith.onInfused(data)
  if data.ok then
    if data.extracted then
      setLabel('statusLabel', tr('Infusion extracted'), '#00BC00')
    else
      local star = data.perfect and tr(' PERFECT!') or ''
      local res = (data.resonant and data.resonant > 1) and tr(' [Resonance x%d]', data.resonant) or ''
      local name = data.enchant or data.essence or ''
      setLabel('statusLabel',
        tr('%s %s q%d%s%s', data.rerolled and tr('Rerolled') or tr('Infused'),
          name, data.quality or 0, res, star), '#00BC00')
    end
  else
    setLabel('statusLabel', trServerMsg(data.reason or 'Infusion failed'), '#de6f6f')
  end
end

function Blacksmith.onRejected(data)
  Blacksmith.setRefining(false)
  -- The server re-sends BS_UPDATE after a rejection, which restores
  -- placedUid / slot visuals if a session still exists.
  setLabel('statusLabel', trServerMsg(data and data.reason or 'Cannot refine'), '#de6f6f')
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
      local ca = blacksmithWindow:recursiveGetChildById('craftAnvil')
      if ca then ca:setItemId(anvilClientId) end
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
  elseif event == 'BS_INFUSION' then
    Blacksmith.onInfusion(data)
  elseif event == 'BS_INFUSED' then
    Blacksmith.onInfused(data)
  elseif event == 'BS_FORGE' then
    Blacksmith.onForge(data)
  elseif event == 'BS_FORGE_DONE' then
    Blacksmith.onForgeDone(data)
  elseif event == 'BS_FORGE_CRAFT_INFO' then
    Blacksmith.onForgeCraftInfo(data)
  elseif event == 'BS_REJECTED' then
    Blacksmith.onRejected(data)
  end
end
