-- Outfit Effects and Titles Module
-- Lightweight module for handling creature titles and outfit offsets

local playerTitles = {
    ["Nok"] = {title = "[Administrator]", color = "alpha", offsetX = 0, offsetY = 0}  -- offsetX/offsetY opcional
}

local npcTitles = {
    --shops (offsetX/offsetY opcional para ajuste fino)
    ["Lubo"] = {title = "[Tools Shop]", color = "#677ef5"},
    ["Alchemist Hanna"] = {title = "[Alchemy Shop]", color = "#677ef5"},
    ["Blacksmith Sam"] = {title = "[Blacksmith Shop]", color = "#677ef5"},
    ["Lucy"] = {title = "[Products Buyer]", color = "#677ef5"},
    ["Berthel"] = {title = "[Fame Vendor]", color = "#FF6700"},
    ["Priest Baltone"] = {title = "[Blesser]", color = "#677ef5"},
    ["Frodo"] = {title = "[Food Vendor]", color = "#677ef5"},
    --extras
    ["Sage Liora"] = {title = "[Valuable Pouches]", color = "#677ef5"}, 
    ["Arcanist Veyron"] = {title = "[Valuable Pouches]", color = "#677ef5"}, 
    ["Eldric The Woodwise"] = {title = "[Valuable Pouches]", color = "#677ef5"},
    --quests
    ["Sheriff Gordon"] = {quest = true},
}

local creatureTitles = {
    ["Al-Razi"] = {title= "[The Void Alchemist]", color = "#FFFFFF"},
    ["Gor'kaal"] = {title= "[Dunefang Clan]", color = "#FFDE21"},
    ["Drekhul"] = {title= "[Dunefang Clan]", color = "#FFDE21"},
    ["Drakkarim"] = {title= "[Dunefang Clan]", color = "#FFDE21"},
    ["Gor'zul"] = {title= "[Dunefang Clan]", color = "#FFDE21"}
}

local outfitOffsets = {
    [2661] = {x = 32, y = 32},
    [2664] = {x = 32, y = 32},
    [2624] = {x = 32, y = 32},
    [2717] = {x = 32, y = 32},
    [2718] = {x = 13, y = 15},



    [2714] = {x = 32, y = 32},
    [2715] = {x = 13, y = 15},
    [2716] = {x = 13, y = 10},



    --ogres
    [2427] = {x = 32, y = 32},
    [2428] = {x = 32, y = 32},
    [2429] = {x = 32, y = 32},
    [2430] = {x = 32, y = 32},
    [2431] = {x = 32, y = 32},
    [2432] = {x = 32, y = 32},
    --trent
    [2625] = {x = 32, y = 32},
    --dragon
    [2463] = {x = 15, y = 15},
    --the old widow
    [2806] = {x = 25, y = 1},
    --goblin  
    [2602] = {x = 32, y = 32},
    [2448] = {x = 18, y = 5},
    [2437] = {x = 18, y = 15},
    [2589] = {x = 32, y = 32},
    [2590] = {x = 32, y = 32},
}

local titleFont = "verdana-11px-rounded"
local creatureWidgets = {}  -- Track widgets by creature ID

-- Global default offsets for all NPCs/Players/Creatures
local globalOffsets = {
    npc = {offsetX = 0, offsetY = 15},      -- Default for all NPCs
    player = {offsetX = 0, offsetY = 0},   -- Default for all Players
    creature = {offsetX = 0, offsetY = 0}  -- Default for all Creatures
}

-- Get outfit ID from creature
function Creature:getOutfitId()
    local outfit = self:getOutfit()
    return outfit and outfit.type or 0
end

-- Apply outfit offsets
local function applyOutfitOffsets(creature)
    local outfitId = creature:getOutfit() and creature:getOutfit().type or 0
    local offsets = outfitOffsets[outfitId]
    
    if offsets then
        creature:setOutfitOffset(offsets.x, offsets.y)
        print("[OutfitsEffects] Offset applied to " .. creature:getName() .. " (outfit ID: " .. outfitId .. ")")
        return true
    end
    return false
end

-- Create and attach title widget to creature
local function setCreatureTitle(creature)
    local name = creature:getName()
    local creatureId = creature:getId()
    
    print("[OutfitsEffects] Processing title for: " .. name)
    
    local outfit = creature:getOutfit()
    if outfit then
        print("[OutfitsEffects] Outfit ID: " .. (outfit.type or "nil"))
    end
    
    -- Clean up old widget if exists
    if creatureWidgets[creatureId] then
        creatureWidgets[creatureId]:destroy()
        creatureWidgets[creatureId] = nil
    end
    
    -- Apply outfit offsets
    applyOutfitOffsets(creature)
    
    -- Create the title widget directly (no dependency on getWidgetInformation)
    local titleWidget = g_ui.createWidget('UILabel')
    titleWidget:setFont(titleFont)
    titleWidget:setTextAutoResize(true)
    titleWidget:setColor('white')
    titleWidget:setBackgroundColor('alpha')
    titleWidget:setTextAlign(AlignCenter)
    titleWidget:setTextHorizontalAutoResize(true)
    
    -- Calculate offset to position title above the creature's name
    -- The name appears ~10-15 pixels below the creature sprite
    local creatureHeight = creature:getExactSize()
    local nameOffset = 15  -- Approximate pixels where name appears below creature
    local titleMargin = 15  -- Space between title and name
    local baseOffset = creatureHeight - nameOffset + titleMargin
    
    -- Assign title based on creature type
    if creature:isPlayer() and playerTitles[name] then
        local config = playerTitles[name]
        titleWidget:setText(config.title)
        titleWidget:setBackgroundColor(config.color)
        creature:attachWidget(titleWidget)
        
        -- Calculate horizontal offset (center by default, or use custom, or use global)
        local textWidth = titleWidget:getTextSize().width
        local defaultX = -textWidth / 2 + (globalOffsets.player.offsetX or 0)
        local defaultY = baseOffset + (globalOffsets.player.offsetY or 0)
        local offsetX = config.offsetX or defaultX
        local offsetY = config.offsetY or defaultY
        
        titleWidget:setMarginLeft(offsetX)
        titleWidget:setMarginBottom(offsetY)
        creatureWidgets[creatureId] = titleWidget
        print("[OutfitsEffects] Player title applied: " .. config.title .. " (offset: X=" .. offsetX .. ", Y=" .. offsetY .. ")")
        
    elseif creature:isNpc() and npcTitles[name] then
        local config = npcTitles[name]
        
        -- Apply title if exists
        if config.title then
            titleWidget:setText(config.title)
            titleWidget:setBackgroundColor(config.color)
            creature:attachWidget(titleWidget)
            
            -- Calculate offsets (center by default, or use custom, or use global)
            local textWidth = titleWidget:getTextSize().width
            local defaultX = -textWidth / 2 + (globalOffsets.npc.offsetX or 0)
            local defaultY = (config.marginBottom or baseOffset) + (globalOffsets.npc.offsetY or 0)
            local offsetX = config.offsetX or defaultX
            local offsetY = config.offsetY or defaultY
            
            titleWidget:setMarginLeft(offsetX)
            titleWidget:setMarginBottom(offsetY)
            creatureWidgets[creatureId] = titleWidget
            
            print("[OutfitsEffects] NPC title applied: " .. config.title .. " (offset: X=" .. offsetX .. ", Y=" .. offsetY .. ")")
        else
            titleWidget:destroy()
        end
        
        -- Add quest effect if applicable (independent of title)
        if config.quest then
            creature:attachEffect(g_attachedEffects.getById(31))
            print("[OutfitsEffects] Quest effect attached to: " .. name)
        end
        
    elseif creatureTitles[name] then
        local config = creatureTitles[name]
        titleWidget:setText(config.title)
        titleWidget:setBackgroundColor(config.color)
        creature:attachWidget(titleWidget)
        
        -- Calculate offsets (center by default, or use custom, or use global)
        local textWidth = titleWidget:getTextSize().width
        local defaultX = -textWidth / 2 + (globalOffsets.creature.offsetX or 0)
        local defaultY = baseOffset + (globalOffsets.creature.offsetY or 0)
        local offsetX = config.offsetX or defaultX
        local offsetY = config.offsetY or defaultY
        
        titleWidget:setMarginLeft(offsetX)
        titleWidget:setMarginBottom(offsetY)
        creatureWidgets[creatureId] = titleWidget
        print("[OutfitsEffects] Creature title applied: " .. config.title .. " (offset: X=" .. offsetX .. ", Y=" .. offsetY .. ")")
        
    else
        titleWidget:destroy()
    end
end

-- Event handlers
local function onAppear(creature)
    setCreatureTitle(creature)
end

local function onDisappear(creature)
    local creatureId = creature:getId()
    if creatureWidgets[creatureId] then
        creatureWidgets[creatureId]:destroy()
        creatureWidgets[creatureId] = nil
        print("[OutfitsEffects] Widget cleaned for: " .. creature:getName())
    end
end

local function onOutfitChange(creature, outfit, oldOutfit)
    if creature then
        applyOutfitOffsets(creature)
    end
end

-- Apply titles to all visible creatures
local function refreshAllTitles()
    if g_game.isOnline() then
        local mapPanel = modules.game_interface.getMapPanel()
        if mapPanel then
            local spectators = mapPanel:getSpectators()
            print("[OutfitsEffects] Refreshing " .. #spectators .. " creatures...")
            for _, creature in ipairs(spectators) do
                onAppear(creature)
            end
        end
    end
end

-- Called when game starts/enters world
local function onGameStart()
    print("[OutfitsEffects] Game started, applying titles...")
    -- Delay slightly to ensure creatures are fully loaded
    scheduleEvent(function()
        refreshAllTitles()
    end, 500)
end

-- Module initialization
function init()
    print("[OutfitsEffects] Module initializing...")
    
    connect(Creature, {
        onAppear = onAppear,
        onDisappear = onDisappear,
        onOutfitChange = onOutfitChange
    })
    
    connect(g_game, {
        onGameStart = onGameStart
    })
    
    -- Apply to existing creatures if game is already running
    if g_game.isOnline() then
        refreshAllTitles()
    end
    
    print("[OutfitsEffects] Module loaded successfully!")
end

function terminate()
    print("[OutfitsEffects] Module terminating...")
    
    disconnect(Creature, {
        onAppear = onAppear,
        onDisappear = onDisappear,
        onOutfitChange = onOutfitChange
    })
    
    disconnect(g_game, {
        onGameStart = onGameStart
    })
    
    -- Clean up all tracked widgets
    for creatureId, widget in pairs(creatureWidgets) do
        if widget then
            widget:destroy()
        end
    end
    creatureWidgets = {}
    
    print("[OutfitsEffects] Module unloaded successfully!")
end
