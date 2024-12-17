import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/congregants/controllers/congregant_affirmation_controller.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

class CongregantAffirmationView
    extends GetView<CongregantAffirmationController> {
  const CongregantAffirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const TextTitleWidget('Asistencia a Libros 21 días'),
          ButtonWidget(
            title: 'Libro 1',
            text: controller.affirmation.fecLibro1,
            icon: Icons.book,
          ),
          ButtonWidget(
            title: 'Libro 2',
            text: controller.affirmation.fecLibro2,
            icon: Icons.book,
          ),
          ButtonWidget(
            title: 'Libro 3',
            text: controller.affirmation.fecLibro3,
            icon: Icons.book,
          ),
          ButtonWidget(
            title: 'Afirmador',
            text: controller.affirmation.afirmador,
            icon: Icons.person,
            isLast: true,
          ),
          const SizedBox(height: 20),
          ButtonWidget(
            title: 'Visita 1',
            text: controller.affirmation.fecRepo1,
            subtitle: controller.affirmation.observaciones1,
            icon: Icons.book,
          ),
          ButtonWidget(
            title: 'Visita 2',
            text: controller.affirmation.fecRepo2,
            subtitle: controller.affirmation.visita2,
            icon: Icons.book,
          ),
          ButtonWidget(
            title: 'Visita 3',
            text: controller.affirmation.fecRepo3,
            subtitle: controller.affirmation.visita3,
            icon: Icons.book,
            isLast: true,
          ),
        ],
      ),
    );
  }
}
