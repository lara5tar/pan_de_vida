import 'api_service.dart';

class AppcoreService {
  static setUnirseGrupo(String nombre, String email, String tel) {
    final data = {
      'nombre': nombre,
      'email': email,
      'tel': tel,
    };

    return ApiService.request(
      '/app/unirsegrupo',
      data,
    );
  }
}
