import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/values/keys.dart';

class AuthService extends GetxService {
  Future<Map<String, dynamic>> login(String user, String pass) async {
    final url = Uri.parse('${Keys.URL_SERVICE}/app/login');
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
    final box = GetStorage(Keys.LOGIN_KEY);
    await box.write(Keys.COD_CONGREGANTE_KEY, data['token']);

    if (data[Keys.COD_CASA_VIDA_KEY] != null) {
      await box.write(Keys.COD_CASA_VIDA_KEY, data[Keys.COD_CASA_VIDA_KEY]);
    }

    if (data[Keys.COD_HOGAR_KEY] != null) {
      await box.write(Keys.COD_HOGAR_KEY, data[Keys.COD_HOGAR_KEY]);
    }

    if (data[Keys.ROLES_KEY] != null) {
      await box.write(Keys.ROLES_KEY, data[Keys.ROLES_KEY]);
    }
  }
}
