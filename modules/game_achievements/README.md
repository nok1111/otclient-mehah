# 🏆 Achievement System - Client UI

## 📦 Installation

### Files Created:
```
modules/game_achievements/
├── achievements.otmod      # Module definition
├── achievements.lua        # Client logic
├── achievements.otui       # UI layout
└── README.md              # This file
```

### Auto-loaded on client start
The module will auto-load when the client starts.

---

## 🎮 Usage

### Opening the Achievement Window

**Method 1:** Click the achievement button in the top menu  
**Method 2:** Press `Ctrl+H` hotkey

### Navigation

1. **Categories** - Click category buttons on the left panel
2. **Achievements** - Scroll through achievements in the main panel
3. **Claim Rewards** - Click "Claim" button on completed achievements
4. **Progress** - Progress bars show completion percentage

---

## 🎨 UI Features

### Window Layout

```
┌─────────────────────────────────────┐
│ 🏆 Achievements   [Stats Display]  │
├──────────┬──────────────────────────┤
│Categories│ Achievement List         │
│          │                          │
│⚔ Combat │ ┌────────────────────┐  │
│🗺 Explor│ │ [Icon] Achievement  │  │
│📦 Collec│ │ Description...      │  │
│👥 Social│ │ Progress: 50/100    │  │
│🎯 Skills│ │ [████████░░] 50%    │  │
│⭐ Special│ │ 10 pts    [CLAIM]   │  │
│          │ └────────────────────┘  │
└──────────┴──────────────────────────┘
```

### Achievement Item Display

Each achievement shows:
- **Icon** - Creature outfit or item sprite
- **Name** - Achievement title (or "???" for uncompleted secrets)
- **Description** - What you need to do
- **Progress Bar** - Visual progress (current/required)
- **Points** - Achievement points value
- **Status Icon** - Locked 🔒 / Completed ✓ / Claimed ⭐
- **Claim Button** - Appears when ready to claim

### Status Colors

- **Green Background** - Claimed
- **Yellow Background** - Completed but not claimed
- **Normal Background** - In progress or locked

---

## 🔧 Customization

### Adding Custom Icons

Icons can be:
1. **Creature Outfits** - Uses creature looktype
2. **Item Sprites** - Uses item ID
3. **Custom Images** - PNG/JPG files (requires assets)

### Changing Hotkey

In `achievements.lua`, change:
```lua
g_keyboard.bindKeyDown('Ctrl+H', toggle)
```

---

## 📡 Network Communication

### Extended Opcodes

**Range: 81-86** (avoiding conflicts with NPC Dialog at 80)

| Opcode | Direction | Purpose |
|--------|-----------|---------|
| 81 | Server→Client | Send achievement list |
| 82 | Server→Client | Progress update |
| 83 | Server→Client | Achievement completed |
| 84 | Client→Server | Claim reward request |
| 85 | Client→Server | Request category data |
| 86 | Server→Client | Stats update |

### Data Format

All data sent as JSON:
```lua
-- Achievement List
{
  type = "list",
  category = "combat",
  achievements = {...}
}

-- Stats Update
{
  type = "stats",
  completed = 5,
  claimed = 3,
  points = 100
}
```

---

## 🎯 Features

### ✅ Implemented

- ✅ Category-based organization
- ✅ Progress tracking with bars
- ✅ Visual status indicators
- ✅ Claim reward system
- ✅ Secret achievement hiding
- ✅ Real-time updates
- ✅ Hotkey support (Ctrl+H)
- ✅ Statistics display
- ✅ Scrollable achievement list

### 🔮 Potential Enhancements

- [ ] Achievement tooltips on hover
- [ ] Search/filter functionality
- [ ] Achievement comparison with friends
- [ ] Animated completion effects
- [ ] Sound effects
- [ ] Achievement notifications (popup)
- [ ] Recent achievements panel
- [ ] Achievement chains visualization

---

## 🐛 Troubleshooting

### Window doesn't open
- Check console for errors
- Verify module is loaded: `/modules`
- Check if game is online

### No achievements displayed
- Check server is sending data (console logs)
- Verify extended opcodes are working
- Try requesting data: close and reopen window

### Icons not showing
- Verify creature/item IDs exist
- Check outfit system is working
- Fallback to default icon

---

## 🎨 Asset Requirements

### Required Images

```
/images/achievements/
├── locked.png       # Locked achievement icon
├── completed.png    # Completed achievement icon
├── claimed.png      # Claimed achievement icon
└── secret.png       # Secret achievement placeholder
```

### Optional

```
/images/topbuttons/
└── achievements.png  # Top menu button icon
```

---

## 📝 Integration Notes

### Requires

- Server-side achievement system
- JSON library
- Extended opcode support
- Achievement data definitions

### Compatible With

- Task system
- Quest system
- Statistics system
- Leaderboards

---

## 🔄 Updates

**v1.0** - Initial release
- Basic UI
- Category system
- Claim functionality
- Progress tracking

---

**For backend documentation, see:**
`data/scripts/achievements/README.md`
