import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/desarrollo_rpa_controller.dart';

class DesarrolloRpaView extends GetView<DesarrolloRpaController> {
  const DesarrolloRpaView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const TextTitleWidget('RPAS'),
                  if (controller.cumbresPorAnio.isEmpty)
                    const TextSubtitleWidget('No hay RPAs registradas')
                  else
                    for (var rpaAnio in controller.cumbresPorAnio) ...[
                      // ── Encabezado de año ──────────────────────────────
                      TextSubtitleWidget(rpaAnio.anio),
                      // const Divider(height: 1),
                      // ── Movimientos del año ────────────────────────────
                      for (var cumbre in rpaAnio.movimientos)
                        ButtonWidget(
                          text: cumbre.nomAccPass,
                          subtitle: cumbre.nomAccSig,
                          trailing: '${cumbre.dia} ${cumbre.mes}',
                          icon: cumbre.iconoC,
                          colorIcon: cumbre.colorC,
                          colorText: cumbre.colorC,
                          isLast: cumbre == rpaAnio.movimientos.last,
                        ),
                    ],
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
