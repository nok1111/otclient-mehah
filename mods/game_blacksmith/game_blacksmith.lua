Blacksmith = {}

local BLACKSMITH_OPCODE = 235

local blacksmithWindow = nil
local itemSlot = nil
local placedUid = nil
local inventoryItems = {}
local currentFilter = 'all'
local filterButtons = {}
local anvilClientId = 0

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

local function addProfLabel(parent, text, color, icon)
  local lbl = g_ui.createWidget('UILabel', parent)
  if lbl then
    lbl:setText(text)
    lbl:setColor(color or '#dfdfdf')
    lbl:setFont('verdana-11px-rounded')
    lbl:setTextAutoResize(true)
    lbl:setTextWrap(true)
    lbl:setWidth(200)
  end
  return lbl
end

function Blacksmith.renderProfession(data)
  if not blacksmithWindow then return end
  local list = blacksmithWindow:recursiveGetChildById('profScroll')
  if not list then return end
  list:destroyChildren()

  local prog = data.progression or {}

  addProfLabel(list, tr('Level %d - %s', data.level or 0, prog.rank or data.rank or ''), '#80c7f8')

  -- Refinement tiers
  addProfLabel(list, tr('REFINEMENT TIERS'), '#c0c0c0')
  for _, t in ipairs(prog.tiers or {}) do
    local mark = t.unlocked and 'v ' or 'x '
    local color = t.unlocked and '#00BC00' or '#dfdfdf88'
    addProfLabel(list, mark .. t.label .. (t.unlocked and '' or ('  (Lv.' .. t.reqLevel .. ')')), color)
  end

  -- Perks
  addProfLabel(list, '', '#dfdfdf')
  addProfLabel(list, tr('PROFESSION BENEFITS'), '#c0c0c0')
  for _, p in ipairs(prog.perks or {}) do
    local mark = p.unlocked and 'v ' or 'x '
    local color = p.unlocked and '#00BC00' or '#dfdfdf88'
    addProfLabel(list, mark .. p.label .. (p.unlocked and '' or ('  (Lv.' .. p.reqLevel .. ')')), color)
  end

  -- Mastery
  local mastery = prog.mastery or {}
  addProfLabel(list, '', '#dfdfdf')
  addProfLabel(list, tr('REFINEMENT MASTERY'), '#c0c0c0')
  addProfLabel(list, tr('Highest Item Level refined: %d', mastery.maxIlvl or 0), '#dfdfdf')
  addProfLabel(list, tr('Total refinements: %d', mastery.total or 0), '#dfdfdf')
  for _, m in ipairs(mastery.milestones or {}) do
    local mark = m.done and 'v ' or 'x '
    addProfLabel(list, mark .. 'Item Level ' .. m.value, m.done and '#00BC00' or '#dfdfdf88')
  end
  if mastery.next then
    addProfLabel(list, tr('Next: refine an Item Level %d item', mastery.next), '#80c7f8')
  end

  -- Specialization
  addProfLabel(list, '', '#dfdfdf')
  addProfLabel(list, tr('SPECIALIZATION'), '#c0c0c0')
  local spec = prog.specialization or {}
  if spec.unlocked then
    addProfLabel(list, tr('Available'), '#00BC00')
  else
    addProfLabel(list, tr('Locked - unlocks at Blacksmith Level %d', spec.reqLevel or 30), '#dfdfdf88')
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

function Blacksmith.onResult(data)
  Blacksmith.setRefining(false)
  if data and data.success then
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
  elseif event == 'BS_RESULT' then
    Blacksmith.onResult(data)
  elseif event == 'BS_REJECTED' then
    Blacksmith.onRejected(data)
  end
end
