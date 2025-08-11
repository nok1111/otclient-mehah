local window, creatureBarHP, creatureHP, creatureName, creatureOutfit, creatureSpecial = nil, nil, nil, nil, nil, nil
local focusedMob = 0

local monstrosIncluidos = {
    "Lucella",
    "Azure [2]",
    "Azure [3]",
}

function init()
    
    connect(g_game, {
        onGameStart = function()
            create()
            scanForBoss()
        end,
        onGameEnd = function()
            destroy()
        end,
    })
    connect(Creature, {
        onHealthPercentChange = function(creature, health)
            onHealthPercentChange(creature, health)
        end,
        onSpecialPercentChange = function(creature, special)
            onSpecialPercentChange(creature, special)
        end,
        onAppear = function(creature)
            onAppear(creature)
        end,
        onDisappear = function(creature)
            onDisappear(creature)
        end,
    })
    if g_game.isOnline() then
        create()
        scanForBoss()
    end
end

function terminate()
	disconnect(g_game, {
		onGameStart = create,
		onGameEnd = destroy,
		onAppear = onAppear
	})
	disconnect(Creature, {
		onHealthPercentChange = onHealthPercentChange,
		onSpecialPercentChange = onSpecialPercentChange
	})
	destroy()
end

function create()
    if window then
        return
    end
    window = g_ui.loadUI("bossbar", modules.game_interface.getMapPanel())
    if not window then
        print('[BossBar] ERROR: Failed to load bossbar UI!')
        return
    end
    window:hide()
    creatureBarHP = window:recursiveGetChildById("creatureBarHP")
    creatureName = window:recursiveGetChildById("creatureName")
    creatureHP = window:recursiveGetChildById("creatureHP")
    creatureOutfit = window:recursiveGetChildById('outfitBox')
    creatureSpecial = window:recursiveGetChildById("special")
end

function destroy()
	if window then
		window:destroy()

		window = nil
		creatureBarHP = nil
		creatureHP = nil
		creatureOutfit = nil
		creatureName = nil
		creatureSpecial = nil
		focusedBoss = 0
		focusedMob = 0
	end
end

-- No opcode logic needed for local bossbar

function showBossBar(creature)
    if not creature then
        hide()
        return
    end
    if not window then
        create()
    end
    if not window then
        return
    end
    focusedMob = creature:getId()
    creatureName:setText(creature:getName())
    creatureHP:setText(creature:getHealthPercent() .. "%")
    creatureSpecial:setPercent(creature:getHealthPercent())
    creatureOutfit:setOutfit(creature:getOutfit())
    window:show()
end

function scanForBoss()
    local mapPanel = modules.game_interface.getMapPanel()
    if not mapPanel then hide() return end
    local spectators = mapPanel:getSpectators()
    for _, creature in ipairs(spectators) do
        local matched = false
        for _, name in ipairs(monstrosIncluidos) do
            if string.find(creature:getName(), name, 1, true) then
                matched = true
                break
            end
        end
        if creature and matched then
            showBossBar(creature)
            return
        end
    end
    hide()
end

function hide()
    focusedMob = 0
    if window then window:hide() end
end

bossBarEnabled = true

function setEnabled(value)
	bossBarEnabled = value
end

function onAppear(creature)
    local matched = false
    for _, name in ipairs(monstrosIncluidos) do
        if string.find(creature:getName(), name, 1, true) then
            matched = true
            break
        end
    end
    if creature and matched then
        showBossBar(creature)
    end
end

function onDisappear(creature)
    if creature and creature:getId() == focusedMob then
        hide()
        scanForBoss()
    end
end

function onHealthPercentChange(creature, health)
	if bossBarEnabled then
		if focusedBoss == creature:getId() or focusedMob == creature:getId() then
			-- creatureBarHP:setPercent(health)
			creatureHP:setText(health .. "%")
			creatureSpecial:setPercent(health)
		end
	else
		hide()
	end
end

function onSpecialPercentChange(creature, special)
	if special > 0 then
		if not creatureSpecial:isVisible() then
			creatureSpecial:setVisible(true)
		end

		creatureSpecial:setPercent(special)
	else
		creatureSpecial:setVisible(false)
	end
end

