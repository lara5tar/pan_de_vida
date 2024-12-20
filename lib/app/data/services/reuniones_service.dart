import 'package:get_storage/get_storage.dart';
import 'package:pan_de_vida/app/data/models/reunion_model.dart';

import '../../../core/values/keys.dart';
import 'api_service.dart';

class ReunionesService {
  Future<Map<dynamic, dynamic>> getReuniones() async {
    String codCasaVida =
        GetStorage(Keys.LOGIN_KEY).read(Keys.COD_CASA_VIDA_KEY);

    var result = await ApiService.request(
      '/grupoVida/obtener',
      {'codCasaVida': codCasaVida},
    );

    if (!result['error']) {
      return {
        'error': false,
        'data': List<Reunion>.from(
          result['reuniones'].map((e) => Reunion.fromJson(e)),
        ),
      };
    } else {
      return result;
    }
  }

  //   set_reunion(
  //   fecha: string,
  //   tema: string,
  //   predicador: string,
  //   hrInicio: string,
  //   hrFin: string,
  //   ofrenda: string,
  //   tCongregantes: string) {
  //   let url = URL_SERVICIOS + '/grupoVida/guardar_datos';
  //   let data = {
  //     'codCasaVida': this.codCasaVida,
  //     'fecha': fecha,
  //     'tema': tema,
  //     'predicador': predicador,
  //     'hrInicio': hrInicio,
  //     'hrFin': hrFin,
  //     'ofrenda': ofrenda,
  //     'tCongregantes': tCongregantes
  //   };
  //   console.log(data);
  //   return this.http.post(url, data);
  // }

  Future<Map<dynamic, dynamic>> setReunion(
    String fecha,
    String tema,
    String predicador,
    String hrInicio,
    String hrFin,
    String ofrenda,
    String tCongregantes,
  ) async {
    String codCasaVida =
        GetStorage(Keys.LOGIN_KEY).read(Keys.COD_CASA_VIDA_KEY);

    var result = await ApiService.request(
      '/grupoVida/guardar_datos',
      {
        'codCasaVida': codCasaVida,
        'fecha': fecha,
        'tema': tema,
        'predicador': predicador,
        'hrInicio': hrInicio,
        'hrFin': hrFin,
        'ofrenda': ofrenda,
        'tCongregantes': tCongregantes,
      },
    );

    return result;
  }
}
