import 'dart:async';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../modules/mycart/controllers/mycart_controller.dart';

class CameraService extends GetxService {
  final isProcessing = false.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    // Preload the sound for better performance
    _audioPlayer.setSourceAsset('sonido.wav');
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  Widget openScanner() {
    // final completer = Completer<String>();
    final controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.unrestricted,
      facing: CameraFacing.front,
      formats: [
        BarcodeFormat.ean8,
        BarcodeFormat.ean13,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.code39,
        BarcodeFormat.code93,
        BarcodeFormat.code128,
        BarcodeFormat.dataMatrix,
        BarcodeFormat.qrCode,

        // BarcodeFormat.all,
      ],
    );

    return MobileScanner(
      controller: controller,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty && !isProcessing.value) {
          final String? code = barcodes.first.rawValue;
          if (code != null && code.isNotEmpty) {
            _handleDetectedCode(code);
          }
        }
      },
    );
  }

  void _handleDetectedCode(String code) {
    if (isProcessing.value) return;

    isProcessing.value = true;
    _audioPlayer.stop().then((_) {
      _audioPlayer.play(AssetSource('sonido.wav'));
    });

    Get.find<MycartController>().addProductByCode(code);

    Future.delayed(const Duration(seconds: 2), () {
      isProcessing.value = false;
    });
  }
}
