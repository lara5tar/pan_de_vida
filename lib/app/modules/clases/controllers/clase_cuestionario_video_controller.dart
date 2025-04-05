import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/models/pregunta_model.dart';
import '../../../data/models/video_model.dart';
import '../../../data/services/escuela_service.dart';
import '../../../data/services/youtube_service.dart';

class ClaseCuestionarioVideoController extends GetxController {
  Video video = Video.empty();
  List<Pregunta> preguntas = [];
  var opcionesElegidas = <Respuesta>[].obs;
  String idInscripcion = '';

  late final WebViewController webViewController;

  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();

    getCuestionario();
  }

  void initWebViewController(String url) {
    webViewController = YouTubeService.getWebViewController(
      'https://www.youtube.com/embed/$url',
    );
  }

  Future<void> getCuestionario() async {
    var arguments = Get.arguments;

    var result = await EscuelaService.getVideoInfo(arguments['codVideo']);

    if (result['error']) {
      Get.snackbar('Error', result['message']);
    } else {
      video = result['data'];
      idInscripcion = arguments['idInscripcion'];
      initWebViewController(video.url);

      result = await EscuelaService.getPregunta(video.codvideo);

      if (result['error']) {
        Get.snackbar('Error', result['message']);
      } else {
        preguntas = result['data'];
        opcionesElegidas.value =
            List.generate(preguntas.length, (index) => Respuesta.empty());
        isLoading.value = false;
      }
    }
  }

  onSelectRespuesta(int index, Respuesta respuesta) {
    opcionesElegidas[index] = respuesta;
  }

  evaluarRespuestas() {
    print(Get.arguments);
    int correctas = 0;

    for (var respuesta in opcionesElegidas) {
      if (respuesta.iscorrecta) {
        correctas++;
      }
      print(respuesta.iscorrecta);
    }

    if (correctas == preguntas.length) {
      Get.dialog(
        AlertDialog(
          title: const Text('¡Felicidades!'),
          content: const Text('Todas las respuestas son correctas'),
          actions: [
            TextButton(
              onPressed: () async {
                var result = await EscuelaService.setVideo(
                  video.codvideo,
                  idInscripcion,
                  video.numClase,
                );
                print(result);
                Get.back();
                Get.back(
                    result:
                        true); // Enviamos un resultado para indicar que debe actualizarse
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
