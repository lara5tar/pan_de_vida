import 'package:get/get.dart';

import '../controllers/map_groups_controller.dart';

class MapGroupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapGroupsController>(
      () => MapGroupsController(),
    );
  }
}
