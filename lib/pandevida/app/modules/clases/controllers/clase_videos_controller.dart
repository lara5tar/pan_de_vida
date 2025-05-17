import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/routes/app_pages.dart';

import '../../../data/models/cuestionario_model.dart';
import '../../../data/services/escuela_service.dart';

class ClaseVideosController extends GetxController {
  CuestionarioModel cuestionario = CuestionarioModel.empty();

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getVideos();
  }

  getVideos() async {
    var result = await EscuelaService.getVideos();

    if (result['error']) {
      Get.snackbar('Error', result['message']);
    } else {
      cuestionario = result['data'];
    }
    isLoading.value = false;
  }

  toCuestionarioVideo(url, codVideo) async {
    final result =
        await Get.toNamed(Routes.CLASE_CUESTIONARIO_VIDEO, arguments: {
      'codVideo': codVideo,
      'url': url,
      'idInscripcion': cuestionario.idInscripcion,
    });

    // Si recibimos un resultado true, significa que debemos recargar la página
    if (result == true) {
      isLoading.value = true;
      await getVideos();
    }
  }

  toCuestionario() {
    if (cuestionario.activo) {
      Get.dialog(
        AlertDialog(
          title: const Text('¡Felicidades!'),
          content: const Text('Ya has contestado el cuestionario'),
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
      return;
    }
    Get.toNamed(
      Routes.CLASE_CUESTIONARIO,
      arguments: {
        'idInscripcion': cuestionario.idInscripcion,
        'codVideo': cuestionario.codVideo,
        'numClase': cuestionario.numClase,
      },
    );
  }
}
