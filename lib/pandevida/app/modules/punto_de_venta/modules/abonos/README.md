# Módulo de Abonos

Este módulo permite gestionar abonos de apartados desde la aplicación móvil del punto de venta.

## Estructura del Módulo

```
lib/pandevida/app/modules/punto_de_venta/
├── data/
│   ├── models/
│   │   ├── apartado_model.dart          # Modelo de Apartado
│   │   └── abono_model.dart             # Modelos de Abono y peticiones
│   └── services/
│       └── abonos_service.dart          # Servicio de API para abonos
└── modules/
    └── abonos/
        ├── bindings/
        │   └── abonos_binding.dart      # Binding del módulo
        ├── controllers/
        │   └── abonos_controller.dart   # Controlador principal
        └── views/
            ├── buscar_apartado_view.dart     # Vista de búsqueda
            ├── registrar_abono_view.dart     # Vista de registro
            └── historial_abonos_view.dart    # Vista de historial
```

## Características

### 1. Búsqueda de Apartados
- **Por Folio**: Busca un apartado específico por su número de folio (ej: APT-2025-001)
- **Por Cliente**: Busca todos los apartados activos de un cliente por su nombre

### 2. Registro de Abonos
- Formulario completo para registrar abonos
- Validación de montos (no puede exceder el saldo pendiente)
- Selección de método de pago (efectivo, transferencia, tarjeta)
- Campos opcionales: comprobante y observaciones
- Botones de acción rápida:
  - Liquidar total (completa el saldo pendiente)
  - 50% del saldo (abona la mitad del saldo pendiente)

### 3. Historial de Abonos
- Lista completa de todos los abonos realizados en un apartado
- Información detallada de cada abono:
  - Monto, fecha y método de pago
  - Saldo anterior y nuevo
  - Usuario que registró el abono
  - Comprobante y observaciones (si aplica)

### 4. Liquidación Automática
- Cuando el saldo pendiente llega a cero, el apartado se marca automáticamente como "liquidado"
- Notificación al usuario cuando se liquida un apartado

## Navegación

### Acceso desde el Carrito
1. En la vista del carrito (`CartView`), hay un botón "Registrar Abono"
2. Al hacer clic, se navega a la vista de búsqueda de apartados

### Flujo Completo
```
CartView → BuscarApartadoView → RegistrarAbonoView → HistorialAbonosView
                                           ↓
                                      [Éxito/Error]
                                           ↓
                                  [Volver a búsqueda]
```

## Rutas

Las siguientes rutas están configuradas en el sistema:

- `/abonos/buscar` - Búsqueda de apartados
- `/abonos/registrar` - Registro de abonos
- `/abonos/historial` - Historial de abonos

## Configuración de API

### URL Base
El servicio está configurado para conectarse a:
```dart
static const String baseUrl = 'http://tu-dominio.com/api/v1/movil';
```

**IMPORTANTE**: Debes cambiar esta URL en el archivo:
`lib/pandevida/app/modules/punto_de_venta/data/services/abonos_service.dart`

### Endpoints Utilizados

1. **GET** `/apartados/buscar-folio/{folio}` - Buscar por folio
2. **GET** `/apartados/buscar-cliente?nombre={nombre}` - Buscar por cliente
3. **POST** `/abonos` - Registrar abono
4. **GET** `/apartados/{apartado_id}/abonos` - Historial de abonos

Para más detalles sobre los endpoints, consulta la documentación de la API.

## Dependencias

Este módulo utiliza:
- **GetX**: Para gestión de estado y navegación
- **http**: Para peticiones HTTP a la API
- **Flutter Material**: Para componentes de UI

## Modelos de Datos

### Apartado
Representa un apartado con toda su información:
- Datos del cliente
- Fechas de apartado y límite
- Montos (total, pagado, pendiente)
- Lista de libros apartados
- Estado del apartado

### Abono
Representa un abono registrado:
- Monto y fecha
- Método de pago
- Saldo anterior y nuevo
- Usuario que lo registró
- Comprobante y observaciones opcionales

### CrearAbonoRequest
Petición para crear un nuevo abono:
- ID del apartado
- Monto del abono
- Método de pago
- Comprobante y observaciones (opcionales)
- Usuario que registra

## Validaciones

El módulo incluye las siguientes validaciones:

1. **Monto requerido**: No puede estar vacío
2. **Monto válido**: Debe ser mayor a 0
3. **Monto no excede saldo**: No puede ser mayor al saldo pendiente
4. **Confirmación**: Diálogo de confirmación antes de registrar
5. **Estados válidos**: Solo se pueden abonar apartados activos o vencidos

## Manejo de Errores

El módulo maneja los siguientes tipos de errores:

- **Error de conexión**: Cuando no se puede conectar a la API
- **Error 404**: Cuando no se encuentra el apartado
- **Error 400**: Cuando el apartado está cancelado o liquidado
- **Error 422**: Errores de validación del servidor
- **Error 500**: Errores del servidor

Todos los errores se muestran al usuario mediante snackbars informativos.

## Usuario Actual

**NOTA IMPORTANTE**: Actualmente el campo `usuario` está hardcodeado como "usuario_actual" en el controlador. 

Para usar el usuario real del sistema, debes modificar la línea en:
`lib/pandevida/app/modules/punto_de_venta/modules/abonos/controllers/abonos_controller.dart`

```dart
// Cambiar esta línea:
final usuario = 'usuario_actual';

// Por algo como:
final usuario = Get.find<AuthController>().currentUser.value.nombre;
```

## Ejemplos de Uso

### Buscar apartado por folio
```dart
controller.tipoBusqueda.value = 'folio';
controller.busquedaController.text = 'APT-2025-001';
await controller.buscarApartado();
```

### Registrar un abono
```dart
controller.montoController.text = '150.00';
controller.metodoPagoSeleccionado.value = 'transferencia';
controller.comprobanteController.text = 'REF123456';
await controller.registrarAbono();
```

## Estilos y UI

El módulo utiliza una paleta de colores consistente:

- **Azul** (`Colors.blue`): Elementos principales y apartados activos
- **Verde** (`Colors.green`): Acciones de registro y montos pagados
- **Rojo** (`Colors.red`): Saldos pendientes y errores
- **Naranja** (`Colors.orange`): Apartados vencidos y advertencias
- **Gris** (`Colors.grey`): Apartados cancelados e información secundaria

## Testing

Para probar el módulo:

1. Asegúrate de que la API esté corriendo y accesible
2. Configura la URL correcta en `abonos_service.dart`
3. Navega al carrito y haz clic en "Registrar Abono"
4. Prueba ambos tipos de búsqueda (por folio y por cliente)
5. Registra un abono y verifica que se actualice correctamente
6. Revisa el historial de abonos

## Mejoras Futuras

Posibles mejoras para el módulo:

1. Agregar escaneo de QR para folios de apartados
2. Implementar búsqueda offline con caché local
3. Agregar exportación de historial a PDF
4. Implementar notificaciones push al cliente
5. Agregar estadísticas de abonos
6. Implementar búsqueda por rango de fechas
7. Agregar filtros en el historial de abonos

## Soporte

Para problemas o preguntas sobre este módulo, contacta al equipo de desarrollo.
