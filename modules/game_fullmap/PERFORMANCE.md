# Performance Optimizations - Full Map System

## Issues Identified

### 1. Frame Drops While Walking
**Problem:** Position updates running at 100ms (10 times per second) caused frame drops  
**Solution:** Reduced to 500ms (2 times per second) - still responsive but much lighter

### 2. Map Reloading
**Problem:** OTBM map was being loaded every time window opened  
**Solution:** Added `mapLoaded` flag - map only loads once per game session

### 3. Unnecessary Updates
**Problem:** Updates running even when window closed  
**Solution:** Only update when `fullMapWindow:isVisible()` is true

## Current Optimizations

### Update Frequency
```lua
scheduleUpdate() -- Runs every 500ms instead of 100ms
```
- **Before:** 10 updates/second = high CPU usage
- **After:** 2 updates/second = minimal impact
- Only updates position label and zoom label
- Only runs when window is visible

### Map Loading
```lua
local mapLoaded = false
if mapLoaded then return end -- Skip reload
```
- OTBM loads once on first game start
- Subsequent opens reuse loaded map
- Flag resets on game end for next session
- Prevents expensive file I/O and parsing

### Lazy Initialization
```lua
if not fullMapWindow then
  -- Create window only when needed
end
```
- Window created on first show(), not on init()
- Reduces startup time
- Handles cases where rootWidget not ready

## Zoom Configuration

### Default Settings
- **Default Zoom:** 11x (minimap-like top-down view)
- **Min Zoom:** 1x (very zoomed out)
- **Max Zoom:** 30x (very close up)
- **Zoom Controls:** +/- buttons in UI

### Why Zoom 11?
- Provides good overview of surrounding area
- Similar to traditional minimap view
- Shows enough detail to navigate
- Can zoom in/out as needed

## Best Practices

### When to Open Full Map
✅ **Good:** Open when you need to navigate or find NPCs  
✅ **Good:** Use for planning routes  
❌ **Avoid:** Keeping open while actively playing/walking  
❌ **Avoid:** Opening/closing repeatedly  

### Performance Tips
1. **Close when not needed** - Updates stop when window hidden
2. **Use zoom controls** - Higher zoom = less rendering
3. **Use NPC list** - Click to navigate instead of panning
4. **Center on player** - Quick way to find yourself

## Technical Details

### OTBM Loading
The OTBM file contains:
- All map tiles and terrain
- All items and decorations
- All NPCs and monsters (in their spawn positions)
- Houses, waypoints, towns

Loading this is expensive (file I/O + parsing), so we only do it once.

### UIMap Rendering
UIMap is a native C++ widget that:
- Renders map tiles efficiently
- Handles zoom and camera position
- Uses hardware acceleration when available
- Doesn't support custom overlays (unlike UIMinimap)

### Update Loop
```lua
scheduleUpdate() -> updatePlayerPosition() -> scheduleEvent(500ms)
```
- Checks if window visible
- Updates position label
- Updates zoom label
- Schedules next update
- Low overhead when window closed

## Monitoring Performance

### Console Commands (F12)
```lua
-- Check if map loaded
print(modules.game_fullmap.mapLoaded)

-- Check current zoom
print(modules.game_fullmap.mapView:getZoom())

-- Check update event status
print(modules.game_fullmap.updateEvent)
```

### Expected Behavior
- **Opening window:** Should be instant (map already loaded)
- **Closing window:** Updates stop immediately
- **Walking with window open:** Minimal FPS impact (2 updates/sec)
- **Walking with window closed:** Zero impact

## Future Improvements

If performance is still an issue:
1. Increase update interval to 1000ms (1 second)
2. Disable updates entirely - manual refresh only
3. Use OTCM instead of OTBM (lighter format)
4. Reduce max zoom to limit rendering area
5. Add "pause updates" toggle button
