import 'package:get_storage/get_storage.dart';

import '../../../core/values/keys.dart';
import '../models/congregant_model.dart';
import 'api_service.dart';

class RestauracionService {
  Future<Map<String, dynamic>> getCongregantesRestauracion() async {
    final box = GetStorage(Keys.LOGIN_KEY);
    final codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    final data = {Keys.COD_CONGREGANTE_KEY: codCongregante};

    var result = await ApiService.request(
      '/restauracion/obtener21',
      data,
    );

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

    return result;
  }
}
