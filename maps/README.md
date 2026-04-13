# Maps Folder

Esta carpeta contiene todos los archivos relacionados con el mapa del servidor.

## Estructura

```
maps/
├── otbm/           - Archivos OTBM del servidor (visualización completa)
├── otcm/           - Archivos OTCM del cliente (alternativa ligera)
├── minimap/        - Archivos de minimap (.otmm)
└── README.md       - Este archivo
```

## Instalación

### 1. Copiar mapa OTBM (Recomendado)

Para visualización completa del mapa con sprites reales:

```bash
# Copiar desde servidor
copy "Ascension-1.4.2\data\world\map.otbm" "otclient-mehah\maps\otbm\map.otbm"
```

### 2. Copiar minimap (Opcional)

Si tienes archivos de minimap pre-generados:

```bash
copy "minimap.otmm" "otclient-mehah\maps\minimap\minimap.otmm"
```

## Uso

El módulo `game_fullmap` carga automáticamente los archivos desde esta carpeta:

1. Primero intenta cargar `/maps/otbm/map.otbm` (visualización completa)
2. Si no existe, intenta `/maps/otcm/map.otcm` (alternativa)
3. Si ninguno existe, el mapa se descubre mientras juegas

## Notas

- Los archivos OTBM son más pesados pero muestran sprites reales
- Los archivos OTCM son más ligeros pero solo muestran tiles básicos
- El minimap se genera automáticamente mientras exploras
