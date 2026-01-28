import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/new_prospecto_controller.dart';

class NewProspectoView extends GetView<NewProspectoController> {
  const NewProspectoView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const TextTitleWidget('Nuevo prospecto'),
            Container(
              color: Colors.white.withOpacity(0.8),
              padding: const EdgeInsets.all(30),
              // margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomTextField(
                    'Nombre de la persona',
                    controller: controller.nameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    'Teléfono',
                    controller: controller.phoneController,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButtonWidget(
                    onPressed: controller.addProspecto,
                    text: 'Enviar',
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
