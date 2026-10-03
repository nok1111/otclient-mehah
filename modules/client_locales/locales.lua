dofile 'neededtranslations'

-- private variables
local defaultLocaleName = 'en'
local installedLocales
local currentLocale

local function stripAccents(str)
    if type(str) ~= 'string' then return str end
    local from = '\195\161\195\169\195\173\195\179\195\186\195\129\195\137\195\141\195\147\195\154\195\177\195\145\195\188\195\156\195\160\195\168\195\172\195\178\195\185\195\128\195\136\195\140\195\146\195\153\195\162\195\170\195\174\195\180\195\187\195\130\195\138\195\142\195\148\195\155\195\163\195\181\195\131\195\149\195\167\195\135\195\191\197\184\195\182\195\150\195\164\195\132\195\165\195\133'
    local to = 'aeiouAEIOUnNuUaeiouAEIOUaeiouAEIOUaoAOcCyYoOaAaA'
    for i = 1, #from, 2 do
        str = str:gsub(from:sub(i, i + 1), to:sub((i + 1) / 2, (i + 1) / 2))
    end
    return str
end

function sendLocale(localeName)
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        protocolGame:sendExtendedOpcode(ExtendedIds.Locale, localeName)
        return true
    end
    return false
end

function createWindow()
    localesWindow = g_ui.displayUI('locales')
    local localesPanel = localesWindow:getChildById('localesPanel')
    local layout = localesPanel:getLayout()
    local spacing = layout:getCellSpacing()
    local size = layout:getCellSize()

    local count = 0
    for name, locale in pairs(installedLocales) do
        local widget = g_ui.createWidget('LocalesButton', localesPanel)
        widget:setImageSource('/images/flags/' .. name .. '')
        widget:setText(locale.languageName)
        widget.onClick = function()
            selectFirstLocale(name)
        end
        count = count + 1
    end

    count = math.max(1, math.min(count, 3))
    localesPanel:setWidth(size.width * count + spacing * (count - 1))

    addEvent(function()
        addEvent(function()
            localesWindow:raise()
            localesWindow:focus()
        end)
    end)
end

function selectFirstLocale(name)
    if localesWindow then
        localesWindow:destroy()
        localesWindow = nil
    end
    if setLocale(name) then
        g_modules.reloadModules()
    end
end

-- hooked functions
function onGameStart()
    sendLocale(currentLocale.name)
end

function onExtendedLocales(protocol, opcode, buffer)
    local locale = installedLocales[buffer]
    if locale and setLocale(locale.name) then
        g_modules.reloadModules()
    end
end

-- public functions
function init()
    installedLocales = {}

    installLocales('/locales')

    local userLocaleName = g_settings.get('locale', 'false')
    if userLocaleName ~= 'false' and setLocale(userLocaleName) then
        pdebug('Using configured locale: ' .. userLocaleName)
    else
        setLocale(defaultLocaleName)
        if g_app.hasUpdater() then
            connect(g_app, {
                onUpdateFinished = createWindow,
            })
        else
            connect(g_app, {
                onRun = createWindow,
            })
        end
    end

    ProtocolGame.registerExtendedOpcode(ExtendedIds.Locale, onExtendedLocales)
    connect(g_game, {
        onGameStart = onGameStart
    })
end

function terminate()
    installedLocales = nil
    currentLocale = nil

    ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Locale)
    if g_app.hasUpdater() then
        disconnect(g_app, {
            onUpdateFinished = createWindow,
        })
    else
        disconnect(g_app, {
            onRun = createWindow,
        })
    end
    disconnect(g_game, {
        onGameStart = onGameStart
    })
end

function generateNewTranslationTable(localename)
    local locale = installedLocales[localename]
    for _i, k in pairs(neededTranslations) do
        local trans = locale.translation[k]
        k = k:gsub('\n', '\\n')
        k = k:gsub('\t', '\\t')
        k = k:gsub('\"', '\\\"')
        if trans then
            trans = trans:gsub('\n', '\\n')
            trans = trans:gsub('\t', '\\t')
            trans = trans:gsub('\"', '\\\"')
        end
        if not trans then
            print('    ["' .. k .. '"]' .. ' = false,')
        else
            print('    ["' .. k .. '"]' .. ' = "' .. trans .. '",')
        end
    end
end

function installLocale(locale)
    if not locale or not locale.name then
        error('Unable to install locale.')
    end

    if _G.allowedLocales and not _G.allowedLocales[locale.name] then
        return
    end

    if locale.name ~= defaultLocaleName then
        local updatesNamesMissing = {}
        for _, k in pairs(neededTranslations) do
            if locale.translation[k] == nil then
                updatesNamesMissing[#updatesNamesMissing + 1] = k
            end
        end

        if #updatesNamesMissing > 0 then
            pdebug('Locale \'' .. locale.name .. '\' is missing ' .. #updatesNamesMissing .. ' translations.')
            for _, name in pairs(updatesNamesMissing) do
                pdebug('["' .. name .. '"] = \"\",')
            end
        end
    end

    local installedLocale = installedLocales[locale.name]
    if installedLocale then
        for word, translation in pairs(locale.translation) do
            installedLocale.translation[word] = translation
        end
    else
        installedLocales[locale.name] = locale
    end
end

function installLocales(directory)
    dofiles(directory)
end

function setLocale(name)
    local locale = installedLocales[name]
    if locale == currentLocale then
        g_settings.set('locale', name)
        return
    end
    if not locale then
        pwarning('Locale ' .. name .. ' does not exist.')
        return false
    end
    if currentLocale then
        sendLocale(locale.name)
    end
    currentLocale = locale
    g_settings.set('locale', name)
    if onLocaleChanged then
        onLocaleChanged(name)
    end
    return true
end

function getInstalledLocales()
    return installedLocales
end

function getCurrentLocale()
    return currentLocale
end

-- global function used to translate texts
function _G.tr(text, ...)
    if currentLocale then
        if tonumber(text) and currentLocale.formatNumbers then
            local number = tostring(text):split('.')
            local out = ''
            local reverseNumber = number[1]:reverse()
            for i = 1, #reverseNumber do
                out = out .. reverseNumber:sub(i, i)
                if i % 3 == 0 and i ~= #number then
                    out = out .. currentLocale.thousandsSeperator
                end
            end

            if number[2] then
                out = number[2] .. currentLocale.decimalSeperator .. out
            end
            return out:reverse()
        elseif tostring(text) then
            text = stripAccents(text)
            local translation = currentLocale.translation[text]
            if not translation then
                local normalized = text:gsub('\n', '\\n')
                if normalized ~= text then
                    translation = currentLocale.translation[normalized]
                end
            end
            if not translation then
                if translation == nil then
                    if currentLocale.name ~= defaultLocaleName then
                        pdebug('Unable to translate: \"' .. text .. '\"')
                        _G.missingTranslations = _G.missingTranslations or {}
                        _G.missingTranslations[text] = true
                    end
                end
                translation = text
            end
            local nargs = select('#', ...)
            if nargs > 0 then
                return string.format(translation, ...)
            end
            return translation
        end
    end
    return text
end

-- Patterns for server-composed messages; captures get tr()'d per index in trArgs
local serverMsgPatterns = {
    { pat = '^Main Quest: (.-) completed%.%s*$', tpl = 'Main Quest: %s completed.', trArgs = {1} },
    { pat = '^Main Quest: (.-) started%.%s*$', tpl = 'Main Quest: %s started.', trArgs = {1} },
    { pat = '^Main Quest: (.-) objective completed%.%s*$', tpl = 'Main Quest: %s objective completed.', trArgs = {1} },
    { pat = '^Congratulations! You have completed the (.-) Quest, visit (.-) to claim your reward!%s*$', tpl = 'Congratulations! You have completed the %s Quest, visit %s to claim your reward!', trArgs = {1} },
    { pat = '^You have defeated a (.-)%. %[(%d+)/(%d+)%] for: (.-) Quest%.%s*$', tpl = 'You have defeated a %s. [%s/%s] for: %s Quest.', trArgs = {4} },
    { pat = '^%[Quest Reward%] %+(.-) Codex Essences!%s*$', tpl = '[Quest Reward] +%s Codex Essences!' },
    { pat = '^%[Quest Reward%] %+(.-)x (.-)!%s*$', tpl = '[Quest Reward] +%sx %s!' },
    { pat = '^This task will be available in (%d+) minutes%.%s*$', tpl = 'This task will be available in %s minutes.' },
    { pat = "^You can't have more active tasks than (.-)!%s*$", tpl = "You can't have more active tasks than %s!" },
    -- zones.lua zone events
    { pat = '^You have entered the zone (.-)%s*$', tpl = 'You have entered the zone %s', trArgs = {1} },
    { pat = '^The mighty (.-) has appeared in (.-)!%s*$', tpl = 'The mighty %s has appeared in %s!', trArgs = {2} },
    { pat = '^Zone Event Started: (.-) %- (.-)%s*$', tpl = 'Zone Event Started: %s - %s', trArgs = {1,2} },
    { pat = '^Zone Event Progress: (.-) %[(%d+)/(.-)%]%s*$', tpl = 'Zone Event Progress: %s [%s/%s]', trArgs = {1} },
    { pat = "^Milestone reached: (%d+)%% of '(.-)' completed! %[(%d+)/(%d+)%]%s*$", tpl = "Milestone reached: %d%% of '%s' completed! [%s/%s]", trArgs = {2} },
    { pat = '^(.-) complete! Thanks for dousing the fires%.%s*$', tpl = '%s complete! Thanks for dousing the fires.', trArgs = {1} },
    { pat = '^(.-) ended due to inactivity%.%s*$', tpl = '%s ended due to inactivity.', trArgs = {1} },
    { pat = '^%[Zone Reward%] %+(.-) Codex Essences!%s*$', tpl = '[Zone Reward] +%s Codex Essences!' },
    { pat = '^%[Zone Reward%] %+(.-)!%s*$', tpl = '[Zone Reward] +%s!' },
    { pat = '^%[Escort Leader Bonus%] %+(.-) Codex Essences!%s*$', tpl = '[Escort Leader Bonus] +%s Codex Essences!' },
    { pat = '^Event Reward: (%d+)x Monster Essence%s*$', tpl = 'Event Reward: %sx Monster Essence' },
    -- achievements rewards shop
    { pat = '^Not enough Achievement Points%. You need (.-) but have (.-)%.%s*$', tpl = 'Not enough Achievement Points. You need %s but have %s.' },
    { pat = '^You purchased the (.-) outfit!%s*$', tpl = 'You purchased the %s outfit!', trArgs = {1} },
    -- npc dialogs (generated)
    { pat = "^Selected: (.-) %[(.-)] Lv%.(.-)\n\nChoose your game of chance:\n\n1%. HIGH/LOW %- Guess if dice is 4%-6 %(high%) or 1%-3 %(low%)\n   Win: 50%% | Reward: Random pet\n\n2%. EXACT NUMBER %- Guess the exact dice number %(1%-6%)\n   Win: 16%% | Reward: Random pet %+ bonus candy\n\n3%. EVEN/ODD %- Guess if dice is even or odd\n   Win: 50%% | Reward: Random pet\n\n4%. DICE SUM %- Guess 2d6 sum %(Low 2%-6, Mid 7%-8, High 9%-12%)\n   Win: 33%-41%% | Reward: Random pet\n\nWhich game%?$", tpl = "Selected: %s [%s] Lv.%s\n\nChoose your game of chance:\n\n1. HIGH/LOW - Guess if dice is 4-6 (high) or 1-3 (low)\n   Win: 50%% | Reward: Random pet\n\n2. EXACT NUMBER - Guess the exact dice number (1-6)\n   Win: 16%% | Reward: Random pet + bonus candy\n\n3. EVEN/ODD - Guess if dice is even or odd\n   Win: 50%% | Reward: Random pet\n\n4. DICE SUM - Guess 2d6 sum (Low 2-6, Mid 7-8, High 9-12)\n   Win: 33-41%% | Reward: Random pet\n\nWhich game?" },
    { pat = "^Gold Gamble: (.-) gold\n\nChoose your game of chance:\n\n1%. HIGH/LOW %- Guess if dice is 4%-6 %(high%) or 1%-3 %(low%)\n   Win: 50%% | Reward: Random pet\n\n2%. EXACT NUMBER %- Guess the exact dice number %(1%-6%)\n   Win: 16%% | Reward: Random pet %+ bonus candy\n\n3%. EVEN/ODD %- Guess if dice is even or odd\n   Win: 50%% | Reward: Random pet\n\n4%. DICE SUM %- Guess 2d6 sum %(Low 2%-6, Mid 7%-8, High 9%-12%)\n   Win: 33%-41%% | Reward: Random pet\n\nWhich game%?$", tpl = "Gold Gamble: %s gold\n\nChoose your game of chance:\n\n1. HIGH/LOW - Guess if dice is 4-6 (high) or 1-3 (low)\n   Win: 50%% | Reward: Random pet\n\n2. EXACT NUMBER - Guess the exact dice number (1-6)\n   Win: 16%% | Reward: Random pet + bonus candy\n\n3. EVEN/ODD - Guess if dice is even or odd\n   Win: 50%% | Reward: Random pet\n\n4. DICE SUM - Guess 2d6 sum (Low 2-6, Mid 7-8, High 9-12)\n   Win: 33-41%% | Reward: Random pet\n\nWhich game?" },
    { pat = "^Aha! You have the spark of an insect lover within you%. Would you be interested in joining our Bugs Love Club%? We gather to celebrate the beauty and complexity of the tiniest creatures%. Together, we'll uncover the hidden world of insects and share our discoveries%. \nWhat do you say%? \nbut to make sure you are a true lover bring us these next list of bugs life:\n\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Aha! You have the spark of an insect lover within you. Would you be interested in joining our Bugs Love Club? We gather to celebrate the beauty and complexity of the tiniest creatures. Together, we'll uncover the hidden world of insects and share our discoveries. \nWhat do you say? \nbut to make sure you are a true lover bring us these next list of bugs life:\n\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, seeker of the wild spirit%. I dream of a wolf companion to join my side, a guardian of the untamed%. Will you help me find and raise such a creature%? Seek out a wolf pet and bring it to me%.\nIn return, I shall offer you a token of my appreciation, a testament to the bond between humanity and the wild%.\n\n(.-)\n\nLet me know if you find a little pet for me <3%.$", tpl = "Ah, seeker of the wild spirit. I dream of a wolf companion to join my side, a guardian of the untamed. Will you help me find and raise such a creature? Seek out a wolf pet and bring it to me.\nIn return, I shall offer you a token of my appreciation, a testament to the bond between humanity and the wild.\n\n%s\n\nLet me know if you find a little pet for me <3." },
    { pat = "^Are you absolutely certain you wish to be reborn%?\n\nThis will reset:\n%-> Your level to 8\n%-> All your skills to base values\n%-> All your quest progress\n%-> All your storages\n\nIn exchange, you will receive a Reborn Orb with permanent bonuses%.\n\nThis will be your reborn #(.-)%.\n\nThis will be your first rebirth!\n\nType {yes} to confirm or {no} to cancel%.$", tpl = "Are you absolutely certain you wish to be reborn?\n\nThis will reset:\n-> Your level to 8\n-> All your skills to base values\n-> All your quest progress\n-> All your storages\n\nIn exchange, you will receive a Reborn Orb with permanent bonuses.\n\nThis will be your reborn #%s.\n\nThis will be your first rebirth!\n\nType {yes} to confirm or {no} to cancel." },
    { pat = "^Ah, seeker of renown%. I hold in high esteem the hero medals, tokens of valor and triumph%. Acquire for me a number of these medals, and I shall grant you an outfit worthy of a true champion%.\nEmbark on this challenge, and prove yourself a bearer of courage and might%.\n\nItems required:\n(.-)\n\nLet me know if you get all the required medals%.$", tpl = "Ah, seeker of renown. I hold in high esteem the hero medals, tokens of valor and triumph. Acquire for me a number of these medals, and I shall grant you an outfit worthy of a true champion.\nEmbark on this challenge, and prove yourself a bearer of courage and might.\n\nItems required:\n%s\n\nLet me know if you get all the required medals." },
    { pat = "^Greetings, (.-)! I am the Reborn Master, keeper of ancient rebirth rituals%.\n\nI see you have been reborn (.-) time%(s%) already%. Impressive!\nYou have consumed (.-) Reborn Orb%(s%)%.\n\nYou have not yet experienced rebirth%.\n\nWould you like to know more about the {reborn} process, check your {status}, or perhaps you're ready to {reborn}%?$", tpl = "Greetings, %s! I am the Reborn Master, keeper of ancient rebirth rituals.\n\nI see you have been reborn %s time(s) already. Impressive!\nYou have consumed %s Reborn Orb(s).\n\nYou have not yet experienced rebirth.\n\nWould you like to know more about the {reborn} process, check your {status}, or perhaps you're ready to {reborn}?" },
    { pat = "^Ah, seeker of esoteric arts%. I am a conjurer and a rune master, delving into both realms of magic%. If you're inclined, you can study runes with me%. Together, we shall explore the fusion of incantations and symbols, the convergence of conjuration and rune magic%.\n\nItems required:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seeker of esoteric arts. I am a conjurer and a rune master, delving into both realms of magic. If you're inclined, you can study runes with me. Together, we shall explore the fusion of incantations and symbols, the convergence of conjuration and rune magic.\n\nItems required:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Hehehehe! Welcome to Lucky's Gamble House!\n\nI offer TWO types of gambles:\n\n1%. GAMBLE PET: Risk one of your pets!\n   Choose a mini%-game, test your luck!\n\n2%. GAMBLE GOLD: Risk (.-) gold!\n   Choose a mini%-game, win big!\n\nYour odds depend on which game you pick!\nHigh risk = HIGH reward! Low risk = safer bet!\n\nWhat will it be%?$", tpl = "Hehehehe! Welcome to Lucky's Gamble House!\n\nI offer TWO types of gambles:\n\n1. GAMBLE PET: Risk one of your pets!\n   Choose a mini-game, test your luck!\n\n2. GAMBLE GOLD: Risk %s gold!\n   Choose a mini-game, win big!\n\nYour odds depend on which game you pick!\nHigh risk = HIGH reward! Low risk = safer bet!\n\nWhat will it be?" },
    { pat = "^%*The professor's eyes light up%*\n\nRemarkable! A level (.-) (.-)!\n\nThis specimen's power signature is extraordinary!\nThe evolutionary data alone is worth a fortune!\n\nHere is your payment: (.-) gold%.\n\n%*The professor carefully stores the egg in a crystalline container%*\n\nThank you for your contribution to magical zoology!$", tpl = "*The professor's eyes light up*\n\nRemarkable! A level %s %s!\n\nThis specimen's power signature is extraordinary!\nThe evolutionary data alone is worth a fortune!\n\nHere is your payment: %s gold.\n\n*The professor carefully stores the egg in a crystalline container*\n\nThank you for your contribution to magical zoology!" },
    { pat = "^What kind of ore are you after%?\n1%. Copper Ore %((.-) pouches%)\n2%. Silver Ore %((.-) pouches%)\n3%. Gold Ore %((.-) pouches%)\n4%. Veridium Ore %((.-) pouches%)\n5%. Aquarite Ore %((.-) pouches%)\n6%. Saladium Ore %((.-) pouches%)\nType 'copper', 'silver', 'gold', 'veridium', 'aquarite', or 'saladium' to choose%.$", tpl = "What kind of ore are you after?\n1. Copper Ore (%s pouches)\n2. Silver Ore (%s pouches)\n3. Gold Ore (%s pouches)\n4. Veridium Ore (%s pouches)\n5. Aquarite Ore (%s pouches)\n6. Saladium Ore (%s pouches)\nType 'copper', 'silver', 'gold', 'veridium', 'aquarite', or 'saladium' to choose." },
    { pat = "^Ah, seeker of balance%. I hold the skills to mend and breathe life into that which is broken%. Offer me broken arrows, remnants of the hunt, and I shall restore them to their former glory%. Let the cycle of nature's bounty continue%.\n\nItems required:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seeker of balance. I hold the skills to mend and breathe life into that which is broken. Offer me broken arrows, remnants of the hunt, and I shall restore them to their former glory. Let the cycle of nature's bounty continue.\n\nItems required:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, seeker of the void's touch%. The essence of chaos demands compensation%. Offer voodoo dolls, manifestations of torment and pain%. Each doll surrendered will quench the insatiable hunger of the abyss, but only for a time%.\n\nItems required:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seeker of the void's touch. The essence of chaos demands compensation. Offer voodoo dolls, manifestations of torment and pain. Each doll surrendered will quench the insatiable hunger of the abyss, but only for a time.\n\nItems required:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^=== Your Reborn Status ===\n\nCurrent Level: (.-)\nTimes Reborn: (.-)\nOrbs Consumed: (.-)\n\n=== Active Bonuses ===\nSkill Gain: %+(.-)%%\nExperience Gain: %+(.-)%%\nDamage: %+(.-)%%\nMax Health: %+(.-)%%\nMax Mana: %+(.-)%%\n\nYou haven't consumed any Reborn Orbs yet%.\n\nYou are eligible for rebirth!(.-)$", tpl = "=== Your Reborn Status ===\n\nCurrent Level: %s\nTimes Reborn: %s\nOrbs Consumed: %s\n\n=== Active Bonuses ===\nSkill Gain: +%s%%\nExperience Gain: +%s%%\nDamage: +%s%%\nMax Health: +%s%%\nMax Mana: +%s%%\n\nYou haven't consumed any Reborn Orbs yet.\n\nYou are eligible for rebirth!%s" },
    { pat = "^Ah, seeker of reckoning%. The scales of death demand recompense%. Provide preserved hearts, vessels of life essence%. Each heart surrendered will momentarily sate the abyss's hunger, if only for a brief respite%.\n\nItems required:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seeker of reckoning. The scales of death demand recompense. Provide preserved hearts, vessels of life essence. Each heart surrendered will momentarily sate the abyss's hunger, if only for a brief respite.\n\nItems required:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^%*Ancient words of power echo through the chamber%*\n\nThe bond is forged! Your level (.-) has transcended its former nature%.\n\nBehold %- a (.-), channeling the very essence of the elements!\n\nThe transformation cannot be undone%. May this power serve you well in the battles to come%.$", tpl = "*Ancient words of power echo through the chamber*\n\nThe bond is forged! Your level %s has transcended its former nature.\n\nBehold - a %s, channeling the very essence of the elements!\n\nThe transformation cannot be undone. May this power serve you well in the battles to come." },
    { pat = "^When you get a pet egg, you can choose to convert it to Pet Tickets instead!\n\nTicket values by rarity:\nCommon egg = (.-) ticket%(s%)\nUncommon egg = (.-) ticket%(s%)\nRare egg = (.-) ticket%(s%)\nEpic egg = (.-) ticket%(s%)\n\nSave up tickets to exchange for specific pets you want!$", tpl = "When you get a pet egg, you can choose to convert it to Pet Tickets instead!\n\nTicket values by rarity:\nCommon egg = %s ticket(s)\nUncommon egg = %s ticket(s)\nRare egg = %s ticket(s)\nEpic egg = %s ticket(s)\n\nSave up tickets to exchange for specific pets you want!" },
    { pat = "^The Pet Capsule Machine works like this:\n\n1%. Click the machine to insert (.-) gold\n2%. A random pet egg drops out!\n3%. Choose to KEEP the egg or convert it to Pet Tickets\n\nYour first pull each day costs only (.-) gold %(50%% off%)!\n\nYou have made (.-) total pulls so far%.$", tpl = "The Pet Capsule Machine works like this:\n\n1. Click the machine to insert %s gold\n2. A random pet egg drops out!\n3. Choose to KEEP the egg or convert it to Pet Tickets\n\nYour first pull each day costs only %s gold (50%% off)!\n\nYou have made %s total pulls so far." },
    { pat = "^Which logs are you after%?\n1%. Oak Logs %((.-) pouches%)\n2%. Greenheart Logs %((.-) pouches%)\n3%. Bloodwood Logs %((.-) pouches%)\n4%. Pine Logs %((.-) pouches%)\n5%. Maple Logs %((.-) pouches%)\nType 'oak', 'greenheart', 'bloodwood', 'pine', or 'maple' to choose%.$", tpl = "Which logs are you after?\n1. Oak Logs (%s pouches)\n2. Greenheart Logs (%s pouches)\n3. Bloodwood Logs (%s pouches)\n4. Pine Logs (%s pouches)\n5. Maple Logs (%s pouches)\nType 'oak', 'greenheart', 'bloodwood', 'pine', or 'maple' to choose." },
    { pat = "^We guarantee good luck eventually!\n\nAfter (.-) pulls without a Rare%+, the next pull guarantees Rare or better%.\nAfter (.-) pulls without an Epic, the next pull guarantees Epic!\n\nYour current counters:\nPulls since last Rare%+: (.-)\nPulls since last Epic: (.-)$", tpl = "We guarantee good luck eventually!\n\nAfter %s pulls without a Rare+, the next pull guarantees Rare or better.\nAfter %s pulls without an Epic, the next pull guarantees Epic!\n\nYour current counters:\nPulls since last Rare+: %s\nPulls since last Epic: %s" },
    { pat = "^Excellent! A level (.-) (.-)%.\n\nStrong development! Perfect for my comparative studies%.\n\nHere is your payment: (.-) gold%.\n\n%*The professor carefully stores the egg in a crystalline container%*\n\nThank you for your contribution to magical zoology!$", tpl = "Excellent! A level %s %s.\n\nStrong development! Perfect for my comparative studies.\n\nHere is your payment: %s gold.\n\n*The professor carefully stores the egg in a crystalline container*\n\nThank you for your contribution to magical zoology!" },
    { pat = "^Ah, a level (.-) (.-)%.\n\nStill valuable data for the early development phase research%.\n\nHere is your payment: (.-) gold%.\n\n%*The professor carefully stores the egg in a crystalline container%*\n\nThank you for your contribution to magical zoology!$", tpl = "Ah, a level %s %s.\n\nStill valuable data for the early development phase research.\n\nHere is your payment: %s gold.\n\n*The professor carefully stores the egg in a crystalline container*\n\nThank you for your contribution to magical zoology!" },
    { pat = "^Ah, seeker of my favor%. It amuses me to task you with eliminating other lesser demons%. You shall cleanse my domain by their eradication%. Slay these pathetic beings for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seeker of my favor. It amuses me to task you with eliminating other lesser demons. You shall cleanse my domain by their eradication. Slay these pathetic beings for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^%*The ritual chamber erupts with elemental power%*\n\nBy the ancient pact%.%.%. by fire and ice, shadow and light%.%.%.\n\nYour (.-) has been reborn as a (.-)!\n\nThe transformation is complete%. Wield this power wisely, young one%.$", tpl = "*The ritual chamber erupts with elemental power*\n\nBy the ancient pact... by fire and ice, shadow and light...\n\nYour %s has been reborn as a %s!\n\nThe transformation is complete. Wield this power wisely, young one." },
    { pat = "^%*The exchange is sealed with ancient magic%*\n\nExcellent choice%. Your level (.-) was a worthy specimen%.\n\nIn return, this (.-) %- one of the rarest creatures in existence%.\n\nMay fortune smile upon your adventures, collector%.$", tpl = "*The exchange is sealed with ancient magic*\n\nExcellent choice. Your level %s was a worthy specimen.\n\nIn return, this %s - one of the rarest creatures in existence.\n\nMay fortune smile upon your adventures, collector." },
    { pat = "^Which herb are you seeking%?\n1%. Crimson Rose %((.-) pouches%)\n2%. Morning Iris %((.-) pouches%)\n3%. Sweet Pea %((.-) pouches%)\n4%. Delphinium %((.-) pouches%)\nType 'crimson', 'morning', 'sweet', or 'delphinium' to choose%.$", tpl = "Which herb are you seeking?\n1. Crimson Rose (%s pouches)\n2. Morning Iris (%s pouches)\n3. Sweet Pea (%s pouches)\n4. Delphinium (%s pouches)\nType 'crimson', 'morning', 'sweet', or 'delphinium' to choose." },
    { pat = "^Ah, you have an interest in my collection, yes%? Excellent!\nI need certain%.%.%. materials%. Bring me these, and I shall grant you something in return%.\n\n(.-)\n\nBring them to me, and I shall see what fate grants you!$", tpl = "Ah, you have an interest in my collection, yes? Excellent!\nI need certain... materials. Bring me these, and I shall grant you something in return.\n\n%s\n\nBring them to me, and I shall see what fate grants you!" },
    { pat = "^Ah, seekers of enlightenment%. I shall share the essence of the elements, but the class has yet to begin%. Return when the sun touches the zenith%.\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seekers of enlightenment. I shall share the essence of the elements, but the class has yet to begin. Return when the sun touches the zenith.\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, fellow enthusiast of the underground realm%. I lack specific equipment to complete my exploration plans for next week%. Acquire for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, fellow enthusiast of the underground realm. I lack specific equipment to complete my exploration plans for next week. Acquire for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Which enchanting material do you seek%?\n1%. Arcane Powder %((.-) pouches%)\n2%. Mystic Powder %((.-) pouches%)\n3%. Crystal Essence %((.-) pouches%)\nType 'arcane', 'mystic', 'crystal' to choose%.$", tpl = "Which enchanting material do you seek?\n1. Arcane Powder (%s pouches)\n2. Mystic Powder (%s pouches)\n3. Crystal Essence (%s pouches)\nType 'arcane', 'mystic', 'crystal' to choose." },
    { pat = "^Ah, a sentinel of honor! I seek specific items to cleanse the evil within this land and finish my steadfast attire%. Retrieve for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, a sentinel of honor! I seek specific items to cleanse the evil within this land and finish my steadfast attire. Retrieve for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, seeker of gemmed strength, not that kind of crystals! I lack specific gemstones to complete my warlord attire%. Acquire for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seeker of gemmed strength, not that kind of crystals! I lack specific gemstones to complete my warlord attire. Acquire for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^%*The ritual circle glows with ancient power%*\n\nExcellent! Your level (.-) has transformed!\n\nBehold %- a (.-)! The enhancement is permanent%.\n\nMay it serve you well in your adventures!$", tpl = "*The ritual circle glows with ancient power*\n\nExcellent! Your level %s has transformed!\n\nBehold - a %s! The enhancement is permanent.\n\nMay it serve you well in your adventures!" },
    { pat = "^Psst, (.-)! My buddy Phil's having%.%.%. %*a crisis%*%. He thinks he's a comedian now%. Could you pretend to laugh at his jokes%? Just 5 times%? I'll pay you in homemade pumpkin bread!$", tpl = "Psst, %s! My buddy Phil's having... *a crisis*. He thinks he's a comedian now. Could you pretend to laugh at his jokes? Just 5 times? I'll pay you in homemade pumpkin bread!" },
    { pat = "^%*pushes forward a glass of (.-)%* \nThis one%.%.%. it's seen more battles than most soldiers%. Distilled in the year the old king fell%. Drink slow%.%.%. the past always catches up%.$", tpl = "*pushes forward a glass of %s* \nThis one... it's seen more battles than most soldiers. Distilled in the year the old king fell. Drink slow... the past always catches up.", trArgs = {1} },
    { pat = "^Psst, (.-)%. You look like someone who appreciates%.%.%. %*creative livestock acquisition%*%. How'd you like to 'rehome' some 'stray' sheep%? No shepherds, no problems%. %*Wink%*%.$", tpl = "Psst, %s. You look like someone who appreciates... *creative livestock acquisition*. How'd you like to 'rehome' some 'stray' sheep? No shepherds, no problems. *Wink*." },
    { pat = "^Ah, seeker of ventures and opportunities! I lack specific acquisitions to complete my entrepreneur's attire%. Secure for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seeker of ventures and opportunities! I lack specific acquisitions to complete my entrepreneur's attire. Secure for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^%*Zara performs the exchange with practiced elegance%*\n\nA pleasure doing business%. Your (.-) for this magnificent (.-)%.\n\nFew possess such a creature%. Guard it well, traveler%.$", tpl = "*Zara performs the exchange with practiced elegance*\n\nA pleasure doing business. Your %s for this magnificent %s.\n\nFew possess such a creature. Guard it well, traveler." },
    { pat = "^Ah, seeker of the wondrous glooth%. I lack specific components to fix my engineering machinery%. Obtain for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seeker of the wondrous glooth. I lack specific components to fix my engineering machinery. Obtain for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, seeker of harmony with the land%. I lack specific essences to complete my guardian attire%. Gather for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seeker of harmony with the land. I lack specific essences to complete my guardian attire. Gather for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^%*Zara shakes her head disappointedly%*\n\nYou don't possess a (.-), friend%.\n\nThis is a trade for serious collectors only%. Return when you have the proper specimen%.$", tpl = "*Zara shakes her head disappointedly*\n\nYou don't possess a %s, friend.\n\nThis is a trade for serious collectors only. Return when you have the proper specimen." },
    { pat = "^Ah, a seeker of the unseen threads! To complete my sacred attire, I require specific offerings%. Bring forth:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, a seeker of the unseen threads! To complete my sacred attire, I require specific offerings. Bring forth:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, a seeker of our enigma! I lack specific relics to complete the cloak of our brotherhood%. Secure for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, a seeker of our enigma! I lack specific relics to complete the cloak of our brotherhood. Secure for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Skål! Your curiosity warms the heart%. I seek certain relics to complete my ancestral attire%. Fetch for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Skål! Your curiosity warms the heart. I seek certain relics to complete my ancestral attire. Fetch for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, seeker of underwater power%. I lack certain artifacts to complete my deepling attire%. Retrieve for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, seeker of underwater power. I lack certain artifacts to complete my deepling attire. Retrieve for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Hark! A curious one approaches%. I seek specific items to complete a special attire%. Acquire these for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Hark! A curious one approaches. I seek specific items to complete a special attire. Acquire these for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^GOLD GAMBLE:\n\n%-> Cost: (.-) gold\n\nNext you'll choose a mini%-game!\nDifferent games = different odds to win!\nYour skill and luck will decide!\n\nReady to proceed%?$", tpl = "GOLD GAMBLE:\n\n-> Cost: %s gold\n\nNext you'll choose a mini-game!\nDifferent games = different odds to win!\nYour skill and luck will decide!\n\nReady to proceed?" },
    { pat = "^Ah, a seeker of knowledge! I require specific items to finalize a unique ensemble%. Seek and bring to me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, a seeker of knowledge! I require specific items to finalize a unique ensemble. Seek and bring to me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, a seeker of merriment! I require certain curiosities to complete my whimsical attire%. Fetch for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, a seeker of merriment! I require certain curiosities to complete my whimsical attire. Fetch for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, a seeker of our purpose! I lack specific artifacts to complete my infernal attire%. Acquire for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, a seeker of our purpose! I lack specific artifacts to complete my infernal attire. Acquire for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, a shadow's apprentice! I require certain articles to complete my distinct attire%. Acquire for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, a shadow's apprentice! I require certain articles to complete my distinct attire. Acquire for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Blessings upon you, kind one! I lack the means to dress properly%. If you're willing, provide me with:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Blessings upon you, kind one! I lack the means to dress properly. If you're willing, provide me with:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^%*Marcus performs the ancient ritual%*\n\nThere we go! Your (.-) has been enhanced into a magnificent (.-)!\n\nThe bloodline runs stronger now%. Treat it well!$", tpl = "*Marcus performs the ancient ritual*\n\nThere we go! Your %s has been enhanced into a magnificent %s!\n\nThe bloodline runs stronger now. Treat it well!" },
    { pat = "^Ah, a seeker of paths! I lack specific artifacts to complete my wayfaring attire%. Secure for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, a seeker of paths! I lack specific artifacts to complete my wayfaring attire. Secure for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, an inquisitive mind! I require certain items to complete a special outfit%. Retrieve for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, an inquisitive mind! I require certain items to complete a special outfit. Retrieve for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, a seeker of valor! I lack certain relics to complete my war%-forged attire%. Procure for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, a seeker of valor! I lack certain relics to complete my war-forged attire. Procure for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^Ah, a seeker of solace%. I lack certain essences to mend my afflicted attire%. Retrieve for me:\n(.-)\n\nLet me know if you have all of these materials%.$", tpl = "Ah, a seeker of solace. I lack certain essences to mend my afflicted attire. Retrieve for me:\n%s\n\nLet me know if you have all of these materials." },
    { pat = "^%*Kael shakes his head slowly%*\n\nI sense no (.-) in your possession%.\n\nThe ritual requires the proper vessel%. Return when you have acquired one%.$", tpl = "*Kael shakes his head slowly*\n\nI sense no %s in your possession.\n\nThe ritual requires the proper vessel. Return when you have acquired one." },
    { pat = "^%*Kael's eyes glow as he senses your companions%*\n\n(.-)%)\n    Power resonance: Level (.-) exp%)\n\n\n%(The ritual can only handle 9 vessels at once%)$", tpl = "*Kael's eyes glow as he senses your companions*\n\n%s)\n    Power resonance: Level %s exp)\n\n\n(The ritual can only handle 9 vessels at once)" },
    { pat = "^Hmm%.%.%. acceptable%. Your level (.-) meets my standards%. Here is your payment: (.-) rare candy and food%. Pleasure doing business%.$", tpl = "Hmm... acceptable. Your level %s meets my standards. Here is your payment: %s rare candy and food. Pleasure doing business." },
    { pat = "^I need (.-)! Last tube was stolen by those bandits near the mill%.\nBring me a paintbrush and I'll reward you%.%.%. somehow%.$", tpl = "I need %s! Last tube was stolen by those bandits near the mill.\nBring me a paintbrush and I'll reward you... somehow.", trArgs = {1} },
    { pat = "^%*Zara studies your collection with keen eyes%*\n\n(.-)%)\n    Strength: Level (.-) exp%)\n\n\n%(I can only appraise 9 at once%)$", tpl = "*Zara studies your collection with keen eyes*\n\n%s)\n    Strength: Level %s exp)\n\n\n(I can only appraise 9 at once)" },
    { pat = "^%*Kael gestures to glowing runes on the floor%*\n\n(.-) %+ \n\n%*The runes pulse with power%*\n\nWhich element calls to you%?$", tpl = "*Kael gestures to glowing runes on the floor*\n\n%s + \n\n*The runes pulse with power*\n\nWhich element calls to you?" },
    { pat = "^Alright, we have added the amount of (.-) gold to your {balance}%. You can {withdraw} your money anytime you want to%.$", tpl = "Alright, we have added the amount of %s gold to your {balance}. You can {withdraw} your money anytime you want to." },
    { pat = "^%*Zara opens an ornate chest filled with glowing eggs%*\n\n(.-) %+ \n\n%*Her eyes gleam%*\n\nWhich catches your interest%?$", tpl = "*Zara opens an ornate chest filled with glowing eggs*\n\n%s + \n\n*Her eyes gleam*\n\nWhich catches your interest?" },
    { pat = "^%*raises eyebrow%* The only thing free here is advice: \nGold weighs less than thirst%. Come back with (.-) coins%.$", tpl = "*raises eyebrow* The only thing free here is advice: \nGold weighs less than thirst. Come back with %s coins." },
    { pat = "^Here are the pet achievements:\n\n(.-) %-> READY TO CLAIM!\n(.-) %-> Not yet\n\nType the number to claim your reward!$", tpl = "Here are the pet achievements:\n\n%s -> READY TO CLAIM!\n%s -> Not yet\n\nType the number to claim your reward!" },
    { pat = "^%*Marcus examines your pets carefully%*\n\n(.-)%)\n    Power: Level (.-) exp%)\n\n\n%(I can only examine 9 at a time%)$", tpl = "*Marcus examines your pets carefully*\n\n%s)\n    Power: Level %s exp)\n\n\n(I can only examine 9 at a time)" },
    { pat = "^%*slides a (.-) across the bar%* \n(.-)\nThat'll be (.-) gold%. Remember %- liquids go down easier than regrets%.$", tpl = "*slides a %s across the bar* \n%s\nThat'll be %s gold. Remember - liquids go down easier than regrets." },
    { pat = "^Here are the drop rates:\n\nCommon: (.-)%%\n\nDon't worry, we have a pity system! Ask about {pity} for details%.$", tpl = "Here are the drop rates:\n\nCommon: %s%%\n\nDon't worry, we have a pity system! Ask about {pity} for details." },
    { pat = "^MAGNIFICENT! Your level 10 (.-) is TRULY ELITE! Here's your ELITE reward package! Return next week for more!$", tpl = "MAGNIFICENT! Your level 10 %s is TRULY ELITE! Here's your ELITE reward package! Return next week for more!" },
    { pat = "^The elements have answered! Your level (.-)\nis now a magnificent (.-)!\n\nThe transformation is complete!$", tpl = "The elements have answered! Your level %s\nis now a magnificent %s!\n\nThe transformation is complete!" },
    { pat = "^%*Marcus shakes his head%*\n\nYou don't have a (.-) with you, friend%.\n\nCome back when you've found one!$", tpl = "*Marcus shakes his head*\n\nYou don't have a %s with you, friend.\n\nCome back when you've found one!" },
    { pat = "^(.-), I CAN'T LET YOU LEAVE %- YOU ARE TOO STRONG ALREADY! YOU CAN ONLY LEAVE WITH LEVEL 9 OR LOWER%.$", tpl = "%s, I CAN'T LET YOU LEAVE - YOU ARE TOO STRONG ALREADY! YOU CAN ONLY LEAVE WITH LEVEL 9 OR LOWER." },
    { pat = "^I think you must be one of the richest inhabitants in the world! Your account balance is (.-) gold%.$", tpl = "I think you must be one of the richest inhabitants in the world! Your account balance is %s gold." },
    { pat = "^Your (.-) radiates with power at level (.-)! Such dedication! May this blessing aid your journey%.$", tpl = "Your %s radiates with power at level %s! Such dedication! May this blessing aid your journey." },
    { pat = "^Splendid! I'm looking for these colorful beauties:\n\n(.-)g %+ food\n\nWhich egg do you have for me%?$", tpl = "Splendid! I'm looking for these colorful beauties:\n\n%sg + food\n\nWhich egg do you have for me?" },
    { pat = "^Hmph! Your pet is only level (.-)! Too weak! Train it to at least level 3 before wasting my time!$", tpl = "Hmph! Your pet is only level %s! Too weak! Train it to at least level 3 before wasting my time!" },
    { pat = "^You've 'persuaded' (.-) sheep so far%. Remember: If anyone asks, they FOLLOWED you willingly%.$", tpl = "You've 'persuaded' %s sheep so far. Remember: If anyone asks, they FOLLOWED you willingly." },
    { pat = "^Hey (.-)! I'm trying out a new career as a stand%-up scarecrow%. Want to be my test audience%?$", tpl = "Hey %s! I'm trying out a new career as a stand-up scarecrow. Want to be my test audience?" },
    { pat = "^The metamorphosis is complete! Your (.-) has evolved into a (.-)! The magic flows through it!$", tpl = "The metamorphosis is complete! Your %s has evolved into a %s! The magic flows through it!" },
    { pat = "^IMPRESSIVE! Your (.-) is level (.-)! A true warrior's companion! Here's your reward, trainer!$", tpl = "IMPRESSIVE! Your %s is level %s! A true warrior's companion! Here's your reward, trainer!" },
    { pat = "^Wow, you have reached the magic number of a million gp!!! Your account balance is (.-) gold!$", tpl = "Wow, you have reached the magic number of a million gp!!! Your account balance is %s gold!" },
    { pat = "^Yesss%.%.%. these are the creatures I seek:\n\n(.-)g %+ food\n\nWhat darkness do you bring me%?$", tpl = "Yesss... these are the creatures I seek:\n\n%sg + food\n\nWhat darkness do you bring me?" },
    { pat = "^These are the evolutions I can perform:\n\n(.-) rare candy\n\nType the number of the evolution!$", tpl = "These are the evolutions I can perform:\n\n%s rare candy\n\nType the number of the evolution!" },
    { pat = "^Here you are, (.-) gold%. Please let me know if there is something else I can do for you%.$", tpl = "Here you are, %s gold. Please let me know if there is something else I can do for you." },
    { pat = "^The ritual is complete! Your (.-) has been infused with elemental power!\n\nBehold the (.-)!$", tpl = "The ritual is complete! Your %s has been infused with elemental power!\n\nBehold the %s!" },
    { pat = "^Magnificent! Your level (.-)\nhas evolved into a powerful (.-)!\n\nThe evolution is complete!$", tpl = "Magnificent! Your level %s\nhas evolved into a powerful %s!\n\nThe evolution is complete!" },
    { pat = "^Splendid! Your level (.-)\nfor an extraordinary (.-)!\n\nA trade worthy of a true collector!$", tpl = "Splendid! Your level %s\nfor an extraordinary %s!\n\nA trade worthy of a true collector!" },
    { pat = "^%*Marcus pulls out a worn leather journal%*\n\n(.-) %+ \n\nWhich enhancement interests you%?$", tpl = "*Marcus pulls out a worn leather journal*\n\n%s + \n\nWhich enhancement interests you?" },
    { pat = "^Choose a pet to gamble:\n%(You'll pick a mini%-game next with different odds!%)\n\n(.-)\n\n$", tpl = "Choose a pet to gamble:\n(You'll pick a mini-game next with different odds!)\n\n%s\n\n" },
    { pat = "^Your (.-) is only level (.-)%. I require at least level (.-)%. Train harder, peasant%.$", tpl = "Your %s is only level %s. I require at least level %s. Train harder, peasant." },
    { pat = "^Congratulations! Achievement unlocked: '(.-)'! You received (.-) rare candy and food!$", tpl = "Congratulations! Achievement unlocked: '%s'! You received %s rare candy and food!" },
    { pat = "^Perfect! Your level (.-) completes the quest! Here's your reward! Come back tomorrow!$", tpl = "Perfect! Your level %s completes the quest! Here's your reward! Come back tomorrow!" },
    { pat = "^%*polishes glass%* (.-) traveler%. The spirits whisper you carry (.-) burdens%.%.%.$", tpl = "*polishes glass* %s traveler. The spirits whisper you carry %s burdens..." },
    { pat = "^Excellent choice! Your (.-) for a rare (.-)!\n\nThis specimen is truly extraordinary!$", tpl = "Excellent choice! Your %s for a rare %s!\n\nThis specimen is truly extraordinary!" },
    { pat = "^You have made ten millions and it still grows! Your account balance is (.-) gold%.$", tpl = "You have made ten millions and it still grows! Your account balance is %s gold." },
    { pat = "^Great! Here are my current swaps:\n\n(.-) %+ \n\nType the number of the swap you want!$", tpl = "Great! Here are my current swaps:\n\n%s + \n\nType the number of the swap you want!" },
    { pat = "^So you would like me to change (.-) of your gold coins into (.-) platinum coins%?$", tpl = "So you would like me to change %s of your gold coins into %s platinum coins?" },
    { pat = "^Here are the evolutions I can perform:\n\n(.-) %+ \n\nSelect the evolution you want!$", tpl = "Here are the evolutions I can perform:\n\n%s + \n\nSelect the evolution you want!" },
    { pat = "^Here's what I offer for STRONG pets:\n\n(.-) rare candy %+ food\n\nShow me your pet!$", tpl = "Here's what I offer for STRONG pets:\n\n%s rare candy + food\n\nShow me your pet!" },
    { pat = "^Excellent! I need these farm friends:\n\n(.-)g %+ food\n\nWhat do you have for me%?$", tpl = "Excellent! I need these farm friends:\n\n%sg + food\n\nWhat do you have for me?" },
    { pat = "^I have already blessed your companion today%. Return in (.-) hours, dear one%.$", tpl = "I have already blessed your companion today. Return in %s hours, dear one." },
    { pat = "^A level (.-) companion! You care for your friend well%. Accept this blessing%.$", tpl = "A level %s companion! You care for your friend well. Accept this blessing." },
    { pat = "^You certainly have made a pretty penny%. Your account balance is (.-) gold%.$", tpl = "You certainly have made a pretty penny. Your account balance is %s gold." },
    { pat = "^%*sighs%* You want stories%? (.-) \nThe truth%? That stays with the spirits%.$", tpl = "*sighs* You want stories? %s \nThe truth? That stays with the spirits.", trArgs = {1} },
    { pat = "^Your (.-) is growing strong at level (.-)%. Here, take this small blessing%.$", tpl = "Your %s is growing strong at level %s. Here, take this small blessing." },
    { pat = "^Success! Your (.-) has evolved into a (.-)!\n\nThe transformation is complete!$", tpl = "Success! Your %s has evolved into a %s!\n\nThe transformation is complete!" },
    { pat = "^Excellent trade! Your (.-) for a (.-) plus goodies! Pleasure doing business!$", tpl = "Excellent trade! Your %s for a %s plus goodies! Pleasure doing business!" },
    { pat = "^%*The professor pulls out a glowing crystal and examines your pets%*\n\n(.-)$", tpl = "*The professor pulls out a glowing crystal and examines your pets*\n\n%s" },
    { pat = "^ADORABLE! These cuties will charm the audience:\n\n(.-) rare candy %+ food\n$", tpl = "ADORABLE! These cuties will charm the audience:\n\n%s rare candy + food\n" },
    { pat = "^TERRIFYING! These will give the crowd a fright:\n\n(.-) rare candy %+ food\n$", tpl = "TERRIFYING! These will give the crowd a fright:\n\n%s rare candy + food\n" },
    { pat = "^%*plays discordant notes%* This is '(.-)'%.%.%. The hidden meaning%? (.-)$", tpl = "*plays discordant notes* This is '%s'... The hidden meaning? %s" },
    { pat = "^Your (.-) is%.%.%. common%. I only deal with RARE specimens%. Good day%.$", tpl = "Your %s is... common. I only deal with RARE specimens. Good day." },
    { pat = "^(.-) This pier's a mess%. Bring me (.-) bits o' trash and I'll owe ye%.$", tpl = "%s This pier's a mess. Bring me %s bits o' trash and I'll owe ye." },
    { pat = "^Today's Quest: (.-)\n\nReward: (.-) rare candy %+ food\n\nShow me your pet!$", tpl = "Today's Quest: %s\n\nReward: %s rare candy + food\n\nShow me your pet!" },
    { pat = "^Perfect! Traded your level (.-) plus goodies!\n\nPleasure doing business!$", tpl = "Perfect! Traded your level %s plus goodies!\n\nPleasure doing business!" },
    { pat = "^%+10%% max HP and %+10%% max Mana for 1 day%. Cost: (.-) gold%. Buy%?$", tpl = "+10%% max HP and +10%% max Mana for 1 day. Cost: %s gold. Buy?" },
    { pat = "^No skill loss on your next death%. 1 charge%. Cost: (.-) gold%. Buy%?$", tpl = "No skill loss on your next death. 1 charge. Cost: %s gold. Buy?" },
    { pat = "^Are you sure you wish to withdraw (.-) gold from your bank account%?$", tpl = "Are you sure you wish to withdraw %s gold from your bank account?" },
    { pat = "^MAGNIFICENT! I need these exotic beauties:\n\n(.-) rare candy %+ food\n$", tpl = "MAGNIFICENT! I need these exotic beauties:\n\n%s rare candy + food\n" },
    { pat = "^Elemental transformations available:\n\n(.-) %+ \n\nChoose your element!$", tpl = "Elemental transformations available:\n\n%s + \n\nChoose your element!" },
    { pat = "^No EXP loss on your next death%. 1 charge%. Cost: (.-) gold%. Buy%?$", tpl = "No EXP loss on your next death. 1 charge. Cost: %s gold. Buy?" },
    { pat = "^I'm looking for these pets:\n\n(.-)g %+ food\n\nWhich one do you have%?$", tpl = "I'm looking for these pets:\n\n%sg + food\n\nWhich one do you have?" },
    { pat = "^Multiple (.-) pets detected!\n\n(.-) exp%)\n\n\n%(Showing first 9 eggs%)$", tpl = "Multiple %s pets detected!\n\n%s exp)\n\n\n(Showing first 9 eggs)" },
    { pat = "^Level (.-)%?! PATHETIC! Only LEVEL 10 pets are ELITE! Train harder!$", tpl = "Level %s?! PATHETIC! Only LEVEL 10 pets are ELITE! Train harder!" },
    { pat = "^Wonderful! I'm looking for these little critters:\n\n(.-)g %+ food\n$", tpl = "Wonderful! I'm looking for these little critters:\n\n%sg + food\n" },
    { pat = "^You already claimed ELITE rewards this week! Return in (.-) days!$", tpl = "You already claimed ELITE rewards this week! Return in %s days!" },
    { pat = "^Takes guts to carry gunpowder! Bring me (.-) kegs if you dare%.$", tpl = "Takes guts to carry gunpowder! Bring me %s kegs if you dare." },
    { pat = "^You don't have a (.-)! This is a rare trade, not for beginners!$", tpl = "You don't have a %s! This is a rare trade, not for beginners!" },
    { pat = "^Wonderful! These wild creatures need our care:\n\n(.-)g %+ food\n$", tpl = "Wonderful! These wild creatures need our care:\n\n%sg + food\n" },
    { pat = "^Whoa whoa! Lady Luck needs a break! Come back in (.-) minutes!$", tpl = "Whoa whoa! Lady Luck needs a break! Come back in %s minutes!" },
    { pat = "^%*ghostly voice%* You interrupt the eternal concert%.%.%. (.-)$", tpl = "*ghostly voice* You interrupt the eternal concert... %s" },
    { pat = "^(.-) Seems ye did a fine job cleanin'! Ready for yer reward%?$", tpl = "%s Seems ye did a fine job cleanin'! Ready for yer reward?" },
    { pat = "^Magnificent! A (.-)! Such beautiful colors! Here's (.-) gold!$", tpl = "Magnificent! A %s! Such beautiful colors! Here's %s gold!" },
    { pat = "^Bah, that's not enough rum! Bring me (.-) barrels at least%.$", tpl = "Bah, that's not enough rum! Bring me %s barrels at least." },
    { pat = "^SPECTACULAR! This parrot will be the star! Here's (.-) gold!$", tpl = "SPECTACULAR! This parrot will be the star! Here's %s gold!" },
    { pat = "^Delicious! A (.-)! Perfect for my recipes! Here's (.-) gold!$", tpl = "Delicious! A %s! Perfect for my recipes! Here's %s gold!" },
    { pat = "^Here are my exclusive rare trades:\n\n(.-) %+ \n\nChoose wisely!$", tpl = "Here are my exclusive rare trades:\n\n%s + \n\nChoose wisely!" },
    { pat = "^You don't have a (.-) egg! The darkness is displeased%.%.%.$", tpl = "You don't have a %s egg! The darkness is displeased..." },
    { pat = "^Gharz will%.%.%. support%. For now%. %[Supporters: (.-)/2]$", tpl = "Gharz will... support. For now. [Supporters: %s/2]" },
    { pat = "^Magnificent! These are the legends I seek:\n\n(.-)g %+ food\n$", tpl = "Magnificent! These are the legends I seek:\n\n%sg + food\n" },
    { pat = "^You possess multiple (.-) exp%)\n\n\n%(Showing first 9 eggs%)$", tpl = "You possess multiple %s exp)\n\n\n(Showing first 9 eggs)" },
    { pat = "^By the Light's grace, you are blessed! %(%+(.-)%% max HP%)$", tpl = "By the Light's grace, you are blessed! (+%s%% max HP)" },
    { pat = "^Your pet is only level (.-)! I need level (.-) or higher!$", tpl = "Your pet is only level %s! I need level %s or higher!" },
    { pat = "^(.-)\n\nJACKPOT! You guessed it! Random pet %+ rare candy!$", tpl = "%s\n\nJACKPOT! You guessed it! Random pet + rare candy!" },
    { pat = "^That's barely a rag! I need at least (.-) cloth rolls%.$", tpl = "That's barely a rag! I need at least %s cloth rolls." },
    { pat = "^You don't have a (.-) egg! Come back when you find one!$", tpl = "You don't have a %s egg! Come back when you find one!" },
    { pat = "^You have multiple (.-) exp%)\n\n\n%(Showing first 9 eggs%)$", tpl = "You have multiple %s exp)\n\n\n(Showing first 9 eggs)" },
    { pat = "^IN RHYVES! AND WHAT PROFESSION HAVE YOU CHOSEN: (.-)%?$", tpl = "IN RHYVES! AND WHAT PROFESSION HAVE YOU CHOSEN: %s?" },
    { pat = "^Splendid! I seek these water dwellers:\n\n(.-)g %+ food\n$", tpl = "Splendid! I seek these water dwellers:\n\n%sg + food\n" },
    { pat = "^A (.-)! ARE YOU SURE%? THIS DECISION IS IRREVERSIBLE!$", tpl = "A %s! ARE YOU SURE? THIS DECISION IS IRREVERSIBLE!" },
    { pat = "^%*blocks bridge%* Answer me this or pay 50 gold!\n(.-)$", tpl = "*blocks bridge* Answer me this or pay 50 gold!\n%s" },
    { pat = "^WONDERFUL! The penguin will waddle! Here's (.-) gold!$", tpl = "WONDERFUL! The penguin will waddle! Here's %s gold!" },
    { pat = "^BEAUTIFUL! The butterfly flutters! Here's (.-) gold!$", tpl = "BEAUTIFUL! The butterfly flutters! Here's %s gold!" },
    { pat = "^So you ask me for a {(.-)} to begin your adventure%?$", tpl = "So you ask me for a {%s} to begin your adventure?" },
    { pat = "^Very well%. You have transfered (.-) gold to (.-)%.$", tpl = "Very well. You have transfered %s gold to %s." },
    { pat = "^HORRIFYING! The nightmare finale! Here's (.-) gold!$", tpl = "HORRIFYING! The nightmare finale! Here's %s gold!" },
    { pat = "^Gharz already gave support%. %[Supporters: (.-)/2]$", tpl = "Gharz already gave support. [Supporters: %s/2]" },
    { pat = "^CREEPY! The spider spins terror! Here's (.-) gold!$", tpl = "CREEPY! The spider spins terror! Here's %s gold!" },
    { pat = "^So you would like to transfer (.-) gold to (.-)%?$", tpl = "So you would like to transfer %s gold to %s?" },
    { pat = "^Morga already gave support! %[Supporters: (.-)/2]$", tpl = "Morga already gave support! [Supporters: %s/2]" },
    { pat = "^PRECIOUS! This poodle performs! Here's (.-) gold!$", tpl = "PRECIOUS! This poodle performs! Here's %s gold!" },
    { pat = "^You don't have a (.-) to evolve! Train one first!$", tpl = "You don't have a %s to evolve! Train one first!" },
    { pat = "^You don't have a (.-) egg! Come back when you do!$", tpl = "You don't have a %s egg! Come back when you do!" },
    { pat = "^%*devours greedily%* (.-)! Your favor is now (.-)$", tpl = "*devours greedily* %s! Your favor is now %s" },
    { pat = "^AMAZING! The seagul will soar! Here's (.-) gold!$", tpl = "AMAZING! The seagul will soar! Here's %s gold!" },
    { pat = "^You don't have a (.-) egg! Check your inventory!$", tpl = "You don't have a %s egg! Check your inventory!" },
    { pat = "^ADORABLE! The bunny hops in! Here's (.-) gold!$", tpl = "ADORABLE! The bunny hops in! Here's %s gold!" },
    { pat = "^MAGICAL! The fairy enchants! Here's (.-) gold!$", tpl = "MAGICAL! The fairy enchants! Here's %s gold!" },
    { pat = "^You don't have a (.-) egg! Return when you do!$", tpl = "You don't have a %s egg! Return when you do!" },
    { pat = "^You need to be at least level (.-) to reborn%.$", tpl = "You need to be at least level %s to reborn." },
    { pat = "^Would you really like to deposit (.-) gold%?$", tpl = "Would you really like to deposit %s gold?" },
    { pat = "^FABULOUS! Pink perfection! Here's (.-) gold!$", tpl = "FABULOUS! Pink perfection! Here's %s gold!" },
    { pat = "^ANCIENT! The mummy curses! Here's (.-) gold!$", tpl = "ANCIENT! The mummy curses! Here's %s gold!" },
    { pat = "^You already claimed the '(.-)' achievement!$", tpl = "You already claimed the '%s' achievement!" },
    { pat = "^SPOOKY! The ghost haunts! Here's (.-) gold!$", tpl = "SPOOKY! The ghost haunts! Here's %s gold!" },
    { pat = "^Who would you like transfer (.-) gold to%?$", tpl = "Who would you like transfer %s gold to?" },
    { pat = "^What%? I have already gave you one {(.-)}!$", tpl = "What? I have already gave you one {%s}!" },
    { pat = "^Hmm%.%.%. (.-) support change%. Need 2$", tpl = "Hmm... %s support change. Need 2" },
    { pat = "^You haven't completed '(.-)' yet! (.-)$", tpl = "You haven't completed '%s' yet! %s" },
    { pat = "^You don't have a (.-)! Seek one first!$", tpl = "You don't have a %s! Seek one first!" },
    { pat = "^Yessss! A (.-) gold from the shadows!$", tpl = "Yessss! A %s gold from the shadows!" },
    { pat = "^(.-)\n\nYou WON! Plus bonus rare candy!$", tpl = "%s\n\nYou WON! Plus bonus rare candy!" },
    { pat = "^The rebirth ritual has failed!\n\n(.-)$", tpl = "The rebirth ritual has failed!\n\n%s" },
    { pat = "^Your account balance is (.-) gold%.$", tpl = "Your account balance is %s gold." },
    { pat = "^(.-)\n\nYou LOST! Your gold is gone!$", tpl = "%s\n\nYou LOST! Your gold is gone!" },
    { pat = "^Pah! (.-) support change%. Need 2$", tpl = "Pah! %s support change. Need 2" },
    { pat = "^(.-)\n\nYou LOST! Your pet is gone!$", tpl = "%s\n\nYou LOST! Your pet is gone!" },
    { pat = "^(.-)\n\nYou WON! Got a random pet!$", tpl = "%s\n\nYou WON! Got a random pet!" },
    { pat = "^Perfect! A (.-) gold plus food!$", tpl = "Perfect! A %s gold plus food!" },
    { pat = "^You need (.-) gold to gamble!$", tpl = "You need %s gold to gamble!" },
    { pat = "^You need (.-) gold for (.-)%.$", tpl = "You need %s gold for %s.", trArgs = {2} },
    { pat = "^You don't have a (.-) egg!$", tpl = "You don't have a %s egg!" },
    { pat = "^Magnificent! A (.-) gold!$", tpl = "Magnificent! A %s gold!" },
    { pat = "^LEGENDARY! A (.-) gold!$", tpl = "LEGENDARY! A %s gold!" },
    { pat = "^Wonderful! A (.-) gold!$", tpl = "Wonderful! A %s gold!" },
    { pat = "^You already have (.-)%.$", tpl = "You already have %s.", trArgs = {1} },
    { pat = "^Bzzzz! A (.-) gold!$", tpl = "Bzzzz! A %s gold!" },
    { pat = "^THEN WHAT%? (.-)%.$", tpl = "THEN WHAT? %s." },
}

-- Translates server-composed messages: exact tr() first, then template match
-- translating captured args (e.g. quest names) with tr().
function _G.trServerMsg(text)
    for _, p in ipairs(serverMsgPatterns) do
        local caps = { text:match(p.pat) }
        if #caps > 0 then
            for _, i in ipairs(p.trArgs or {}) do
                caps[i] = tr(caps[i])
            end
            return tr(p.tpl, unpack(caps))
        end
    end
    return tr(text)
end

-- Dumps all collected missing translation keys to data/missing_translations.lua
-- Call from terminal: dumpMissingTranslations()
function _G.dumpMissingTranslations()
    local missing = _G.missingTranslations or {}
    local keys = {}
    for k, _ in pairs(missing) do
        table.insert(keys, k)
    end
    table.sort(keys)

    local lines = { '-- Missing translations collected at runtime', '-- Paste these into data/locales/<lang>.lua' }
    for _, k in ipairs(keys) do
        local escaped = k:gsub('\\', '\\\\'):gsub('\n', '\\n'):gsub('\t', '\\t'):gsub('"', '\\"')
        table.insert(lines, ' ["' .. escaped .. '"] = "",')
    end

    local output = table.concat(lines, '\n')
    local path = '/missing_translations.lua'
    local ok, err = pcall(g_resources.writeFileContents, path, output)
    local writeDir = g_resources.getWriteDir and g_resources.getWriteDir() or '?'
    if ok then
        print('[Locales] Dumped ' .. #keys .. ' missing translations.')
        print('[Locales] File written to: ' .. writeDir .. path)
    else
        print('[Locales] ERROR writing file: ' .. tostring(err))
        print('[Locales] Write dir: ' .. writeDir)
        print('[Locales] Collected keys count: ' .. #keys)
    end
    return #keys
end
