import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/services/reuniones_service.dart';

class ReunionAsistenciaController extends GetxController {
  var arguments = Get.arguments;

  var congregantes = [].obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getCongregantes();
  }

  Future<void> getCongregantes() async {
    isLoading.value = true;

    final value = !arguments['isUpdate']
        ? await ReunionesService().getCongregantesCasaVida()
        : await ReunionesService()
            .getReunionCongregantes(arguments['idReunion']);

    if (!value['error']) {
      congregantes.value = value['congregantes'];
    } else {
      Get.snackbar(
        'Error',
        'No se pudo obtener los congregantes',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isLoading.value = false;
  }

  checkCongregante(congregante) {
    congregante['isChecked'] =
        congregante['isChecked'] == 'true' ? 'false' : 'true';
    congregantes.refresh();
  }

  saveAsistencia() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
    var result = {};
    if (arguments['isUpdate']) {
      result = await ReunionesService()
          .updateCongregantes(arguments['idReunion'], congregantes.toList());
    } else {
      result = await ReunionesService()
          .setCongregantes(arguments['idReunion'], congregantes.toList());
    }
    Get.back();

    if (!result['error']) {
      Get.back();
      Get.back();
    } else {
      Get.snackbar(
        'Error',
        'No se pudo guardar la asistencia',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
