import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/custom_text_field_underline.dart';
import 'package:pan_de_vida/app/widgets/custom_switch_widget.dart';
import 'package:pan_de_vida/app/widgets/elevated_button_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';
import 'package:pan_de_vida/app/widgets/weekday_selector_widget.dart';

import '../../../widgets/custom_scaffold.dart';
import '../controllers/event_form_controller.dart';

class EventFormView extends GetView<EventFormController> {
  const EventFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const TextTitleWidget('CREAR EVENTO'),
            CustomTextFieldUnderline(
              label: 'Titulo',
              hintText: 'Escribe el titulo del evento',
              info: controller.title,
              typefield: TypeField.TEXT,
            ),
            CustomTextFieldUnderline(
              label: 'Descripcion',
              hintText: 'Escribe la descripcion del evento',
              info: controller.description,
              typefield: TypeField.TEXT,
            ),
            CustomTextFieldUnderline(
              label: 'Lugar ',
              hintText: 'Escribe el lugar del evento',
              info: controller.location,
              typefield: TypeField.TEXT,
            ),
            CustomSwitchWidget(
              label: '¿Es un evento recurrente?',
              value: controller.isRecurrent,
            ),
            Obx(
              () => controller.isRecurrent.value
                  ? Column(
                      children: [
                        WeekdaySelector(
                          label: 'Cada semana el...',
                          selectedDays: controller.selectedWeekdays,
                          onDaySelected: controller.toggleWeekday,
                        ),
                        CustomTextFieldUnderline(
                          label: 'Fecha de fin (Opcional)',
                          hintText: 'Ej. 2025-12-31',
                          info: controller.endDateRecurrence,
                          typefield: TypeField.DATE,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        CustomTextFieldUnderline(
                          label: 'Fecha de inicio',
                          hintText: 'Ej. 2025-12-31',
                          info: controller.startDate,
                          typefield: TypeField.DATE,
                        ),
                        CustomTextFieldUnderline(
                          label: 'Fecha de fin (Opcional)',
                          hintText: 'Ej. 2025-12-31',
                          info: controller.endDate,
                          typefield: TypeField.DATE,
                        ),
                      ],
                    ),
            ),
            CustomSwitchWidget(
              label: 'Todo el día',
              value: controller.isAllDay,
            ),
            Obx(
              () => controller.isAllDay.value
                  ? const SizedBox()
                  : Column(
                      children: [
                        CustomTextFieldUnderline(
                          label: 'Hora de inicio',
                          hintText: 'Ej. 12:00',
                          info: controller.startTime,
                          typefield: TypeField.TIME,
                        ),
                        CustomTextFieldUnderline(
                          label: 'Hora de fin',
                          hintText: 'Ej. 13:00',
                          info: controller.endTime,
                          typefield: TypeField.TIME,
                        ),
                      ],
                    ),
            ),
            CustomTextFieldUnderline(
              label: 'URL de la imagen',
              hintText: 'Escribe la URL de la imagen',
              info: controller.urlImage,
              typefield: TypeField.TEXT,
            ),
            const SizedBox(height: 20),
            ElevatedButtonWidget(
              text: 'Guardar evento',
              onPressed: () {
                controller.guardar();
              },
            ),
            const SizedBox(height: 20),
            if (controller.isEditMode.value)
              ElevatedButtonWidget(
                text: 'Desactivar evento',
                onPressed: () {
                  controller.desactivar();
                },
                color: Colors.blueGrey,
              ),
          ],
        ),
      ),
    );
  }
}
