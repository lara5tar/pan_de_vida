import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/services/cumbres_services.dart';

class NewProspectoController extends GetxController {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  addProspecto() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Todos los campos son obligatorios',
        backgroundColor: Colors.white,
      );
      return;
    }

    var result = await CumbresServices.setProspecto(
      nameController.text,
      phoneController.text,
    );

    if (result['error']) {
      Get.snackbar('Error', result['message']);
    } else {
      Get.back();
      Get.back();
      Get.snackbar(
        'Éxito',
        'Prospecto guardado',
        backgroundColor: Colors.white,
      );
    }
  }
}
