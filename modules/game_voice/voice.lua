local VOICE_OPCODE = 175
local voiceWindow = nil
local roomListWindow = nil
local currentRoom = nil
local availableRooms = {}
local playerPositions = {} -- Track positions of other players in world channel
local connectedPlayers = {} -- Track players connected to voice relay
local playerSettings = {} -- cid -> { volume, muted }
local lastDistanceVolume = {} -- cid -> last calculated distance-based volume

-- Voice icon overlays (widgets attached to creatures)
local voiceOverlays = {} -- cid -> { widget = UIWidget, type = "active"/"muted" }

-- Position update throttle
local lastPositionUpdate = 0
local POSITION_UPDATE_INTERVAL = 200 -- ms between position updates
local lastSentPosition = nil

-- Speaking indicator update timer
local speakingUpdateTimer = nil

function enableVoiceTest()
    if Voice.isConnected() then
        print("Enabling voice test mode...")
        local success = Voice.enableTest()
        if success then
            print("Test mode enabled! Speak into your microphone.")
            print("You should hear your voice played back after 2 seconds.")
        else
            print("ERROR: Failed to enable test mode!")
            print("Make sure you have joined a voice room first.")
        end
    else
        print("ERROR: Not connected to voice. Join a room first!")
    end
end

-- Disable test mode
function disableVoiceTest()
    if Voice.isTestMode() then
        print("Disabling voice test mode...")
        Voice.disableTest()
        print("Test mode disabled.")
    else
        print("Voice test mode is not currently active.")
    end
end

-- Check if test mode is active
function checkTestMode()
    if Voice.isTestMode() then
        print("========================================")
        print("WARNING: Voice test mode is ACTIVE!")
        print("This WILL cause echo!")
        print("Type: disableVoiceTest() to turn it off")
        print("========================================")
        return true
    else
        print("Voice test mode is INACTIVE (good)")
        return false
    end
end

-- Auto-check on init to warn users
local function autoCheckEcho()
    if Voice.isTestMode() then
        g_logger.warning("================================================")
        g_logger.warning("VOICE TEST MODE IS ENABLED - THIS CAUSES ECHO!")
        g_logger.warning("Type 'disableVoiceTest()' in console to disable")
        g_logger.warning("================================================")
    end
end

-- Example: Enable test mode and disable it after 10 seconds
function quickVoiceTest()
    if not Voice.isConnected() then
        print("ERROR: Not connected to voice. Join a room first!")
        return
    end

    print("Starting 10-second voice test...")
    Voice.enableTest()

    -- Schedule disable after 10 seconds
    scheduleEvent(function()
        Voice.disableTest()
        print("Voice test completed!")
    end, 10000)
end

-- Manual test: Call processAudio in a loop
function testAudioCapture()
    if not Voice.isConnected() then
        print("ERROR: Not connected to voice. Join a room first!")
        return
    end

    print("Testing audio capture... calling processAudio() 100 times")
    for i = 1, 100 do
        Voice.processAudio()
    end
    print("Done! Check console for audio capture stats.")
end


local voiceState = {
    connected = false,
    muted = false,
    room = nil,
    channelType = nil,
    myPosition = nil,
    pushToTalk = false,
    vadEnabled = false,
    lastHost = "127.0.0.1",
    lastPort = 7331
}

-- Helper function to calculate distance between two positions
local function calculateDistance(pos1, pos2)
    if not pos1 or not pos2 then
        return math.huge
    end

    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    local dz = pos1.z - pos2.z

    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

-- Helper function to calculate volume multiplier based on distance
local function calculateVolumeMultiplier(distance)
    local MAX_DISTANCE = 20 -- 20 SQM max range
    local VOLUME_DECREASE = 0.05 -- 5% decrease per SQM
    local DECREASE_INTERVAL = 1 -- Every 1 SQM

    if distance > MAX_DISTANCE then
        return 0.0 -- Too far, no audio
    end

    local intervals = math.floor(distance / DECREASE_INTERVAL)
    local volumeMultiplier = 1.0 - (intervals * VOLUME_DECREASE)

    return math.max(0.0, volumeMultiplier)
end

function hashRoomPassword(password)
    if not password or password:len() == 0 then
        return "public"
    end
    local hash = 5381
    for i = 1, password:len() do
        local b = string.byte(password, i)
        hash = ((hash * 33) + b) % 4294967296
    end
    return tostring(hash)
end

function applyPlayerVolume(cid)
    local settings = playerSettings[cid] or { volume = 1.0, muted = false }
    local distVol = lastDistanceVolume[cid] or 1.0
    if settings.muted then
        Voice.setPlayerVolume(cid, 0)
    else
        Voice.setPlayerVolume(cid, (settings.volume or 1.0) * distVol)
    end
end

function setDistanceVolume(cid, volume)
    lastDistanceVolume[cid] = volume
    applyPlayerVolume(cid)
end

function togglePlayerMute(cid)
    if not playerSettings[cid] then
        playerSettings[cid] = { volume = 1.0, muted = false }
    end
    playerSettings[cid].muted = not playerSettings[cid].muted
    applyPlayerVolume(cid)
    updatePlayersList()
    updateWhitelistPanel()
    updateSpeakingIndicators()
end

function onPlayerVolumeChange(cid, value)
    if not playerSettings[cid] then
        playerSettings[cid] = { volume = 1.0, muted = false }
    end
    playerSettings[cid].volume = value / 100
    applyPlayerVolume(cid)
end

function setPlayerMuted(cid, muted, name)
    if not playerSettings[cid] then
        playerSettings[cid] = { volume = 1.0, muted = false }
    end
    playerSettings[cid].muted = muted
    if name then
        playerSettings[cid].name = name
    end
    applyPlayerVolume(cid)
    updatePlayersList()
    updateWhitelistPanel()
    updateSpeakingIndicators()
end

function isPlayerMuted(cid)
    local settings = playerSettings[cid]
    return settings and settings.muted or false
end

function setPlayerVolume(cid, volume)
    if not playerSettings[cid] then
        playerSettings[cid] = { volume = 1.0, muted = false }
    end
    playerSettings[cid].volume = volume
    applyPlayerVolume(cid)
end

function getPlayerVolume(cid)
    local settings = playerSettings[cid]
    return settings and settings.volume or 1.0
end


local audioProcessTimer = nil

function init()
    Voice.init()
    g_logger.info("Voice system initialized")

    g_keyboard.bindKeyDown('F6', function() showVoiceWindow() end)

    -- Push-to-talk key: hold V to talk
    g_keyboard.bindKeyDown('V', function()
        if voiceState.pushToTalk and voiceState.connected then
            Voice.setPTTActive(true)
        end
    end)
    g_keyboard.bindKeyUp('V', function()
        if voiceState.pushToTalk and voiceState.connected then
            Voice.setPTTActive(false)
        end
    end)

    if g_game then
        ProtocolGame.registerExtendedOpcode(VOICE_OPCODE, onExtendedOpcode)
    end

    connect(g_game, {onGameUpdate = onGameUpdate, onGameEnd = onGameEnd})

    -- Register right-click context menu hooks for muting/unmuting players
    if modules.game_interface and modules.game_interface.addMenuHook then
        modules.game_interface.addMenuHook('voice', 'Mute Voice', function(menuPosition, lookThing, useThing, creatureThing)
            if creatureThing then
                modules.game_voice.setPlayerMuted(creatureThing:getId(), true, creatureThing:getName())
            end
        end, function(menuPosition, lookThing, useThing, creatureThing)
            if not creatureThing or not creatureThing:isPlayer() then return false end
            local localPlayer = g_game.getLocalPlayer()
            if not localPlayer then return false end
            return creatureThing:getId() ~= localPlayer:getId() and not modules.game_voice.isPlayerMuted(creatureThing:getId())
        end)

        modules.game_interface.addMenuHook('voice', 'Unmute Voice', function(menuPosition, lookThing, useThing, creatureThing)
            if creatureThing then
                modules.game_voice.setPlayerMuted(creatureThing:getId(), false, creatureThing:getName())
            end
        end, function(menuPosition, lookThing, useThing, creatureThing)
            if not creatureThing or not creatureThing:isPlayer() then return false end
            return modules.game_voice.isPlayerMuted(creatureThing:getId())
        end)
    end

    -- CRITICAL: Start a timer to process audio every 20ms (50 FPS)
    -- This ensures audio processing even when onGameUpdate doesn't fire
    audioProcessTimer = cycleEvent(function()
        onGameUpdate()
    end, 20)

    -- Voice indicators update timer (every 200ms)
    speakingUpdateTimer = cycleEvent(function()
        updateSpeakingIndicators()
        updatePlayersList()
        updateVUMeter()
    end, 200)

    -- Check for test mode echo warning
    scheduleEvent(autoCheckEcho, 2000)

    g_logger.info("Audio processing timer started (20ms interval)")
end

function terminate()
    g_logger.info("Terminating voice system...")

    -- Stop audio processing timer
    if audioProcessTimer then
        removeEvent(audioProcessTimer)
        audioProcessTimer = nil
        g_logger.info("Audio processing timer stopped")
    end

    if speakingUpdateTimer then
        removeEvent(speakingUpdateTimer)
        speakingUpdateTimer = nil
    end

    -- Leave voice room if connected
    if voiceState.connected then
        Voice.leave()
    end

    -- Clean up voice overlay widgets
    for cid, entry in pairs(voiceOverlays) do
        entry.widget:destroy()
    end
    voiceOverlays = {}

    -- Clean up windows
    if voiceWindow then
        voiceWindow:destroy()
        voiceWindow = nil
    end

    if roomListWindow then
        roomListWindow:destroy()
        roomListWindow = nil
    end

    -- Clean up voice system
    Voice.cleanup()

    -- Unbind keys and disconnect events
    g_keyboard.unbindKeyDown('F6')
    g_keyboard.unbindKeyDown('V')
    g_keyboard.unbindKeyUp('V')

    if g_game then
        ProtocolGame.unregisterExtendedOpcode(VOICE_OPCODE)
    end

    disconnect(g_game, {onGameUpdate = onGameUpdate, onGameEnd = onGameEnd})

    -- Remove context menu hooks
    if modules.game_interface and modules.game_interface.removeMenuHook then
        modules.game_interface.removeMenuHook('voice', 'Mute Voice')
        modules.game_interface.removeMenuHook('voice', 'Unmute Voice')
    end

    -- Reset state
    voiceState.connected = false
    voiceState.room = nil
    voiceState.channelType = nil
    voiceState.myPosition = nil
    voiceState.pushToTalk = false
    currentRoom = nil
    playerPositions = {}
    connectedPlayers = {}
    voiceOverlays = {}

    g_logger.info("Voice system terminated")
end

function onGameEnd()
    -- Disconnect from voice relay when the game session ends
    if voiceState.connected then
        leaveVoiceRoom()
    end

    -- Destroy all overlay widgets
    for cid, entry in pairs(voiceOverlays) do
        entry.widget:destroy()
    end
    voiceOverlays = {}

    -- Close voice window if open
    if voiceWindow then
        voiceWindow:hide()
    end

    g_logger.info("Voice system: game ended, disconnected from voice")
end

function onExtendedOpcode(protocol, opcode, buffer)
    if opcode == VOICE_OPCODE then
        local data = json.decode(buffer)

        -- Handle voice room join response
        if data.relay_host and data.relay_port and data.room and data.token then
            local player = g_game.getLocalPlayer()
            if player then
                local success = Voice.join(data.relay_host, data.relay_port, data.room, data.token, player:getId())
                if success then
                    voiceState.connected = true
                    voiceState.room = data.room
                    voiceState.channelType = data.channelType or "unknown"
                    currentRoom = data.room

                    -- Store position for world channel
                    if data.position then
                        voiceState.myPosition = data.position
                    end

                    -- Store nearby player positions for world channel
                    if data.nearbyPlayers then
                        playerPositions = {}
                        for _, p in ipairs(data.nearbyPlayers) do
                            playerPositions[p.cid] = {x = p.x, y = p.y, z = p.z}
                            -- Set initial volume based on distance
                            if voiceState.myPosition then
                                local distance = calculateDistance(voiceState.myPosition, {x = p.x, y = p.y, z = p.z})
                                local volume = calculateVolumeMultiplier(distance)
                                setDistanceVolume(p.cid, volume)
                                g_logger.info("Set initial volume for CID " .. p.cid .. ": " .. volume .. " (distance: " .. distance .. ")")
                            end
                        end
                        g_logger.info("Loaded " .. #data.nearbyPlayers .. " nearby player positions with volumes")
                    end

                    g_logger.info("Joined voice room: " .. data.room .. " (type: " .. voiceState.channelType .. ")")
                    updateVoiceWindow()
                else
                    g_logger.error("Failed to join voice room")
                end
            end
        -- Handle position updates (for world channel)
        elseif data.action == "positionUpdate" then
            if data.cid and data.position then
                playerPositions[data.cid] = data.position
                -- Update volume for this player if needed
                if voiceState.channelType == "world" and voiceState.myPosition then
                    local distance = calculateDistance(voiceState.myPosition, data.position)
                    local volume = calculateVolumeMultiplier(distance)
                    -- Apply volume to the specific player's audio stream
                    setDistanceVolume(data.cid, volume)
                    g_logger.debug("Player " .. data.cid .. " moved to distance: " .. distance .. " (volume: " .. volume .. ")")
                end
            end
        -- Handle channel list response
        elseif data.action == "channelList" and data.channels then
            availableRooms = data.channels
            updateRoomList()
        -- Handle errors
        elseif data.error then
            g_logger.error("Voice error: " .. data.error)
            showVoiceError(data.error)
        end
    end
end

function onGameUpdate()
    Voice.processAudio()

    -- Update position if in world channel (throttled to 200ms)
    if voiceState.connected and voiceState.channelType == "world" then
        local player = g_game.getLocalPlayer()
        if player then
            local pos = player:getPosition()
            local now = g_clock.millis()

            -- Check if floor changed - need to rejoin different room
            if voiceState.myPosition and pos.z ~= voiceState.myPosition.z then
                g_logger.info("Floor changed from " .. voiceState.myPosition.z .. " to " .. pos.z .. " - rejoining world channel")
                voiceState.myPosition = {x = pos.x, y = pos.y, z = pos.z}
                -- Leave and rejoin to get into correct floor room
                leaveVoiceRoom()
                scheduleEvent(function()
                    joinPublicVoiceRoom()
                end, 500)
                return
            end

            -- Throttle position updates: only send every 200ms or when moved >1 SQM
            if not lastSentPosition or
               pos.x ~= lastSentPosition.x or
               pos.y ~= lastSentPosition.y or
               pos.z ~= lastSentPosition.z then

                if now - lastPositionUpdate >= POSITION_UPDATE_INTERVAL then
                    voiceState.myPosition = {x = pos.x, y = pos.y, z = pos.z}
                    lastSentPosition = {x = pos.x, y = pos.y, z = pos.z}
                    lastPositionUpdate = now

                    -- Send position update to server
                    local data = {
                        action = "positionUpdate"
                    }
                    g_game.getProtocolGame():sendExtendedOpcode(VOICE_OPCODE, json.encode(data))

                    -- Update volumes for all nearby players based on new position
                    for cid, position in pairs(playerPositions) do
                        local distance = calculateDistance(voiceState.myPosition, position)
                        local volume = calculateVolumeMultiplier(distance)
                        setDistanceVolume(cid, volume)
                    end
                end
            end
        end
    end
end

local function getDesiredVoiceOverlay(cid, localCid, relayMuted, relayConnected)
    if cid == localCid then
        if voiceState.muted then return "muted" end
        if voiceState.connected then return "active" end
        return nil
    end

    if not relayConnected[cid] then return nil end

    if relayMuted[cid] or (playerSettings[cid] and playerSettings[cid].muted) then
        return "muted"
    end

    return "active"
end

-- Update voice overlay widgets on all players
function updateSpeakingIndicators()
    if not voiceState.connected then
        for cid, entry in pairs(voiceOverlays) do
            entry.widget:destroy()
        end
        voiceOverlays = {}
        return
    end

    local localPlayer = g_game.getLocalPlayer()
    local localCid = localPlayer and localPlayer:getId() or 0

    -- Build sets from relay data
    local relayMuted = {}
    if Voice.getMutedPlayers then
        local mutedPlayers = Voice.getMutedPlayers()
        for i = 1, #mutedPlayers do
            relayMuted[mutedPlayers[i]] = true
        end
    end

    local relayConnected = {}
    if Voice.getConnectedPlayers then
        local connected = Voice.getConnectedPlayers()
        for i = 1, #connected do
            relayConnected[connected[i]] = true
        end
    end

    -- Determine desired state for local player
    local desiredStates = {}
    desiredStates[localCid] = getDesiredVoiceOverlay(localCid, localCid, relayMuted, relayConnected)

    -- Determine desired state for other connected players
    for cid, _ in pairs(relayConnected) do
        if cid ~= localCid then
            local creature = g_map.getCreatureById(cid)
            if creature and not creature:isRemoved() and not creature:isDead() and creature:canBeSeen() then
                desiredStates[cid] = getDesiredVoiceOverlay(cid, localCid, relayMuted, relayConnected)
            end
        end
    end

    -- Update or create overlays
    for cid, desired in pairs(desiredStates) do
        local creature = (cid == localCid) and localPlayer or g_map.getCreatureById(cid)
        if not creature then
            if voiceOverlays[cid] then
                voiceOverlays[cid].widget:destroy()
                voiceOverlays[cid] = nil
            end
        else
            local current = voiceOverlays[cid]
            local currentType = current and current.type or nil

            if currentType ~= desired then
                -- Destroy old widget if exists
                if current then
                    current.widget:destroy()
                    voiceOverlays[cid] = nil
                end

                -- Create new widget
                if desired then
                    local widgetStyle = desired == "muted" and 'MutedVoiceIndicator' or 'SpeakingIndicator'
                    local widget = g_ui.createWidget(widgetStyle)
                    widget:setId('voiceOverlay_' .. cid)

                    -- Attach as child of creature info widget, anchored right of lifeBar
                    local infoWidget = creature:getWidgetInformation()
                    if infoWidget and infoWidget.lifeBar then
                        widget:addAnchor(AnchorLeft, 'lifeBar', AnchorRight)
                        widget:addAnchor(AnchorTop, 'lifeBar', AnchorTop)
                        widget:setMarginLeft(8)
                        widget:setMarginTop(-15)
                        infoWidget:addChild(widget)
                    else
                        -- Fallback: attach directly to creature
                        widget:setMarginBottom(37)
                        widget:setMarginLeft(28)
                        creature:attachWidget(widget)
                    end
                    voiceOverlays[cid] = { widget = widget, type = desired }
                end
            end
        end
    end

    -- Clean up overlays for players no longer connected, visible, or whose creature was destroyed/hidden
    for cid, entry in pairs(voiceOverlays) do
        local shouldRemove = false
        if not desiredStates[cid] then
            shouldRemove = true
        else
            local creature = (cid == localCid) and localPlayer or g_map.getCreatureById(cid)
            if not creature or creature:isRemoved() or creature:isDead() or not creature:canBeSeen() then
                shouldRemove = true
            end
        end
        if shouldRemove then
            entry.widget:destroy()
            voiceOverlays[cid] = nil
        end
    end
end

-- Update microphone VU meter based on captured input level
function updateVUMeter()
    if not voiceWindow then return end

    local fill = voiceWindow:recursiveGetChildById('vuMeterFill')
    local bg = voiceWindow:recursiveGetChildById('vuMeterBg')
    if not fill or not bg then return end

    local level = 0
    if Voice.getMicLevel then
        level = Voice.getMicLevel()
    end
    local maxRms = 5000.0
    local percent = math.min(1.0, level / maxRms)

    local bgWidth = bg:getWidth()
    fill:setWidth(math.floor(percent * bgWidth))

    if percent < 0.3 then
        fill:setColor('#00FF00')
    elseif percent < 0.7 then
        fill:setColor('#FFFF00')
    else
        fill:setColor('#FF0000')
    end
end

-- Update the connected players list in the UI
function updatePlayersList()
    if not voiceWindow then return end

    local playersList = voiceWindow:recursiveGetChildById('playersList')
    if not playersList then return end

    -- Get connected players from C++
    local players = Voice.getConnectedPlayers()
    local speakingPlayers = Voice.getSpeakingPlayers()
    local speakingSet = {}
    for i = 1, #speakingPlayers do
        speakingSet[speakingPlayers[i]] = true
    end

    -- Clear current list
    playersList:destroyChildren()

    -- Add local player first
    local player = g_game.getLocalPlayer()
    if player and voiceState.connected then
        local row = g_ui.createWidget('PlayerListRow', playersList)
        row:setId('playerRow_self')
        local nameLabel = row:recursiveGetChildById('playerNameLabel')
        if nameLabel then
            nameLabel:setText(player:getName() .. " (You)" .. (speakingSet[player:getId()] and " [Speaking]" or ""))
            nameLabel:setColor(speakingSet[player:getId()] and '#00FF00' or '#FFFFFF')
        end
        local slider = row:recursiveGetChildById('playerVolumeSlider')
        if slider then slider:hide() end
        local muteBtn = row:recursiveGetChildById('playerMuteButton')
        if muteBtn then muteBtn:hide() end
    end

    -- Add other connected players with volume and mute controls
    for i = 1, #players do
        local cid = players[i]
        if cid ~= player:getId() then
            local creature = g_map.getCreatureById(cid)
            local name = creature and creature:getName() or ("Player " .. cid)
            local settings = playerSettings[cid] or { volume = 1.0, muted = false }
            local row = g_ui.createWidget('PlayerListRow', playersList)
            row:setId('playerRow_' .. cid)

            local nameLabel = row:recursiveGetChildById('playerNameLabel')
            if nameLabel then
                nameLabel:setText(name .. (speakingSet[cid] and " [Speaking]" or "") .. (settings.muted and " [Muted]" or ""))
                nameLabel:setColor(speakingSet[cid] and '#00FF00' or (settings.muted and '#FF0000' or '#CCCCCC'))
            end

            local slider = row:recursiveGetChildById('playerVolumeSlider')
            if slider then
                slider:setValue(math.floor((settings.volume or 1.0) * 100))
                slider.onValueChange = function(self)
                    onPlayerVolumeChange(cid, self:getValue())
                end
            end

            local muteBtn = row:recursiveGetChildById('playerMuteButton')
            if muteBtn then
                muteBtn:setText(settings.muted and 'Unmute' or 'Mute')
                muteBtn:setColor(settings.muted and '#FF0000' or '#FFFFFF')
                muteBtn.onClick = function()
                    togglePlayerMute(cid)
                end
            end
        end
    end
end

function showVoiceWindow()
    if not voiceWindow then
        voiceWindow = g_ui.displayUI('voice')
        if not voiceWindow then
            g_logger.error("Failed to load voice window UI")
            return
        end
        selectVoiceTab('voice')

        -- Wire up the main mute button once
        local muteButton = voiceWindow:recursiveGetChildById('muteButton')
        if muteButton and not muteButton.voiceMuteWired then
            muteButton.onClick = function()
                modules.game_voice.toggleVoiceMute()
            end
            muteButton.voiceMuteWired = true
        end
    end

    voiceWindow:show()
    voiceWindow:raise()
    voiceWindow:focus()
    updateVoiceWindow()
end

function hideVoiceWindow()
    if voiceWindow then
        voiceWindow:hide()
    end
end

function selectVoiceTab(tabName)
    if not voiceWindow then return end

    local tabs = {
        { name = 'voice',  panelId = 'voiceTab' },
        { name = 'lobbies', panelId = 'lobbiesTab' },
        { name = 'whitelist', panelId = 'whitelistTab' },
        { name = 'settings', panelId = 'settingsTab' }
    }

    for _, tab in ipairs(tabs) do
        local panel = voiceWindow:recursiveGetChildById(tab.panelId)
        local button = voiceWindow:recursiveGetChildById(tab.name .. 'TabButton')
        if panel then
            panel:setVisible(tab.name == tabName)
        end
        if button then
            if tab.name == tabName then
                button:setColor('#00FF00')
            else
                button:setColor('#FFFFFF')
            end
        end
    end

    if tabName == 'whitelist' then
        updateWhitelistPanel()
    end

    if tabName == 'lobbies' then
        refreshLobbyList()
    end
end

function updateWhitelistPanel()
    if not voiceWindow then return end

    local list = voiceWindow:recursiveGetChildById('whitelistList')
    if not list then return end

    list:destroyChildren()

    local emptyLabel = voiceWindow:recursiveGetChildById('whitelistEmptyLabel')
    local hasMuted = false

    for cid, settings in pairs(playerSettings) do
        if settings.muted then
            hasMuted = true
            local row = g_ui.createWidget('PlayerListRow', list)
            row:setId('whitelistRow_' .. cid)

            local nameLabel = row:recursiveGetChildById('playerNameLabel')
            if nameLabel then
                local name = settings.name or ('Player ' .. cid)
                nameLabel:setText(name .. ' [Muted]')
                nameLabel:setColor('#FF0000')
            end

            local slider = row:recursiveGetChildById('playerVolumeSlider')
            if slider then slider:hide() end

            local muteBtn = row:recursiveGetChildById('playerMuteButton')
            if muteBtn then
                muteBtn:setText('Unmute')
                muteBtn:show()
                muteBtn.onClick = function()
                    setPlayerMuted(cid, false)
                end
            end
        end
    end

    if emptyLabel then
        emptyLabel:setVisible(not hasMuted)
    end
end

function updateVoiceWindow()
    if not voiceWindow then return end

    local state = voiceState
    local statusLabel = voiceWindow:recursiveGetChildById('statusLabel')
    local roomLabel = voiceWindow:recursiveGetChildById('roomLabel')
    local muteButton = voiceWindow:recursiveGetChildById('muteButton')
    local leaveButton = voiceWindow:recursiveGetChildById('leaveButton')
    local pttButton = voiceWindow:recursiveGetChildById('pttButton')
    local vadButton = voiceWindow:recursiveGetChildById('vadButton')
    local reconnectButton = voiceWindow:recursiveGetChildById('reconnectButton')
    local micPanel = voiceWindow:recursiveGetChildById('micPanel')
    local masterVolumeSlider = voiceWindow:recursiveGetChildById('masterVolumeSlider')
    local volumeValueLabel = voiceWindow:recursiveGetChildById('volumeValueLabel')
    local partyButton = voiceWindow:recursiveGetChildById('partyChannelButton')
    local guildButton = voiceWindow:recursiveGetChildById('guildChannelButton')

    -- Channel display names
    local channelDisplay = {
        world = "World (Proximity)",
        party = "Party",
        guild = "Guild",
        private = "Private"
    }

    if state.connected then
        local chanName = channelDisplay[state.channelType] or state.channelType or "Unknown"
        statusLabel:setText('Status: Connected')
        statusLabel:setColor('#00FF00')
        roomLabel:setText('Channel: ' .. chanName)
        roomLabel:setColor('#FFFFFF')
        muteButton:setEnabled(true)
        leaveButton:setEnabled(true)
        if pttButton then pttButton:setEnabled(true) end
        if vadButton then vadButton:setEnabled(true) end
        if reconnectButton then reconnectButton:setEnabled(true) end
        if micPanel then micPanel:setVisible(true) end
    else
        statusLabel:setText('Status: Disconnected')
        statusLabel:setColor('#FF0000')
        roomLabel:setText('Channel: None')
        roomLabel:setColor('#888888')
        muteButton:setEnabled(false)
        leaveButton:setEnabled(false)
        if pttButton then pttButton:setEnabled(false) end
        if vadButton then vadButton:setEnabled(false) end
        if reconnectButton then reconnectButton:setEnabled(false) end
        if micPanel then micPanel:setVisible(false) end
    end

    -- Enable/disable party button based on party membership
    local player = g_game.getLocalPlayer()
    if player and partyButton then
        local shield = player:getShield()
        local inParty = shield and shield > 0 and shield < 11
        if inParty then
            partyButton:setEnabled(true)
            partyButton:setColor('#FFFFFF')
        else
            partyButton:setEnabled(false)
            partyButton:setColor('#666666')
        end
    end

    -- Enable/disable guild button based on guild membership
    if player and guildButton then
        local emblem = player:getEmblem()
        local inGuild = emblem and emblem > 0
        if inGuild then
            guildButton:setEnabled(true)
            guildButton:setColor('#FFFFFF')
        else
            guildButton:setEnabled(false)
            guildButton:setColor('#666666')
        end
    end

    if state.muted then
        muteButton:setText('Unmute')
        muteButton:setColor('#FF0000')
    else
        muteButton:setText('Mute')
        muteButton:setColor('#FFFFFF')
    end

    if pttButton then
        if state.pushToTalk then
            pttButton:setText('PTT: On')
            pttButton:setColor('#00FF00')
        else
            pttButton:setText('PTT: Off')
            pttButton:setColor('#FFFFFF')
        end
    end

    if vadButton then
        if state.vadEnabled then
            vadButton:setText('VAD: On')
            vadButton:setColor('#00FF00')
        else
            vadButton:setText('VAD: Off')
            vadButton:setColor('#FFFFFF')
        end
    end

    -- Set master volume slider and label
    if masterVolumeSlider then
        local vol = Voice.getMasterVolume()
        local volPercent = math.floor(vol * 100)
        masterVolumeSlider:setValue(volPercent)
        if volumeValueLabel then
            volumeValueLabel:setText(tostring(volPercent) .. '%')
        end
    end
end

function showVoiceError(message)
    if not voiceWindow then return end

    local infoLabel = voiceWindow:recursiveGetChildById('infoLabel')
    if infoLabel then
        infoLabel:setText('Error: ' .. message)
        infoLabel:setColor('#FF0000')
    end
end

function createVoiceRoom(roomName)
    local data = {
        action = "create",
        room = roomName
    }
    g_game.getProtocolGame():sendExtendedOpcode(VOICE_OPCODE, json.encode(data))
end

function joinPublicVoiceRoom()
    -- World proximity: connect directly to relay with floor-based room
    -- No need to ask TFS for room/token - just connect
    local player = g_game.getLocalPlayer()
    if not player then
        g_logger.error("No local player found")
        return
    end

    local pos = player:getPosition()
    local room = "world_" .. tostring(pos.z)
    local cid = player:getId()
    local token = tostring(cid) .. "-" .. room .. "-proximity"

    local RELAY_HOST = "127.0.0.1"
    local RELAY_PORT = 7331

    local success = Voice.join(RELAY_HOST, RELAY_PORT, room, token, cid)
    if success then
        voiceState.connected = true
        voiceState.room = room
        voiceState.channelType = "world"
        voiceState.myPosition = {x = pos.x, y = pos.y, z = pos.z}
        currentRoom = room
        g_logger.info("Joined world proximity voice (floor " .. pos.z .. ")")
        updateVoiceWindow()
    else
        g_logger.error("Failed to join world voice room")
    end
end

function joinPartyVoiceRoom()
    -- Party channel: connect directly to relay
    local player = g_game.getLocalPlayer()
    if not player then return end

    -- getParty() is not exposed to Lua; use shield emblem as party membership check
    local shield = player:getShield()
    if not shield or shield == 0 or shield == 11 then
        g_logger.error("You are not in a party")
        showVoiceError("You are not in a party")
        return
    end

    -- NOTE: real party separation needs server-side room assignment.
    -- Using a single shared room as a placeholder so party voice can be tested.
    local room = "party_channel"
    local cid = player:getId()
    local token = tostring(cid) .. "-" .. room .. "-party"

    local success = Voice.join("127.0.0.1", 7331, room, token, cid)
    if success then
        voiceState.connected = true
        voiceState.room = room
        voiceState.channelType = "party"
        currentRoom = room
        g_logger.info("Joined party voice room: " .. room)
        updateVoiceWindow()
    else
        g_logger.error("Failed to join party voice room")
    end
end

function joinGuildVoiceRoom()
    -- Guild channel: connect directly to relay
    local player = g_game.getLocalPlayer()
    if not player then return end

    -- getGuild() is not exposed to Lua; use emblem as guild membership check
    local emblem = player:getEmblem()
    if not emblem or emblem == 0 then
        g_logger.error("You are not in a guild")
        showVoiceError("You are not in a guild")
        return
    end

    -- NOTE: real guild separation needs server-side room assignment.
    -- Using a single shared room as a placeholder so guild voice can be tested.
    local room = "guild_channel"
    local cid = player:getId()
    local token = tostring(cid) .. "-" .. room .. "-guild"

    local success = Voice.join("127.0.0.1", 7331, room, token, cid)
    if success then
        voiceState.connected = true
        voiceState.room = room
        voiceState.channelType = "guild"
        currentRoom = room
        g_logger.info("Joined guild voice room: " .. room)
        updateVoiceWindow()
    else
        g_logger.error("Failed to join guild voice room")
    end
end

function joinVoiceRoom(room)
    if not voiceState.connected then
        local data = {
            action = "join",
            room = room
        }
        g_game.getProtocolGame():sendExtendedOpcode(VOICE_OPCODE, json.encode(data))
    end
end

function leaveVoiceRoom()
    if voiceState.connected then
        g_logger.info("Leaving voice room...")

        -- Send leave request to server first
        local data = {
            action = "leave"
        }
        g_game.getProtocolGame():sendExtendedOpcode(VOICE_OPCODE, json.encode(data))

        -- Then leave the voice connection
        Voice.leave()

        -- Update local state
        voiceState.connected = false
        voiceState.room = nil
        voiceState.channelType = nil
        voiceState.myPosition = nil
        currentRoom = nil
        playerPositions = {}
        connectedPlayers = {}
        lastSentPosition = nil

        -- Clean up voice overlay widgets
        for cid, entry in pairs(voiceOverlays) do
            entry.widget:destroy()
        end
        voiceOverlays = {}

        -- Update UI
        updateVoiceWindow()

        g_logger.info("Left voice room successfully")
    end
end

function toggleVoiceMute()
    if voiceState.connected then
        voiceState.muted = not voiceState.muted
        Voice.mute(voiceState.muted)
        updateVoiceWindow()
        updateSpeakingIndicators()
    end
end

function togglePushToTalk()
    voiceState.pushToTalk = not voiceState.pushToTalk
    Voice.setPushToTalk(voiceState.pushToTalk)
    if voiceState.pushToTalk then
        Voice.setPTTActive(false)
        g_logger.info("Push-to-talk enabled - hold V to talk")
    else
        Voice.setPTTActive(true) -- When PTT is off, always active
        g_logger.info("Push-to-talk disabled - always on")
    end
    updateVoiceWindow()
end

function toggleVAD()
    voiceState.vadEnabled = not voiceState.vadEnabled
    Voice.setVAD(voiceState.vadEnabled, 500.0)
    g_logger.info("VAD " .. (voiceState.vadEnabled and "enabled" or "disabled"))
    updateVoiceWindow()
end

function reconnectRoom()
    if not voiceState.connected or not voiceState.room then
        showVoiceError("Not connected to any room")
        return
    end

    local room = voiceState.room
    local host = voiceState.lastHost
    local port = voiceState.lastPort

    leaveVoiceRoom()
    scheduleEvent(function()
        local player = g_game.getLocalPlayer()
        if not player then return end

        local cid = player:getId()
        local token = tostring(cid) .. "-" .. room .. "-reconnect"

        local success = Voice.join(host, port, room, token, cid)
        if success then
            voiceState.connected = true
            voiceState.room = room
            g_logger.info("Reconnected to voice room: " .. room)
            showVoiceError("Reconnected to " .. room)
            updateVoiceWindow()
        else
            g_logger.error("Failed to reconnect to voice room")
            showVoiceError("Failed to reconnect")
        end
    end, 500)
end

function setMasterVolume(volume)
    Voice.setMasterVolume(volume)
    if voiceWindow then
        local volumeValueLabel = voiceWindow:recursiveGetChildById('volumeValueLabel')
        if volumeValueLabel then
            volumeValueLabel:setText(tostring(math.floor(volume * 100)) .. '%')
        end
    end
end

function getVoiceState()
    return voiceState
end

function getCurrentRoom()
    return currentRoom
end

function createRoom()
    if not voiceWindow then return end

    local roomNameEdit = voiceWindow:recursiveGetChildById('roomNameEdit')
    local roomName = roomNameEdit:getText()

    if roomName and roomName:len() > 0 then
        createVoiceRoom(roomName)
        roomNameEdit:setText('')
        local infoLabel = voiceWindow:recursiveGetChildById('infoLabel')
        infoLabel:setText('Creating room: ' .. roomName)
        infoLabel:setColor('#FFFF00')
    else
        showVoiceError('Please enter a room name')
    end
end

function joinRoom()
    if not voiceWindow then return end

    local roomNameEdit = voiceWindow:recursiveGetChildById('roomNameEdit')
    local roomName = roomNameEdit:getText()

    if roomName and roomName:len() > 0 then
        joinVoiceRoom(roomName)
        roomNameEdit:setText('')
        local infoLabel = voiceWindow:recursiveGetChildById('infoLabel')
        infoLabel:setText('Joining room: ' .. roomName)
        infoLabel:setColor('#FFFF00')
    else
        showVoiceError('Please enter a room name')
    end
end

function joinPublicRoom()
    joinPublicVoiceRoom()
    if voiceWindow then
        local infoLabel = voiceWindow:recursiveGetChildById('infoLabel')
        if infoLabel then
            infoLabel:setText('Joining public room with nearby players')
            infoLabel:setColor('#FFFF00')
        end
    end
end

function toggleMute()
    toggleVoiceMute()
end

function leaveRoom()
    if voiceState.connected then
        leaveVoiceRoom()
        if voiceWindow then
            local infoLabel = voiceWindow:recursiveGetChildById('infoLabel')
            if infoLabel then
                infoLabel:setText('Left voice room')
                infoLabel:setColor('#FFFF00')
            end
        end
    else
        if voiceWindow then
            local infoLabel = voiceWindow:recursiveGetChildById('infoLabel')
            if infoLabel then
                infoLabel:setText('Not connected to any voice room')
                infoLabel:setColor('#FF0000')
            end
        end
    end
end

function createPrivateRoom()
    if not voiceWindow then return end

    local roomNameEdit = voiceWindow:recursiveGetChildById('roomNameEdit')
    local passwordEdit = voiceWindow:recursiveGetChildById('passwordEdit')
    if not roomNameEdit then return end

    local roomName = roomNameEdit:getText()
    if not roomName or roomName:len() == 0 then
        showVoiceError('Please enter a room name')
        return
    end

    local password = passwordEdit and passwordEdit:getText() or ""
    local room = "private_" .. roomName .. "_" .. hashRoomPassword(password)

    local player = g_game.getLocalPlayer()
    if not player then return end

    local cid = player:getId()
    local token = tostring(cid) .. "-" .. room .. "-private"

    local success = Voice.join("127.0.0.1", 7331, room, token, cid)
    if success then
        voiceState.connected = true
        voiceState.room = room
        voiceState.channelType = "private"
        currentRoom = room
        roomNameEdit:setText('')
        if passwordEdit then passwordEdit:setText('') end
        g_logger.info("Created private voice room: " .. roomName)
        updateVoiceWindow()
    else
        g_logger.error("Failed to create private voice room")
    end
end

function joinPrivateRoom()
    if not voiceWindow then return end

    local roomNameEdit = voiceWindow:recursiveGetChildById('roomNameEdit')
    local passwordEdit = voiceWindow:recursiveGetChildById('passwordEdit')
    if not roomNameEdit then return end

    local roomName = roomNameEdit:getText()
    if not roomName or roomName:len() == 0 then
        showVoiceError('Please enter a room name')
        return
    end

    local password = passwordEdit and passwordEdit:getText() or ""
    local room = "private_" .. roomName .. "_" .. hashRoomPassword(password)

    local player = g_game.getLocalPlayer()
    if not player then return end

    local cid = player:getId()
    local token = tostring(cid) .. "-" .. room .. "-private"

    local success = Voice.join("127.0.0.1", 7331, room, token, cid)
    if success then
        voiceState.connected = true
        voiceState.room = room
        voiceState.channelType = "private"
        currentRoom = room
        roomNameEdit:setText('')
        if passwordEdit then passwordEdit:setText('') end
        g_logger.info("Joined private voice room: " .. roomName)
        updateVoiceWindow()
    else
        g_logger.error("Failed to join private voice room")
    end
end

function showRoomList()
    if not roomListWindow then
        roomListWindow = g_ui.displayUI('roomlist')
    end

    roomListWindow:show()
    roomListWindow:raise()
    roomListWindow:focus()

    -- Request room list from server
    getAvailableRooms()
end

function hideRoomList()
    if roomListWindow then
        roomListWindow:hide()
    end
end

function updateRoomList()
    if not roomListWindow then return end

    local roomList = roomListWindow:recursiveGetChildById('roomList')
    if not roomList then return end

    roomList:destroyChildren()

    for i, room in ipairs(availableRooms) do
        local roomText = string.format("%s (%d/%d)%s - by %s",
            room.name,
            room.memberCount or 0,
            room.maxMembers or 8,
            room.hasPassword and " [LOCKED]" or "",
            room.creator or "Unknown"
        )

        local label = g_ui.createWidget('RoomListLabel', roomList)
        label:setText(roomText)

        local joinBtn = g_ui.createWidget('RoomListJoinButton', roomList)
        joinBtn:setText('Join')
        joinBtn.onClick = function()
            joinVoiceRoom(room.name)
            hideRoomList()
        end
    end
end

function getAvailableRooms()
    local data = {
        action = "getRooms"
    }
    g_game.getProtocolGame():sendExtendedOpcode(VOICE_OPCODE, json.encode(data))
end

-- ==================== LOBBY SYSTEM ====================

local RELAY_HTTP_HOST = "http://127.0.0.1:7332"
local lobbyListData = {}
local passwordModalRoom = nil

function refreshLobbyList()
    if not voiceWindow then return end

    local lobbyList = voiceWindow:recursiveGetChildById('lobbyList')
    if lobbyList then
        lobbyList:destroyChildren()
        local loadingLabel = g_ui.createWidget('Label', lobbyList)
        loadingLabel:setText('Loading...')
        loadingLabel:setColor('#888888')
    end

    HTTP.getJSON(RELAY_HTTP_HOST .. '/rooms', function(response, err)
        if err then
            g_logger.error("Failed to fetch lobby list: " .. tostring(err))
            if voiceWindow then
                local lobbyList = voiceWindow:recursiveGetChildById('lobbyList')
                if lobbyList then
                    lobbyList:destroyChildren()
                    local errLabel = g_ui.createWidget('Label', lobbyList)
                    errLabel:setText('Cannot connect to voice server')
                    errLabel:setColor('#FF0000')
                end
            end
            return
        end

        if response and response.rooms then
            lobbyListData = response.rooms
            updateLobbyList()
        end
    end)
end

function updateLobbyList()
    if not voiceWindow then return end

    local lobbyList = voiceWindow:recursiveGetChildById('lobbyList')
    if not lobbyList then return end

    lobbyList:destroyChildren()

    if #lobbyListData == 0 then
        local emptyLabel = g_ui.createWidget('Label', lobbyList)
        emptyLabel:setText('No lobbies available. Create one!')
        emptyLabel:setColor('#888888')
        return
    end

    for i, room in ipairs(lobbyListData) do
        local row = g_ui.createWidget('LobbyListRow', lobbyList)
        row:setId('lobbyRow_' .. i)

        local nameLabel = row:recursiveGetChildById('lobbyNameLabel')
        if nameLabel then
            nameLabel:setText(room.name or room.roomId)
        end

        local lockLabel = row:recursiveGetChildById('lobbyLockLabel')
        if lockLabel then
            lockLabel:setText(room.hasPassword and '[LOCKED]' or '')
        end

        local countLabel = row:recursiveGetChildById('lobbyCountLabel')
        if countLabel then
            countLabel:setText(string.format('%d/%d', room.memberCount or 0, room.maxMembers or 50))
        end

        local creatorLabel = row:recursiveGetChildById('lobbyCreatorLabel')
        if creatorLabel then
            creatorLabel:setText('by ' .. (room.creator or 'Unknown'))
        end

        local joinBtn = row:recursiveGetChildById('lobbyJoinButton')
        if joinBtn then
            if (room.memberCount or 0) >= (room.maxMembers or 50) then
                joinBtn:setEnabled(false)
                joinBtn:setText('Full')
            else
                joinBtn.onClick = function()
                    attemptJoinLobby(room)
                end
            end
        end
    end
end

function createLobby()
    if not voiceWindow then return end

    local nameEdit = voiceWindow:recursiveGetChildById('lobbyNameEdit')
    local passwordEdit = voiceWindow:recursiveGetChildById('lobbyPasswordEdit')
    local maxMembersSlider = voiceWindow:recursiveGetChildById('maxMembersSlider')

    if not nameEdit then return end

    local name = nameEdit:getText()
    if not name or name:len() == 0 then
        showVoiceError('Please enter a lobby name')
        return
    end

    local password = passwordEdit and passwordEdit:getText() or ""
    local maxMembers = maxMembersSlider and maxMembersSlider:getValue() or 50
    local hasPassword = password and password:len() > 0

    local player = g_game.getLocalPlayer()
    if not player then return end

    local cid = player:getId()
    local creatorName = player:getName()
    local room = "lobby_" .. name .. "_" .. hashRoomPassword(password)

    local token = tostring(cid) .. "-" .. room .. "-lobby"

    local success = Voice.join("127.0.0.1", 7331, room, token, cid)
    if success then
        voiceState.connected = true
        voiceState.room = room
        voiceState.channelType = "lobby"
        currentRoom = room

        -- Send registerRoom after delay so socket is authenticated
        scheduleEvent(function()
            Voice.sendControlMessage(json.encode({
                action = "registerRoom",
                name = name,
                hasPassword = hasPassword,
                maxMembers = maxMembers,
                creator = creatorName
            }))
        end, 1000)

        nameEdit:setText('')
        if passwordEdit then passwordEdit:setText('') end

        g_logger.info("Created lobby: " .. name .. " (max: " .. maxMembers .. ")")
        updateVoiceWindow()
        refreshLobbyList()
        scheduleEvent(function()
            refreshLobbyList()
        end, 1500)
    else
        g_logger.error("Failed to create lobby")
        showVoiceError("Failed to create lobby")
    end
end

function attemptJoinLobby(room)
    if not room then return end

    if room.hasPassword then
        showPasswordModal(room)
    else
        joinLobby(room.roomId, room.name, nil)
    end
end

function showPasswordModal(room)
    passwordModalRoom = room

    local modal = g_ui.displayUI('password_modal')
    if not modal then
        g_logger.error("Failed to load password modal UI")
        return
    end

    local label = modal:recursiveGetChildById('modalLabel')
    if label then
        label:setText('Password for "' .. (room.name or room.roomId) .. '":')
    end

    local edit = modal:recursiveGetChildById('modalPasswordEdit')
    local okBtn = modal:recursiveGetChildById('modalOkButton')

    if okBtn then
        okBtn.onClick = function()
            local pwd = edit and edit:getText() or ""
            modal:destroy()
            if passwordModalRoom then
                joinLobby(passwordModalRoom.roomId, passwordModalRoom.name, pwd)
                passwordModalRoom = nil
            end
        end
    end

    modal.onEscape = function()
        modal:destroy()
        passwordModalRoom = nil
    end

    modal:show()
    modal:raise()
    modal:focus()
    if edit then edit:focus() end
end

function joinLobby(roomId, displayName, password)
    if voiceState.connected then
        leaveVoiceRoom()
    end

    local player = g_game.getLocalPlayer()
    if not player then return end

    local pwdHash = hashRoomPassword(password or "")
    local actualRoom = roomId

    if roomId:starts("lobby_") then
        actualRoom = roomId
    else
        local namePart = displayName or roomId
        actualRoom = "lobby_" .. namePart .. "_" .. pwdHash
    end

    local cid = player:getId()
    local token = tostring(cid) .. "-" .. actualRoom .. "-lobby"

    local success = Voice.join("127.0.0.1", 7331, actualRoom, token, cid)
    if success then
        voiceState.connected = true
        voiceState.room = actualRoom
        voiceState.channelType = "lobby"
        currentRoom = actualRoom

        g_logger.info("Joined lobby: " .. (displayName or actualRoom))
        updateVoiceWindow()

        local infoLabel = voiceWindow:recursiveGetChildById('infoLabel')
        if infoLabel then
            infoLabel:setText('Joined lobby: ' .. (displayName or actualRoom))
            infoLabel:setColor('#00FF00')
        end
    else
        g_logger.error("Failed to join lobby")
        showVoiceError("Failed to join lobby (wrong password?)")
    end
end
