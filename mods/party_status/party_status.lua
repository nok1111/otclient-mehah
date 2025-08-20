local PARTY_OPCODE = 50
local UPDATE_INTERVAL = 2000

local partyButton = nil
local partyWindow = nil
local membersPanel = nil
local updateEvent = nil

local cachedPartyFlags = {}

local function logError(msg) print("[PartyStatus] Error " .. msg) end

local function getMinimapWidget()
  return modules.game_minimap and modules.game_minimap.getMiniMapUi and modules.game_minimap.getMiniMapUi() or nil
end

local function clearPreviousPartyFlags()
  local minimap = getMinimapWidget()
  if not minimap then return end

  for _, data in ipairs(cachedPartyFlags) do
    minimap:removeFlag(data.pos, 0, data.name)
  end

  cachedPartyFlags = {}
end

local function drawPartyMinimapFlags()
  local minimap = getMinimapWidget()
  if not minimap then return end

  for _, data in ipairs(cachedPartyFlags) do
    minimap:addFlag(data.pos, 0, data.name, true)
  end
end

function toggle()
  if partyButton:isOn() then
    if partyWindow then
      partyWindow:close()
    end
    partyButton:setOn(false)
  else
    if not partyWindow then
      partyWindow = g_ui.loadUI('party_status.otui')
      if not partyWindow then
        logError("Could not load party_status.otui")
        return
      end
      membersPanel = partyWindow:recursiveGetChildById('membersPanel')
      if not membersPanel then
        logError("Could not find membersPanel in partyWindow")
        return
      end

      local container = modules.game_interface.getRightPanel()
      if container then
        container:addChild(partyWindow)
      end

      partyWindow:setup()

      local scrollbar = partyWindow:getChildById('miniwindowScrollBar')
      if scrollbar then
        scrollbar:mergeStyle({ ['$!on'] = {} })
      end
    end
    partyWindow:open()
    partyButton:setOn(true)
  end
end

function onMiniWindowOpen()
  if partyButton then
    partyButton:setOn(true)
  end
end

function onMiniWindowClose()
  if partyButton then
    partyButton:setOn(false)
  end
  clearPreviousPartyFlags()
end

function onGameStart()
  requestPartyUpdate()
end

function onGameEnd()
  if updateEvent then
    removeEvent(updateEvent)
    updateEvent = nil
  end
  if partyWindow then
    partyWindow:hide()
  end
  if partyButton then
    partyButton:setOn(false)
  end
  clearPreviousPartyFlags()
end

function requestPartyUpdate()
  if not g_game.isOnline() then return end
  local protocol = g_game.getProtocolGame()
  if protocol then
    protocol:sendExtendedOpcode(PARTY_OPCODE, "")
  end
  updateEvent = scheduleEvent(requestPartyUpdate, UPDATE_INTERVAL)
end

function onPartyData(protocol, opcode, buffer)
  if not partyWindow or not membersPanel then
    partyWindow = g_ui.loadUI('party_status.otui')
    if not partyWindow then
      logError("Failed to load party_status.otui")
      return
    end

    membersPanel = partyWindow:recursiveGetChildById('membersPanel')
    if not membersPanel then
      logError("Failed to find 'membersPanel' in UI")
      return
    end

    local container = modules.game_interface.getRightPanel()
    if container then
      container:addChild(partyWindow)
    end

    partyWindow:setup()

    local scrollbar = partyWindow:getChildById('miniwindowScrollBar')
    if scrollbar then
      scrollbar:mergeStyle({ ['$!on'] = {} })
    end

    partyWindow:open()
  end

  membersPanel:destroyChildren()
  clearPreviousPartyFlags()

  if not buffer or buffer == "" then
    return
  end

  local memberCount = 0
  local localPlayer = g_game.getLocalPlayer()

  for memberInfo in string.gmatch(buffer, "[^;]+") do
    local fields = {}
    for field in string.gmatch(memberInfo, "[^,]+") do
      table.insert(fields, field)
    end

    local name    = fields[1] or "Unknown"
    local hp      = tonumber(fields[2]) or 0
    local maxHp   = tonumber(fields[3]) or 1
    local mana    = tonumber(fields[4]) or 0
    local maxMana = tonumber(fields[5]) or 1
    local posX    = tonumber(fields[6]) or 0
    local posY    = tonumber(fields[7]) or 0
    local posZ    = tonumber(fields[8]) or 7

    if localPlayer and name ~= localPlayer:getName() then
      memberCount = memberCount + 1

      local widget = g_ui.createWidget('PartyMemberPanel', membersPanel)
      if widget then
        local nameLabel = widget:getChildById('memberNameLabel')
        if nameLabel then nameLabel:setText(name) end

        local healthBar = widget:getChildById('healthBar')
        if healthBar then
          local total = healthBar:getChildById('total')
          local current = healthBar:getChildById('current')
          if total and current then
            local percent = math.ceil((total:getWidth() * hp) / math.max(1, maxHp))
            current:setWidth(math.max(1, percent))
          end
        end

        local manaBar = widget:getChildById('manaBar')
        if manaBar then
          local total = manaBar:getChildById('total')
          local current = manaBar:getChildById('current')
          if total and current then
            local percent = math.ceil((total:getWidth() * mana) / math.max(1, maxMana))
            current:setWidth(math.max(1, percent))
          end
        end

        table.insert(cachedPartyFlags, {
          name = name,
          pos = { x = posX, y = posY, z = posZ }
        })
      else
        logError("Failed to create PartyMemberPanel for " .. name)
      end
    end
  end

  membersPanel:setHeight(memberCount * 56)
  drawPartyMinimapFlags()
end

function init()
  partyButton = modules.game_mainpanel.addToggleButton('partyStatusButton', 'Party Status', '/images/ui/tibiaCoin.png', toggle, false, 5)
  partyButton:setOn(false)

  ProtocolGame.registerExtendedOpcode(PARTY_OPCODE, onPartyData)
  connect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })

  if g_game.isOnline() then
    requestPartyUpdate()
  end
end

function terminate()
  disconnect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
  ProtocolGame.unregisterExtendedOpcode(PARTY_OPCODE)
  if updateEvent then removeEvent(updateEvent) end
  if partyWindow then partyWindow:destroy() end
  if partyButton then partyButton:destroy() end
  clearPreviousPartyFlags()
end
