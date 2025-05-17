import 'package:get/get.dart';

import '../../../data/models/congregant_model.dart';
import 'congregant_profile_controller.dart';

class CongregantAdressController extends GetxController {
  late Congregant congregant;

  @override
  void onInit() {
    congregant = Get.find<CongregantProfileController>().congregant;

    super.onInit();
  }
}
