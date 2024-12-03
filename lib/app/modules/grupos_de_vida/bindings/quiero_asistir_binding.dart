import 'package:get/get.dart';

import '../controllers/quiero_asistir_controller.dart';

class QuieroAsistirBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuieroAsistirController>(
      () => QuieroAsistirController(),
    );
  }
}
