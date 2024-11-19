import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/values/keys.dart';
import '../models/cumbre_model.dart';

class CumbresServices {
  getCumbres() async {
    final url = Uri.parse('${Keys.URL_SERVICE}/cumbres/obtener21');
    final data = {
      Keys.COD_CONGREGANTE_KEY: GetStorage(Keys.LOGIN_KEY).read(
        Keys.COD_CONGREGANTE_KEY,
      )
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        List<Cumbre> cumbres = [];

        for (var cumbre in result['cumbres']) {
          cumbres.add(Cumbre.fromJson(cumbre));
        }

        return {
          'error': false,
          'cumbres': cumbres,
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }
}
