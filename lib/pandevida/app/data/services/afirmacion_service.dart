import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pan_de_vida/pandevida/app/data/models/congregant_model.dart';
import 'package:pan_de_vida/pandevida/app/data/models/group_attendance_model.dart';
import 'package:pan_de_vida/pandevida/app/data/models/video_model.dart';

import '../../../core/values/keys.dart';

class AfirmacionService {
  getAfirmacionCongregantes() async {
    final box = GetStorage(Keys.LOGIN_KEY);
    final codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    final url = Uri.parse('${Keys.URL_SERVICE}/afirmacion/obtener21');

    final data = {Keys.COD_CONGREGANTE_KEY: codCongregante};

    try {
      final response = await http.post(
        url,
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      final result = json.decode(response.body);

      if (response.statusCode == 200) {
        List<Congregant> congregantes = [];
        for (var congregante in result['afirmacion']) {
          congregantes.add(Congregant.fromJson(congregante));
        }
        return {
          'error': false,
          'data': congregantes,
        };
      } else {
        return {
          'error': false,
          'message': 'Error al obtener las afirmaciones',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al obtener las afirmaciones $e',
      };
    }
  }

  getAfirmacionVideos(String codCongregante) async {
    final url = Uri.parse('${Keys.URL_SERVICE}/evangelismo/videos');

    final data = {'codCongregante': codCongregante, 'tipo': 'A'};

    try {
      final response = await http.post(
        url,
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        List<Video> videos = [];

        for (var video in result['videos']) {
          videos.add(Video.fromJson(video));
        }
        return {
          'error': false,
          'data': videos,
        };
      } else {
        return {
          'error': false,
          'message': 'Error al obtener las afirmaciones',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al obtener las afirmaciones $e',
      };
    }
  }

  getAsistencia(String codCongregante) async {
    final url = Uri.parse('${Keys.URL_SERVICE}/grupoVida/obtener_asistencia');

    final data = {'codCongregante': codCongregante};

    try {
      final response = await http.post(
        url,
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        return {
          'error': false,
          'data': GroupAttendace.fromJson(result),
        };
      } else {
        return {
          'error': false,
          'message': 'Error al obtener las asistencias',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al obtener las asistencias $e',
      };
    }
  }
}
