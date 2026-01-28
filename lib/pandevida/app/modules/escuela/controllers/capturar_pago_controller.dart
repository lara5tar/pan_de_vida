import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/widgets/custom_text_field_underline.dart';
import 'package:pan_de_vida/pandevida/core/utils/barcode_dialog.dart';

import '../../../data/services/escuela_service.dart';

class CapturarPagoController extends GetxController {
  capturar() async {
    String? barcode = await barcodeDialog();

    if (barcode == null) return;

    var montoController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Capturar Pago'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFieldUnderline(
              info: montoController,
              hintText: 'Monto',
              label: 'Monto',
              typefield: TypeField.MONEY,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              EscuelaService.setPago(barcode, montoController.text).then(
                (result) {
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
                        title: const Text('Pago Realizado'),
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
                },
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
