import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService extends GetxService {
  final String baseUrl = dotenv.env['URL_SERVICE'] ?? '';

  Future<Map<String, dynamic>> login(String user, String pass) async {
    final url = Uri.parse('$baseUrl/app/login');
    final data = {
      'user': user,
      'contra': pass,
    };

    try {
      final response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final respData = json.decode(response.body);
        if (respData['error'] == true) {
          return {'error': true, 'message': respData['mensaje']};
        } else {
          await saveLoginData(respData);
          return respData;
        }
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

  Future<void> saveLoginData(Map<String, dynamic> data) async {
    final box = GetStorage('login');
    await box.write('codCongregante', data['token']);

    if (data['codCasaVida'] != null) {
      await box.write('codCasaVida', data['codCasaVida']);
    }

    if (data['codHogar'] != null) {
      await box.write('codHogar', data['codHogar']);
    }

    if (data['roles'] != null) {
      await box.write('roles', data['roles']);
    }
  }
}
