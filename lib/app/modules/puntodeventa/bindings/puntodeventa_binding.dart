import 'package:get/get.dart';

import '../controllers/puntodeventa_controller.dart';

class PuntodeventaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PuntodeventaController>(
      () => PuntodeventaController(),
    );
  }
}
