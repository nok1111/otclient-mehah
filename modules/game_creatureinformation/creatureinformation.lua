local playerTitles = {

["Nok"] = {title = "[Administrator]", color = "alpha"}

}

local npcTitles = {
["Khadin"] = {title = "[Ressource Shop]", color = "#f5c367", quest = true},
["Armin"] = {title = "[Ancestral Task]", color = "#677ef5"},
["Magnus Blackwater"] = {title = "[Captain of Ships]", color = "#67caf5"},
["Shipwright Trader"] = {title = "[Ship Parts]", color = "#a68556"},
["Alaistar"] = {title = "[Potion-Ressources]", color = "#e5f280"},
["Alesar"] = {title = "[Djinn Seller]", color = "#e5f280"},
["Alexander"] = {title = "[Magician Shop]", color = "#e5f280"},

--quests
["Sheriff Gordon"] = {quest = true},

}

local creatureTitles = {
["Avarithia"] = {title = "[The Goddess of Greed]", color = "#FFD700"},
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

local function setCreatureTitle(creature)
    local name = creature:getName()
    local titleFont = "verdana-11px-rounded"



    --OFFSETS CODE

     -- Default wings offset
    local infoOffsetX = 0
    local infoOffsetY = 0

     if creature:getEmblem()  then
        print(creature:getEmblem())
    end
    
    --OFFSETS END



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
    titleWidget:setMarginBottom(30) -- Adjust height above name
    titleWidget:setMarginRight(50)  -- Adjust horizontal position

    -- Store the titleWidget in the creature's widget
    widget.titleWidget = titleWidget

    -- Assign title if applicable
    if creature:isPlayer() and playerTitles[name] then
        titleWidget:setText(playerTitles[name].title)
        titleWidget:setBackgroundColor(playerTitles[name].color)
        creature:attachWidget(titleWidget)

    elseif creature:isNpc() and npcTitles[name] then

        if npcTitles[name].title then
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
        creature:attachWidget(titleWidget)

    else
        titleWidget:destroy() -- Remove if no title is found
    end
end


local function onDisappear(creature)
    local widget = creature:getWidgetInformation()
    if widget and widget.titleWidget then
        widget.titleWidget:destroy()
        widget.titleWidget = nil
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

          -- Set a background image for the health bar
    --widget.lifeBar:setImageSource('/images/monsterbar/basic_monster_background2')
    --widget.lifeBar:setImageSize({ width = 50, height = 12 })
    
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
    -- Attach title using the new function
    --setCreatureTitle(creature)

end

local function onCovered(creature, isCovered, oldIsCovered)
    local infoWidget = creature:getWidgetInformation()
    if isCovered then
        infoWidget.name:setColor(COVERED_COLOR)
        infoWidget.lifeBar:setBackgroundColor(COVERED_COLOR)
    else
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
        end
    end
end


