import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/services/congregante_service.dart';

import '../../../data/models/congregant_model.dart';

class CongregantProfileController extends GetxController {
  var congregant = Congregant.empty().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getCongregant();
  }

  getCongregant() async {
    var parameters = Get.parameters;

    if (parameters['id'] != null) {
      var response =
          await CongregantService().getCongregant(parameters['id'].toString());

      if (!response['error']) {
        congregant.value = response['congregant'];
      }
    }
  }
}
