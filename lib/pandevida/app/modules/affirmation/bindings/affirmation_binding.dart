import 'package:get/get.dart';

import 'package:pan_de_vida/pandevida/app/modules/affirmation/controllers/affirmation_index_controller.dart';
import 'package:pan_de_vida/pandevida/app/modules/affirmation/controllers/affirmation_videos_controller.dart';

class AffirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AffirmationVideosController>(
      () => AffirmationVideosController(),
    );
    Get.lazyPut<AffirmationIndexController>(
      () => AffirmationIndexController(),
    );
  }
}
