import 'package:get/get.dart';

import '../../../data/models/test_ministerio_model.dart';

class TestMinisterioPreguntasController extends GetxController {
  late TestMinisterio test;
  var opcionesElegidas = <OpcionMinisterio?>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTest();
  }

  void loadTest() {
    try {
      final arguments = Get.arguments;
      test = arguments['test'] as TestMinisterio;

      // Inicializar las opciones elegidas con null
      opcionesElegidas.value =
          List<OpcionMinisterio?>.filled(test.preguntas.length, null);

      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar el test');
      print('Error en loadTest: $e');
      Get.back();
    }
  }

  void onSelectRespuesta(int index, OpcionMinisterio opcion) {
    opcionesElegidas[index] = opcion;
  }

  void evaluarRespuestas() {
    // Verificar que todas las preguntas tengan respuesta
    final todasRespondidas = opcionesElegidas.every((opcion) => opcion != null);

    if (!todasRespondidas) {
      Get.snackbar(
        'Advertencia',
        'Por favor responde todas las preguntas',
      );
      return;
    }

    // Por ahora solo mostramos un mensaje de completado
    Get.snackbar(
      'Test Completado',
      'Has finalizado el test de ${test.titulo}',
    );

    // Regresar a la vista anterior
    Get.back();
  }
}
