import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/pregunta_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/test_ministerio_preguntas_controller.dart';

class TestMinisterioPreguntasView
    extends GetView<TestMinisterioPreguntasController> {
  const TestMinisterioPreguntasView({super.key});

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
                    TextTitleWidget(controller.test.titulo),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            for (var i = 0;
                                i < controller.test.preguntas.length;
                                i++)
                              PreguntaWidget(
                                pregunta:
                                    '${i + 1}. ${controller.test.preguntas[i].pregunta}',
                                respuestas: [
                                  for (var opcion in controller
                                      .test.preguntas[i].opciones)
                                    OpcionItem(
                                      text: opcion.texto,
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
                      text: 'Finalizar Test',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
