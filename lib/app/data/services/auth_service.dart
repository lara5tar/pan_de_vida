import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pan_de_vida/core/utils/print_debug.dart';

import '../../../core/values/keys.dart';
import 'api_service.dart';

class AuthService extends GetxService {
  static String getCodCongregante() {
    return GetStorage(Keys.LOGIN_KEY).read(Keys.COD_CONGREGANTE_KEY);
  }

  String? get getUser {
    return GetStorage(Keys.LOGIN_KEY).read(Keys.USER_KEY);
  }

  static String? get getCodCasaVida {
    return GetStorage(Keys.LOGIN_KEY).read(Keys.COD_CASA_VIDA_KEY);
  }

  bool get isLogged {
    return GetStorage(Keys.LOGIN_KEY).hasData(Keys.COD_CONGREGANTE_KEY);
  }

  Future<void> logout() async {
    printD('AuthService.logout');

    final box = GetStorage(Keys.LOGIN_KEY);
    await box.erase();
  }

  Future<Map<String, dynamic>> checkPassword(String password) async {
    printD('AuthService.comprobarContraseña');

    var result = await ApiService.request(
      '/app/login',
      {'user': getUser, 'contra': password},
    );

    return result;
  }

  Future<Map<String, dynamic>> login(String user, String password) async {
    printD('AuthService.login');

    var result = await ApiService.request(
      '/app/login',
      {'user': user, 'contra': password},
    );

    if (!result['error']) await saveLoginData(result, user);

    return result;
  }

  Future<void> saveLoginData(Map<String, dynamic> data, String user) async {
    final box = GetStorage(Keys.LOGIN_KEY);
    box.erase();

    await box.write(Keys.COD_CONGREGANTE_KEY, data['token']);

    await box.write(Keys.USER_KEY, user);

    if (data[Keys.COD_CASA_VIDA_KEY] != null) {
      await box.write(Keys.COD_CASA_VIDA_KEY, data[Keys.COD_CASA_VIDA_KEY]);
    }

    if (data[Keys.COD_HOGAR_KEY] != null) {
      await box.write(Keys.COD_HOGAR_KEY, data[Keys.COD_HOGAR_KEY]);
    }

    if (data[Keys.ROLES_KEY] != null) {
      await box.write(Keys.ROLES_KEY, data[Keys.ROLES_KEY]);
    }
  }
}
