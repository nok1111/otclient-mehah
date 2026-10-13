local debugInfoWindow = nil
local debugInfoButton = nil

local updateEvent = nil

function init()
    debugInfoButton = modules.client_topmenu.addTopRightToggleButton('debugInfoButton', tr('Debug Info'),
            '/images/topbuttons/debug', toggle)
    debugInfoButton:setOn(false)

    debugInfoWindow = g_ui.displayUI('debug_info')
    debugInfoWindow:hide()

    Keybind.new("Debug", "Toggle Stats", "Ctrl+Alt+D", "")
    Keybind.bind("Debug", "Toggle Stats", {
      {
        type = KEY_DOWN,
        callback = toggle,
      }
    })

    updateEvent = scheduleEvent(update, 2000)
end

function terminate()
    debugInfoWindow:destroy()
    debugInfoButton:destroy()

    Keybind.delete("Debug", "Toggle Stats")

    removeEvent(updateEvent)
end

function onClose()
    debugInfoButton:setOn(false)
end

function toggle()
    if debugInfoButton:isOn() then
        debugInfoWindow:hide()
        debugInfoButton:setOn(false)
    else
        debugInfoWindow:show()
        debugInfoWindow:raise()
        debugInfoWindow:focus()
        debugInfoButton:setOn(true)
    end
end

local lastMemoryRefresh = 0
local peakMemMb = 0

function update()
    updateEvent = scheduleEvent(update, 20)

    if not debugInfoWindow:isVisible() then
        return
    end

    if g_proxy then
        local text = ""
        local proxiesDebug = g_proxy.getProxiesDebugInfo()
        for proxy_name, proxy_debug in pairs(proxiesDebug) do
            text = text .. proxy_name .. " - " .. proxy_debug .. "\n"
        end
        debugInfoWindow.debugPanel.proxies:setText(text)
    end

    local now = g_clock.millis()
    if now - lastMemoryRefresh >= 500 then
        lastMemoryRefresh = now
        local memMb = 0
        if g_app.getMemoryUsage then
            memMb = g_app.getMemoryUsage() / 1024 / 1024
        end
        peakMemMb = math.max(peakMemMb, memMb)
        local luaMb = collectgarbage("count") / 1024
        local tiles = g_map.getTileCount and g_map.getTileCount() or 0
        local creatures = g_map.getCreatureCount and g_map.getCreatureCount() or 0
        local staticTexts = g_map.getStaticTextCount and g_map.getStaticTextCount() or 0
        local animatedTexts = g_map.getAnimatedTextCount and g_map.getAnimatedTextCount() or 0
        local mmBlocks = g_minimap.getBlockCount and g_minimap.getBlockCount() or 0
        debugInfoWindow.debugPanel.memory:setText(string.format(
            "Process RAM: %.1f MB (peak %.1f MB)\nLua heap: %.1f MB\nMap tiles: %d (~%.1f MB)\nCreatures: %d\nTexts (static/anim): %d / %d\nMinimap blocks: %d (~%.1f MB)",
            memMb, peakMemMb, luaMb, tiles, tiles * 0.0004, creatures, staticTexts, animatedTexts, mmBlocks, mmBlocks * 0.028))
    end
end
