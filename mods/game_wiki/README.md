# 📚 Game Wiki Module

In-game wiki system with search functionality and multi-language support.

## ✨ Features

- 🔍 **Search System** - Find content by keywords across all categories
- 🌐 **Multi-language** - Currently supports English and Spanish
- 📂 **Category Organization** - Expandable categories and subcategories
- 🎮 **Game Integration** - Opens with Ctrl+H or top menu button
- 📝 **Extensible** - Easy to add new categories and content

## 🎯 Current Categories

### Items
- Dropable Spells
- Runes
- Sample Categories (extensible)
- Enchantments

### Dungeons
- Dungeon Teleport Stones
- Boss Information

### Currencies
- Fame Points
- Valuable Pouches

### Pets
- Complete pet list with abilities and rarities

## 🔧 How to Add Content

### Adding a New Category

Edit `wiki_data.lua` in both `getEnglishData()` and `getSpanishData()` functions:

```lua
new_category = {
  name = 'New Category Name',
  subcategories = {
    sub1 = {
      name = 'Subcategory 1',
      type = 'list', -- or 'text' or 'pets'
      items = { ... }
    }
  }
}
```

### Content Types

**List Type** - For items with icons and descriptions:
```lua
{
  name = 'Item Name',
  description = 'Item description',
  icon = 2160 -- Item ID
}
```

**Text Type** - For informational content:
```lua
{
  type = 'text',
  content = 'Your text content here...'
}
```

**Pets Type** - For pet information:
```lua
{
  name = 'Pet Name',
  rarity = 'Epic/Rare/Uncommon/Common',
  collector = 'Collector Name',
  abilities = {
    { name = 'Ability Name', description = 'Description' }
  }
}
```

## 🎨 Icon Setup

Place a wiki icon at:
```
data/images/topbuttons/wiki.png
```

Recommended size: 20x20 pixels

## ⌨️ Hotkeys

- **Ctrl+H** - Toggle wiki window
- **Escape** - Close wiki window

## 🌍 Languages

Current languages:
- **en** - English
- **es** - Spanish (Español)

To add more languages:
1. Add a new function in `wiki_data.lua` (e.g., `getPortugueseData()`)
2. Update the `changeLanguage()` function in `wiki.lua`
3. Add the language to the cycle

## 📝 Examples

### Adding a Monster Category

```lua
monsters = {
  name = 'Monsters',
  subcategories = {
    demons = {
      name = 'Demons',
      type = 'list',
      items = {
        {
          name = 'Demon',
          description = 'HP: 8,200 | Exp: 6,000 | Drops: Fire Sword',
          icon = 5080
        }
      }
    }
  }
}
```

### Adding a Quest Guide

```lua
quests = {
  name = 'Quests',
  subcategories = {
    main_quest = {
      name = 'Main Quest Line',
      type = 'text',
      content = 'Step 1: Talk to NPC\nStep 2: Collect 10 items\nStep 3: Return to NPC'
    }
  }
}
```

## 🎮 Usage

1. Player opens wiki with **Ctrl+H** or clicking the wiki button
2. Browse categories on the left
3. Select subcategories in the middle panel
4. View content on the right
5. Use search bar to find specific content
6. Switch language with the language button (EN/ES)

## 🔄 Future Enhancements

Possible additions:
- 📊 Monster statistics
- 🗺️ Map locations
- 🎁 Quest rewards
- ⚔️ Weapon comparisons
- 🛡️ Armor sets
- 🧪 Potion recipes
- 🏆 Achievement guides
- 📅 Event schedules

## 💡 Tips

- Keep descriptions concise and informative
- Use consistent formatting across languages
- Test search functionality after adding content
- Use appropriate item IDs for icons
- Organize logically with clear subcategories

---

**Created by:** Custom Module
**Version:** 1.0.0
**Compatible with:** OTClient Mehah
