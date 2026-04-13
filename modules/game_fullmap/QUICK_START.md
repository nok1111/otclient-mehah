# Guía Rápida - Mapa Completo

## ¿Qué es esto?

El **minimap normal** (ventana pequeña) y el **World Map** (mapa completo) son **dos sistemas diferentes**:

- 🗺️ **Minimap** - Ventana pequeña que se descubre al caminar
- 🌍 **World Map** - Mapa completo del servidor con NPCs marcados

## Cómo Abrir el Mapa Completo

### Opción 1: Atajo de Teclado (Más Rápido)
```
Ctrl + W
```

### Opción 2: Comando en Chat
```
/worldmap
/map
!map
```

### Opción 3: Consola (F12)
```lua
modules.game_fullmap.show()
```

## Controles del Mapa Completo

| Acción | Control |
|--------|---------|
| Abrir/Cerrar | `Ctrl + W` o `ESC` |
| Zoom In/Out | Scroll del mouse |
| Mover mapa | Click y arrastrar |
| Centrar en jugador | Botón "Center on Player" |
| Fullscreen | Botón "Fullscreen" |
| Click en NPC | Centra el mapa en ese NPC |

## Diferencias

### Minimap Normal (Pequeño)
- Se descubre al caminar
- Muestra solo área explorada
- Ventana pequeña en la esquina
- No muestra NPCs

### World Map (Completo)
- Muestra TODO el mapa desde el inicio
- Sprites reales del OTBM
- Ventana grande/maximizada
- Muestra TODOS los NPCs con nombres y colores
- Lista clickeable de NPCs

## Tipos de Marcadores

- 🟢 **Verde** - NPCs normales
- 🔴 **Rojo** - Bosses
- 🟡 **Amarillo** - Trainers
- 🔵 **Cyan** - Shops/Merchants
- 🟣 **Magenta** - Outfit NPCs
- ⚪ **Blanco** - Tu posición (actualizada en tiempo real)

## Instalación

1. Crear carpeta:
```bash
mkdir otclient-mehah\maps\otbm
```

2. Copiar mapa:
```bash
copy Ascension-1.4.2\data\world\map.otbm otclient-mehah\maps\otbm\map.otbm
```

3. ¡Listo! Presiona `Ctrl + W` en el juego

## Troubleshooting

### "No pasa nada al presionar Ctrl+W"
- Verifica que el módulo esté cargado: `modules.game_fullmap` en consola (F12)
- Intenta con el comando: `/worldmap`

### "El mapa se ve vacío"
- Verifica que copiaste `map.otbm` a `maps/otbm/`
- Revisa la consola (F12) para ver mensajes de error

### "No veo NPCs"
- Los NPCs se cargan automáticamente desde el servidor
- Verifica la consola del servidor para ver si se parsearon los XML

## Comandos Útiles

```lua
-- Abrir mapa
modules.game_fullmap.show()

-- Abrir en fullscreen
modules.game_fullmap.showFullscreen()

-- Cerrar
modules.game_fullmap.hide()

-- Toggle (abrir/cerrar)
modules.game_fullmap.toggle()

-- Centrar en jugador
modules.game_fullmap.centerOnPlayer()
```

## Atajos de Teclado

| Tecla | Acción |
|-------|--------|
| `Ctrl + W` | Abrir/Cerrar World Map |
| `ESC` | Cerrar World Map |
| `Scroll` | Zoom In/Out |

## Más Información

- `README.md` - Documentación completa
- `INSTALLATION.md` - Guía de instalación detallada
- `FULLMAP_SETUP.md` - Configuración avanzada
