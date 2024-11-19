import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pan_de_vida/app/data/models/congregant_model.dart';

import '../../../core/values/keys.dart';
import '../models/cumbre_model.dart';

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

  //   get_cumbres_equipo() {
  //   const url = URL_SERVICIOS + '/cumbres/obtener_equipo';
  //   const data = {
  //     codCongregante: this.codCongregante
  //   };
  //   console.log(data);
  //   return this.http.post(url, data);
  // }

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
}
