# Technical Notes - Full Map System

## UIMap vs UIMinimap

### Important Differences

**UIMinimap:**
- Supports `centerInPosition(widget, pos)` for positioning child widgets
- Can display flags, markers, and custom widgets on the map
- Has built-in cross/player marker support
- Designed for interactive minimap with overlays

**UIMap:**
- Does NOT support `centerInPosition()` - this method doesn't exist
- Cannot position child widgets on the map surface
- Only displays the raw map data (OTBM/OTCM)
- Use `setCameraPosition(pos)` to navigate the map view
- Simpler widget focused on map display only

## Current Implementation

### What Works
✅ Loading OTBM map files  
✅ Displaying full map view  
✅ Centering camera on positions with `setCameraPosition()`  
✅ NPC list with click-to-center functionality  
✅ Player position tracking and auto-centering  
✅ Zoom controls (1x-4x)  

### What Doesn't Work (UIMap Limitations)
❌ Visual NPC markers on the map surface  
❌ Player position marker overlay  
❌ Custom widgets positioned on map  

### Workaround
The OTBM map file itself contains all NPCs and creatures in their positions, so they are visible in the map naturally. The NPC list provides navigation - clicking an NPC centers the map on that position.

## Error History

### Error 1: Opcode Conflict
**Problem:** Opcode 200 already in use by another module  
**Solution:** Changed to opcode 210  

### Error 2: centerInPosition doesn't exist
**Problem:** Tried to use UIMinimap method on UIMap widget  
**Solution:** Removed marker positioning, use setCameraPosition for navigation only  

### Error 3: fullMapWindow nil errors
**Problem:** Widget accessed before creation  
**Solution:** Added lazy initialization and nil checks throughout  

## Best Practices

1. **Always check if widgets exist** before accessing them
2. **Use setCameraPosition()** for map navigation, not widget positioning
3. **UIMap is for display only** - don't try to add overlays
4. **NPC list is the UI** - map is the view
5. **OTBM contains everything** - NPCs, monsters, items all visible naturally

## Future Improvements

If visual markers are needed:
1. Use a separate overlay widget on top of UIMap
2. Calculate screen positions from world coordinates
3. Update overlay positions when map camera moves
4. This is complex - current list-based approach is simpler
