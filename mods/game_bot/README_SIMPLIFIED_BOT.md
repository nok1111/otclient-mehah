# Simplified Bot v2.0

## 🎯 Overview
Bot simplificado sin CaveBot ni Looting. Solo funciones esenciales de combate, curación y soporte.

## 📁 Estructura de Archivos

```
mods/game_bot/
├── bot.lua                      # Controlador principal (simplificado)
├── bot.otmod                    # Definición del módulo
├── simple_bot/
│   ├── bot_simple.lua          # Lógica del bot (combat/healing/support)
│   ├── bot_simple.otui         # Definición de UI (window + tabs)
│   └── bot_ui.lua              # Controlador de UI
└── [archivos antiguos respaldados con sufijo _old_backup]
```

## ✨ Features

### Tab 1: Combat 🗡️
- **Attack All Monsters**: Checkbox para atacar cualquier monstruo cercano
- **Monster List**: Lista específica de monstruos a atacar (alternativa a Attack All)
- **3 Attack Spells**: Rotación automática de hasta 3 hechizos de ataque
- Sin priority, danger, chase, lure ni distance calculations

### Tab 2: Healing ❤️💙
- **Healing Spell**: 1 hechizo de curación con slider de HP%
- **Health Potion**: 1 poción de vida con slider de HP%
- **Mana Potion**: 1 poción de mana con slider de MP%
- Sliders simples de 0-100% en incrementos de 5%

### Tab 3: Support ⚡
- **Support Spell 1**: Hechizo con cooldown configurable (ej: mana shield)
- **Support Spell 2**: Hechizo con cooldown configurable (ej: haste)
- **Auto Eat**: Come food automáticamente cada X segundos
- Cooldowns en segundos, intervalo de comida configurable

## 🎮 Uso

### Activación
1. Click en botón "Bot" en topbar
2. Configurar tabs según necesidad
3. Click en botón **ON** en la parte superior
4. El bot ejecuta su loop cada 50ms

### Configuración Rápida

#### Combat
```
[✓] Attack All Monsters
Spell 1: exori vis
Spell 2: exori gran
Spell 3: 
[✓] Combat Enabled
```

#### Healing
```
[✓] Healing Spell: exura vita @ 60% HP
[✓] Health Potion: 3160 @ 40% HP
[✓] Mana Potion: 268 @ 70% MP
```

#### Support
```
[✓] Support Spell 1: utamo vita (90s cooldown)
[✓] Support Spell 2: utani hur (60s cooldown)
[✓] Auto Eat: 3577 (every 10s)
```

## 💾 Storage

### Ubicación
```
/bot_simple/profile_{N}.json
```

### Estructura
```json
{
  "combat": {
    "enabled": true,
    "attackAll": true,
    "monsterList": ["Demon", "Dragon"],
    "spells": ["exori vis", "exori gran", ""]
  },
  "healing": {
    "spell": {"enabled": true, "text": "exura vita", "hpPercent": 60},
    "healthPotion": {"enabled": true, "itemId": 3160, "hpPercent": 40},
    "manaPotion": {"enabled": true, "itemId": 268, "mpPercent": 70}
  },
  "support": {
    "spell1": {"enabled": true, "text": "utamo vita", "cooldown": 90},
    "spell2": {"enabled": true, "text": "utani hur", "cooldown": 60},
    "autoEat": {"enabled": true, "itemId": 3577, "interval": 10}
  }
}
```

## 🔧 Lógica Interna

### Combat Loop (processCombat)
1. Obtiene espectadores en pantalla
2. Filtra monstruos según `attackAll` o `monsterList`
3. Selecciona target más cercano
4. Ataca y rota spells (1→2→3→1)

### Healing Loop (processHealing)
1. Check HP% del jugador
2. Si HP < spell.hpPercent → usar spell
3. Si HP < healthPotion.hpPercent → usar potion
4. Check MP% del jugador
5. Si MP < manaPotion.mpPercent → usar potion
6. Cooldown global de 1 segundo entre heals

### Support Loop (processSupport)
1. Check cooldown de spell1 → cast si disponible
2. Check cooldown de spell2 → cast si disponible
3. Check intervalo de auto-eat → comer si disponible

## ⚠️ Removido del Bot Antiguo

### ❌ Sistemas Eliminados
- CaveBot completo (walking, waypoints, labels)
- Looting system
- Depositer, supply, recorder
- Priority/danger calculations
- Chase, lure, distance mechanics
- Runas de ataque/curación
- Auto-equip system
- Mana shield/haste automáticos (ahora son support spells configurables)
- Sistema de configs .cfg/.json externos
- Editor visual
- Upload/download de configs

### 📦 Archivos Respaldados
- `bot_old_backup.lua` - Bot antiguo completo
- `default_configs_old_backup/` - Configs viejas (cavebot 1.3)
- `ui_old_backup/` - UI widgets antiguos
- `bot_old.otui` - UI antigua principal
- `edit_old.otui` - Editor de configs antiguo
- `executor_old.lua` - Sistema de ejecución antiguo

## 🐛 Troubleshooting

### Bot no inicia
- Verificar que `simple_bot/` existe con los 3 archivos
- Check console para errores de import
- Verificar permisos de escritura en `/bot_simple/`

### No ataca monstruos
- Verificar que Combat Enabled está checkeado
- Si usa lista específica, agregar nombres exactos
- Check que at least 1 spell está configurado

### No cura
- Verificar que los checkboxes están activados
- Ajustar sliders si HP/MP nunca baja a ese %
- Check que item IDs son correctos

### Support spells no funcionan
- Verificar que están enabled
- Check que cooldowns no son demasiado altos
- Verificar que spell text es correcto

## 📝 Notas

- Storage se guarda automáticamente al cambiar configuración
- Storage se carga automáticamente al conectar
- Bot se desactiva automáticamente al desconectar
- Main loop corre a 50ms (20 ticks/segundo)
- Healing tiene cooldown interno de 1s para evitar spam

## 🔄 Changelog

### v2.0 (Current)
- Simplificación completa del bot
- Removido CaveBot y Looting
- 3 tabs simples (Combat/Healing/Support)
- UI con sliders para HP/MP%
- Storage independiente
- Sin dependencias de configs externos

### v1.3 (Old - Backup)
- CaveBot con waypoints
- TargetBot con priority system
- Looting system
- Depositer, supply, recorder
- Configs .cfg/.json externos
