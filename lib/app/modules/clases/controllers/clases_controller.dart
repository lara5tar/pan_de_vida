import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/school_attendace_model.dart';
import 'package:pan_de_vida/app/data/services/escuela_service.dart';

class ClasesController extends GetxController {
  SchoolAttendace schoolAttendace = SchoolAttendace.empty();
  var isLoading = true.obs;

  @override
  void onInit() {
    getAsistecias();
    super.onInit();
  }

  getAsistecias() async {
    var response = await EscuelaService.getAsistencia();

    if (response['error']) {
      Get.snackbar('Error', response['message']);
    } else {
      schoolAttendace = response['data'];
    }
    isLoading(false);
  }
}
