import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../../core/values/keys.dart';

class CongreganteService {
  Future<dynamic> getMenu() async {
    final url = Uri.parse('${Keys.URL_SERVICE}/app/menu');
    final data = {'codCongregante': GetStorage('login').read('codCongregante')};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        GetStorage('login').write('menu', result['menu']);

        return {
          'error': false,
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }
}
