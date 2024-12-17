import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/rpa/controllers/new_prospecto_controller.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/custom_text_field.dart';
import 'package:pan_de_vida/app/widgets/elevated_button_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

class NewProspectoView extends GetView<NewProspectoController> {
  const NewProspectoView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const TextTitleWidget('Nuevo prospecto'),
          Container(
            color: Colors.white.withOpacity(0.8),
            padding: const EdgeInsets.symmetric(vertical: 30),
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                const SizedBox(height: 40),
                ElevatedButtonWidget(
                  onPressed: controller.addProspecto,
                  text: 'Enviar',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
