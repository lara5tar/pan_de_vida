import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/escuela/controllers/capturar_pago_controller.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/elevated_button_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

class CapturarPagoView extends GetView<CapturarPagoController> {
  const CapturarPagoView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const TextTitleWidget('Registro de Pagos'),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
    );
  }
}
