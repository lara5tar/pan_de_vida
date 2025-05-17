import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/values/keys.dart';

class ApiService {
  static Future<Map<String, dynamic>> request(
    String url,
    Map<String, dynamic> data,
  ) async {
    try {
      var response = await http.post(
        Uri.parse(Keys.URL_SERVICE + url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'error': true,
          'message': 'Error en la respuesta del servidor',
        };
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }
}
