import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/book_model.dart';
import '../controllers/mycart_controller.dart';

class BookWidget extends GetView<MycartController> {
  final CartItem cartItem;

  const BookWidget({
    required this.cartItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    // Establecer el texto inicial del controlador
    textEditingController.text = cartItem.quantity.value.toString();
    // Mover el cursor al final del texto
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));

    return Obx(
      () => Container(
        color: Colors.white.withValues(alpha: 0.8),
        margin: const EdgeInsets.only(bottom: 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            selectedTileColor: Colors.teal[100],
            selectedColor: Colors.black,
            selected: controller.selectedCartItem.value == cartItem,
            onTap: () {
              controller.selectCartItem(cartItem);
              // Actualizar el texto del controlador cuando se selecciona el ítem
              textEditingController.text = cartItem.quantity.value.toString();
              // Mover el cursor al final del texto
              textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: textEditingController.text.length));
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            title: Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    child: controller.selectedCartItem.value == cartItem
                        ? RawKeyboardListener(
                            focusNode:
                                FocusNode(), // Necesario para capturar eventos de teclado
                            onKey: (RawKeyEvent event) {
                              if (event is RawKeyDownEvent &&
                                  event.logicalKey ==
                                      LogicalKeyboardKey.enter) {
                                final newQuantity =
                                    int.tryParse(textEditingController.text);
                                if (newQuantity != null) {
                                  controller.updateQuantityByInput(newQuantity);
                                }
                                // Quitar el foco para ocultar el teclado
                                FocusScope.of(context).unfocus();
                              }
                            },
                            child: TextField(
                              controller: textEditingController,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 23),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (value) {
                                final newQuantity = int.tryParse(value);
                                if (newQuantity != null) {
                                  controller.updateQuantityByInput(newQuantity);
                                }
                              },
                              onTapOutside: (_) {
                                // Cuando se toca fuera del textfield, se actualiza la cantidad
                                final newQuantity =
                                    int.tryParse(textEditingController.text);
                                if (newQuantity != null) {
                                  controller.updateQuantityByInput(newQuantity);
                                }
                              },
                            ),
                          )
                        : Text(
                            cartItem.quantity.value.toString(),
                            style: const TextStyle(fontSize: 23),
                          ),
                  ),
                  Expanded(
                    child: Text(
                      cartItem.book.nombre,
                      style: const TextStyle(fontSize: 23),
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: Text(
                      '\$${(cartItem.book.precio * cartItem.quantity.value).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 23),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${cartItem.book.precio.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (cartItem.book.codigoBarras.isNotEmpty)
                    Text(
                      'Código: ${cartItem.book.codigoBarras}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  Text(
                    'Stock: ${cartItem.book.cantidadEnStock}',
                    style: TextStyle(
                      fontSize: 14,
                      color: cartItem.book.cantidadEnStock > 5
                          ? Colors.green[800]
                          : Colors.red[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
