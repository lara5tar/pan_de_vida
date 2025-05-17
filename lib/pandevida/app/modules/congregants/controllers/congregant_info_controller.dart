import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/data/models/congregant_model.dart';
import 'package:pan_de_vida/pandevida/app/modules/congregants/controllers/congregant_profile_controller.dart';

class CongregantInfoController extends GetxController {
  late Congregant congregant;

  @override
  void onInit() {
    congregant = Get.find<CongregantProfileController>().congregant;

    super.onInit();
  }
}
