import 'package:pan_de_vida/pandevida/app/data/models/accion_model.dart';
import 'package:pan_de_vida/pandevida/app/data/models/marcador_model.dart';

import '../../../core/utils/print_debug.dart';
import '../../../core/values/keys.dart';
import '../models/congregant_model.dart';
import '../models/cumbre_model.dart';
import '../models/prospecto_model.dart';
import '../models/video_model.dart';
import 'api_service.dart';
import 'auth_service.dart';

class CumbresServices {
  static Future<Map<String, dynamic>> getCumbres(String? codCongregante) async {
    printD('CumbresServices.getCumbres');
    codCongregante = codCongregante ?? AuthService.getCodCongregante();

    var result = await ApiService.request(
      '/cumbres/obtener21',
      {Keys.COD_CONGREGANTE_KEY: codCongregante},
    );

    if (result['error']) return result;

    return {
      'error': false,
      'cumbres': List<Cumbre>.from(
        result['cumbres'].map((e) => Cumbre.fromJson(e)),
      ),
    };
  }

  static Future<Map<String, dynamic>> getCumbresEquipo() async {
    printD('CumbresServices.getCumbresEquipo');
    var result = await ApiService.request(
      '/cumbres/obtener_equipo',
      {Keys.COD_CONGREGANTE_KEY: AuthService.getCodCongregante()},
    );

    if (result['error']) return result;

    return {
      'error': false,
      'sinRegistro': List<Congregant>.from(
        result['sinRegistro'].map((e) => Congregant.fromJson(e)),
      ),
      'marcador': List<Congregant>.from(
        result['marcador'].map((e) => Congregant.fromJson(e)),
      ),
      'noMarcador': List<Congregant>.from(
        result['noMarcador'].map((e) => Congregant.fromJson(e)),
      ),
    };
  }

  static Future<Map<String, dynamic>> getProspectos(
      String codCongregante, String codAccion) async {
    printD('CumbresServices.getProspectos');
    var result = await ApiService.request(
      '/cumbres/prospectos',
      {
        Keys.COD_CONGREGANTE_KEY: codCongregante,
        'codAccion': codAccion,
      },
    );

    if (result['error']) return result;

    return {
      'error': false,
      'prospectos': List<Prospecto>.from(
        result['prospectos'].map((e) => Prospecto.fromJson(e)),
      )
    };
  }

  static Future<Map<String, dynamic>> getProspectoDetail() async {
    printD('CumbresServices.getProspectoDetail');
    var result = await ApiService.request(
      '/cumbres/prospectoDetail',
      {
        Keys.COD_CONGREGANTE_KEY: AuthService.getCodCongregante(),
      },
    );

    if (result['error']) return result;

    return {
      'error': false,
      'prospectos': List<Prospecto>.from(
        result['prospectos'].map((e) => Prospecto.fromJson(e)),
      ),
    };
  }

  static Future<Map<String, dynamic>> setProspecto(
      String nombre, String cel) async {
    printD('CumbresServices.setProspecto');

    return await ApiService.request(
      '/cumbres/prospecto',
      {
        Keys.COD_CONGREGANTE_KEY: AuthService.getCodCongregante(),
        'nombre': nombre,
        'cel': cel,
      },
    );
  }

  static Future<Map<String, dynamic>> deleteProspecto(
      String idProspecto) async {
    printD('CumbresServices.deleteProspecto');

    return await ApiService.request(
      '/cumbres/baja_prospecto',
      {'idProspecto': idProspecto},
    );
  }

  static Future<Map<String, dynamic>> getProspectoVideos(
      String idProspecto) async {
    printD('CumbresServices.getProspectoVideos');
    var result = await ApiService.request(
      '/evangelismo/videosP',
      {'idProspecto': idProspecto},
    );

    if (result['error']) return result;

    return {
      'error': false,
      'videos': List<Video>.from(
        result['videos'].map((e) => Video.fromJson(e)),
      ),
    };
  }

  static Future<Map<String, dynamic>> getCumbreAcciones() async {
    printD('CumbresServices.getCumbreAcciones');

    var result = await ApiService.request(
      '/accion/obtener',
      {
        Keys.COD_CONGREGANTE_KEY: AuthService.getCodCongregante(),
      },
    );

    if (result['error']) return result;

    return {
      'error': false,
      'acciones': List<Accion>.from(
        result['acciones'].map((e) => Accion.fromJson(e)),
      ),
    };
  }

  static Future<Map<String, dynamic>> getCumbreMarcadores(
      String idAccion) async {
    printD('CumbresServices.getCumbreMarcadores');

    var result = await ApiService.request(
      '/marcador/marcadores',
      {
        Keys.COD_CONGREGANTE_KEY: AuthService.getCodCongregante(),
        'idAccion': idAccion,
      },
    );

    if (result['error']) return result;

    return {
      'error': false,
      'marcadores': List<Marcador>.from(
        result['marcadores'].map((e) => Marcador.fromJson(e)),
      ),
    };
  }

  static Future<Map<String, dynamic>> getCumbreCompromisoAccion() async {
    printD('CumbresServices.getCumbreCompromisoAccion');

    var result = await ApiService.request(
      '/cumbres/obtener_catalogo',
      {
        Keys.COD_CONGREGANTE_KEY: AuthService.getCodCongregante(),
      },
    );

    if (result['error']) return result;

    return {
      'error': false,
      'cumbres': List<Cumbre>.from(
        result['cumbres'].map((e) => Cumbre.fromJson(e)),
      ),
    };
  }

  static Future<Map<String, dynamic>> getCumbreCompromisoPersona(
      String codAccion) async {
    printD('CumbresServices.getCumbreCompromisoPersona');

    var result = await ApiService.request(
      '/cumbres/prospectos',
      {
        Keys.COD_CONGREGANTE_KEY: AuthService.getCodCongregante(),
        'codAccion': codAccion,
      },
    );

    if (result['error']) return result;

    printD(result['prospectos']);

    return {
      'error': false,
      'prospectos': List<Prospecto>.from(
        result['prospectos'].map((e) => Prospecto.fromJson(e)),
      ),
    };
  }

  static Future<Map<String, dynamic>> setCumbre(
    String idAccion,
    String idMarcador,
    String accSig,
    String prospectoSig,
  ) async {
    printD('CumbresServices.setCumbre');

    return await ApiService.request(
      '/cumbres/guardar21',
      {
        Keys.COD_CONGREGANTE_KEY: AuthService.getCodCongregante(),
        'idAccion': idAccion,
        'idMarcador': idMarcador,
        'accSig': accSig,
        'prospectoSig': prospectoSig,
      },
    );
  }
}
