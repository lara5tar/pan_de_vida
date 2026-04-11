import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/book_model.dart';
import '../controllers/pos_view_controller.dart';

class PosBookItemWidget extends GetView<PosViewController> {
  final CartItem cartItem;

  const PosBookItemWidget({
    required this.cartItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    final FocusNode focusNode = FocusNode();
    
    textEditingController.text = cartItem.quantity.value.toString();
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));

    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        decoration: BoxDecoration(
          color: controller.selectedCartItem.value == cartItem
              ? Colors.teal[100]?.withValues(alpha: 0.9)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // Solo seleccionar el item, pero no abrir el teclado
            controller.selectCartItem(cartItem);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                // Cantidad editable
                GestureDetector(
                  onTap: () {
                    // Este onTap solo se dispara al tocar el número
                    controller.selectCartItem(cartItem);
                    textEditingController.text = cartItem.quantity.value.toString();
                    textEditingController.selection = TextSelection.fromPosition(
                        TextPosition(offset: textEditingController.text.length));
                    // Solicitar foco SOLO cuando se toca el número
                    if (focusNode.canRequestFocus) {
                      focusNode.requestFocus();
                    }
                  },
                  child: SizedBox(
                    width: 70,
                    child: controller.selectedCartItem.value == cartItem
                        ? TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (value) {
                              final newQuantity = int.tryParse(value);
                              if (newQuantity != null) {
                                controller.updateQuantityByInput(newQuantity);
                                // Desenfoque automático después de actualizar
                                focusNode.unfocus();
                              }
                            },
                            onTapOutside: (_) {
                              final newQuantity =
                                  int.tryParse(textEditingController.text);
                              if (newQuantity != null) {
                                controller.updateQuantityByInput(newQuantity);
                              }
                              // Desenfoque automático al tocar fuera
                              focusNode.unfocus();
                            },
                          )
                        : Center(
                            child: Text(
                              '${cartItem.quantity.value}x',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                // Información del libro
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.book.nombre,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Precio: \$${cartItem.book.precio.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (cartItem.book.cantidadEnStock < 10)
                        Text(
                          'Stock: ${cartItem.book.cantidadEnStock}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Subtotal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${(cartItem.book.precio * cartItem.quantity.value).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
