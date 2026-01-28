import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/modules/rpa/controllers/cumbres_controller.dart';
import 'package:pan_de_vida/pandevida/app/modules/rpa/controllers/prospectos_controller.dart';

import '../controllers/new_prospecto_controller.dart';
import '../controllers/prospectos_videos_controller.dart';
import '../controllers/rpa_index_controller.dart';
import '../controllers/team_controller.dart';

class RpaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RpaIndexController>(
      () => RpaIndexController(),
    );
    Get.lazyPut<TeamController>(
      () => TeamController(),
    );
    Get.lazyPut<ProspectosController>(
      () => ProspectosController(),
    );
    Get.lazyPut<NewProspectoController>(
      () => NewProspectoController(),
    );
    Get.lazyPut<ProspectosVideosController>(
      () => ProspectosVideosController(),
    );
    Get.lazyPut<CumbresController>(
      () => CumbresController(),
    );
  }
}
