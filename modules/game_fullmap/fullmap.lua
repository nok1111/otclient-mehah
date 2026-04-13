fullMapWindow = nil
mapView = nil
npcMarkers = {}
playerMarker = nil
updateEvent = nil
npcList = {}
mapLoaded = false

function init()
  connect(g_game, { 
    onGameStart = onGameStart,
    onGameEnd = onGameEnd
  })
  
  ProtocolGame.registerExtendedOpcode(210, onReceiveMapData)
  
  -- Add keyboard shortcut Ctrl+W (World Map)
  g_keyboard.bindKeyDown('Ctrl+W', toggle)
  
  -- Create UI (may fail if rootWidget not ready yet)
  local success, err = pcall(function()
    g_ui.importStyle('fullmap')
    fullMapWindow = g_ui.createWidget('FullMapWindow', rootWidget)
    if fullMapWindow then
      fullMapWindow:hide()
      mapView = fullMapWindow:getChildById('mapView')
    end
  end)
  
  if not success then
    print('[FullMap] Warning: Could not create UI on init: ' .. tostring(err))
  end
end

function terminate()
  disconnect(g_game, { 
    onGameStart = onGameStart,
    onGameEnd = onGameEnd
  })
  
  ProtocolGame.unregisterExtendedOpcode(210)
  
  -- Unbind keyboard shortcut
  g_keyboard.unbindKeyDown('Ctrl+W')
  
  if updateEvent then
    removeEvent(updateEvent)
    updateEvent = nil
  end
  
  clearMarkers()
  
  if fullMapWindow then
    fullMapWindow:destroy()
    fullMapWindow = nil
  end
end

function onGameStart()
  -- Request map data from server (NPCs, spawns, etc.)
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    local msg = OutputMessage.create()
    msg:addU8(210) -- Extended opcode for map data
    msg:addString('request-map-data')
    protocolGame:sendExtendedOpcode(210, msg:getBuffer())
  end
  
  -- Try to load OTBM if available
  loadMapFromOTBM()
  
  -- Start position update loop
  scheduleUpdate()
end

function onGameEnd()
  if updateEvent then
    removeEvent(updateEvent)
    updateEvent = nil
  end
  
  clearMarkers()
  hide()
  mapLoaded = false -- Reset so map can be loaded again next session
end

function loadMapFromOTBM()
  -- Only load map once to avoid performance issues
  if mapLoaded then
    print('[FullMap] Map already loaded, skipping reload')
    return
  end
  
  -- Try multiple map paths in order of preference
  local mapPaths = {
    '/maps/otbm/map.otbm',
    '/maps/otbm/cross_map.otbm',
    '/map.otbm'  -- Legacy path for backwards compatibility
  }
  
  for _, mapPath in ipairs(mapPaths) do
    if g_resources.fileExists(mapPath) then
      print('[FullMap] Loading OTBM map: ' .. mapPath)
      
      -- Load the map using editor functions
      if g_map.loadOtbm then
        local success = pcall(function()
          g_map.loadOtbm(mapPath)
          print('[FullMap] OTBM map loaded successfully!')
        end)
        
        if success then
          mapLoaded = true
          return -- Successfully loaded
        else
          print('[FullMap] Failed to load OTBM from: ' .. mapPath)
        end
      else
        print('[FullMap] OTBM loading not available - client not compiled with FRAMEWORK_EDITOR')
        loadMapFromOTCM()
        return
      end
    end
  end
  
  print('[FullMap] No OTBM map file found - trying OTCM format')
  loadMapFromOTCM()
end

function loadMapFromOTCM()
  -- Try multiple OTCM paths
  local otcmPaths = {
    '/maps/otcm/map.otcm',
    '/maps/otcm/cross_map.otcm',
    '/map.otcm'  -- Legacy path
  }
  
  for _, otcmPath in ipairs(otcmPaths) do
    if g_resources.fileExists(otcmPath) then
      print('[FullMap] Loading OTCM map: ' .. otcmPath)
      
      if g_map.loadOtcm then
        local success = pcall(function()
          g_map.loadOtcm(otcmPath)
          print('[FullMap] OTCM map loaded successfully!')
        end)
        
        if success then
          mapLoaded = true
          return -- Successfully loaded
        else
          print('[FullMap] Failed to load OTCM from: ' .. otcmPath)
        end
      end
    end
  end
  
  print('[FullMap] No map file found - map will be discovered as you explore')
end

function onReceiveMapData(protocol, opcode, buffer)
  local msg = InputMessage.create()
  msg:setBuffer(buffer)
  
  local action = msg:getString()
  
  if action == 'npc-list' then
    -- Receive NPC positions and names
    local count = msg:getU16()
    npcList = {}
    
    for i = 1, count do
      local npcData = {
        name = msg:getString(),
        x = msg:getU16(),
        y = msg:getU16(),
        z = msg:getU8(),
        type = msg:getString() -- 'npc', 'boss', 'trainer', etc.
      }
      table.insert(npcList, npcData)
    end
    
    updateNPCMarkers()
    updateNPCList()
    
    print('[FullMap] Received ' .. count .. ' NPC locations')
  elseif action == 'open-worldmap' then
    -- Server command to open world map
    show()
  end
end

function updateNPCMarkers()
  if not mapView then return end
  
  -- Clear existing markers
  for _, marker in ipairs(npcMarkers) do
    if marker.widget then
      marker.widget:destroy()
    end
  end
  npcMarkers = {}
  
  -- Note: UIMap widget doesn't support adding visual markers like UIMinimap does
  -- NPCs are only shown in the side list, clicking them centers the map
  -- The actual map view from OTBM will show NPCs naturally
  
  print('[FullMap] NPC data loaded - ' .. #npcList .. ' NPCs available in list')
end

function updateNPCList()
  if not fullMapWindow then return end
  
  local npcListWidget = fullMapWindow:getChildById('npcList')
  if not npcListWidget then return end
  
  npcListWidget:destroyChildren()
  
  -- Sort NPCs by name
  local sortedNPCs = {}
  for _, npc in ipairs(npcList) do
    table.insert(sortedNPCs, npc)
  end
  
  table.sort(sortedNPCs, function(a, b)
    return a.name < b.name
  end)
  
  -- Add to list
  for _, npc in ipairs(sortedNPCs) do
    local label = g_ui.createWidget('Label', listWidget)
    
    local typeIcon = '[NPC]'
    local color = '#00ff00'
    
    if npc.type == 'boss' then
      typeIcon = '[BOSS]'
      color = '#ff0000'
    elseif npc.type == 'trainer' then
      typeIcon = '[TRAIN]'
      color = '#ffff00'
    elseif npc.type == 'shop' then
      typeIcon = '[SHOP]'
      color = '#00ffff'
    elseif npc.type == 'outfit' then
      typeIcon = '[OUTFIT]'
      color = '#ff00ff'
    end
    
    label:setText(typeIcon .. ' ' .. npc.name)
    label:setColor(color)
    label:setPhantom(false)
    
    label.onClick = function()
      centerOnPosition({x = npc.x, y = npc.y, z = npc.z})
    end
  end
end

function scheduleUpdate()
  if fullMapWindow and fullMapWindow:isVisible() then
    updatePlayerPosition()
  end
  updateEvent = scheduleEvent(scheduleUpdate, 500) -- Update every 500ms (reduced from 100ms for performance)
end

function updatePlayerPosition()
  if not fullMapWindow or not fullMapWindow:isVisible() then return end
  
  local player = g_game.getLocalPlayer()
  if not player then return end
  
  local pos = player:getPosition()
  
  -- Update position label
  local posLabel = fullMapWindow:getChildById('positionLabel')
  if posLabel then
    posLabel:setText(string.format('Position: %d, %d, %d', pos.x, pos.y, pos.z))
  end
  
  -- Center map on player position (no need for player marker widget)
  -- The map view itself shows the player position
  
  -- Update zoom label
  local zoomLabel = fullMapWindow:getChildById('zoomLabel')
  if zoomLabel and mapView then
    local zoom = mapView:getZoom()
    zoomLabel:setText('Zoom: ' .. zoom .. 'x')
  end
end

function clearMarkers()
  for _, marker in ipairs(npcMarkers) do
    if marker.widget then
      marker.widget:destroy()
    end
  end
  npcMarkers = {}
end

function show()
  if not g_game.isOnline() then
    return
  end
  
  -- Lazy initialization if window wasn't created during init
  if not fullMapWindow then
    local success, err = pcall(function()
      g_ui.importStyle('fullmap')
      fullMapWindow = g_ui.createWidget('FullMapWindow', rootWidget)
      if fullMapWindow then
        mapView = fullMapWindow:getChildById('mapView')
      end
    end)
    
    if not success or not fullMapWindow then
      print('[FullMap] Error: Could not create window: ' .. tostring(err))
      return
    end
  end
  
  -- Maximize window to fill screen
  local gameRootWidget = modules.game_interface.getRootPanel()
  if gameRootWidget then
    fullMapWindow:setSize(gameRootWidget:getSize())
    fullMapWindow:setPosition({x = 0, y = 0})
  end
  
  fullMapWindow:show()
  fullMapWindow:raise()
  fullMapWindow:focus()
  
  centerOnPlayer()
  updatePlayerPosition()
  updateNPCMarkers()
  updateNPCList()
end

function showMaximized()
  show() -- Already maximized by default
end

function showFullscreen()
  if not g_game.isOnline() then
    return
  end
  
  -- Lazy initialization if window wasn't created during init
  if not fullMapWindow then
    local success, err = pcall(function()
      g_ui.importStyle('fullmap')
      fullMapWindow = g_ui.createWidget('FullMapWindow', rootWidget)
      if fullMapWindow then
        mapView = fullMapWindow:getChildById('mapView')
      end
    end)
    
    if not success or not fullMapWindow then
      print('[FullMap] Error: Could not create window: ' .. tostring(err))
      return
    end
  end
  
  -- True fullscreen - cover entire window
  fullMapWindow:setSize(rootWidget:getSize())
  fullMapWindow:setPosition({x = 0, y = 0})
  
  fullMapWindow:show()
  fullMapWindow:raise()
  fullMapWindow:focus()
  
  centerOnPlayer()
  updatePlayerPosition()
  updateNPCMarkers()
  updateNPCList()
end

function hide()
  if fullMapWindow then
    fullMapWindow:hide()
  end
end

function toggle()
  if fullMapWindow and fullMapWindow:isVisible() then
    hide()
  else
    show()
  end
end

function centerOnPlayer()
  if not mapView then return end
  
  local player = g_game.getLocalPlayer()
  if not player then return end
  
  local pos = player:getPosition()
  centerOnPosition(pos)
end

function centerOnPosition(pos)
  if not mapView then return end
  mapView:setCameraPosition(pos)
end

function zoomIn()
  if not mapView then return end
  local currentZoom = mapView:getZoom()
  local maxZoom = mapView:getMaxZoom()
  if currentZoom < maxZoom then
    mapView:setZoom(currentZoom + 1)
  end
end

function zoomOut()
  if not mapView then return end
  local currentZoom = mapView:getZoom()
  local minZoom = mapView:getMinZoom()
  if currentZoom > minZoom then
    mapView:setZoom(currentZoom - 1)
  end
end
