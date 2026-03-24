# Implementación de Tests de Ministerio con API

## Descripción de Cambios

Se ha implementado la integración con la API de tests de ministerio, incluyendo la verificación de asignación de tests para cada congregante. El botón de "Test de Ministerio" ahora solo se muestra a los usuarios que tienen tests asignados.

## Configuración de URLs por Entorno

### Modo Debug (Desarrollo)
- **URL Base:** `http://localhost:8000/api/v1`
- El servicio detecta automáticamente el modo debug y usa localhost
- Útil para pruebas locales durante el desarrollo

### Modo Release (Producción)
- **URL Base:** Se usa la URL configurada en `Keys.URL_SERVICE`
- La URL de producción se obtiene del archivo `.env`
- Configuración: `https://inventario.sistemasdevida.com` (o la URL que tengas configurada)

## Archivos Creados/Modificados

### 1. Servicio de API - `test_ministerio_service.dart`

**Ubicación:** `lib/pandevida/app/data/services/test_ministerio_service.dart`

**Funciones principales:**

#### `verificarAsignacion()`
Verifica si el congregante actual tiene tests asignados.

```dart
final response = await TestMinisterioService.verificarAsignacion();

if (!response['error']) {
  bool tieneAsignacion = response['tiene_asignacion'];
  Map resumen = response['resumen']; // {pendientes, completados, disponibles}
  List testsPendientes = response['tests_pendientes'];
  List testsCompletados = response['tests_completados'];
}
```

**Endpoint:** `GET /testministerios/verificar_asignacion/{codCongregante}`

#### `obtenerTestsAsignados()`
Obtiene la lista completa de tests asignados al congregante.

```dart
final response = await TestMinisterioService.obtenerTestsAsignados();

if (!response['error']) {
  List tests = response['tests'];
}
```

**Endpoint:** `GET /testministerios/asignados/{codCongregante}`

#### `guardarRespuestas()`
Guarda las respuestas de un test completado.

```dart
final response = await TestMinisterioService.guardarRespuestas(
  idTest: 1,
  respuestas: [
    {'pregunta_id': 1, 'respuesta_id': 2},
    {'pregunta_id': 2, 'respuesta_id': 5},
  ],
);
```

**Endpoint:** `POST /testministerios/guardar_respuestas`

### 2. Modelos - `test_ministerio_verificacion_model.dart`

**Ubicación:** `lib/pandevida/app/data/models/test_ministerio_verificacion_model.dart`

**Modelos incluidos:**

- `TestMinisterioVerificacion`: Respuesta completa de verificación
- `CongreganteInfo`: Información del congregante
- `ResumenTests`: Contadores de tests (pendientes, completados, disponibles)
- `TestAsignado`: Test pendiente por completar
- `TestCompletado`: Test ya completado con resultados
- `TestDisponible`: Tests disponibles pero no asignados

### 3. Controlador - `clases_controller.dart`

**Modificaciones:**
- Agregado: `var tieneTestsAsignados = false.obs`
- Agregado: `var isLoadingTests = true.obs`
- Nueva función: `verificarTestsAsignados()`

La función `verificarTestsAsignados()` se ejecuta automáticamente al iniciar el controlador y verifica si el usuario tiene tests asignados.

### 4. Vista - `clases_view.dart`

**Modificaciones:**
- Reemplazada la condición `if (kDebugMode)` por una verificación dinámica
- El botón ahora se muestra solo si `controller.tieneTestsAsignados.value == true`
- Manejo de estado de carga mientras se verifica la asignación

## Estructura de la Respuesta del API

### Verificar Asignación - Con Tests Asignados

```json
{
  "error": false,
  "congregante": {
    "CODCONGREGANTE": "123",
    "NOMBRE_COMPLETO": "Juan Pérez García"
  },
  "tiene_asignacion": true,
  "resumen": {
    "pendientes": 2,
    "completados": 1,
    "disponibles": 0
  },
  "tests_pendientes": [
    {
      "IDRESULTADO": 45,
      "IDTEST": 1,
      "NOMBRE_TEST": "Test de Temperamentos",
      "DESCRIPCION": "Evaluación de perfil ministerial",
      "VERSION": "1.0",
      "ESTADO_ASIGNACION": "PENDIENTE",
      "FECHA_ASIGNACION": "20/02/2026 14:30",
      "HORAS_DESDE_ASIGNACION": 18
    }
  ],
  "tests_completados": [...],
  "tests_disponibles": []
}
```

### Verificar Asignación - Sin Tests Asignados

```json
{
  "error": false,
  "congregante": {
    "CODCONGREGANTE": "123",
    "NOMBRE_COMPLETO": "Juan Pérez García"
  },
  "tiene_asignacion": false,
  "resumen": {
    "pendientes": 0,
    "completados": 0,
    "disponibles": 3
  },
  "tests_pendientes": [],
  "tests_completados": [],
  "tests_disponibles": [...]
}
```

## Flujo de Funcionamiento

1. **Carga de Vista de Clases:**
   - Se ejecuta `ClasesController.onInit()`
   - Se llama a `getAsistecias()` para cargar asistencias
   - Se llama a `verificarTestsAsignados()` en paralelo

2. **Verificación de Tests:**
   - Se obtiene el `codCongregante` del storage local
   - Se hace una petición a `/testministerios/verificar_asignacion/{codCongregante}`
   - Se actualiza `tieneTestsAsignados` según la respuesta

3. **Renderizado del Botón:**
   - Si `isLoadingTests == true`: No se muestra nada
   - Si `tieneTestsAsignados == true`: Se muestra el botón "Test de Ministerio"
   - Si `tieneTestsAsignados == false`: No se muestra el botón

## Configuración Requerida en el Backend

El backend debe tener implementado el siguiente endpoint:

```
GET /testministerios/verificar_asignacion/{codCongregante}
```

**Headers requeridos:**
```
Accept: application/json
Content-Type: application/json
```

## Pruebas

### Probar en Modo Debug (Localhost)

1. Asegúrate de tener el servidor corriendo en `localhost:8000`
2. Ejecuta la app en modo debug: `flutter run --debug`
3. La app usará automáticamente `http://localhost:8000/api/v1`

### Probar en Modo Release

1. Compila la app en modo release: `flutter run --release`
2. La app usará la URL configurada en `.env` (Keys.URL_SERVICE)

## Manejo de Errores

El servicio maneja los siguientes casos:

- **Error 404:** Congregante no encontrado
- **Error 500+:** Error del servidor
- **Error de conexión:** Problemas de red o servidor caído
- **Sin codCongregante:** Usuario no autenticado

En todos los casos de error, el botón NO se muestra por seguridad.

## Seguridad

- El `codCongregante` se obtiene del storage local encriptado
- Solo se muestra el botón si hay confirmación del servidor
- En caso de error en la verificación, el botón permanece oculto
- El modo debug/release se detecta automáticamente

## Próximos Pasos (Opcional)

- Implementar la carga de tests desde el API en lugar de archivos locales
- Guardar respuestas en el servidor al completar un test
- Mostrar historial de tests completados
- Agregar notificaciones cuando se asigna un nuevo test

## Notas Importantes

⚠️ **Debug vs Release:**
- El cambio de URL es automático según el modo de compilación
- No es necesario cambiar código manualmente
- Usa `flutter run --debug` para desarrollo local
- Usa `flutter run --release` o `flutter build` para producción

⚠️ **Requisitos:**
- El congregante debe estar autenticado (tener `codCongregante` en storage)
- El servidor debe estar corriendo y accesible
- El endpoint debe devolver la estructura JSON especificada
