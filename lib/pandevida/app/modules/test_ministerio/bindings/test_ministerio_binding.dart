import 'package:get/get.dart';

import '../controllers/test_ministerio_list_controller.dart';
import '../controllers/test_ministerio_preguntas_controller.dart';

class TestMinisterioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestMinisterioListController>(
      () => TestMinisterioListController(),
    );
    Get.lazyPut<TestMinisterioPreguntasController>(
      () => TestMinisterioPreguntasController(),
    );
  }
}
