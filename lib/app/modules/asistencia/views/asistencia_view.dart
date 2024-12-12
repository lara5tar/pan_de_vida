import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/elevated_button_widget.dart';

import '../../../../core/utils/print_debug.dart';
import '../../../widgets/custom_text_field_underline.dart';
import '../controllers/asistencia_controller.dart';

class AsistenciaView extends GetView<AsistenciaController> {
  const AsistenciaView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // appBar: AppBar(
      //   title: const Text('AsistenciaView'),
      //   centerTitle: true,
      // ),

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
              hintText: '03:00pm',
              info: controller.horaInicio,
              typefield: TypeField.TIME,
            ),
            CustomTextFieldUnderline(
              label: 'Hra fin',
              hintText: '04:00pm',
              info: controller.horaFin,
              typefield: TypeField.TIME,
            ),
            CustomTextFieldUnderline(
              label: 'Ofrenda',
              hintText: '0.00',
              info: controller.ofrenda,
              typefield: TypeField.MONEY,
            ),
            const SizedBox(height: 20),
            ElevatedButtonWidget(
              text: 'Guardar',
              onPressed: () {
                printD(controller.fecha.value);
                printD(controller.tema.value);
                printD(controller.predicador.value);
                printD(controller.horaInicio.value);
                printD(controller.horaFin.value);
                printD(controller.ofrenda.value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
