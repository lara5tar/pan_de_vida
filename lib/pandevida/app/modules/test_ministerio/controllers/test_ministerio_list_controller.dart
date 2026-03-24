import 'package:get/get.dart';

import '../../../data/models/test_ministerio_model.dart';
import '../../../data/services/test_ministerio_service.dart';
import '../../../routes/app_pages.dart';

class TestMinisterioListController extends GetxController {
  var tests = <TestMinisterio>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTests();
  }

  Future<void> loadTests() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await TestMinisterioService.obtenerTests();

      if (!response['error']) {
        final List<dynamic> testsData = response['tests'] ?? [];
        tests.value = testsData
            .map((t) => TestMinisterio.fromJson(t as Map<String, dynamic>))
            .toList();
        print('Tests cargados: ${tests.length}');
      } else {
        errorMessage.value = response['message'] ?? 'Error al cargar los tests';
        Get.snackbar('Error', errorMessage.value);
        print('Error al cargar tests: ${response['message']}');
      }
    } catch (e) {
      errorMessage.value = 'Error inesperado: $e';
      Get.snackbar('Error', 'No se pudieron cargar los tests');
      print('Error en loadTests: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toTestPreguntas(TestMinisterio test) {
    Get.toNamed(
      Routes.TEST_MINISTERIO_PREGUNTAS,
      arguments: {'idTest': test.id},
    );
  }
}
