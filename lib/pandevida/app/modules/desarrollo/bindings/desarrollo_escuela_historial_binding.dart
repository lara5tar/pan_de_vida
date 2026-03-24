import 'package:get/get.dart';

import '../controllers/desarrollo_escuela_historial_controller.dart';

class DesarrolloEscuelaHistorialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DesarrolloEscuelaHistorialController>(
      () => DesarrolloEscuelaHistorialController(),
    );
  }
}
