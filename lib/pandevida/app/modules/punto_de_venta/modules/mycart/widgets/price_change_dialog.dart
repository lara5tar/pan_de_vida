import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/mycart_controller.dart';

Future<double> editPriceDialog({
  required String name,
  required double price,
}) async {
  // Obtenemos el controlador de carrito
  final mycartController = Get.find<MycartController>();

  // Establecemos que estamos en un diálogo para pausar la captura de eventos del scanner
  mycartController.inDialog.value = true;

  TextEditingController priceController = TextEditingController(
    text: price.toString(),
  );
  FocusNode textFieldFocusNode = FocusNode();
  bool result = false;

  await Get.dialog(
    barrierColor: Colors.black87,
    barrierDismissible: false,
    WillPopScope(
      // Interceptamos el botón de retroceso para asegurar que se restablezca el flag
      onWillPop: () async {
        mycartController.inDialog.value = false;
        return true;
      },
      child: UnconstrainedBox(
        child: SizedBox(
          width: 450,
          child: AlertDialog(
            title: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
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
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        priceController.text = '0.00';
                      }
                    },
                    onSubmitted: (value) {
                      result = true;
                      Get.back();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CurrencyInputFormatter(),
                    ],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.delete, size: 32),
                        onPressed: () {
                          priceController.text = '0.00';
                        },
                      ),
                      helperText: 'Ingrese monto',
                      prefixText: '\$ ',
                      label: const Text('Precio Unitario'),
                      prefixStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }),
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
                  result = true;
                  mycartController.inDialog.value = false;
                  Get.back();
                },
                child: const Text(
                  'Guardar',
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

  return result
      ? double.parse(
          priceController.text.replaceAll(',', ''),
        )
      : price;
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Convierte el texto a un número (en centavos)
    final value = int.parse(newValue.text);
    // Convierte a formato decimal
    final actualValue = value / 100;

    // Formatea el número con dos decimales
    final formatter = NumberFormat("#,##0.00", "en_US");
    final newText = formatter.format(actualValue);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
