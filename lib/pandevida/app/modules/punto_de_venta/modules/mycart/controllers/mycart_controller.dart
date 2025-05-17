import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/book_model.dart';
import '../../../data/services/books_service.dart';
import '../../../data/services/camera_service.dart';
import '../../../widgets/confirm_dialog.dart';

class MycartController extends GetxController {
  var cameraService = Get.find<CameraService>();
  var booksService = BooksService();
  var selectedCartItem = Rx<CartItem?>(null);
  var cartItems = <CartItem>[].obs;
  var totalAmount = 0.0.obs;
  var isCameraActive = false.obs;
  var barcodeBuffer = '';
  var isLoading = false.obs;
  var inDialog = false.obs;

  void updateQuantityByInput(int newQuantity) {
    if (selectedCartItem.value == null) {
      Get.snackbar('Error', 'No hay ningún libro seleccionado');
      return;
    }
    if (newQuantity <= 0) {
      Get.snackbar('Error', 'La cantidad debe ser mayor que cero');
      return;
    }

    CartItem item = selectedCartItem.value!;
    if (newQuantity > item.book.cantidadEnStock) {
      Get.snackbar(
        'Sin stock',
        'No hay suficiente stock. Disponible: ${item.book.cantidadEnStock}',
      );
      return;
    }

    // Actualizar el monto total
    totalAmount.value -= item.book.precio * item.quantity.value;
    item.quantity.value = newQuantity;
    totalAmount.value += item.book.precio * item.quantity.value;

    cartItems.refresh(); // Para asegurar que la UI se actualice si es necesario
    Get.snackbar('Cantidad actualizada',
        'La cantidad de "${item.book.nombre}" es ahora ${item.quantity.value}');
  }

  void getKeyDownEvent(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (barcodeBuffer.isNotEmpty) {
        findBookByBarcode(barcodeBuffer);
        barcodeBuffer = '';
      }
    } else if (event.character != null && event.character!.isNotEmpty) {
      barcodeBuffer += event.character!;
    }
  }

  void updatePrice(double newPrice, CartItem item) {
    // En un entorno real, deberías actualizar el precio en la base de datos
    // Por ahora solo actualizamos el precio en el carrito
    totalAmount.value -= item.book.precio * item.quantity.value;
    item.book = item.book.copyWith(precio: newPrice);
    totalAmount.value += item.book.precio * item.quantity.value;
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

  Future<void> findBookByBarcode(String barcode) async {
    isLoading.value = true;
    try {
      final result = await booksService.findByBarcode(barcode);
      if (!result['error']) {
        Book book = result['data'];
        addBook(book);
      } else {
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'No se encontró ningún libro con ese código');
    } finally {
      isLoading.value = false;
    }
  }

  void addBook(Book book) {
    CartItem? existingItem = findBookInCart(book);

    if (existingItem != null) {
      incrementQuantity(existingItem);
    } else {
      var newItem = CartItem(book);
      //añade al inicio
      cartItems.insert(0, newItem);
      totalAmount.value += book.precio;
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

  CartItem? findBookInCart(Book book) => cartItems.firstWhereOrNull(
        (element) => element.book.codigoBarras == book.codigoBarras,
      );

  void checkout() {
    // Aquí podrías actualizar el inventario reduciendo la cantidad de libros en stock
    cartItems.clear();
    totalAmount.value = 0.0;
    Get.snackbar('Compra realizada', 'Gracias por su compra');
  }

  void startRemoveSelectedItem() {
    if (selectedCartItem.value == null) return;
    confirmDialog(
      content: selectedCartItem.value!.book.nombre,
      title: '¿Quitamos este libro?',
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
    totalAmount.value -= item.book.precio;
    totalAmount.value = totalAmount.value.abs();
  }

  void incrementQuantity(CartItem item) {
    // Verificar si hay suficiente stock antes de incrementar
    if (item.quantity.value < item.book.cantidadEnStock) {
      item.quantity += 1;
      if (item.quantity.value == 1) {
        cartItems.add(item);
      } else {
        totalAmount.value += item.book.precio;
      }
    } else {
      Get.snackbar(
        'Sin stock',
        'No hay suficiente stock disponible para este libro',
      );
    }
  }

  void selectCartItem(CartItem item) {
    selectedCartItem.value = item;
  }

  void removeSelectedItem() {
    if (selectedCartItem.value == null) return;

    cartItems.remove(selectedCartItem.value);
    totalAmount.value -= selectedCartItem.value!.book.precio *
        selectedCartItem.value!.quantity.value;

    totalAmount.value = totalAmount.value.abs();
    selectedCartItem.value = null;
  }

  Future<void> addBookByCode(String code) async {
    await findBookByBarcode(code);
  }
}

class CartItem {
  Book book;
  var quantity = 1.obs;
  var isSelected = false.obs;

  CartItem(this.book);
}
