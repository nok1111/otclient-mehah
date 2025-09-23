local SpelllistProfile = 'Custom'

spelllistWindow = nil
spelllistButton = nil
spellList = nil
-- New UI elements only
searchEdit = nil
spellTitle = nil
chipFormula = nil
chipCooldown = nil
chipLevel = nil
chipMana = nil
descriptionValueLabel = nil
-- Labeled value fields on right pane
formulaValueLabel = nil
cooldownValueLabel = nil
levelValueLabel = nil
manaValueLabel = nil
spellIcon = nil


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

    descriptionValueLabel = spelllistWindow:recursiveGetChildById('labelDescriptionValue')

    -- New UI references (safe even if absent)
    searchEdit   = spelllistWindow:recursiveGetChildById('searchEdit')
    spellTitle   = spelllistWindow:recursiveGetChildById('spellTitle')
    chipFormula  = spelllistWindow:recursiveGetChildById('chipFormula')
    chipCooldown = spelllistWindow:recursiveGetChildById('chipCooldown')
    chipLevel    = spelllistWindow:recursiveGetChildById('chipLevel')
    chipMana     = spelllistWindow:recursiveGetChildById('chipMana')
    spellIcon    = spelllistWindow:recursiveGetChildById('spellIcon')

    -- Right pane labeled values
    formulaValueLabel  = spelllistWindow:recursiveGetChildById('labelFormulaValue')
    cooldownValueLabel = spelllistWindow:recursiveGetChildById('labelCooldownValue')
    levelValueLabel    = spelllistWindow:recursiveGetChildById('labelLevelValue')
    manaValueLabel     = spelllistWindow:recursiveGetChildById('labelManaValue')

   

    spellList = spelllistWindow:recursiveGetChildById('spellList')
    print('[SpellList] spellList widget:', spellList and spellList:getClassName() or 'nil')

    g_keyboard.bindKeyPress('Down', function()
        spellList:focusNextChild(KeyboardFocusReason)
    end, spelllistWindow)
    g_keyboard.bindKeyPress('Up', function()
        spellList:focusPreviousChild(KeyboardFocusReason)
    end, spelllistWindow)

    initializeSpelllist()

    -- Hook search to filter list (set after spellList exists)
    if searchEdit then
        searchEdit.onTextChange = function(widget, text)
            local query = (text or ''):lower()
            -- If query is empty, apply the standard vocation/learned filter
            if query == '' then
                updateSpelllist()
                return
            end

            -- Build-time data for filter
            local learnedSpells = getLearnedSpells and (getLearnedSpells() or {}) or {}
            local localPlayer = g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
            local playerVocation = localPlayer and localPlayer:getVocation() or nil
            for i = 1, #SpelllistSettings[SpelllistProfile].spellOrder do
                local sid = SpelllistSettings[SpelllistProfile].spellOrder[i]
                local info = SpellInfo[SpelllistProfile][sid]
                local label = spellList and spellList:getChildById(sid)
                if label then
                    local hay = (sid .. ' ' .. (info.words or '')):lower()
                    local match = string.find(hay, query, 1, true) ~= nil
                    -- Apply the same base filter as updateSpelllist()
                    local show = true
                    if info then
                        if info.needLearn then
                            show = (learnedSpells[sid] or learnedSpells[info.words]) and true or false
                        elseif info.vocations and playerVocation then
                            show = table.contains(info.vocations, playerVocation)
                        end
                    end
                    label:setVisible(show and match)
                end
            end
        end
    end
    
    --resizeWindow()

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
    if not SpelllistSettings or not SpelllistSettings[SpelllistProfile] then
        print('[SpellList] ERROR: SpelllistSettings or profile missing:', SpelllistProfile)
        return
    end
    if not SpelllistSettings[SpelllistProfile].spellOrder then
        print('[SpellList] ERROR: spellOrder missing for profile:', SpelllistProfile)
        return
    end
    print('[SpellList] Building', #SpelllistSettings[SpelllistProfile].spellOrder, 'entries for profile', SpelllistProfile)
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

    -- Debug: count children created
    do
      local count = 0
      for i = 1, #SpelllistSettings[SpelllistProfile].spellOrder do
        local sid = SpelllistSettings[SpelllistProfile].spellOrder[i]
        if spellList:getChildById(sid) then count = count + 1 end
      end
      print('[SpellList] Created children:', count)
    end

    -- Select first visible spell to populate the right pane
    addEvent(function()
        if not spellList then return end
        local first = nil
        for i = 1, #SpelllistSettings[SpelllistProfile].spellOrder do
            local sid = SpelllistSettings[SpelllistProfile].spellOrder[i]
            local label = spellList:getChildById(sid)
            if label and label:isVisible() then
                first = label
                break
            end
        end
        if first then
            spellList:focusChild(first, KeyboardFocusReason)
            updateSpellInformation(first)
        end
    end)
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
    
   -- resizeWindow()
    resetWindow()
end

function updateSpelllist()
    if not spellList then return end
    local learnedSpells = getLearnedSpells and (getLearnedSpells() or {}) or {}
    local visibleCount = 0
    for i = 1, #SpelllistSettings[SpelllistProfile].spellOrder do
        local sid = SpelllistSettings[SpelllistProfile].spellOrder[i]
        local info = SpellInfo[SpelllistProfile][sid]
        local label = spellList:getChildById(sid)
        if label then
            local localPlayer = g_game.getLocalPlayer and g_game:getLocalPlayer() or nil
            local playerVocation = localPlayer and localPlayer:getVocation() or nil
            local show = true -- default to show to avoid empty list
            if info then
                if info.needLearn then
                    show = (learnedSpells[sid] or learnedSpells[info.words]) and true or false
                elseif info.vocations and playerVocation then
                    show = table.contains(info.vocations, playerVocation)
                end
            end
            label:setVisible(show)
            if show then visibleCount = visibleCount + 1 end
        end
    end
    print('[SpellList] Visible after filter:', visibleCount)
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

        -- Update icon (if available)
        if spellIcon then
            local iconId = tonumber(info.icon)
            if not iconId and SpellIcons[info.icon] then
                iconId = SpellIcons[info.icon][1]
            end
            if iconId then
                spellIcon:setImageSource(Spells.getIconId(iconId, SpelllistProfile))
            else
                spellIcon:setImageSource("")
            end
        end
    else
        -- Clear icon when no info
        if spellIcon then spellIcon:setImageSource("") end
    end

    -- New UI only
    if descriptionValueLabel then
        descriptionValueLabel:setText(description)
    else
        print('[SpellList] WARN: descriptionValueLabel not found')
    end

    -- New UI: title and chips
    if spellTitle then spellTitle:setText(name) else print('[SpellList] WARN: spellTitle missing') end
    if chipFormula then chipFormula:setText(formula ~= '' and ('/' .. formula) or '') else print('[SpellList] WARN: chipFormula missing') end
    if chipCooldown then chipCooldown:setText(cooldown) else print('[SpellList] WARN: chipCooldown missing') end
    if chipLevel then chipLevel:setText(level ~= '' and ('Lv. ' .. level) or '') else print('[SpellList] WARN: chipLevel missing') end
    if chipMana then chipMana:setText(mana) else print('[SpellList] WARN: chipMana missing') end

    -- Also fill labeled value rows
    if formulaValueLabel then formulaValueLabel:setText(formula) end
    if cooldownValueLabel then cooldownValueLabel:setText(cooldown) end
    if levelValueLabel then levelValueLabel:setText(level) end
    if manaValueLabel then manaValueLabel:setText(mana) end
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
