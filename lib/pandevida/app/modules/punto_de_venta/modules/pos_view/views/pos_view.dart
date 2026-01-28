import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../controllers/pos_view_controller.dart';
import '../widgets/pos_action_buttons_widget.dart';
import '../widgets/pos_book_item_widget.dart';
import '../widgets/pos_bottom_bar_widget.dart';
import '../widgets/pos_camera_widget.dart';

class PosView extends GetView<PosViewController> {
  const PosView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      bottomSheet: const PosBottomBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Título con información del carrito y subinventario
            Container(
              color: Colors.white.withValues(alpha: 0.9),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.blue[900],
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(() {
                            final sub = controller.subinventarioActivo.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sub?.nombreDisplay ?? 'Punto de Venta',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  sub != null
                                      ? '${sub.totalLibros} libros · ${sub.totalUnidades} unidades disponibles'
                                      : '${controller.cartItems.length} ${controller.cartItems.length == 1 ? 'libro' : 'libros'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  // Botón de cámara
                  Obx(
                    () => IconButton(
                      onPressed: () {
                        controller.isCameraActive.toggle();
                      },
                      icon: Icon(
                        controller.isCameraActive.value
                            ? Icons.videocam
                            : Icons.videocam_off,
                        size: 28,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: controller.isCameraActive.value
                            ? Colors.green[100]
                            : Colors.grey[300],
                        foregroundColor: controller.isCameraActive.value
                            ? Colors.green[800]
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Cámara expandible
            const PosCameraWidget(),
            const SizedBox(height: 10),
            // Botones de acción
            const PosActionButtonsWidget(),
            const SizedBox(height: 10),
            // Lista de libros en el carrito
            Obx(
              () {
                if (controller.cartItems.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Escanea un código de barras para agregar libros',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'o usa el botón de búsqueda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    ...controller.cartItems
                        .map(
                            (cartItem) => PosBookItemWidget(cartItem: cartItem))
                        .toList(),
                  ],
                );
              },
            ),
            const SizedBox(height: 150), // Espacio para el bottomSheet
          ],
        ),
      ),
    );
  }
}
