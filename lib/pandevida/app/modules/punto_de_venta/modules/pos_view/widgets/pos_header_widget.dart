import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pos_view_controller.dart';

class PosHeaderWidget extends GetView<PosViewController> {
  const PosHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.blue[900],
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Punto de Venta',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Obx(
                        () => Text(
                          '${controller.cartItems.length} ${controller.cartItems.length == 1 ? 'libro' : 'libros'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
        ],
      ),
    );
  }
}
