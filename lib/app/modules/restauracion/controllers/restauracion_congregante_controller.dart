import 'package:get/get.dart';

import '../../../data/models/school_attendace_model.dart';
import '../../../data/services/congregante_service.dart';

class RestauracionCongreganteController extends GetxController {
  var isLoading = true.obs;
  var schoolAttendance = SchoolAttendace.empty().obs;

  @override
  void onInit() {
    super.onInit();
    getSchoolAttandace();
  }

  getSchoolAttandace() async {
    if (Get.parameters['id'] != null) {
      var response = await CongregantService()
          .getSchoolAttandance(Get.parameters['id'].toString());

      if (!response['error']) {
        schoolAttendance.value = response['attendance'];
      }
    }
    isLoading(false);
  }
}
