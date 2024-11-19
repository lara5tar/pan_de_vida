import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/custom_dropdown_widget.dart';
import 'package:pan_de_vida/app/widgets/elevated_button_widget.dart';
import 'package:pan_de_vida/app/widgets/text_subtitle_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

import '../../../widgets/custom_scaffold.dart';
import '../controllers/cumbres_controller.dart';

class CumbresView extends GetView<CumbresController> {
  const CumbresView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 0,
        ),
        children: [
          const SizedBox(height: 20),
          const TextTitleWidget('Nueva Cumbre'),
          const SizedBox(height: 20),
          const TextSubtitleWidget('1. ACCIÓN'),
          CustomDropdown(
            items: const [],
            selectedItem: controller.accion,
            hint: 'Seleccione una acción',
          ),
          const SizedBox(height: 20),
          const TextSubtitleWidget('2. MARCADOR'),
          CustomDropdown(
            items: const [],
            selectedItem: controller.marcador,
            hint: 'Movimiento',
          ),
          const SizedBox(height: 20),
          const TextSubtitleWidget('3. COMPROMISO'),
          CustomDropdown(
            items: const [],
            selectedItem: controller.comprmisoAccion,
            hint: 'Seleccione una acción',
          ),
          CustomDropdown(
            items: const [],
            selectedItem: controller.compromisoPerosna,
            hint: 'Seleccione una persona',
          ),
          const SizedBox(height: 20),
          ElevatedButtonWidget(
            text: 'Enviar',
            onPressed: () {
              // controller.saveCumbre();
            },
          ),
        ],
      ),
    );
  }
}
