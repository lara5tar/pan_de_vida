import 'package:get/get.dart';

import '../controllers/restauracion_controller.dart';

class RestauracionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestauracionController>(
      () => RestauracionController(),
    );
  }
}
