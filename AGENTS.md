# OTClient (mehah-withupstream2) — Project Info

## Build commands (Windows, VS 2022 + vcpkg)

```bash
# Configure (Visual Studio 17 2022, x64, vcpkg at C:\vcpkg)
cmake --preset windows-release
# or use CMakeSettings.json (x64-Release) from VS IDE

# Build
cmake --build build/windows-release --config Release
# or from VS IDE: Build Solution (Release)

# Output binary
otclient_dx_x64.exe
```

vcpkg triplet: `x64-windows-static` (preset) or `x64-windows` (CMakeSettings)
Toolchain: `C:\vcpkg\scripts\buildsystems\vcpkg.cmake`

## Style system (data/styles/)

OTML does NOT support variables/tokens. Colors are hardcoded per-style.
Follow this palette convention when adding or modifying styles:

### Color palette

| Token (conceptual) | Hex | Usage |
|--------------------|-----|-------|
| Primary text | `#dfdfdf` / `#dfdfdfff` | Main text, icons, button labels |
| Secondary text | `#c0c0c0` / `#c0c0c0ff` | Secondary labels, inactive titles, creature labels |
| Disabled (alpha) | `#dfdfdf88` | Disabled states (alpha-based) |
| Editable text | `#f4f4f4ff` | TextEdit input fields |
| White (hover) | `#ffffff` | Hover states, text on dark backgrounds |
| Accent blue | `#355d89` | ComboBox/menu hover background |
| Accent blue light | `#80c7f8` | Active tab text |
| Alert red | `#de6f6f` / `#F55E5E` | Notifications, tabs with alerts |
| Success green | `#00BC00` | Positive indicators (outfit window) |

### Rules

- Use `#dfdfdf` for primary text/icons. Do not introduce new gray shades.
- Use `#c0c0c0` for secondary/muted text. Do not use `#aaaaaa`, `#909090`, `#888888`, `#929292`, `#bbbbbb`.
- Use `#dfdfdf88` for disabled states (consistent alpha-based dimming).
- Qt-style buttons (`QtButton`, `QtCheckBox`, `fakeCheckBox`, `TabBarQtVerticalButton`) use `#dfdfdfff` (same as primary, unified in QW4).
- `#888888ff` in `QtComboBoxPopupMenuButton` disabled is an exception (Qt popup styling).

### Style file loading order (prefix number = load order)

| Prefix | Category | Files |
|--------|----------|-------|
| `10-` | Base widgets | buttons, checkboxes, comboboxes, creaturebuttons, creatures, effect, items, labels, listboxes, missile, panels, progressbars, scrollbars, separators, splitters, textedits, windows |
| `20-` | Composite widgets | imageview, popupmenus, smallscrollbar, spinboxes, tabbars, tables, topmenu |
| `30-` | Complex widgets | calendar, inputboxes, messageboxes, minimap, miniwindow, statsbar |
| `40-` | Feature windows | gamebuttons, outfitwindow |

### Button style hierarchy

- `Button < UIButton` — base button (verdana font, `#dfdfdf`)
- `QtButton < UIButton` — Cipsoft-style button (cipsoftFont, now `#dfdfdfff`)
- `MainPanelSquareIconButton`, `MainPanelGridButton`, `MainPanelLargeButton` — main panel buttons
- `TabButton`, `TabBarButton`, `TabBarRoundedButton` — tab buttons
- `AbandonTaskButton`, `StartTaskButton` — task board action buttons (red/green)
- `BigPremiumButton`, `MiniPremiumButton` — store buttons
- `TaskButton < Button` — inherits from Button, redefined in `game_tasklist/npc_tasklist.otui`

## Key directories

- `data/styles/` — global OTUI style definitions
- `data/fonts/` — font definitions (.otfont)
- `data/particles/` — particle effects (.otps)
- `modules/` — Lua/OTUI game modules (one folder per feature)
- `src/` — C++ engine source
- `mods/` — additional game mods

## Server

- TFS 1.4.2 fork: `C:\Users\nokturno\Desktop\1.4 konakon\TFS-1.4.2-Compatible-Aura-Effect-Wings-Shader-MEHAH`
- Discord bridge: HTTP server on TFS (port 8081) + Node.js bridge (port 3000)
- Channels: 3 (World), 4 (English), 5 (Advertising), 6 (Advertising-Rook), 7 (Help)

## Mods

### game_alchemy (`mods/game_alchemy/`)

Dedicated alchemy-station window (opened by station actionid 33111; the generic
`game_crafting` window still handles other professions). Same structure/patterns
as `mods/game_blacksmith/`: `MainWindow` + horizontal `AlTabButton` row, dynamic
rows via `g_ui.createWidget`, extended-opcode JSON `{e, d}` packets.

- Opcode: `239` (`ALCHEMY_OPCODE`), registered in `Alchemy.init()` via
  (`237`/`238` are already taken by `game_dominion`/`game_guildmanagement`)
  `ProtocolGame.registerExtendedOpcode`.
- Server events handled: `AL_OPEN_WINDOW`, `AL_UPDATE` (meta only:
  level/xp/gold/buffs/oil/spec/progression), `AL_RECIPES`, `AL_REAGENTS`
  (chunked `{part,total,list}` — reassembled in `accumulate()`; the TFS
  `NetworkMessage::addString` silently drops strings > 8192 bytes so big
  lists must be chunked), `AL_CAULDRON` (mix state), `AL_BUFFS`,
  `AL_RESULT`, `AL_REJECTED`.
- Client sends: `AL_CRAFT`, `AL_PLACE`, `AL_REMOVE`, `AL_MIX_INFO`, `AL_BREW`,
  `AL_BUFFS`, `AL_CHOOSE_SPEC`, `AL_CLOSE`.
- Tabs (4, simplified rework): Boticario (recipe grid — `clientId` icon +
  name, locked recipes render as `Blackout`-shader silhouette + `?????`,
  click selects into a side detail panel with batch slider), Cauldron
  (fixed reagent grid, click toggles a reagent into the mix with numbered
  overlay, Brew tries an exact set match — order does NOT matter),
  Specializacion (3 spec cards, lvl 15, permanent), Progress (level/xp bar,
  discovered count, tiers, perks).
- Cauldron semantics: the mix is a SET of distinct ids server-side;
  `AL_PLACE` toggles an id on/off. `AL_BREW` sends no payload — the server
  matches the placed set against the recipe's cauldronable ingredient set
  exactly (order does not matter; all cauldronable recipes have unique sets).
  Outcomes: new gated recipe →
  discover + brew once + 24h `AlchemyBrewCd`; known recipe → mats consumed,
  no craft, no cd; no match → 1 of each clicked reagent consumed. Server sends
  `cdEnd`/`brewCd` as REMAINING SECONDS (client-side countdown, immune to
  clock skew).
- Potency odds from the server are already percentages (0-100) — do NOT
  multiply by 100 again.
- `UIItem`/`Item` widgets show sprites via `setItemId(clientId)` (server sends
  client ids, not server ids).
- Local helpers (`setLabel`, `fmtTime`, `fmtGold`, `herbFilter`, `buffTick`)
  must be declared before `Alchemy.wireUp()` — the chip/slider closures
  capture them lexically.
