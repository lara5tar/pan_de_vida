import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/escuela_historial_model.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../../../widgets/button_widget.dart';
import '../controllers/desarrollo_escuela_historial_controller.dart';

class DesarrolloEscuelaHistorialView
    extends GetView<DesarrolloEscuelaHistorialController> {
  const DesarrolloEscuelaHistorialView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : controller.escuelas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.school_outlined,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value.isNotEmpty
                              ? controller.errorMessage.value
                              : 'No hay historial de escuelas',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const TextTitleWidget('Historial de Escuelas'),
                        for (int i = 0;
                            i < controller.escuelas.length;
                            i++) ...[
                          ..._buildEscuelaCard(
                            controller.escuelas[i],
                            isLast: i == controller.escuelas.length - 1,
                          ),
                          if (i < controller.escuelas.length - 1)
                            const SizedBox(height: 10),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
      ),
    );
  }

  List<Widget> _buildEscuelaCard(EscuelaHistorial escuela,
      {bool isLast = false}) {
    return [
      // const TextSubtitleWidget('Escuela'),
      ButtonWidget(
        title: 'Curso',
        text: escuela.curso,
        icon: Icons.school_rounded,
      ),
      ButtonWidget(
        title: 'Clase',
        text: escuela.clase,
        icon: Icons.menu_book_outlined,
      ),
      ButtonWidget(
        title: 'Ciclo',
        text: escuela.ciclo,
        icon: Icons.calendar_today,
      ),
      ButtonWidget(
        title: 'Asistencias',
        text: '${escuela.asistencias} / ${escuela.numClases}',
        subtitle: 'Mínimo requerido: ${escuela.minClases}',
        icon: Icons.check_circle_outline,
        colorText: int.tryParse(escuela.asistencias) != null &&
                int.tryParse(escuela.minClases) != null &&
                int.parse(escuela.asistencias) >= int.parse(escuela.minClases)
            ? Colors.green
            : Colors.red,
      ),
      ButtonWidget(
        title: 'Tareas',
        text: '${escuela.tareas} / ${escuela.numClases}',
        subtitle: 'Mínimo requerido: ${escuela.minTareas}',
        icon: Icons.assignment_outlined,
        colorText: int.tryParse(escuela.tareas) != null &&
                int.tryParse(escuela.minTareas) != null &&
                int.parse(escuela.tareas) >= int.parse(escuela.minTareas)
            ? Colors.green
            : Colors.red,
      ),
      ButtonWidget(
        title: 'Estado',
        text: escuela.estado,
        icon: escuela.aprobado ? Icons.check_circle : Icons.cancel,
        colorIcon: escuela.aprobado ? Colors.green : Colors.red,
        colorText: escuela.aprobado ? Colors.green : Colors.red,
        isLast: true,
      ),
    ];
  }
}
