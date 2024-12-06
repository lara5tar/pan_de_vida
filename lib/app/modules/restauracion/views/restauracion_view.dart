import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/loading_widget.dart';

import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/restauracion_controller.dart';

class RestauracionView extends GetView<RestauracionController> {
  const RestauracionView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButtonWidget(
            text: 'Capturar Visita',
            onPressed: () {},
          ),
          Obx(
            () => controller.congregantes.isEmpty
                ? const Expanded(child: LoadingWidget())
                : Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        const SizedBox(height: 20),
                        const TextTitleWidget('Mis Ovejas'),
                        for (var congregant in controller.congregantes)
                          ButtonWidget(
                            text: congregant.nombre,
                            subtitle:
                                '${congregant.fecAlta} - ${congregant.curso}',
                            icon: Icons.person,
                            isLast: controller.congregantes.last == congregant,
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
