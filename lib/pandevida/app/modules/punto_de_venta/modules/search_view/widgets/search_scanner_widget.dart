import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/camera_service.dart';

class SearchScannerWidget extends StatelessWidget {
  const SearchScannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CameraService cameraService = Get.find<CameraService>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.shade800,
          width: 3,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Escáner de código de barras
          cameraService.openScanner(),

          // Overlay con guía de escaneo
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Coloca el código de barras dentro del marco',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Esquinas decorativas
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.green.shade400, width: 4),
                  left: BorderSide(color: Colors.green.shade400, width: 4),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.green.shade400, width: 4),
                  right: BorderSide(color: Colors.green.shade400, width: 4),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.green.shade400, width: 4),
                  left: BorderSide(color: Colors.green.shade400, width: 4),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.green.shade400, width: 4),
                  right: BorderSide(color: Colors.green.shade400, width: 4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
