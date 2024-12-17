import 'package:get/get.dart';

import 'package:pan_de_vida/app/modules/restauracion/controllers/restauracion_congregante_controller.dart';

import '../controllers/restauracion_controller.dart';

class RestauracionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestauracionCongreganteController>(
      () => RestauracionCongreganteController(),
    );
    Get.lazyPut<RestauracionController>(
      () => RestauracionController(),
    );
  }
}
