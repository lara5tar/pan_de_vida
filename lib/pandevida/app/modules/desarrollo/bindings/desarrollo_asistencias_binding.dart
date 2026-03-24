import 'package:get/get.dart';

import '../controllers/desarrollo_asistencias_controller.dart';

class DesarrolloAsistenciasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DesarrolloAsistenciasController>(
      () => DesarrolloAsistenciasController(),
    );
  }
}
