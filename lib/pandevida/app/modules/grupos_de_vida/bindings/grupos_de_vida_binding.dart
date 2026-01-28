import 'package:get/get.dart';

import '../controllers/grupos_de_vida_controller.dart';

class GruposDeVidaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GruposDeVidaController>(
      () => GruposDeVidaController(),
    );
  }
}
