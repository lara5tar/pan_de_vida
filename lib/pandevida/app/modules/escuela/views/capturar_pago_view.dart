import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/capturar_pago_controller.dart';

class CapturarPagoView extends GetView<CapturarPagoController> {
  const CapturarPagoView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const TextTitleWidget('Registro de Pagos'),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white.withOpacity(0.8),
              child: ElevatedButtonWidget(
                text: 'Capturar Pago',
                onPressed: () {
                  controller.capturar();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
