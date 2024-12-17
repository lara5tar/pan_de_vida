import 'package:get/get.dart';

import '../controllers/reuniones_controller.dart';

class ReunionesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReunionesController>(
      () => ReunionesController(),
    );
  }
}
