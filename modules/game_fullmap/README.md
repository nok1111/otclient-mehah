# Full Map Visualization System

## 🚀 Acceso Rápido

**Presiona `Ctrl + W` para abrir el mapa completo**

O usa los comandos:
- `/worldmap` - Abrir mapa completo
- `/map` - Abrir mapa completo
- `!map` - Abrir mapa completo

## ¿Qué hace este módulo?

⚠️ **IMPORTANTE:** Este es el **World Map** (mapa completo), NO el minimap normal (ventana pequeña).

Este sistema te permite ver **el mapa completo del servidor** directamente en el cliente con:

✅ **Visualización real del mapa OTBM** - Sprites reales, no solo colores  
✅ **Posición del jugador en tiempo real** - Marcador blanco que se actualiza cada 100ms  
✅ **Marcadores de NPCs con nombres** - Diferentes colores según el tipo  
✅ **Lista clickeable de NPCs** - Click para centrar el mapa en ese NPC  
✅ **Zoom 1x-4x** - Control con scroll del mouse  
✅ **Áreas y zonas del OTBM** - Todo visible desde el inicio  

## Instalación Rápida

### 1. Copiar el mapa del servidor al cliente

```bash
# Desde la carpeta raíz del proyecto
copy "Ascension-1.4.2\data\world\map.otbm" "otclient-mehah\map.otbm"
```

### 2. Configurar NPCs en el servidor

Edita `Ascension-1.4.2\data\scripts\fullmap\fullmap_server.lua`:

```lua
local npcs = {
    -- Agrega tus NPCs aquí con sus posiciones reales
    {name = "Captain Bluebear", x = 32360, y = 31782, z = 6, type = "npc"},
    {name = "Rashid", x = 32328, y = 31784, z = 6, type = "shop"},
    {name = "Demon Boss", x = 32400, y = 31800, z = 7, type = "boss"},
}
```

### 3. Agregar botón al UI (Opcional)

Agrega esta línea en `otclient-mehah\modules\game_interface\gameinterface.lua` después de otros botones:

```lua
modules.game_mainpanel.addStoreButton('fullMapButton', 'World Map', '/images/icons/map', 
  function() modules.game_fullmap.toggle() end, false, 3)
```

O usa el comando en consola (F12):
```lua
modules.game_fullmap.show()
```

## Tipos de Marcadores

- 🟢 **Verde** (`type = "npc"`) - NPCs normales
- 🔴 **Rojo** (`type = "boss"`) - Bosses
- 🟡 **Amarillo** (`type = "trainer"`) - Entrenadores
- 🔵 **Cyan** (`type = "shop"`) - Tiendas

## Controles

- **Ctrl+W** - Abrir/Cerrar mapa
- **Click en NPC** (lista o mapa) - Centra el mapa
- **Botón "Center on Player"** - Vuelve a tu posición
- **Scroll del mouse** - Zoom in/out
- **Arrastrar** - Mover el mapa
- **ESC** - Cerrar ventana

## Archivos Creados

### Cliente
- `modules/game_fullmap/fullmap.otmod` - Módulo
- `modules/game_fullmap/fullmap.otui` - Interfaz
- `modules/game_fullmap/fullmap.lua` - Lógica

### Servidor
- `data/scripts/fullmap/fullmap_server.lua` - Envía datos de NPCs

## Troubleshooting

### El mapa no carga

**Problema:** Mensaje "Map file not found"  
**Solución:** Asegúrate de copiar `map.otbm` a la carpeta raíz del cliente

### NPCs no aparecen

**Problema:** No se ven marcadores de NPCs  
**Solución:** 
1. Verifica que agregaste NPCs en `fullmap_server.lua`
2. Revisa la consola del cliente (F12) para ver si recibió los datos
3. Asegúrate que las coordenadas sean correctas

### "OTBM loading not available"

**Problema:** El cliente no puede cargar OTBM  
**Solución:** El cliente ya tiene `FRAMEWORK_EDITOR` activado. Si aún falla, recompila:

```bash
cd otclient-mehah
mkdir build && cd build
cmake .. -DTOGGLE_FRAMEWORK_EDITOR=ON
cmake --build .
```

## Obtener Posiciones de NPCs Automáticamente

### Método 1: Comando in-game (Recomendado)

Crea un comando para que los admins agreguen NPCs:

```lua
-- En talkactions
function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return false
    end
    
    local pos = player:getPosition()
    print(string.format('{name = "%s", x = %d, y = %d, z = %d, type = "npc"},', 
        param, pos.x, pos.y, pos.z))
    
    player:sendTextMessage(MESSAGE_INFO_DESCR, "NPC position copied to console!")
    return false
end
```

Uso: `/addnpc Captain Bluebear`

### Método 2: Desde MySQL

Si tienes NPCs en la base de datos:

```sql
SELECT CONCAT(
    '{name = "', name, '", x = ', posx, ', y = ', posy, ', z = ', posz, ', type = "npc"},'
) as lua_code
FROM spawns_npcs;
```

## Personalización

### Cambiar colores

En `fullmap.lua`, busca la función `updateNPCMarkers()`:

```lua
local color = '#00ff00' -- Verde por defecto
if npc.type == 'boss' then
    color = '#ff0000' -- Rojo para bosses
elseif npc.type == 'custom' then
    color = '#ff00ff' -- Magenta para tipo personalizado
end
```

### Cambiar tamaño de ventana

En `fullmap.otui`:

```lua
FullMapWindow < MainWindow
  size: 1200 800  -- Ancho x Alto
```

### Agregar más información a NPCs

Modifica el servidor para enviar más datos:

```lua
-- Servidor
msg:addString(npc.description or "")

-- Cliente (en onReceiveMapData)
description = msg:getString()
```

## Próximas Mejoras Planeadas

- [ ] Parser automático de spawn XML
- [ ] Filtros por tipo de NPC
- [ ] Búsqueda de NPCs por nombre
- [ ] Waypoints personalizados del jugador
- [ ] Exportar/Importar marcadores
- [ ] Integración con sistema de quests
- [ ] Mostrar áreas de hunting
- [ ] Marcadores de dungeons

## Soporte

Para más información, revisa:
- `FULLMAP_SETUP.md` - Guía detallada de instalación
- Consola del cliente (F12) - Mensajes de debug
- Consola del servidor - Logs del sistema
