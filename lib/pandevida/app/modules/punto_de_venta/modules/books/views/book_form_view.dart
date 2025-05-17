import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/widgets/custom_text_field_underline.dart';
import 'package:pan_de_vida/pandevida/app/widgets/elevated_button_widget.dart';
import 'package:pan_de_vida/pandevida/app/widgets/text_title_widget.dart';

import '../controllers/book_form_controller.dart';
import '../../../../../widgets/custom_scaffold.dart';
import 'qr_scanner_view.dart';

class BookFormView extends GetView<BookFormController> {
  const BookFormView({super.key});

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
            Obx(
              () => TextTitleWidget(
                controller.isEditing.value ? 'EDITAR LIBRO' : 'NUEVO LIBRO',
              ),
            ),
            // Campo ID visible solo en modo edición (cuando el libro ya existe)
            // if (controller.isEditing.value)
            //   CustomTextFieldUnderline(
            //     label: 'ID del libro',
            //     hintText: 'ID (solo lectura)',
            //     info: controller.idController,
            //     typefield: TypeField.TEXT,
            //     // enabled: false, // ID no se puede editar
            //   ),

            // Campo de código de barras con botón para escanear
            Row(
              children: [
                Expanded(
                  child: CustomTextFieldUnderline(
                    label: 'Código de Barras',
                    hintText: 'Ingrese o escanee el código de barras',
                    info: controller.codigoBarrasController,
                    typefield: TypeField.TEXT,
                  ),
                ),
                Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 58,
                    width: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue.shade800,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                      ),
                      onPressed: () => _openScanner(context),
                      tooltip: 'Escanear código QR o de barras',
                    ),
                  ),
                ),
              ],
            ),
            CustomTextFieldUnderline(
              label: 'Nombre',
              hintText: 'Ingrese el nombre del libro',
              info: controller.nombreController,
              typefield: TypeField.TEXT,
            ),
            CustomTextFieldUnderline(
              label: 'Precio',
              hintText: 'Ingrese el precio del libro',
              info: controller.precioController,
              typefield: TypeField.MONEY,
            ),
            // Campo de cantidad con botones de incremento/decremento
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Botón para decrementar
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade800,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.remove, color: Colors.white),
                        onPressed: () {
                          // Evitar valores negativos
                          int currentValue = int.tryParse(
                                  controller.cantidadController.text) ??
                              0;
                          if (currentValue > 0) {
                            controller.cantidadController.text =
                                (currentValue - 1).toString();
                          }
                        },
                      ),
                    ),
                    // Campo de texto para la cantidad
                    Expanded(
                      child: CustomTextFieldUnderline(
                        label: 'Cantidad disponible',
                        hintText: 'Cantidad disponible',
                        info: controller.cantidadController,
                        typefield: TypeField.NUMBER,
                      ),
                    ),
                    // Botón para incrementar
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade800,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          // Incrementar el valor
                          int currentValue = int.tryParse(
                                  controller.cantidadController.text) ??
                              0;
                          controller.cantidadController.text =
                              (currentValue + 1).toString();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButtonWidget(
                text: controller.isEditing.value
                    ? 'Actualizar Libro'
                    : 'Guardar Libro',
                onPressed: () {
                  if (!controller.isLoading.value) {
                    controller.saveBook();
                  }
                },
                color: Colors.blue.shade800,
              ),
            ),
            if (controller.isEditing.value) const SizedBox(height: 10),

            if (controller.isEditing.value)
              ElevatedButtonWidget(
                text: 'Eliminar Libro',
                onPressed: () {
                  if (!controller.isLoading.value) {
                    controller.deleteBook();
                  }
                },
                color: Colors.red.shade700,
              ),

            const SizedBox(height: 10),
            ElevatedButtonWidget(
              text: 'Cancelar',
              onPressed: () => Get.back(),
              color: Colors.blueGrey,
            ),
            // Indicador de carga
            Obx(() => controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  void _openScanner(BuildContext context) {
    Get.to(() => QrScannerView(
          onDetect: controller.onDetect,
        ));
  }
}
