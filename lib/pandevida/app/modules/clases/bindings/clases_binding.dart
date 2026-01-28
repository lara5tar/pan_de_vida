import 'package:get/get.dart';

import 'package:pan_de_vida/pandevida/app/modules/clases/controllers/clase_cuestionario_controller.dart';
import 'package:pan_de_vida/pandevida/app/modules/clases/controllers/clase_cuestionario_video_controller.dart';
import 'package:pan_de_vida/pandevida/app/modules/clases/controllers/clase_videos_controller.dart';

import '../controllers/clases_controller.dart';

class ClasesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClaseCuestionarioController>(
      () => ClaseCuestionarioController(),
    );
    Get.lazyPut<ClaseCuestionarioVideoController>(
      () => ClaseCuestionarioVideoController(),
    );
    Get.lazyPut<ClaseVideosController>(
      () => ClaseVideosController(),
    );
    Get.lazyPut<ClasesController>(
      () => ClasesController(),
    );
  }
}
