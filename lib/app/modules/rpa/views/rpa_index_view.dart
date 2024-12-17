import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/loading_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

import '../controllers/rpa_index_controller.dart';

class RpaIndexView extends GetView<RpaIndexController> {
  const RpaIndexView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.cumbres.isEmpty
            ? const LoadingWidget()
            : ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const SizedBox(height: 20),
                  const TextTitleWidget('Mis Cumbres'),
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
