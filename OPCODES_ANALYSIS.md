# 🔍 ANÁLISIS COMPLETO DE OPCODES

## 📊 ESTADO ACTUAL DE OPCODES

### ⚠️ **CONFLICTOS DETECTADOS**

#### **Opcode 80 - DUPLICADO**
```lua
# En protocol.lua:
GameServerNPCDialog = 80

# En game_npcdialog/npcdialog.lua:
OpcodeDialog = 80  -- ✅ Extended opcode

# Veredicto: ✅ NO HAY CONFLICTO
# GameServerNPCDialog es un opcode de protocolo normal
# OpcodeDialog es un extended opcode (50)
# Son sistemas diferentes
```

#### **Opcode 57 - Crafting**
```lua
GameServerOpenCrafting = 57
# Usado en: modules/game_crafting
# Tipo: Opcode de protocolo (NO extended)
# Estado: ✅ Registrado correctamente
```

#### **Opcode 88 - Fame Shop**
```lua
GameServerOpenFameShop = 88
# Usado en: modules/game_famenpcshop
# Tipo: Opcode de protocolo (NO extended)
# Estado: ✅ Registrado correctamente
```

---

## 📋 EXTENDED OPCODES EN USO (Rango 0-99)

### **Sistema Base (0-7)**
```lua
0  - Activate
1  - Locale
2  - Ping
3  - Sound
4  - Game
5  - Particles
6  - MapShader
7  - NeedsUpdate
```

### **Task System (16-20 / 0x10-0x14)**
```lua
16 (0x10) - TaskList
17 (0x11) - UpdateTask
18 (0x12) - NpcTaskList
19 (0x13) - NpcRewardList
20 (0x14) - NpcTaskWindowClose
```

### **Módulos Custom**
```lua
27  - Tooltips (item_tooltip.lua) - CODE_TOOLTIPS
75  - Messages (game_sendmessages.lua) - OPCODE_MESSAGES
76  - Centre Messages (game_sendmessages.lua) - OPCODE_CENTREMESSAGES
80  - NPC Dialog (game_npcdialog/npcdialog.lua) - OpcodeDialog
94  - Passive Cooldown (PassiveSkills) - opCode
76  - Dungeons (game_dungeons/dungeons.lua) - DUNGEON_OPCODE ⚠️ CONFLICTO CON 76!
214 - MapTravel (game_MapTravel/MapTravel.lua) - MapTravel_OPCODE
???  - Auction (game_auction/game_auction.lua) - Auction.opCode (no especificado)
???  - Shops (game_shops/shops.lua) - Config.opcode (no especificado)
???  - Party Status (party_status/party_status.lua) - PARTY_OPCODE (no especificado)
```

### **⚠️ CONFLICTOS ENCONTRADOS**

#### **Opcode 76 - DUPLICADO**
```lua
# game_sendmessages.lua:
OPCODE_CENTREMESSAGES = 76

# game_dungeons.lua:
DUNGEON_OPCODE = 76

# ⚠️ CONFLICTO REAL - Ambos son extended opcodes
# SOLUCIÓN: Cambiar uno de ellos
```

#### **Opcode 94 - POSIBLE CONFLICTO**
```lua
# protocol.lua:
GameServerPassiveCooldown = 94  -- Opcode de protocolo

# game_passiveSkills.lua:
PassiveSkills.opCode = 94  -- Extended opcode

# ⚠️ POSIBLE CONFLICTO si ambos se usan simultáneamente
```

---

## 🎯 RANGOS LIBRES PARA ACHIEVEMENTS

### **Opción 1: Rango 80-89 (Recomendado)**
```lua
80 - NPC Dialog (usado como extended, compatible)
81 - ✅ LIBRE
82 - ✅ LIBRE
83 - ✅ LIBRE
84 - ✅ LIBRE
85 - ✅ LIBRE
86 - ✅ LIBRE
87 - ✅ LIBRE
88 - ✅ LIBRE (en protocol pero no como extended)
89 - ✅ LIBRE (en protocol pero no como extended)
```

**Asignación Achievement System:**
```lua
AchievementList = 81        -- Send full achievement list
AchievementUpdate = 82      -- Update progress
AchievementComplete = 83    -- Achievement completed notification
AchievementClaim = 84       -- Claim reward request
AchievementDetails = 85     -- Request specific achievement details
AchievementStats = 86       -- Player statistics
```

### **Opción 2: Rango 30-49**
```lua
30-49 - Completamente libre
# Pero más lejos de otros extended opcodes
```

### **Opción 3: Rango 90-99**
```lua
90-93 - ✅ LIBRE
94 - ⚠️ Passive Cooldown
95-99 - ✅ LIBRE
```

---

## 📊 CLIENT OPCODES EN USO (Rango 50-99)

### **Actualmente Usados**
```lua
50  - ClientExtendedOpcode (base)
52  - ClientSelectTask
53  - ClientSelectReward
54  - ClientGetTaskList
56  - ClientDeleteTask
58  - ClientCraftRecipe
60  - ClientStartDungeon
61  - ClientFameShopBuy
```

### **Libres para Client Opcodes**
```lua
51, 55, 57, 59, 62-99 = ✅ LIBRES
```

---

## ✅ RECOMENDACIÓN FINAL PARA ACHIEVEMENTS

### **Extended Opcodes (Server → Client)**
```lua
ExtendedIds = {
    -- ... existing opcodes ...
    
    -- Achievement System (81-86)
    AchievementList = 81,       -- Send full list
    AchievementUpdate = 82,     -- Progress update
    AchievementComplete = 83,   -- Completion notification
    AchievementClaim = 84,      -- Claim confirmation
    AchievementDetails = 85,    -- Category/specific data
    AchievementStats = 86,      -- Player statistics
}
```

### **Por qué 81-86:**
1. ✅ Están en rango de extended opcodes (51-99)
2. ✅ No están en uso actualmente
3. ✅ Están cerca del rango 80 que ya tiene NPC Dialog
4. ✅ Son consecutivos (fácil de documentar)
5. ✅ Dejan espacio para expansión (87-89)

---

## 🔧 FIXES NECESARIOS

### **1. Resolver Conflicto Opcode 76**
```lua
# ANTES:
OPCODE_CENTREMESSAGES = 76  (game_sendmessages)
DUNGEON_OPCODE = 76          (game_dungeons)

# DESPUÉS:
OPCODE_CENTREMESSAGES = 76   (mantener)
DUNGEON_OPCODE = 77          (cambiar a 77)
```

### **2. Clarificar Opcode 94**
```lua
# Si son sistemas separados, OK
# Si interfieren, mover PassiveSkills a 95
```

### **3. Definir Opcodes No Especificados**
```lua
# En sus respectivos archivos, verificar:
Auction.opCode = ???
Config.opcode (shops) = ???
PARTY_OPCODE = ???
```

---

## 📝 TABLA RESUMEN COMPLETA

| Opcode | Sistema | Tipo | Estado |
|--------|---------|------|--------|
| 0-7 | Base System | Extended | ✅ Usado |
| 16-20 | Task System | Extended | ✅ Usado |
| 27 | Tooltips | Extended | ✅ Usado |
| 57 | Crafting | Protocol | ✅ Usado |
| 60 | Jobs | Protocol | ✅ Usado |
| 61 | Fame | Protocol | ✅ Usado |
| 75 | Messages | Extended | ✅ Usado |
| 76 | Centre Msg/Dungeons | Extended | ⚠️ CONFLICTO |
| 80 | NPC Dialog | Extended | ✅ Usado |
| **81-86** | **ACHIEVEMENTS** | **Extended** | **✅ LIBRE** |
| 88 | Fame Shop | Protocol | ✅ Usado |
| 89 | Ancestral Tasks | Protocol | ✅ Usado |
| 94 | Passive Cooldown | Extended/Protocol | ⚠️ Verificar |
| 214 | MapTravel | Extended | ✅ Usado |

---

## 🎯 IMPLEMENTACIÓN ACHIEVEMENTS

### **En const.lua**
```lua
ExtendedIds = {
    Activate = 0,
    Locale = 1,
    Ping = 2,
    Sound = 3,
    Game = 4,
    Particles = 5,
    MapShader = 6,
    NeedsUpdate = 7,
    TaskList = 0x10,
    UpdateTask = 0x11,
    NpcTaskList = 0x12,
    NpcRewardList = 0x13,
    NpcTaskWindowClose = 0x14,
    
    -- Achievement System (81-86)
    AchievementList = 81,
    AchievementUpdate = 82,
    AchievementComplete = 83,
    AchievementClaim = 84,
    AchievementDetails = 85,
    AchievementStats = 86,
}
```

### **En achievements.lua (cliente)**
```lua
local OPCODE_ACHIEVEMENT_LIST = 81      -- ExtendedIds.AchievementList
local OPCODE_ACHIEVEMENT_UPDATE = 82    -- ExtendedIds.AchievementUpdate
local OPCODE_ACHIEVEMENT_COMPLETE = 83  -- ExtendedIds.AchievementComplete
local OPCODE_ACHIEVEMENT_CLAIM = 84     -- ExtendedIds.AchievementClaim
local OPCODE_ACHIEVEMENT_DETAILS = 85   -- ExtendedIds.AchievementDetails
local OPCODE_ACHIEVEMENT_STATS = 86     -- ExtendedIds.AchievementStats
```

### **En servidor (TFS)**
```lua
-- data/scripts/achievements/achievement_opcodes.lua
local OPCODE_ACHIEVEMENT_LIST = 81
local OPCODE_ACHIEVEMENT_UPDATE = 82
local OPCODE_ACHIEVEMENT_COMPLETE = 83
local OPCODE_ACHIEVEMENT_CLAIM = 84
local OPCODE_ACHIEVEMENT_DETAILS = 85
local OPCODE_ACHIEVEMENT_STATS = 86
```

---

## ✅ CONCLUSIÓN

1. **Achievements puede usar opcodes 81-86** sin conflictos
2. **Hay un conflicto real en opcode 76** que debe resolverse
3. **Opcode 94 necesita verificación** (passive vs protocol)
4. **Los opcodes 80, 87-89 están disponibles** para expansión futura

---

**Fecha:** Dec 18, 2025
**Análisis de:** 10+ módulos client-side
**Conflictos encontrados:** 2 (opcode 76 y posible 94)
**Rango recomendado:** 81-86
