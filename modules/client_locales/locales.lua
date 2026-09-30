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
