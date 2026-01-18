# Integración de Subinventarios con Punto de Venta

## 📋 Resumen

Se ha implementado la integración completa del sistema de **punto de venta móvil** con la **API de Control Interno de Librería** para gestionar subinventarios asignados a usuarios específicos.

---

## 🎯 Funcionalidades Implementadas

### 1. **Servicio de API - SubinventarioService**
**Archivo:** `lib/pandevida/app/modules/punto_de_venta/data/services/subinventario_service.dart`

Métodos disponibles:
- `getMisSubinventarios(codCongregante)` - Obtiene los subinventarios asignados a un usuario
- `getLibrosSubinventario(subinventarioId, codCongregante)` - Carga libros de un subinventario específico
- `buscarLibroPorCodigo(codigo)` - Busca libro por código de barras
- `crearVenta(...)` - Crea una venta en el sistema

### 2. **Modelo de Datos - Subinventario**
**Archivo:** `lib/pandevida/app/modules/punto_de_venta/data/models/subinventario_model.dart`

Clases:
- `Subinventario` - Modelo principal con información del punto de venta
- `LibroSubinventario` - Modelo para libros con stock disponible

### 3. **Pantalla de Selección de Subinventarios**
**Archivos:**
- **Controller:** `modules/subinventario_selection/controllers/subinventario_selection_controller.dart`
- **Binding:** `modules/subinventario_selection/bindings/subinventario_selection_binding.dart`
- **View:** `modules/subinventario_selection/views/subinventario_selection_view.dart`

**Características:**
- ✅ Carga automática de subinventarios al entrar
- ✅ Muestra información visual de cada punto de venta
- ✅ Pull-to-refresh para recargar datos
- ✅ Si solo hay un subinventario, lo selecciona automáticamente
- ✅ Navegación directa al punto de venta al seleccionar

### 4. **Punto de Venta Actualizado**
**Archivo:** `modules/pos_view/controllers/pos_view_controller.dart`

**Mejoras:**
- ✅ Recibe el subinventario seleccionado como argumento
- ✅ Carga libros del subinventario específico
- ✅ Muestra información del subinventario activo en el header

**Vista actualizada:** `modules/pos_view/views/pos_view.dart`
- ✅ Display visual del subinventario activo
- ✅ Muestra total de libros y unidades disponibles

---

## 🚀 Flujo de Usuario

```
1. Usuario entra a la app (Landing/Debug Mode) o Dashboard
   ↓
2. Presiona "Punto de Venta" (ruta: /punto-de-venta)
   ↓
3. Sistema carga subinventarios del usuario automáticamente
   ↓
4. Si tiene 1 subinventario → Va directo al Punto de Venta
   Si tiene varios → Muestra lista para seleccionar
   ↓
5. Usuario selecciona un subinventario (si hay varios)
   ↓
6. Punto de Venta se abre con:
   - Libros del subinventario cargados
   - Información del punto de venta visible
   - Listo para escanear y vender
```

**IMPORTANTE:** La ruta `/punto-de-venta` ahora apunta directamente a la selección de subinventarios, por lo que desde el menú del backend solo se necesita configurar esta única ruta.

---

## 🔌 Endpoints de API Utilizados

### GET `/api/v1/mis-subinventarios/{cod_congregante}`
**URL:** `https://inventario.sistemasdevida.com/api/v1/mis-subinventarios/14279`

**Respuesta:**
```json
{
  "success": true,
  "message": "Subinventarios encontrados",
  "data": [
    {
      "id": 1,
      "descripcion": null,
      "fecha_subinventario": "2025-12-30T00:00:00.000000Z",
      "estado": "activo",
      "total_libros": 27,
      "total_unidades": 79,
      "libros": [...]
    }
  ]
}
```

### GET `/api/v1/subinventarios/{id}/libros`
**URL:** `https://inventario.sistemasdevida.com/api/v1/subinventarios/1/libros?cod_congregante=14279`

Carga los libros de un subinventario específico (uso opcional, ya que los libros vienen en el primer endpoint).

---

## 📱 Rutas Agregadas

En `app/routes/app_routes.dart`:

```dart
// Ruta principal del Punto de Venta - Muestra selección de subinventarios
static const POS_VIEW = '/punto-de-venta';

// Ruta interna de la vista principal con cámara (después de seleccionar)
static const POS_VIEW_MAIN = '/pos-view-main';

// Ruta legacy para compatibilidad
static const SUBINVENTARIO_SELECTION = '/seleccionar-subinventario';
```

**Configuración en el menú del backend:**

Para agregar "Punto de Venta" al menú que viene del servidor, solo necesitas configurar:

```php
'URL' => '/punto-de-venta'  // o 'punto-de-venta' sin la barra inicial
```

Esta ruta automáticamente:
1. Carga los subinventarios del usuario
2. Si tiene uno, entra directo al punto de venta
3. Si tiene varios, muestra la lista para seleccionar

En `app/routes/app_pages.dart`:

```dart
GetPage(
  name: _Paths.SUBINVENTARIO_SELECTION,
  page: () => const SubinventarioSelectionView(),
  binding: SubinventarioSelectionBinding(),
),
```

---

## 🧪 Pruebas Realizadas

### Test del Endpoint
```bash
curl -X GET "https://inventario.sistemasdevida.com/api/v1/mis-subinventarios/14279" \
  -H "Accept: application/json"
```

**Resultado:**
- ✅ Respuesta exitosa (200)
- ✅ Retorna 1 subinventario activo
- ✅ Incluye 27 libros con stock
- ✅ Total de 79 unidades disponibles

---

## 📂 Estructura de Archivos Creados

```
lib/pandevida/app/modules/punto_de_venta/
├── data/
│   ├── models/
│   │   └── subinventario_model.dart         [NUEVO]
│   └── services/
│       └── subinventario_service.dart        [NUEVO]
│
└── modules/
    ├── pos_view/
    │   ├── controllers/
    │   │   └── pos_view_controller.dart      [MODIFICADO]
    │   └── views/
    │       └── pos_view.dart                 [MODIFICADO]
    │
    └── subinventario_selection/              [NUEVO MÓDULO]
        ├── bindings/
        │   └── subinventario_selection_binding.dart
        ├── controllers/
        │   └── subinventario_selection_controller.dart
        └── views/
            └── subinventario_selection_view.dart
```

---

## 🎨 UI/UX Implementada

### Pantalla de Selección de Subinventarios

**Elementos:**
- 🏪 Icono de tienda para cada subinventario
- 📅 Fecha de creación
- 🟢 Badge de estado (activo/completado/cancelado)
- 📚 Total de libros disponibles
- 📦 Total de unidades en stock
- ➡️ Indicador visual de navegación
- 🔄 Pull-to-refresh para recargar

**Estados:**
- **Cargando:** Spinner con mensaje
- **Sin datos:** Mensaje amigable con opción de reintentar
- **Con datos:** Lista scrolleable de subinventarios

### Punto de Venta

**Header actualizado:**
- 🛒 Icono de carrito
- 📊 Contador de libros en el carrito
- 📹 Botón de cámara on/off
- 🏬 **[NUEVO]** Badge del subinventario activo con:
  - Nombre/descripción del punto de venta
  - Total de libros y unidades disponibles
  - Estilo visual distintivo (fondo teal)

---

## 🔐 Seguridad

- ✅ Usa `codCongregante` del usuario logueado (desde AuthService)
- ✅ Solo muestra subinventarios asignados al usuario
- ✅ Validación de acceso en cada request (si se implementa en backend)

---

## 🐛 Manejo de Errores

El sistema maneja:
- ❌ Sin conexión a internet
- ❌ Error del servidor (500, 404, etc.)
- ❌ Usuario sin subinventarios asignados
- ❌ Token de usuario inválido o vacío
- ❌ Respuesta de API malformada

Todos los errores se muestran con Snackbar al usuario.

---

## 🔧 Para Desarrolladores

### Cómo agregar al menú principal del dashboard

El menú actualmente viene del servidor (backend). Para agregar la opción:

**En el backend Laravel**, agregar a la estructura del menú:
```php
[
  'MENU' => 'Librería',
  'OPCIONES' => [
    [
      'OPCION' => 'Punto de Venta',
      'URL' => 'punto-de-venta'  // Sin la barra inicial
    ]
  ]
]
```

La app automáticamente:
- Navegará a `/punto-de-venta`
- Cargará los subinventarios del usuario
- Mostrará la selección o entrará directo si solo hay uno

### Navegación programática

```dart
// Ir a selección de subinventarios
Get.toNamed(Routes.SUBINVENTARIO_SELECTION);
### Navegación programática

```dart
// Ir a punto de venta (muestra selección de subinventarios)
Get.toNamed(Routes.POS_VIEW);

// Ir directo a la vista principal con un subinventario (uso interno)
Get.toNamed(
  Routes.POS_VIEW_MAIN,
  arguments: {
    'subinventario': miSubinventario,
  },
);
```
- [x] Probar endpoints de la API
- [x] Crear servicio de subinventarios
- [x] Crear modelo de datos
- [x] Implementar pantalla de selección
- [x] Actualizar punto de venta
- [x] Agregar rutas en GetX
- [x] Integrar con el flujo de navegación
- [x] Manejo de errores
- [x] UI/UX responsive
- [x] Documentación

---

## 🚧 Próximos Pasos (Recomendaciones)

1. **Backend:**
   - [ ] Agregar autenticación API (Laravel Sanctum)
   - [ ] Validar `cod_congregante` en endpoint de ventas
   - [ ] Rate limiting

2. **Frontend:**
   - [ ] Implementar creación de ventas usando el endpoint POST `/api/v1/ventas`
   - [ ] Caché local de subinventarios (para offline)
   - [ ] Sincronización de ventas pendientes

3. **UX:**
   - [ ] Animaciones de transición
   - [ ] Indicador de ventas realizadas
   - [ ] Historial de transacciones

---

## 📞 Soporte

- **Código de usuario de prueba:** `14279`
- **API Base URL:** `https://inventario.sistemasdevida.com/api/v1`
- **Subinventario de prueba ID:** `1`

---

## 📝 Notas de Versión

**Versión:** 1.0.0  
**Fecha:** 7 de enero de 2026  
**Estado:** ✅ Funcional y probado

**Probado con:**
- Usuario: cod_congregante `14279`
- 1 subinventario activo
- 27 libros con 79 unidades totales
- API respondiendo correctamente
