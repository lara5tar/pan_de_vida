import 'package:get/get.dart';

import '../controllers/desarrollo_controller.dart';

class DesarrolloBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DesarrolloController>(() => DesarrolloController());
  }
}
