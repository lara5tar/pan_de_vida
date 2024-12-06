import 'package:get_storage/get_storage.dart';
import 'package:pan_de_vida/app/data/models/congregant_model.dart';
import 'package:pan_de_vida/app/data/services/api_service.dart';

import '../../../core/values/keys.dart';

class RestauracionService {
  Future<Map<String, dynamic>> getCongregantesRestauracion() async {
    final box = GetStorage(Keys.LOGIN_KEY);
    final codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    final data = {Keys.COD_CONGREGANTE_KEY: codCongregante};

    var result = await ApiService.request(
      '/restauracion/obtener21',
      data,
    );

    print(result);

    if (!result['error']) {
      return {
        'error': false,
        'data': List<Congregant>.from(
          result['restauracion'].map((e) => Congregant.fromJson(e)),
        ),
      };
    } else {
      return result;
    }
  }

  // set_restauracionVisita(codConFin: string) {
  //   let url = URL_SERVICIOS + '/restauracion/guardarVisita';
  //   let data = {
  //     codCongregante: this.codCongregante,
  //     codConFin
  //   };
  //   console.log(data);
  //   return this.http.post(url, data);
  // }

  Future<Map<String, dynamic>> setRestauracionVisita(String codConFin) async {
    final box = GetStorage(Keys.LOGIN_KEY);
    final codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    final data = {
      Keys.COD_CONGREGANTE_KEY: codCongregante,
      'codConFin': codConFin,
    };

    var result = await ApiService.request(
      '/restauracion/guardarVisita',
      data,
    );

    print(result);

    return result;
  }
}
