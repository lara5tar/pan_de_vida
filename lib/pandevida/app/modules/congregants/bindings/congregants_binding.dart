import 'package:get/get.dart';

import '../controllers/congregant_adress_controller.dart';
import '../controllers/congregant_affirmation_controller.dart';
import '../controllers/congregant_attandance_controller.dart';
import '../controllers/congregant_info_controller.dart';
import '../controllers/congregant_profile_controller.dart';
import '../controllers/congregants_index_controller.dart';

class CongregantsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CongregantsIndexController>(
      () => CongregantsIndexController(),
    );
    Get.lazyPut<CongregantProfileController>(
      () => CongregantProfileController(),
    );
    Get.lazyPut<CongregantInfoController>(
      () => CongregantInfoController(),
    );
    Get.lazyPut<CongregantAttandanceController>(
      () => CongregantAttandanceController(),
    );
    Get.lazyPut<CongregantAffirmationController>(
      () => CongregantAffirmationController(),
    );
    Get.lazyPut<CongregantAdressController>(
      () => CongregantAdressController(),
    );
  }
}
