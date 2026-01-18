import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://inventario.sistemasdevida.com/api/v1/movil';

void main() async {
  print('🧪 Iniciando pruebas de API de Abonos...\n');

  // Prueba 1: Buscar apartado por folio
  await testBuscarPorFolio();

  // Prueba 2: Buscar apartados por cliente
  await testBuscarPorCliente();

  // Prueba 3: Registrar abono
  // await testRegistrarAbono();

  // Prueba 4: Obtener historial de abonos
  // await testObtenerHistorial();

  print('\n✅ Pruebas completadas');
}

Future<void> testBuscarPorFolio() async {
  print('📋 Test 1: Buscar apartado por folio');
  print('─────────────────────────────────────');

  // Prueba con un folio de ejemplo
  final folios = ['APT-2025-001', 'APT-001', 'TEST-001'];

  for (var folio in folios) {
    try {
      final url = '$baseUrl/apartados/buscar-folio/$folio';
      print('🌐 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('📊 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Success: ${data['success']}');
        if (data['data'] != null) {
          print('📝 Apartado encontrado:');
          print('   - Folio: ${data['data']['folio']}');
          print('   - Cliente: ${data['data']['cliente']['nombre']}');
          print('   - Monto Total: \$${data['data']['monto_total']}');
          print('   - Saldo Pendiente: \$${data['data']['saldo_pendiente']}');
        }
      } else if (response.statusCode == 404) {
        print('⚠️  Apartado no encontrado');
      } else {
        print('❌ Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
    print('');
  }
  print('');
}

Future<void> testBuscarPorCliente() async {
  print('👤 Test 2: Buscar apartados por cliente');
  print('─────────────────────────────────────');

  final nombres = ['Maria', 'Juan', 'Pedro'];

  for (var nombre in nombres) {
    try {
      final url = '$baseUrl/apartados/buscar-cliente?nombre=$nombre';
      print('🌐 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('📊 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Success: ${data['success']}');
        if (data['data'] != null && data['data'] is List) {
          print('📝 Clientes encontrados: ${data['data'].length}');
          for (var cliente in data['data']) {
            print('   - ${cliente['nombre_cliente']}');
            print('     Apartados: ${cliente['apartados'].length}');
          }
        }
      } else if (response.statusCode == 404) {
        print('⚠️  No se encontraron apartados');
      } else {
        print('❌ Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
    print('');
  }
  print('');
}

Future<void> testRegistrarAbono() async {
  print('💰 Test 3: Registrar abono');
  print('─────────────────────────────────────');

  try {
    final url = '$baseUrl/abonos';
    print('🌐 URL: $url');

    final body = {
      'apartado_id': 1, // Cambia esto por un ID válido
      'monto': 100.00,
      'metodo_pago': 'efectivo',
      'comprobante': 'TEST-001',
      'observaciones': 'Prueba de abono desde script',
      'usuario': 'test_user',
    };

    print('📤 Request Body: ${json.encode(body)}');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    print('📊 Status Code: ${response.statusCode}');
    print('📦 Response Body: ${response.body}');

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      print('✅ Abono registrado exitosamente');
      print('   - ID: ${data['data']['abono']['id']}');
      print('   - Monto: \$${data['data']['abono']['monto']}');
      print('   - Nuevo saldo: \$${data['data']['apartado']['saldo_pendiente']}');
    } else {
      print('❌ Error al registrar abono');
    }
  } catch (e) {
    print('❌ Exception: $e');
  }
  print('');
}

Future<void> testObtenerHistorial() async {
  print('📜 Test 4: Obtener historial de abonos');
  print('─────────────────────────────────────');

  try {
    final apartadoId = 1; // Cambia esto por un ID válido
    final url = '$baseUrl/apartados/$apartadoId/abonos';
    print('🌐 URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    print('📊 Status Code: ${response.statusCode}');
    print('📦 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Historial obtenido');
      print('   - Apartado: ${data['data']['apartado']['folio']}');
      print('   - Total de abonos: ${data['data']['abonos'].length}');
      
      if (data['data']['abonos'].isNotEmpty) {
        print('   - Abonos:');
        for (var abono in data['data']['abonos']) {
          print('     * \$${abono['monto']} - ${abono['fecha_abono']}');
        }
      }
    } else {
      print('❌ Error al obtener historial');
    }
  } catch (e) {
    print('❌ Exception: $e');
  }
  print('');
}
