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
    [SKILL_CLUB] = "Club Fighting",
    [SKILL_SWORD] = "Sword Fighting",
    [SKILL_AXE] = "Axe Fighting",
    [SKILL_DISTANCE] = "Distance Fighting",
    [SKILL_SHIELDING] = "Shielding",
    [SKILL_FIST] = "Fist Fighting",
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
    
    -- Background (skip - causes overlap issues)
    
    -- Calculate centering
    local totalBranches = #treeData.branches
    local nodeWidth = 42
    local marginBetweenBranches = 40
    local totalWidth = totalBranches * nodeWidth + (totalBranches + 1) * marginBetweenBranches
    local parentWidth = scrollArea:getWidth()
    local treeLeftOffset = math.max(0, math.floor((parentWidth - totalWidth) / 2))
    
    -- Render branches
    for branchIndex, branchData in ipairs(treeData.branches) do
        local leftMargin = treeLeftOffset + (branchIndex - 1) * (nodeWidth + marginBetweenBranches) + marginBetweenBranches
        local prevNode = nil
        
        for nodeIndex, nodeData in ipairs(branchData.nodes) do
            local nodeId = "branch" .. branchIndex .. "/" .. nodeIndex
            
            -- Create node
            local node = g_ui.createWidget("TalentNode", scrollArea)
            node:setId(nodeId)
            node:setImageSource("/mods/game_passiveSkills/images/tree" .. (talents.treeId or 0) .. "/branch" .. branchIndex .. "/" .. nodeIndex)
            node:addAnchor(AnchorLeft, "parent", AnchorLeft)
            node:setMarginLeft(leftMargin)
            
            -- Border
            local border = g_ui.createWidget("TalentNodeBorder", node)
            border:setImageSource("/mods/game_passiveSkills/images/borders/" .. (branchData.border or "default"))
            border:setImageColor(branchData.color or "#ffffff")
            
            -- Position vertically
            if prevNode then
                node:addAnchor(AnchorTop, prevNode:getId(), AnchorBottom)
                node:setMarginTop(20)
                
                -- Separator line
                local sep = g_ui.createWidget("VerticalSeparator", scrollArea)
                sep:addAnchor(AnchorTop, prevNode:getId(), AnchorBottom)
                sep:addAnchor(AnchorBottom, node:getId(), AnchorTop)
                sep:addAnchor(AnchorHorizontalCenter, node:getId(), AnchorHorizontalCenter)
            else
                node:addAnchor(AnchorTop, "parent", AnchorTop)
                node:setMarginTop(20)
            end
            
            -- Level indicator
            local nodeLevel = g_ui.createWidget("TalentNodeLevel", scrollArea)
            nodeLevel:addAnchor(AnchorLeft, nodeId, AnchorLeft)
            nodeLevel:addAnchor(AnchorTop, nodeId, AnchorTop)
            nodeLevel:addAnchor(AnchorHorizontalCenter, nodeId, AnchorHorizontalCenter)
            
            local currentLevel = progress[branchIndex] and progress[branchIndex][nodeIndex] or 0
            nodeLevel:setText(currentLevel .. "/" .. (nodeData.maxLevel or 1))
            
            -- Store node data for tooltip on the border (same pattern as PassiveSkills)
            border.nodeData = nodeData
            border.currentLevel = currentLevel
            border.onHoverChange = Inspect.onTalentHoverChange
            
            prevNode = node
        end
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
            tooltipName:setText(card.name or "Unknown Card")
            tooltipName:setColor(Inspect.rarityColors[card.rarity] or "#ffffff")
        end
        
        if tooltipLevel then
            tooltipLevel:setText("Level " .. (card.level or 1) .. " / " .. (card.maxLevel or 1))
        end
        
        if tooltipDesc then
            local desc = "No description available"
            if card.description then
                if type(card.description) == "table" then
                    desc = card.description[card.level] or card.description[1] or desc
                else
                    desc = card.description
                end
            end
            tooltipDesc:setText(desc)
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
        
        local tooltipName = findWidget(Inspect.UI, "tooltipCardName")
        local tooltipLevel = findWidget(Inspect.UI, "tooltipCardLevel")
        local tooltipDesc = findWidget(Inspect.UI, "tooltipCardDescription")
        
        if tooltipName then
            tooltipName:setText(tr(node.name) or tr("Talent Node"))
            tooltipName:setColor("#f4ca16")
        end
        
        if tooltipLevel then
            tooltipLevel:setText(tr("Level %s / %s", currentLevel, node.maxLevel or 1))
        end
        
        if tooltipDesc then
            local desc = tr(node.description) or tr("No description")
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
            Inspect.cachedData.talents = data.talents
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
