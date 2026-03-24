import 'package:get/get.dart';

import '../../../data/models/escuela_historial_model.dart';
import '../../../data/services/congregante_service.dart';

class DesarrolloEscuelaHistorialController extends GetxController {
  var isLoading = true.obs;
  var escuelas = <EscuelaHistorial>[].obs;
  var errorMessage = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    final id = Get.parameters['id'];

    if (id != null) {
      await _loadHistorial(id);
    } else {
      errorMessage.value = 'No se recibió el ID del congregante';
    }

    isLoading.value = false;
  }

  Future<void> _loadHistorial(String id) async {
    try {
      final response = await CongregantService().getEscuelaHistorial(id);

      if (!response['error']) {
        escuelas.value = response['escuelas'] as List<EscuelaHistorial>;
      } else {
        errorMessage.value =
            response['message'] ?? 'Error al cargar el historial';
      }
    } catch (e) {
      errorMessage.value = 'Error inesperado: $e';
    }
  }
}
