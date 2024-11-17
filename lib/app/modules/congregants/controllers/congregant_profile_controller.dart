import 'package:get/get.dart';

import '../../../data/models/congregant_model.dart';

class CongregantProfileController extends GetxController {
  late Congregant congregant;

  @override
  void onInit() {
    getCongregant();
    super.onInit();
  }

  getCongregant() {
    var parameters = Get.parameters;

    if (parameters['congregant'] != null) {
      congregant =
          Congregant.fromJsonString(parameters['congregant'].toString());
    } else {
      congregant = Congregant(
        id: 'N/A',
        name: 'N/A',
        email: 'N/A',
        mentor: 'N/A',
        registrationDate: 'N/A',
      );
    }
  }
}
