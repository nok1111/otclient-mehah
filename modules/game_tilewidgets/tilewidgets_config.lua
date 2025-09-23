-- modules/game_tilewidgets/tilewidgets_config.lua

-- Define tile widgets to auto-attach when the game starts.
-- You can add more entries to 'labels' and 'images' as needed.

TileWidgetsConfig = {
  labels = {
    -- Example label
    {
      pos = { x = 208, y = 703, z = 5 },
      text = "Refinery Table",
      opts = {
        width = 100, height = 22,
        font = "terminus-10px",
        bg = "#111111cc", color = "#ffffff",
        marginBottom = 40
      }
    },
    {
      pos = { x = 208, y = 707, z = 5 },
      text = "Alchemy Table",
      opts = {
        width = 100, height = 22,
        font = "terminus-10px",
        bg = "#111111cc", color = "#ffffff",
        marginBottom = 40
      }
    },

    {
      pos = { x = 205, y = 703, z = 5 },
      text = "Enchanting Table",
      opts = {
        width = 100, height = 22,
        font = "terminus-10px",
        bg = "#111111cc", color = "#ffffff",
        marginBottom = 40
      }
    },
    {
      pos = { x = 201, y = 705, z = 5 },
      text = "Blacksmith Table",
      opts = {
        width = 100, height = 22,
        font = "terminus-10px",
        bg = "#111111cc", color = "#ffffff",
        marginBottom = 40
      }
    },

    {
      pos = { x = 227, y = 703, z = 6 },
      text = "Waypoint",
      opts = {
        width = 100, height = 22,
        font = "terminus-10px",
        bg = "#111111cc", color = "#ffffff",
        marginBottom = 40
      }
    },







  }, 
}
