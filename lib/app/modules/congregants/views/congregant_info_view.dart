import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/button_widget.dart';
import '../controllers/congregant_info_controller.dart';

class CongregantInfoView extends GetView<CongregantInfoController> {
  const CongregantInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextTitleWidget('Datos Generales'),
            ButtonWidget(
              icon: Icons.info,
              title: 'Codigo',
              text: controller.congregant.codCongregant,
            ),
            ButtonWidget(
              icon: Icons.person,
              title: 'Nombre',
              text: controller.congregant.nombreF,
            ),
            ButtonWidget(
              icon: Icons.calendar_month,
              title: 'Fecha de Alta',
              text: controller.congregant.fecAlta,
            ),
            ButtonWidget(
              icon: Icons.wc,
              title: 'Sexo',
              text: controller.congregant.sexoF,
            ),
            ButtonWidget(
              icon: Icons.favorite,
              title: 'Estado Civil',
              text: controller.congregant.edoCivF,
            ),
            ButtonWidget(
              icon: Icons.phone,
              title: 'Telefono Casa',
              text: controller.congregant.telCasa,
            ),
            ButtonWidget(
              icon: Icons.smartphone,
              title: 'Telefono Celular',
              text: controller.congregant.cel,
            ),
            ButtonWidget(
              icon: Icons.email,
              title: 'Correo Electronico',
              text: controller.congregant.mail,
            ),
            ButtonWidget(
              icon: Icons.watch_later,
              title: 'Horario',
              text: controller.congregant.horario,
              isLast: true,
            ),
            const TextTitleWidget('Datos Congregacionales'),
            ButtonWidget(
              icon: Icons.volunteer_activism,
              title: 'Necesidad',
              text: controller.congregant.necesidad,
            ),
            ButtonWidget(
              icon: Icons.public,
              title: 'Vía',
              text: controller.congregant.viaF,
            ),
            ButtonWidget(
              icon: Icons.church_rounded,
              title: 'Otra Iglesia',
              text: controller.congregant.otraIglF,
            ),
            ButtonWidget(
              icon: Icons.search,
              title: 'Observaciones',
              text: controller.congregant.observaciones,
            ),
            ButtonWidget(
              icon: Icons.check,
              title: 'Plataforma que Invita',
              text: controller.congregant.plataforma,
            ),
            ButtonWidget(
              icon: Icons.check_circle,
              title: 'Plataforma Asignada',
              text: controller.congregant.platAsignada,
              isLast: true,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class TextTitleWidget extends StatelessWidget {
  final String title;
  const TextTitleWidget(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Container(
        color: Colors.white.withOpacity(0.8),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
