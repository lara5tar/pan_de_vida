import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/affirmation_model.dart';
import '../../../data/models/group_attendance_model.dart';
import '../../../data/models/congregant_model.dart';
import '../../../data/models/school_attendace_model.dart';
import '../../../data/services/congregante_service.dart';
import '../../../routes/app_pages.dart';

class CongregantProfileController extends GetxController {
  var isLoading = true.obs;

  var congregant = Congregant.empty();
  var groupAttendance = GroupAttendace.empty();
  var schoolAttendance = SchoolAttendace.empty();
  var affirmation = Affirmation.empty();

  @override
  Future<void> onInit() async {
    super.onInit();
    await getCongregant();
    await getGruopAttandace();
    await getSchoolAttandace();
    await getAffirmations();
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
    isLoading(false);
  }

  getAffirmations() async {
    var response =
        await CongregantService().getAffirmation(congregant.codCongregant);

    if (!response['error'] && response['data'] != null) {
      affirmation = response['data'];
    }
  }

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

  toWhatsApp() async {
    String url =
        "https://wa.me/${congregant.cel}?text=${Uri.encodeComponent('Hola, ${congregant.nombre}')}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {}
  }

  toCall() async {
    await FlutterPhoneDirectCaller.callNumber(congregant.cel);
  }
}
