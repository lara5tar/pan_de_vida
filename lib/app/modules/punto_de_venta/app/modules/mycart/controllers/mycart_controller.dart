import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/factories/product_factory.dart';
import '../../../data/models/product.dart';
import '../../../data/services/camera_service.dart';
import '../../../data/services/product_service.dart';
import '../../../widgets/confirm_dialog.dart';

class MycartController extends GetxController {
  var cameraService = Get.find<CameraService>();
  var productService = Get.find<ProductService>();
  var selectedCartItem = Rx<CartItem?>(null);
  var cartItems = <CartItem>[].obs;
  var totalAmount = 0.0.obs;
  var isCameraActive = false.obs;
  var barcodeBuffer = '';

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      ProductFactory(addItem: addProduct).addProducts(10);
    }
  }

  void getKeyDownEvent(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (barcodeBuffer.isNotEmpty) {
        var product = productService.readProductByCode(barcodeBuffer);
        if (product != null) {
          addProduct(product);
        }
        barcodeBuffer = '';
      }
    } else if (event.character != null && event.character!.isNotEmpty) {
      barcodeBuffer += event.character!;
    }
  }

  void updatePrice(double newPrice, CartItem item) {
    item.product.price = newPrice;
    cartItems.refresh();
  }

  void selectedCarItemIncrement() {
    if (selectedCartItem.value != null) {
      incrementQuantity(selectedCartItem.value!);
    }
  }

  void selectedCarItemDecrement() {
    if (selectedCartItem.value != null) {
      decrementQuantity(selectedCartItem.value!);
    }
  }

  void addProduct(
    Product product,
  ) {
    CartItem? existingItem = findProductInCart(product);

    if (existingItem != null) {
      incrementQuantity(existingItem);
    } else {
      var newItem = CartItem(product);
      //añade al inicio
      cartItems.insert(0, newItem);
      totalAmount.value += product.price;
    }

    selectedCartItem.value = existingItem;
    setCartItemInTop();
  }

  setCartItemInTop() {
    if (selectedCartItem.value != null) {
      cartItems.remove(selectedCartItem.value);
      cartItems.insert(0, selectedCartItem.value!);
    }
  }

  CartItem? findProductInCart(Product product) => cartItems.firstWhereOrNull(
        (element) => element.product.code == product.code,
      );

  void checkout() {
    totalAmount.value = 0.0;
    Get.snackbar('Compra realizada', 'Gracias por su compra');
  }

  void startRemoveSelectedItem() {
    if (selectedCartItem.value == null) return;
    confirmDialog(
      content: selectedCartItem.value!.product.name,
      title: '¿Quitamos este producto?',
      confirmAction: removeSelectedItem,
    );
  }

  void startClearCart() {
    confirmDialog(
      title: 'Cancelamos la venta',
      content: '¿Está seguro?',
      confirmAction: clearCart,
    );
  }

  void clearCart() {
    cartItems.clear();
    totalAmount.value = 0.0;
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity.value == 1) return;
    item.quantity -= 1;
    if (item.quantity.value == 0) {
      cartItems.remove(item);
      selectedCartItem.value = null;
    }
    totalAmount.value -= item.product.price;
    totalAmount.value = totalAmount.value.abs();
  }

  void incrementQuantity(CartItem item) {
    item.quantity += 1;
    if (item.quantity.value == 1) {
      cartItems.add(item);
    } else {
      totalAmount.value += item.product.price;
    }
  }

  void selectCartItem(CartItem item) {
    selectedCartItem.value = item;
  }

  void removeSelectedItem() {
    if (selectedCartItem.value == null) return;

    cartItems.remove(selectedCartItem.value);
    totalAmount.value -= selectedCartItem.value!.product.price *
        selectedCartItem.value!.quantity.value;

    totalAmount.value = totalAmount.value.abs();
    selectedCartItem.value = null;
  }

  void addProductByCode(String code) async {
    var product = productService.readProductByCode(code);
    if (product != null) {
      addProduct(product);
    }
  }
}

class CartItem {
  Product product;
  var quantity = 1.obs;
  var isSelected = false.obs;

  CartItem(
    this.product,
  );
}
