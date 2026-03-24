import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../core/values/keys.dart';
import '../models/discipulo_model.dart';

class DiscipulosService {
  static String get _baseUrl => Keys.URL_SERVICE;

  static Future<Map<String, dynamic>> getDiscipulos() async {
    final codCongregante =
        GetStorage(Keys.LOGIN_KEY).read(Keys.COD_CONGREGANTE_KEY);
    return _fetchDiscipulos(codCongregante?.toString() ?? '');
  }

  static Future<Map<String, dynamic>> getDiscipulosByID(String id) async {
    return _fetchDiscipulos(id);
  }

  static Future<Map<String, dynamic>> _fetchDiscipulos(
      String codCongregante) async {
    final url = Uri.parse('$_baseUrl/congregante/discipulos');

    final body = <String, dynamic>{
      Keys.COD_CONGREGANTE_KEY: codCongregante,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;

        if (result['error'] == true) {
          return {
            'error': true,
            'message': result['message'] ?? 'Error del servidor',
          };
        }

        List<Discipulo> parseGroup(String key) {
          final raw = result[key] as List<dynamic>? ?? [];
          return raw
              .map((e) => Discipulo.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        return {
          'error': false,
          'marcador': parseGroup('marcador'),
          'noMarcador': parseGroup('noMarcador'),
          'sinRegistro': parseGroup('sinRegistro'),
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }
}
