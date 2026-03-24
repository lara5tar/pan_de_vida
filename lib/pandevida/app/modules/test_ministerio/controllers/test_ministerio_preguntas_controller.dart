import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/test_ministerio_model.dart';
import '../../../data/services/test_ministerio_service.dart';
import 'test_ministerio_list_controller.dart';

class TestMinisterioPreguntasController extends GetxController {
  TestMinisterio? test;
  var opcionesElegidas = <OpcionMinisterio?>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadTest());
  }

  Future<void> loadTest() async {
    try {
      isLoading.value = true;
      final arguments = Get.arguments;

      // Obtener el id del test pasado como argumento
      final String idTest =
          (arguments['idTest'] ?? arguments['test']?.id ?? '').toString();

      if (idTest.isEmpty) {
        Get.snackbar('Error', 'No se especificó el test');
        Get.back();
        return;
      }

      // Cargar el test completo con preguntas desde la API
      final response = await TestMinisterioService.obtenerTest(idTest);

      if (!response['error']) {
        final bool completado = response['completado'] == true;

        if (completado) {
          Get.back();
          Get.snackbar(
            'Test ya completado',
            'Ya realizaste este test anteriormente',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey.shade700,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          return;
        }

        test = TestMinisterio.fromJson(
            response['test'] as Map<String, dynamic>);

        // Inicializar las respuestas con null
        opcionesElegidas.value =
            List<OpcionMinisterio?>.filled(test!.preguntas.length, null);
      } else {
        Get.snackbar(
            'Error', response['message'] ?? 'No se pudo cargar el test');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar el test');
      print('Error en loadTest: $e');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  void onSelectRespuesta(int index, OpcionMinisterio opcion) {
    opcionesElegidas[index] = opcion;
  }

  void seleccionarAleatoriamente() {
    if (test == null) return;
    final random = Random();
    for (var i = 0; i < test!.preguntas.length; i++) {
      final opciones = test!.preguntas[i].opciones;
      opcionesElegidas[i] = opciones[random.nextInt(opciones.length)];
    }
  }

  Future<void> evaluarRespuestas() async {
    if (test == null) {
      Get.snackbar('Error', 'El test no está cargado, intenta de nuevo');
      return;
    }

    final todasRespondidas = opcionesElegidas.every((opcion) => opcion != null);

    if (!todasRespondidas) {
      Get.snackbar('Advertencia', 'Por favor responde todas las preguntas');
      return;
    }

    isLoading.value = true;

    // Construir el listado de respuestas con el formato que espera la API
    final List<Map<String, dynamic>> respuestas = [];
    for (var i = 0; i < test!.preguntas.length; i++) {
      respuestas.add({
        'idPregunta':
            int.tryParse(test!.preguntas[i].id) ?? test!.preguntas[i].id,
        'idOpcion':
            int.tryParse(opcionesElegidas[i]!.id) ?? opcionesElegidas[i]!.id,
      });
    }

    final response = await TestMinisterioService.guardarRespuestas(
      idTest: test!.id,
      respuestas: respuestas,
    );

    isLoading.value = false;

    if (!response['error']) {
      print('✅ Test enviado correctamente: ${response['mensaje']}');
      // Recargar la lista de tests antes de volver para que se vea el completado
      final listController = Get.find<TestMinisterioListController>();
      await listController.loadTests();
      Get.back();
    } else {
      print('❌ Error al enviar: ${response['message']}');
      Get.snackbar('Error',
          response['message'] ?? 'No se pudieron guardar las respuestas');
    }
  }
}
