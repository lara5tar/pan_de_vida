import 'package:pan_de_vida/pandevida/app/data/models/reunion_model.dart';
import 'package:pan_de_vida/pandevida/app/data/services/auth_service.dart';

import 'api_service.dart';

class ReunionesService {
  Future<Map<dynamic, dynamic>> getReuniones() async {
    var result = await ApiService.request(
      '/grupoVida/obtener',
      {'codCasaVida': AuthService.getCodCasaVida},
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

  Future<Map<dynamic, dynamic>> setReunion(
    String fecha,
    String tema,
    String predicador,
    String hrInicio,
    String hrFin,
    String ofrenda,
    String tCongregantes,
  ) async {
    var result = await ApiService.request(
      '/grupoVida/guardar_datos',
      {
        'codCasaVida': AuthService.getCodCasaVida,
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

  Future<Map> updateReunion(
    int idReunion,
    String fecha,
    String tema,
    String predicador,
    String hrInicio,
    String hrFin,
    String ofrenda,
    String tCongregantes,
  ) async {
    var result = await ApiService.request(
      '/grupoVida/update_datos',
      {
        'idReunion': idReunion,
        'codCasaVida': AuthService.getCodCasaVida,
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
  // getCongregantes(codCasaVida: string) {
  //   let url = URL_SERVICIOS + '/grupoVida/obtener_congregantes';
  //   let data = {
  //     'codCasaVida': codCasaVida
  //   };
  //   return this.http.post(url, data)
  //     .pipe(map((dataResp: any) => dataResp['congregantes']));
  // }

  getCongregantesCasaVida() async {
    var result = await ApiService.request(
      '/grupoVida/obtener_congregantes',
      {
        'codCasaVida': AuthService.getCodCasaVida,
      },
    );

    print(result['congregantes']);

    return result;
  }

  //   getReunionCongregantes(idReunion: number) {
  //   let url = URL_SERVICIOS + '/grupoVida/obtener_reunion_congregante';
  //   let data = {
  //     'idReunion': idReunion
  //   };
  //   console.log(data);
  //   return this.http.post(url, data)
  //     .pipe(map((dataResp: any) => dataResp['congregantes']));
  // }

  getReunionCongregantes(int idReunion) async {
    var result = await ApiService.request(
      '/grupoVida/obtener_reunion_congregante',
      {
        'idReunion': idReunion,
      },
    );

    print('getreunioncongregantes');

    print(result['congregantes']);

    return result;
  }

  //   set_congregantes(idReunion: number, congregantes: any) {
  //   let url = URL_SERVICIOS + '/grupoVida/guardar_asistencia';
  //   let data = {
  //     'idReunion': idReunion,
  //     'congregantes': congregantes
  //   };
  //   console.log(data);
  //   return this.http.post(url, data);
  // }

  setCongregantes(int idReunion, List congregantes) async {
    var result = await ApiService.request(
      '/grupoVida/guardar_asistencia',
      {
        'idReunion': idReunion,
        'congregantes': congregantes,
      },
    );

    return result;
  }

  //   update_congregantes(idReunion: number, congregantes: any) {
  //   let url = URL_SERVICIOS + '/grupoVida/update_asistencia';
  //   let data = {
  //     'idReunion': idReunion,
  //     'congregantes': congregantes
  //   };
  //   console.log(data);
  //   return this.http.post(url, data);
  // }

  updateCongregantes(int idReunion, List congregantes) async {
    var result = await ApiService.request(
      '/grupoVida/update_asistencia',
      {
        'idReunion': idReunion,
        'congregantes': congregantes,
      },
    );

    return result;
  }
}
