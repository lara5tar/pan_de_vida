import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/rpa/controllers/new_rpa_controller.dart';
import 'package:pan_de_vida/app/modules/rpa/controllers/prospectos_controller.dart';

import '../controllers/rpa_index_controller.dart';
import '../controllers/team_controller.dart';

class RpaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewRpaController>(
      () => NewRpaController(),
    );
    Get.lazyPut<RpaIndexController>(
      () => RpaIndexController(),
    );
    Get.lazyPut<TeamController>(
      () => TeamController(),
    );
    Get.lazyPut<ProspectosController>(
      () => ProspectosController(),
    );
  }
}
