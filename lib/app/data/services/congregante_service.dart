import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CongreganteService {
  final String baseUrl = dotenv.env['URL_SERVICE'] ?? '';

  Future<dynamic> getMenu() async {
    final url = Uri.parse('$baseUrl/app/menu');
    final data = {'codCongregante': GetStorage('login').read('codCongregante')};

    print(data);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return {
          'error': false,
          'message': result['message'],
          'menu': result['menu'],
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }
}
