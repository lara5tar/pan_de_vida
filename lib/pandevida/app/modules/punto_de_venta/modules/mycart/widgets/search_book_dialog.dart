import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/mycart_controller.dart';

Future<String?> searchBookDialog() async {
  // Obtenemos el controlador de carrito
  final mycartController = Get.find<MycartController>();

  // Establecemos que estamos en un diálogo para pausar la captura de eventos del scanner
  mycartController.inDialog.value = true;

  TextEditingController codeController = TextEditingController();
  FocusNode textFieldFocusNode = FocusNode();
  bool result = false;
  String? code;

  await Get.dialog(
    barrierColor: Colors.black87,
    barrierDismissible: true,
    WillPopScope(
      // Interceptamos el botón de retroceso para asegurar que se restablezca el flag
      onWillPop: () async {
        mycartController.inDialog.value = false;
        return true;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width:
              Get.width * 0.9, // Usar ancho relativo al tamaño de la pantalla
          constraints:
              const BoxConstraints(maxWidth: 450), // Establecer un ancho máximo
          child: AlertDialog(
            insetPadding: EdgeInsets.zero, // Eliminar el padding interno
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            title: const Text(
              'Buscar Libro',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                // Asegurar que el TextField obtenga el foco después de renderizarse
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (textFieldFocusNode.canRequestFocus) {
                    FocusScope.of(context).requestFocus(textFieldFocusNode);
                  }
                });

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      focusNode: textFieldFocusNode,
                      controller: codeController,
                      keyboardType: TextInputType.text,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          result = true;
                          code = value;
                          Get.back();
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Ingrese el código de barras',
                        prefixIcon: Icon(Icons.search),
                        label: Text('Código de barras'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                );
              },
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  iconColor: Colors.white,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                ),
                onPressed: () {
                  mycartController.inDialog.value = false;
                  Get.back();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[400],
                  iconColor: Colors.white,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                ),
                onPressed: () {
                  if (codeController.text.isNotEmpty) {
                    result = true;
                    code = codeController.text;
                    mycartController.inDialog.value = false;
                    Get.back();
                  }
                },
                child: const Text(
                  'Buscar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ).then((_) {
    // Asegurar que el flag se restaure cuando el diálogo se cierre por cualquier motivo
    mycartController.inDialog.value = false;
  });

  return result ? code : null;
}
