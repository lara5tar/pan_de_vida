import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/custom_dropdown_widget.dart';

import '../../../widgets/custom_scaffold.dart';
import '../controllers/cumbres_controller.dart';

class CumbresView extends GetView<CumbresController> {
  const CumbresView({super.key});
  @override
  Widget build(BuildContext context) {
    //crea un find del controlador
    final controller = Get.find<CumbresController>();
    Get.toNamed('/cumbres');

    return CustomScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 0,
        ),
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text('1. ACCIÓN'),
          CustomDropdown(
            items: List.generate(1000, (i) {
              return '1.$i. Acción $i';
            }),
            selectedItem: controller.accion,
            hint: 'Seleccione una acción',
          ),
          CustomDropdown(
            items: const [
              '2.1. Marcador 1',
              '2.2. Marcador 2',
              '2.3. Marcador 3',
            ],
            selectedItem: controller.marcador,
            hint: 'Movimiento',
          ),
          CustomDropdown(
            items: const [
              '3.1. Compromiso 1',
              '3.2. Compromiso 2',
              '3.3. Compromiso 3',
            ],
            selectedItem: controller.comprmisoAccion,
            hint: 'Seleccione una acción',
          ),
          CustomDropdown(
            items: const [
              '4.1. Responsable 1',
              '4.2. Responsable 2',
              '4.3. Responsable 3',
            ],
            selectedItem: controller.compromisoPerosna,
            hint: 'Seleccione una persona',
          ),
        ],
      ),
    );
  }
}
