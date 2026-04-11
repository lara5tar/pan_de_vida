# 📊 Análisis: Obtención de Libros en Inventario General vs Subinventarios

## 🎯 Resumen Ejecutivo

**Sistema Actual (Aplicación Flutter Mobile):**
- ✅ Obtiene libros **DE UN SUBINVENTARIO ESPECÍFICO** (punto de venta asignado)
- ✅ El usuario selecciona qué punto de venta usa
- ✅ Solo ve libros disponibles EN ESE SUBINVENTARIO
- ❌ **NO accede al inventario general directamente** (salvo para roles especiales)

**Sistema en Hostinger:**
- Maneja un **Inventario General** central
- Maneja múltiples **Subinventarios** (puntos de venta)
- Vinculación de libros en ambos niveles
- Control de disponibilidad desde ambos niveles

---

## 🔄 Flujo Actual de Obtención de Libros

### 1. **Inicio de Sesión y Preparación**
```
Usuario inicia sesión → App obtiene `cod_congregante`
```

**Archivo:** `lib/pandevida/app/modules/punto_de_venta/modules/subinventario_selection/`

Data preservada en el storage:
- `codCongregante` - Código del usuario (ej: "14279")
- Otros datos de seguridad

---

### 2. **Paso 1: Listar Subinventarios Disponibles**

**Endpoint API:**
```
GET https://inventario.sistemasdevida.com/api/v1/mis-subinventarios/{cod_congregante}
```

**Archivo:** `lib/pandevida/app/modules/punto_de_venta/data/services/subinventario_service.dart` 
- Método: `getMisSubinventarios(codCongregante)`
- Línea ~100

**Request:**
```http
GET /api/v1/mis-subinventarios/14279
Header: Accept: application/json
```

**Response (Ejemplo):**
```json
{
  "success": true,
  "message": "Subinventarios encontrados",
  "data": [
    {
      "id": 1,
      "descripcion": "Punto de Venta Central",
      "fecha_subinventario": "2025-12-30",
      "estado": "activo",
      "total_libros": 27,
      "total_unidades": 79,
      "libros": [
        {
          "id": 12,
          "nombre": "Biblia Reina Valera 1960",
          "codigo_barras": "9788408234567",
          "precio": 350.00,
          "stock_general": 50,
          "cantidad_disponible": 10
        },
        // ... más libros
      ]
    },
    {
      "id": 2,
      "descripcion": "Punto de Venta Sucursal",
      "total_libros": 15,
      "total_unidades": 45,
      "libros": [...]
    }
  ]
}
```

**Lo que ocurre en esta llamada:**
1. ✅ Se obtienen TODOS los subinventarios asignados al usuario
2. ✅ Cada subinventario trae información de su stock
3. ✅ Cada subinventario trae lista completa de libros disponibles
4. ⚠️ **Los libros vienen filtrados** - Solo muestra libros con stock > 0

**Vista Responsable:** 
- `modules/subinventario_selection/views/subinventario_selection_view.dart`
- Muestra lista de puntos de venta disponibles
- Usuario selecciona uno (o si hay solo 1, se selecciona automáticamente)

---

### 3. **Paso 2: Cargar Libros del Subinventario Seleccionado**

**Endpoint API:**
```
GET https://inventario.sistemasdevida.com/api/v1/subinventarios/{id}/libros?cod_congregante={cod_congregante}
```

**Archivo:** `lib/pandevida/app/modules/punto_de_venta/data/services/subinventario_service.dart`
- Método: `getLibrosSubinventario(subinventarioId, codCongregante)`
- Línea ~160

**Request:**
```http
GET /api/v1/subinventarios/1/libros?cod_congregante=14279
Header: Accept: application/json
Header: X-Roles: json.encode(roles)
```

**Response:**
```json
{
  "success": true,
  "data": {
    "subinventario": {
      "id": 1,
      "nombre": "Punto de Venta Central",
      "total_libros": 27,
      "total_unidades": 79
    },
    "libros": [
      {
        "id": 12,
        "nombre": "Biblia Reina Valera 1960",
        "codigo_barras": "9788408234567",
        "precio": 350.00,
        "stock_general": 50,
        "cantidad_disponible": 10
      }
    ]
  }
}
```

**Controller Responsable:**
- `modules/pos_view/controllers/pos_view_controller.dart`
- Línea ~50: Método `cargarLibrosSubinventario()`
- Rellena `RxList<LibroSubinventario> librosDisponibles`

**Modelos Involucrados:**
```dart
class Subinventario {
  final int id;
  final int totalLibros;        // Cantidad de títulos distintos
  final int totalUnidades;      // Cantidad total de unidades
  List<LibroSubinventario>? libros;
}

class LibroSubinventario {
  final int id;
  final String nombre;
  final String? codigoBarras;
  final double precio;
  final int cantidadDisponible;  // ← Stock EN ESE SUBINVENTARIO
}
```

---

### 4. **Paso 3: Usar los Libros en el Punto de Venta**

**Archivo:** `modules/pos_view/views/pos_view.dart`

**Opciones para Agregar Libros:**

#### Opción A: Escaneo de Código de Barras
```dart
findBookByBarcode(codigo)
  ↓
buscarLibroPorCodigo() → SubinventarioService API
  ↓
Busca en librosDisponibles (libros cargados)
  ↓
Valida que exista en el subinventario activo
  ↓
Agrega a carrito si can_vender = true y hay stock
```

#### Opción B: Búsqueda Manual
```dart
showSearchBookDialog()
  ↓
Filtra de librosDisponibles
  ↓
Usuario selecciona
  ↓
Agrega a carrito
```

---

## 📊 Comparación: Sistema Actual vs Sistema Hostinger

### **SISTEMA ACTUAL (APP FLUTTER)**

| Aspecto | Actual |
|---------|--------|
| **Obtención de libros** | Del subinventario seleccionado |
| **Alcance de datos** | Un solo subinventario a la vez |
| **Inventario General** | ❌ No visible en POS (solo admin puede) |
| **Múltiples subinventarios** | ✅ Se selecciona cuál usar |
| **Flujo básico** | Seleccionar subinventario → Vender de ese subinventario |
| **Acceso a inventario total** | ❌ No en vendedor normal |

**Código de validación:**
```dart
// En pos_view_controller.dart, línea ~167
if (!book.esVendible) {
  // No permite vender si no está en el subinventario actual
  Get.snackbar('No disponible', 
    'No puedes vender "${book.nombre}" porque no está en tu subinventario actual.');
  return;
}
```

---

### **SISTEMA HOSTINGER ESPERADO**

| Aspecto | Hostinger |
|---------|-----------|
| **Obtención de libros** | Del inventario general O de un subinventario |
| **Alcance de datos** | Acceso a inventario general + subinventarios |
| **Inventario General** | ✅ Visible y vendible (para roles específicos) |
| **Múltiples subinventarios** | ✅ Seleccionar punto de venta |
| **Flujo esperado** | Admin librería puede vender del inventario general |
| **Acceso a inventario total** | ✅ Disponible según permisos (roles) |

---

## 🔑 Puntos Críticos de la API

### **Parámetro: `cod_congregante`**
```
¿Qué es? Identificador único del usuario (vendedor)
¿Para qué? 
  - Obtener sus subinventarios
  - Validar acceso a libros
  - Saber qué puede vender
```

**Ejemplo:** `cod_congregante=14279`

---

### **Información en Libros**

```json
{
  "id": 12,
  "nombre": "Biblia Reina Valera 1960",
  "precio": 350.00,
  
  // ← Stock en INVENTARIO GENERAL
  "stock_general": 50,
  
  // ← Stock en ESTE SUBINVENTARIO
  "cantidad_disponible": 10,
  
  // En la API /libros con cod_congregante:
  "stock": 50,                      // General
  "stock_subinventario": 20,        // En subinventarios
  "stock_apartado": 5,              // En apartados
  "puede_vender": true,             // Este vendedor puede vender
  "cantidad_disponible_para_mi": 10 // En mis subinventarios
}
```

---

## 🛠️ Servicios Principales

### **1. SubinventarioService**
**Archivo:** `data/services/subinventario_service.dart`

```dart
// Obtener mis subinventarios
getMisSubinventarios(String codCongregante)

// Obtener libros de un subinventario
getLibrosSubinventario(int subinventarioId, String codCongregante, List roles)

// Buscar libro por código
buscarLibroPorCodigo(String barcode)

// Crear venta (desde subinventario)
crearVenta(
  int subinventarioId,
  String codCongregante,
  String fechaVenta,
  String tipoPago,
  String usuario,
  List libros,
  // ...
)

// Buscar TODOS los libros del sistema
buscarTodosLosLibros(String codCongregante, {...opcional})
```

### **2. VentaService**
**Archivo:** `data/services/venta_service.dart`

```dart
// Para ADMIN LIBRERIA - vender desde inventario general
crearVentaAdmin(
  List roles,
  String tipoInventario,  // 'general' o 'subinventario'
  int? subinventarioId,
  // ...
)
```

---

## ⚙️ Cómo Acceder a Inventario General (Admin)

### **Caso 1: Usuario Normal (Vendedor)**
```
getMisSubinventarios() 
  → Solo ve sus puntos de venta
  → Solo puede vender DE SUS subinventarios
```

### **Caso 2: Usuario con Rol ADMIN_LIBRERIA**
```
Se accede mediante:
  - VentaService.crearVentaAdmin() 
  - Parámetro: tipoInventario = 'general'
  - Se envían los roles en header: X-Roles
  
→ Puede crear ventas desde inventario general
→ Puede acceder a TODOS los libros del sistema
```

**Archivo:** `modules/cart/controllers/cart_controller.dart`
- Línea ~525: Detecta si es ADMIN_LIBRERIA
- Si es admin: usa `crearVentaAdmin` con `tipoInventario: 'general'`

---

## 📱 Pantallas Involucradas

```
Landing Page
  ↓
Dashboard
  ↓
[Click "Punto de Venta"]
  ↓
SubinventarioSelectionView
  - Llama: getMisSubinventarios(codCongregante)
  - Muestra lista de puntos de venta
  - Usuario selecciona uno
  ↓
PosView (Punto de Venta Principal)
  - Recibe: Subinventario seleccionado
  - Llama: cargarLibrosSubinventario()
  - Libros disponibles: librosDisponibles (RxList)
  ↓
[Usuario escanea o busca libro]
  ↓
[Valida si está en el subinventario actual]
  ↓
[Agrega a carrito]
  ↓
[Procesa venta]
```

---

## 🚨 Restricciones Actuales

1. **Solo Subinventarios:**
   - Usuario normal NO PUEDE vender del inventario general
   - SOLO puede vender de sus subinventarios asignados
   - Si un libro no está en su subinventario → ERROR "No disponible"

2. **Sin Mezcla de Inventarios:**
   - No puede vender del general Y del subinventario en una sola venta
   - Debe elegir: O vender del subinventario O (si es admin) del general

3. **Validación de Stock:**
   - Usa `cantidadDisponible` del subinventario
   - Si intenta vender más de lo disponible → ERROR

---

## 🔄 Mejoras Sugeridas (Comparación con Sistema Ideal)

### **Funcionalidad Faltante #1: Visualizar Inventario General**
```dart
// NO EXISTE ACTUALMENTE
Future<Map<String, dynamic>> obtenerTodoElInventarioGeneral(
  String codCongregante
) {
  // Mostrar todos los libros del sistema
  // Con información de stock general y subinventarios
}
```

**Necesitaría:**
- Endpoint: `GET /api/v1/libros?cod_congregante=14279`
- Permiso: Usuarios solo con ciertos roles
- Data: Stock general, stock por subinventario, etc.

---

### **Funcionalidad Faltante #2: Venta Mixta (General + Subinventario)**
```dart
// NO SOPORTADA ACTUALMENTE
// Una venta debe ser 100% del inventario general O 100% del subinventario
// No puede mezclar libros de ambos en una venta
```

---

### **Funcionalidad Faltante #3: Cambiar de Inventario Sin Cerrar Sesión**
```dart
// Actualmente: Cambiar subinventario → Vuelve atrás y selecciona otro
// Ideal: Cambiar subinventario on-the-fly sin perder lo que está haciendo
```

---

## 📝 Resumen Técnico

### **Flow de Datos (Actual)**

```
┌─────────────────────────────────────────────────────────┐
│                    USUARIO EN APP                        │
│              (cod_congregante = 14279)                   │
└────────────────────┬────────────────────────────────────┘
                     │
                     ↓ getMisSubinventarios(14279)
┌─────────────────────────────────────────────────────────┐
│              API HOSTINGER                              │
│  GET /api/v1/mis-subinventarios/14279                   │
└────────────────────┬────────────────────────────────────┘
                     │
                  [200 OK]
                     ↓
    ┌────────────────────────────────────┐
    │ Subinventario 1: Punto Central  │
    │ - totalLibros: 27                 │
    │ - totalUnidades: 79               │
    │ - libros: [...]                   │
    │                                    │
    │ Subinventario 2: Sucursal       │
    │ - totalLibros: 15                 │
    │ - libros: [...]                   │
    └────────────────────────────────────┘
                     │
         [Usuario selecciona uno]
                     ↓
    ┌────────────────────────────────────┐
    │  POS View                          │
    │  - Subinventario activo            │
    │  - Libros disponibles cargados     │
    │  - Ready para vender               │
    └────────────────────────────────────┘
                     │
         [Escanea código o busca]
                     ↓
    ┌────────────────────────────────────┐
    │ Valida presencia en              │
    │ librosDisponibles                  │
    │ ¿Existe? ¿Es vendible?            │
    │ ¿Hay stock?                        │
    └────────────────────────────────────┘
                     │
         [Si todo OK]
                     ↓
    ┌────────────────────────────────────┐
    │ Agrega a carrito                   │
    │ Calcula total                      │
    └────────────────────────────────────┘
                     │
         [Usuario presiona Vender]
                     ↓
    ┌────────────────────────────────────┐
    │ crearVenta()                       │
    │ POST /api/v1/movil/ventas          │
    │ - subinventario_id: 1              │
    │ - libros: [{id, cantidad}, ...]    │
    └────────────────────────────────────┘
                     │
                  [200 OK]
                     ↓
    ┌────────────────────────────────────┐
    │ Venta registrada                   │
    │ Stock actualizado                  │
    └────────────────────────────────────┘
```

---

## 🎓 Conclusión

**El sistema actual obtiene libros DE SUBINVENTARIOS, NO del inventario general.**

Para usuarios normales:
- ✅ Funciona perfecto para vendedores en puntos de venta específicos
- ✅ Previene errores de venta de libros no asignados
- ✅ Mantiene control de stock por punto de venta

Para administradores:
- ⚠️ Necesita usar `crearVentaAdmin()` para acceder al inventario general
- ⚠️ No hay UI visual del inventario general desde POS
- ⚠️ Debe estructurarse diferente

**Comparación con Hostinger:**
- Hostinger tiene ambos niveles
- La app Flutter implementa principalmente el nivel de subinventarios
- Falta implementación visual del inventario general para admins
