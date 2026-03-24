import 'package:get/get.dart';

import '../controllers/desarrollo_rpa_controller.dart';

class DesarrolloRpaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DesarrolloRpaController>(() => DesarrolloRpaController());
  }
}
