# Configuración del Módulo de Abonos

## Configurar URL del Servidor

Para que el módulo de abonos funcione correctamente, debes configurar la URL base de tu servidor API.

### Pasos:

1. Abre el archivo: `lib/pandevida/app/modules/punto_de_venta/data/services/abonos_service.dart`

2. Busca la línea:
```dart
static const String baseUrl = 'http://tu-dominio.com/api/v1/movil';
```

3. Reemplaza `http://tu-dominio.com` con la URL real de tu servidor, por ejemplo:
```dart
static const String baseUrl = 'http://192.168.1.100:8000/api/v1/movil';
// o
static const String baseUrl = 'https://miapi.ejemplo.com/api/v1/movil';
```

### Ejemplos de URLs según el entorno:

#### Desarrollo Local (servidor en tu computadora)
```dart
static const String baseUrl = 'http://localhost:8000/api/v1/movil';
```

#### Desarrollo en red local (dispositivo en la misma red)
```dart
static const String baseUrl = 'http://192.168.1.100:8000/api/v1/movil';
```
*Nota: Reemplaza `192.168.1.100` con la IP de tu computadora*

#### Producción (servidor en internet)
```dart
static const String baseUrl = 'https://api.pandevida.com/api/v1/movil';
```

### ⚠️ Importante:

- Si usas **HTTP** (no HTTPS), debes configurar permisos en tu app Android/iOS
- Para **Android**: Agrega `android:usesCleartextTraffic="true"` en AndroidManifest.xml
- Para **iOS**: Configura App Transport Security en Info.plist
- En **producción**, siempre usa HTTPS por seguridad

### Verificar la conexión:

Después de configurar la URL, prueba la conexión:

1. Ejecuta la app
2. Ve al carrito
3. Haz clic en "Registrar Abono"
4. Intenta buscar un apartado
5. Si hay error de conexión, verifica:
   - La URL esté correcta
   - El servidor esté corriendo
   - El dispositivo pueda acceder a la red

## Configurar Usuario Actual

El módulo necesita saber qué usuario está registrando los abonos.

### Pasos:

1. Abre el archivo: `lib/pandevida/app/modules/punto_de_venta/modules/abonos/controllers/abonos_controller.dart`

2. Busca la línea (aproximadamente línea 256):
```dart
final usuario = 'usuario_actual'; // Cambiar por el usuario real
```

3. Reemplázala con el usuario real de tu sistema, por ejemplo:
```dart
final usuario = Get.find<AuthController>().currentUser.value.nombre;
// o
final usuario = Get.find<UserController>().userName.value;
// o como tengas configurado tu sistema de autenticación
```

## Dependencias Requeridas

Asegúrate de tener estas dependencias en tu `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6  # o la versión que estés usando
  http: ^1.1.0  # Para las peticiones HTTP
```

Si no tienes `http`, agrégalo ejecutando:
```bash
flutter pub add http
```

## Probar el Módulo

Una vez configurado todo:

1. Reinicia la app completamente
2. Navega al carrito
3. Haz clic en "Registrar Abono"
4. Prueba buscar un apartado por folio (ej: APT-2025-001)
5. Si funciona, verás los datos del apartado
6. Si no funciona, revisa los logs de consola para ver el error

## Troubleshooting

### Error: "Failed host lookup"
- Verifica que la URL sea correcta
- Verifica que el dispositivo tenga conexión a internet/red
- Si es localhost, usa la IP de tu computadora en lugar de localhost

### Error: "Connection refused"
- Verifica que el servidor esté corriendo
- Verifica que el puerto sea el correcto
- Verifica el firewall de tu computadora

### Error: "Certificate verification failed"
- Si usas HTTPS con certificado autofirmado, configura la validación de certificados
- En desarrollo, considera usar HTTP en red local

### No muestra apartados
- Verifica que existan apartados en la base de datos
- Verifica que los folios/nombres sean correctos
- Revisa los logs del servidor para ver si llegan las peticiones

## Logs de Debug

Para ver los logs de las peticiones HTTP, puedes agregar prints en el servicio:

```dart
Future<Map<String, dynamic>> buscarPorFolio(String folio) async {
  try {
    final url = '$baseUrl/apartados/buscar-folio/$folio';
    print('🔍 Buscando apartado: $url'); // <- Agrega esto
    
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    
    print('📥 Respuesta: ${response.statusCode}'); // <- Y esto
    print('📄 Body: ${response.body}'); // <- Y esto
    
    // ... resto del código
  }
}
```

Esto te ayudará a debuggear problemas de conexión.
