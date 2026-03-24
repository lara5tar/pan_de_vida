import 'dart:convert';
import 'package:http/http.dart' as http;

/// Script de prueba para verificar el endpoint de tests de ministerio
/// 
/// Uso:
/// ```bash
/// dart test_ministerio_api_test.dart
/// ```

const String baseUrl = 'http://localhost:8000/api/v1';

void main() async {
  print('🧪 Iniciando pruebas de API de Tests de Ministerio...\n');

  // Prueba 1: Verificar asignación (con tests asignados)
  await testVerificarAsignacion('123'); // Reemplaza con un cod válido

  // Prueba 2: Verificar asignación (sin tests asignados)
  await testVerificarAsignacion('999'); // Cod inexistente

  print('\n✅ Pruebas completadas');
}

/// Test 1: Verificar asignación de tests
Future<void> testVerificarAsignacion(String codCongregante) async {
  print('📋 Test: Verificar asignación para congregante $codCongregante');
  print('─────────────────────────────────────');

  try {
    final url = '$baseUrl/testministerios/verificar_asignacion/$codCongregante';
    print('🌐 URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print('📊 Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Success: ${!data['error']}');
      print('');
      print('📦 Respuesta completa:');
      print(const JsonEncoder.withIndent('  ').convert(data));
      print('');
      
      if (data['error'] == false) {
        print('👤 Congregante: ${data['congregante']['NOMBRE_COMPLETO']}');
        print('📝 Tiene asignación: ${data['tiene_asignacion']}');
        print('');
        
        final resumen = data['resumen'];
        print('📊 Resumen:');
        print('   • Pendientes: ${resumen['pendientes']}');
        print('   • Completados: ${resumen['completados']}');
        print('   • Disponibles: ${resumen['disponibles']}');
        print('');
        
        if (data['tiene_asignacion'] == true) {
          print('📚 Tests Pendientes:');
          for (var test in data['tests_pendientes']) {
            print('   • ${test['NOMBRE_TEST']} (ID: ${test['IDTEST']})');
            print('     Estado: ${test['ESTADO_ASIGNACION']}');
            print('     Fecha asignación: ${test['FECHA_ASIGNACION']}');
            print('     Horas desde asignación: ${test['HORAS_DESDE_ASIGNACION']}');
          }
          print('');
          
          if (data['tests_completados'].isNotEmpty) {
            print('✅ Tests Completados:');
            for (var test in data['tests_completados']) {
              print('   • ${test['NOMBRE_TEST']} (ID: ${test['IDTEST']})');
              print('     Ministerio Principal: ${test['MINISTERIO_PRINCIPAL']}');
              print('     Puntaje: ${test['PUNTAJE_PRINCIPAL']}');
              print('     Fecha completado: ${test['FECHA_COMPLETADO']}');
            }
            print('');
          }
        } else {
          print('ℹ️  No hay tests asignados a este congregante');
          
          if (data['tests_disponibles'].isNotEmpty) {
            print('');
            print('📋 Tests Disponibles:');
            for (var test in data['tests_disponibles']) {
              print('   • ${test['NOMBRE_TEST']} (ID: ${test['IDTEST']})');
              print('     ${test['DESCRIPCION']}');
              print('     Total preguntas: ${test['TOTAL_PREGUNTAS']}');
            }
          }
        }
      }
    } else if (response.statusCode == 404) {
      print('⚠️  Congregante no encontrado');
      print('📦 Response Body: ${response.body}');
    } else {
      print('❌ Error: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');
    }
  } catch (e) {
    print('❌ Exception: $e');
  }
  print('');
  print('═══════════════════════════════════════════════════════════\n');
}

/// Test 2: Obtener tests asignados
Future<void> testObtenerTestsAsignados(String codCongregante) async {
  print('📚 Test: Obtener tests asignados para congregante $codCongregante');
  print('─────────────────────────────────────');

  try {
    final url = '$baseUrl/testministerios/asignados/$codCongregante';
    print('🌐 URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print('📊 Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Success: ${!data['error']}');
      print('📦 Response Body:');
      print(const JsonEncoder.withIndent('  ').convert(data));
      print('');
      
      if (data['error'] == false && data['tests'] != null) {
        print('📝 Total de tests: ${data['tests'].length}');
        for (var test in data['tests']) {
          print('   • ${test['NOMBRE_TEST']}');
        }
      }
    } else {
      print('❌ Error: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');
    }
  } catch (e) {
    print('❌ Exception: $e');
  }
  print('');
  print('═══════════════════════════════════════════════════════════\n');
}

/// Test 3: Guardar respuestas de un test
Future<void> testGuardarRespuestas() async {
  print('💾 Test: Guardar respuestas de un test');
  print('─────────────────────────────────────');

  try {
    final url = '$baseUrl/testministerios/guardar_respuestas';
    print('🌐 URL: $url');

    final body = {
      'cod_congregante': '123', // Reemplaza con un cod válido
      'id_test': 1,
      'respuestas': [
        {'pregunta_id': 1, 'respuesta_id': 2},
        {'pregunta_id': 2, 'respuesta_id': 5},
        {'pregunta_id': 3, 'respuesta_id': 8},
      ],
    };

    print('📤 Body:');
    print(const JsonEncoder.withIndent('  ').convert(body));
    print('');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    print('📊 Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Success: ${!data['error']}');
      print('📦 Response Body:');
      print(const JsonEncoder.withIndent('  ').convert(data));
      print('');
      
      if (data['error'] == false) {
        print('💾 Respuestas guardadas exitosamente');
        if (data['resultado'] != null) {
          print('📊 Resultado: ${data['resultado']}');
        }
      }
    } else {
      print('❌ Error: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');
    }
  } catch (e) {
    print('❌ Exception: $e');
  }
  print('');
  print('═══════════════════════════════════════════════════════════\n');
}
