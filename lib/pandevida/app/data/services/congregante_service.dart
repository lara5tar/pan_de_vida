import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../../core/values/keys.dart';
import '../models/affirmation_model.dart';
import '../models/group_attendance_model.dart';
import '../models/congregant_model.dart';
import '../models/school_attendace_model.dart';
import '../models/escuela_historial_model.dart';

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

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          Keys.COD_CONGREGANTE_KEY: codCongregant,
          'idCongregante': codCongregant,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'error': false,
          'congregant':
              Congregant.fromJson(jsonDecode(response.body)['congregante'])
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

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({Keys.COD_CONGREGANTE_KEY: codCongregante}),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        return {
          'error': false,
          'data': Affirmation.fromJson(result['afirmacion']),
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

    // var result = await ApiService.request(
    //   '${Keys.URL_SERVICE}/escuela/obtener_asistencia',
    //   {Keys.COD_CONGREGANTE_KEY: codCongregante},
    // );

    // if (!result['error']) {
    //   return {
    //     'error': false,
    //     'attendance': SchoolAttendace.fromJson(result['asistencia']),
    //   };
    // } else {
    //   return result;
    // }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({Keys.COD_CONGREGANTE_KEY: codCongregante}),
      );

      if (response.statusCode == 200) {
        return {
          'error': false,
          'attendance': SchoolAttendace.fromJson(jsonDecode(response.body)),
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

    print('=== getGroupAttendance SERVICE ===');
    print('URL: $url');
    print('Body: ${jsonEncode({Keys.COD_CONGREGANTE_KEY: codCongregante})}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({Keys.COD_CONGREGANTE_KEY: codCongregante}),
      );

      print('Status: ${response.statusCode}');
      print('Response body RAW: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'error': false,
          'attendance': GroupAttendace.fromJson(jsonDecode(response.body)),
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> getEscuelaHistorial(
      String codCongregante) async {
    final String url = '${Keys.URL_SERVICE}/escuela/historial';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({Keys.COD_CONGREGANTE_KEY: codCongregante}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result['error'] == false) {
          final List<EscuelaHistorial> escuelas = (result['escuelas'] as List)
              .map((e) => EscuelaHistorial.fromJson(e))
              .toList();

          return {
            'error': false,
            'escuelas': escuelas,
          };
        } else {
          return {
            'error': true,
            'message': result['message'] ?? 'Error del servidor'
          };
        }
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  /// Obtener la lista de elegidos de un mentor
  Future<Map<String, dynamic>> getElegidos(String codMentor) async {
    final String url = '${Keys.URL_SERVICE}/congregante/elegidos';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({Keys.COD_CONGREGANTE_KEY: codMentor}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result;
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  /// Agregar un discípulo como elegido (máx 3)
  Future<Map<String, dynamic>> elegirDiscipulo(
      String codMentor, String codDiscipulo) async {
    final String url = '${Keys.URL_SERVICE}/congregante/elegir';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          Keys.COD_CONGREGANTE_KEY: codMentor,
          'codDiscipulo': codDiscipulo,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  /// Quitar un discípulo de elegidos
  Future<Map<String, dynamic>> quitarElegido(
      String codMentor, String codDiscipulo) async {
    final String url = '${Keys.URL_SERVICE}/congregante/quitar_elegido';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          Keys.COD_CONGREGANTE_KEY: codMentor,
          'codDiscipulo': codDiscipulo,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }
}
