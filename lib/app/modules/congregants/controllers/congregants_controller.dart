import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/congregant_model.dart';
import 'package:pan_de_vida/app/data/services/congregante_service.dart';

class CongregantsController extends GetxController {
  var ovejas = <Congregant>[].obs;
  var nietos = <Congregant>[].obs;

  var isErrored = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCongregants();
  }

  getCongregants() async {
    CongreganteService congreganteService = CongreganteService();

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
