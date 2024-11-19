import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/congregant_model.dart';
import 'package:pan_de_vida/app/routes/app_pages.dart';

import '../../../data/services/cumbres_services.dart';

class TeamController extends GetxController {
  var sinRegistro = <Congregant>[].obs;
  var marcador = <Congregant>[].obs;
  var noMarcador = <Congregant>[].obs;

  @override
  void onInit() {
    getCumbresEquipo();
    super.onInit();
  }

  getCumbresEquipo() async {
    var result = await CumbresServices().getCumbresEquipo();

    if (!result['error']) {
      sinRegistro.value = result['sinRegistro'];
      marcador.value = result['marcador'];
      noMarcador.value = result['noMarcador'];
    }
  }

  toRpaIndex(String codCongregante) {
    Get.toNamed(Routes.RPA_INDEX, parameters: {'id': codCongregante});
  }
}
