-- Outfit Effects and Titles Module
-- Lightweight module for handling creature titles and outfit offsets

local playerTitles = {
    ["Nokturno"] = {title = "[Admin]", color = "alpha", offsetX = -15, offsetY = 50}  -- offsetX/offsetY opcional
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
    ["Auctioneer"] = {title = "[Market]", color = "#f5ec67ff"},
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

-- Direction constants (same as in C++)
local Directions = {
    North = 0,
    East = 1,
    South = 2,
    West = 3
}

-- Outfit IDs that cannot use mounts (no mount animations)
local blockedMountOutfits = {
    -- Add outfit IDs here that should NOT be able to mount
    [2829] = true,
    [2830] = true,
    [2831] = true,
    [2832] = true,
    [2833] = true,
    [2834] = true,
    [2835] = true,
    [2836] = true,
}

-- Offsets for mounts (when player is mounted)
-- Two formats supported:
-- 1. Simple: mountOffsets[mountId] = {x = offsetX, y = offsetY}  -- Same offset for all directions
-- 2. By direction: mountOffsets[mountId] = { [Directions.North] = {x, y}, [Directions.South] = {x, y}, ... }
local mountOffsets = {
    -- Example with direction-specific offsets:
    [2202] = {
        [Directions.North] = {x = 10, y = 15},
        [Directions.South] = {x = 10, y = 10},
        [Directions.East] = {x = 15, y = 12},
        [Directions.West] = {x = 5, y = 12}
    },
    
    -- Simple format (same offset for all directions):
    [2203] = {x = 10, y = 15},  -- COHETE
    [2204] = {x = 10, y = 15},  -- COHETE

    [1682] = {x = 10, y = 9},  -- GLOBOS
   

    [1506] = {
        [Directions.North] = {x = 24, y = 2},
        [Directions.South] = {x = 15, y = 15},
        [Directions.East] = {x = 15, y = 15}, --DERECHA
        [Directions.West] = {x = 2, y = 22} --IZQUIERDA
    },

    [1508] = {
        [Directions.North] = {x = 4, y = 6},
        [Directions.South] = {x = 2, y = 8},
        [Directions.East] = {x = 6, y = 0}, --DERECHA
        [Directions.West] = {x = 2, y = 3} --IZQUIERDA
    },
    
    [1509] = {
        [Directions.North] = {x = 6, y = 10},
        [Directions.South] = {x = 6, y = 10},
        [Directions.East] = {x = 6, y = 3}, --DERECHA
        [Directions.West] = {x = 2, y = 3} --IZQUIERDA
    },
    [1259] = {
        [Directions.North] = {x = 0, y = 5},
        [Directions.South] = {x = 0, y = -8},
        [Directions.East] = {x = -6, y = 0}, --DERECHA
        [Directions.West] = {x = 0, y = 0} --IZQUIERDA
    },
     [2361] = {
        [Directions.North] = {x = 8, y = 12},
        [Directions.South] = {x = 9, y = 6},
        [Directions.East] = {x = 12, y = 6}, --DERECHA
        [Directions.West] = {x = 8, y = 10} --IZQUIERDA
    },
     [2362] = {
        [Directions.North] = {x = 8, y = 12},
        [Directions.South] = {x = 9, y = 6},
        [Directions.East] = {x = 12, y = 6}, --DERECHA
        [Directions.West] = {x = 8, y = 10} --IZQUIERDA
    },
     [2363] = {
        [Directions.North] = {x = 8, y = 12},
        [Directions.South] = {x = 9, y = 6},
        [Directions.East] = {x = 12, y = 6}, --DERECHA
        [Directions.West] = {x = 8, y = 10} --IZQUIERDA
    },
    [2581] = {
        [Directions.North] = {x = 9, y = 6},
        [Directions.South] = {x = 9, y = 3},
        [Directions.East] = {x = 1, y = 6}, --DERECHA
        [Directions.West] = {x = 8, y = 10} --IZQUIERDA
    },
     [1686] = {
        [Directions.North] = {x = 2, y = 2},
        [Directions.South] = {x = 2, y = 3},
        [Directions.East] = {x = 1, y = 6}, --DERECHA
        [Directions.West] = {x = 0, y = 3} --IZQUIERDA
    },
    [1689] = {
        [Directions.North] = {x = 6, y = 8},
        [Directions.South] = {x = 2, y = 3},
        [Directions.East] = {x = 1, y = 6}, --DERECHA
        [Directions.West] = {x = 5, y = 8} --IZQUIERDA
    },
    [1504] = {
        [Directions.North] = {x = 16, y = 9},
        [Directions.South] = {x = 9, y = 9},
        [Directions.East] = {x = 9, y = 9}, --DERECHA
        [Directions.West] = {x = 5, y = 16} --IZQUIERDA
    },

    [2391] = {
        [Directions.North] = {x = -4, y = -4},
        [Directions.South] = {x = -8, y = -2},
        [Directions.East] = {x = -2, y = -8}, --DERECHA
        [Directions.West] = {x = 2, y = -2} --IZQUIERDA
    },
    [2665] = {
        [Directions.North] = {x = 41, y = 40},
        [Directions.South] = {x = 41, y = 38},
        [Directions.East] = {x = 37, y = 40}, --DERECHA
        [Directions.West] = {x = 41, y = 40} --IZQUIERDA
    },

   [2717] = {
        [Directions.North] = {x = 36, y = 34},
        [Directions.South] = {x = 36, y = 32},
        [Directions.East] = {x = 32, y = 38}, --DERECHA
        [Directions.West] = {x = 32, y = 36} --IZQUIERDA
    },

  
    
}

local titleFont = "verdana-11px-rounded"
local creatureWidgets = {}  -- Track widgets by creature ID

-- Global default offsets for all NPCs/Players/Creatures
local globalOffsets = {
    npc = {offsetX = 0, offsetY = 23},      -- Default for all NPCs
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

-- Apply mount offsets
local function applyMountOffsets(creature, mountId)
    local mountConfig = mountOffsets[mountId]
    
    if not mountConfig then
        -- Reset mount offset if no offset defined
        creature:setMountOffset(0, 0)
        print("[OutfitsEffects] Mount detected but no offset defined for mount ID: " .. mountId)
        return false
    end
    
    -- Check if mountConfig has direction-specific offsets or is a simple {x, y} table
    local offsets
    if mountConfig.x and mountConfig.y then
        -- Simple format: same offset for all directions
        offsets = mountConfig
    else
        -- Direction-specific format
        local direction = creature:getDirection()
        offsets = mountConfig[direction]
        
        if not offsets then
            -- Fallback to North if specific direction not found
            offsets = mountConfig[Directions.North] or {x = 0, y = 0}
            print("[OutfitsEffects] No offset for direction " .. direction .. ", using fallback")
        end
    end
    
    creature:setMountOffset(offsets.x, offsets.y)
    print("[OutfitsEffects] >>> MOUNT OFFSET APPLIED <<< " .. creature:getName() .. " (mount ID: " .. mountId .. " | dir: " .. creature:getDirection() .. " | offset: X=" .. offsets.x .. ", Y=" .. offsets.y .. ")")
    return true
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

local function onMountChange(creature, newMountId, oldMountId)
    if not creature then return end
    
    local creatureName = creature:getName()
    
    if newMountId > 0 then
        print("[OutfitsEffects] >>> MOUNTED <<< " .. creatureName .. " mounted on mount ID: " .. newMountId)
        applyMountOffsets(creature, newMountId)
    else
        print("[OutfitsEffects] >>> DISMOUNTED <<< " .. creatureName .. " dismounted (was mount ID: " .. oldMountId .. ")")
        -- Reset mount offset to 0 when dismounted
        creature:setMountOffset(0, 0)
    end
end

local function onDirectionChange(creature, newDirection, oldDirection)
    if not creature then return end
    
    -- Only update mount offset if creature is mounted
    local outfit = creature:getOutfit()
    if outfit and outfit.mount and outfit.mount > 0 then
        local mountId = outfit.mount
        print("[OutfitsEffects] >>> DIRECTION CHANGE <<< " .. creature:getName() .. " turned from " .. oldDirection .. " to " .. newDirection)
        applyMountOffsets(creature, mountId)
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

-- Store original mount function
local originalMount = Player.mount

-- Module initialization
function init()
    print("[OutfitsEffects] Module initializing...")
    
    -- Override Player:mount() to check blocked outfits
    Player.mount = function(self)
        local outfit = self:getOutfit()
        if outfit and outfit.type then
            local outfitId = outfit.type
            
            -- Check if outfit is blocked from mounting
            if blockedMountOutfits[outfitId] then
                -- Display warning message
                local textMessage = "This outfit cannot use mounts (no mount animations)"
                modules.game_textmessage.displayGameMessage(textMessage)
                print("[OutfitsEffects] >>> MOUNT BLOCKED <<< Outfit ID " .. outfitId .. " cannot use mounts")
                return false
            end
        end
        
        -- Call original mount function
        return originalMount(self)
    end
    
    connect(Creature, {
        onAppear = onAppear,
        onDisappear = onDisappear,
        onOutfitChange = onOutfitChange,
        onMountChange = onMountChange,
        onDirectionChange = onDirectionChange
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
    
    -- Restore original mount function
    Player.mount = originalMount
    
    disconnect(Creature, {
        onAppear = onAppear,
        onDisappear = onDisappear,
        onOutfitChange = onOutfitChange,
        onMountChange = onMountChange,
        onDirectionChange = onDirectionChange
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
