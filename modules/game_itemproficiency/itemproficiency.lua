modules.game_itemproficiency = modules.game_itemproficiency or {}

local Proficiency = modules.game_itemproficiency

local OPCODE = 220

-- clientId(string) -> { t = tier, m = maxTier, p = pct }
Proficiency.tiers = Proficiency.tiers or {}

local window = nil
local currentItemId = 0
local registry = {}          -- list of { itemId, clientId, name, category, ... }
local currentFilter = 0      -- 0 = all categories
local searchText = ''
local selectedCell = nil

-- Mirror of server IP_CATEGORY (config.lua)
local CATEGORY = {
    NONE = 0, ARMOR = 1, SHIELD = 2, WEAPON_1H = 3,
    WEAPON_2H = 4, BOW = 5, RING = 6, NECKLACE = 7,
    BOOTS = 8, WAND = 9,
}

local filterTabs = {
    { label = 'All',    cat = 0 },
    { label = 'Armor',  cat = CATEGORY.ARMOR },
    { label = 'Shield', cat = CATEGORY.SHIELD },
    { label = '1H',     cat = CATEGORY.WEAPON_1H },
    { label = 'Wands',  cat = CATEGORY.WAND },
    { label = '2H',     cat = CATEGORY.WEAPON_2H },
    { label = 'Bow',    cat = CATEGORY.BOW },
    { label = 'Ring',   cat = CATEGORY.RING },
    { label = 'Neck',   cat = CATEGORY.NECKLACE },
    { label = 'Boots',  cat = CATEGORY.BOOTS },
}

local tierColors = {
    [0] = '#7d7d7d',
    [1] = '#9FD49F',
    [2] = '#67C7E2',
    [3] = '#5B8DEF',
    [4] = '#A66CFF',
    [5] = '#E2A85B',
    [6] = '#E2675B',
    [7] = '#FFD17A',
}

local function formatNumber(n)
    n = math.floor(tonumber(n) or 0)
    local s = tostring(n)
    local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return (out:gsub("^,", ""))
end

-- ───────────────────────────────────────────────────────────────────────────
-- Networking
-- ───────────────────────────────────────────────────────────────────────────
local function sendAction(action, data)
    local protocol = g_game.getProtocolGame()
    if not protocol then
        return
    end
    protocol:sendExtendedOpcode(OPCODE, json.encode({
        action = action,
        data = data or {},
    }))
end

-- ───────────────────────────────────────────────────────────────────────────
-- Left container: filters + item grid
-- ───────────────────────────────────────────────────────────────────────────
local function rebuildItemGrid()
    if not window or window:isDestroyed() then return end
    local grid = window:recursiveGetChildById('itemGrid')
    if not grid then return end
    grid:destroyChildren()
    selectedCell = nil

    local needle = searchText:lower()
    for _, entry in ipairs(registry) do
        local catOk = (currentFilter == 0) or (entry.category == currentFilter)
        local nameOk = (needle == '') or (tostring(entry.name):lower():find(needle, 1, true) ~= nil)
        if catOk and nameOk then
            local cell = g_ui.createWidget('IPItemCell', grid)
            cell:setDraggable(false)
            cell:setItemId(tonumber(entry.clientId) or 0)
            cell:setTooltip(string.format('%s\n%s - Milestone %d', entry.name, entry.categoryName or '', entry.milestone or 0))

            local itemId = entry.itemId
            cell.profItemId = itemId
            if itemId == currentItemId then
                cell:setBorderColor('#44E06A')
                selectedCell = cell
            end

            cell.onMouseRelease = function(self, mousePos, mouseButton)
                if mouseButton == MouseLeftButton then
                    sendAction('select_item', { itemId = itemId })
                    return true
                end
                return false
            end
        end
    end
end

-- Lightweight selection refresh (no grid rebuild, keeps scroll position).
local function updateGridSelection()
    if not window or window:isDestroyed() then return end
    local grid = window:recursiveGetChildById('itemGrid')
    if not grid then return end
    for _, cell in ipairs(grid:getChildren()) do
        if cell.profItemId == currentItemId then
            cell:setBorderColor('#44E06A')
            selectedCell = cell
        else
            cell:setBorderColor('#00000000')
        end
    end
end

local function buildFilterButtons()
    local panel = window:recursiveGetChildById('filterButtons')
    if not panel then return end
    panel:destroyChildren()

    for _, tab in ipairs(filterTabs) do
        local btn = g_ui.createWidget('IPFilterButton', panel)
        btn:setText(tab.label)
        btn:setWidth(48)
        btn:setChecked(tab.cat == currentFilter)
        local cat = tab.cat
        btn.onClick = function()
            currentFilter = cat
            for _, child in ipairs(panel:getChildren()) do
                child:setChecked(false)
            end
            btn:setChecked(true)
            rebuildItemGrid()
        end
    end
end

-- ───────────────────────────────────────────────────────────────────────────
-- Window
-- ───────────────────────────────────────────────────────────────────────────
local function ensureWindow()
    if window and not window:isDestroyed() then
        return true
    end

    local parent = rootWidget
    if modules.game_interface and modules.game_interface.getRootPanel then
        parent = modules.game_interface.getRootPanel() or rootWidget
    end

    window = g_ui.createWidget('ItemProficiencyWindow', parent)
    window:hide()

    local closeButton = window:recursiveGetChildById('closeButton')
    if closeButton then
        closeButton.onClick = function() Proficiency.hide() end
    end

    local resetButton = window:recursiveGetChildById('resetButton')
    if resetButton then
        resetButton.onClick = function()
            if currentItemId > 0 then
                sendAction('reset', { itemId = currentItemId })
            end
        end
    end

    local upgradeButton = window:recursiveGetChildById('upgradeButton')
    if upgradeButton then
        upgradeButton.onClick = function()
            if currentItemId > 0 then
                sendAction('upgrade', { itemId = currentItemId })
            end
        end
    end

    local searchBox = window:recursiveGetChildById('searchBox')
    if searchBox then
        searchBox.onTextChange = function(widget, text)
            searchText = text or ''
            rebuildItemGrid()
        end
    end

    buildFilterButtons()
    return true
end

-- ── Milestone header (star row) ──────────────────────────────────────────────
local function buildMilestoneHeader(data)
    local header = window:getChildById('milestoneHeader')
    if not header then return end
    header:destroyChildren()

    local total = data.maxColumns or 7
    for col = 1, total do
        local cell = g_ui.createWidget('IPMilestoneCell', header)
        local colData = (data.columns or {})[col]
        local unlocked = colData and colData.unlocked
        local star = cell:getChildById('star')
        if star then
            star:setImageColor(unlocked and (tierColors[math.min(col, 7)] or '#FFD17A') or '#555555')
        end
    end
end

-- ── Trait columns ────────────────────────────────────────────────────────────
local function buildColumns(data)
    local container = window:getChildById('columnsContainer')
    if not container then return end
    container:destroyChildren()

    for _, colData in ipairs(data.columns or {}) do
        local col = g_ui.createWidget('IPColumn', container)

        for _, trait in ipairs(colData.traits or {}) do
            local btn = g_ui.createWidget('IPTraitNode', col)
            local iconWidget = btn:getChildById('icon')
            if iconWidget and trait.icon and trait.icon ~= '' then
                iconWidget:setImageSource(trait.icon)
            end

            local lockOverlay = btn:getChildById('lockOverlay')
            if lockOverlay then
                if not colData.unlocked then
                    lockOverlay:setImageSource('/images/icons/lock')
                    lockOverlay:setOpacity(0.6)
                    lockOverlay:setVisible(true)
                else
                    lockOverlay:setVisible(false)
                end
            end
            btn:setTooltip(string.format('%s\n%s', trait.name or '', trait.desc or ''))
            btn:setChecked(colData.selected == trait.id)
            btn:setOpacity(colData.unlocked and 1.0 or 0.60)

            local traitId = trait.id
            local column = colData.column
            local selectedNow = colData.selected

            btn.onClick = function()
                if not colData.unlocked then return end
                local newTrait = (selectedNow == traitId) and 0 or traitId
                sendAction('select', { itemId = currentItemId, column = column, traitId = newTrait })
            end
        end
    end
end

-- ── Selected-trait description row ───────────────────────────────────────────
local function buildDescRow(data)
    local row = window:getChildById('descRow')
    if not row then return end
    row:destroyChildren()

    local total = data.maxColumns or 7
    for col = 1, total do
        local cell = g_ui.createWidget('IPDescCell', row)
        local colData = (data.columns or {})[col]
        if not colData then
            cell:setText('')
        elseif not colData.unlocked then
            cell:setText('Locked')
            cell:setColor('#6E6E6E')
        elseif colData.selected and colData.selected > 0 then
            local desc = nil
            for _, t in ipairs(colData.traits or {}) do
                if t.id == colData.selected then desc = t.desc break end
            end
            cell:setText(desc or '-')
            cell:setColor('#9FD49F')
        else
            cell:setText('Empty slot')
            cell:setColor('#9E9E9E')
        end
    end
end

-- Clears the right-hand panels (used when no eligible item is selected).
local function clearItemPanels()
    local header = window:getChildById('milestoneHeader')
    if header then header:destroyChildren() end
    local cols = window:getChildById('columnsContainer')
    if cols then cols:destroyChildren() end
    local desc = window:getChildById('descRow')
    if desc then desc:destroyChildren() end
    local xpBar = window:getChildById('xpBar')
    if xpBar then xpBar:setPercent(0) end
end

local function applyWindowState(data)
    if not ensureWindow() then return end
    if not data then return end

    currentItemId = tonumber(data.itemId) or 0

    -- "Empty" state: item has no proficiency progression. Keep the module open
    -- with the left grid usable, but show a placeholder on the right.
    if data.empty then
        local icon = window:recursiveGetChildById('itemIcon')
        if icon then icon:setItemId(tonumber(data.clientId) or 0) end
        local nameLabel = window:recursiveGetChildById('itemNameLabel')
        if nameLabel then
            nameLabel:setText(data.itemName ~= '' and data.itemName or 'Select an item')
        end
        local catLabel = window:recursiveGetChildById('categoryLabel')
        if catLabel then catLabel:setText('No proficiency progression') end
        local xpLabel = window:recursiveGetChildById('xpLabel')
        if xpLabel then xpLabel:setText('-') end
        local nextLabel = window:recursiveGetChildById('nextLabel')
        if nextLabel then nextLabel:setText('Pick an item from the list') end
        clearItemPanels()
        updateGridSelection()
        return
    end

    local icon = window:recursiveGetChildById('itemIcon')
    if icon then
        icon:setItemId(tonumber(data.clientId) or 0)
    end

    local nameLabel = window:recursiveGetChildById('itemNameLabel')
    if nameLabel then
        nameLabel:setText(data.itemName or '-')
    end

    local catLabel = window:recursiveGetChildById('categoryLabel')
    if catLabel then
        catLabel:setText(string.format('%s  -  Milestone %d/%d',
            data.categoryName or '-', data.milestone or 0, data.maxColumns or 7))
    end

    local xpLabel = window:recursiveGetChildById('xpLabel')
    local nextLabel = window:recursiveGetChildById('nextLabel')
    if data.maxed then
        if xpLabel then xpLabel:setText('MAX') end
        if nextLabel then nextLabel:setText('Fully mastered') end
    else
        local cur = data.progress or 0
        local max = math.max(1, data.progressMax or 1)
        if xpLabel then xpLabel:setText(string.format('%s / %s', formatNumber(cur), formatNumber(max))) end
        if nextLabel then nextLabel:setText(string.format('%s XP for next milestone', formatNumber(max - cur))) end
    end

    local xpBar = window:getChildById('xpBar')
    if xpBar then
        if data.maxed then
            xpBar:setPercent(100)
        else
            xpBar:setValue(data.progress or 0, 0, math.max(1, data.progressMax or 1))
        end
        xpBar:setBackgroundColor('#4FC3F7')
    end

    buildMilestoneHeader(data)
    buildColumns(data)
    buildDescRow(data)

    -- refresh selection highlight in the left grid (without rebuilding it)
    updateGridSelection()
end

-- ───────────────────────────────────────────────────────────────────────────
-- Inventory overlay sync
-- ───────────────────────────────────────────────────────────────────────────
local function refreshOverlays()
    if modules.game_inventory and modules.game_inventory.updateProficiencyOverlays then
        pcall(modules.game_inventory.updateProficiencyOverlays)
    end
    if modules.game_containers and modules.game_containers.refreshContainerItems then
        for _, container in pairs(g_game.getContainers() or {}) do
            pcall(modules.game_containers.refreshContainerItems, container)
        end
    end
end

local function applyInventorySync(data)
    Proficiency.tiers = (data and data.items) or {}
    refreshOverlays()
end

-- ───────────────────────────────────────────────────────────────────────────
-- Opcode handler
-- ───────────────────────────────────────────────────────────────────────────
local function onExtendedOpcode(protocol, opcode, buffer)
    if opcode ~= OPCODE then
        return
    end

    local ok, packet = pcall(function() return json.decode(buffer) end)
    if not ok or type(packet) ~= 'table' then
        return
    end

    if packet.action == 'window' then
        applyWindowState(packet.data)
        -- Do NOT auto-open the window on background updates (kill XP, etc.);
        -- only refresh the UI if the user already has it open.
        if packet.feedback and packet.feedback ~= '' and modules.game_textmessage then
            modules.game_textmessage.displayStatusMessage(packet.feedback)
        end
    elseif packet.action == 'registry' then
        local d = packet.data or {}
        if d.reset then
            registry = {}
        end
        for _, entry in ipairs(d.items or {}) do
            registry[#registry + 1] = entry
        end
        ensureWindow()
        if d.final then
            rebuildItemGrid()
            if window and not window:isVisible() then
                window:show()
                window:raise()
                window:focus()
            end
        end
    elseif packet.action == 'inventory' then
        applyInventorySync(packet.data)
    end
end

-- ───────────────────────────────────────────────────────────────────────────
-- Public API
-- ───────────────────────────────────────────────────────────────────────────
function Proficiency.open(clientId)
    ensureWindow()
    sendAction('open', { clientId = tonumber(clientId) or 0 })
end

function Proficiency.hide()
    if window and not window:isDestroyed() then
        window:hide()
    end
end

function Proficiency.toggle()
    if window and window:isVisible() then
        Proficiency.hide()
    end
end

local function onGameEnd()
    Proficiency.hide()
    Proficiency.tiers = {}
end

-- ───────────────────────────────────────────────────────────────────────────
-- Module lifecycle
-- ───────────────────────────────────────────────────────────────────────────
function init()
    g_ui.importStyle('itemproficiency.otui')

    connect(g_game, { onGameEnd = onGameEnd })

    ProtocolGame.registerExtendedOpcode(OPCODE, onExtendedOpcode)

    if g_game.isOnline() then
        sendAction('sync_inventory')
    end
end

function terminate()
    disconnect(g_game, { onGameEnd = onGameEnd })

    ProtocolGame.unregisterExtendedOpcode(OPCODE, onExtendedOpcode)

    if window and not window:isDestroyed() then
        window:destroy()
    end
    window = nil
end
