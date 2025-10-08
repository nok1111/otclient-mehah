-- Bottom-right Menu module: creates a grid of 48x48 buttons inside bottomRightPanel2
-- Mirrors client_topmenu addButton API but renders into bottomRightPanel2Buttons container.

local container

local function getContainer()
  if not container then
    local p2 = modules.game_interface.getBottomRightPanel2()
    if not p2 then return nil end
    container = p2:getChildById('bottomRightPanel2Buttons')
    if not container then
      -- create dynamically if missing
      container = g_ui.createWidget('UIWidget', p2)
      container:setId('bottomRightPanel2Buttons')
      container:breakAnchors()
      container:addAnchor(AnchorLeft, 'parent', AnchorLeft)
      container:addAnchor(AnchorRight, 'parent', AnchorRight)
      container:addAnchor(AnchorTop, 'parent', AnchorTop)
      container:addAnchor(AnchorBottom, 'parent', AnchorBottom)
      container:setMarginTop(8)
      container:setMarginLeft(8)
      container:setMarginRight(8)
      container:setMarginBottom(8)
      container:setVisible(true)
    end
  end
  return container
end

local function layout()
  local c = getContainer()
  if not c then return end
  local btnSize, spacing, cols = 48, 6, 4
  local col, row = 0, 0
  for _, child in ipairs(c:getChildren()) do
    if child:isVisible() then
      child:setWidth(btnSize)
      child:setHeight(btnSize)
      -- Anchor-based absolute positioning so it works with anchor layout
      local x = col * (btnSize + spacing)
      local y = row * (btnSize + spacing)
      child:breakAnchors()
      child:addAnchor(AnchorLeft, 'parent', AnchorLeft)
      child:addAnchor(AnchorTop, 'parent', AnchorTop)
      child:setMarginLeft(x)
      child:setMarginTop(y)
      col = col + 1
      if col >= cols then col = 0; row = row + 1 end
    end
  end
end

local function addButtonInternal(id, description, icon, callback, togglable, front)
  local c = getContainer()
  if not c then
    scheduleEvent(function() addButtonInternal(id, description, icon, callback, togglable, front) end, 150)
    return nil
  end
  local existing = id and c:recursiveGetChildById(id) or nil
  if existing then return existing end

  -- Use the same classes the top menu uses so visuals (icons/text) show up predictably
  local class = togglable and 'TopToggleButton' or 'TopButton'
  local btn = g_ui.createWidget(class, c)
  if id then btn:setId(id) end
  if description then btn:setTooltip(description) end
  if togglable then
    if icon then btn:setIcon(resolvepath(icon, 3)) end
  else
    -- For TopButton the topmenu shows text, keep same convention
    btn:setText(description or '')
  end
  btn:setFocusable(false)
  btn:setVisible(true)
  -- Force 48x48 size for our grid
  btn:setWidth(48)
  btn:setHeight(48)

  if togglable then
    -- Do not toggle state here; let the consumer manage setOn/isOn in onOpen/onClose
    btn.onMouseRelease = function(widget, mousePos, mouseButton)
      if widget:containsPoint(mousePos) and mouseButton ~= MouseMidButton then
        print('[brmenu] toggle click id=' .. (widget:getId() or '?'))
        if callback then callback(widget) end
        return true
      end
    end
  else
    btn.onMouseRelease = function(widget, mousePos, mouseButton)
      if widget:containsPoint(mousePos) and mouseButton ~= MouseMidButton then
        if callback then callback(widget) end
        return true
      end
    end
  end

  if front then c:moveChildToIndex(btn, 1) end
  layout()
  print(string.format('[brmenu] added button id=%s togglable=%s', tostring(id), tostring(togglable)))
  return btn
end

-- Public API
function init()
  print('[brmenu] init')
  -- Relayout on container geometry changes
  local c = getContainer()
  if c and not c._hooked then
    c.onGeometryChange = function()
      scheduleEvent(layout, 1)
    end
    c._hooked = true
  end
  -- Ensure an initial layout happens after interface shows
  addEvent(function() layout() end, 200)
end

function terminate()
  container = nil
end

function addButton(id, description, icon, callback, front)
  return addButtonInternal(id, description, icon, callback, false, front)
end

function addToggleButton(id, description, icon, callback, front)
  return addButtonInternal(id, description, icon, callback, true, front)
end
