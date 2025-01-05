import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/pregunta_widget.dart';
import '../controllers/clase_cuestionario_controller.dart';

class ClaseCuestionarioView extends GetView<ClaseCuestionarioController> {
  const ClaseCuestionarioView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var i = 0;
                                i < controller.preguntas.length;
                                i++)
                              PreguntaWidget(
                                pregunta:
                                    '${i + 1}. ${controller.preguntas[i].pregunta}',
                                respuestas: [
                                  for (var opcion
                                      in controller.preguntas[i].respuestas)
                                    OpcionItem(
                                      text: opcion.respuesta,
                                      value: opcion,
                                    ),
                                ],
                                onChanged: (value) =>
                                    controller.onSelectRespuesta(i, value),
                              ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButtonWidget(
                      onPressed: controller.evaluarRespuestas,
                      text: 'Evaluar Respuestas',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
