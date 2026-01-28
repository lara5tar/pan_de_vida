import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_title_widget.dart';
import '../../../../../widgets/text_subtitle_widget.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/elevated_button_widget.dart';
import '../../../../../widgets/custom_text_field_underline.dart';
import '../../../../../widgets/custom_dropdown_widget.dart';
import '../controllers/abonos_controller.dart';
import '../widgets/apartado_info_widget.dart';

class RegistrarAbonoView extends GetView<AbonosController> {
  const RegistrarAbonoView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(() {
        final apartado = controller.apartadoSeleccionado.value;

        if (apartado == null) {
          return const Center(
            child: TextSubtitleWidget('No se ha seleccionado un apartado'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20
            
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TextTitleWidget('Registrar Abono'),
              const TextSubtitleWidget('Información del apartado'),

              // Información del apartado
              ApartadoInfoWidget(apartado: apartado),

              const TextTitleWidget('Datos del Abono'),

              // Campo de monto usando CustomTextFieldUnderline
              CustomTextFieldUnderline(
                label: 'Monto',
                hintText: 'Máximo: \$${apartado.saldoPendiente.toStringAsFixed(2)}',
                info: controller.montoController,
                typefield: TypeField.MONEY,
              ),


              // Método de pago usando CustomDropdown
              CustomDropdown(
                hint: 'Método de pago',
                selectedItem: controller.metodoPagoSeleccionado,
                items: [
                  DropDownItem(text: 'Efectivo', value: 'Efectivo'),
                  DropDownItem(text: 'Transferencia', value: 'Transferencia'),
                  DropDownItem(text: 'Tarjeta', value: 'Tarjeta'),
                ],
                onChanged: (value) {
                  // value ya contiene el texto directamente ('Efectivo', 'Transferencia', 'Tarjeta')
                  controller.metodoPagoSeleccionado.value = value;
                },
              ),


              // Comprobante (opcional) usando CustomTextFieldUnderline
              CustomTextFieldUnderline(
                label: 'Comprobante',
                hintText: 'Ej: REF123456789 (opcional)',
                info: controller.comprobanteController,
                typefield: TypeField.TEXT,
              ),


              // Observaciones (opcional) usando CustomTextFieldUnderline
              CustomTextFieldUnderline(
                label: 'Observaciones',
                hintText: 'Notas adicionales (opcional)',
                info: controller.observacionesController,
                typefield: TypeField.DESCRIPTION,
              ),

              const SizedBox(height: 20),

              // Botón de registrar usando ElevatedButtonWidget
              Obx(() => ElevatedButtonWidget(
                    text: controller.isLoading.value
                        ? 'Registrando...'
                        : 'Registrar Abono',
                    color: Colors.green,
                    onPressed: controller.isLoading.value
                        ? () {}
                        : () => controller.registrarAbono(),
                  )),

              const SizedBox(height: 10),

              // Botón de ver historial usando ElevatedButtonWidget
              ElevatedButtonWidget(
                text: 'Ver Historial de Abonos',
                color: Colors.blue,
                onPressed: () => controller.verHistorialAbonos(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
