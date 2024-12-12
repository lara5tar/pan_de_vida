import 'package:get/get.dart';

import '../controllers/asistencia_controller.dart';

class AsistenciaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AsistenciaController>(
      () => AsistenciaController(),
    );
  }
}
