import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/pregunta_model.dart';
import '../../../data/services/escuela_service.dart';

class ClaseCuestionarioController extends GetxController {
  List<Pregunta> preguntas = [];
  var opcionesElegidas = <Respuesta>[].obs;

  var arguments = Get.arguments;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    getCuestionario();
  }

  Future<void> getCuestionario() async {
    print(arguments);
    var result = await EscuelaService.getPregunta(
      arguments['codVideo'],
      cuestionario: 1,
    );

    if (result['error']) {
      Get.snackbar('Error', result['message']);
    } else {
      preguntas = result['data'];
      opcionesElegidas.value =
          List.generate(preguntas.length, (index) => Respuesta.empty());
    }
    isLoading.value = false;
  }

  onSelectRespuesta(int index, Respuesta respuesta) {
    opcionesElegidas[index] = respuesta;
  }

  evaluarRespuestas() {
    int correctas = 0;

    for (var respuesta in opcionesElegidas) {
      if (respuesta.iscorrecta) {
        correctas++;
      }
    }

    if (correctas == preguntas.length) {
      Get.dialog(
        AlertDialog(
          title: const Text('¡Felicidades!'),
          content: const Text('Todas las respuestas son correctas'),
          actions: [
            TextButton(
              onPressed: () {
                EscuelaService.setCuestionarioTarea(
                  arguments['idInscripcion'],
                  arguments['numClase'],
                  arguments['codVideo'],
                );
                Get.back();
                Get.back();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('¡Lo siento!'),
          content: const Text('Algunas respuestas son incorrectas'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }
}
