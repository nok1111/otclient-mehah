# 🎨 IMÁGENES NECESARIAS PARA TASK CARDS

## **Estructura de Carpetas**
```
otclient/data/images/
├── tasks/
│   ├── header_normal.png       (210x80)
│   ├── header_rare.png         (210x80)
│   ├── header_epic.png         (210x80)
│   └── header_legendary.png    (210x80)
│
├── ui/
│   ├── windows/
│   │   ├── card_window_normal.png      (210x370)
│   │   ├── card_window_rare.png        (210x370)
│   │   ├── card_window_epic.png        (210x370)
│   │   ├── card_window_legendary.png   (210x370)
│   │   └── panel_border.png            (flexible width x 70 height)
│   │
│   ├── buttons/
│   │   ├── close_button.png        (116x102, 3 estados verticales)
│   │   └── open_button.png         (116x102, 3 estados verticales)
│   │
│   └── icons/
│       ├── fame.png                (16x16)
│       ├── lock.png                (32x32)
│       ├── lock_small.png          (16x16)
│       ├── premium.png             (16x16)
│       ├── reroll.png              (16x16)
│       ├── check.png               (16x16)
│       ├── cancel.png              (16x16)
│       ├── modifier_positive.png   (16x16)
│       ├── modifier_negative.png   (16x16)
│       └── modifier_mixed.png      (16x16)
```

---

## **1. Task Board Buttons**

### **Ubicación**: `/images/ui/buttons/`

Botones con 3 estados (normal, hover, pressed) divididos verticalmente:

| Archivo | Uso | Tamaño | Descripción |
|---------|-----|--------|-------------|
| `close_button.png` | Abandon Task | 116x102 | Botón rojo con 3 estados (34px cada uno) |
| `open_button.png` | Start Task | 116x102 | Botón verde con 3 estados (34px cada uno) |

**Formato de imagen**:
- **Altura total**: 102px (34px × 3 estados)
- **Ancho**: 116px
- **Estados verticales**:
  - Píxeles 0-33: Estado normal
  - Píxeles 34-67: Estado hover
  - Píxeles 68-101: Estado pressed
- **Border**: 5px en todos los lados (para `image-border: 5`)

**Estilos**:
- `close_button.png`: Fondo rojo/marrón oscuro con gradiente, texto blanco
- `open_button.png`: Fondo verde oscuro con gradiente, texto blanco

**Estados**:
- Normal: Color base
- Hover: Ligeramente más brillante
- Pressed: Más oscuro o con efecto hundido

---

## **2. Card Window Backgrounds (Tier-Specific)**

### **Ubicación**: `/images/ui/windows/`

Cada tier necesita una imagen de **210x370 pixels** para el fondo completo de la task card:

| Archivo | Tier | Descripción |
|---------|------|-------------|
| `card_window_normal.png` | Normal | Panel gris oscuro, borde simple |
| `card_window_rare.png` | Rare | Panel azul oscuro, borde brillante azul |
| `card_window_epic.png` | Epic | Panel púrpura oscuro, borde brillante púrpura |
| `card_window_legendary.png` | Legendary | Panel dorado/naranja, borde brillante dorado |

**Estilo sugerido**:
- Fondo semi-transparente con gradiente sutil
- **Borde decorativo de 5px** en todos los lados (para `image-border: 5`)
- Colores base:
  - Normal: #2a2a2a (gris oscuro)
  - Rare: #1a2a3a (azul oscuro)
  - Epic: #2a1a3a (púrpura oscuro)
  - Legendary: #3a2a1a (dorado oscuro)
- Opcional: textura sutil o efecto de brillo

**IMPORTANTE para `image-border: 5`:**
- Los primeros/últimos 5px de cada lado serán usados como borde repetible
- El contenido interno debe estar a partir del pixel 6 en todos los lados
- Esto permite que la imagen se escale correctamente sin distorsionar el borde

---

## **2. Panel Border (Header & General Panels)**

### **Ubicación**: `/images/ui/windows/`

Imagen de borde para paneles generales (header, action panel, active task, etc.):

| Archivo | Uso | Tamaño |
|---------|-----|--------|
| `panel_border.png` | Header panel, action panel, etc. | Ancho flexible x 70+ height |

**Estilo sugerido**:
- Fondo oscuro semi-transparente (#1a1a1a - #2a2a2a)
- **Borde decorativo de 5px** en todos los lados (para `image-border: 5`)
- Bordes pueden tener un color más claro (#3a3a3a - #4a4a4a)
- Opcional: gradiente sutil o textura

**IMPORTANTE para `image-border: 5`:**
- Los primeros/últimos 5px de cada lado serán usados como borde repetible
- El ancho puede variar (será escalado horizontalmente)
- La altura mínima recomendada es 70px
- Esto permite reutilizar la misma imagen en diferentes paneles

---

## **3. Header Images (Monster Groups)**

### **Ubicación**: `/images/tasks/`

Cada tier necesita una imagen de **210x80 pixels** mostrando los tipos de monstruos característicos:

| Archivo | Tier | Descripción |
|---------|------|-------------|
| `header_normal.png` | Normal | Monstruos básicos (lobos, osos, etc) |
| `header_rare.png` | Rare | Monstruos intermedios (arañas, escorpiones) |
| `header_epic.png` | Epic | Monstruos avanzados (demonios, dragones) |
| `header_legendary.png` | Legendary | Monstruos épicos (esqueletos dorados, etc) |

**Estilo sugerido**:
- Fondo oscuro/gris con borde decorativo
- 2-3 siluetas de monstruos por imagen
- Filtro de color según tier:
  - Normal: Gris (#888888)
  - Rare: Azul (#0070DD)
  - Epic: Púrpura (#A335EE)
  - Legendary: Naranja (#FF8000)

---

## **2. Iconos de Modifiers**

### **Ubicación**: `/images/icons/`

Tamaño: **16x16 pixels**

Los iconos de modifiers se cargan dinámicamente desde el servidor usando el campo `icon` de cada modifier.

**Iconos necesarios**:
- `gold-bars.png` - Gold boost modifier
- `fame.png` - Fame bonus modifier
- `icon_magic.png` - Essence drop modifier
- `prey_star.png` - Elite spawns / high risk modifiers
- `prey_loot.png` - Rare drop chance modifier
- `clock.png` - Faster respawn modifier
- `pet.png` - Pet exp modifier
- `prey_damage.png` - Monster damage / glass cannon modifiers
- `icon_health.png` - Reduced healing / monster HP / blood hunt modifiers
- `summon_other.png` - Increased respawn modifier
- `prey_defense.png` - Reduced armor modifier
- `icon_fist.png` - Death penalty modifier
- `summon_own.png` - Swarm mode modifier

**Fallback**: Si un modifier no tiene icono definido, usa `modifier_positive.png`

---

## **3. Iconos de Rewards**

### **Ubicación**: `/images/ui/icons/`

| Archivo | Tamaño | Uso | Alternativa |
|---------|--------|-----|-------------|
| `fame.png` | 16x16 | Fame reward icon | Usar `/images/game/items/{fame_item_id}` |

**Gold Icon**: Ya existe en `/images/game/items/3031` (gold coin)

---

## **4. Icono de Lock**

### **Ubicación**: `/images/ui/icons/`

| Archivo | Tamaño | Uso |
|---------|--------|-----|
| `lock.png` | 32x32 | Overlay cuando una task está locked |

**Descripción**: Candado dorado (#FFD700) con fondo transparente

---

## **5. Fallbacks Temporales**

Si no tienes las imágenes aún, puedes usar temporalmente:

### **Header Images**:
```lua
-- En tasks.lua, línea 278-284, comentar setImageSource:
-- headerImage:setImageSource(headerImages[task.tier] or '/images/tasks/header_normal')

-- Y usar un color de fondo:
local headerImagePanel = taskCard:recursiveGetChildById('headerImagePanel')
if headerImagePanel then
    local tierColors = {
        normal = '#3a3a3a',
        rare = '#1a3a5a',
        epic = '#3a1a5a',
        legendary = '#5a3a1a'
    }
    headerImagePanel:setBackgroundColor(tierColors[task.tier])
end
```

### **Modifier Icons**:
Usar símbolos Unicode:
```lua
-- En lugar de iconos, usar texto:
local modSymbols = {
    positive = '✓',  -- o '▲'
    negative = '✗',  -- o '▼'
    mixed = '±'      -- o '●'
}
```

### **Fame Icon**:
```lua
-- Usar item ID de crystal coins temporalmente
image-source: /images/game/items/3043
```

### **Lock Icon**:
```lua
-- Usar solo el texto "🔒" o cambiar por un panel amarillo
```

---

## **6. Cómo Crear las Imágenes**

### **Opción 1: Photoshop/GIMP**
1. Crear canvas del tamaño especificado
2. Usar sprites de Tibia existentes
3. Aplicar filtros de color según tier
4. Exportar como PNG con transparencia

### **Opción 2: Usar Sprites del Servidor**
```bash
# Extraer sprites de tu servidor
# Ubicación típica: data/items/items.otb o sprites/
```

### **Opción 3: Placeholder Simple**
Para testing rápido, crear imágenes sólidas de colores:
```lua
-- Normal: Gris oscuro
-- Rare: Azul oscuro
-- Epic: Púrpura oscuro
-- Legendary: Naranja dorado
```

---

## **7. Verificación**

Una vez agregadas las imágenes, reinicia el cliente y verifica:

```
✓ Header images cargan según tier
✓ Modifier icons aparecen a la izquierda de cada modifier
✓ Gold/Fame icons aparecen en rewards
✓ Lock icon aparece cuando lockeas una task
```

Si una imagen falta, verás un espacio en blanco o el error en consola:
```
ERROR: could not load image: /images/tasks/header_rare.png
```

---

## **Rutas Actuales Usadas en el Código**

```lua
-- Card Window Backgrounds (tasks.lua línea 257-263)
'/images/ui/windows/card_window_normal'
'/images/ui/windows/card_window_rare'
'/images/ui/windows/card_window_epic'
'/images/ui/windows/card_window_legendary'

-- Panel Border (tasks.otui líneas 251, 315, 419)
'/images/ui/windows/panel_border'  -- Header panel, action panel, active task panel

-- Header Images (tasks.lua línea 290+)
'/images/tasks/header_normal'
'/images/tasks/header_rare'
'/images/tasks/header_epic'
'/images/tasks/header_legendary'

-- Modifier Icons (tasks.lua línea 321, dinámicos desde servidor)
'/images/icons/{modifier.icon}'  -- Carga dinámica basada en task_modifiers.lua
'/images/icons/gold-bars'
'/images/icons/fame'
'/images/icons/icon_magic'
'/images/icons/prey_star'
'/images/icons/prey_loot'
'/images/icons/clock'
'/images/icons/pet'
'/images/icons/prey_damage'
'/images/icons/icon_health'
'/images/icons/summon_other'
'/images/icons/prey_defense'
'/images/icons/icon_fist'
'/images/icons/summon_own'

-- Reward Icons (tasks.otui línea 148, 171)
'/images/game/items/3031'  -- Gold coin
'/images/ui/icons/fame'     -- Fame icon

-- Lock Icon (tasks.otui línea 225)
'/images/ui/icons/lock'

-- Action Panel Icons (tasks.otui líneas 331, 357, 383, 398)
'/images/ui/icons/reroll'       -- Reroll icon
'/images/ui/icons/lock_small'   -- Small lock icon
'/images/ui/icons/premium'      -- Premium icon

-- Task Board Button Images (10-buttons.otui líneas 290+, 305+)
'/images/ui/buttons/close_button'   -- Abandon Task button (red, 3 estados)
'/images/ui/buttons/open_button'    -- Start Task button (green, 3 estados)
```

---

¡Sistema listo para recibir assets! 🎨
