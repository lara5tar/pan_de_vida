import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/pandevida/app/widgets/elevated_button_widget.dart';
import 'package:pan_de_vida/pandevida/app/widgets/loading_widget.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/clases_controller.dart';

class ClasesView extends GetView<ClasesController> {
  const ClasesView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(
          () => controller.isLoading.value
              ? const LoadingWidget()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (controller.schoolAttendace.clase.isNotEmpty) ...[
                        ElevatedButtonWidget(
                          onPressed: () {
                            Get.toNamed(Routes.CLASE_VIDEOS);
                          },
                          text: 'Ver Clase',
                        ),
                        const SizedBox(height: 20),
                      ],
                      const TextTitleWidget('Escuela'),
                      ButtonWidget(
                        title: 'Ciclo',
                        text: controller.schoolAttendace.ciclo,
                        icon: Icons.school_rounded,
                      ),
                      ButtonWidget(
                        title: 'Clase',
                        text: controller.schoolAttendace.clase,
                        icon: Icons.menu_book_outlined,
                        isLast: true,
                      ),
                      const TextSubtitleWidget('Asistencias y Tareas'),
                      if (controller.schoolAttendace.asistencias.isEmpty)
                        const ButtonWidget(
                          text: '',
                          icon: Icons.close,
                          isLast: true,
                        )
                      else ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.white.withOpacity(0.8),
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: Text(
                                  'Clase',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text('Asistencia',
                                    textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child:
                                    Text('Tarea', textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child:
                                    Text('Fecha', textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                        for (var item in controller.schoolAttendace.asistencias)
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.white.withOpacity(0.8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    item.idClase,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Icon(
                                    item.asistencia ? Icons.check : Icons.close,
                                    color: item.asistencia
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                Expanded(
                                  child: Icon(
                                    item.tarea ? Icons.check : Icons.close,
                                    color:
                                        item.tarea ? Colors.green : Colors.red,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.fecha.isEmpty
                                        ? 'Sin fecha'
                                        : item.fecha,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                      if (kDebugMode) ...[
                        const SizedBox(height: 20),
                        ElevatedButtonWidget(
                          onPressed: () {
                            Get.toNamed(Routes.TEST_MINISTERIO);
                          },
                          text: 'Test de Ministerio',
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
