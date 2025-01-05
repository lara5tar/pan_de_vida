import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/alertas_controller.dart';

class AlertasView extends GetView<AlertasController> {
  const AlertasView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const TextTitleWidget('Alertas'),
                  if (controller.alertas.isEmpty)
                    const TextSubtitleWidget('No hay alertas'),
                  for (var alerta in controller.alertas)
                    ButtonWidget(
                      text: alerta.titulo,
                      subtitle: alerta.detalle,
                      icon: Icons.warning,
                      colorIcon: Colors.red.shade300,
                      isLast: controller.alertas.last == alerta,
                    ),
                  const TextTitleWidget('Alertas de mis 3'),
                  for (var alerta in controller.alertasEquipo)
                    ButtonWidget(
                      title: alerta.nombre,
                      text: alerta.titulo,
                      subtitle: alerta.detalle,
                      icon: Icons.warning,
                      colorIcon: Colors.red.shade300,
                      isLast: controller.alertasEquipo.last == alerta,
                    ),
                  if (controller.alertasEquipo.isEmpty)
                    const TextSubtitleWidget('No hay alertas de mis 3'),
                  const SizedBox(height: 20),
                ],
              ),
      ),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () {
          controller.getAlertas();
        },
        icon: Icons.add,
      ),
    );
  }
}
