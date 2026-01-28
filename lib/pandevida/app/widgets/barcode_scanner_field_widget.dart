import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../modules/punto_de_venta/modules/books/views/qr_scanner_view.dart';

class BarcodeScannerFieldWidget extends StatefulWidget {
  /// Función que se llama cuando cambia el texto o se escanea un código
  final Function(String) onChanged;

  /// Función que se llama específicamente cuando se detecta un código de barras
  final Function(String)? onBarcodeDetected;

  /// El texto de placeholder que se muestra cuando el campo está vacío
  final String hintText;

  /// Icono personalizado para el campo de búsqueda
  final IconData? searchIcon;

  /// Si es verdadero, el campo tendrá enfoque automáticamente al mostrarse
  final bool autofocus;

  /// Constructor para el widget BarcodeScannerFieldWidget
  const BarcodeScannerFieldWidget({
    super.key,
    required this.onChanged,
    this.onBarcodeDetected,
    this.hintText = 'Buscar o escanear código',
    this.searchIcon = Icons.search,
    this.autofocus = false,
  });

  @override
  State<BarcodeScannerFieldWidget> createState() =>
      _BarcodeScannerFieldWidgetState();
}

class _BarcodeScannerFieldWidgetState extends State<BarcodeScannerFieldWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    // Esto nos permitirá capturar eventos del teclado, incluidos los del escáner físico
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Maneja el escaneo de códigos de barras desde la cámara
  void _handleCameraScanner() async {
    setState(() {
      _isScanning = true;
    });

    // Abrir la cámara para escanear
    await Get.to(() => QrScannerView(
          onDetect: (barcode) {
            // Cuando se detecta un código de barras
            if (barcode.barcodes.isNotEmpty) {
              final String code = barcode.barcodes.first.rawValue ?? '';
              if (code.isNotEmpty) {
                _controller.text = code;
                widget.onChanged(code);
                if (widget.onBarcodeDetected != null) {
                  widget.onBarcodeDetected!(code);
                }
                Get.back(); // Cerrar la vista de escaneo
              }
            }
          },
        ));

    setState(() {
      _isScanning = false;
      // Devolvemos el foco al campo después de escanear
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: RawKeyboardListener(
              focusNode: _focusNode,
              onKey: (RawKeyEvent event) {
                // Detectar cuando se presiona Enter (lo que hacen los escáneres de códigos de barras)
                if (event is RawKeyUpEvent &&
                    (event.logicalKey == LogicalKeyboardKey.enter ||
                        event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
                  final String text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    // Esto probablemente fue un escaneo con un lector físico
                    if (widget.onBarcodeDetected != null) {
                      widget.onBarcodeDetected!(text);
                    }
                    widget.onChanged(text);
                  }
                }
              },
              child: TextField(
                controller: _controller,
                autofocus: widget.autofocus,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  prefixIcon: Icon(widget.searchIcon),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                onChanged: (value) {
                  // Para búsqueda normal con teclado
                  widget.onChanged(value);
                },
              ),
            ),
          ),
          // Botón para escanear con la cámara
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: _isScanning ? Colors.blue : Colors.grey.shade700,
            ),
            onPressed: _handleCameraScanner,
            tooltip: 'Escanear con cámara',
          ),
          // Botón para limpiar el texto
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _controller.clear();
                widget.onChanged('');
                _focusNode.requestFocus();
              },
              tooltip: 'Limpiar',
            ),
        ],
      ),
    );
  }
}
