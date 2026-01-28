# Problema Detectado: Rutas de Abonos No Implementadas en el Backend

## 🚨 Diagnóstico

Las pruebas de API revelan que **las rutas para el módulo de abonos NO ESTÁN IMPLEMENTADAS** en el servidor backend.

### Resultados de las Pruebas

Todas las rutas probadas devuelven **404 Not Found** con una página HTML de Laravel:

```
Status Code: 404
Content-Type: text/html
Response: Laravel "Not Found" page
```

## 📋 Rutas que Faltan en el Backend

El módulo de abonos requiere que el backend implemente las siguientes rutas:

### 1. Buscar Apartado por Folio
```
GET /api/v1/apartados/buscar-folio/{folio}
```
**Respuesta esperada:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "folio": "APT-2025-001",
    "cliente": {
      "id": 1,
      "nombre": "Juan Pérez",
      "telefono": "1234567890"
    },
    "monto_total": 1000.00,
    "total_pagado": 300.00,
    "saldo_pendiente": 700.00,
    "porcentaje_pagado": 30.0,
    "estado": "activo",
    "fecha_apartado": "2025-01-15",
    "fecha_limite": "2025-02-15"
  }
}
```

### 2. Buscar Apartados por Cliente
```
GET /api/v1/apartados/buscar-cliente?nombre={nombre}
```
**Respuesta esperada:**
```json
{
  "success": true,
  "data": [
    {
      "nombre_cliente": "Juan Pérez",
      "telefono_cliente": "1234567890",
      "apartados": [
        {
          "id": 1,
          "folio": "APT-2025-001",
          "monto_total": 1000.00,
          "saldo_pendiente": 700.00,
          "estado": "activo"
        }
      ]
    }
  ]
}
```

### 3. Registrar Abono
```
POST /api/v1/abonos
```
**Request body:**
```json
{
  "apartado_id": 1,
  "monto": 100.00,
  "metodo_pago": "efectivo",
  "comprobante": "REF123",
  "observaciones": "Abono parcial",
  "usuario": "admin"
}
```
**Respuesta esperada:**
```json
{
  "success": true,
  "message": "Abono registrado exitosamente",
  "data": {
    "abono": {
      "id": 1,
      "apartado_id": 1,
      "monto": 100.00,
      "metodo_pago": "efectivo",
      "fecha_abono": "2025-01-17",
      "usuario": "admin"
    },
    "apartado": {
      "id": 1,
      "folio": "APT-2025-001",
      "saldo_pendiente": 600.00,
      "total_pagado": 400.00,
      "estado": "activo"
    }
  }
}
```

### 4. Obtener Historial de Abonos
```
GET /api/v1/apartados/{apartado_id}/abonos
```
**Respuesta esperada:**
```json
{
  "success": true,
  "data": {
    "apartado": {
      "id": 1,
      "folio": "APT-2025-001",
      "monto_total": 1000.00,
      "saldo_pendiente": 600.00
    },
    "abonos": [
      {
        "id": 1,
        "monto": 100.00,
        "metodo_pago": "efectivo",
        "fecha_abono": "2025-01-17",
        "saldo_anterior": 700.00,
        "saldo_nuevo": 600.00,
        "usuario": "admin",
        "observaciones": "Abono parcial"
      }
    ]
  }
}
```

## 🔧 Solución Implementada en el Frontend

Mientras el backend implementa estas rutas, el servicio de abonos ahora detecta cuando las rutas no están implementadas y muestra un mensaje claro:

```dart
// Verificar si el servidor devolvió HTML (error 404 o ruta no implementada)
if (response.headers['content-type']?.contains('text/html') == true) {
  return {
    'success': false,
    'message': 'La funcionalidad de abonos no está implementada en el servidor. Contacta al administrador.',
  };
}
```

## 📝 Tareas Pendientes

### Para el Desarrollador Backend:

1. **Crear las rutas** en `routes/api.php` (Laravel):
```php
Route::prefix('apartados')->group(function () {
    Route::get('buscar-folio/{folio}', [ApartadoController::class, 'buscarPorFolio']);
    Route::get('buscar-cliente', [ApartadoController::class, 'buscarPorCliente']);
    Route::get('{apartado_id}/abonos', [AbonoController::class, 'historial']);
});

Route::post('abonos', [AbonoController::class, 'registrar']);
```

2. **Implementar los controladores**:
   - `ApartadoController::buscarPorFolio()`
   - `ApartadoController::buscarPorCliente()`
   - `AbonoController::registrar()`
   - `AbonoController::historial()`

3. **Crear las migraciones** para la tabla de abonos (si no existe):
```php
Schema::create('abonos', function (Blueprint $table) {
    $table->id();
    $table->foreignId('apartado_id')->constrained();
    $table->decimal('monto', 10, 2);
    $table->enum('metodo_pago', ['efectivo', 'tarjeta', 'transferencia']);
    $table->string('comprobante')->nullable();
    $table->text('observaciones')->nullable();
    $table->decimal('saldo_anterior', 10, 2);
    $table->decimal('saldo_nuevo', 10, 2);
    $table->string('usuario');
    $table->timestamps();
});
```

4. **Implementar la lógica de negocio**:
   - Validar que el monto no exceda el saldo pendiente
   - Actualizar el saldo del apartado
   - Registrar el historial de abonos
   - Cambiar el estado del apartado a "liquidado" si el saldo llega a 0

## ✅ Estado Actual

- ✅ Frontend implementado y funcionando correctamente
- ✅ Modelos de datos creados
- ✅ Vistas con diseño consistente
- ✅ Navegación configurada
- ✅ Manejo de errores mejorado
- ❌ **Backend: Rutas NO implementadas** (404)
- ❌ **Backend: Controladores pendientes**
- ❌ **Backend: Lógica de negocio pendiente**

## 🧪 Script de Prueba

Se creó un script de prueba en `/test_abonos_api.dart` que puede ejecutarse con:
```bash
dart test_abonos_api.dart
```

Este script verifica todas las rutas y muestra los resultados detallados.
