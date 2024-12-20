import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/services/escuela_service.dart';

import '../../../../core/utils/barcode_dialog.dart';

class CapturarAsistenciaController extends GetxController {
  resultDialog(result) {
    if (result['error']) {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(result['message']),
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
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('Éxito'),
          content: Text(result['message']),
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

  setAsistencia() async {
    String? barcode = await barcodeDialog();

    if (barcode == null) return;

    var result = await EscuelaService.setAsistencia(barcode);

    resultDialog(result);
  }

  setTarea() async {
    String? barcode = await barcodeDialog();

    if (barcode == null) return;

    var result = await EscuelaService.setTarea(barcode);

    resultDialog(result);
  }

  setAsistenciaTarea() async {
    String? barcode = await barcodeDialog();

    if (barcode == null) return;

    var result = await EscuelaService.setAsistenciaTarea(barcode);

    resultDialog(result);
  }
}
