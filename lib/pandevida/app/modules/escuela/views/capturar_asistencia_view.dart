import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/capturar_asistencia_controller.dart';

class CapturarAsistenciaView extends GetView<CapturarAsistenciaController> {
  const CapturarAsistenciaView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const TextTitleWidget('Registro de Asistencia'),
            Container(
              padding: const EdgeInsets.all(20),
              // margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white.withOpacity(0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButtonWidget(
                    text: 'Capturar Asistencia',
                    onPressed: () {
                      controller.setAsistencia();
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButtonWidget(
                    text: 'Capturar Tareas',
                    onPressed: () {
                      controller.setTarea();
                    },
                    color: Colors.blue.shade900,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButtonWidget(
                    text: 'Capturar Asistencia y Tareas',
                    onPressed: () {
                      controller.setAsistenciaTarea();
                    },
                    color: Colors.cyan,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
