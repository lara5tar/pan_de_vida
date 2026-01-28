import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/custom_dropdown_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/cumbres_controller.dart';

class CumbresView extends GetView<CumbresController> {
  const CumbresView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const TextTitleWidget('Nueva Cumbre'),
                  // const SizedBox(height: 20),
                  const TextSubtitleWidget('1. ACCIÓN'),
                  Obx(
                    () => CustomDropdown(
                      items: [
                        for (var item in controller.listAcciones)
                          DropDownItem(
                            text: item.accion,
                            value: item,
                          ),
                      ],
                      selectedItem: controller.accion,
                      hint: 'Seleccione una acción',
                      onChanged: controller.onSelectAccion,
                    ),
                  ),
                  // const SizedBox(height: 20),
                  const TextSubtitleWidget('2. MARCADOR'),
                  Obx(() {
                    return CustomDropdown(
                      items: [
                        for (var item in controller.listMarcadores)
                          DropDownItem(
                            text: item.movimiento,
                            value: item,
                          ),
                      ],
                      selectedItem: controller.marcador,
                      hint: 'Movimiento',
                      onChanged: controller.onSelectMarcador,
                    );
                  }),
                  // const SizedBox(height: 20),
                  const TextSubtitleWidget('3. COMPROMISO'),
                  Obx(
                    () {
                      return CustomDropdown(
                        items: [
                          for (var item in controller.listCompromisosAccion)
                            DropDownItem(
                              text: item.codcumbre,
                              value: item,
                            ),
                        ],
                        selectedItem: controller.comprmisoAccion,
                        hint: 'Seleccione una acción',
                        onChanged: controller.onSelectCompromiso,
                      );
                    },
                  ),
                  Obx(
                    () => CustomDropdown(
                      items: [
                        for (int i = 0;
                            i < controller.listCompromisosPersona.length;
                            i++)
                          DropDownItem(
                            text:
                                '$i. ${controller.listCompromisosPersona[i].nombre}',
                            value: controller.listCompromisosPersona[i],
                          ),
                      ],
                      selectedItem: controller.compromisoPerosna,
                      hint: 'Seleccione una persona',
                      onChanged: controller.onSelectedPersona,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButtonWidget(
              text: 'Enviar',
              onPressed: () {
                controller.setCumbre();
              },
            ),
          ),
        ],
      ),
    );
  }
}
