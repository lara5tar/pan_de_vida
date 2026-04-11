# 🐛 Problema: Inventario General Aparece Vacío en Selección de POS

## 📋 Resumen del Problema

Cuando un **admin librería** entra a la pantalla de "Seleccionar Punto de Venta", el **Inventario General aparece con 0 libros y 0 unidades** aunque sí tenga stock disponible en el backend.

**Ejemplo visual:**
```
❌ Inventario General - 0 libros, 0 unidades
✅ Punto Venta Central - 27 libros, 79 unidades
✅ Punto Venta Sucursal - 15 libros, 45 unidades
```

---

## 🔍 Causa Raíz

### **Endpoint API Involucrado:**
```
GET https://inventario.sistemasdevida.com/api/v1/movil/admin/puntos-venta
```

**Headers requeridos:**
```
Accept: application/json
X-Roles: [{"ROL": "ADMIN LIBRERIA"}, ...]
```

---

### **Respuesta del API (CORRECTA en Hostinger):**
```json
{
  "success": true,
  "data": {
    "inventario_general": {
      "nombre": "Inventario General",
      "total_libros": 127,      ← ESTOS DATOS SIEMPRE VIENEN
      "total_unidades": 450,    ← DEL SERVIDOR
      "estado": "activo"
    },
    "subinventarios": [
      {
        "id": 1,
        "nombre": "Punto Venta Central",
        "total_libros": 27,
        "total_unidades": 79
      },
      {
        "id": 2,
        "nombre": "Punto Venta Sucursal",
        "total_libros": 15,
        "total_unidades": 45
      }
    ]
  }
}
```

---

### **El Bug en el Código:**

**Archivo:** `lib/pandevida/app/modules/punto_de_venta/data/services/subinventario_service.dart`

**Líneas 40-60 (ANTES - INCORRECTO):**
```dart
if (data['inventario_general'] != null) {
  try {
    final invGeneral = data['inventario_general'] as Map<String, dynamic>;
    subinventarios.add(Subinventario(
      id: 0,
      descripcion: invGeneral['nombre'] ?? 'Inventario General',
      fechaSubinventario: DateTime.now().toString(),
      estado: 'activo',
      totalLibros: 0,        // ❌ SIEMPRE 0
      totalUnidades: 0,      // ❌ SIEMPRE 0
      // Los datos estaban disponibles en invGeneral pero NO SE USABAN
    ));
```

**El problema:**
- API envía `invGeneral['total_libros']` y `invGeneral['total_unidades']`
- Código **ignora estos valores**
- Hardcodea todo en 0
- Resultado: Usuario ve "Inventario General - 0, 0"

---

### **Líneas 40-60 (DESPUÉS - CORRECTO):**
```dart
if (data['inventario_general'] != null) {
  try {
    final invGeneral = data['inventario_general'] as Map<String, dynamic>;
    
    // Convertir valores con validación
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }
    
    subinventarios.add(Subinventario(
      id: 0,
      descripcion: invGeneral['nombre'] ?? 'Inventario General',
      fechaSubinventario: DateTime.now().toString(),
      estado: 'activo',
      totalLibros: toInt(invGeneral['total_libros']),      // ✅ LEE DEL API
      totalUnidades: toInt(invGeneral['total_unidades']),  // ✅ LEE DEL API
    ));
    print('✅ Inventario general: ${toInt(invGeneral['total_libros'])} libros, ${toInt(invGeneral['total_unidades'])} unidades');
```

---

## 🔄 Flujo de Carga

### **Paso 1: Login del Admin**
```
Usuario entra a la app con rol "ADMIN LIBRERIA" o "SUPERVISOR"
  ↓
Sistema obtiene roles y los guarda en GetStorage
```

**Archivo:** `lib/pandevida/app/modules/punto_de_venta/modules/subinventario_selection/controllers/subinventario_selection_controller.dart`

```dart
void _checkIfAdminLibreria() {
  try {
    final roles = _getUserRoles();
    const fullAccessRoles = {'ADMIN LIBRERIA', 'SUPERVISOR'};
    
    isAdminLibreria.value = roles.any(
      (role) => fullAccessRoles.contains(role['ROL']),
    );
    
    print('Usuario admin librería: ${isAdminLibreria.value}');
  } catch (e) {
    print('Error verificando rol: $e');
  }
}
```

---

### **Paso 2: Clic en "Punto de Venta"**
```
if (isAdminLibreria.value) {
  // Llamar a getTodosPuntosVenta (para ADMINS)
  result = await _service.getTodosPuntosVenta(roles);
} else {
  // Llamar a getMisSubinventarios (para vendedores normales)
  result = await _service.getMisSubinventarios(codCongregante);
}
```

---

### **Paso 3: getTodosPuntosVenta - Llamada a API**
```
GET https://inventario.sistemasdevida.com/api/v1/movil/admin/puntos-venta
Header: X-Roles: [{"ROL": "ADMIN LIBRERIA"}]
  ↓
API retorna:
{
  "success": true,
  "data": {
    "inventario_general": {
      "total_libros": 127,      ← ¡AQUÍ ESTÁN LOS DATOS!
      "total_unidades": 450,
      ...
    },
    "subinventarios": [...]
  }
}
  ↓
[BUG ANTERIOR] Códigoignoraba total_libros y total_unidades
  ↓
[FIX APLICADO] Ahora lee estos campos correctamente
```

---

### **Paso 4: Visualización en UI**
```
SubinventarioSelectionView
  ↓
_buildSubinventarioCard(subinventario)
  ↓
_buildInfoChip() para mostrar:
  - Icon: Libros
  - Value: subinventario.totalLibros  ← Ahora correcto
  
  - Icon: Unidades  
  - Value: subinventario.totalUnidades ← Ahora correcto
```

**Vista:** `lib/pandevida/app/modules/punto_de_venta/modules/subinventario_selection/views/subinventario_selection_view.dart`

```dart
Row(
  children: [
    Expanded(
      child: _buildInfoChip(
        icon: Icons.menu_book,
        label: 'Libros',
        value: '${subinventario.totalLibros}',  // ← Antes: 0, Ahora: 127
        color: Colors.blue,
      ),
    ),
    Expanded(
      child: _buildInfoChip(
        icon: Icons.inventory_2,
        label: 'Unidades',
        value: '${subinventario.totalUnidades}',  // ← Antes: 0, Ahora: 450
        color: Colors.green,
      ),
    ),
  ],
)
```

---

## 🛠️ Métodos Involucrados

### **1. SubinventarioSelectionController.cargarSubinventarios()**
**Archivo:** `lib/pandevida/app/modules/punto_de_venta/modules/subinventario_selection/controllers/subinventario_selection_controller.dart`

```dart
Future<void> cargarSubinventarios() async {
  try {
    isLoading.value = true;
    
    Map<String, dynamic> result;
    
    if (isAdminLibreria.value) {
      // ← Detecta si es admin
      final roles = _getUserRoles();
      result = await _service.getTodosPuntosVenta(roles);  // ← API para admins
    } else {
      // ← Usuario normal
      final codCongregante = AuthService.getCodCongregante();
      result = await _service.getMisSubinventarios(codCongregante);  // ← API para vendedores
    }
    
    if (result['error'] == false) {
      subinventarios.value = result['data'];
      
      if (subinventarios.length == 1) {
        // Si solo hay inventario general o 1 punto de venta, entra directo
        seleccionarSubinventario(subinventarios.first);
      }
    }
  } finally {
    isLoading.value = false;
  }
}
```

---

### **2. SubinventarioService.getTodosPuntosVenta() [AJUSTADO]**
**Archivo:** `lib/pandevida/app/modules/punto_de_venta/data/services/subinventario_service.dart`

**Antes (BUG):**
```dart
totalLibros: 0,       // ❌ HARDCODEADO
totalUnidades: 0,     // ❌ HARDCODEADO
```

**Después (CORRECTO):**
```dart
totalLibros: toInt(invGeneral['total_libros']),       // ✅ LEE DEL API
totalUnidades: toInt(invGeneral['total_unidades']),   // ✅ LEE DEL API
```

---

## 📝 Comparación: Admin vs Usuario Normal

| Aspecto | Admin Librería | Usuario Normal/Vendedor |
|---------|---|---|
| **Ruta** | `/punto-de-venta` → selección | `/punto-de-venta` → selección |
| **Controller** | `SubinventarioSelectionController` | `SubinventarioSelectionController` |
| **Operación** | `_checkIfAdminLibreria() = true` | `_checkIfAdminLibreria() = false` |
| **Llamada API** | `getTodosPuntosVenta(roles)` | `getMisSubinventarios(codCongregante)` |
| **Endpoint** | `/api/v1/movil/admin/puntos-venta` | `/api/v1/mis-subinventarios/{cod}` |
| **Ver Inventario General** | ✅ Sí (con este fix) | ❌ No |
| **Ver sus Subinventarios** | ✅ Sí | ✅ Sí |
| **Datos mostrados** | Inv. General + todos los puntos | Solo sus asignados |

---

## 🔌 Endpoint Específico para Admins

### **Endpoint:** 
```
GET https://inventario.sistemasdevida.com/api/v1/movil/admin/puntos-venta
```

### **Request:**
```bash
curl -X GET "https://inventario.sistemasdevida.com/api/v1/movil/admin/puntos-venta" \
  -H "Accept: application/json" \
  -H "X-Roles: [{\"ROL\": \"ADMIN LIBRERIA\"}]"
```

### **Response Esperado:**
```json
{
  "success": true,
  "message": "Datos cargados",
  "data": {
    "inventario_general": {
      "id": null,
      "nombre": "Inventario General",
      "descripcion": "Stock disponible en la librería central",
      "total_libros": 127,
      "total_unidades": 450,
      "estado": "activo",
      "libros": [...]  // Opcional
    },
    "subinventarios": [
      {
        "id": 1,
        "descripcion": "Punto de Venta Central",
        "fecha_subinventario": "2025-12-30",
        "estado": "activo",
        "total_libros": 27,
        "total_unidades": 79,
        "libros": [...]
      },
      {
        "id": 2,
        "descripcion": "Punto de Venta Sucursal",
        "fecha_subinventario": "2025-12-15",
        "estado": "activo",
        "total_libros": 15,
        "total_unidades": 45,
        "libros": [...]
      }
    ]
  }
}
```

---

## 🚀 Resultado Esperado Después del Fix

### **Antes (BUG):**
```
📱 Seleccionar Punto de Venta

Inventario General
├── Libros: 0        ← ❌ INCORRECTO
├── Unidades: 0      ← ❌ INCORRECTO
└── [Muestra vacío]

Punto de Venta Central
├── Libros: 27       ← ✅ CORRECTO
├── Unidades: 79     ← ✅ CORRECTO
└── [Accesible]

Punto de Venta Sucursal  
├── Libros: 15       ← ✅ CORRECTO
├── Unidades: 45     ← ✅ CORRECTO
└── [Accesible]
```

### **Después (FIX APLICADO):**
```
📱 Seleccionar Punto de Venta

Inventario General
├── Libros: 127      ← ✅ AHORA CORRECTO (leído del API)
├── Unidades: 450    ← ✅ AHORA CORRECTO (leído del API)
└── [Totalmente funcional]

Punto de Venta Central
├── Libros: 27       ← ✅ CORRECTO
├── Unidades: 79     ← ✅ CORRECTO
└── [Accesible]

Punto de Venta Sucursal
├── Libros: 15       ← ✅ CORRECTO
├── Unidades: 45     ← ✅ CORRECTO
└── [Accesible]
```

---

## 📊 Diagrama de Flujo

```
┌──────────────────────────────────────────────┐
│   Admin entra a "Punto de Venta"            │
└──────────────┬───────────────────────────────┘
               │
               ↓
    ┌─────────────────────────────┐
    │ SubinventarioSelectionView  │
    │ onInit()                    │
    └──────────┬──────────────────┘
               │
               ↓
    ┌──────────────────────────────────────┐
    │ _checkIfAdminLibreria()              │
    │ isAdminLibreria = true               │
    └──────────┬───────────────────────────┘
               │
               ↓
    ┌──────────────────────────────────────┐
    │ cargarSubinventarios()               │
    │ if (isAdminLibreria) {               │
    │   getTodosPuntosVenta(roles)         │
    │ }                                     │
    └──────────┬───────────────────────────┘
               │
               ↓
    ┌─────────────────────────────────────────────┐
    │ API Request                                 │
    │ GET /api/v1/movil/admin/puntos-venta       │
    │ Headers:                                    │
    │   Accept: application/json                  │
    │   X-Roles: [{"ROL": "ADMIN LIBRERIA"}]      │
    └──────────┬────────────────────────────────┘
               │
               ↓ [200 OK]
    ┌──────────────────────────────────────────────────┐
    │ Response JSON                                    │
    │ {                                                │
    │   "data": {                                      │
    │     "inventario_general": {                      │
    │       "total_libros": 127,  ← ¡AQUÍ ESTÁ!       │
    │       "total_unidades": 450  ← ¡AQUÍ ESTÁ!      │
    │     },                                           │
    │     "subinventarios": [...]                      │
    │   }                                              │
    │ }                                                │
    └──────────┬───────────────────────────────────┘
               │
               ↓
    ┌──────────────────────────────────────────────┐
    │ getTodosPuntosVenta() PROCESA RESPUESTA      │
    │                                               │
    │ [ANTES - BUG]                                │
    │ totalLibros: 0         ❌ IGNORA DATA        │
    │ totalUnidades: 0       ❌ IGNORA DATA        │
    │                                               │
    │ [DESPUÉS - FIX]                              │
    │ totalLibros: 127       ✅ USA DATA DEL API  │
    │ totalUnidades: 450     ✅ USA DATA DEL API  │
    └──────────┬───────────────────────────────────┘
               │
               ↓
    ┌──────────────────────────────────────────┐
    │ SubinventarioSelectionView               │
    │ Muestra tarjetas con datos correctos     │
    │                                           │
    │ Inventario General - 127 libros, 450 u.  │
    │ Punto Venta Central - 27 libros, 79 u.   │
    │ Punto Venta Sucursal - 15 libros, 45 u.  │
    └──────────────────────────────────────────┘
```

---

## 🔍 Debugging - Cómo Verificar

### **En Consola (Debug/Flutter Inspector):**

Buscar logs como:
```
✅ Inventario general agregado: 127 libros, 450 unidades
✅ Total subinventarios: 3
```

O ver el error:
```
⚠️ Error procesando inventario general: [error details]
```

---

### **En la App:**

1. Loguea como usuario con rol "ADMIN LIBRERIA"
2. Ve a Dashboard → Punto de Venta
3. Verifica que aparezca información del Inventario General
4. Los números NO deben ser 0

---

## ✅ Fix Aplicado

**Archivo modificado:** `lib/pandevida/app/modules/punto_de_venta/data/services/subinventario_service.dart`

**Cambios:**
- ✅ Ahora lee `total_libros` del API
- ✅ Ahora lee `total_unidades` del API  
- ✅ Incluye función `toInt()` para convertir valores de forma segura
- ✅ Logs mejorados para debugging

**Resultado:**
- ✅ Inventario General muestra números reales
- ✅ Usuario admin ve la información correcta
- ✅ Ya funciona como el sistema en Hostinger

---

## 📌 Notas Finales

- **endpoint para admins:** `/api/v1/movil/admin/puntos-venta`
- **endpoint para vendedores:** `/api/v1/mis-subinventarios/{cod_congregante}`
- **El bug afectaba solo a admins** (vendedores normales se ven bien)
- **Ya está corregido** - El inventario general ahora muestra datos reales
