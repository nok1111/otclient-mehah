if not Codex then Codex = {} end

-- Trigger Icons Mapping
Codex.triggerIcons = {
	onHit = "/images/icons/row-1-column-1",
	passive = "/images/icons/row-2-column-8",
	onKill = "/images/icons/skull",
	onDamageTaken = "/images/icons/row-1-column-3",
	onDeath = "/images/icons/row-5-column-3",
	onSpell = "/images/icons/row-4-column-7",
	onLowHP = "/images/icons/row-5-column-7",
	onHeal = "/images/icons/row-5-column-2",
	onCrit = "/images/icons/row-8-column-6",
	onDash = "/images/icons/speed",
	onStandStill = "/images/icons/row-7-column-1",
	onShield = "/images/icons/row-1-column-3",
	onShieldDamage = "/images/icons/row-2-column-6",
	onDefensiveSpell = "/images/icons/prey_defense",
	onAttackSpell = "/images/icons/row-5-column-6",
	onHealingSpell = "/images/icons/row-6-column-1",
}

function Codex.init()
	connect(g_game, { onGameStart = Codex.onGameStart, onGameEnd = Codex.onGameEnd })
	Codex.initNetwork()
	if g_game.isOnline() then
		Codex.onGameStart()
	end
end

function Codex.terminate()
	disconnect(g_game, { onGameStart = Codex.onGameStart, onGameEnd = Codex.onGameEnd })
	Codex.terminateNetwork()
	Codex.onGameEnd()
end

function Codex.onGameStart()
	Codex.UI = g_ui.displayUI("codex")
	if not Codex.UI then
		print("[Codex] ERROR: Failed to load codex.otui")
		return
	end
	
	Codex.UI:hide()
	
	print("[Codex MVC] UI loaded successfully")

	if not Codex.Button then
		Codex.Button = modules.game_mainpanel.addStoreButton("Codex", tr("Codex"), '/images/options/large_stats', Codex.toggle, false, 5)
		Codex.Button:setOn(false)
	end

	Codex.Tooltip = g_ui.displayUI("CardTooltip")
	Codex.Tooltip:hide()

	-- Initialize MVC
	Codex.setupDialogButtons()
	Codex.setupTabButtons()
	Codex.initializeFilters()
	
	-- Request Data
	Codex.sendOpcode({ topic = "base-data-request" })
end

function Codex.onGameEnd()
	if Codex.Tooltip then
		Codex.Tooltip:destroy()
		Codex.Tooltip = nil
	end

	if Codex.Button then
		Codex.Button:destroy()
		Codex.Button = nil
	end

	if Codex.UI then
		Codex.UI:destroy()
		Codex.UI = nil
	end
end
