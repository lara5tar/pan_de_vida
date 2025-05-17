import 'package:get/get.dart';

import '../../../data/models/affirmation_model.dart';
import 'congregant_profile_controller.dart';

class CongregantAffirmationController extends GetxController {
  late Affirmation affirmation;

  @override
  void onInit() {
    affirmation = Get.find<CongregantProfileController>().affirmation;
    super.onInit();
  }
}
