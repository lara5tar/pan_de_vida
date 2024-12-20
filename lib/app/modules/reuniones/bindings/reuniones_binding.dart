import 'package:get/get.dart';

import 'package:pan_de_vida/app/modules/reuniones/controllers/reunion_form_controller.dart';
import 'package:pan_de_vida/app/modules/reuniones/controllers/reunion_form_edit_controller.dart';

import '../controllers/reuniones_controller.dart';

class ReunionesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReunionFormEditController>(
      () => ReunionFormEditController(),
    );
    Get.lazyPut<ReunionFormController>(
      () => ReunionFormController(),
    );
    Get.lazyPut<ReunionesController>(
      () => ReunionesController(),
    );
  }
}
