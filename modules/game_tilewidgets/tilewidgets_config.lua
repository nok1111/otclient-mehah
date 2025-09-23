-- modules/game_tilewidgets/tilewidgets_config.lua

-- Define tile widgets to auto-attach when the game starts.
-- You can add more entries to 'labels' and 'images' as needed.

TileWidgetsConfig = {
  labels = {
    -- Example label
    {
      pos = { x = 229, y = 701, z = 6 },
      text = "OTC Redemption",
      opts = {
        width = 100, height = 22,
        font = "terminus-10px",
        bg = "#111111cc", color = "#ffffff",
        marginBottom = 40
      }
    },
  },

  images = {
    -- Example image icon
    {
      pos = { x = 233, y = 700, z = 6 },
      image = "/images/icons/dungeon.png",
      opts = {
        width = 24, height = 24,
        marginBottom = 32
      }
    },
  }
}
