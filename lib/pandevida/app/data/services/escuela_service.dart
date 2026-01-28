import 'package:get_storage/get_storage.dart';
import 'package:pan_de_vida/pandevida/app/data/models/cuestionario_model.dart';
import 'package:pan_de_vida/pandevida/app/data/models/pregunta_model.dart';
import 'package:pan_de_vida/pandevida/app/data/models/school_attendace_model.dart';
import 'package:pan_de_vida/pandevida/app/data/models/video_model.dart';
import 'package:pan_de_vida/pandevida/core/values/keys.dart';

import 'api_service.dart';

class EscuelaService {
  static Future<Map> setAsistencia(String codCongregante) async {
    return await ApiService.request(
      '/escuela/registrar_asistencia',
      {'codCongregante': codCongregante},
    );
  }

  static Future<Map> setTarea(String codCongregante) async {
    return await ApiService.request(
      '/escuela/registrar_tarea',
      {'codCongregante': codCongregante},
    );
  }

  static Future<Map> setAsistenciaTarea(String codCongregante) async {
    return await ApiService.request(
      '/escuela/registrar_AsistenciaTarea',
      {'codCongregante': codCongregante},
    );
  }

  static Future<Map> setPago(String codCongregante, String monto) async {
    return await ApiService.request(
      '/escuela/pago',
      {'codCongregante': codCongregante, 'monto': monto},
    );
  }

  static Future<Map> getAsistencia() async {
    GetStorage box = GetStorage(Keys.LOGIN_KEY);
    String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    var response = await ApiService.request(
      '/escuela/obtener_asistencia',
      {'codCongregante': codCongregante},
    );

    if (response['error']) {
      return response;
    } else {
      return {
        'error': false,
        'data': SchoolAttendace.fromJson(response),
      };
    }
  }

  static Future<Map> getVideos() async {
    GetStorage box = GetStorage(Keys.LOGIN_KEY);
    String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    var response = await ApiService.request(
      '/clase/obtener_videos',
      {'codCongregante': codCongregante},
    );

    if (response['error']) {
      return response;
    } else {
      print(response);
      return {
        'error': false,
        'data': CuestionarioModel.fromJson(response),
      };
    }
  }

  static Future<Map> getVideoInfo(String codVideo) async {
    GetStorage box = GetStorage(Keys.LOGIN_KEY);
    String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    var response = await ApiService.request(
      '/clase/obtener_video_info',
      {'codCongregante': codCongregante, 'codVideo': codVideo},
    );
    if (response['error']) {
      return response;
    } else {
      return {
        'error': false,
        'data': Video.fromJson(response),
      };
    }
  }

  static Future<Map> getPregunta(String codVideo, {int? cuestionario}) async {
    GetStorage box = GetStorage(Keys.LOGIN_KEY);
    String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    var response = await ApiService.request(
      '/clase/obtener_pregunta',
      {
        'codCongregante': codCongregante,
        'codVideo': codVideo,
        'cuestionario': cuestionario
      },
    );

    if (response['error']) {
      return response;
    } else {
      return {
        'error': false,
        'data': List<Pregunta>.from(
          response['preguntas'].map((x) => Pregunta.fromJson(x)),
        ),
      };
    }
  }

  static Future<Map> setVideo(
    String codVideo,
    String idInscripcion,
    String numClase,
  ) async {
    GetStorage box = GetStorage(Keys.LOGIN_KEY);
    String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    return await ApiService.request(
      '/clase/guardar_video',
      {
        'codCongregante': codCongregante,
        'codVideo': codVideo,
        'idInscripcion': idInscripcion,
        'numClase': numClase,
      },
    );
  }

  static Future<Map> setCuestionarioTarea(
    String idInscripcion,
    String numClase,
    String codVideo,
  ) async {
    GetStorage box = GetStorage(Keys.LOGIN_KEY);
    String codCongregante = box.read(Keys.COD_CONGREGANTE_KEY);

    return await ApiService.request(
      '/clase/guardar_tarea',
      {
        'codCongregante': codCongregante,
        'idInscripcion': idInscripcion,
        'numClase': numClase,
        'codVideo': codVideo,
      },
    );
  }
}
