import 'package:get/get.dart';

import '../controllers/cumbres_controller.dart';

class CumbresBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CumbresController>(
      () => CumbresController(),
    );
  }
}
