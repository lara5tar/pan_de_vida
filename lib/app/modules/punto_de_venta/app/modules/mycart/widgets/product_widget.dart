import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mycart_controller.dart';

class ProductWidget extends GetView<MycartController> {
  final CartItem cartItem;

  const ProductWidget({
    required this.cartItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: ListTile(
          tileColor: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          selectedTileColor: Colors.teal[100],
          selectedColor: Colors.black,
          selected: controller.selectedCartItem.value == cartItem,
          onTap: () {
            controller.selectedCartItem.value = cartItem;
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
                  // color: Colors.red,
                  width: 70,
                  child: Text(
                    cartItem.quantity.value.toString(),
                    style: const TextStyle(fontSize: 23),
                  ),
                ),
                Expanded(
                  child: Text(
                    cartItem.product.name,
                    style: const TextStyle(fontSize: 23),
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: Text(
                    '\$${(cartItem.product.price * cartItem.quantity.value).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 23),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Text(
              '\$${cartItem.product.price}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
