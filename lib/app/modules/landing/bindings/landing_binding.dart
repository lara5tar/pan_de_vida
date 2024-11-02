import 'package:get/get.dart';

import '../controllers/landing_controller.dart';
import '../controllers/youtube_carrusel_controller.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingController>(
      () => LandingController(),
    );
    Get.lazyPut<YoutubeCarruselController>(
      () => YoutubeCarruselController(),
    );
  }
}
