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
}
