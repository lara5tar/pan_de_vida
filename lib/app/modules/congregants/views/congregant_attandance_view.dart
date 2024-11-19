import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/congregants/controllers/congregant_attandance_controller.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/text_subtitle_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

class CongregantAttandanceView extends GetView<CongregantAttandanceController> {
  const CongregantAttandanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const TextTitleWidget('Grupos de Vida'),
            ButtonWidget(
              title: 'Red',
              text: controller.groupAttendance.red,
              icon: Icons.public,
            ),
            ButtonWidget(
              title: 'Sub-Red',
              text: controller.groupAttendance.subRed,
              icon: Icons.device_hub_rounded,
            ),
            ButtonWidget(
              title: 'Grupo de Vida',
              text: controller.groupAttendance.gpoVida,
              icon: Icons.eco,
              isLast: true,
            ),
            // SizedBox(height: 20),
            const TextSubtitleWidget('Asistencias'),
            if (controller.groupAttendance.asistencias.isEmpty)
              const ButtonWidget(
                text: 'Sin asistencias',
                icon: Icons.close,
                isLast: true,
              ),
            for (var item in controller.groupAttendance.asistencias)
              ButtonWidget(
                text: item.fecha,
                icon: item.asistencia ? Icons.check : Icons.close,
                colorIcon: item.asistencia ? Colors.green : Colors.red,
                colorText: item.asistencia ? Colors.green : Colors.red,
                isLast: controller.groupAttendance.asistencias.last == item,
              ),
            const SizedBox(height: 20),
            const TextTitleWidget('Escuela'),
            ButtonWidget(
              title: 'Ciclo',
              text: controller.schoolAttendance.ciclo,
              icon: Icons.school_rounded,
            ),
            ButtonWidget(
              title: 'Clase',
              text: controller.schoolAttendance.clase,
              icon: Icons.menu_book_outlined,
              isLast: true,
            ),
            const TextSubtitleWidget('Asistencias'),
            if (controller.schoolAttendance.asistencias.isEmpty)
              const ButtonWidget(
                text: 'Sin asistencias',
                icon: Icons.close,
                isLast: true,
              ),
            for (var item in controller.schoolAttendance.asistencias)
              ButtonWidget(
                text: item.fecha,
                icon: item.asistencia ? Icons.check : Icons.close,
                colorIcon: item.asistencia ? Colors.green : Colors.red,
                colorText: item.asistencia ? Colors.green : Colors.red,
                isLast: controller.schoolAttendance.asistencias.last == item,
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
