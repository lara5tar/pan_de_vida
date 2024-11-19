import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pan_de_vida/app/data/models/congregant_model.dart';
import 'package:pan_de_vida/app/data/models/prospecto_model.dart';

import '../../../core/values/keys.dart';
import '../models/cumbre_model.dart';
import '../models/video_model.dart';

class CumbresServices {
  getCumbres(String? codCongregante) async {
    final url = Uri.parse('${Keys.URL_SERVICE}/cumbres/obtener21');
    final data = {
      Keys.COD_CONGREGANTE_KEY: codCongregante ??
          GetStorage(Keys.LOGIN_KEY).read(
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

  getCumbresEquipo() async {
    final url = Uri.parse('${Keys.URL_SERVICE}/cumbres/obtener_equipo');
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
        List<Congregant> sinRegistro = [];
        List<Congregant> marcador = [];
        List<Congregant> noMarcador = [];

        for (var congregant in result['sinRegistro']) {
          sinRegistro.add(Congregant.fromJson(congregant));
        }

        for (var congregant in result['marcador']) {
          marcador.add(Congregant.fromJson(congregant));
        }

        for (var congregant in result['noMarcador']) {
          noMarcador.add(Congregant.fromJson(congregant));
        }

        return {
          'error': false,
          'sinRegistro': sinRegistro,
          'marcador': marcador,
          'noMarcador': noMarcador,
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  getProspectos(String codCongregante, String codAccion) async {
    final url = Uri.parse('${Keys.URL_SERVICE}/cumbres/prospectos');
    final data = {
      Keys.COD_CONGREGANTE_KEY: codCongregante,
      'codAccion': codAccion,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        print(result);

        return {
          'error': false,
          // 'prospectos': prospectos,
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  getProspectoDetail() async {
    final url = Uri.parse('${Keys.URL_SERVICE}/cumbres/prospectoDetail');
    final data = {
      Keys.COD_CONGREGANTE_KEY: GetStorage(Keys.LOGIN_KEY).read(
        Keys.COD_CONGREGANTE_KEY,
      ),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        List<Prospecto> prospectos = [];

        for (var congregant in result['prospectos']) {
          prospectos.add(Prospecto.fromJson(congregant));
        }

        return {
          'error': false,
          'prospectos': prospectos,
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  setProspecto(String nombre, String cel) async {
    final url = Uri.parse('${Keys.URL_SERVICE}/cumbres/prospecto');
    final data = {
      Keys.COD_CONGREGANTE_KEY: GetStorage(Keys.LOGIN_KEY).read(
        Keys.COD_CONGREGANTE_KEY,
      ),
      'nombre': nombre,
      'cel': cel,
    };

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
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  deleteProspecto(String idProspecto) async {
    final url = Uri.parse('${Keys.URL_SERVICE}/cumbres/baja_prospecto');
    final data = {
      'idProspecto': idProspecto,
    };

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
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }

  //   getVideosP(idProspecto: string) {
  //   this.url = URL_SERVICIOS + '/evangelismo/videosP';
  //   this.data = {
  //     idProspecto
  //   };
  //   return this.http.post(this.url, this.data);
  // }

  getProspectoVideos(String idProspecto) async {
    final url = Uri.parse('${Keys.URL_SERVICE}/evangelismo/videosP');
    print(idProspecto);
    final data = {
      'idProspecto': idProspecto,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        List<Video> videos = [];

        for (var video in result['videos']) {
          videos.add(Video.fromJson(video));
        }

        return {
          'error': false,
          'videos': videos,
        };
      } else {
        return {'error': true, 'message': 'Error en la respuesta del servidor'};
      }
    } catch (e) {
      return {'error': true, 'message': 'Error de conexión: $e'};
    }
  }
}
