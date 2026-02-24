local standModeBox
local chaseModeBox
local optionsAmount = 0
local storeAmount = 0

local chaseModeRadioGroup
local controlButton1400 = nil
local optionPanel = nil
local buttonConfigs = {}
local buttonOrder = {}
local ICON_ONLY_MAIN_BUTTONS = {
    optionsMainButton = true,
    logoutButton = true,
    minimapButton = true,
    inventoryButton = true,
}
local COLORS = {
    BASE_1 = "#484848",
    BASE_2 = "#414141"
}

function reloadMainPanelSizes()
    -- Only size widgets that live in the RightPanel; do not change MainRightPanel height
    local container = modules.game_interface.getLeftPanel()

    if not container then
        return
    end
    
    local height = 1
    local function calculatePanelHeight(icon_count, max_icons_per_row, icon_size)
        local rows = math.ceil(icon_count / max_icons_per_row)
        return (rows * icon_size) + (rows * 3)
    end

    for _, panel in ipairs(container:getChildren()) do
        if panel.panelHeight ~= nil then
            if panel:isVisible() then
                panel:setHeight(panel.panelHeight)
                height = height + panel.panelHeight

                if panel:getId() == 'mainoptionspanel' and panel:isOn() then
             
                    local function calculatePanelHeightFromPanel(panel, max_icons_per_row)
                        local icon_count = 0
                        local max_icon_height = 18
                        for _, icon in ipairs(panel:getChildren()) do
                            if icon:isVisible() then
                                icon_count = icon_count + 1
                                if icon.getHeight then
                                    max_icon_height = math.max(max_icon_height, icon:getHeight())
                                end
                            end
                        end

                        local rows = math.ceil(icon_count / max_icons_per_row)
                        return (rows * max_icon_height) + (rows * 3)
                    end

                    local options_panel = optionsController.ui.onPanel.options
                    local options_height = calculatePanelHeightFromPanel(options_panel, 5)

                    panel:setHeight(panel:getHeight() + options_height)
                    height = height + options_height

                    local store_panel = panel.onPanel.store
                    local store_height = calculatePanelHeightFromPanel(store_panel, 1)

                    store_panel:setHeight(store_height)
                    height = height + store_height

                    local top_controls_panel = panel.onPanel.topControls
                    if top_controls_panel then
                        local top_controls_height = calculatePanelHeightFromPanel(top_controls_panel, 2)
                        if top_controls_height < 30 then top_controls_height = 30 end
                        top_controls_panel:setHeight(top_controls_height)
                        height = height + top_controls_height
                    end

                    if store_panel:getChildCount() >= 2 then
                        height = height + 15 
                    end
                end
            else
                panel:setHeight(0)
            end
        end
    end

    -- Do not alter MainRightPanel height anymore; just refit RightPanel
    container:fitAll()
end

-- @ Options
local optionsShrink = false -- deprecated, keep for compatibility
local function refreshOptionsSizes()
    local ui = optionsController and optionsController.ui
    if not ui then return end

    local onPanel = ui.onPanel
    local offPanel = ui.offPanel -- may not exist in current OTUI
    -- Always show all buttons; ignore shrink state
    ui:setOn(true)
    if onPanel then onPanel:show() end
    if offPanel then offPanel:hide() end
    reloadMainPanelSizes()
end

local function createButton_large(id, description, image, callback, special, front, index, customStyle)
    -- fast version
    local isIconOnly = ICON_ONLY_MAIN_BUTTONS[id]
    local storePanel = optionsController.ui.onPanel.store
    local topControlsPanel = optionsController.ui.onPanel.topControls
    local panel = (isIconOnly and topControlsPanel) or storePanel
    if not panel then
        return nil
    end

    storeAmount = storeAmount + 1

    local button = panel:getChildById(id)
    local styleName = customStyle or (ICON_ONLY_MAIN_BUTTONS[id] and 'MainPanelSquareIconButton') or 'MainPanelLargeButton'

    if isIconOnly then
        local allPanels = { topControlsPanel, storePanel }
        for _, currentPanel in ipairs(allPanels) do
            if currentPanel then
                local children = currentPanel:getChildren()
                for i = #children, 1, -1 do
                    local child = children[i]
                    if child and child:getId() == id then
                        child:destroy()
                    end
                end
            end
        end

        button = nil
    end

    if not button then
        button = g_ui.createWidget(styleName)
        if front then
            panel:insertChild(1, button)
        else
            panel:addChild(button)
        end
    end

    button:setId(id)
    button:setTooltip(description)

    if ICON_ONLY_MAIN_BUTTONS[id] then
        if button.setSize then button:setSize({ width = 68, height = 28 }) end
        if button.setWidth then button:setWidth(68) end
        if button.setHeight then button:setHeight(28) end
        if button.setMinimumSize then button:setMinimumSize({ width = 68, height = 28 }) end
        if button.setMaximumSize then button:setMaximumSize({ width = 68, height = 28 }) end
        if button.setText then button:setText('') end
        if button.setIcon then button:setIcon(image or '') end
        if button.setIconAlign then button:setIconAlign(AlignCenter) end
    else
        if button.setText then button:setText(description) end
        -- Ensure the proper sprite is used (avoid legacy /images/options/store_large)
        if button.setImageSource then button:setImageSource('/images/ui/buttons/tabbar_button') end
    end

    button.onMouseRelease = function(widget, mousePos, mouseButton)
        if widget:containsPoint(mousePos) and mouseButton ~= MouseMidButton then
            callback()
            return true
        end
    end

    if not button.index and type(index) == 'number' then
        button.index = index
    end

    return button
end

local function createButton(id, description, image, callback, special, front, index)
    -- Validación: verificar que el controlador esté inicializado
    if not optionsController or not optionsController.ui then
        return nil
    end
    
    -- Todos los botones van al panel 'options'
    local panel = optionsController.ui.onPanel.options
    optionsAmount = optionsAmount + 1
    
    if not panel then
        return nil
    end

    local button = panel:getChildById(id)
    if not button then
        button = g_ui.createWidget('MainPanelGridButton')
        if front then
            panel:insertChild(1, button)
        else
            panel:addChild(button)
        end
    end

    button:setId(id)
    button:setTooltip(description)
    -- Use styled background via style; do not override here
    if button.setText then button:setText(description) end
    button.onMouseRelease = function(widget, mousePos, mouseButton)
        if widget:containsPoint(mousePos) and mouseButton ~= MouseMidButton then
            callback()
            return true
        end
    end
    if not button.index and type(index) == 'number' then
        button.index = index or 1000
    end

    refreshOptionsSizes()
    return button
end

optionsController = Controller:new()
-- Place mainoptionspanel inside the RightPanel (not MainRightPanel)
optionsController:setUI('mainoptionspanel', modules.game_interface.getLeftPanel())

function optionsController:onInit()
   -- createButton_large('Store shop', tr('Store shop'), '', toggleStore,
   -- false, 8)

    if not optionPanel then
        optionPanel = g_ui.loadUI('option_control_buttons', modules.client_options:getPanel())
       -- modules.client_options.addButton("Interface", "Control Buttons", optionPanel, function() initControlButtons() end)
    end
end

function toggleStore()
    if  g_game.getFeature(GameIngameStore) then
        modules.game_store.toggle() -- cipsoft packets
    else
        modules.game_shop.toggle() -- custom from v8
    end
end

function optionsController:onTerminate()
    if optionPanel then
        optionPanel:destroy()
        optionPanel = nil
        modules.client_options.removeButton("Interface", "Control Buttons")  -- hot reload
    end
    if controlButton1400 then
        controlButton1400:destroy()
        controlButton1400 = nil
    end
end

function optionsController:onGameStart()
    optionsShrink = g_settings.getBoolean('mainpanel_shrink_options')
    refreshOptionsSizes()
    modules.game_interface.setupOptionsMainButton()
    modules.client_options.setupOptionsMainButton()
    local getOptionsPanel = optionsController.ui.onPanel.options
    local children = getOptionsPanel:getChildren()
    table.sort(children, function(a, b)
        return (a.index or 1000) < (b.index or 1000)
    end)
    getOptionsPanel:reorderChildren(children)

    local topControlsPanel = optionsController.ui.onPanel.topControls
    if topControlsPanel then
        local topChildren = topControlsPanel:getChildren()
        table.sort(topChildren, function(a, b)
            return (a.index or 1000) < (b.index or 1000)
        end)
        topControlsPanel:reorderChildren(topChildren)
    end

    local storePanel = optionsController.ui.onPanel.store
    if storePanel then
        local storeChildren = storePanel:getChildren()
        table.sort(storeChildren, function(a, b)
            return (a.index or 1000) < (b.index or 1000)
        end)
        storePanel:reorderChildren(storeChildren)
    end
    optionsController:scheduleEvent(function()
        if optionPanel then
            local config = loadButtonConfig()
            buttonConfigs = config.buttons or {}
            buttonOrder = config.order or {}
            
            local optionsPanel = optionsController.ui.onPanel.options
            if optionsPanel then
                for _, button in ipairs(optionsPanel:getChildren()) do
                    local id = button:getId()
                    if id and buttonConfigs[id] then
                        button:setVisible(buttonConfigs[id].visible)
                    end
                end
                reorderButtons()
                updateDisplayedButtonsList()
                updateAvailableButtonsList()
                reloadMainPanelSizes()
            end
        end
    end, 50, "onGameStart")
    if g_game.getClientVersion() >= 1400 and not controlButton1400 then
        controlButton1400 = modules.game_mainpanel.addToggleButton('controButtons', tr('Manage control buttons'),
        '/images/options/button_control', function() modules.client_options.openOptionsCategory("Interface", "Control Buttons") end, false, 1)
        controlButton1400:setOn(false)
    end
end

function optionsController:onGameEnd()
end

function changeOptionsSize()
    optionsShrink = not optionsShrink
    g_settings.set('mainpanel_shrink_options', optionsShrink)
    refreshOptionsSizes()
end

function addToggleButton(id, description, image, callback, front, index)
    return createButton(id, description, image, callback, false, front, index)
end

function addStoreButton(id, description, image, callback, front, index, customStyle)
    return createButton_large(id, description, image, callback, true, front, index, customStyle)
end

function getButton(id)
    return optionsController.ui.onPanel.options:recursiveGetChildById(id)
end

function toggleExtendedViewButtons(extended)
    local optionsPanel = optionsController.ui.onPanel.options
    local storePanel = optionsController.ui.onPanel.store
    local rightGamePanel = modules.client_topmenu.getRightGameButtonsPanel()
    if extended then
        local optionChildren = optionsPanel:getChildren()
        for _, button in ipairs(optionChildren) do
            if not button:isDestroyed() then
                button.originalPanel = "options"
                rightGamePanel:addChild(button)
            end
        end
        local storeChildren = storePanel:getChildren()
        for _, button in ipairs(storeChildren) do
            if not button:isDestroyed() then
                button.originalPanel = "store"
                rightGamePanel:addChild(button)
            end
        end
        optionsController.ui:hide()
        optionsController.ui:setHeight(0)
    else
        local children = rightGamePanel:getChildren()
        for _, button in ipairs(children) do
            if not button:isDestroyed() then
                if button.originalPanel == "options" then
                    optionsPanel:addChild(button)
                elseif button.originalPanel == "store" then
                    storePanel:addChild(button)
                end
            end
        end
        optionsController.ui:show()
        -- No need to manipulate MainRightPanel; ensure widget is in RightPanel near the top
        local leftPanel = modules.game_interface.getLeftPanel()
        if leftPanel:hasChild(optionsController.ui) then
            leftPanel:moveChildToIndex(optionsController.ui, 1)
        end
    end
    refreshOptionsSizes()
end

function saveButtonConfig()
    local config = {
        buttons = {},
        order = {}
    }
    for id, buttonConfig in pairs(buttonConfigs) do
        if type(id) == "string" and type(buttonConfig) == "table" then
            config.buttons[id] = {
                visible = buttonConfig.visible,
                tooltip = buttonConfig.tooltip
            }
        end
    end
    for i, id in ipairs(buttonOrder) do
        config.order[tostring(i)] = id
    end
    g_settings.setNode('control_buttons', config)
end

function loadButtonConfig()
    local config = g_settings.getNode('control_buttons') or {
        buttons = {},
        order = {}
    }
    local orderArray = {}
    if config.order then
        local keys = {}
        for k in pairs(config.order) do
            table.insert(keys, tonumber(k))
        end
        table.sort(keys)
        for _, k in ipairs(keys) do
            table.insert(orderArray, config.order[tostring(k)])
        end
    end

    return {
        buttons = config.buttons or {},
        order = orderArray
    }
end

local function updateList(listWidget, isVisibleList)
    if not g_game.isOnline() or not listWidget then
        return
    end
    local focusedItem = listWidget:getFocusedChild()
    local focusedId = focusedItem and focusedItem.buttonId
    local existingItems = {}
    for _, child in ipairs(listWidget:getChildren()) do
        existingItems[child.buttonId] = child
    end
    local displayButtons = {}
    for id, config in pairs(buttonConfigs) do
        if (config.visible == true) == isVisibleList then
            table.insert(displayButtons, {
                id = id,
                config = config
            })
        end
    end
    if isVisibleList then
        table.sort(displayButtons, function(a, b)
            local indexA = table.find(buttonOrder, a.id) or 999
            local indexB = table.find(buttonOrder, b.id) or 999
            return indexA < indexB
        end)
    end
    for buttonId, item in pairs(existingItems) do
        local shouldBeInList = false
        for _, buttonData in ipairs(displayButtons) do
            if buttonData.id == buttonId then
                shouldBeInList = true
                break
            end
        end
        if not shouldBeInList then
            item:destroy()
            existingItems[buttonId] = nil
        end
    end

    local currentChildren = {}
    for i, buttonData in ipairs(displayButtons) do
        local buttonId = buttonData.id
        local buttonConfig = buttonData.config
        local item = existingItems[buttonId]
        if not item then
            item = g_ui.createWidget('HotkeyListLabel', listWidget)
            item:setId(buttonId)
            item.buttonId = buttonId
            item:setText(buttonConfig.tooltip)
            item:setTextAlign(AlignLeft)
        end
        if not item:isFocused() then
            item:setBackgroundColor((i % 2 == 0) and COLORS.BASE_1 or COLORS.BASE_2)
        end

        table.insert(currentChildren, item)
    end
    listWidget:reorderChildren(currentChildren)
    if focusedId then
        for _, child in ipairs(listWidget:getChildren()) do
            if child.buttonId == focusedId then
                child:focus()
                break
            end
        end
    end
end

function updateDisplayedButtonsList()
    updateList(optionPanel.panelDisplayedButtons.displayedButtonsList, true)
end

function updateAvailableButtonsList()
    updateList(optionPanel.panelAvailableButtons.displayedAvailableButtonsList, false)
end

function moveToAvailable()
    local displayedList = optionPanel.panelDisplayedButtons.displayedButtonsList
    local selectedItem = displayedList:getFocusedChild()

    if not selectedItem then
        return
    end

    local buttonId = selectedItem.buttonId
    local optionsPanel = optionsController.ui.onPanel.options
    local button = optionsPanel:getChildById(buttonId)
    if button then
        button:setVisible(false)
        buttonConfigs[buttonId].visible = false
        table.removevalue(buttonOrder, buttonId)
        updateDisplayedButtonsList()
        updateAvailableButtonsList()
        saveButtonConfig()
        reloadMainPanelSizes()
        displayedList:focusNextChild(KeyboardFocusReason)
    end
end

function moveToDisplayed()
    local availableList = optionPanel.panelAvailableButtons.displayedAvailableButtonsList
    local selectedItem = availableList:getFocusedChild()

    if not selectedItem then
        return
    end

    local buttonId = selectedItem.buttonId
    local optionsPanel = optionsController.ui.onPanel.options
    local button = optionsPanel:getChildById(buttonId)

    if button then
        button:setVisible(true)
        buttonConfigs[buttonId].visible = true
        table.insert(buttonOrder, buttonId)
        updateDisplayedButtonsList()
        updateAvailableButtonsList()
        reorderButtons()
        saveButtonConfig()
        reloadMainPanelSizes()
        availableList:focusNextChild(KeyboardFocusReason)
    end
end

function moveButtonUp()
    if not g_game.isOnline() then
        return
    end

    local displayedList = optionPanel.panelDisplayedButtons.displayedButtonsList
    local selectedItem = displayedList:getFocusedChild()

    if not selectedItem then
        return
    end

    local buttonId = selectedItem.buttonId
    local index = table.find(buttonOrder, buttonId)

    if index and index > 1 then
        buttonOrder[index], buttonOrder[index - 1] = buttonOrder[index - 1], buttonOrder[index]
        updateDisplayedButtonsList()
        reorderButtons()
        saveButtonConfig()
        local focusedChild = displayedList:getFocusedChild()
        if focusedChild then
            displayedList:ensureChildVisible(focusedChild)
        end
    end
end

function moveButtonDown()
    if not g_game.isOnline() then
        return
    end

    local displayedList = optionPanel.panelDisplayedButtons.displayedButtonsList
    local selectedItem = displayedList:getFocusedChild()

    if not selectedItem then
        return
    end

    local buttonId = selectedItem.buttonId
    local index = table.find(buttonOrder, buttonId)

    if index and index < #buttonOrder then
        buttonOrder[index], buttonOrder[index + 1] = buttonOrder[index + 1], buttonOrder[index]

        updateDisplayedButtonsList()
        reorderButtons()
        saveButtonConfig()
        local focusedChild = displayedList:getFocusedChild()
        if focusedChild then
            displayedList:ensureChildVisible(focusedChild)
        end
    end
end

function reorderButtons()
    if not g_game.isOnline() then
        return
    end
    local optionsPanel = optionsController.ui.onPanel.options
    local children = {}
    for _, id in ipairs(buttonOrder) do
        local button = optionsPanel:getChildById(id)
        if button then
            table.insert(children, button)
        end
    end
    for _, button in ipairs(optionsPanel:getChildren()) do
        local id = button:getId()
        if not table.find(buttonOrder, id) then
            table.insert(children, button)
        end
    end
    optionsPanel:reorderChildren(children)
end

function listAllButtons()
    print("========== LISTA DE BOTONES DEL MAINPANEL ==========")
    local optionsPanel = optionsController.ui.onPanel.options
    if optionsPanel then
        local buttons = optionsPanel:getChildren()
        print("Total de botones: " .. #buttons)
        for i, button in ipairs(buttons) do
            local id = button:getId()
            local visible = button:isVisible()
            local tooltip = button:getTooltip()
            print(string.format("[%d] ID: %s | Visible: %s | Tooltip: %s", i, tostring(id), tostring(visible), tostring(tooltip)))
        end
    else
        print("ERROR: optionsPanel es nil")
    end
    print("=====================================================")
end

function showButton(buttonId)
    local optionsPanel = optionsController.ui.onPanel.options
    if optionsPanel then
        local button = optionsPanel:getChildById(buttonId)
        if button then
            button:setVisible(true)
            if buttonConfigs[buttonId] then
                buttonConfigs[buttonId].visible = true
            else
                buttonConfigs[buttonId] = { visible = true, tooltip = button:getTooltip() or buttonId }
            end
            if not table.find(buttonOrder, buttonId) then
                table.insert(buttonOrder, buttonId)
            end
            saveButtonConfig()
            reloadMainPanelSizes()
            print("[MainPanel] Botón '" .. buttonId .. "' ahora visible y guardado")
        else
            print("[MainPanel ERROR] Botón '" .. buttonId .. "' no encontrado")
        end
    end
end

function showAllButtons()
    local optionsPanel = optionsController.ui.onPanel.options
    if optionsPanel then
        local count = 0
        for _, button in ipairs(optionsPanel:getChildren()) do
            local id = button:getId()
            if id then
                button:setVisible(true)
                buttonConfigs[id] = { visible = true, tooltip = button:getTooltip() or id }
                if not table.find(buttonOrder, id) then
                    table.insert(buttonOrder, id)
                end
                count = count + 1
            end
        end
        saveButtonConfig()
        reloadMainPanelSizes()
        print("[MainPanel] " .. count .. " botones ahora visibles y guardados")
    end
end

function reset()
    g_settings.setNode('control_buttons', {})
    buttonConfigs = {}
    buttonOrder = {}
    local optionsPanel = optionsController.ui.onPanel.options
    if optionsPanel then
        for _, button in ipairs(optionsPanel:getChildren()) do
            local id = button:getId()
            if id then
                button:setVisible(true)
                buttonConfigs[id] = {
                    visible = true,
                    tooltip = button:getTooltip() or id
                }
                table.insert(buttonOrder, id)
            end
        end
    end
    updateDisplayedButtonsList()
    updateAvailableButtonsList()
    reorderButtons()
    reloadMainPanelSizes()
end

function initControlButtons()
    local config = loadButtonConfig()
    buttonConfigs = config.buttons or {}
    buttonOrder = config.order or {}
    local currentButtons = {}
    for _, button in ipairs(optionsController.ui.onPanel.options:getChildren()) do
        local id = button:getId()
        if id then
            currentButtons[id] = true
            if not buttonConfigs[id] then
                buttonConfigs[id] = {
                    visible = button:isVisible(),
                    tooltip = button:getTooltip() or id
                }

                if button:isVisible() and not table.find(buttonOrder, id) then
                    table.insert(buttonOrder, id)
                end
            else
                if buttonConfigs[id].visible == nil then
                    buttonConfigs[id].visible = true
                end
                button:setVisible(buttonConfigs[id].visible)
            end
        end
    end

    local toRemove = {}
    for id in pairs(buttonConfigs) do
        if not currentButtons[id] then
            table.insert(toRemove, id)
        end
    end

    for _, id in ipairs(toRemove) do
        buttonConfigs[id] = nil
        for i, orderId in ipairs(buttonOrder) do
            if orderId == id then
                table.remove(buttonOrder, i)
                break
            end
        end
    end
    updateDisplayedButtonsList()
    updateAvailableButtonsList()
    reorderButtons()
    reloadMainPanelSizes()
end
