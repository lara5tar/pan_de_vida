import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/values/keys.dart';
import '../../../data/services/test_ministerio_service.dart';
import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  var menu = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    cargarMenu();
    verificarTestsMinisterio();
  }

  void cargarMenu() {
    final box = GetStorage(Keys.LOGIN_KEY);
    menu.value = List.from(box.read('menu') ?? []);
  }

  Future<void> verificarTestsMinisterio() async {
    try {
      final response = await TestMinisterioService.verificarAsignacion();
      final box = GetStorage(Keys.LOGIN_KEY);
      List storedMenu = box.read('menu') ?? [];

      // Remover cualquier entrada previa para evitar duplicados
      storedMenu.removeWhere((item) => item['MENU'] == 'TEST DE MINISTERIOS');

      if (!response['error'] && response['mostrar_boton'] == true) {
        storedMenu.add({
          'MENU': 'TEST DE MINISTERIOS',
          'OPCIONES': [
            {
              'OPCION': 'CONTESTAR TEST',
              'URL': Routes.TEST_MINISTERIO,
            }
          ]
        });
        await box.write('test_ministerio_estado', response['estado']);
      } else {
        box.remove('test_ministerio_estado');
      }

      await box.write('menu', storedMenu);
      menu.value = List.from(storedMenu);
    } catch (e) {
      print('Error verificando tests de ministerio: $e');
    }
  }
}
