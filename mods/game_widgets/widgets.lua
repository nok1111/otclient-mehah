-- tile_widget_display.lua
local widgetList = {} -- To store widgets created on specific tiles

function addTileWidgetonMap(position, text)
    local tile = g_map.getTile(position)
    if not tile then
        return false
    end

    local widget = g_ui.createWidget('Panel')
    widget:setSize({width = 90, height = 22})
    widget:setText(text)
    widget:setFont("terminus-10px")
    widget:setBackgroundColor('#111111cc')
    widget:setMarginBottom(40)

    tile:attachWidget(widget)
    table.insert(widgetList, widget)
end

function removeTileWidgets()
    for _, widget in ipairs(widgetList) do
        widget:destroy()
    end
    widgetList = {}
end


function setupTileWidgets()
    -- Replace with actual positions and text for each widget
    addTileWidgetonMap({x=284, y=753, z=7}, "Widget 1")
    --addTileWidget({x=102, y=100, z=7}, "Widget 2")
end

function clearTileWidgets()
    removeTileWidgets()
end

setupTileWidgets()