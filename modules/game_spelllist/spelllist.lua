local SpelllistProfile = 'Custom'

spelllistWindow = nil
spelllistButton = nil
spellList = nil
nameValueLabel = nil
formulaValueLabel = nil
vocationValueLabel = nil
groupValueLabel = nil
typeValueLabel = nil
cooldownValueLabel = nil
levelValueLabel = nil
manaValueLabel = nil
premiumValueLabel = nil
descriptionValueLabel = nil

vocationBoxAny = nil


vocationBoxMagician = nil
vocationBoxTemplar = nil
vocationBoxNightblade = nil
vocationBoxDragonKnight = nil
vocationBoxWarlock = nil
vocationBoxStellar = nil
vocationBoxMonk = nil
vocationBoxDruid = nil
vocationBoxLightDancer = nil
vocationBoxArcher = nil

groupBoxAny = nil
groupBoxAttack = nil
groupBoxHealing = nil
groupBoxSupport = nil

premiumBoxAny = nil
premiumBoxNo = nil
premiumBoxYes = nil

vocationRadioGroup = nil
groupRadioGroup = nil
premiumRadioGroup = nil

-- consts
FILTER_PREMIUM_ANY = 0
FILTER_PREMIUM_NO = 1
FILTER_PREMIUM_YES = 2

FILTER_VOCATION_ANY = 0
FILTER_VOCATION_MAGICIAN = 1
FILTER_VOCATION_TEMPLAR = 2
FILTER_VOCATION_NIGHTBLADE = 3
FILTER_VOCATION_DRAGONKNIGHT = 4
FILTER_VOCATION_WARLOCK = 5
FILTER_VOCATION_STELLAR = 6
FILTER_VOCATION_MONK = 7
FILTER_VOCATION_DRUID = 8
FILTER_VOCATION_LIGHTDANCER = 9
FILTER_VOCATION_ARCHER = 10

FILTER_GROUP_ANY = 0
FILTER_GROUP_ATTACK = 1
FILTER_GROUP_HEALING = 2
FILTER_GROUP_SUPPORT = 3

-- Filter Settings
local filters = {
    level = false,
    vocation = false,

    vocationId = FILTER_VOCATION_ANY,
    premium = FILTER_PREMIUM_ANY,
    groupId = FILTER_GROUP_ANY
}

function getSpelllistProfile()
    return SpelllistProfile
end

function setSpelllistProfile(name)
    if SpelllistProfile == name then
        return
    end

    if SpelllistSettings[name] and SpellInfo[name] then
        local oldProfile = SpelllistProfile
        SpelllistProfile = name
        changeSpelllistProfile(oldProfile)
    else
        perror('Spelllist profile \'' .. name .. '\' could not be set.')
    end
end

function online()
    if g_game.getFeature(GameSpellList) and not spelllistButton then
        spelllistButton = modules.game_mainpanel.addToggleButton('spelllistButton', tr('Spell List'),
        '/images/options/button_spells', toggle, false, 4)
        spelllistButton:setOn(false)
    end

    -- Vocation is only send in newer clients
    if g_game.getClientVersion() >= 950 then
        spelllistWindow:getChildById('buttonFilterVocation'):setVisible(true)
    else
        spelllistWindow:getChildById('buttonFilterVocation'):setVisible(false)
    end
end

function offline()
    resetWindow()
end

function init()
    connect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

    spelllistWindow = g_ui.displayUI('spelllist', modules.game_interface.getRightPanel())
    spelllistWindow:hide()

    nameValueLabel = spelllistWindow:getChildById('labelNameValue')
    formulaValueLabel = spelllistWindow:getChildById('labelFormulaValue')
    vocationValueLabel = spelllistWindow:getChildById('labelVocationValue')
    groupValueLabel = spelllistWindow:getChildById('labelGroupValue')
    typeValueLabel = spelllistWindow:getChildById('labelTypeValue')
    cooldownValueLabel = spelllistWindow:getChildById('labelCooldownValue')
    levelValueLabel = spelllistWindow:getChildById('labelLevelValue')
    manaValueLabel = spelllistWindow:getChildById('labelManaValue')
    premiumValueLabel = spelllistWindow:getChildById('labelPremiumValue')
    descriptionValueLabel = spelllistWindow:getChildById('labelDescriptionValue')

    vocationBoxAny = spelllistWindow:getChildById('vocationBoxAny')
    vocationBoxMagician = spelllistWindow:getChildById('vocationBoxMagician')
    vocationBoxTemplar = spelllistWindow:getChildById('vocationBoxTemplar')
    vocationBoxNightblade = spelllistWindow:getChildById('vocationBoxNightblade')
    vocationBoxDragonKnight = spelllistWindow:getChildById('vocationBoxDragonKnight')
    vocationBoxWarlock = spelllistWindow:getChildById('vocationBoxWarlock')
    vocationBoxStellar = spelllistWindow:getChildById('vocationBoxStellar')
    vocationBoxMonk = spelllistWindow:getChildById('vocationBoxMonk')
    vocationBoxDruid = spelllistWindow:getChildById('vocationBoxDruid')
    vocationBoxLightDancer = spelllistWindow:getChildById('vocationBoxLightDancer')
    vocationBoxArcher = spelllistWindow:getChildById('vocationBoxArcher')

    groupBoxAny = spelllistWindow:getChildById('groupBoxAny')
    groupBoxAttack = spelllistWindow:getChildById('groupBoxAttack')
    groupBoxHealing = spelllistWindow:getChildById('groupBoxHealing')
    groupBoxSupport = spelllistWindow:getChildById('groupBoxSupport')

    premiumBoxAny = spelllistWindow:getChildById('premiumBoxAny')
    premiumBoxYes = spelllistWindow:getChildById('premiumBoxYes')
    premiumBoxNo = spelllistWindow:getChildById('premiumBoxNo')

    vocationRadioGroup = UIRadioGroup.create()
    vocationRadioGroup:addWidget(vocationBoxAny)
    vocationRadioGroup:addWidget(vocationBoxMagician)
    vocationRadioGroup:addWidget(vocationBoxTemplar)
    vocationRadioGroup:addWidget(vocationBoxNightblade)
    vocationRadioGroup:addWidget(vocationBoxDragonKnight)
    vocationRadioGroup:addWidget(vocationBoxWarlock)
    vocationRadioGroup:addWidget(vocationBoxStellar)
    vocationRadioGroup:addWidget(vocationBoxMonk)
    vocationRadioGroup:addWidget(vocationBoxDruid)
    vocationRadioGroup:addWidget(vocationBoxLightDancer)
    vocationRadioGroup:addWidget(vocationBoxArcher)

    groupRadioGroup = UIRadioGroup.create()
    groupRadioGroup:addWidget(groupBoxAny)
    groupRadioGroup:addWidget(groupBoxAttack)
    groupRadioGroup:addWidget(groupBoxHealing)
    groupRadioGroup:addWidget(groupBoxSupport)

    premiumRadioGroup = UIRadioGroup.create()
    premiumRadioGroup:addWidget(premiumBoxAny)
    premiumRadioGroup:addWidget(premiumBoxYes)
    premiumRadioGroup:addWidget(premiumBoxNo)

    premiumRadioGroup:selectWidget(premiumBoxAny)
    vocationRadioGroup:selectWidget(vocationBoxAny)
    groupRadioGroup:selectWidget(groupBoxAny)

    vocationRadioGroup.onSelectionChange = toggleFilter
    groupRadioGroup.onSelectionChange = toggleFilter
    premiumRadioGroup.onSelectionChange = toggleFilter

    spellList = spelllistWindow:getChildById('spellList')

    g_keyboard.bindKeyPress('Down', function()
        spellList:focusNextChild(KeyboardFocusReason)
    end, spelllistWindow)
    g_keyboard.bindKeyPress('Up', function()
        spellList:focusPreviousChild(KeyboardFocusReason)
    end, spelllistWindow)

    initializeSpelllist()
    resizeWindow()

    if g_game.isOnline() then
        online()
    end
    Keybind.new("Windows", "Show/hide spell list", "Alt+L", "")
    Keybind.bind("Windows", "Show/hide spell list", {
      {
        type = KEY_DOWN,
        callback = toggle,
      }
    })
end

function terminate()
    disconnect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

    spelllistWindow:destroy()
    if spelllistButton then
        spelllistButton:destroy()
        spelllistButton = nil
    end
    vocationRadioGroup:destroy()
    groupRadioGroup:destroy()
    premiumRadioGroup:destroy()
    Keybind.delete("Windows", "Show/hide spell list")
end

function initializeSpelllist()
    for i = 1, #SpelllistSettings[SpelllistProfile].spellOrder do
        local spell = SpelllistSettings[SpelllistProfile].spellOrder[i]
        local info = SpellInfo[SpelllistProfile][spell]

        local tmpLabel = g_ui.createWidget('SpellListLabel', spellList)
        tmpLabel:setId(spell)
        tmpLabel:setText(spell .. '\n\'' .. info.words .. '\'')
        tmpLabel:setPhantom(false)

        local iconId = tonumber(info.icon)
        if not iconId and SpellIcons[info.icon] then
            iconId = SpellIcons[info.icon][1]
        end

        if not (iconId) then
            perror('Spell icon \'' .. info.icon .. '\' not found.')
        end

        tmpLabel:setHeight(SpelllistSettings[SpelllistProfile].iconSize.height + 4)
        tmpLabel:setTextOffset(topoint((SpelllistSettings[SpelllistProfile].iconSize.width + 10) .. ' ' ..
                                           (SpelllistSettings[SpelllistProfile].iconSize.height - 32) / 2 + 3))
        --tmpLabel:setImageSource(SpelllistSettings[SpelllistProfile].iconFile)
        tmpLabel:setImageSource(Spells.getIconId(iconId, SpelllistProfile))
        tmpLabel:setImageSize(tosize(SpelllistSettings[SpelllistProfile].iconSize.width .. ' ' ..
                                         SpelllistSettings[SpelllistProfile].iconSize.height))
        tmpLabel.onClick = updateSpellInformation
    end

    connect(spellList, {
        onChildFocusChange = function(self, focusedChild)
            if focusedChild == nil then
                return
            end
            updateSpellInformation(focusedChild)
        end
    })
end

function changeSpelllistProfile(oldProfile)
    -- Delete old labels
    for i = 1, #SpelllistSettings[oldProfile].spellOrder do
        local spell = SpelllistSettings[oldProfile].spellOrder[i]
        local tmpLabel = spellList:getChildById(spell)

        tmpLabel:destroy()
    end

    -- Create new spelllist and ajust window
    initializeSpelllist()
    resizeWindow()
    resetWindow()
end

function updateSpelllist()
    for i = 1, #SpelllistSettings[SpelllistProfile].spellOrder do
        local spell = SpelllistSettings[SpelllistProfile].spellOrder[i]
        local info = SpellInfo[SpelllistProfile][spell]
        local tmpLabel = spellList:getChildById(spell)

        local localPlayer = g_game.getLocalPlayer()
        if (not (filters.level) or info.level <= localPlayer:getLevel()) and
            (not (filters.vocation) or table.find(info.vocations, localPlayer:getVocation())) and
            (filters.vocationId == FILTER_VOCATION_ANY or table.find(info.vocations, filters.vocationId)) and
            (filters.groupId == FILTER_GROUP_ANY or info.group[filters.groupId]) and
            (filters.premium == FILTER_PREMIUM_ANY or (info.premium and filters.premium == FILTER_PREMIUM_YES) or
                (not (info.premium) and filters.premium == FILTER_PREMIUM_NO)) then
            tmpLabel:setVisible(true)
        else
            tmpLabel:setVisible(false)
        end
    end
end

function updateSpellInformation(widget)
    local spell = widget:getId()

    local name = ''
    local formula = ''
    local vocation = ''
    local group = ''
    local type = ''
    local cooldown = ''
    local level = ''
    local mana = ''
    local premium = ''
    local description = ''

    if SpellInfo[SpelllistProfile][spell] then
        local info = SpellInfo[SpelllistProfile][spell]

        name = spell
        formula = info.words

        for i = 1, #info.vocations do
            local vocationId = info.vocations[i]
            if vocationId <= 10 or not (table.find(info.vocations, (vocationId - 10))) then
                vocation = vocation .. (vocation:len() == 0 and '' or ', ') .. VocationNames[vocationId]
            end
        end

        cooldown = (info.exhaustion / 1000) .. 's'
        for groupId, groupName in ipairs(SpellGroups) do
            if info.group[groupId] then
                group = group .. (group:len() == 0 and '' or ' / ') .. groupName
                cooldown = cooldown .. ' / ' .. (info.group[groupId] / 1000) .. 's'
            end
        end

        type = info.type
        level = info.level
        mana = info.mana .. ' / ' .. info.soul
        premium = (info.premium and 'yes' or 'no')
        description = info.description or '-'
    end

    nameValueLabel:setText(name)
    formulaValueLabel:setText(formula)
    vocationValueLabel:setText(vocation)
    groupValueLabel:setText(group)
    typeValueLabel:setText(type)
    cooldownValueLabel:setText(cooldown)
    levelValueLabel:setText(level)
    manaValueLabel:setText(mana)
    premiumValueLabel:setText(premium)
    descriptionValueLabel:setText(description)
end

function toggle()
    if spelllistButton:isOn() then
        spelllistButton:setOn(false)
        spelllistWindow:hide()
    else
        spelllistButton:setOn(true)
        spelllistWindow:show()
        spelllistWindow:raise()
        spelllistWindow:focus()
    end
end

function toggleFilter(widget, selectedWidget)
    if widget == vocationRadioGroup then
        local boxId = selectedWidget:getId()
        if boxId == 'vocationBoxAny' then
            filters.vocationId = FILTER_VOCATION_ANY
        elseif boxId == 'vocationBoxMagician' then
            filters.vocationId = FILTER_VOCATION_MAGICIAN
        elseif boxId == 'vocationBoxTemplar' then
            filters.vocationId = FILTER_VOCATION_TEMPLAR
        elseif boxId == 'vocationBoxNightblade' then
            filters.vocationId = FILTER_VOCATION_NIGHTBLADE
        elseif boxId == 'vocationBoxDragonKnight' then
            filters.vocationId = FILTER_VOCATION_DRAGONKNIGHT
        elseif boxId == 'vocationBoxWarlock' then
            filters.vocationId = FILTER_VOCATION_WARLOCK
        elseif boxId == 'vocationBoxStellar' then
            filters.vocationId = FILTER_VOCATION_STELLAR
        elseif boxId == 'vocationBoxMonk' then
            filters.vocationId = FILTER_VOCATION_MONK
        elseif boxId == 'vocationBoxDruid' then
            filters.vocationId = FILTER_VOCATION_DRUID
        elseif boxId == 'vocationBoxLightDancer' then
            filters.vocationId = FILTER_VOCATION_LIGHTDANCER
        elseif boxId == 'vocationBoxArcher' then
            filters.vocationId = FILTER_VOCATION_ARCHER
        end
    elseif widget == groupRadioGroup then
        local boxId = selectedWidget:getId()
        if boxId == 'groupBoxAny' then
            filters.groupId = FILTER_GROUP_ANY
        elseif boxId == 'groupBoxAttack' then
            filters.groupId = FILTER_GROUP_ATTACK
        elseif boxId == 'groupBoxHealing' then
            filters.groupId = FILTER_GROUP_HEALING
        elseif boxId == 'groupBoxSupport' then
            filters.groupId = FILTER_GROUP_SUPPORT
        end
    elseif widget == premiumRadioGroup then
        local boxId = selectedWidget:getId()
        if boxId == 'premiumBoxAny' then
            filters.premium = FILTER_PREMIUM_ANY
        elseif boxId == 'premiumBoxNo' then
            filters.premium = FILTER_PREMIUM_NO
        elseif boxId == 'premiumBoxYes' then
            filters.premium = FILTER_PREMIUM_YES
        end
    else
        local id = widget:getId()
        if id == 'buttonFilterLevel' then
            filters.level = not (filters.level)
            widget:setOn(filters.level)
        elseif id == 'buttonFilterVocation' then
            filters.vocation = not (filters.vocation)
            widget:setOn(filters.vocation)
        end
    end

    updateSpelllist()
end

function resizeWindow()
    spelllistWindow:setWidth(SpelllistSettings['Custom'].spellWindowWidth +
                                 SpelllistSettings[SpelllistProfile].iconSize.width - 32)
    spellList:setWidth(
        SpelllistSettings['Custom'].spellListWidth + SpelllistSettings[SpelllistProfile].iconSize.width - 32)
end

function resetWindow()
    spelllistWindow:hide()
    if spelllistButton then
        spelllistButton:setOn(false)
    end

    -- Resetting filters
    filters.level = false
    filters.vocation = false

    local buttonFilterLevel = spelllistWindow:getChildById('buttonFilterLevel')
    buttonFilterLevel:setOn(filters.level)

    local buttonFilterVocation = spelllistWindow:getChildById('buttonFilterVocation')
    buttonFilterVocation:setOn(filters.vocation)

    vocationRadioGroup:selectWidget(vocationBoxAny)
    groupRadioGroup:selectWidget(groupBoxAny)
    premiumRadioGroup:selectWidget(premiumBoxAny)

    updateSpelllist()
end
