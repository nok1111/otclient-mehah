-- skill consts
SKILL_BLACKSMITH = 1
SKILL_ALCHEMY = 2
SKILL_COOKING = 3
SKILL_ENCHANTING = 4
SKILL_MINING = 5
SKILL_HERBALISM = 6
SKILL_FISHING = 7
SKILL_RUNE_SEEKER = 8

-- helpers
local skillIdToUI = {
    [SKILL_BLACKSMITH] = "Blacksmith",
    [SKILL_ALCHEMY] = "Alchemy",
    [SKILL_COOKING] = "Refinery",
    [SKILL_ENCHANTING] = "Enchanting",
    [SKILL_MINING] = "Mining",
    [SKILL_HERBALISM] = "Herbalism",
    [SKILL_FISHING] = "Fishing",
    [SKILL_RUNE_SEEKER] = "Woodcutting",
}


skillsWindow = nil
skillsButton = nil
skillsSettings = nil

function init()
    connect(LocalPlayer, {
        onExperienceChange = onExperienceChange,
        onLevelChange = onLevelChange,
        onHealthChange = onHealthChange,
        onManaChange = onManaChange,
        onSoulChange = onSoulChange,
        onFreeCapacityChange = onFreeCapacityChange,
        onTotalCapacityChange = onTotalCapacityChange,
        onStaminaChange = onStaminaChange,
        onOfflineTrainingChange = onOfflineTrainingChange,
        onRegenerationChange = onRegenerationChange,
        onSpeedChange = onSpeedChange,
        onBaseSpeedChange = onBaseSpeedChange,
        onMagicLevelChange = onMagicLevelChange,
        onBaseMagicLevelChange = onBaseMagicLevelChange,
        onSkillChange = onSkillChange,
        onBaseSkillChange = onBaseSkillChange
    })
    connect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

    ProtocolGame.registerOpcode(GameServerOpcodes.GameServerUpdateFame, parseUpdateFame)
    ProtocolGame.registerOpcode(GameServerOpcodes.GameServerJobs, parseJobs)

    skillsButton = modules.game_mainpanel.addToggleButton('skillsButton', tr('Skills') .. ' (Alt+S)',
                                                                   '/images/options/button_skills', toggle, false, 1)
    skillsButton:setOn(true)
    skillsWindow = g_ui.loadUI('skills')

    g_keyboard.bindKeyDown('Alt+S', toggle)

    skillSettings = g_settings.getNode('skills-hide')
    if not skillSettings then
        skillSettings = {}
    end

    refresh()
    skillsWindow:setup()
    if g_game.isOnline() then
        skillsWindow:setupOnStart()
    end
end

function terminate()
    disconnect(LocalPlayer, {
        onExperienceChange = onExperienceChange,
        onLevelChange = onLevelChange,
        onHealthChange = onHealthChange,
        onManaChange = onManaChange,
        onSoulChange = onSoulChange,
        onFreeCapacityChange = onFreeCapacityChange,
        onTotalCapacityChange = onTotalCapacityChange,
        onStaminaChange = onStaminaChange,
        onOfflineTrainingChange = onOfflineTrainingChange,
        onRegenerationChange = onRegenerationChange,
        onSpeedChange = onSpeedChange,
        onBaseSpeedChange = onBaseSpeedChange,
        onMagicLevelChange = onMagicLevelChange,
        onBaseMagicLevelChange = onBaseMagicLevelChange,
        onSkillChange = onSkillChange,
        onBaseSkillChange = onBaseSkillChange
    })
    disconnect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })


    g_keyboard.unbindKeyDown('Alt+S')
    skillsWindow:destroy()
    skillsButton:destroy()

    skillsWindow = nil
    skillsButton = nil

    ProtocolGame.unregisterOpcode(GameServerOpcodes.GameServerUpdateFame, parseUpdateFame)
    ProtocolGame.unregisterOpcode(GameServerOpcodes.GameServerJobs, parseJobs)


end

function expForLevel(level)
    return math.floor((50 * level * level * level) / 3 - 100 * level * level + (850 * level) / 3 - 200)
end

function expToAdvance(currentLevel, currentExp)
    return expForLevel(currentLevel + 1) - currentExp
end

function resetSkillColor(id)
    local skill = skillsWindow:recursiveGetChildById(id)
    local widget = skill:getChildById('value')
    widget:setColor('#bbbbbb')
end

function toggleSkill(id, state)
    local skill = skillsWindow:recursiveGetChildById(id)
    skill:setVisible(state)
end

function setSkillBase(id, value, baseValue)
    if baseValue <= 0 or value < 0 then
        return
    end
    local skill = skillsWindow:recursiveGetChildById(id)
    local widget = skill:getChildById('value')

    if value > baseValue then
        widget:setColor('#008b00') -- green
        skill:setTooltip(baseValue .. ' +' .. (value - baseValue))
    elseif value < baseValue then
        widget:setColor('#b22222') -- red
        skill:setTooltip(baseValue .. ' ' .. (value - baseValue))
    else
        widget:setColor('#bbbbbb') -- default
        skill:removeTooltip()
    end
end

function setSkillValue(id, value)
    local skill = skillsWindow:recursiveGetChildById(id)
    if skill then
        local widget = skill:getChildById('value')
        if id == "skillId7" or id == "skillId9" or id == "skillId11" or id == "skillId13" or id == "skillId14" or id == "skillId15" then
            local value = value
            widget:setText(value .. "%")
        else
            widget:setText(value)
        end
    end
end

function setSkillColor(id, value)
    local skill = skillsWindow:recursiveGetChildById(id)
    if skill then
        local widget = skill:getChildById('value')
        widget:setColor(value)
    end
end

function setSkillTooltip(id, value)
    local skill = skillsWindow:recursiveGetChildById(id)
    if skill then
        local widget = skill:getChildById('value')
        widget:setTooltip(value)
    end
end

function setSkillPercent(id, percent, tooltip, color)
    local skill = skillsWindow:recursiveGetChildById(id)
    if skill then
        local widget = skill:getChildById('percent')
        if widget then
            widget:setPercent(math.floor(percent))

            if tooltip then
                widget:setTooltip(tooltip)
            end

            if color then
                widget:setBackgroundColor(color)
            end
        end
    end
end

function checkAlert(id, value, maxValue, threshold, greaterThan)
    if greaterThan == nil then
        greaterThan = false
    end
    local alert = false

    -- maxValue can be set to false to check value and threshold
    -- used for regeneration checking
    if type(maxValue) == 'boolean' then
        if maxValue then
            return
        end

        if greaterThan then
            if value > threshold then
                alert = true
            end
        else
            if value < threshold then
                alert = true
            end
        end
    elseif type(maxValue) == 'number' then
        if maxValue < 0 then
            return
        end

        local percent = math.floor((value / maxValue) * 100)
        if greaterThan then
            if percent > threshold then
                alert = true
            end
        else
            if percent < threshold then
                alert = true
            end
        end
    end

    if alert then
        setSkillColor(id, '#b22222') -- red
    else
        resetSkillColor(id)
    end
end

function update()
    local offlineTraining = skillsWindow:recursiveGetChildById('offlineTraining')
    if not g_game.getFeature(GameOfflineTrainingTime) then
        offlineTraining:hide()
    else
        offlineTraining:show()
    end

    local regenerationTime = skillsWindow:recursiveGetChildById('regenerationTime')
    if not g_game.getFeature(GamePlayerRegenerationTime) then
        regenerationTime:hide()
    else
        regenerationTime:show()
    end
end

function online()
    skillsWindow:setupOnStart() -- load character window configuration
    refresh()
end

function refresh()
    local player = g_game.getLocalPlayer()
    if not player then
        return
    end

    if expSpeedEvent then
        expSpeedEvent:cancel()
    end
    expSpeedEvent = cycleEvent(checkExpSpeed, 30 * 1000)

    onExperienceChange(player, player:getExperience())
    onLevelChange(player, player:getLevel(), player:getLevelPercent())
    onHealthChange(player, player:getHealth(), player:getMaxHealth())
    onManaChange(player, player:getMana(), player:getMaxMana())
    onSoulChange(player, player:getSoul())
    onFreeCapacityChange(player, player:getFreeCapacity())
    onStaminaChange(player, player:getStamina())
    onMagicLevelChange(player, player:getMagicLevel(), player:getMagicLevelPercent())
    onOfflineTrainingChange(player, player:getOfflineTrainingTime())
    onRegenerationChange(player, player:getRegenerationTime())
    onSpeedChange(player, player:getSpeed())

    -- Define skill ranges at the top of the file for maintainability
local COMBAT_SKILLS = {Skill.Fist, Skill.Club, Skill.Sword, Skill.Axe, Skill.Distance, Skill.Shielding, Skill.Fishing}
local SPECIAL_SKILLS = {Skill.CriticalChance, Skill.CriticalDamage, Skill.LifeLeechChance, Skill.LifeLeechAmount, 
                       Skill.ManaLeechChance, Skill.ManaLeechAmount, Skill.AttackSpeed, Skill.Weaken, Skill.ExtraHealing}

-- Update skills function
for _, skillId in ipairs(COMBAT_SKILLS) do
    local level = player:getSkillLevel(skillId)
    local percent = player:getSkillLevelPercent(skillId)
    if level and percent then
        onSkillChange(player, skillId, level, percent)
    end
end

for _, skillId in ipairs(SPECIAL_SKILLS) do
    local level = player:getSkillLevel(skillId)
    local percent = player:getSkillLevelPercent(skillId)

    print(level, percent)
    if level and percent then
        onSkillChange(player, skillId, level, percent)
    end
end


local hasAdditionalSkills = g_game.getFeature(GameAdditionalSkills)
    for i = Skill.Fist, Skill.Transcendence do

        if i > Skill.Fishing then
            local ativedAdditionalSkills = hasAdditionalSkills
            if ativedAdditionalSkills then
                if g_game.getClientVersion() >= 1281 then
	            if i == Skill.LifeLeechAmount or i == Skill.ManaLeechAmount then
                        ativedAdditionalSkills = false
                    elseif g_game.getClientVersion() < 1332 and Skill.Transcendence then
                        ativedAdditionalSkills = false
                    elseif i >= Skill.Fatal and player:getSkillLevel(i) <= 0 then
                        ativedAdditionalSkills = false
                    end
		elseif g_game.getClientVersion() < 1281 and i >= Skill.Fatal then
                    ativedAdditionalSkills = false
	        end
            end

            toggleSkill('skillId' .. i, ativedAdditionalSkills)
        end
    end
    update()
    updateHeight()
end

function updateHeight()
    local maximumHeight = 8 -- margin top and bottom

    if g_game.isOnline() then
        local char = g_game.getCharacterName()

        if not skillSettings[char] then
            skillSettings[char] = {}
        end

        local skillsButtons = skillsWindow:recursiveGetChildById('experience'):getParent():getChildren()

        for _, skillButton in pairs(skillsButtons) do
            local percentBar = skillButton:getChildById('percent')

            if skillButton:isVisible() then
                if percentBar then
                    showPercentBar(skillButton, skillSettings[char][skillButton:getId()] ~= 1)
                end
                maximumHeight = maximumHeight + skillButton:getHeight() + skillButton:getMarginBottom()
            end
        end
    else
        maximumHeight = 390
    end

    local contentsPanel = skillsWindow:getChildById('contentsPanel')
    skillsWindow:setContentMinimumHeight(44)
    skillsWindow:setContentMaximumHeight(maximumHeight)
end

function offline()
    skillsWindow:setParent(nil, true)
    if expSpeedEvent then
        expSpeedEvent:cancel()
        expSpeedEvent = nil
    end
    g_settings.setNode('skills-hide', skillSettings)
end

function toggle()
    if skillsButton:isOn() then
        skillsWindow:close()
        skillsButton:setOn(false)
    else
        if not skillsWindow:getParent() then
            local panel = modules.game_interface.findContentPanelAvailable(skillsWindow, skillsWindow:getMinimumHeight())
            if not panel then
                return
            end

            panel:addChild(skillsWindow)
        end
        skillsWindow:open()
        skillsButton:setOn(true)
        updateHeight()
    end
end

function checkExpSpeed()
    local player = g_game.getLocalPlayer()
    if not player then
        return
    end

    local currentExp = player:getExperience()
    local currentTime = g_clock.seconds()
    if player.lastExps ~= nil then
        player.expSpeed = (currentExp - player.lastExps[1][1]) / (currentTime - player.lastExps[1][2])
        onLevelChange(player, player:getLevel(), player:getLevelPercent())
    else
        player.lastExps = {}
    end
    table.insert(player.lastExps, {currentExp, currentTime})
    if #player.lastExps > 30 then
        table.remove(player.lastExps, 1)
    end
end

function onMiniWindowOpen()
    skillsButton:setOn(true)
end

function onMiniWindowClose()
    skillsButton:setOn(false)
end

function onSkillButtonClick(button)
    local percentBar = button:getChildById('percent')
    local skillIcon = button:getChildById('icon')
    if percentBar and skillIcon then
        showPercentBar(button, not percentBar:isVisible())
        skillIcon:setVisible(skillIcon:isVisible())

        local char = g_game.getCharacterName()
        if percentBar:isVisible() then
            skillsWindow:modifyMaximumHeight(6)
            skillSettings[char][button:getId()] = 0
        else
            skillsWindow:modifyMaximumHeight(-6)
            skillSettings[char][button:getId()] = 1
        end
    end
end

function showPercentBar(button, show)
    local percentBar = button:getChildById('percent')
    local skillIcon = button:getChildById('icon')
    if percentBar and skillIcon then
        percentBar:setVisible(show)
        skillIcon:setVisible(show)
        if show then
            button:setHeight(21)
        else
            button:setHeight(21 - 6)
        end
    end
end

function onExperienceChange(localPlayer, value)
    setSkillValue('experience', comma_value(value))
end

function onLevelChange(localPlayer, value, percent)
    setSkillValue('level', comma_value(value))
    local text = tr('You have %s percent to go', 100 - percent) .. '\n' ..
                     tr('%s of experience left', expToAdvance(localPlayer:getLevel(), localPlayer:getExperience()))

    if localPlayer.expSpeed ~= nil then
        local expPerHour = math.floor(localPlayer.expSpeed * 3600)
        if expPerHour > 0 then
            local nextLevelExp = expForLevel(localPlayer:getLevel() + 1)
            local hoursLeft = (nextLevelExp - localPlayer:getExperience()) / expPerHour
            local minutesLeft = math.floor((hoursLeft - math.floor(hoursLeft)) * 60)
            hoursLeft = math.floor(hoursLeft)
            text = text .. '\n' .. tr('%s of experience per hour', comma_value(expPerHour))
            text = text .. '\n' .. tr('Next level in %d hours and %d minutes', hoursLeft, minutesLeft)
        end
    end

    setSkillPercent('level', percent, text)
end

function onHealthChange(localPlayer, health, maxHealth)
    setSkillValue('health', health)
    checkAlert('health', health, maxHealth, 30)
end

function onManaChange(localPlayer, mana, maxMana)
    setSkillValue('mana', mana)
    checkAlert('mana', mana, maxMana, 30)
end

function onSoulChange(localPlayer, soul)
    setSkillValue('soul', soul)
end

function onFreeCapacityChange(localPlayer, freeCapacity)
    setSkillValue('capacity', freeCapacity)
    checkAlert('capacity', freeCapacity, localPlayer:getTotalCapacity(), 20)
end

function onTotalCapacityChange(localPlayer, totalCapacity)
    checkAlert('capacity', localPlayer:getFreeCapacity(), totalCapacity, 20)
end

function onStaminaChange(localPlayer, stamina)
    local hours = math.floor(stamina / 60)
    local minutes = stamina % 60
    if minutes < 10 then
        minutes = '0' .. minutes
    end
    local percent = math.floor(100 * stamina / (42 * 60)) -- max is 42 hours --TODO not in all client versions

    setSkillValue('stamina', hours .. ':' .. minutes)

    -- TODO not all client versions have premium time
    if stamina > 2400 and g_game.getClientVersion() >= 1038 and localPlayer:isPremium() then
        local text = tr('You have %s hours and %s minutes left', hours, minutes) .. '\n' ..
                         tr('Now you will gain 50%% more experience')
        setSkillPercent('stamina', percent, text, 'green')
    elseif stamina > 2400 and g_game.getClientVersion() >= 1038 and not localPlayer:isPremium() then
        local text = tr('You have %s hours and %s minutes left', hours, minutes) .. '\n' .. tr(
                         'You will not gain 50%% more experience because you aren\'t premium player, now you receive only 1x experience points')
        setSkillPercent('stamina', percent, text, '#89F013')
    elseif stamina >= 2400 and g_game.getClientVersion() < 1038 then
        local text = tr('You have %s hours and %s minutes left', hours, minutes) .. '\n' ..
                         tr('If you are premium player, you will gain 50%% more experience')
        setSkillPercent('stamina', percent, text, 'green')
    elseif stamina < 2400 and stamina > 840 then
        setSkillPercent('stamina', percent, tr('You have %s hours and %s minutes left', hours, minutes), 'orange')
    elseif stamina <= 840 and stamina > 0 then
        local text = tr('You have %s hours and %s minutes left', hours, minutes) .. '\n' ..
                         tr('You gain only 50%% experience and you don\'t may gain loot from monsters')
        setSkillPercent('stamina', percent, text, 'red')
    elseif stamina == 0 then
        local text = tr('You have %s hours and %s minutes left', hours, minutes) .. '\n' ..
                         tr('You don\'t may receive experience and loot from monsters')
        setSkillPercent('stamina', percent, text, 'black')
    end
end

function onOfflineTrainingChange(localPlayer, offlineTrainingTime)
    if not g_game.getFeature(GameOfflineTrainingTime) then
        return
    end
    local hours = math.floor(offlineTrainingTime / 60)
    local minutes = offlineTrainingTime % 60
    if minutes < 10 then
        minutes = '0' .. minutes
    end
    local percent = 100 * offlineTrainingTime / (12 * 60) -- max is 12 hours

    setSkillValue('offlineTraining', hours .. ':' .. minutes)
    setSkillPercent('offlineTraining', percent, tr('You have %s percent', percent))
end

function onRegenerationChange(localPlayer, regenerationTime)
    if not g_game.getFeature(GamePlayerRegenerationTime) or regenerationTime < 0 then
        return
    end
    local minutes = math.floor(regenerationTime / 60)
    local seconds = regenerationTime % 60
    if seconds < 10 then
        seconds = '0' .. seconds
    end

    setSkillValue('regenerationTime', minutes .. ':' .. seconds)
    checkAlert('regenerationTime', regenerationTime, false, 300)
end

function onSpeedChange(localPlayer, speed)
    setSkillValue('speed', speed)

    onBaseSpeedChange(localPlayer, localPlayer:getBaseSpeed())
end

function onBaseSpeedChange(localPlayer, baseSpeed)
    setSkillBase('speed', localPlayer:getSpeed(), baseSpeed)
end

function onMagicLevelChange(localPlayer, magiclevel, percent)
    setSkillValue('magiclevel', magiclevel)
    setSkillPercent('magiclevel', percent, tr('You have %s percent to go', 100 - percent))

    onBaseMagicLevelChange(localPlayer, localPlayer:getBaseMagicLevel())
end

function onBaseMagicLevelChange(localPlayer, baseMagicLevel)
    setSkillBase('magiclevel', localPlayer:getMagicLevel(), baseMagicLevel)
end

function onSkillChange(localPlayer, id, level, percent)
    setSkillValue('skillId' .. id, level)
    setSkillPercent('skillId' .. id, percent, tr('You have %s percent to go', 100 - percent))

    onBaseSkillChange(localPlayer, id, localPlayer:getSkillBaseLevel(id))

end

function onBaseSkillChange(localPlayer, id, baseLevel)
    setSkillBase('skillId' .. id, localPlayer:getSkillLevel(id), baseLevel)
end

function parseUpdateFame(protocol, msg)
    local points = msg:getU32()
    local level = msg:getU16()
    local pointsToAdvance = msg:getU32()
    local percentage = msg:getU16()
    onFameChange(points, level, pointsToAdvance, percentage)
end

function onFameChange(points, level, pointsToAdvance, percentage)
    local fame = skillsWindow:recursiveGetChildById('fame')
    local fame2 = skillsWindow:recursiveGetChildById('famePointslabel')
    local fameLevel = fame:getChildById('fameLevel')
    fameLevel:setText(tostring(level))
    fameLevel:setWidth(fameLevel:getTextSize().width)
    --fame:setTooltip(("You need %d pts to unlock next fame level"):format(tostring(pointsToAdvance)))

    local famePoints = fame:getChildById('famePoints')
    famePoints:setText(points .. " exp")
    famePoints:setWidth(famePoints:getTextSize().width)

    local famePtsToLvl = fame2:getChildById('famePtsToLvl')
    famePtsToLvl:setText(tostring(pointsToAdvance))
    famePtsToLvl:setWidth(famePtsToLvl:getTextSize().width)

    -- set percentage
    local famebarpercent = skillsWindow:recursiveGetChildById('famebar')
    famebarpercent:setPercent(tonumber(percentage))
    famebarpercent:setTooltip("You have " .. 100 - tonumber(percentage) .. " percent to go.")
end

-- protocol
function parseJobs(protocol, msg)
pwarning("parseJobs triggered")
    local job_skill = {}
    local skillSize = msg:getU8()
    for i = 1, skillSize do
        local job = {}
        job.level = msg:getU16()
        job.percentage = msg:getU8()
        job_skill[i] = job
    end

    local professionId = msg:getU8()
    local professionDescription = msg:getString()

    updateMainJobs(job_skill, professionId)
end

function updateMainJobs(job_skill, profId)
pwarning("updateMainJobs triggered")
    for i = 1, 8 do
    -- done? xD
        -- finding 'id: professionIdX' inside skillsWindows
        local skillWindow = skillsWindow:recursiveGetChildById("professionId" .. i)
        if skillWindow then
            if job_skill[i] then
                skillWindow:show()
                
                -- finding 'id: label' inside id: 'professionIdX'
                local label = skillWindow:getChildById("label")
                if label then
                    label:setText(skillIdToUI[i])
                end

                -- finding 'id: value' inside id: 'professionIdX'
                local value = skillWindow:getChildById("value")
                if value then
                    value:setText(job_skill[i].level)
                end
                
                -- finding 'id: percent' inside id: 'professionIdX'
                local bar = skillWindow:getChildById("percent")
                if bar then
                    bar:setPercent(job_skill[i].percentage)
                    if i > 4 or (i < 5 and profId == i) then
                        bar:setTooltip("You have " .. 100 - job_skill[i].percentage .. " percent to go.")
                    end
                end
            else
                skillWindow:hide()
            end
        end
    end

    --show()
end