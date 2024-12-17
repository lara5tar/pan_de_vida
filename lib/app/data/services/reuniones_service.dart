import 'package:get_storage/get_storage.dart';
import 'package:pan_de_vida/core/utils/print_debug.dart';

import '../../../core/values/keys.dart';
import 'api_service.dart';

class ReunionesService {
  //   getReuniones() {
  //   let url = URL_SERVICIOS + '/grupoVida/obtener';
  //   let data = {
  //     'codCasaVida': this.codCasaVida
  //   };
  //   console.log(' this.codCasaVida' + this.codCasaVida);
  //   return this.http.post(url, data)
  //     .pipe(map((dataResp: any) => dataResp['reuniones']));

  // }

  getReuniones() async {
    String codCasaVida =
        GetStorage(Keys.LOGIN_KEY).read(Keys.COD_CASA_VIDA_KEY);

    var result = await ApiService.request(
      '/grupoVida/obtener',
      {'codCasaVida': codCasaVida},
    );

    printD(result);
  }
}
