# Instalación Rápida - Full Map System

## Paso 1: Crear estructura de carpetas

```bash
# Desde la carpeta otclient-mehah
mkdir maps
mkdir maps\otbm
mkdir maps\otcm
mkdir maps\minimap
```

## Paso 2: Copiar mapa del servidor

```bash
# Copiar OTBM para visualización completa
copy ..\Ascension-1.4.2\data\world\map.otbm maps\otbm\map.otbm

# Si tienes cross_map también
copy ..\Ascension-1.4.2\data\world\cross_map.otbm maps\otbm\cross_map.otbm
```

## Paso 3: Verificar archivos del servidor

Los archivos ya están creados en:
- `Ascension-1.4.2\data\scripts\fullmap\fullmap_server.lua`

**¡No necesitas editar nada!** Los NPCs se cargan automáticamente desde:
- `data/world/map-spawn.xml`
- `data/world/cross_map-spawn.xml`

## Paso 4: Abrir el mapa en el juego

### Opción A: Agregar botón al UI

Edita `otclient-mehah\modules\game_interface\gameinterface.lua` y agrega:

```lua
-- Después de otros botones
modules.game_mainpanel.addStoreButton('fullMapButton', 'World Map', '/images/icons/map', 
  function() modules.game_fullmap.toggle() end, false, 3)
```

### Opción B: Usar comando en consola

1. Presiona F12 para abrir consola
2. Escribe:
```lua
modules.game_fullmap.show()
```

## Verificación

### En el servidor (consola):
```
[FullMap] Parsing NPC spawns from XML files...
[FullMap] Reading: data/world/map-spawn.xml
[FullMap] Loaded X NPC positions from XML
```

### En el cliente (consola F12):
```
[FullMap] Loading OTBM map: /maps/otbm/map.otbm
[FullMap] OTBM map loaded successfully!
[FullMap] Received X NPC locations
```

## Troubleshooting

### "Map file not found"
- Verifica que copiaste el archivo a `otclient-mehah\maps\otbm\map.otbm`
- Revisa que la carpeta `maps` existe en la raíz del cliente

### "OTBM loading not available"
- El cliente necesita estar compilado con `FRAMEWORK_EDITOR=ON`
- Recompila el cliente si es necesario

### NPCs no aparecen
- Verifica la consola del servidor para ver cuántos NPCs se cargaron
- Asegúrate que los archivos XML existen en `data/world/`

## Estructura Final

```
otclient-mehah/
├── maps/
│   ├── otbm/
│   │   └── map.otbm          ← Tu mapa aquí
│   ├── otcm/
│   └── minimap/
└── modules/
    └── game_fullmap/
        ├── fullmap.otmod
        ├── fullmap.otui
        └── fullmap.lua

Ascension-1.4.2/
└── data/
    ├── scripts/
    │   └── fullmap/
    │       └── fullmap_server.lua
    └── world/
        ├── map-spawn.xml      ← NPCs se leen de aquí
        └── cross_map-spawn.xml
```

## ¡Listo!

El sistema está configurado. Al conectarte al servidor:
1. El servidor parsea automáticamente los NPCs desde XML
2. El cliente carga el mapa OTBM
3. Presiona el botón "World Map" o usa el comando
4. ¡Disfruta del mapa completo con todos los NPCs marcados!
