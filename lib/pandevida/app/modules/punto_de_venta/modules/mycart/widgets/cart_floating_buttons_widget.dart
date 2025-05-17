import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/mycart_controller.dart';
import 'price_change_dialog.dart';
import 'search_book_dialog.dart';

class CartFloatingButtonsWidget extends GetView<MycartController> {
  const CartFloatingButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          color: Colors.transparent,
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 10,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  CartFloatingButton(
                    icon: Icons.delete,
                    color: Colors.grey[600],
                    onPressed: () {
                      controller.startRemoveSelectedItem();
                    },
                  ),
                  CartFloatingButton(
                    icon: Icons.remove,
                    color: Colors.teal[500],
                    onPressed: () {
                      controller.selectedCarItemDecrement();
                    },
                  ),
                  CartFloatingButton(
                    icon: Icons.add,
                    color: Colors.teal[500],
                    onPressed: () {
                      controller.selectedCarItemIncrement();
                    },
                  ),
                  CartFloatingButton(
                    icon: Icons.edit,
                    color: Colors.teal[500],
                    onPressed: () async {
                      if (controller.selectedCartItem.value != null) {
                        var item = controller.selectedCartItem.value!;
                        double? price = await editPriceDialog(
                          name: item.book.nombre,
                          price: item.book.precio,
                        );

                        controller.updatePrice(price, item);
                      }
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  CartFloatingButton(
                    icon: Icons.search,
                    color: Colors.indigo[400],
                    onPressed: () async {
                      // Abre el diálogo de búsqueda y espera el resultado
                      String? code = await searchBookDialog();
                      if (code != null && code.isNotEmpty) {
                        // Busca el libro por el código ingresado
                        await controller.findBookByBarcode(code);
                      }
                    },
                  ),
                  Obx(
                    () => CartFloatingButton(
                      icon: controller.isCameraActive.value
                          ? Icons.no_photography
                          : Icons.camera_alt,
                      color: controller.isCameraActive.value
                          ? Colors.red
                          : Colors.indigo[400],
                      onPressed: () {
                        controller.isCameraActive.toggle();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Obx(
          () => Visibility(
            visible: controller.isCameraActive.value,
            child: Container(
              height: 250,
              margin: const EdgeInsets.only(
                bottom: 75,
                right: 10,
                left: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: controller.cameraService.openScanner(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CartFloatingButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Function onPressed;

  const CartFloatingButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 65,
      child: FloatingActionButton(
        heroTag: UniqueKey(),
        elevation: 0,
        backgroundColor: color,
        onPressed: () {
          onPressed();
        },
        child: Icon(
          icon,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}
