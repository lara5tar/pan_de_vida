import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/cart_controller.dart';

class PaymentView extends GetView<CartController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proceso de Pago'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen del carrito
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen de la compra',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cantidad de libros:'),
                        // Usamos el map de quantities para suma de cantidades
                        Text(
                          '${controller.quantities.values.fold(0, (sum, qty) => sum + qty)}',
                        ),
                      ],
                    ),
                    const Divider(),
                    _buildSummaryRow('Subtotal:',
                        '\$${controller.subtotal.toStringAsFixed(2)}'),
                    Obx(() {
                      if (!controller.isSupplier.value) {
                        return const SizedBox.shrink();
                      }
                      return _buildSummaryRow(
                        'Descuento (${controller.supplierDiscountPercentage.value.toStringAsFixed(0)}%):',
                        '-\$${controller.discountAmount.toStringAsFixed(2)}',
                        valueColor: Colors.green,
                      );
                    }),
                    const Divider(),
                    _buildSummaryRow(
                      'Total:',
                      '\$${controller.total.toStringAsFixed(2)}',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),

            // Método de pago
            const Text(
              'Método de Pago',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(() => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  controller.isInstallmentPayment.value = false,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: !controller.isInstallmentPayment.value
                                      ? Colors.blue
                                      : Colors.grey[200],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.payments_outlined,
                                      color:
                                          !controller.isInstallmentPayment.value
                                              ? Colors.white
                                              : Colors.black54,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Pago único',
                                      style: TextStyle(
                                        color: !controller
                                                .isInstallmentPayment.value
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.isInstallmentPayment.value = true;
                                // Generar plan de pagos automáticamente al seleccionar la opción
                                controller.generateDefaultInstallmentPlan();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: controller.isInstallmentPayment.value
                                      ? Colors.blue
                                      : Colors.grey[200],
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color:
                                          controller.isInstallmentPayment.value
                                              ? Colors.white
                                              : Colors.black54,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'A plazos',
                                      style: TextStyle(
                                        color: controller
                                                .isInstallmentPayment.value
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),

            // Pagos a plazos
            Obx(() {
              if (!controller.isInstallmentPayment.value) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Información del cliente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cliente
                  TextField(
                    controller: controller.customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del cliente *',
                      hintText: 'Nombre completo',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Contacto
                  TextField(
                    controller: controller.contactInfoController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono *',
                      hintText: 'Número de teléfono',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 12),

                  // Notas
                  TextField(
                    controller: controller.notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notas (opcional)',
                      hintText: 'Observaciones o acuerdos especiales',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    maxLines: 2,
                  ),
                ],
              );
            }),

            // Comprobante de pago (solo para pagos únicos)
            Obx(() {
              if (controller.isInstallmentPayment.value) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Comprobante de pago',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Adjunta un comprobante de pago (opcional)',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final hasImage =
                        controller.paymentReceiptImage.value != null;

                    if (hasImage) {
                      return Column(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(
                                    controller.paymentReceiptImage.value!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => controller.clearPaymentReceipt(),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red,
                              backgroundColor: Colors.red.withAlpha(25),
                            ),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Eliminar comprobante'),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller
                                  .getPaymentReceipt(ImageSource.gallery),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.photo_library,
                                  color: Colors.white),
                              label: const Text('Galería'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller
                                  .getPaymentReceipt(ImageSource.camera),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                              label: const Text('Cámara'),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
                ],
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(77),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _confirmPurchase(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Finalizar Compra',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // Función para mostrar selector de fecha - Mantenida para posible uso futuro
  /*
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.startDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('es', 'ES'),
    );

    if (picked != null && picked != controller.startDate.value) {
      controller.updateStartDate(picked);
    }
  }
  */

  // Widget para mostrar la información de pagos
  Widget _buildPaymentInfoCard(String paymentInfo) {
    // Analizar las líneas para darles formato
    List<String> lines = paymentInfo.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resumen financiero del plan de pagos
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado del plan
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text(
                      "Resumen del Plan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido del plan
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (int i = 1; i < lines.length; i++)
                      if (lines[i].isNotEmpty) _formatLineItem(lines[i])
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Formato para cada línea del plan de pagos
  Widget _formatLineItem(String line) {
    List<String> parts = line.split(':');
    bool isPagoInicial = line.contains("Pago Inicial");

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            parts[0].trim(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            parts.length > 1 ? parts[1].trim() : "",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isPagoInicial ? Colors.green[700] : Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  // Función para finalizar la compra
  void _confirmPurchase() {
    if (controller.isInstallmentPayment.value) {
      // Validar nombre del cliente
      if (controller.customerNameController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'El nombre del cliente es obligatorio para compras a plazos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validar información de contacto
      if (controller.contactInfoController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'La información de contacto es obligatoria para compras a plazos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Crear plan con los datos proporcionados
      controller.createInstallmentPlan();
    }

    controller.completePurchase();
    Get.back(); // Volver a la pantalla del carrito
  }
}
