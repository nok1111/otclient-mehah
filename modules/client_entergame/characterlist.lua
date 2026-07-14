CharacterList = {}

-- private variables
local charactersWindow
local loadBox
local characterList
local errorBox
local waitingWindow
local updateWaitEvent
local resendWaitEvent
local loginEvent
local outfitCreatureBox

local autoReconnectButton
local autoReconnectEvent
local lastLogout = 0
local function removeAutoReconnectEvent() --prevent
    if autoReconnectEvent then
        removeEvent(autoReconnectEvent)
        autoReconnectEvent = nil
    end
end

-- private functions
local function tryLogin(charInfo, tries)
    tries = tries or 1

    if tries > 50 then
        return
    end

    if g_game.isOnline() then
        if tries == 1 then
            g_game.safeLogout()
			if loginEvent then
				removeEvent(loginEvent)
				loginEvent = nil
			end
        end
        loginEvent = scheduleEvent(function()
            tryLogin(charInfo, tries + 1)
        end, 100)
        return
    end

    CharacterList.hide()

    g_game.loginWorld(G.account, G.password, charInfo.worldName, charInfo.worldHost, charInfo.worldPort,
                      charInfo.characterName, G.authenticatorToken, G.sessionKey)

    loadBox = displayCancelBox(tr('Please wait'), tr('Connecting to game server...'))
    connect(loadBox, {
        onCancel = function()
            loadBox = nil
            g_game.cancelLogin()
            CharacterList.show()
        end
    })

    -- save last used character
    g_settings.set('last-used-character', charInfo.characterName)
    g_settings.set('last-used-world', charInfo.worldName)
    removeAutoReconnectEvent()
end

local function updateWait(timeStart, timeEnd)
    if waitingWindow then
        local time = g_clock.seconds()
        if time <= timeEnd then
            local percent = ((time - timeStart) / (timeEnd - timeStart)) * 100
            local timeStr = string.format('%.0f', timeEnd - time)

            local progressBar = waitingWindow:getChildById('progressBar')
            progressBar:setPercent(percent)

            local label = waitingWindow:getChildById('timeLabel')
            label:setText(tr('Trying to reconnect in %s seconds.', timeStr))

            updateWaitEvent = scheduleEvent(function()
                updateWait(timeStart, timeEnd)
            end, 1000 * progressBar:getPercentPixels() / 100 * (timeEnd - timeStart))
            return true
        end
    end

    if updateWaitEvent then
        updateWaitEvent:cancel()
        updateWaitEvent = nil
    end
end

local function resendWait()
    if waitingWindow then
        waitingWindow:destroy()
        waitingWindow = nil

        if updateWaitEvent then
            updateWaitEvent:cancel()
            updateWaitEvent = nil
        end

        if charactersWindow then
            local selected = characterList:getFocusedChild()
            if selected then
                local charInfo = {
                    worldHost = selected.worldHost,
                    worldPort = selected.worldPort,
                    worldName = selected.worldName,
                    characterName = selected.characterName,
                    characterLevel = selected.characterLevel,
                    main = selected.main,
                    dailyreward = selected.dailyreward,
                    hidden = selected.hidden,
                    outfitid = selected.outfitid,
                    headcolor = selected.headcolor,
                    torsocolor = selected.torsocolor,
                    legscolor = selected.legscolor,
                    detailcolor = selected.detailcolor,
                    addonsflags = selected.addonsflags,
                    characterVocation = selected.characterVocation
                }
                tryLogin(charInfo)
            end
        end
    end
end

local function onLoginWait(message, time)
    CharacterList.destroyLoadBox()

    waitingWindow = g_ui.displayUI('waitinglist')

    local label = waitingWindow:getChildById('infoLabel')
    label:setText(message)

    updateWaitEvent = scheduleEvent(function()
        updateWait(g_clock.seconds(), g_clock.seconds() + time)
    end, 0)
    resendWaitEvent = scheduleEvent(resendWait, time * 1000)
end

function onGameLoginError(message)
    CharacterList.destroyLoadBox()
    errorBox = displayErrorBox(tr('Login Error'), message)
    errorBox.onOk = function()
        errorBox = nil
        CharacterList.showAgain()
    end
end

function onGameSessionEnd(reason)
    CharacterList.destroyLoadBox()
    CharacterList.showAgain()
end

function onGameConnectionError(message, code)
    CharacterList.destroyLoadBox()
    local text = translateNetworkError(code, g_game.getProtocolGame() and g_game.getProtocolGame():isConnecting(),
                                       message)
    errorBox = displayErrorBox(tr('Connection Error'), text)
    errorBox.onOk = function()
        errorBox = nil
        CharacterList.showAgain()
    end
end

function onGameUpdateNeeded(signature)
    CharacterList.destroyLoadBox()
    errorBox = displayErrorBox(tr('Update needed'), tr('Enter with your account again to update your client.'))
    errorBox.onOk = function()
        errorBox = nil
        CharacterList.showAgain()
    end
end

-- public functions
function CharacterList.init()
    connect(g_game, {
        onLoginError = onGameLoginError
    })
    connect(g_game, {
        onSessionEnd = onGameSessionEnd
    })
    connect(g_game, {
        onUpdateNeeded = onGameUpdateNeeded
    })
    connect(g_game, {
        onConnectionError = onGameConnectionError
    })
    connect(g_game, {
        onGameStart = CharacterList.destroyLoadBox
    })
    connect(g_game, {
        onLoginWait = onLoginWait
    })
    connect(g_game, {
        onGameEnd = CharacterList.showAgain
    })
    connect(g_game, {
        onLogout = onLogout 
    })

    if G.characters then
        CharacterList.create(G.characters, G.characterAccount)
    end
end

function CharacterList.terminate()
    disconnect(g_game, {
        onLoginError = onGameLoginError
    })
    disconnect(g_game, {
        onSessionEnd = onGameSessionEnd
    })
    disconnect(g_game, {
        onUpdateNeeded = onGameUpdateNeeded
    })
    disconnect(g_game, {
        onConnectionError = onGameConnectionError
    })
    disconnect(g_game, {
        onGameStart = CharacterList.destroyLoadBox
    })
    disconnect(g_game, {
        onLoginWait = onLoginWait
    })
    disconnect(g_game, {
        onGameEnd = CharacterList.showAgain
    })
    disconnect(g_game, {
        onLogout = onLogout 
    })

    if charactersWindow then
        characterList = nil
        charactersWindow:destroy()
        charactersWindow = nil
    end

    if loadBox then
        g_game.cancelLogin()
        loadBox:destroy()
        loadBox = nil
    end

    if waitingWindow then
        waitingWindow:destroy()
        waitingWindow = nil
    end

    if updateWaitEvent then
        removeEvent(updateWaitEvent)
        updateWaitEvent = nil
    end

    if resendWaitEvent then
        removeEvent(resendWaitEvent)
        resendWaitEvent = nil
    end

    if loginEvent then
        removeEvent(loginEvent)
        loginEvent = nil
    end

    removeAutoReconnectEvent()
    destroyCreateAccount()
    
    CharacterList = nil
end

function CharacterList.create(characters, account, otui)
    if not otui then
        otui = 'characterlist'
    end

    if charactersWindow then
        charactersWindow:destroy()
    end

    charactersWindow = g_ui.displayUI(otui)
    characterList = charactersWindow:getChildById('characters')
    autoReconnectButton = charactersWindow:getChildById('autoReconnect')

    -- Enhanced Graphics checkbox
    local enhanceCheck = charactersWindow:getChildById('enhanceGraphics')
    if enhanceCheck then
        enhanceCheck:setChecked(g_settings.getBoolean('enhance-graphics', true))
        enhanceCheck.onCheckChange = function(widget, checked)
            g_settings.set('enhance-graphics', checked)
        end
    end

    -- characters
    G.characters = characters
    G.characterAccount = account

    characterList:destroyChildren()
    local accountStatusLabel = charactersWindow:getChildById('accountStatusLabel')
    local accountStatusIcon = nil
    if g_game.getFeature(GameEnterGameShowAppearance) then
        accountStatusIcon = charactersWindow:getChildById('accountStatusIcon')
    end

    -- Auto-size window to fit character cards horizontally
    if not g_game.getFeature(GameEnterGameShowAppearance) then
        local cardWidth = 100
        local cardSpacing = 6
        local padding = 16
        local windowPadding = 36
        local numChars = #characters
        local contentWidth = numChars * cardWidth + (numChars - 1) * cardSpacing + padding
        local totalWidth = math.max(320, math.min(contentWidth + windowPadding, 900))
        charactersWindow:setWidth(totalWidth)
    end

    local focusLabel
    for i, characterInfo in ipairs(characters) do
        local widget = g_ui.createWidget('CharacterWidget', characterList)
        for key, value in pairs(characterInfo) do
            local subWidget = widget:getChildById(key)
            if subWidget then
                if key == 'outfit' then -- it's an exception
                    subWidget:setOutfit(value)
                else
                    local text = value
                    if subWidget.baseText and subWidget.baseTranslate then
                        text = tr(subWidget.baseText, text)
                    elseif subWidget.baseText then
                        text = string.format(subWidget.baseText, text)
                    end
                    subWidget:setText(text)
                end
            end
        end

        if g_game.getFeature(GameEnterGameShowAppearance) then
            local creatureDisplay = widget:getChildById('outfitCreatureBox', characterList)
            creatureDisplay:setSize("64 64")
            local creature = Creature.create()
            local outfit = {type = characterInfo.outfitid, head = characterInfo.headcolor, body = characterInfo.torsocolor, legs = characterInfo.legscolor, feet = characterInfo.detailcolor, addons = characterInfo.addonsflags}
            creature:setOutfit(outfit)
            creature:setDirection(2)
            creatureDisplay:setCreature(creature)

            local mainCharacter = widget:getChildById('mainCharacter', characterList)
            if characterInfo.main then
                mainCharacter:setImageSource('/images/game/entergame/maincharacter')
            else
                mainCharacter:setImageSource('')
            end

            local statusDailyReward = widget:getChildById('statusDailyReward', characterList)
            if characterInfo.dailyreward == 0 then
                statusDailyReward:setImageSource('/images/game/entergame/dailyreward_collected')
            else
                statusDailyReward:setImageSource('/images/game/entergame/dailyreward_notcollected')
            end

            local statusHidden = widget:getChildById('statusHidden', characterList)
            if characterInfo.hidden then
                statusHidden:setImageSource('/images/game/entergame/hidden')
            else
                statusHidden:setImageSource('')
            end
        else
            -- Card mode: show walking outfit
            if characterInfo.looktype and characterInfo.looktype > 0 then
                local creatureDisplay = widget:getChildById('outfitCreatureBox')
                local creature = Creature.create()
                local outfit = {
                    type = characterInfo.looktype,
                    head = characterInfo.lookhead or 0,
                    body = characterInfo.lookbody or 0,
                    legs = characterInfo.looklegs or 0,
                    feet = characterInfo.lookfeet or 0,
                    addons = characterInfo.lookaddons or 0
                }
                creature:setOutfit(outfit)
                creature:setDirection(2)
                creatureDisplay:setCreature(creature)
                creature:setStaticWalking(1000)
            end

            -- Build info lines for card
            local vocationNames = {
                [0] = 'None', [1] = 'Magician', [2] = 'Templar', [3] = 'Nightblade',
                [4] = 'Dragon Knight', [5] = 'Warlock', [6] = 'Stellar', [7] = 'Monk',
                [8] = 'Druid', [9] = 'Light Dancer', [10] = 'Archer',
                [11] = 'Bard', [12] = 'Tinker', [13] = 'Samurai', [14] = 'Blood Mage',
                [15] = 'Warden'
            }

            -- Prestige / Paragon badge colors (mutually exclusive — Paragon is 300+, Prestige resets below).
            --   Prestige mode:  1 = Prestige Rebirth | 2 = Hardcore | 3 = High Risk | 4 = Iron Man
            --                   5 = Nightmare I | 6 = Nightmare II | 7 = Nightmare III
            --   Prestige state: 1 = active | 2 = failed | 3 = completed
            local PRESTIGE_MODE_NAMES  = {
                [1] = 'Prestige Rebirth', [2] = 'Hardcore', [3] = 'High Risk', [4] = 'Iron Man',
                [5] = 'Nightmare I', [6] = 'Nightmare II', [7] = 'Nightmare III',
            }
            local PRESTIGE_MODE_COLORS = {
                [1] = '#5ED66A',  -- Prestige Rebirth → verde
                [2] = '#E53935',  -- Hardcore          → rojo
                [3] = '#F2C72A',  -- High Risk         → amarillo
                [4] = '#B0B8C1',  -- Iron Man          → gris acero
                [5] = '#B084E0',  -- Nightmare I       → violeta claro
                [6] = '#8B4FCB',  -- Nightmare II      → violeta medio
                [7] = '#5D2A99',  -- Nightmare III     → violeta oscuro
            }
            local PARAGON_COLOR = '#4FA3FF' -- azul

            local infoLines = {}
            if characterInfo.level then
                table.insert(infoLines, 'Lv. ' .. characterInfo.level)
            end
            if characterInfo.vocation and vocationNames[characterInfo.vocation] then
                table.insert(infoLines, vocationNames[characterInfo.vocation])
            end

            local prestigeMode = tonumber(characterInfo.prestigeMode) or 0
            local prestigeState = tonumber(characterInfo.prestigeState) or 0
            local badgeText = nil
            local badgeColor = nil
            if prestigeMode > 0 and PRESTIGE_MODE_NAMES[prestigeMode] then
                local name = PRESTIGE_MODE_NAMES[prestigeMode]
                badgeColor = PRESTIGE_MODE_COLORS[prestigeMode] or '#FFFFFF'
                if prestigeState == 3 then
                    badgeText = name .. ' (done)'
                elseif prestigeState == 2 then
                    badgeText = name .. ' (failed)'
                else
                    badgeText = name
                end
            elseif characterInfo.paragonLevel and characterInfo.paragonLevel > 0 then
                badgeText = 'Paragon ' .. characterInfo.paragonLevel
                badgeColor = PARAGON_COLOR
            end

            if badgeText then
                table.insert(infoLines, badgeText)
            end

            local infoLabel = widget:getChildById('charInfo')
            if infoLabel then
                infoLabel:setText(table.concat(infoLines, '\n'))
                if badgeColor then
                    infoLabel:setColor(badgeColor)
                end
            end
        end

        -- these are used by login
        widget.characterName = characterInfo.name
        widget.worldName = characterInfo.worldName
        widget.worldHost = characterInfo.worldIp
        widget.worldPort = characterInfo.worldPort

        connect(widget, {
            onDoubleClick = function()
                CharacterList.doLogin()
                return true
            end
        })

        if i == 1 or
            (g_settings.get('last-used-character') == widget.characterName and g_settings.get('last-used-world') ==
                widget.worldName) then
            focusLabel = widget
        end
    end

    if focusLabel then
        characterList:focusChild(focusLabel, KeyboardFocusReason)
        addEvent(function()
            characterList:ensureChildVisible(focusLabel)
        end)
    end
    characterList.onChildFocusChange = function()
        removeAutoReconnectEvent()
    end

    -- account
    local status = ''
    if account.status == AccountStatus.Frozen then
        status = tr(' (Frozen)')
    elseif account.status == AccountStatus.Suspended then
        status = tr(' (Suspended)')
    end

    if account.subStatus == SubscriptionStatus.Free then
        accountStatusLabel:setText(('%s%s'):format(tr('Free Account'), status))
        if accountStatusIcon ~= nil then
            accountStatusIcon:setImageSource('/images/game/entergame/nopremium')
        end
    elseif account.subStatus == SubscriptionStatus.Premium then
        if account.premDays == 0 or account.premDays == 65535 then
            accountStatusLabel:setText(('%s%s'):format(tr('Gratis Premium Account'), status))
        else
            accountStatusLabel:setText(('%s%s'):format(tr('Premium Account (%s) days left', account.premDays), status))
        end
        if accountStatusIcon ~= nil then
            accountStatusIcon:setImageSource('/images/game/entergame/premium')
        end
    end

    if account.premDays > 0 and account.premDays <= 7 then
        accountStatusLabel:setOn(true)
    else
        accountStatusLabel:setOn(false)
    end

    autoReconnectButton.onClick = function(widget)
        local autoReconnect = not g_settings.getBoolean('autoReconnect', false)
        autoReconnectButton:setOn(autoReconnect)
        g_settings.set('autoReconnect', autoReconnect)
        local statusText = autoReconnect and 'Auto reconnect: On' or 'Auto reconnect: off'
        if not g_game.getFeature(GameEnterGameShowAppearance) then
            statusText = autoReconnect and 'Auto reconnect:\n On' or 'Auto reconnect:\n off'
        end
        
        autoReconnectButton:setText(statusText)
    end
end

function CharacterList.destroy()
    CharacterList.hide(true)

    if charactersWindow then
        characterList = nil
        charactersWindow:destroy()
        charactersWindow = nil
    end
end

function CharacterList.show()
    if loadBox or errorBox or not charactersWindow then
        return
    end
    charactersWindow:show()
    charactersWindow:raise()
    charactersWindow:focus()

    local autoReconnect = g_settings.getBoolean('autoReconnect', false)
    autoReconnectButton:setOn(autoReconnect)
    local reconnectStatus = autoReconnect and "On" or "Off"
    if not g_game.getFeature(GameEnterGameShowAppearance) then
        autoReconnectButton:setText('Auto reconnect:\n ' .. reconnectStatus)
    else
        autoReconnectButton:setText('Auto reconnect: ' .. reconnectStatus)
    end
end

function CharacterList.hide(showLogin)
    removeAutoReconnectEvent()
    showLogin = showLogin or false
    charactersWindow:hide()

    if showLogin and EnterGame and not g_game.isOnline() then
        EnterGame.show()
    end
end

function CharacterList.showAgain()
    if characterList and characterList:hasChildren() then
        CharacterList.show()
        scheduleAutoReconnect()
    end
end

function CharacterList.isVisible()
    if charactersWindow and charactersWindow:isVisible() then
        return true
    end
    return false
end

function CharacterList.doLogin()
    removeAutoReconnectEvent()
    local selected = characterList:getFocusedChild()
    if selected then
        local charInfo = {
            worldHost = selected.worldHost,
            worldPort = selected.worldPort,
            worldName = selected.worldName,
            characterName = selected.characterName
        }
        charactersWindow:hide()
        if loginEvent then
            removeEvent(loginEvent)
            loginEvent = nil
        end
        tryLogin(charInfo)
    else
        displayErrorBox(tr('Error'), tr('You must select a character to login!'))
    end
end

function CharacterList.destroyLoadBox()
    if loadBox then
        loadBox:destroy()
        loadBox = nil
    end
    destroyCreateAccount()
end

function CharacterList.cancelWait()
    if waitingWindow then
        waitingWindow:destroy()
        waitingWindow = nil
    end

    if updateWaitEvent then
        removeEvent(updateWaitEvent)
        updateWaitEvent = nil
    end

    if resendWaitEvent then
        removeEvent(resendWaitEvent)
        resendWaitEvent = nil
    end

    CharacterList.destroyLoadBox()
    CharacterList.showAgain()
end

function CharacterList.updateCharactersAppearances(showOutfits)
    if showOutfitsCheckbox and showOutfits ~= showOutfitsCheckbox:isChecked() then
        showOutfitsCheckbox:setChecked(showOutfits)
    end

    if not(characterList) or #(characterList:getChildren()) == 0 then
        return
    end

    for _, widget in ipairs(characterList:getChildren()) do
        if not widget.characterInfo then
            break
        end

        if not(widget.creature) or not(widget.creatureBorder) then
            widget.creature = widget:recursiveGetChildById('creature')
            widget.creatureBorder = widget.creature:getParent()
        end

        CharacterList.updateCharactersAppearance(widget, widget.characterInfo, showOutfits)
    end
end

function onLogout()
    lastLogout = g_clock.millis()
end

function scheduleAutoReconnect()
    if not g_settings.getBoolean('autoReconnect') or lastLogout + 2000 > g_clock.millis() then
        return
    end

    removeAutoReconnectEvent()
    autoReconnectEvent = scheduleEvent(executeAutoReconnect, 2500)
end

function executeAutoReconnect()
    if not g_settings.getBoolean('autoReconnect') then
        return
    end

    if errorBox then
        errorBox:destroy()
        errorBox = nil
    end
    CharacterList.doLogin()
end
