import 'package:get/get.dart';

import '../../../../core/utils/barcode_dialog.dart';
import '../../../data/models/congregant_model.dart';
import '../../../data/services/restauracion_service.dart';
import '../../../routes/app_pages.dart';

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
    } else {
      Get.snackbar('Error', result['message']);
    }
  }

  void setRestauracionVisita() async {
    String? barcode = await barcodeDialog();

    if (barcode == null) return;

    var result = await RestauracionService().setRestauracionVisita(barcode);

    if (!result['error']) {
      Get.snackbar('Visita', 'Visita guardada correctamente.');
    } else {
      Get.snackbar('Error', result['message']);
    }
  }

  void toCongreganteDetail(String codCongregante) {
    Get.toNamed('${Routes.RESTAURACION_CONGREGANTES}?id=$codCongregante');
  }
}
