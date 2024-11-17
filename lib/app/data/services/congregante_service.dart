import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:pan_de_vida/app/data/models/congregant_model.dart';

import '../../../core/values/keys.dart';

class CongreganteService {
  Future<dynamic> getMenu() async {
    final url = Uri.parse('${Keys.URL_SERVICE}/app/menu');

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

        GetStorage(Keys.LOGIN_KEY).write('menu', result['menu']);

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

  Future<dynamic> getCongregants() async {
    final url = Uri.parse('${Keys.URL_SERVICE}/cumbres/ovejasDetail');
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

        List<Congregant> ovejas = [];
        List<Congregant> nietos = [];

        for (var oveja in result['ovejas']) {
          ovejas.add(Congregant.fromJson(oveja));
        }

        for (var nieto in result['nietos']) {
          nietos.add(Congregant.fromJson(nieto));
        }

        return {
          'error': false,
          'ovejas': ovejas,
          'nietos': nietos,
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> getCongregante(
      String codCongregante, String idCongregante) async {
    final String url = '${Keys.URL_SERVICE}/congregante/obtener';
    final Map<String, String> body = {
      'codCongregante': codCongregante,
      'idCongregante': idCongregante,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(data['congregante']);
        return {'error': false, 'congregante': data['congregante']};
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }
}
