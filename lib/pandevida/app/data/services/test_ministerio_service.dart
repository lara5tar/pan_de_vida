import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../../core/values/keys.dart';

class TestMinisterioService {
  // URL base — tomada directamente del .env (Keys.URL_SERVICE)
  static String get baseUrl => Keys.URL_SERVICE;

  /// Verifica si un congregante tiene tests asignados
  ///
  /// Returns: Map con estructura:
  /// ```dart
  /// {
  ///   'error': bool,
  ///   'tiene_asignacion': bool,
  ///   'congregante': Map,
  ///   'resumen': Map,
  ///   'tests_pendientes': List,
  ///   'tests_completados': List,
  ///   'tests_disponibles': List,
  ///   'message': String? // solo si hay error
  /// }
  /// ```
  static Future<Map<String, dynamic>> verificarAsignacion() async {
    try {
      // Obtener el código del congregante actual del storage
      final box = GetStorage(Keys.LOGIN_KEY);
      final String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

      if (codCongregante.isEmpty) {
        return {
          'error': true,
          'message': 'No se encontró el código del congregante',
        };
      }

      final url =
          '$baseUrl/testministerios/verificar_asignacion/$codCongregante';

      print('========================================');
      print('TestMinisterioService.verificarAsignacion');
      print('URL: $url');
      print('codCongregante: $codCongregante');
      print('Iniciando petición HTTP...');
      print('========================================');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('========================================');
      print('RESPUESTA DEL SERVIDOR:');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print('========================================');

      if (response.statusCode == 200) {
        print('✅ Respuesta exitosa 200');
        final data = json.decode(response.body);
        print('📦 Data decodificada: $data');

        // Verificar si la respuesta es exitosa
        if (data['error'] == false) {
          final String estado = data['estado'] ?? 'SIN_ASIGNAR';
          print('✅ Sin errores en la respuesta');
          print('estado: $estado');

          // El botón se muestra si tiene test pendiente o ya completado
          return {
            'error': false,
            'estado': estado,
            'mostrar_boton': estado == 'PENDIENTE' || estado == 'COMPLETADO',
          };
        } else {
          print('⚠️ Error en la respuesta del servidor');
          return {
            'error': true,
            'message': data['message'] ?? 'Error en la respuesta del servidor',
          };
        }
      } else if (response.statusCode == 404) {
        print('❌ Error 404 - No encontrado');
        return {
          'error': true,
          'message': 'No se encontró información para este congregante',
        };
      } else {
        print('❌ Error del servidor: ${response.statusCode}');
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e, stackTrace) {
      print('❌ ERROR en verificarAsignacion: $e');
      print('Stack trace: $stackTrace');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Obtiene un test completo con sus preguntas y opciones por ID
  /// Verifica si el test ya fue completado por el congregante
  static Future<Map<String, dynamic>> obtenerTest(String idTest) async {
    try {
      final box = GetStorage(Keys.LOGIN_KEY);
      final String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

      final url =
          '$baseUrl/testministerios/obtener_test/$idTest/$codCongregante';
      print('TestMinisterioService.obtenerTest: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('obtenerTest status: ${response.statusCode}');
      print('obtenerTest body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          return {
            'error': false,
            'test': data['test'],
            'completado': data['completado'] ?? false,
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'Error al obtener el test',
          };
        }
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en obtenerTest: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Obtiene la lista de tests activos desde la API
  static Future<Map<String, dynamic>> obtenerTests() async {
    try {
      final box = GetStorage(Keys.LOGIN_KEY);
      final String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

      final url = '$baseUrl/testministerios/tests/$codCongregante';
      print('TestMinisterioService.obtenerTests: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('obtenerTests status: ${response.statusCode}');
      print('obtenerTests body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          return {
            'error': false,
            'tests': data['tests'] ?? [],
          };
        } else {
          return {
            'error': true,
            'message': data['mensaje'] ??
                data['message'] ??
                'Error al obtener los tests',
          };
        }
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en obtenerTests: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Obtiene la lista de tests asignados al congregante
  static Future<Map<String, dynamic>> obtenerTestsAsignados() async {
    try {
      final box = GetStorage(Keys.LOGIN_KEY);
      final String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

      if (codCongregante.isEmpty) {
        return {
          'error': true,
          'message': 'No se encontró el código del congregante',
        };
      }

      final url = '$baseUrl/testministerios/asignados/$codCongregante';

      print('TestMinisterioService.obtenerTestsAsignados: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['error'] == false) {
          return {
            'error': false,
            'tests': data['tests'] ?? [],
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'Error en la respuesta del servidor',
          };
        }
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en obtenerTestsAsignados: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Guarda las respuestas de un test completado
  static Future<Map<String, dynamic>> guardarRespuestas({
    required String idTest,
    required List<Map<String, dynamic>> respuestas,
  }) async {
    try {
      final box = GetStorage(Keys.LOGIN_KEY);
      final String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

      if (codCongregante.isEmpty) {
        return {
          'error': true,
          'message': 'No se encontró el código del congregante',
        };
      }

      final url = '$baseUrl/testministerios/submit';
      print('TestMinisterioService.guardarRespuestas: $url');

      final body = {
        'codCongregante': int.tryParse(codCongregante) ?? codCongregante,
        'idTest': int.tryParse(idTest) ?? idTest,
        'respuestas': respuestas,
      };

      print('Body: ${json.encode(body)}');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 15));

      print('guardarRespuestas status: ${response.statusCode}');
      print('guardarRespuestas body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          return {
            'error': false,
            'mensaje': data['mensaje'] ?? 'Test completado exitosamente',
            'idResultado': data['idResultado'],
            'ministerios': data['ministerios'],
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'Error al guardar las respuestas',
          };
        }
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en guardarRespuestas: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}
