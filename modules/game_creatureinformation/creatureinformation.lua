local playerTitles = {

    ["Nok"] = {title = "[Administrator]", color = "alpha"}
    
    }
    
    local npcTitles = {
    --shops
    ["Lubo"] = {title = "[Tools Shop]", color = "#677ef5"}, --addlight blue code
    ["Alchemist Hanna"] = {title = "[Alchemy Shop]", color = "#677ef5"}, --addlight blue code
    ["Blacksmith Sam"] = {title = "[Blacksmith Shop]", color = "#677ef5"}, --addlight blue code
    ["Lucy"] = {title = "[Products Buyer]", color = "#677ef5"},
    --extras
    ["Sage Liora"] = {title = "[Valuable Pouches]", color = "#677ef5" , marginBottom = 65}, 
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

controller = Controller:new()

if not g_gameConfig.isDrawingInformationByWidget() then
    return
end

g_logger.warning("Creature Information By Widget is enabled. (performance may be depreciated)");

local devMode = false
local debug = false

local COVERED_COLOR = '#606060'
local NPC_COLOR = '#66CCFF'


-- The CORRECT way to get outfit ID in your client
function Creature:getOutfitId()
    local outfit = self:getOutfit()
    return outfit and outfit.type or 0  -- In your version, the ID is in 'type'
end

local outfitOffsets = {
    [2661] = {x = 32, y = 32},    -- Example: outfit ID 111
    [2664] = {x = 32, y = 32},
    [2624] = {x = 32, y = 32},

    -- Add all your outfit IDs and their offsets here
}

-- Simple print function
function printOutfitId(creature)
    print("Outfit ID:", creature:getOutfitId())
end



function applyOutfitOffsets(creature)
    local outfitId = creature:getOutfit() and creature:getOutfit().type or 0
    local offsets = outfitOffsets[outfitId]
    
    if offsets then
        creature:setOutfitOffset(offsets.x, offsets.y)
        return true
    end
    return false
end

local function setCreatureTitle(creature)
    local name = creature:getName()
    local titleFont = "verdana-11px-rounded"


    --OFFSETS CODE

    printOutfitId(creature)

    if creature then
        applyOutfitOffsets(creature)
    end

    -- Get the creature's existing widget
    local widget = creature:getWidgetInformation()
    if not widget then return end -- Safety check

    -- Remove old title if it exists
    if widget.titleWidget then
        widget.titleWidget:destroy()
        widget.titleWidget = nil
    end

    -- Create the title widget
    local titleWidget = g_ui.createWidget('Panel')
    titleWidget:setFont(titleFont)
    titleWidget:setTextAutoResize(true)
    titleWidget:setColor('white')
    titleWidget:setFontScale(1)

    -- Position titleWidget 20 units above and center over widget.name
    local nameWidget = creature:getWidgetInformation().lifeBar
    local parent = nameWidget and nameWidget:getParent() or nil
    if parent then
        parent:addChild(titleWidget)
        titleWidget:fill('none') -- Remove previous anchors
        titleWidget:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        titleWidget:addAnchor(AnchorRight, 'parent', AnchorRight)
        titleWidget:setMarginRight(55) -- Negative value moves it up
        
    end

    -- Store the titleWidget in the creature's widget
    widget.titleWidget = titleWidget

    -- Assign title if applicable
    if creature:isPlayer() and playerTitles[name] then
        titleWidget:setText(playerTitles[name].title)
        titleWidget:setBackgroundColor(playerTitles[name].color)
        titleWidget:setMarginBottom(40) -- Negative value moves it up
        creature:attachWidget(titleWidget)

    elseif creature:isNpc() and npcTitles[name] then

        if npcTitles[name].title then
            if npcTitles[name].marginBottom then
                titleWidget:setMarginBottom(npcTitles[name].marginBottom)
            else
                titleWidget:setMarginBottom(55)
            end
        titleWidget:setText(npcTitles[name].title)
        titleWidget:setBackgroundColor(npcTitles[name].color)
        
        creature:attachWidget(titleWidget)
        end
        -- Add quest effect if applicable
        if npcTitles[name].quest then
            creature:attachEffect(g_attachedEffects.getById(31))
        end

    elseif creatureTitles[name] then -- Assume all other creatures
        titleWidget:setText(creatureTitles[name].title)
        titleWidget:setBackgroundColor(creatureTitles[name].color)
        titleWidget:setMarginBottom(55) -- Negative value moves it up
        creature:attachWidget(titleWidget)

    else
        titleWidget:destroy() -- Remove if no title is found
    end
end


local function onDisappear(creature)
    local widget = creature:getWidgetInformation()
    if widget then
        if widget.titleWidget then
            widget.titleWidget:destroy()
            widget.titleWidget = nil
        end
        print("Title removed for " .. creature:getName())
    end
end

local function onAppear(creature)
    -- Ensure the creature has a widget
    local widget = creature:getWidgetInformation()
    if widget then
        -- Reapply the title
        setCreatureTitle(creature)
    end
end

local function onCreate(creature)
    local widget = g_ui.loadUI('creatureinformation')

    if debug then
        widget:setBorderColor('red')
        widget:setBorderWidth(2)
        widget.icons:setBorderColor('yellow')
        widget.icons:setBorderWidth(2)
    end

    widget.manaBar:setVisible(creature:isLocalPlayer())

    creature:setWidgetInformation(widget)
end

local function onHealthPercentChange(creature, healthPercent, oldHealthPercent)
    local gameMapPanel = modules.game_interface.getMapPanel()
    local widget = creature:getWidgetInformation()
    local color = nil

    if healthPercent > 92 then
        color = '#00BC00';
    elseif healthPercent > 60 then
        color = '#50A150';
    elseif healthPercent > 30 then
        color = '#A1A100';
    elseif healthPercent > 8 then
        color = '#BF0A0A';
    elseif healthPercent > 3 then
        color = '#910F0F';
    else
        color = '#850C0F'
    end

    widget.name:setColor(color)
    widget.lifeBar:setPercent(healthPercent)
    widget.lifeBar:setBackgroundColor(color)
    widget.lifeBar:setVisible(gameMapPanel:isDrawingHealthBars())
end

local function onManaChange(player, mana, maxMana, oldMana, oldMaxMana)
    local gameMapPanel = modules.game_interface.getMapPanel()
    local widget = player:getWidgetInformation()

    if player:getMaxMana() > 1 then
        widget.manaBar:setPercent((mana / maxMana) * 100)
    else
        widget.manaBar:setPercent(1)
    end

    widget.manaBar:setVisible(gameMapPanel:isDrawingManaBar())
end

local function onChangeName(creature, name, oldName)
    local gameMapPanel = modules.game_interface.getMapPanel()
    local infoWidget = creature:getWidgetInformation()

    if g_game.getFeature(GameBlueNpcNameColor) and creature:isNpc() and creature:isFullHealth() then
        infoWidget.name:setColor(NPC_COLOR)
    end

    infoWidget.name:setText(name)
    infoWidget.name:setVisible(gameMapPanel:isDrawingNames())
end

local function onCovered(creature, isCovered, oldIsCovered)
    local infoWidget = creature:getWidgetInformation()
    if isCovered then
        infoWidget.name:setColor(COVERED_COLOR)
        infoWidget.lifeBar:setBackgroundColor(COVERED_COLOR)

        print("Covered: " .. creature:getName())

    else
        print("Not Covered: " .. creature:getName())
        onHealthPercentChange(creature, creature:getHealthPercent())
    end
end


local function onOutfitChange(creature, outfit, oldOutfit)
    local infoWidget = creature:getWidgetInformation()
    if not infoWidget then
        return
    end

    if g_gameConfig.isAdjustCreatureInformationBasedCropSize() then
        infoWidget:setMarginTop(-creature:getExactSize())
    end
end

local function blinkIcon(icon, ticks)
    if icon:isDestroyed() then
        return
    end

    icon:setVisible(not icon:isVisible())

    scheduleEvent(function()
        blinkIcon(icon, ticks)
    end, ticks)
end

local function setIcon(creature, id, getIconPath, typeIcon)
    
    local setParentAnchor = function(w)
        w:addAnchor(AnchorTop, 'parent', AnchorTop)
        w:addAnchor(AnchorLeft, 'parent', AnchorLeft)
    end

    local infoWidget = creature:getWidgetInformation()
    local oldIcon = infoWidget.icons[typeIcon]

    if oldIcon then
        local index = oldIcon:getChildIndex()
        oldIcon:destroy()

        if index == 1 and infoWidget.icons:hasChildren() then
            setParentAnchor(infoWidget.icons:getChildByIndex(index))
        end
    end

    local hasChildren = infoWidget.icons:hasChildren()
    local path, blink = getIconPath(id)

    if path == nil then
        if not hasChildren then
            infoWidget.icons:setVisible(false)
        end
        return
    end

    local icon = g_ui.createWidget('IconInformation', infoWidget.icons)
    icon:setId(typeIcon)
    icon:setImageSource(path)

    if not hasChildren then
        setParentAnchor(icon)
        infoWidget.icons:setVisible(true)
    end

    if blink then
        blinkIcon(icon, g_gameConfig.getShieldBlinkTicks())
    end
end

local creatureEvents = {
    onCreate = onCreate,
    onOutfitChange = onOutfitChange,
    onCovered = onCovered,
    onHealthPercentChange = onHealthPercentChange,
    onChangeName = onChangeName,
    onTypeChange = function(creature, id) setIcon(creature, id, getTypeImagePath, 'type') end,
    onIconChange = function(creature, id) setIcon(creature, id, getIconImagePath, 'icon') end,
    onSkullChange = function(creature, id) setIcon(creature, id, getSkullImagePath, 'skull') end,
    onShieldChange = function(creature, id) setIcon(creature, id, getShieldImagePathAndBlink, 'shield') end,
    onEmblemChange = function(creature, id) setIcon(creature, id, getEmblemImagePath, 'emblem') end,
    onDisappear = onDisappear, -- Remove only the title
    onAppear = onAppear -- Re-add the title when the creature reappears
};

function toggleInformation()
    local localPlayer = g_game.getLocalPlayer()
    if not localPlayer then return end

    local gameMapPanel = modules.game_interface.getMapPanel()

    localPlayer:getWidgetInformation().manaBar:setVisible(gameMapPanel:isDrawingManaBar())

    local spectators = modules.game_interface.getMapPanel():getSpectators()
    for _, creature in ipairs(spectators) do
        creature:getWidgetInformation().name:setVisible(gameMapPanel:isDrawingNames())
        creature:getWidgetInformation().lifeBar:setVisible(gameMapPanel:isDrawingHealthBars())

       
    end
end

function controller:onInit()
    controller:registerEvents(Creature, creatureEvents)
    controller:registerEvents(LocalPlayer, { onManaChange = onManaChange })
end

if devMode then
    function controller:onGameStart()
        local spectators = modules.game_interface.getMapPanel():getSpectators()
        for _, creature in ipairs(spectators) do
            onCreate(creature)

            if creature:isLocalPlayer() then
                onManaChange(creature, creature:getMana(), creature:getMaxMana(), creature:getMana(),
                    creature:getMaxMana())
            end

            onOutfitChange(creature, creature:getOutfit())
            onCovered(creature, creature:isCovered())
            onHealthPercentChange(creature, creature:getHealthPercent(), creature:getHealthPercent())
            onChangeName(creature, creature:getName())

            creatureEvents.onTypeChange(creature, creature:getType())
            creatureEvents.onIconChange(creature, creature:getIcon())
            creatureEvents.onSkullChange(creature, creature:getSkull())
            creatureEvents.onShieldChange(creature, creature:getShield())
            creatureEvents.onEmblemChange(creature, creature:getEmblem())
            onAppear(creature)
        end
    end
end
