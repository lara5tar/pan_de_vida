import 'package:get/get.dart';

import '../../../data/models/alerta_model.dart';
import '../../../data/services/alerta_service.dart';

class AlertasController extends GetxController {
  List<Alerta> alertas = [];
  List<Alerta> alertasEquipo = [];

  var isLoading = true.obs;

  @override
  void onInit() {
    getAlertas();
    super.onInit();
  }

  getAlertas() async {
    var result = await AlertaService.obtener();

    if (!result['error']) {
      alertas = result['alerta'];
      alertasEquipo = result['alertaEquipo'];
      isLoading.value = false;
    } else {
      Get.snackbar(
        'Error',
        'No se pudo obtener las alertas',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
