import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/congregant_model.dart';
import 'package:pan_de_vida/app/data/services/restauracion_service.dart';

class RestauracionController extends GetxController {
  var congregantes = <Congregant>[].obs;

  @override
  void onInit() {
    super.onInit();

    getCongregantes();
  }

  void getCongregantes() async {
    congregantes.clear();
    var result = await RestauracionService().getCongregantesRestauracion();

    if (!result['error']) {
      congregantes.addAll(result['data']);
      print(congregantes);
    } else {
      Get.snackbar('Error', result['message']);
    }
  }
}
