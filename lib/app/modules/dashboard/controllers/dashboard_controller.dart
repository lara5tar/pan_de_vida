import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/services/congregante_service.dart';

class DashboardController extends GetxController {
  var menu = [].obs;

  CongreganteService congreganteService = CongreganteService();

  @override
  void onInit() {
    super.onInit();
    getMenu();
  }

  void getMenu() {
    congreganteService.getMenu().then((response) {
      if (response['error'] == true) {
        Get.snackbar('Error', response['message']);
      } else {
        menu.value = response['menu'];
      }
    });
  }
}
