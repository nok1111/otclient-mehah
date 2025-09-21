local SpelllistProfile = 'Custom'

spelllistWindow = nil
spelllistButton = nil
spellList = nil
nameValueLabel = nil
formulaValueLabel = nil
cooldownValueLabel = nil
levelValueLabel = nil
manaValueLabel = nil
descriptionValueLabel = nil


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
    cooldownValueLabel = spelllistWindow:getChildById('labelCooldownValue')
    levelValueLabel = spelllistWindow:getChildById('labelLevelValue')
    manaValueLabel = spelllistWindow:getChildById('labelManaValue')
    descriptionValueLabel = spelllistWindow:getChildById('labelDescriptionValue')

   

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

    Keybind.delete("Windows", "Show/hide spell list")
end

function initializeSpelllist()
    print("initializeSpelllist")
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
    local learnedSpells = getLearnedSpells() or {}
    print('DEBUG learnedSpells:', table.tostring and table.tostring(learnedSpells) or learnedSpells)
    for k,v in pairs(learnedSpells) do print('learned:', k, v) end
    for i = 1, #SpelllistSettings[SpelllistProfile].spellOrder do
        local spell = SpelllistSettings[SpelllistProfile].spellOrder[i]
        local info = SpellInfo[SpelllistProfile][spell]
        local tmpLabel = spellList:getChildById(spell)

        local localPlayer = g_game.getLocalPlayer()
        local playerVocation = localPlayer and localPlayer:getVocation() or nil
        local show = false
        if info and playerVocation and table.contains(info.vocations, playerVocation) and not info.needLearn then
            show = true
        elseif info and info.needLearn and (learnedSpells[spell] or learnedSpells[info.words]) then
            show = true
        end
        tmpLabel:setVisible(show)
    end
end

function updateSpellInformation(widget)
    print("updateSpellInformation")
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
        description = info.description or '-'
    end

    nameValueLabel:setText(name)
    formulaValueLabel:setText(formula)
    cooldownValueLabel:setText(cooldown)
    levelValueLabel:setText(level)
    manaValueLabel:setText(mana)
    descriptionValueLabel:setText(description)
end

function toggle()
    print("toggle")
    if spelllistButton:isOn() then
        spelllistButton:setOn(false)
        spelllistWindow:hide()
    else
        spelllistButton:setOn(true)
        spelllistWindow:show()
        spelllistWindow:raise()
        spelllistWindow:focus()
        updateSpelllist()
    end
end

function toggleFilter(widget, selectedWidget)
    updateSpelllist()
end

function resizeWindow()
    spelllistWindow:setWidth(SpelllistSettings['Custom'].spellWindowWidth + SpelllistSettings[SpelllistProfile].iconSize.width - 32)
    spellList:setWidth(SpelllistSettings['Custom'].spellListWidth + SpelllistSettings[SpelllistProfile].iconSize.width - 32)
end

function resetWindow()
    spelllistWindow:hide()
    if spelllistButton then
        spelllistButton:setOn(false)
    end

    updateSpelllist()
end
