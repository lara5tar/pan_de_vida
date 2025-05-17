import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/rpa_index_controller.dart';

class RpaIndexView extends GetView<RpaIndexController> {
  const RpaIndexView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoadning.value
            ? const LoadingWidget()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const TextTitleWidget('Mis Cumbres'),
                  if (controller.cumbres.isEmpty)
                    const TextSubtitleWidget('No hay cumbres'),
                  for (var cumbre in controller.cumbres)
                    ButtonWidget(
                      text: cumbre.accion,
                      subtitle: cumbre.movimiento,
                      trailing: '${cumbre.dia} ${cumbre.mes}',
                      icon: cumbre.iconoC,
                      colorIcon: cumbre.colorC,
                      colorText: cumbre.colorC,
                      isLast: controller.cumbres.last == cumbre,
                    ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
