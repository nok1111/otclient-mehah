# 🔧 WIKI MODULE - ERROR FIXES APPLIED

## ❌ Error Original:
```
ERROR: Lua exception: /game_wiki/wiki.lua:109: attempt to index global 'wikiWindow' (a nil value)
```

## ✅ Soluciones Aplicadas:

### 1. **Manejo de Errores en show()**
- Agregado debug logging para rastrear carga de UI
- Agregado check de nil antes de usar wikiWindow
- Agregado return temprano si el UI falla al cargar

**Cambio en wiki.lua líneas 77-99:**
```lua
function show()
  if not wikiWindow then
    print("[Wiki] Attempting to load UI...")
    wikiWindow = g_ui.displayUI('wiki')
    
    if not wikiWindow then
      print("[Wiki] ERROR: Failed to load wiki.otui - wikiWindow is nil")
      return
    end
    
    print("[Wiki] UI loaded successfully")
    populateCategories()
    updateLanguageLabel()
  end
  
  wikiWindow:show()
  wikiWindow:raise()
  wikiWindow:focus()
  
  if wikiButton then
    wikiButton:setOn(true)
  end
end
```

### 2. **Referencias Corregidas en wiki.otui**
Cuando un módulo está en `mods/` en lugar de `modules/`, las referencias necesitan usar `g_mods.getModule()` en lugar de `modules.xxx`

**Cambios aplicados:**
- `@onEscape: modules.game_wiki.hide()` → `@onEscape: g_mods.getModule('game_wiki').hide()`
- `@onTextChange: modules.game_wiki.onSearchTextChange()` → `@onTextChange: g_mods.getModule('game_wiki').onSearchTextChange()`
- `@onClick: modules.game_wiki.changeLanguage()` → `@onClick: g_mods.getModule('game_wiki').changeLanguage()`
- `@onClick: modules.game_wiki.hide()` → `@onClick: g_mods.getModule('game_wiki').hide()`

---

## 🧪 Testing:

1. **Reinicia el cliente**
2. **Verifica la consola** al iniciar el juego
3. Deberías ver:
   ```
   [Wiki] Module initializing...
   [Wiki] Module initialized successfully
   [Wiki] online() called
   [Wiki] Creating wiki button...
   [Wiki] Wiki button created successfully
   ```
4. **Click en el botón Wiki** o presiona **Ctrl+H**
5. Deberías ver:
   ```
   [Wiki] Attempting to load UI...
   [Wiki] UI loaded successfully
   ```

---

## 🔍 Si el Problema Persiste:

### Opción A: Problema con MainWindow
Si ves error sobre `MainWindow`, puede ser que falte el módulo base.

**Solución:** Cambia la primera línea de `wiki.otui` de:
```
WikiWindow < MainWindow
```
A:
```
WikiWindow < Window
```

### Opción B: Problema con g_ui.displayUI
Si el UI no carga, intenta cargar explícitamente desde el path del mod:

**En wiki.lua, función show(), línea 80, cambia:**
```lua
wikiWindow = g_ui.displayUI('wiki')
```
**A:**
```lua
local uiPath = g_resources.resolvePath('wiki.otui')
wikiWindow = g_ui.loadUI(uiPath)
```

### Opción C: Verificar Dependencias
Asegúrate que el módulo tiene las dependencias correctas en `wiki.otmod`:
```
dependencies: [game_interface, game_mainpanel]
```

Si `game_mainpanel` no existe, cámbialo a:
```
dependencies: [game_interface]
```

Y actualiza `wiki.lua` línea 45:
```lua
if modules.game_mainpanel then
  wikiButton = modules.game_mainpanel.addToggleButton(...)
```
A:
```lua
if modules.client_topmenu then
  wikiButton = modules.client_topmenu.addRightToggleButton(...)
```

---

## 📋 Checklist de Archivos en mods/game_wiki/:

- ✅ wiki.otmod (descriptor del módulo)
- ✅ wiki.lua (lógica principal - ACTUALIZADO)
- ✅ wiki.otui (interfaz - ACTUALIZADO)
- ✅ wiki_data.lua (contenido)
- ✅ README.md (documentación)
- ✅ SETUP_COMPLETE.md (guía de setup)
- ✅ ICON_INSTRUCTIONS.txt (instrucciones ícono)
- ✅ FIX_APPLIED.md (este archivo)

---

## 💡 Notas Importantes:

1. **Mods vs Modules:**
   - `mods/` = Módulos personalizados, usan `g_mods.getModule()`
   - `modules/` = Módulos core del cliente, usan `modules.xxx`

2. **UI Loading:**
   - `g_ui.displayUI('name')` busca el archivo en el directorio del módulo
   - Debe existir `name.otui` en la misma carpeta
   - Si falla, retorna `nil`

3. **Debug:**
   - Siempre revisa la consola del cliente para mensajes de error
   - Los `print()` agregados te ayudarán a identificar en qué paso falla

---

## 🚀 Próximos Pasos:

1. Reinicia el cliente
2. Verifica logs en consola
3. Intenta abrir el Wiki
4. Si hay errores, revisa las opciones A, B, C arriba
5. Reporta cualquier error nuevo con el log completo

---

**¡El módulo debería funcionar ahora!** 🎉

Si persisten los errores, comparte el log completo de la consola para diagnóstico adicional.
