import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

Future<String?> barcodeDialog() async {
  Barcode? barcode;

  await Get.dialog(
    Dialog(
      backgroundColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        height: Get.width * 0.9,
        width: Get.width * 0.9,
        child: Stack(
          children: [
            MobileScanner(
              placeholderBuilder: (p0, p1) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              onDetect: (barcodes) {
                barcode = barcodes.barcodes.firstOrNull;
                if (barcode != null) {
                  if (barcode!.displayValue != null) {
                    Get.back();
                    Get.snackbar('Barcode', 'Se detectó el código de barras.');
                  } else {
                    Get.snackbar(
                        'Barcode', 'No se detectó el código de barras.');
                  }
                } else {
                  Get.snackbar('Barcode', 'No se detectó el código de barras.');
                }
              },
            ),
            Positioned(
              right: 0,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  if (barcode != null) return barcode!.displayValue;

  return null;
}
