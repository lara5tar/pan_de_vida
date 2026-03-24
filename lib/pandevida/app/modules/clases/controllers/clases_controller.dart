import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/data/models/school_attendace_model.dart';
import 'package:pan_de_vida/pandevida/app/data/services/escuela_service.dart';
import 'package:pan_de_vida/pandevida/app/data/services/test_ministerio_service.dart';

class ClasesController extends GetxController {
  SchoolAttendace schoolAttendace = SchoolAttendace.empty();
  var isLoading = true.obs;
  var tieneTestsAsignados = false.obs;
  var isLoadingTests = true.obs;
  var estadoTest = 'SIN_ASIGNAR'.obs;

  @override
  void onInit() {
    getAsistecias();
    verificarTestsAsignados();
    super.onInit();
  }

  getAsistecias() async {
    var response = await EscuelaService.getAsistencia();

    if (response['error']) {
      Get.snackbar('Error', response['message']);
    } else {
      schoolAttendace = response['data'];
    }
    isLoading(false);
  }

  /// Verifica si el congregante tiene tests asignados
  Future<void> verificarTestsAsignados() async {
    try {
      isLoadingTests.value = true;

      final response = await TestMinisterioService.verificarAsignacion();

      if (!response['error']) {
        final String estado = response['estado'] ?? 'SIN_ASIGNAR';
        estadoTest.value = estado;
        tieneTestsAsignados.value = response['mostrar_boton'] ?? false;
        print('Estado test ministerio: $estado');
        print('Mostrar botón: ${tieneTestsAsignados.value}');
      } else {
        // Si hay error, no mostrar el botón por seguridad
        tieneTestsAsignados.value = false;
        print('Error al verificar tests: ${response['message']}');
      }
    } catch (e) {
      print('Error en verificarTestsAsignados: $e');
      tieneTestsAsignados.value = false;
    } finally {
      isLoadingTests.value = false;
    }
  }
}
