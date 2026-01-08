import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pos_view_controller.dart';

class PosCameraWidget extends GetView<PosViewController> {
  const PosCameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: controller.isCameraActive.value ? 300 : 0,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            if (controller.isCameraActive.value)
              BoxShadow(
                color: Colors.blue.shade900.withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: controller.isCameraActive.value
              ? Stack(
                  children: [
                    controller.cameraService.openScanner(),
                    // Marco de guía para escaneo
                    Center(
                      child: Container(
                        width: 250,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Escanea el código de barras',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                backgroundColor:
                                    Colors.black.withValues(alpha: 0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Indicador de procesamiento
                    Obx(
                      () => controller.cameraService.isProcessing.value
                          ? Container(
                              color: Colors.black.withValues(alpha: 0.5),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
