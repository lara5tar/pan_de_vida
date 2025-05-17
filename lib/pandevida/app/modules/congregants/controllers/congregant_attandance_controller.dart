import 'package:get/get.dart';

import '../../../data/models/group_attendance_model.dart';
import '../../../data/models/school_attendace_model.dart';
import 'congregant_profile_controller.dart';

class CongregantAttandanceController extends GetxController {
  late GroupAttendace groupAttendance;
  late SchoolAttendace schoolAttendance;

  @override
  void onInit() {
    groupAttendance = Get.find<CongregantProfileController>().groupAttendance;
    schoolAttendance = Get.find<CongregantProfileController>().schoolAttendance;

    super.onInit();
  }
}
