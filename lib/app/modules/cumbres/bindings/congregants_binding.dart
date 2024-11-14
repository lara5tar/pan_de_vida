import 'package:get/get.dart';

import '../controllers/congregants_controller.dart';

class CongregantsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CongregantsController>(
      () => CongregantsController(),
    );
  }
}
