import 'package:get/get.dart';

import '../../../data/services/appcore_service.dart';

class QuieroAsistirController extends GetxController {
  var nombre = ''.obs;
  var telefono = ''.obs;
  var email = ''.obs;

  enviar() {
    AppcoreService.setUnirseGrupo(nombre.value, email.value, telefono.value)
        .then(
      (value) {
        if (value['error']) {
          Get.snackbar(
            'Error',
            'No se pudo enviar tu solicitud',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        Get.snackbar(
          'Mensaje',
          'Se ha enviado tu solicitud',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
