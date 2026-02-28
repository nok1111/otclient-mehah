QuickLoot = {}

local MAX_DYNAMIC_CATEGORIES = 63

local function getFilter(id)
    local filter = {
        [1] = 0,
        [2] = 1
    }
    return filter[id]
end

quickLootController = Controller:new()
quickLootController:setUI('quickloot')
function quickLootController:onInit()

    QuickLoot.Define()

    QuickLoot.data = {
        filter = 1,
        selectedCategoryId = 1,
        categories = {
            { id = 1, name = "General" }
        },
        categoryItems = {},
        collapsedCategories = {},
        loots = {
            [0] = {},
            {}
        }
    }

    quickLootController.ui:hide()

    quickLootController:registerEvents(g_game, {
        onQuickLootContainers = QuickLoot.start
    })
    Keybind.new("Loot", "Quick Loot Nearby Corpses", "Ctrl+Q", "")
    Keybind.bind("Loot", "Quick Loot Nearby Corpses", {
      {
        type = KEY_DOWN,
        callback = function() g_game.sendQuickLoot(2) end,
      }
    })

end

function quickLootController:onTerminate()
    Keybind.delete("Loot", "Quick Loot Nearby Corpses")
    if QuickLoot.cancelCategoryName then
        QuickLoot.cancelCategoryName()
    end
    if QuickLoot.closeCategoryItemsWindow then
        QuickLoot.closeCategoryItemsWindow()
    end

    if QuickLoot.mouseGrabberWidget then
        if g_ui.isMouseGrabbed() then
            QuickLoot.mouseGrabberWidget:ungrabMouse()
        end
        QuickLoot.mouseGrabberWidget.onMouseRelease = nil
        QuickLoot.mouseGrabberWidget:destroy()
        QuickLoot.mouseGrabberWidget = nil
    end
    QuickLoot.onConfirmCategoryName = nil
end

function quickLootController:onGameStart()
    if not g_game.getFeature(GameThingQuickLoot) then
        return
    end

    QuickLoot.mouseGrabberWidget = g_ui.createWidget("UIWidget")

    QuickLoot.mouseGrabberWidget:setVisible(false)
    QuickLoot.mouseGrabberWidget:setFocusable(false)

    QuickLoot.mouseGrabberWidget.onMouseRelease = QuickLoot.onChooseItem
    QuickLoot.lastSelectBag = nil
    QuickLoot.ErrorWindow = nil
    QuickLoot.serverCategoryItemNames = {}
    QuickLoot.serverCategoryItemsPayload = nil

    quickLootController.ui.information.vipPanel.premium:setOn(not g_game.getLocalPlayer():isPremium())
    QuickLoot.load()
    for itemId, itemName in pairs(QuickLoot.data.itemNames or {}) do
        QuickLoot.cacheItemName(itemId, itemName)
    end

    g_game.requestQuickLootBlackWhiteList(getFilter(QuickLoot.data.filter),
        #QuickLoot.data.loots[QuickLoot.data.filter], QuickLoot.data.loots[QuickLoot.data.filter])
end

function quickLootController:onGameEnd()
    if not g_game.getFeature(GameThingQuickLoot) then
        return
    end
    QuickLoot.save()
    QuickLoot.toggle()
    if quickLootController.ui:isVisible() then
        quickLootController.ui:hide()
    end
end

function QuickLoot.Define()
    function QuickLoot.filter(widget, isChecked)
        widget:setChecked(true)

        isChecked = true

        local accepted = quickLootController.ui.filters.accepted
        local skipped = quickLootController.ui.filters.skipped
        local add_text = string.format("Add to %s Loot List", widget:getId():gsub("^%l", string.upper))
        local clear_text = string.format("Clear %s Loot List", widget:getId():gsub("^%l", string.upper))

        if widget == skipped and isChecked then
            quickLootController.ui.filters.accepted:setChecked(false)
            quickLootController.ui.filters.add:setText(add_text)
            quickLootController.ui.filters.clear:setText(clear_text)

            QuickLoot.data.filter = 1
        end

        if widget == accepted and isChecked then
            quickLootController.ui.filters.skipped:setChecked(false)
            quickLootController.ui.filters.add:setText(add_text)
            quickLootController.ui.filters.clear:setText(clear_text)

            QuickLoot.data.filter = 2
        end

        if not QuickLoot.suppressFilterSyncRequest then
            g_game.requestQuickLootBlackWhiteList(getFilter(QuickLoot.data.filter),
                #QuickLoot.data.loots[QuickLoot.data.filter], QuickLoot.data.loots[QuickLoot.data.filter])
        end
        QuickLoot.loadFilterItems()
    end

    function QuickLoot.lootExists(itemId, filter)
        if not filter then
            filter = QuickLoot.data.filter
        end
        return table.contains(QuickLoot.data.loots[filter], itemId)
    end

    function QuickLoot.addLootList(itemId,filter)
        if not filter then
            filter = QuickLoot.data.filter
        end
        if table.contains(QuickLoot.data.loots[filter], itemId) then
            return
        end

        table.insert(QuickLoot.data.loots[filter], itemId)

        g_game.requestQuickLootBlackWhiteList(getFilter(filter),
            #QuickLoot.data.loots[filter], QuickLoot.data.loots[filter])
        if quickLootController.ui:isVisible() then
            QuickLoot.loadFilterItems()
        end
    end
    function QuickLoot.clearFilterItems()
        QuickLoot.data.loots[QuickLoot.data.filter] = {}

        g_game.requestQuickLootBlackWhiteList(getFilter(QuickLoot.data.filter),
            #QuickLoot.data.loots[QuickLoot.data.filter], QuickLoot.data.loots[QuickLoot.data.filter])
        QuickLoot.loadFilterItems()
    end

    function QuickLoot.removeLootList(itemId, filter)
        if not filter then
            filter = QuickLoot.data.filter
        end
        if not table.contains(QuickLoot.data.loots[filter], itemId) then
            return
        end

        table.removevalue(QuickLoot.data.loots[filter], itemId)

        g_game.requestQuickLootBlackWhiteList(getFilter(filter),
            #QuickLoot.data.loots[filter], QuickLoot.data.loots[filter])
        if quickLootController.ui:isVisible() then
            QuickLoot.loadFilterItems()
        end
    end

    function QuickLoot.load()
        local file = string.format("/settings/%s_containers.json",
            g_game.getLocalPlayer():getName():lower():gsub("%s+", "_"))

        if g_resources.fileExists(file) then
            local status, result = pcall(function()
                return json.decode(g_resources.readFileContents(file))
            end)

            if not status then
                return g_logger.error("Error while reading containers settings file. " .. result)
            end

            if result == nil then
                QuickLoot.data = {
                    filter = 1,
                    selectedCategoryId = 1,
                    categories = {
                        { id = 1, name = "General" }
                    },
                    categoryItems = {},
                    collapsedCategories = {},
                    loots = {{}, {}}
                }
            else
                QuickLoot.data = result
            end

        else
            QuickLoot.data = {
                filter = 1,
                selectedCategoryId = 1,
                categories = {
                    { id = 1, name = "General" }
                },
                categoryItems = {},
                collapsedCategories = {},
                loots = {{}, {}}
            }
        end

        local normalizedCategories = {}
        local seenCategories = {}
        for key, category in pairs(QuickLoot.data.categories or {}) do
            local categoryId = nil
            local categoryName = nil

            if type(category) == "table" then
                categoryId = tonumber(category.id) or tonumber(key)
                if categoryId then
                    categoryName = tostring(category.name or string.format("Category %d", categoryId))
                end
            else
                categoryId = tonumber(category) or tonumber(key)
                if categoryId then
                    categoryName = string.format("Category %d", categoryId)
                end
            end

            if categoryId and categoryId > 0 and not seenCategories[categoryId] then
                table.insert(normalizedCategories, {
                    id = categoryId,
                    name = categoryName
                })
                seenCategories[categoryId] = true
            end
        end

        if #normalizedCategories == 0 then
            normalizedCategories = {
                { id = 1, name = "General" }
            }
        end

        table.sort(normalizedCategories, function(a, b)
            return tonumber(a.id) < tonumber(b.id)
        end)

        QuickLoot.data.categories = normalizedCategories

        if not QuickLoot.data.categoryItems then
            QuickLoot.data.categoryItems = {}
        end

        if not QuickLoot.data.itemNames then
            QuickLoot.data.itemNames = {}
        end

        if not QuickLoot.data.collapsedCategories then
            QuickLoot.data.collapsedCategories = {}
        end

        if not QuickLoot.data.selectedCategoryId then
            QuickLoot.data.selectedCategoryId = tonumber(QuickLoot.data.categories[1].id) or 1
        elseif not QuickLoot.getCategoryById(QuickLoot.data.selectedCategoryId) then
            QuickLoot.data.selectedCategoryId = tonumber(QuickLoot.data.categories[1].id) or 1
        end
    end

    function QuickLoot.refreshCategoryView()
        if not quickLootController.ui or not quickLootController.ui:isVisible() then
            return
        end

        QuickLoot.start(
            quickLootController.ui.fallbackPanel.checkbox:isChecked(),
            QuickLoot.serverLootContainers or {},
            QuickLoot.serverCategoryItemsPayload
        )
    end

    function QuickLoot.getCategoryById(id)
        for _, category in ipairs(QuickLoot.data.categories) do
            if tonumber(category.id) == tonumber(id) then
                return category
            end
        end
        return nil
    end

    function QuickLoot.ensureCategory(id, fallbackName)
        local category = QuickLoot.getCategoryById(id)
        if category then
            return category
        end

        category = {
            id = tonumber(id),
            name = fallbackName or string.format("Category %d", tonumber(id))
        }
        table.insert(QuickLoot.data.categories, category)
        table.sort(QuickLoot.data.categories, function(a, b)
            return tonumber(a.id) < tonumber(b.id)
        end)
        return category
    end

    function QuickLoot.createCategory()
        local used = {}
        for _, category in ipairs(QuickLoot.data.categories) do
            used[tonumber(category.id)] = true
        end

        local nextId = nil
        for i = 1, MAX_DYNAMIC_CATEGORIES do
            if not used[i] then
                nextId = i
                break
            end
        end

        if not nextId then
            displayInfoBox(tr("Quick Loot"), tr("Maximum amount of categories reached."))
            return
        end

        QuickLoot.ensureCategory(nextId, string.format("Category %d", nextId))
        QuickLoot.data.selectedCategoryId = nextId
        QuickLoot.save()
        QuickLoot.refreshCategoryView()
        QuickLoot.reloadCategoryItemsWindow()
    end

    function QuickLoot.showCategoryNameWindow(defaultName, onConfirm)
        if QuickLoot.categoryNameWindow then
            QuickLoot.categoryNameWindow:destroy()
            QuickLoot.categoryNameWindow = nil
        end

        local window = g_ui.displayUI("quickloot_categoryname")
        window.onEnter = QuickLoot.confirmCategoryName
        window.onEscape = QuickLoot.cancelCategoryName
        if window.confirmButton then
            window.confirmButton.onClick = QuickLoot.confirmCategoryName
        end
        if window.cancelButton then
            window.cancelButton.onClick = QuickLoot.cancelCategoryName
        end
        window:show()
        window:raise()
        window:focus()

        window.name:setText(defaultName or "")
        window.name:focus()
        window.name:setCursorPos(#window.name:getText())

        QuickLoot.categoryNameWindow = window
        QuickLoot.onConfirmCategoryName = onConfirm
    end

    function QuickLoot.getCategoryItems(categoryId)
        return QuickLoot.data.categoryItems[tostring(categoryId)] or {}
    end

    function QuickLoot.extractNameFromTooltip(tooltip)
        if not tooltip or tooltip == "" then
            return nil
        end

        local raw = tostring(tooltip):gsub("\r", "")
        local cleaned = raw:gsub("\n", " ")
        local fromSee = cleaned:match("You see an? ([^%.]+)")
        if fromSee and fromSee ~= "" then
            return fromSee
        end

        -- Fallback: some tooltips use first-line item name format
        local firstLine = raw:match("^%s*([^\n]+)")
        if firstLine and firstLine ~= "" then
            firstLine = tostring(firstLine):gsub("^%s+", ""):gsub("%s+$", "")
            if firstLine ~= "" and not firstLine:lower():find("^weight:") and not firstLine:lower():find("^vol:") then
                return firstLine
            end
        end

        return nil
    end

    function QuickLoot.cacheItemName(itemId, itemName)
        local normalizedId = tonumber(itemId) or 0
        local normalizedName = tostring(itemName or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if normalizedId <= 0 or normalizedName == "" or normalizedName == "Unknown Item" then
            return
        end

        QuickLoot.serverCategoryItemNames[normalizedId] = normalizedName
        QuickLoot.data.itemNames[tostring(normalizedId)] = normalizedName
    end

    function QuickLoot.applyServerCategoryItems(categoryItems)
        if categoryItems == nil then
            return
        end

        QuickLoot.serverCategoryItemsPayload = categoryItems
        QuickLoot.serverCategoryItemNames = QuickLoot.serverCategoryItemNames or {}

        local mappedByCategory = {}
        for _, mapping in ipairs(categoryItems or {}) do
            local categoryId = tonumber(mapping[1]) or 0
            local itemId = tonumber(mapping[2]) or 0
            local itemName = tostring(mapping[3] or "")

            if itemId > 0 then
                QuickLoot.cacheItemName(itemId, itemName)
            end

            if categoryId > 0 and itemId > 0 then
                local categoryKey = tostring(categoryId)
                mappedByCategory[categoryKey] = mappedByCategory[categoryKey] or {}
                if not table.contains(mappedByCategory[categoryKey], itemId) then
                    table.insert(mappedByCategory[categoryKey], itemId)
                end

                QuickLoot.ensureCategory(categoryId, string.format("Category %d", categoryId))
            end
        end

        QuickLoot.data.categoryItems = mappedByCategory
    end

    function QuickLoot.getItemDisplayName(itemId)
        local normalizedId = tonumber(itemId) or 0
        local serverName = QuickLoot.serverCategoryItemNames and QuickLoot.serverCategoryItemNames[normalizedId]
        if serverName and serverName ~= "" then
            QuickLoot.cacheItemName(normalizedId, serverName)
            return serverName
        end

        local cachedName = QuickLoot.data.itemNames and QuickLoot.data.itemNames[tostring(normalizedId)]
        if cachedName and cachedName ~= "" then
            return cachedName
        end

        local staticItem = Item.create(normalizedId)
        if staticItem then
            local tooltipName = QuickLoot.extractNameFromTooltip(staticItem:getTooltip())
            if tooltipName then
                QuickLoot.cacheItemName(normalizedId, tooltipName)
                return tooltipName
            end
        end

        local thingType = g_things.getThingType(normalizedId, ThingCategoryItem)
        if not thingType then
            return tr("Unknown Item")
        end

        local name = thingType:getName()
        if name and name ~= "" then
            QuickLoot.cacheItemName(normalizedId, name)
            return name
        end

        local description = thingType:getDescription()
        if description and description ~= "" then
            local extracted = description:match("You see an? ([^%.]+)")
            if extracted and extracted ~= "" then
                QuickLoot.cacheItemName(normalizedId, extracted)
                return extracted
            end
        end

        return tr("Unknown Item")
    end

    function QuickLoot.isCategoryCollapsed(categoryId)
        return QuickLoot.data.collapsedCategories[tostring(categoryId)] == true
    end

    function QuickLoot.toggleCategoryCollapse(categoryId)
        local key = tostring(categoryId)
        QuickLoot.data.collapsedCategories[key] = not QuickLoot.isCategoryCollapsed(categoryId)
        QuickLoot.save()
        QuickLoot.refreshCategoryView()
    end

    function QuickLoot.removeCategoryItem(categoryId, itemId)
        local categoryKey = tostring(categoryId)
        local items = QuickLoot.data.categoryItems[categoryKey] or {}
        local serverPayload = QuickLoot.serverCategoryItemsPayload or {}

        if not table.contains(items, itemId) then
            return
        end

        table.removevalue(items, itemId)
        QuickLoot.data.categoryItems[categoryKey] = items

        for index = #serverPayload, 1, -1 do
            local mapping = serverPayload[index]
            if tonumber(mapping[1]) == tonumber(categoryId) and tonumber(mapping[2]) == tonumber(itemId) then
                table.remove(serverPayload, index)
            end
        end

        QuickLoot.serverCategoryItemsPayload = serverPayload

        QuickLoot.serverCategoryItemNames[itemId] = nil
        g_game.openContainerQuickLoot(8, categoryId, {}, itemId, 0, nil)
        QuickLoot.save()
        QuickLoot.refreshCategoryView()
        QuickLoot.reloadCategoryItemsWindow()
    end

    function QuickLoot.closeCategoryItemsWindow()
        if QuickLoot.categoryItemsWindow then
            QuickLoot.categoryItemsWindow:destroy()
            QuickLoot.categoryItemsWindow = nil
        end
    end

    function QuickLoot.reloadCategoryItemsWindow()
        local window = QuickLoot.categoryItemsWindow
        if not window then
            return
        end

        local categoryId = tonumber(window:getId()) or 0
        local category = QuickLoot.getCategoryById(categoryId)
        if not category then
            QuickLoot.closeCategoryItemsWindow()
            return
        end

        window:setText(string.format("%s - %s", category.name, tr("Items")))
        window.list:destroyChildren()
        local color = "#484848"

        for _, itemId in ipairs(QuickLoot.getCategoryItems(categoryId)) do
            local row = g_ui.createWidget("QuickLootCategoryItem", window.list)

            row:setBackgroundColor(color)
            row.label:setText(QuickLoot.getItemDisplayName(itemId))
            row.item:setItemId(itemId)
            row.remove.onClick = function()
                QuickLoot.removeCategoryItem(categoryId, itemId)
            end

            color = color == "#484848" and "#414141" or "#484848"
        end
    end

    function QuickLoot.showSelectedCategoryItems()
        local categoryId = tonumber(QuickLoot.data.selectedCategoryId) or 0
        local category = QuickLoot.getCategoryById(categoryId)
        if not category then
            displayInfoBox(tr("Quick Loot"), tr("Select a category first."))
            return
        end

        if QuickLoot.categoryItemsWindow then
            QuickLoot.categoryItemsWindow:destroy()
            QuickLoot.categoryItemsWindow = nil
        end

        local window = g_ui.displayUI("quickloot_categoryitems")
        window:setId(categoryId)
        window.close.onClick = QuickLoot.closeCategoryItemsWindow
        QuickLoot.categoryItemsWindow = window

        QuickLoot.reloadCategoryItemsWindow()
        window:show()
        window:raise()
        window:focus()
    end

    function QuickLoot.confirmCategoryName()
        if not QuickLoot.categoryNameWindow then
            return
        end

        local name = QuickLoot.categoryNameWindow.name:getText() or ""
        name = name:gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then
            name = "Category"
        end

        if QuickLoot.onConfirmCategoryName then
            QuickLoot.onConfirmCategoryName(name)
        end

        QuickLoot.categoryNameWindow:destroy()
        QuickLoot.categoryNameWindow = nil
        QuickLoot.onConfirmCategoryName = nil
    end

    function QuickLoot.cancelCategoryName()
        if QuickLoot.categoryNameWindow then
            QuickLoot.categoryNameWindow:destroy()
            QuickLoot.categoryNameWindow = nil
        end
        QuickLoot.onConfirmCategoryName = nil
    end

    function QuickLoot.renameSelectedCategory()
        local category = QuickLoot.getCategoryById(QuickLoot.data.selectedCategoryId)
        if not category then
            displayInfoBox(tr("Quick Loot"), tr("Select a category first."))
            return
        end

        QuickLoot.showCategoryNameWindow(category.name, function(newName)
            category.name = newName
            QuickLoot.save()
            QuickLoot.refreshCategoryView()
        end)
    end

    function QuickLoot.deleteSelectedCategory()
        local categoryId = tonumber(QuickLoot.data.selectedCategoryId) or 0
        local serverPayload = QuickLoot.serverCategoryItemsPayload or {}
        if categoryId <= 0 then
            displayInfoBox(tr("Quick Loot"), tr("Select a category first."))
            return
        end

        local category = QuickLoot.getCategoryById(categoryId)
        if not category then
            return
        end

        local categoryKey = tostring(categoryId)
        local items = QuickLoot.data.categoryItems[categoryKey] or {}

        for _, itemId in ipairs(items) do
            g_game.openContainerQuickLoot(8, categoryId, {}, itemId, 0, nil)
        end

        for index = #serverPayload, 1, -1 do
            local mapping = serverPayload[index]
            if tonumber(mapping[1]) == tonumber(categoryId) then
                QuickLoot.serverCategoryItemNames[tonumber(mapping[2]) or 0] = nil
                table.remove(serverPayload, index)
            end
        end

        QuickLoot.serverCategoryItemsPayload = serverPayload

        g_game.openContainerQuickLoot(1, categoryId, {}, nil, nil, nil)
        QuickLoot.data.categoryItems[categoryKey] = nil
        QuickLoot.data.collapsedCategories[categoryKey] = nil

        for i, categoryData in ipairs(QuickLoot.data.categories) do
            if tonumber(categoryData.id) == categoryId then
                table.remove(QuickLoot.data.categories, i)
                break
            end
        end

        if #QuickLoot.data.categories == 0 then
            QuickLoot.data.categories = {
                { id = 1, name = "General" }
            }
        end

        QuickLoot.data.selectedCategoryId = tonumber(QuickLoot.data.categories[1].id) or 1

        local newContainers = {}
        for _, container in pairs(QuickLoot.serverLootContainers or {}) do
            if tonumber(container[1]) ~= categoryId then
                table.insert(newContainers, container)
            end
        end
        QuickLoot.serverLootContainers = newContainers

        QuickLoot.save()
        QuickLoot.refreshCategoryView()
    end

    function QuickLoot.save()
        local file = string.format("/settings/%s_containers.json",
            g_game.getLocalPlayer():getName():lower():gsub("%s+", "_"))
        local status, result = pcall(function()
            return json.encode(QuickLoot.data, 2)
        end)

        if not status then
            return g_logger.warning("Error while saving QuickLoot settings. Data won't be saved. Details: " .. result)
        end

        if result:len() > 104857600 then
            return g_logger.error("Something went wrong, file is above 100MB, won't be saved")
        end

        g_resources.writeFileContents(file, result)
    end

    function QuickLoot.start(quickLootFallbackToMainContainer, lootContainers, categoryItems)
        local player = g_game.getLocalPlayer()
        local vipPanel = quickLootController.ui.information.vipPanel
        local loots = lootContainers
        local fallback = quickLootFallbackToMainContainer
        QuickLoot.serverQuickLootFallback = fallback
        QuickLoot.serverLootContainers = lootContainers
        QuickLoot.applyServerCategoryItems(categoryItems)

        QuickLoot.loadFilterItems()

        local filter = {
            [1] = "skipped",
            [2] = "accepted"
        }

        QuickLoot.suppressFilterSyncRequest = true
        QuickLoot.filter(quickLootController.ui.filters[filter[QuickLoot.data.filter]], true)
        QuickLoot.suppressFilterSyncRequest = false
        quickLootController.ui.list:getLayout():disableUpdates()
        quickLootController.ui.list:destroyChildren()

        quickLootController.ui.fallbackPanel.checkbox:setChecked(fallback)
        for _, container in pairs(lootContainers) do
            QuickLoot.ensureCategory(container[1], string.format("Category %d", container[1]))
        end

        for index, slot in ipairs(QuickLoot.data.categories) do
            local widget = g_ui.createWidget("QuicklootBagLabel", quickLootController.ui.list)
            local id = tonumber(slot.id) or 0
            local isSelected = tonumber(QuickLoot.data.selectedCategoryId) == id
            local categoryItemCount = #QuickLoot.getCategoryItems(id)
            local isCollapsed = QuickLoot.isCategoryCollapsed(id)

            widget:setId(id)
            widget:setBackgroundColor(isSelected and "#5a7a5a" or (index % 2 == 0 and "#414141" or "#484848"))
            widget.label:setText(string.format("%s (%d)", slot.name, categoryItemCount))
            widget.collapse:setText(isCollapsed and "+" or "-")
            widget.collapse.onClick = function()
                QuickLoot.toggleCategoryCollapse(id)
            end
            widget.onClick = function()
                QuickLoot.data.selectedCategoryId = id
                QuickLoot.save()
                QuickLoot.refreshCategoryView()
            end

            for _, container in pairs(lootContainers) do
                if container[1] == id then
                    local lootContainerId = container[2]
                    widget.item:setItemId(lootContainerId)
                    break
                end
            end

            if not isCollapsed then
                local rowColor = "#333333"
                for _, itemId in ipairs(QuickLoot.getCategoryItems(id)) do
                    local mappedItemRow = g_ui.createWidget("QuickLootCategoryMappedItem", quickLootController.ui.list)

                    mappedItemRow:setBackgroundColor(rowColor)
                    mappedItemRow.label:setText(QuickLoot.getItemDisplayName(itemId))
                    mappedItemRow.item:setItemId(itemId)
                    mappedItemRow.remove.onClick = function()
                        QuickLoot.removeCategoryItem(id, itemId)
                    end

                    rowColor = rowColor == "#333333" and "#2f2f2f" or "#333333"
                end
            end
        end
        quickLootController.ui.list:getLayout():enableUpdates()
        quickLootController.ui.list:getLayout():update()
    end

    function QuickLoot.loadFilterItems()
        quickLootController.ui.ignoreList:destroyChildren()

        local color = "#484848"

        for _, itemId in ipairs(QuickLoot.data.loots[QuickLoot.data.filter]) do
            local widget = g_ui.createWidget("QuicLootIgnoreItem", quickLootController.ui.ignoreList)

            widget:setId(itemId)
            widget:setBackgroundColor(color)
            widget.item:setItemId(itemId)

            local displayName = QuickLoot.getItemDisplayName(itemId)
            if displayName == tr("Unknown Item") and widget.item:getItem() then
                local tooltipName = QuickLoot.extractNameFromTooltip(widget.item:getItem():getTooltip())
                if tooltipName then
                    QuickLoot.cacheItemName(itemId, tooltipName)
                    displayName = tooltipName
                end
            end

            widget.label:setText(displayName)

            color = color == "#484848" and "#414141" or "#484848"
        end
    end

    function QuickLoot.search(text)
        return
    end

    function QuickLoot.clearSearch()
        local search = quickLootController.ui.search
        search:clearText()
    end

    function QuickLoot.fallback(widget, isChecked)
        g_game.openContainerQuickLoot(3, nil, {}, nil, nil, isChecked)
    end

    function QuickLoot:chooseItem()
        if g_ui.isMouseGrabbed() then
            return
        end

        QuickLoot.mouseGrabberWidget:grabMouse()
        g_mouse.pushCursor("target")

        QuickLoot.lastSelectBag = self:getParent()
        QuickLoot.selectMode = "container"

        quickLootController.ui:hide()
    end

    function QuickLoot:chooseCategoryItem()
        if g_ui.isMouseGrabbed() then
            return
        end

        QuickLoot.mouseGrabberWidget:grabMouse()
        g_mouse.pushCursor("target")

        QuickLoot.lastSelectBag = self:getParent()
        QuickLoot.selectMode = "categoryItem"

        quickLootController.ui:hide()
    end

    function QuickLoot.chooseLootItem()
        if g_ui.isMouseGrabbed() then
            return
        end

        QuickLoot.mouseGrabberWidget:grabMouse()
        g_mouse.pushCursor("target")

        QuickLoot.lastSelectBag = nil
        QuickLoot.selectMode = "filterItem"

        quickLootController.ui:hide()
    end

    function QuickLoot.confirmError()
        QuickLoot.ErrorWindow:destroy()
        quickLootController.ui:show()
    end

    function QuickLoot:onChooseItem(mousePosition, mouseButton)
        local item

        local function applyChosenItem(selectedItem)
            if not selectedItem then
                return
            end

            if QuickLoot.selectMode == "categoryItem" then
                local categoryId = tonumber(QuickLoot.lastSelectBag:getId()) or 0
                local categoryKey = tostring(categoryId)
                QuickLoot.serverCategoryItemsPayload = QuickLoot.serverCategoryItemsPayload or {}
                QuickLoot.data.categoryItems[categoryKey] = QuickLoot.data.categoryItems[categoryKey] or {}
                local selectedName = QuickLoot.extractNameFromTooltip(selectedItem:getTooltip())
                QuickLoot.cacheItemName(selectedItem:getId(), selectedName)
                if not table.contains(QuickLoot.data.categoryItems[categoryKey], selectedItem:getId()) then
                    table.insert(QuickLoot.data.categoryItems[categoryKey], selectedItem:getId())

                    table.insert(QuickLoot.serverCategoryItemsPayload, {
                        categoryId,
                        selectedItem:getId(),
                        QuickLoot.getItemDisplayName(selectedItem:getId())
                    })
                end

                g_game.openContainerQuickLoot(7, categoryId, {}, selectedItem:getId(), 0, nil)
                QuickLoot.save()
                QuickLoot.refreshCategoryView()
                QuickLoot.reloadCategoryItemsWindow()
            elseif QuickLoot.selectMode == "filterItem" then
                local selectedName = QuickLoot.extractNameFromTooltip(selectedItem:getTooltip())
                QuickLoot.cacheItemName(selectedItem:getId(), selectedName)
                QuickLoot.addLootList(selectedItem:getId())
                QuickLoot.save()
            else
                local categoryId = tonumber(QuickLoot.lastSelectBag:getId()) or 0
                g_game.openContainerQuickLoot(0, categoryId,
                    selectedItem:getPosition(), selectedItem:getId(), selectedItem:getStackPos())
                QuickLoot.lastSelectBag.item:setItem(selectedItem)
            end
        end

        if mouseButton == MouseLeftButton then
            local clickedWidget = modules.game_interface.getRootPanel():recursiveGetChildByPos(mousePosition, false)

            if clickedWidget then
                if clickedWidget:getClassName() == "UIGameMap" then
                    local tile = clickedWidget:getTile(mousePosition)

                    if tile then
                        local thing = tile:getTopMoveThing()

                        local allowAnyItem = QuickLoot.selectMode == "categoryItem" or QuickLoot.selectMode == "filterItem"
                        if thing and ((allowAnyItem and thing:isItem()) or (not allowAnyItem and thing:isContainer())) then
                            item = thing
                            applyChosenItem(item)
                        else
                            local title = allowAnyItem and tr("Invalid Item") or tr("Invalid Loot Container")
                            local message = allowAnyItem
                                and tr("You can only select valid inventory or map items.")
                                or tr("You can only select containers you carry in your inventory.")

                            QuickLoot.ErrorWindow = displayGeneralBox(title, message, {
                                {
                                    text = tr("Ok"),
                                    callback = QuickLoot.confirmError
                                },
                                anchor = AnchorHorizontalCenter
                            })
                        end
                    end
                elseif clickedWidget:getClassName() == "UIItem" and not clickedWidget:isVirtual() then
                    if clickedWidget:getItem() and (QuickLoot.selectMode == "categoryItem" or QuickLoot.selectMode == "filterItem" or clickedWidget:getItem():isContainer()) then
                        item = clickedWidget:getItem()
                        applyChosenItem(item)
                    else
                        local title = (QuickLoot.selectMode == "categoryItem" or QuickLoot.selectMode == "filterItem") and tr("Invalid Item") or tr("Invalid Loot Container")
                        local message = (QuickLoot.selectMode == "categoryItem" or QuickLoot.selectMode == "filterItem")
                            and tr("You can only select valid inventory items.")
                            or tr("You can only select containers you carry in your inventory.")

                        QuickLoot.ErrorWindow = displayGeneralBox(title, message, {
                            {
                                text = tr("Ok"),
                                callback = QuickLoot.confirmError
                            },
                            anchor = AnchorHorizontalCenter
                        })
                    end
                end
            end
        end

        if item then
            quickLootController.ui:show()
        end

        g_mouse.popCursor("target")
        self:ungrabMouse()

        return true
    end

    function QuickLoot:openContainer()
        for _, container in pairs(g_game.getContainers()) do
            if container:getContainerItem():getId() == self:getItemId() then
                return false
            end
        end
        local categoryId = tonumber(self:getParent():getId()) or 0
        g_game.openContainerQuickLoot(5, categoryId, {}, nil, nil, nil)
        return true
    end

    function QuickLoot:clearItem()
        self:getParent().item:setItem(nil)
        local categoryId = tonumber(self:getParent():getId()) or 0
        g_game.openContainerQuickLoot(1, categoryId, {}, nil, nil, nil)
    end

    function QuickLoot:clearCategoryItems()
        local categoryId = tonumber(self:getParent():getId()) or 0
        local categoryKey = tostring(categoryId)
        local items = QuickLoot.data.categoryItems[categoryKey] or {}
        local serverPayload = QuickLoot.serverCategoryItemsPayload or {}

        for _, itemId in ipairs(items) do
            g_game.openContainerQuickLoot(8, categoryId, {}, itemId, 0, nil)
        end

        for index = #serverPayload, 1, -1 do
            local mapping = serverPayload[index]
            if tonumber(mapping[1]) == tonumber(categoryId) then
                QuickLoot.serverCategoryItemNames[tonumber(mapping[2]) or 0] = nil
                table.remove(serverPayload, index)
            end
        end

        QuickLoot.serverCategoryItemsPayload = serverPayload

        QuickLoot.data.categoryItems[categoryKey] = {}
        QuickLoot.save()
        QuickLoot.refreshCategoryView()
        QuickLoot.reloadCategoryItemsWindow()
    end

    function QuickLoot:clearFilterItem()
        QuickLoot.removeLootList(self:getParent().item:getItemId())

        QuickLoot.loadFilterItems()
    end

    function QuickLoot.toggle()
        if not quickLootController.ui then
            return
        end

        if quickLootController.ui:isVisible() then
            return QuickLoot.hide()
        end
        QuickLoot.show()
        QuickLoot.loadFilterItems()
        if QuickLoot.data.filter == 2 and not quickLootController.ui.filters.accepted:isChecked() then
            quickLootController.ui.filters.accepted:onClick()
        end
    end

    function QuickLoot.show()
        if not quickLootController.ui then
            return
        end

        quickLootController.ui:show()
        quickLootController.ui:raise()
        quickLootController.ui:focus()

        QuickLoot.start(
            QuickLoot.serverQuickLootFallback or quickLootController.ui.fallbackPanel.checkbox:isChecked(),
            QuickLoot.serverLootContainers or {},
            QuickLoot.serverCategoryItemsPayload
        )

    end

    function QuickLoot.hide()
        if not quickLootController.ui then
            return
        end
        quickLootController.ui:hide()
    end

end
