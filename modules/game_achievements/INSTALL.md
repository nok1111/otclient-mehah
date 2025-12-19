# 🎮 Achievement System - Client Installation

## ✅ **PASOS COMPLETADOS:**

1. ✅ Módulo agregado a `modules/game_interface/interface.otmod`
2. ✅ Archivos `.otmod`, `.lua`, `.otui` creados
3. ✅ Opcodes registrados en `modules/gamelib/const.lua` y `protocol.lua`
4. ✅ OTUI arreglado (sin emojis, sin referencias circulares)
5. ✅ Manejo de errores mejorado

---

## 🚀 **CÓMO PROBAR:**

### **1. Reiniciar Cliente**
Cierra y vuelve a abrir el cliente OTClient.

### **2. Conectarse al Servidor**
El servidor debe tener los scripts de achievements cargados.

### **3. Abrir Ventana de Achievements**
- **Botón:** Click en "Achievements" en el top menu
- **Hotkey:** Presiona `Ctrl+H`

---

## 🐛 **SI HAY ERRORES:**

### **Error: "Failed to load achievements.otui"**
- Verifica que el archivo `achievements.otui` existe
- Revisa la consola del cliente para errores de parsing
- Asegúrate de que no hay errores de sintaxis en el .otui

### **Error: "attempt to index global 'achievementWindow'"**
- Este error ya fue corregido con verificación de nil
- Si persiste, verifica que MainWindow esté disponible

### **La ventana se abre pero está vacía**
- Verifica que el servidor está enviando datos
- Revisa console del cliente: `F12` para ver logs
- Verifica que los opcodes coinciden (81-86)

---

## 📦 **ASSETS OPCIONALES:**

Por el momento, el sistema usa texto (`?`, `!`, `✓`) para los status icons.

Si quieres agregar iconos visuales, crea estas imágenes:
```
data/images/achievements/
├── locked.png        # Icon para achievements bloqueados
├── completed.png     # Icon para achievements completados
└── claimed.png       # Icon para achievements reclamados
```

Y luego actualiza `achievements.otui` línea 215-225:
```otui
// Status Icon (top-right corner)
UIWidget
  id: statusIcon
  anchors.top: parent.top
  anchors.right: parent.right
  margin-top: 5
  margin-right: 5
  size: 16 16
  image-source: /images/achievements/locked
```

---

## 🔧 **CONFIGURACIÓN:**

### **Cambiar Hotkey**
En `achievements.lua` línea ~50:
```lua
g_keyboard.bindKeyDown('Ctrl+H', toggle)
```

### **Cambiar Posición del Botón**
En `achievements.lua` línea ~46:
```lua
achievementButton = modules.client_topmenu.addRightGameToggleButton('achievementButton',
  tr('Achievements') .. ' (Ctrl+H)', '/images/topbuttons/achievements',
  toggle, false, 8)  -- El 8 es la posición
```

---

## 📊 **VERIFICACIÓN:**

### **Consola del Cliente (F12):**
Busca estas líneas al conectar:
```
Module 'game_achievements' loaded
```

### **Consola del Servidor:**
Busca estas líneas al iniciar:
```
>> Achievement System Library loaded
>> Achievement Data loaded (19 achievements)
>> Achievement System initialized successfully
>> Achievement Events loaded
>> Achievement Commands loaded
>> Achievement Opcodes loaded
```

---

## ✅ **SISTEMA FUNCIONAL SI:**

1. ✅ La ventana se abre con `Ctrl+H` o click en botón
2. ✅ Se muestran las 6 categorías en el panel izquierdo
3. ✅ Al hacer click en una categoría, se cargan achievements
4. ✅ Los progress bars muestran progreso correctamente
5. ✅ El botón "Claim" aparece cuando completas un achievement

---

## 🎯 **TROUBLESHOOTING RÁPIDO:**

| Problema | Solución |
|----------|----------|
| Ventana no abre | Verifica .otui sin errores, console F12 |
| Lista vacía | Verifica servidor envía datos, opcodes correctos |
| Error de anchors | Ya corregido, restart cliente |
| Status icons no se ven | Normal, usa texto por defecto |
| Botón no aparece | Verifica topbuttons registrado |

---

**¡Sistema listo para usar!** 🎉

**Problemas comunes ya arreglados:**
- ✅ Emojis removidos (causaban parsing errors)
- ✅ Referencias circulares arregladas
- ✅ Verificación de nil agregada
- ✅ Status icons usando texto en lugar de imágenes faltantes

**Restart el cliente y debería funcionar!** 🚀
