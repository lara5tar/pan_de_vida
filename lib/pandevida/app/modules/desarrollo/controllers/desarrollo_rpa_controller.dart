import 'package:get/get.dart';

import '../../../data/models/cumbre_ciclo_model.dart';
import '../../../data/services/cumbres_services.dart';

/// Controlador para la vista de RPAs del ciclo actual de un discípulo.
class DesarrolloRpaController extends GetxController {
  var cumbresPorAnio = <CumbreAnio>[].obs;
  var isLoading = true.obs;

  /// Código del congregante pasado como parámetro de ruta
  String? codCongregante = Get.parameters['id'];

  @override
  void onInit() {
    super.onInit();
    getCumbres();
  }

  getCumbres() async {
    if (codCongregante == null || codCongregante!.isEmpty) {
      isLoading.value = false;
      return;
    }

    var response =
        await CumbresServices.getCumbresRpaCongregante(codCongregante!);

    if (!response['error']) {
      cumbresPorAnio.value = response['cumbres_por_anio'] ?? [];
    }

    isLoading.value = false;
  }
}
