--[[
  Dominion tab for the Guild Management window.
  Data comes from modules.game_dominion (opcode 237 headless layer).
]]

local panel = nil
local filter = 'all' -- all|neutral|owned|conflict|mine

local STATE_COLORS = {
  available = '#c0c0c0',
  protected = '#80c7f8',
  owned = '#00BC00',
  contested = '#de6f6f',
}
local FILTERS = {
  { id = 'fAll', key = 'all', label = 'All' },
  { id = 'fNeutral', key = 'neutral', label = 'Neutral' },
  { id = 'fOwned', key = 'owned', label = 'Owned' },
  { id = 'fConflict', key = 'conflict', label = 'Conflict' },
  { id = 'fMine', key = 'mine', label = 'My guild' },
}

local function dom()
  return modules and modules.game_dominion or nil
end

local function myGuildId()
  return myGuild and myGuild.id or nil
end

local function passesFilter(t)
  if filter == 'all' then return true end
  if filter == 'mine' then return t.guildId and t.guildId == myGuildId() end
  if filter == 'conflict' then
    return t.state == 'vulnerable' or t.state == 'contested' or t.state == 'siege'
  end
  if filter == 'owned' then return t.guildId ~= nil end
  if filter == 'neutral' then return t.guildId == nil end
  return true
end

local function sortedIds(d)
  local ids = {}
  for id in pairs(d.territories) do ids[#ids + 1] = id end
  table.sort(ids, function(a, b)
    local ta, tb = d.territories[a], d.territories[b]
    return (ta.name or '') < (tb.name or '')
  end)
  return ids
end

local function renderList()
  if not panel then return end
  local d = dom()
  local box = panel:recursiveGetChildById('territoryScrollBox')
  if not box then return end
  box:destroyChildren()
  if not d then return end

  for _, id in ipairs(sortedIds(d)) do
    local t = d.territories[id]
    if passesFilter(t) then
      local row = g_ui.createWidget('Panel', box)
      row:setHeight(34)
      row:setFocusable(true)
      row:setPhantom(false)
      row:setBackgroundColor(id == d.selectedId and '#355d89' or '#dfdfdf18')
      row.territoryId = id

      local bar = g_ui.createWidget('UIWidget', row)
      bar:setWidth(4)
      bar:addAnchor(AnchorTop, 'parent', AnchorTop)
      bar:addAnchor(AnchorLeft, 'parent', AnchorLeft)
      bar:addAnchor(AnchorBottom, 'parent', AnchorBottom)
      bar:setBackgroundColor(STATE_COLORS[t.state] or '#dfdfdf')

      local name = g_ui.createWidget('UILabel', row)
      name:setText(t.name or ('Territory ' .. id))
      name:setFont('verdana-11px-rounded')
      name:setColor('#dfdfdf')
      name:addAnchor(AnchorLeft, 'parent', AnchorLeft)
      name:addAnchor(AnchorTop, 'parent', AnchorTop)
      name:setMarginLeft(10)
      name:setMarginTop(3)

      local info = g_ui.createWidget('UILabel', row)
      local owner = t.guildName or 'Unclaimed'
      info:setText(owner)
      info:setFont('verdana-11px-antialised')
      info:setColor(t.guildName and '#80c7f8' or '#c0c0c088')
      info:addAnchor(AnchorLeft, 'parent', AnchorLeft)
      info:addAnchor(AnchorBottom, 'parent', AnchorBottom)
      info:setMarginLeft(10)
      info:setMarginBottom(3)

      row.onClick = function()
        local dd = dom()
        if dd then dd.selectTerritory(id) end
      end
    end
  end
end

local function setText(id, text, color)
  local w = panel and panel:recursiveGetChildById(id)
  if w then w:setText(text) end
  if w and color then w:setColor(color) end
end

local function renderDetail()
  if not panel then return end
  local d = dom()
  local t = d and d.selectedId and d.territories[d.selectedId]

  setText('detailTitle', t and t.name or 'Select a territory')
  setText('stateBadge', t and ('[' .. (t.state or 'neutral') .. ']') or '',
          t and STATE_COLORS[t.state] or '#c0c0c0')

  if not t then
    setText('detailInfo', '')
    return
  end

  local lines = {
    string.format('Owner: %s', t.guildName or 'Unclaimed'),
    string.format('Territorial lord: %s', t.lordName or '—'),
    string.format('Stability: %d%%', t.stability or 0),
    string.format('Specialization: %s', t.specialization or '—'),
    t.linkedZoneNames and ('Zones: ' .. t.linkedZoneNames) or nil,
    string.format('Tier: %s', t.tier or '—'),
    string.format('Production stock: %s', t.productionStock or '—'),
    string.format('State: %s   Protected: %s', t.state or 'neutral',
                  t.protectedUntil and 'yes' or 'no'),
  }
  if t.siege then
    local s = t.siege
    if s.phase == 'preparing' then
      lines[#lines + 1] = string.format(
        'SIEGE declared by %s — starts %s',
        s.attackerGuildName or '?',
        os.date('%H:%M %x', s.windowStart or 0))
    else
      lines[#lines + 1] = string.format(
        'SIEGE ACTIVE: %s holds core %ds/%ds — ends %s',
        s.attackerGuildName or '?', s.hold or 0, s.holdNeeded or 60,
        os.date('%H:%M', s.windowEnd or 0))
    end
  end
  setText('detailInfo', table.concat(lines, '\n'))

  -- contributors / history from dominion-detail
  local contribBox = panel:recursiveGetChildById('contribBox')
  if contribBox then
    contribBox:destroyChildren()
    if d.detail and d.detail.id == t.id and d.detail.contributions then
      for i, c in ipairs(d.detail.contributions) do
        if i > 5 then break end
        local l = g_ui.createWidget('UILabel', contribBox)
        l:setText(string.format('%d. %s — %d', i, c.name or '?', c.points or 0))
        l:setColor(i == 1 and '#80c7f8' or '#c0c0c0')
      end
    end
  end

  local historyBox = panel:recursiveGetChildById('historyBox')
  if historyBox then
    historyBox:destroyChildren()
    if d.detail and d.detail.id == t.id and d.detail.history then
      for i, h in ipairs(d.detail.history) do
        if i > 4 then break end
        local l = g_ui.createWidget('UILabel', historyBox)
        l:setText(h.text or h.event or '?')
        l:setColor('#c0c0c0')
      end
    end
  end
end

function renderDominion()
  renderList()
  renderDetail()
end

function setupDominionUI(dominionPanel)
  panel = dominionPanel

  for _, f in ipairs(FILTERS) do
    local btn = panel:recursiveGetChildById(f.id)
    if btn then
      btn.onClick = function()
        filter = f.key
        renderDominion()
      end
    end
  end

  local function actionBtn(id, fn)
    local b = panel:recursiveGetChildById(id)
    if b then b.onClick = fn end
  end

  actionBtn('mapButton', function()
    local d = dom()
    if modules.game_MapTravel and modules.game_MapTravel.show then
      modules.game_MapTravel.show()
    end
  end)
  actionBtn('lordButton', function()
    local d = dom()
    local input = panel:recursiveGetChildById('lordInput')
    local name = input and input:getText() or ''
    if d and #name > 0 then
      d.send({ topic = 'dominion-action', action = 'appoint-lord', name = name })
      input:setText('')
    end
  end)

  -- live updates from the protocol layer
  if dom() then
    dom().onDataChanged = function()
      addEvent(renderDominion)
    end
    dom().requestSnapshot()
  end
end

-- entry point used by modules.game_dominion.show() (MapTravel markers)
function openDominionTab()
  local win = g_ui.getRootWidget():recursiveGetChildById('guildManagementWindow')
  if win then
    win:show()
    win:raise()
    if dominionPanelBtn then
      win.tabBar:selectTab(dominionPanelBtn)
    end
  end
end
