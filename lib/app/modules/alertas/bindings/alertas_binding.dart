import 'package:get/get.dart';

import '../controllers/alertas_controller.dart';

class AlertasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlertasController>(
      () => AlertasController(),
    );
  }
}
