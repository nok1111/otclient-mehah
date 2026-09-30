if not Inspect then Inspect = {} end

-- Helper to find nested widget by id
local function findWidget(parent, id)
    if not parent then return nil end
    if parent[id] then return parent[id] end
    if parent.recursiveGetChildById then
        return parent:recursiveGetChildById(id)
    end
    return nil
end

-- Opcode for inspect system (using a unique opcode - 219)
Inspect.opCode = 219

-- UI references
Inspect.UI = nil
Inspect.currentTab = "stats"
Inspect.inspectedPlayer = nil

-- Cached data for inspected player
Inspect.cachedData = {
    basicInfo = nil,
    stats = nil,
    talents = nil,
    codex = nil
}

-- Skill constants (matching game_skills)
SKILL_BLACKSMITH = 1
SKILL_ALCHEMY = 2
SKILL_COOKING = 3
SKILL_ENCHANTING = 4
SKILL_MINING = 5
SKILL_HERBALISM = 6
SKILL_FISHING = 7
SKILL_RUNE_SEEKER = 8

local skillIdToName = {
    [SKILL_BLACKSMITH] = "Blacksmith",
    [SKILL_ALCHEMY] = "Alchemy",
    [SKILL_COOKING] = "Cooking",
    [SKILL_ENCHANTING] = "Enchanting",
    [SKILL_MINING] = "Mining",
    [SKILL_HERBALISM] = "Herbalism",
    [SKILL_FISHING] = "Fishing",
    [SKILL_RUNE_SEEKER] = "Woodcutting",
}

-- Combat skill constants (matching game_skills)
SKILL_FIST = 0
SKILL_CLUB = 1
SKILL_SWORD = 2
SKILL_AXE = 3
SKILL_DISTANCE = 4
SKILL_SHIELDING = 5
SKILL_FISHING = 6
SKILL_MAGLEVEL = 7
SKILL_LEVEL = 8

-- Combat skill names
local combatSkillNames = {
   -- [SKILL_CLUB] = "Focus",
    [SKILL_SWORD] = "Melee",
    [SKILL_AXE] = "Arcana",
    [SKILL_DISTANCE] = "Distance",
    [SKILL_SHIELDING] = "Defence",
    [SKILL_MAGLEVEL] = "Magic Level"
}

-- Special skill names (matching server SPECIALSKILL indices 0-20)
-- Server: 0=CRITICALHITCHANCE, 1=CRITICALHITAMOUNT, 2=LIFELEECHCHANCE, 3=LIFELEECHAMOUNT
-- 4=MANALEECHCHANCE, 5=MANALEECHAMOUNT, 6=ATTACKSPEED, 7=WEAKEN, 8=EXTRAHEALING, 9=DODGE, 10=BLOCK
-- 11=COOLDOWNREDUCTION, 12=BARRIER, 13=SHIELDPOWER, 14=FIREDAMAGE, 15=EARTHDAMAGE, 16=HOLYDAMAGE
-- 17=PHYSICALDAMAGE, 18=ICEDAMAGE, 19=ENERGYDAMAGE, 20=DEATHDAMAGE
local specialSkillNames = {
    [0] = "Critical Hit Chance",
    [1] = "Critical Hit Amount",
    [2] = "Life Leech Chance",
    [3] = "Life Leech Amount",
    [4] = "Mana Leech Chance",
    [5] = "Mana Leech Amount",
    [6] = "Attack Speed",
    [7] = "Weaken",
    [8] = "Extra Healing",
    [9] = "Dodge",
    [10] = "Block",
    [11] = "Cooldown Reduction",
    [12] = "Barrier",
    [13] = "Shield Power",
    [14] = "Fire Damage",
    [15] = "Earth Damage",
    [16] = "Holy Damage",
    [17] = "Physical Damage",
    [18] = "Ice Damage",
    [19] = "Energy Damage",
    [20] = "Death Damage"
}

-- Special skills that display as percentages
local percentageSkills = {
    [0] = true, -- Critical Hit Chance
    [6] = true, -- Attack Speed
    [7] = true, -- Weaken
    [8] = true, -- Extra Healing
    [9] = true, -- Dodge
    [11] = true, -- Cooldown Reduction
}

-- Card tooltip state
Inspect.tooltipCardData = nil

-- Rarity colors (mirror of Codex.rarityColors)
Inspect.rarityColors = {
    common = "#ffffff",
    rare = "#00ff00",
    epic = "#a335ee",
    legendary = "#ff8000"
}

------ Initialization and Termination ------

function Inspect.init()
    print("[Inspect] Module initializing...")
    
    -- Load card descriptions from game_codex mod (codex is sandboxed, we are not)
    Inspect.cardDescriptions = {}
    local descPath = "/mods/game_codex/codexCardDescriptions.lua"
    if g_resources.fileExists(descPath) then
        -- Set up Codex stub so the file's `Codex.cardDescriptions = {...}` assignment works locally
        local prevCodex = rawget(_G, "Codex")
        _G.Codex = _G.Codex or {}
        local ok, err = pcall(dofile, descPath)
        if ok and _G.Codex.cardDescriptions then
            Inspect.cardDescriptions = _G.Codex.cardDescriptions
        end
        if prevCodex == nil then
            _G.Codex = nil
        else
            _G.Codex = prevCodex
        end
    end

    -- Load talent node info (names/descriptions/effects) from game_passiveSkills.
    -- The server omits descriptions from the inspect payload to stay under the
    -- 8192-byte extended opcode string limit.
    Inspect.nodeInfo = {}
    local nodeInfoPath = "/mods/game_passiveSkills/nodeInfo.lua"
    if g_resources.fileExists(nodeInfoPath) then
        local prevPS = rawget(_G, "PassiveSkills")
        _G.PassiveSkills = _G.PassiveSkills or {}
        local ok, err = pcall(dofile, nodeInfoPath)
        if ok and _G.PassiveSkills.nodeInfo then
            Inspect.nodeInfo = _G.PassiveSkills.nodeInfo
        end
        if prevPS == nil then
            _G.PassiveSkills = nil
        else
            _G.PassiveSkills = prevPS
        end
    end

    connect(g_game, { onGameStart = Inspect.onGameStart, onGameEnd = Inspect.onGameEnd })
    ProtocolGame.registerExtendedOpcode(Inspect.opCode, Inspect.onExtendedOpcode)
    
    if g_game.isOnline() then
        Inspect.onGameStart()
    end
    
    print("[Inspect] Module initialized successfully")
end

function Inspect.terminate()
    disconnect(g_game, { onGameStart = Inspect.onGameStart, onGameEnd = Inspect.onGameEnd })
    ProtocolGame.unregisterExtendedOpcode(Inspect.opCode)
    Inspect.onGameEnd()
end

function Inspect.onGameStart()
    -- Load UI with proper parent panel like other mods do
    Inspect.UI = g_ui.loadUI('inspect', modules.game_interface.getRootPanel())
    if not Inspect.UI then
        print("[Inspect] ERROR: Failed to load inspect.otui")
        return
    end
    
    print("[Inspect] UI loaded successfully")
    Inspect.UI:hide()
    Inspect.setupTabs()
end

function Inspect.onGameEnd()
    if Inspect.UI then
        Inspect.UI:destroy()
        Inspect.UI = nil
    end
    Inspect.clearCache()
end

function Inspect.clearCache()
    Inspect.cachedData = {
        basicInfo = nil,
        stats = nil,
        talents = nil,
        codex = nil
    }
    Inspect.inspectedPlayer = nil
end

------ UI Setup ------

function Inspect.setupTabs()
    if not Inspect.UI then return end
    
    -- Stats tab
    local tabStats = findWidget(Inspect.UI, "tabStats")
    if tabStats then
        tabStats.onClick = function() Inspect.switchTab("stats") end
    end
    
    -- Talents tab
    local tabTalents = findWidget(Inspect.UI, "tabTalents")
    if tabTalents then
        tabTalents.onClick = function() Inspect.switchTab("talents") end
    end
    
    -- Codex tab
    local tabCodex = findWidget(Inspect.UI, "tabCodex")
    if tabCodex then
        tabCodex.onClick = function() Inspect.switchTab("codex") end
    end
    
    -- Setup tooltip handlers
    Inspect.setupTooltip()
end

function Inspect.setupTooltip()
    if not Inspect.UI then return end
    local tooltip = findWidget(Inspect.UI, "cardTooltip")
    if not tooltip then return end
    tooltip:setEnabled(false)
    tooltip:hide()
end

function Inspect.switchTab(tabName)
    if not Inspect.UI then return end
    
    Inspect.currentTab = tabName
    
    -- Hide all tab contents
    local statsContent = findWidget(Inspect.UI, "statsTabContent")
    local talentsContent = findWidget(Inspect.UI, "talentsTabContent")
    local codexContent = findWidget(Inspect.UI, "codexTabContent")
    local tabStats = findWidget(Inspect.UI, "tabStats")
    local tabTalents = findWidget(Inspect.UI, "tabTalents")
    local tabCodex = findWidget(Inspect.UI, "tabCodex")
    
    if statsContent then statsContent:hide() end
    if talentsContent then talentsContent:hide() end
    if codexContent then codexContent:hide() end
    
    if tabStats then tabStats:setStyle("TabButton") end
    if tabTalents then tabTalents:setStyle("TabButton") end
    if tabCodex then tabCodex:setStyle("TabButton") end
    
    -- Show selected tab
    if tabName == "stats" then
        if statsContent then statsContent:show() end
        if tabStats then tabStats:setStyle("TabButtonActive") end
        Inspect.updateStatsTab()
    elseif tabName == "talents" then
        if talentsContent then talentsContent:show() end
        if tabTalents then tabTalents:setStyle("TabButtonActive") end
        Inspect.updateTalentsTab()
    elseif tabName == "codex" then
        if codexContent then codexContent:show() end
        if tabCodex then tabCodex:setStyle("TabButtonActive") end
        Inspect.updateCodexTab()
    end
end

------ Public Functions ------

function Inspect.openPlayerInspect(creatureId, playerName)
    if not Inspect.UI then
        print("[Inspect] ERROR: UI not loaded, cannot open inspect window")
        -- Try to load UI if game is online
        if g_game.isOnline() then
            print("[Inspect] Attempting to load UI...")
            Inspect.onGameStart()
        end
        if not Inspect.UI then return end
    end
    
    Inspect.inspectedPlayer = {
        id = creatureId,
        name = playerName
    }
    
    -- Request data from server
    Inspect.sendOpcode({
        topic = "inspect-request",
        targetId = creatureId
    })
    
    -- Show window with loading state
    Inspect.UI:show()
    Inspect.UI:raise()
    Inspect.UI:focus()
    
    -- Set initial info if available
    local nameLabel = findWidget(Inspect.UI, "playerNameLabel")
    if nameLabel then nameLabel:setText(playerName) end
    
    -- Default to stats tab
    Inspect.switchTab("stats")
end

function Inspect.hide()
    if Inspect.UI then
        Inspect.UI:hide()
    end
    Inspect.hideTooltip()
end

------ Data Updates ------

function Inspect.updateHeader()
    if not Inspect.UI or not Inspect.cachedData.basicInfo then return end
    
    local info = Inspect.cachedData.basicInfo
    
    -- Name
    local nameLabel = findWidget(Inspect.UI, "playerNameLabel")
    if nameLabel then nameLabel:setText(info.name or "Unknown") end
    
    -- Level
    local levelLabel = findWidget(Inspect.UI, "playerLevelLabel")
    if levelLabel then
        local levelText = "Level " .. (info.level or "?")
        if info.paragonLevel and info.paragonLevel > 0 then
            levelText = levelText .. " (Paragon " .. info.paragonLevel .. ")"
        end
        levelLabel:setText(levelText)
    end
    
    -- Vocation
    local vocLabel = findWidget(Inspect.UI, "playerVocationLabel")
    if vocLabel then vocLabel:setText(info.vocation or "No Vocation") end
    
    -- Fame
    local fameLabel = findWidget(Inspect.UI, "fameLevelLabel")
    if fameLabel then fameLabel:setText("Fame: " .. (info.fameLevel or "0")) end
    
    -- Outfit
    local outfitImg = findWidget(Inspect.UI, "outfitImage")
    if outfitImg and info.outfit then
        local outfit = {
            type    = info.outfit.lookType    or 0,
            head    = info.outfit.lookHead    or 0,
            body    = info.outfit.lookBody    or 0,
            legs    = info.outfit.lookLegs    or 0,
            feet    = info.outfit.lookFeet    or 0,
            addons  = info.outfit.lookAddons  or 0,
            mount   = info.outfit.lookMount   or 0,
        }
        if outfitImg.setOutfit then
            outfitImg:setOutfit(outfit)
        end
    end
end

function Inspect.updateStatsTab()
    if not Inspect.UI or not Inspect.cachedData.stats then return end
    
    local stats = Inspect.cachedData.stats
    
    -- Update header first
    Inspect.updateHeader()
    
    -- Combat Stats Section
    local combatSection = findWidget(Inspect.UI, "combatStatsSection")
    if combatSection then
        combatSection:destroyChildren()
        
        -- Add title
        local title = g_ui.createWidget("Label", combatSection)
        title:setText("Combat Skills")
        title:setColor("#f4ca16")
        title:setTextAutoResize(true)
        title:setMarginBottom(5)
        
        -- Add combat skills
        for skillId, skillName in pairs(combatSkillNames) do
            local skillValue = stats.combatSkills and (stats.combatSkills[skillId] or stats.combatSkills[tostring(skillId)]) or 0
            local skillPercent = stats.combatSkillPercents and stats.combatSkillPercents[skillId] or 0
            
            local row = g_ui.createWidget("StatRow", combatSection)
            
            local label = g_ui.createWidget("StatLabel", row)
            label:setText(skillName)
            
            local value = g_ui.createWidget("StatValue", row)
            value:setText(tostring(skillValue))
            
            if skillPercent and skillPercent > 0 then
                local bar = g_ui.createWidget("SkillBar", row)
                bar:setPercent(skillPercent)
            end
        end
    end
    
    -- Professions Section
    local profSection = findWidget(Inspect.UI, "professionsSection")
    if profSection then
        profSection:destroyChildren()
        
        local title = g_ui.createWidget("Label", profSection)
        title:setText("Professions")
        title:setColor("#f4ca16")
        title:setTextAutoResize(true)
        title:setMarginBottom(5)
        
        for skillId, skillName in pairs(skillIdToName) do
            local skillValue = stats.professions and (stats.professions[skillId] or stats.professions[tostring(skillId)]) or 0
            local skillPercent = stats.professionPercents and stats.professionPercents[skillId] or 0
            
            local row = g_ui.createWidget("StatRow", profSection)
            
            local label = g_ui.createWidget("StatLabel", row)
            label:setText(skillName)
            
            local value = g_ui.createWidget("StatValue", row)
            value:setText(tostring(skillValue))
            
            if skillPercent and skillPercent > 0 then
                local bar = g_ui.createWidget("SkillBar", row)
                bar:setPercent(skillPercent)
            end
        end
    end
    
    -- Special Stats Section
    local specialSection = findWidget(Inspect.UI, "specialStatsSection")
    if specialSection then
        specialSection:destroyChildren()
        
        local title = g_ui.createWidget("Label", specialSection)
        title:setText("Special Stats")
        title:setColor("#f4ca16")
        title:setTextAutoResize(true)
        title:setMarginBottom(5)
        
        -- Speed
        if stats.speed then
            local row = g_ui.createWidget("StatRow", specialSection)
            local label = g_ui.createWidget("StatLabel", row)
            label:setText("Speed")
            local value = g_ui.createWidget("StatValue", row)
            value:setText(tostring(stats.speed))
        end
        
        -- HP/MP
        if stats.maxHp then
            local row = g_ui.createWidget("StatRow", specialSection)
            local label = g_ui.createWidget("StatLabel", row)
            label:setText("Max HP")
            local value = g_ui.createWidget("StatValue", row)
            value:setText(tostring(stats.maxHp))
        end
        
        if stats.maxMana then
            local row = g_ui.createWidget("StatRow", specialSection)
            local label = g_ui.createWidget("StatLabel", row)
            label:setText("Max Mana")
            local value = g_ui.createWidget("StatValue", row)
            value:setText(tostring(stats.maxMana))
        end
        
        -- Special skills with percentages
        for skillId, skillName in pairs(specialSkillNames) do
            local skillValue = stats.specialSkills and (stats.specialSkills[skillId] or stats.specialSkills[tostring(skillId)]) or 0
            
            if skillValue and skillValue > 0 then
                local row = g_ui.createWidget("StatRow", specialSection)
                
                local label = g_ui.createWidget("StatLabel", row)
                label:setText(skillName)
                
                local value = g_ui.createWidget("StatValue", row)
                -- Format percentages for certain skills
                if percentageSkills[skillId] then
                    value:setText(string.format("%.1f%%", math.min(skillValue, 100)))
                else
                    value:setText(tostring(skillValue))
                end
            end
        end
    end
end

-- Node border configs (mirror of game_passiveSkills constellation borders)
Inspect.nodeBorderConfigs = {
    core     = { image = '/mods/game_passiveSkills/images/new_borders/node.png',          width = 60, height = 55 },
    keystone = { image = '/mods/game_passiveSkills/images/new_borders/keystone.png',      width = 70, height = 70 },
    notable  = { image = '/mods/game_passiveSkills/images/new_borders/star.png',          width = 60, height = 57 },
    nexus    = { image = '/mods/game_passiveSkills/images/new_borders/constellation.png', width = 60, height = 57 },
    fork     = { image = '/mods/game_passiveSkills/images/new_borders/node.png',          width = 60, height = 52 },
    star     = { image = '/mods/game_passiveSkills/images/new_borders/node.png',          width = 60, height = 57 },
}

function Inspect.getNodeBranchAndIndex(treeData, nodeId)
    if treeData.core and treeData.core.id == nodeId then
        return 0, 0
    end
    if treeData.nexusNodes then
        for index, nodeData in ipairs(treeData.nexusNodes) do
            if nodeData.id == nodeId then
                return 0, index
            end
        end
    end
    for branchId, branchData in ipairs(treeData.branches or {}) do
        for index, nodeData in ipairs(branchData.nodes or {}) do
            if nodeData.id == nodeId then
                return branchId, index
            end
        end
    end
    return nil
end

function Inspect.getNodeLevelFromProgress(progress, branchId, nodeIndex)
    local branchData = progress[branchId] or progress[tostring(branchId)]
    if not branchData then return 0 end
    return branchData[nodeIndex] or branchData[tostring(nodeIndex)] or 0
end

-- Read-only state: inspecting another player, no pending allocations
function Inspect.getInspectNodeState(treeData, progress, nodeData)
    local branchId, nodeIndex = Inspect.getNodeBranchAndIndex(treeData, nodeData.id)
    local level = Inspect.getNodeLevelFromProgress(progress, branchId or -1, nodeIndex or -1)
    local maxLevel = nodeData.maxLevel or 1
    if maxLevel > 0 and level >= maxLevel then return "maxed", level end
    if level > 0 then return "unlocked", level end
    return "locked", level
end

-- Route through waypoint nodes between two connected nodes
function Inspect.calculateRoute(fromNode, toNode, nodesById, cachedRoutes)
    local route = {}
    local minId = math.min(fromNode.id, toNode.id)
    local maxId = math.max(fromNode.id, toNode.id)
    local connKey = minId .. "-" .. maxId
    local wpList = (cachedRoutes and cachedRoutes[connKey])
        or (fromNode.routeWaypoints and fromNode.routeWaypoints[connKey])
        or (toNode.routeWaypoints and toNode.routeWaypoints[connKey])
    if wpList then
        for _, wpId in ipairs(wpList) do
            local numId = tonumber(wpId) or wpId
            if nodesById[numId] then
                table.insert(route, numId)
            end
        end
    end
    return route
end

function Inspect.drawConnectionLine(parent, x1, y1, x2, y2, color)
    local dx = x2 - x1
    local dy = y2 - y1
    local distance = math.sqrt(dx * dx + dy * dy)
    if distance < 1 then return nil end
    local angle = math.atan2(dy, dx) * 180 / math.pi

    local line = g_ui.createWidget("Panel", parent)
    line:addAnchor(AnchorLeft, 'parent', AnchorLeft)
    line:addAnchor(AnchorTop, 'parent', AnchorTop)
    line:setMarginLeft((x1 + x2) / 2 - distance / 2)
    line:setMarginTop((y1 + y2) / 2 - 1)
    line:setSize({width = math.floor(distance), height = 2})
    line:setRotation(angle)
    line:setBackgroundColor(color)
    line:setPhantom(true)
    return line
end

function Inspect.drawWaypointNode(panel, wpNode, offsetX, offsetY, nodeSpacingX, nodeSpacingY)
    local wpSize = 20
    local cx = offsetX + wpNode.pos.x * nodeSpacingX
    local cy = offsetY + wpNode.pos.y * nodeSpacingY

    local wp = g_ui.createWidget("Panel", panel)
    wp:addAnchor(AnchorLeft, 'parent', AnchorLeft)
    wp:addAnchor(AnchorTop, 'parent', AnchorTop)
    wp:setMarginLeft(cx - math.floor(wpSize / 2))
    wp:setMarginTop(cy - math.floor(wpSize / 2))
    wp:setSize({width = wpSize, height = wpSize})
    wp:setImageSource('/images/icons/node')
    wp:setImageColor('#f4ca16')
    wp:setImageFixedRatio(true)
    wp:setPhantom(true)
    return wp
end

function Inspect.createConstellationNode(panel, treeData, nodeData, nodePixelPos, progress, nodeSize)
    nodeSize = nodeSize or 44
    local branchId, nodeIndex = Inspect.getNodeBranchAndIndex(treeData, nodeData.id)
    local state, level = Inspect.getInspectNodeState(treeData, progress, nodeData)
    local maxLevel = nodeData.maxLevel or 1
    local x, y = nodePixelPos(nodeData)
    x = tonumber(x) or 0
    y = tonumber(y) or 0

    local node = g_ui.createWidget("TalentNode", panel)
    node:addAnchor(AnchorLeft, 'parent', AnchorLeft)
    node:addAnchor(AnchorTop, 'parent', AnchorTop)
    node:setMarginLeft(x)
    node:setMarginTop(y)
    node:setSize({width = nodeSize, height = nodeSize})

    -- Border behind icon
    local border = g_ui.createWidget("TalentNodeBorder", node)
    local borderConfig = Inspect.nodeBorderConfigs[nodeData.kind]
    if borderConfig then
        border:setImageSource(borderConfig.image)
        border:setSize({width = borderConfig.width, height = borderConfig.height})
    else
        border:setImageSource('/mods/game_passiveSkills/images/new_borders/node.png')
    end
    border:setImageColor('#ffffff')
    border:setOpacity(state == "locked" and 0.5 or 1.0)

    -- Icon on top of border
    local iconPath = '/mods/game_passiveSkills/images/no_image.png'
    if nodeData.icon then
        local iconStr = tostring(nodeData.icon)
        local treeBg = treeData.background or '1'
        local customPath
        if tonumber(iconStr) then
            customPath = '/mods/game_passiveSkills/images/talents/icons/tree' .. treeBg .. '/' .. iconStr .. '.png'
        else
            customPath = '/mods/game_passiveSkills/images/talents/icons/' .. iconStr .. '.png'
        end
        if g_resources.fileExists(customPath) then
            iconPath = customPath
        end
    end
    -- Fallback to legacy tree images (cycling 1-6)
    if iconPath == '/mods/game_passiveSkills/images/no_image.png' and branchId and nodeIndex then
        local treeBg = treeData.background or '1'
        local imgIdx = ((nodeIndex - 1) % 6) + 1
        local branchPath = '/mods/game_passiveSkills/images/tree' .. treeBg .. '/branch' .. branchId .. '/' .. imgIdx .. '.png'
        if g_resources.fileExists(branchPath) then
            iconPath = branchPath
        end
    end
    node:setImageSource(iconPath)
    node:setOpacity(state == "locked" and 0.5 or 1.0)

    -- Level label bottom-right of node
    local label = g_ui.createWidget("TalentNodeLevel", panel)
    label:addAnchor(AnchorLeft, 'parent', AnchorLeft)
    label:addAnchor(AnchorTop, 'parent', AnchorTop)
    label:setMarginLeft(x + nodeSize - 6)
    label:setMarginTop(y + nodeSize - 8)
    label:setText(level .. "/" .. maxLevel)

    -- Hover tooltip
    node.nodeData = nodeData
    node.currentLevel = level
    node.onHoverChange = Inspect.onTalentHoverChange
    border.nodeData = nodeData
    border.currentLevel = level
    border.onHoverChange = Inspect.onTalentHoverChange

    return node
end

function Inspect.renderConstellationTree(scrollArea, treeData, progress, routeWaypoints)
    local nodeSize = 44
    local nodeSpacingX = 48
    local nodeSpacingY = 44

    local viewWidth = scrollArea:getWidth()
    local viewHeight = scrollArea:getHeight()

    -- Collect all nodes and compute bounds
    local nodesById = {}
    local minX, maxX, minY, maxY = 0, 0, 0, 0
    local function addNode(nodeData)
        if not nodeData or not nodeData.pos then return end
        nodesById[nodeData.id] = nodeData
        minX = math.min(minX, nodeData.pos.x)
        maxX = math.max(maxX, nodeData.pos.x)
        minY = math.min(minY, nodeData.pos.y)
        maxY = math.max(maxY, nodeData.pos.y)
    end

    addNode(treeData.core)
    for _, branchData in ipairs(treeData.branches or {}) do
        for _, nodeData in ipairs(branchData.nodes or {}) do
            addNode(nodeData)
        end
    end
    for _, nodeData in ipairs(treeData.nexusNodes or {}) do
        addNode(nodeData)
    end
    for _, nodeData in ipairs(treeData.waypointNodes or {}) do
        addNode(nodeData)
    end

    -- Prefer saved layout bounds for a stable layout
    if treeData.layoutBounds then
        local lb = treeData.layoutBounds
        minX = tonumber(lb.minX) or minX
        maxX = tonumber(lb.maxX) or maxX
        minY = tonumber(lb.minY) or minY
        maxY = tonumber(lb.maxY) or maxY
    end

    -- Same behavior as the original module: node size stays 44 and only the
    -- spacing shrinks to fit the view (setupConstellationUI lines 1877-1884)
    local contentWidth = (maxX - minX) * nodeSpacingX + nodeSize * 2
    local contentHeight = (maxY - minY) * nodeSpacingY + nodeSize * 2
    if contentWidth > viewWidth and (maxX - minX) * nodeSpacingX > 0 then
        local scale = (viewWidth - nodeSize * 2) / ((maxX - minX) * nodeSpacingX)
        nodeSpacingX = math.floor(nodeSpacingX * scale)
    end
    if contentHeight > viewHeight and (maxY - minY) * nodeSpacingY > 0 then
        local scale = (viewHeight - nodeSize * 2) / ((maxY - minY) * nodeSpacingY)
        nodeSpacingY = math.floor(nodeSpacingY * scale)
    end
    contentWidth = (maxX - minX) * nodeSpacingX + nodeSize * 2
    contentHeight = (maxY - minY) * nodeSpacingY + nodeSize * 2

    -- Container sized to the content (never smaller than the viewport) so the
    -- scroll area range covers all nodes
    local panel = g_ui.createWidget("Panel", scrollArea)
    panel:setId("constellationContainer")
    panel:addAnchor(AnchorLeft, 'parent', AnchorLeft)
    panel:addAnchor(AnchorTop, 'parent', AnchorTop)
    panel:setSize({
        width = math.max(viewWidth, contentWidth),
        height = math.max(viewHeight, contentHeight)
    })
    panel:setPhantom(true)

    local panelWidth = panel:getWidth()
    local panelHeight = panel:getHeight()
    local offsetX = math.floor((panelWidth - contentWidth) / 2) - minX * nodeSpacingX + math.floor(nodeSize / 2)
    local offsetY = math.floor((panelHeight - contentHeight) / 2) - minY * nodeSpacingY + math.floor(nodeSize / 2)

    local function nodePixelPos(nodeData)
        local cx = offsetX + nodeData.pos.x * nodeSpacingX
        local cy = offsetY + nodeData.pos.y * nodeSpacingY
        return cx - math.floor(nodeSize / 2), cy - math.floor(nodeSize / 2)
    end

    -- Draw connections first (behind nodes)
    local drawnConnections = {}
    for _, fromNode in pairs(nodesById) do
        if fromNode.kind ~= "waypoint" then
            for _, connId in ipairs(fromNode.connections or {}) do
                local toNode = nodesById[connId]
                if toNode and toNode.kind ~= "waypoint" then
                    local minId = math.min(fromNode.id, toNode.id)
                    local maxId = math.max(fromNode.id, toNode.id)
                    local connKey = minId .. "-" .. maxId
                    if not drawnConnections[connKey] then
                        drawnConnections[connKey] = true
                        local x1, y1 = nodePixelPos(fromNode)
                        local x2, y2 = nodePixelPos(toNode)
                        local cx1, cy1 = x1 + math.floor(nodeSize / 2), y1 + math.floor(nodeSize / 2)
                        local cx2, cy2 = x2 + math.floor(nodeSize / 2), y2 + math.floor(nodeSize / 2)

                        local state1 = Inspect.getInspectNodeState(treeData, progress, fromNode)
                        local state2 = Inspect.getInspectNodeState(treeData, progress, toNode)
                        local color = '#3a3045'
                        if (state1 == "unlocked" or state1 == "maxed") and (state2 == "unlocked" or state2 == "maxed") then
                            color = '#f4ca16'
                        elseif state1 ~= "locked" or state2 ~= "locked" then
                            color = '#7a7090'
                        end

                        local route = Inspect.calculateRoute(fromNode, toNode, nodesById, routeWaypoints)
                        local prevX, prevY = cx1, cy1
                        for _, wpId in ipairs(route) do
                            local wpNode = nodesById[wpId]
                            if wpNode then
                                local wpx = offsetX + wpNode.pos.x * nodeSpacingX
                                local wpy = offsetY + wpNode.pos.y * nodeSpacingY
                                Inspect.drawConnectionLine(panel, prevX, prevY, wpx, wpy, color)
                                Inspect.drawWaypointNode(panel, wpNode, offsetX, offsetY, nodeSpacingX, nodeSpacingY)
                                prevX, prevY = wpx, wpy
                            end
                        end
                        Inspect.drawConnectionLine(panel, prevX, prevY, cx2, cy2, color)
                    end
                end
            end
        end
    end

    -- Draw nodes (skip waypoints, already drawn with their routes)
    for _, nodeData in pairs(nodesById) do
        if nodeData.kind ~= "waypoint" then
            Inspect.createConstellationNode(panel, treeData, nodeData, nodePixelPos, progress, nodeSize)
        end
    end
end

function Inspect.renderLegacyTree(scrollArea, treeData, progress, treeId)
    local totalBranches = #treeData.branches
    local nodeWidth = 42
    local marginBetweenBranches = 40
    local totalWidth = totalBranches * nodeWidth + (totalBranches + 1) * marginBetweenBranches
    local parentWidth = scrollArea:getWidth()
    local treeLeftOffset = math.max(0, math.floor((parentWidth - totalWidth) / 2))

    for branchIndex, branchData in ipairs(treeData.branches) do
        local leftMargin = treeLeftOffset + (branchIndex - 1) * (nodeWidth + marginBetweenBranches) + marginBetweenBranches
        local prevNode = nil

        for nodeIndex, nodeData in ipairs(branchData.nodes) do
            local nodeId = "branch" .. branchIndex .. "/" .. nodeIndex

            local node = g_ui.createWidget("TalentNode", scrollArea)
            node:setId(nodeId)
            node:setImageSource("/mods/game_passiveSkills/images/tree" .. (treeId or 0) .. "/branch" .. branchIndex .. "/" .. nodeIndex)
            node:addAnchor(AnchorLeft, "parent", AnchorLeft)
            node:setMarginLeft(leftMargin)

            local border = g_ui.createWidget("TalentNodeBorder", node)
            border:setImageSource("/mods/game_passiveSkills/images/borders/" .. (branchData.border or "default"))
            border:setImageColor(branchData.color or "#ffffff")

            if prevNode then
                node:addAnchor(AnchorTop, prevNode:getId(), AnchorBottom)
                node:setMarginTop(20)

                local sep = g_ui.createWidget("VerticalSeparator", scrollArea)
                sep:addAnchor(AnchorTop, prevNode:getId(), AnchorBottom)
                sep:addAnchor(AnchorBottom, node:getId(), AnchorTop)
                sep:addAnchor(AnchorHorizontalCenter, node:getId(), AnchorHorizontalCenter)
            else
                node:addAnchor(AnchorTop, "parent", AnchorTop)
                node:setMarginTop(20)
            end

            local nodeLevel = g_ui.createWidget("TalentNodeLevel", scrollArea)
            nodeLevel:addAnchor(AnchorLeft, nodeId, AnchorLeft)
            nodeLevel:addAnchor(AnchorTop, nodeId, AnchorTop)
            nodeLevel:addAnchor(AnchorHorizontalCenter, nodeId, AnchorHorizontalCenter)

            local currentLevel = Inspect.getNodeLevelFromProgress(progress, branchIndex, nodeIndex)
            nodeLevel:setText(currentLevel .. "/" .. (nodeData.maxLevel or 1))

            border.nodeData = nodeData
            border.currentLevel = currentLevel
            border.onHoverChange = Inspect.onTalentHoverChange

            prevNode = node
        end
    end
end

function Inspect.updateTalentsTab()
    if not Inspect.UI then return end
    local scrollArea = findWidget(Inspect.UI, "talentsScrollArea")
    if not scrollArea then return end
    scrollArea:destroyChildren()

    if not Inspect.cachedData.talents or not Inspect.cachedData.talents.treeData then
        local msg = g_ui.createWidget("Label", scrollArea)
        msg:setText(tr("No talent data available"))
        msg:setColor("#888888")
        msg:addAnchor(AnchorTop, "parent", AnchorTop)
        msg:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
        msg:setMarginTop(50)
        return
    end

    local talents = Inspect.cachedData.talents
    local treeData = talents.treeData
    local progress = talents.progress or {}

    -- Tree name
    local treeName = findWidget(Inspect.UI, "talentsTreeName")
    if treeName then treeName:setText(tr(treeData.name) or tr("Talent Tree")) end

    if treeData.core then
        -- Constellation 2D format (new talent system)
        -- Waypoint nodes are sent alongside treeData, not inside it
        if talents.waypointNodes and not treeData.waypointNodes then
            treeData.waypointNodes = talents.waypointNodes
        end
        Inspect.renderConstellationTree(scrollArea, treeData, progress, talents.routeWaypoints)
    else
        -- Legacy linear format
        Inspect.renderLegacyTree(scrollArea, treeData, progress, talents.treeId)
    end
end

function Inspect.updateCodexTab()
    if not Inspect.UI then return end
    local slotsPanel = findWidget(Inspect.UI, "codexSlotsPanel")
    if not slotsPanel then return end
    slotsPanel:destroyChildren()
    
    if not Inspect.cachedData.codex or not Inspect.cachedData.codex.equippedCards then
        local msg = g_ui.createWidget("Label", slotsPanel)
        msg:setText("No codex data available")
        msg:setColor("#888888")
        return
    end
    
    local codex = Inspect.cachedData.codex
    local equippedCards = codex.equippedCards or {}
    local TOTAL_SLOTS = 6
    
    -- Compute slot width to fully fill the panel horizontally
    local panelWidth = slotsPanel:getWidth()
    if panelWidth <= 0 then panelWidth = 650 end
    local spacing = 8
    local slotWidth = math.floor((panelWidth - spacing * (TOTAL_SLOTS - 1)) / TOTAL_SLOTS)
    local slotHeight = 130
    
    -- Create 6 slot widgets always
    for slotIndex = 1, TOTAL_SLOTS do
        local serverCard = equippedCards[slotIndex] or equippedCards[tostring(slotIndex)]
        
        local slotWidget = g_ui.createWidget("CardSlot", slotsPanel)
        slotWidget:setId("cardSlot_" .. slotIndex)
        slotWidget:setSize({width = slotWidth, height = slotHeight})
        slotWidget:addAnchor(AnchorTop, "parent", AnchorTop)
        slotWidget:addAnchor(AnchorLeft, "parent", AnchorLeft)
        slotWidget:setMarginLeft((slotIndex - 1) * (slotWidth + spacing))
        
        if serverCard and serverCard.id and serverCard.id > 0 then
            -- Lookup card metadata from client-side database
            local meta = (Inspect.cardDescriptions and Inspect.cardDescriptions[serverCard.id]) or {}
            
            local cardData = {
                id = serverCard.id,
                level = serverCard.level or 1,
                name = meta.name or "Unknown",
                rarity = meta.rarity,
                frame = meta.cardFrame,
                trigger = meta.trigger,
                maxLevel = 10,
                description = meta.descriptions
            }
            
            local cardImage = g_ui.createWidget("CardImage", slotWidget)
            local imagePath = "/images/codex/cards/" .. (cardData.frame or "default") .. ".png"
            cardImage:setImageSource(imagePath)
            
            local levelLabel = g_ui.createWidget("CardLevel", slotWidget)
            levelLabel:setText("Lv " .. cardData.level)
            
            slotWidget.cardData = cardData
            slotWidget.onHoverChange = Inspect.onCardHoverChange
            cardImage.cardData = cardData
            cardImage.onHoverChange = Inspect.onCardHoverChange
        else
            -- Empty slot
            local emptyLabel = g_ui.createWidget("Label", slotWidget)
            emptyLabel:setText("Empty")
            emptyLabel:setColor("#444444")
            emptyLabel:addAnchor(AnchorCenter, "parent", AnchorCenter)
            emptyLabel:setTextAutoResize(true)
        end
    end
end

------ Tooltip Handlers ------

function Inspect.onCardHoverChange(widget, hovered)
    if not Inspect.UI then return end
    local tooltip = findWidget(Inspect.UI, "cardTooltip")
    if not tooltip then return end
    
    if hovered and widget.cardData then
        local card = widget.cardData
        
        -- Update tooltip content
        local tooltipName = findWidget(Inspect.UI, "tooltipCardName")
        local tooltipLevel = findWidget(Inspect.UI, "tooltipCardLevel")
        local tooltipDesc = findWidget(Inspect.UI, "tooltipCardDescription")
        
        if tooltipName then
            tooltipName:setText(tr(card.name) or "Unknown Card")
            tooltipName:setColor(Inspect.rarityColors[card.rarity] or "#ffffff")
        end
        
        if tooltipLevel then
            tooltipLevel:setText(tr("Level") .. " " .. (card.level or 1) .. " / " .. (card.maxLevel or 1))
        end
        
        if tooltipDesc then
            local desc = tr("No description")
            if card.description then
                if type(card.description) == "table" then
                    desc = card.description[card.level] or card.description[1] or desc
                else
                    desc = card.description
                end
            end
            tooltipDesc:setText(tr(desc))
        end
        
        -- Position and show tooltip
        local pos = g_window.getMousePosition()
        local tipSize = tooltip:getSize()
        local windowSize = g_window.getSize()
        
        pos.x = pos.x + 15
        pos.y = pos.y + 15
        
        if windowSize.width - (pos.x + tipSize.width) < 10 then
            pos.x = pos.x - tipSize.width - 30
        end
        
        if windowSize.height - (pos.y + tipSize.height) < 10 then
            pos.y = pos.y - tipSize.height - 30
        end
        
        tooltip:setPosition(pos)
        tooltip:show()
        tooltip:raise()
        
        connect(rootWidget, { onMouseMove = Inspect.moveTooltip })
    else
        Inspect.hideTooltip()
    end
end

function Inspect.onTalentHoverChange(widget, hovered)
    print("[Inspect] Talent hover: " .. tostring(hovered) .. " nodeData=" .. tostring(widget and widget.nodeData))
    if not Inspect.UI then return end
    local tooltip = findWidget(Inspect.UI, "cardTooltip")
    if not tooltip then print("[Inspect] no tooltip widget") return end
    
    if hovered and widget.nodeData then
        local node = widget.nodeData
        local currentLevel = widget.currentLevel or 0

        -- Resolve name/description from client-side nodeInfo ("treeId:nodeId")
        local info = nil
        local treeId = Inspect.cachedData.talents and Inspect.cachedData.talents.treeId
        if Inspect.nodeInfo and treeId and node.id ~= nil then
            info = Inspect.nodeInfo[tostring(treeId) .. ":" .. tostring(node.id)]
        end

        local tooltipName = findWidget(Inspect.UI, "tooltipCardName")
        local tooltipLevel = findWidget(Inspect.UI, "tooltipCardLevel")
        local tooltipDesc = findWidget(Inspect.UI, "tooltipCardDescription")

        if tooltipName then
            tooltipName:setText(tr((info and info.name) or node.name) or tr("Talent Node"))
            tooltipName:setColor("#f4ca16")
        end
        
        if tooltipLevel then
            tooltipLevel:setText(tr("Level %s / %s", currentLevel, node.maxLevel or 1))
        end
        
        if tooltipDesc then
            local desc = tr((info and info.description) or node.description) or tr("No description")
            if type(desc) == "table" then
                desc = desc[currentLevel > 0 and currentLevel or 1] or desc[1] or "No description"
            end
            tooltipDesc:setText(desc)
        end
        
        local pos = g_window.getMousePosition()
        local tipSize = tooltip:getSize()
        local windowSize = g_window.getSize()
        pos.x = pos.x + 15
        pos.y = pos.y + 15
        if windowSize.width - (pos.x + tipSize.width) < 10 then
            pos.x = pos.x - tipSize.width - 30
        end
        if windowSize.height - (pos.y + tipSize.height) < 10 then
            pos.y = pos.y - tipSize.height - 30
        end
        tooltip:setPosition(pos)
        tooltip:show()
        tooltip:raise()
        connect(rootWidget, { onMouseMove = Inspect.moveTooltip })
    else
        Inspect.hideTooltip()
    end
end

function Inspect.moveTooltip()
    if not Inspect.UI then return end
    local tooltip = findWidget(Inspect.UI, "cardTooltip")
    if not tooltip then return end
    local pos = g_window.getMousePosition()
    local tipSize = tooltip:getSize()
    local windowSize = g_window.getSize()
    
    pos.x = pos.x + 15
    pos.y = pos.y + 15
    
    if windowSize.width - (pos.x + tipSize.width) < 10 then
        pos.x = pos.x - tipSize.width - 30
    end
    
    if windowSize.height - (pos.y + tipSize.height) < 10 then
        pos.y = pos.y - tipSize.height - 30
    end
    
    tooltip:setPosition(pos)
end

function Inspect.hideTooltip()
    if Inspect.UI then
        local tooltip = findWidget(Inspect.UI, "cardTooltip")
        if tooltip then tooltip:hide() end
    end
    disconnect(rootWidget, { onMouseMove = Inspect.moveTooltip })
end

------ Network ------

function Inspect.sendOpcode(data)
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        protocolGame:sendExtendedJSONOpcode(Inspect.opCode, data)
    end
end

function Inspect.onExtendedOpcode(protocol, opcode, buffer)
    local data = json.decode(buffer)
    if not data then return end
    
    if data.topic == "inspect-reply" then
        -- Store cached data
        if data.basicInfo then
            Inspect.cachedData.basicInfo = data.basicInfo
        end
        if data.stats then
            Inspect.cachedData.stats = data.stats
        end
        if data.talents then
            -- Talents arrive split across messages (progress / treeData) to
            -- stay under the 8192-byte extended opcode limit; merge fields
            Inspect.cachedData.talents = Inspect.cachedData.talents or {}
            for k, v in pairs(data.talents) do
                Inspect.cachedData.talents[k] = v
            end
        end
        if data.codex then
            Inspect.cachedData.codex = data.codex
        end
        
        -- Update current tab
        if Inspect.currentTab == "stats" then
            Inspect.updateStatsTab()
        elseif Inspect.currentTab == "talents" then
            Inspect.updateTalentsTab()
        elseif Inspect.currentTab == "codex" then
            Inspect.updateCodexTab()
        end
        
    elseif data.topic == "inspect-error" then
        -- Show error and close
        if data.message then
            print("[Inspect] Error: " .. data.message)
        end
        Inspect.hide()
    end
end
