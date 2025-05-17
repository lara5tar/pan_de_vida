import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/widgets/text_subtitle_widget.dart';

import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/restauracion_controller.dart';

class RestauracionView extends GetView<RestauracionController> {
  const RestauracionView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButtonWidget(
              text: 'Capturar Visita',
              onPressed: () async {
                controller.setRestauracionVisita();
              },
            ),
            Obx(
              () => controller.isLoading.value
                  ? const Expanded(child: LoadingWidget())
                  : Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(0),
                        children: [
                          const SizedBox(height: 20),
                          const TextTitleWidget('Mis Ovejas'),
                          if (controller.congregantes.isEmpty)
                            const TextSubtitleWidget('No hay congregantes'),
                          for (var congregant in controller.congregantes)
                            ButtonWidget(
                              text: congregant.nombre,
                              subtitle:
                                  '${congregant.fecAlta} - ${congregant.curso}',
                              icon: Icons.person,
                              isLast:
                                  controller.congregantes.last == congregant,
                              onTap: () {
                                controller.toCongreganteDetail(
                                    congregant.codCongregant);
                              },
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
