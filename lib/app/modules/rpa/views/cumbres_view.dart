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
          Obx(
            () => CustomDropdown(
              items: [
                for (int i = 0; i < controller.listAcciones.length; i++)
                  '$i. ${controller.listAcciones[i]['ACCION']}',
              ],
              selectedItem: controller.accion,
              hint: 'Seleccione una acción',
            ),
          ),
          const SizedBox(height: 20),
          const TextSubtitleWidget('2. MARCADOR'),
          Obx(() {
            if (controller.accion.value.isNotEmpty) {
              controller.getCumbreMarcadores(
                  controller.accion.value.split('.').first);
            }
            return CustomDropdown(
              items: [
                for (int i = 0; i < controller.listMarcadores.length; i++)
                  '${i + 1}. ${controller.listMarcadores[i]['MARCADOR']}',
              ],
              selectedItem: controller.marcador,
              hint: 'Movimiento',
            );
          }),
          const SizedBox(height: 20),
          const TextSubtitleWidget('3. COMPROMISO'),
          Obx(
            () {
              if (controller.comprmisoAccion.value.isNotEmpty) {
                controller.getCumbreComprosimoPersona(
                    controller.comprmisoAccion.value.split('.').first);
              }
              return CustomDropdown(
                items: [
                  for (int i = 0;
                      i < controller.listCompromisosAccion.length;
                      i++)
                    '$i. ${controller.listCompromisosAccion[i]['CODCUMBRE']}',
                ],
                selectedItem: controller.comprmisoAccion,
                hint: 'Seleccione una acción',
              );
            },
          ),
          CustomDropdown(
            items: [
              for (int i = 0; i < controller.listCompromisosPersona.length; i++)
                '$i. ${controller.listCompromisosPersona[i]['NOMBRE']}',
            ],
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
