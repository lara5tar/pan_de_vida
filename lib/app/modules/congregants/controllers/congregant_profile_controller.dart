import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/school_attendace_model.dart';
import 'package:pan_de_vida/app/data/services/congregante_service.dart';

import '../../../data/models/group_attendance_model.dart';
import '../../../data/models/congregant_model.dart';
import '../../../routes/app_pages.dart';

class CongregantProfileController extends GetxController {
  var isLoading = true.obs;

  var congregant = Congregant.empty();
  var groupAttendance = GroupAttendace.empty();

  var schoolAttendance = SchoolAttendace.empty();

  @override
  Future<void> onInit() async {
    super.onInit();
    await getCongregant();
    await getGruopAttandace();
    await getSchoolAttandace();
  }

  getCongregant() async {
    var parameters = Get.parameters;

    if (parameters['id'] != null) {
      var response =
          await CongregantService().getCongregant(parameters['id'].toString());

      if (!response['error']) {
        congregant = response['congregant'];
      }
    }
  }

  getGruopAttandace() async {
    var parameters = Get.parameters;

    if (parameters['id'] != null) {
      var response = await CongregantService()
          .getGroupAttendance(parameters['id'].toString());

      if (!response['error']) {
        groupAttendance = response['attendance'];
      }
    }
    isLoading(false);
  }

  getSchoolAttandace() async {
    var parameters = Get.parameters;

    if (parameters['id'] != null) {
      var response = await CongregantService()
          .getSchoolAttandance(parameters['id'].toString());

      if (!response['error']) {
        schoolAttendance = response['attendance'];
      }
    }
  }

  // getAffirmations() async {
  //   var response = await CongregantService()
  //       .getAffirmation(congregant.value.codCongregant);

  //   // if (!response['error']) {
  //   //   var affirmation = response['affirmations'];
  //   // }
  // }

  toCongregantInfo() {
    Get.toNamed(Routes.CONGREGANT_INFO);
  }

  toCongregantAdress() {
    Get.toNamed(Routes.CONGREGANT_ADRESS);
  }

  toCongregantAffirmations() {
    Get.toNamed(Routes.CONGREGANT_AFFIRMATION);
  }

  toCongrengatAttendance() {
    Get.toNamed(Routes.CONGREGANT_ATTENDANCE);
  }
}
