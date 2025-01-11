import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

import '../../../data/models/congregant_model.dart';
import '../../../data/services/congregante_service.dart';

class CongregantsIndexController extends GetxController {
  var ovejas = <Congregant>[].obs;
  var nietos = <Congregant>[].obs;

  var isLoadning = true.obs;

  GroupButtonController groupButtonController = GroupButtonController();

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

      isLoadning.value = false;
    } else {
      Get.snackbar('Error', result['message']);
    }
  }
}
