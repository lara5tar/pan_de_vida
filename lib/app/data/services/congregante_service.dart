import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../../core/values/keys.dart';
import '../models/group_attendance_model.dart';
import '../models/congregant_model.dart';
import '../models/school_attendace_model.dart';

class CongregantService {
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

  Future<Map<String, dynamic>> getCongregant(String codCongregant) async {
    final String url = '${Keys.URL_SERVICE}/congregante/obtener';
    final Map<String, String> body = {
      'codCongregante': codCongregant,
      'idCongregante': codCongregant,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return {
          'error': false,
          'congregant': Congregant.fromJson(data['congregante'])
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> getAffirmation(String codCongregante) async {
    final String url = '${Keys.URL_SERVICE}/afirmacion/detalle';
    final Map<String, String> body = {
      'codCongregante': codCongregante,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data['afirmacion']);
        return {
          'error': false,
          // 'afirmacion': data['afirmacion'],
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> getSchoolAttandance(
      String codCongregante) async {
    final String url = '${Keys.URL_SERVICE}/escuela/obtener_asistencia';
    final Map<String, String> body = {
      'codCongregante': codCongregante,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          'error': false,
          'attendance': SchoolAttendace.fromJson(data),
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> getGroupAttendance(String codCongregante) async {
    final String url = '${Keys.URL_SERVICE}/grupoVida/obtener_asistencia';
    final Map<String, String> body = {
      'codCongregante': codCongregante,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          'error': false,
          'attendance': GroupAttendace.fromJson(data),
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }
}
