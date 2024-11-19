import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/prospecto_model.dart';
import 'package:pan_de_vida/app/data/services/cumbres_services.dart';

import '../../../routes/app_pages.dart';

class ProspectosController extends GetxController {
  var prospectos = <Prospecto>[].obs;

  @override
  void onInit() {
    getProspectos();
    super.onInit();
  }

  toProspectoVideos(Prospecto prospecto) {
    Get.toNamed(Routes.PROSPECTO_VIDEOS, arguments: prospecto);
  }

  getProspectos() async {
    var result = await CumbresServices().getProspectoDetail();

    if (!result['error']) {
      prospectos.value = result['prospectos'];
    }
  }

  deleteProspecto(String idProspecto) {
    Get.dialog(
      AlertDialog(
        title: const Text('Eliminar prospecto'),
        content: const Text('¿Estás seguro de eliminar este prospecto?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              var result = await CumbresServices().deleteProspecto(idProspecto);

              if (!result['error']) {
                Get.back();
                Get.snackbar('Éxito', 'Prospecto eliminado');
                getProspectos();
              } else {
                Get.back();
                Get.snackbar('Error', result['message']);
              }
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
