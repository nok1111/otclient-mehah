# 🎯 WIKI MODULE - MAJOR FIX APPLIED

## ❌ **Problema Original:**
```
[Wiki] ERROR: All loading methods failed
[Wiki] Error details: nil
```

El UI no se cargaba porque estábamos intentando cargarlo en la función `show()`, cuando debería cargarse en `online()`.

---

## ✅ **Solución - Siguiendo Patrón de Otros Módulos**

### **Análisis de Módulos Existentes:**

**PassiveSkills Pattern:**
```lua
function PassiveSkills.onGameStart()
  PassiveSkills.UI = g_ui.displayUI("passiveSkills")  -- ✅ Carga aquí
  PassiveSkills.UI:hide()
end

function PassiveSkills.show()
  PassiveSkills.UI:show()  -- ✅ Solo muestra
  PassiveSkills.UI:raise()
  PassiveSkills.UI:focus()
end
```

**Shops Pattern:**
```lua
function init()
  MainWindow = g_ui.loadUI('shops', g_ui.getRootWidget())  -- ✅ Carga en init
  hide()
end
```

### **Patrón Correcto:**
1. **Cargar UI** en `init()` o `online()` / `onGameStart()`
2. **Ocultar** inmediatamente después de cargar
3. **Mostrar/Ocultar** solo cambia visibilidad, no carga

---

## 🔧 **Cambios Aplicados al Wiki Module:**

### **1. online() - Ahora Carga el UI**
```lua
function online()
  -- Load UI first
  if not wikiWindow then
    print("[Wiki] Loading wiki UI...")
    wikiWindow = g_ui.displayUI('wiki')
    
    if wikiWindow then
      print("[Wiki] UI loaded successfully")
      wikiWindow:hide()  -- ✅ Hide after loading
    else
      print("[Wiki] ERROR: Failed to load wiki.otui")
      return
    end
  end
  
  -- Then create button...
end
```

### **2. show() - Simplificado**
```lua
function show()
  if not wikiWindow then
    print("[Wiki] ERROR: wikiWindow not loaded yet")
    return
  end
  
  print("[Wiki] Showing wiki window")
  
  -- Populate content on first show only
  if not wikiWindow.initialized then
    populateCategories()
    updateLanguageLabel()
    wikiWindow.initialized = true
  end
  
  wikiWindow:show()  -- ✅ Solo muestra
  wikiWindow:raise()
  wikiWindow:focus()
  
  if wikiButton then
    wikiButton:setOn(true)
  end
end
```

### **3. offline() - Limpieza Correcta**
```lua
function offline()
  print("[Wiki] offline() called - cleaning up")
  
  if wikiWindow then
    wikiWindow:destroy()  -- ✅ Destruye UI
    wikiWindow = nil
  end
  
  if wikiButton then
    wikiButton:destroy()  -- ✅ Destruye botón
    wikiButton = nil
  end
end
```

### **4. terminate() - Simplificado**
```lua
function terminate()
  print("[Wiki] Module terminating...")
  
  disconnect(g_game, { onGameStart = online, onGameEnd = offline })
  g_keyboard.unbindKeyDown('Ctrl+H')
  
  offline()  -- ✅ Reutiliza limpieza
  
  print("[Wiki] Module terminated")
end
```

---

## 📊 **Flujo Correcto del Módulo:**

### **Al Iniciar el Cliente:**
```
1. init() called
   └─ Bind hotkeys
   └─ Connect events
   └─ If already online → call online()

2. online() called (cuando entras al juego)
   └─ g_ui.displayUI('wiki') → ✅ UI CARGADO
   └─ wikiWindow:hide() → Oculto inicialmente
   └─ Create button
   └─ Load wiki data
```

### **Al Presionar Ctrl+H o Click Botón:**
```
1. toggle() called
   └─ show() called
       └─ wikiWindow:show() → ✅ SOLO MUESTRA (no carga)
       └─ Populate content (solo primera vez)
```

### **Al Desconectar:**
```
1. offline() called
   └─ wikiWindow:destroy() → ✅ LIMPIA UI
   └─ wikiButton:destroy() → ✅ LIMPIA BOTÓN
```

---

## 🎮 **TESTING:**

### **1. Reinicia el Cliente Completamente**

### **2. Entra al Juego**
Deberías ver en consola:
```
[Wiki] Module initializing...
[Wiki] Module initialized successfully
[Wiki] online() called
[Wiki] Loading wiki UI...
[Wiki] UI loaded successfully
[Wiki] Creating wiki button...
[Wiki] Wiki button created successfully
```

### **3. Presiona Ctrl+H**
Deberías ver:
```
[Wiki] Showing wiki window
```

Y la ventana del Wiki debería aparecer correctamente.

### **4. Presiona Escape o Click "Close"**
La ventana se oculta.

### **5. Desconecta del Juego**
Deberías ver:
```
[Wiki] offline() called - cleaning up
```

---

## 💡 **Diferencias Clave vs. Versión Anterior:**

| Aspecto | ❌ Antes | ✅ Ahora |
|---------|---------|----------|
| **Carga UI** | En `show()` | En `online()` |
| **Método** | `pcall()` con fallbacks | `g_ui.displayUI()` directo |
| **Inicialización** | Cada vez que se muestra | Una sola vez al cargar |
| **Limpieza** | Duplicada en terminate() | Centralizada en offline() |
| **Contenido** | Carga cada show() | Carga solo primera vez |

---

## ✨ **Ventajas del Nuevo Patrón:**

✅ **Consistente** con otros módulos del cliente
✅ **Más eficiente** - UI se carga solo una vez
✅ **Mejor manejo** de errores - falla rápido si hay problema
✅ **Limpieza correcta** - destruye recursos al desconectar
✅ **Debug claro** - mensajes informativos en cada paso

---

## 🚀 **El módulo ahora debería funcionar perfectamente!**

**Próximos pasos:**
1. Reinicia el cliente
2. Entra al juego
3. Presiona Ctrl+H
4. ¡Disfruta tu Wiki!

Si hay algún error, la consola te mostrará exactamente en qué paso falló con mensajes claros.

---

**Patrón aprendido:** Siempre cargar UIs en `online()`/`onGameStart()`, nunca en funciones de show/toggle.
