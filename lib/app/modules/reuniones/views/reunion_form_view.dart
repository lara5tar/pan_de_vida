import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/custom_text_field_underline.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../controllers/reunion_form_controller.dart';

class ReunionFormView extends GetView<ReunionFormController> {
  const ReunionFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          children: [
            CustomTextFieldUnderline(
              label: 'Fecha',
              hintText: 'Seleccionar Fecha',
              info: controller.fecha,
              typefield: TypeField.DATE,
            ),
            CustomTextFieldUnderline(
              label: 'Tema',
              hintText: 'Escribe el tema',
              info: controller.tema,
              typefield: TypeField.TEXT,
            ),
            CustomTextFieldUnderline(
              label: 'Predicador',
              hintText: 'Escribe el predicador',
              info: controller.predicador,
              typefield: TypeField.TEXT,
            ),
            CustomTextFieldUnderline(
              label: 'Hra inicio',
              hintText: '3',
              info: controller.horaInicio,
              typefield: TypeField.NUMBER,
            ),
            CustomTextFieldUnderline(
              label: 'Hra fin',
              hintText: '4',
              info: controller.horaFin,
              typefield: TypeField.NUMBER,
            ),
            CustomTextFieldUnderline(
              label: 'Ofrenda',
              hintText: '0.00',
              info: controller.ofrenda,
              typefield: TypeField.MONEY,
            ),
            CustomTextFieldUnderline(
              label: 'Total congregantes',
              hintText: '0',
              info: controller.totalCongregantes,
              typefield: TypeField.NUMBER,
            ),
            const SizedBox(height: 20),
            ElevatedButtonWidget(
              text: 'Guardar',
              onPressed: () {
                controller.guardar();
              },
            ),
          ],
        ),
      ),
    );
  }
}
