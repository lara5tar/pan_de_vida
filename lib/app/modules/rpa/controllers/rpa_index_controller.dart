import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/cumbre_model.dart';

import '../../../data/services/cumbres_services.dart';

class RpaIndexController extends GetxController {
  var cumbres = <Cumbre>[].obs;
  String? codCongregante = Get.parameters['id'];

  @override
  void onInit() {
    getCumbres();
    super.onInit();
  }

  getCumbres() async {
    var response = await CumbresServices.getCumbres(codCongregante);

    if (!response['error']) {
      cumbres.value = response['cumbres'];
    }
  }
}
