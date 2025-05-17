import 'package:get_storage/get_storage.dart';

import '../../../core/values/keys.dart';
import '../models/alerta_model.dart';
import 'api_service.dart';

class AlertaService {
  //    obtener( ) {
  //   this.cargar_storage();
  //   let url = URL_SERVICIOS + '/alerta/obtener';
  //   let data = {
  //         'codCongregante' : this.codCongregante
  //     };
  //   console.log(data);
  //   return this.http.post( url, data );

  // }

  static Future<Map> obtener() async {
    final box = GetStorage(Keys.LOGIN_KEY);
    final codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    final data = {
      Keys.COD_CONGREGANTE_KEY: codCongregante,
    };

    var result = await ApiService.request(
      '/alerta/obtener',
      data,
    );

    if (result['error']) {
      return result;
    } else {
      return {
        'error': false,
        'alerta': List<Alerta>.from(
          result['alerta'].map((e) => Alerta.fromJson(e)),
        ),
        'alertaEquipo': List<Alerta>.from(
          result['alertaEquipo'].map((e) => Alerta.fromJson(e)),
        ),
      };
    }
  }
}
