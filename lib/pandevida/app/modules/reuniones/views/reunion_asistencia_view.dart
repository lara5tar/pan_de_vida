import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/pandevida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/pandevida/app/widgets/loading_widget.dart';

import '../../../widgets/elevated_button_widget.dart';
import '../controllers/reunion_asistencia_controller.dart';

class ReunionAsistenciaView extends GetView<ReunionAsistenciaController> {
  const ReunionAsistenciaView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(0),
                        children: [
                          for (var congregante in controller.congregantes)
                            ButtonWidget(
                              icon: congregante['isChecked'] == 'true'
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              text: congregante['NOMBRE'],
                              isLast:
                                  controller.congregantes.last == congregante,
                              onTap: () {
                                controller.checkCongregante(congregante);
                              },
                            ),
                        ],
                      ),
                    ),
                    ElevatedButtonWidget(
                      text: 'Guardar',
                      onPressed: () {
                        controller.saveAsistencia();
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
