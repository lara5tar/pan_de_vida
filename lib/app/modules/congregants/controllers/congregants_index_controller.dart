import 'package:get/get.dart';

import '../../../data/models/congregant_model.dart';
import '../../../data/services/congregante_service.dart';

class CongregantsIndexController extends GetxController {
  var ovejas = <Congregant>[].obs;
  var nietos = <Congregant>[].obs;

  var isErrored = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCongregants();
  }

  getCongregants() async {
    CongregantService congreganteService = CongregantService();

    var result = await congreganteService.getCongregants();

    if (!result['error']) {
      ovejas.value = result['ovejas'];
      nietos.value = result['nietos'];
    } else {
      Get.snackbar('Error', result['message']);
      isErrored.value = true;
    }
  }
}
