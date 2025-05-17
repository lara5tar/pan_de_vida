import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// Función callback para procesar códigos detectados
typedef BarcodeDetectionCallback = void Function(String barcode);

class CameraService extends GetxService {
  final isProcessing = false.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Guardamos la función callback para procesamiento de códigos
  BarcodeDetectionCallback? _barcodeCallback;

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

  // Método para registrar el callback
  void setBarcodeCallback(BarcodeDetectionCallback callback) {
    _barcodeCallback = callback;
  }

  Widget openScanner() {
    return MobileScanner(
      controller: MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
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
        ],
      ),
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

    // En lugar de buscar directamente MycartController, usamos el callback registrado
    if (_barcodeCallback != null) {
      _barcodeCallback!(code);
    } else {
      debugPrint(
          'No barcode callback registered. Please call setBarcodeCallback() first.');
    }

    Future.delayed(const Duration(seconds: 2), () {
      isProcessing.value = false;
    });
  }
}
