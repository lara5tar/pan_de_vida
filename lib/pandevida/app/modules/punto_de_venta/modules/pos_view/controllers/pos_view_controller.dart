import 'package:get/get.dart';
import '../../../data/models/book_model.dart';
import '../../../data/services/books_service.dart';
import '../../../data/services/camera_service.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../mycart/widgets/search_book_dialog.dart';

class PosViewController extends GetxController {
  var cameraService = Get.find<CameraService>();
  var booksService = BooksService();

  var selectedCartItem = Rx<CartItem?>(null);
  var cartItems = <CartItem>[].obs;
  var totalAmount = 0.0.obs;
  var isCameraActive = true.obs; // La cámara está activa por defecto
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Configurar el callback para el escaneo de códigos de barras
    cameraService.setBarcodeCallback((code) {
      addBookByCode(code);
    });
  }

  void addBookByCode(String code) async {
    await findBookByBarcode(code);
  }

  Future<void> findBookByBarcode(String barcode) async {
    isLoading.value = true;
    try {
      final result = await booksService.findByBarcode(barcode);
      if (!result['error']) {
        Book book = result['data'];
        addBook(book);
      } else {
        Get.snackbar('Error', result['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
            colorText: Get.theme.colorScheme.onError);
      }
    } catch (e) {
      Get.snackbar('Error', 'No se encontró ningún libro con ese código',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
          colorText: Get.theme.colorScheme.onError);
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
      cartItems.insert(0, newItem);
      totalAmount.value += book.precio;
    }

    selectedCartItem.value = existingItem ?? cartItems[0];
    Get.snackbar(
      'Libro agregado',
      '${book.nombre} - \$${book.precio.toStringAsFixed(2)}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.8),
      colorText: Get.theme.colorScheme.onPrimary,
      duration: const Duration(seconds: 2),
    );
  }

  CartItem? findBookInCart(Book book) => cartItems.firstWhereOrNull(
        (element) => element.book.id == book.id,
      );

  void incrementQuantity(CartItem item) {
    if (item.quantity.value < item.book.cantidadEnStock) {
      item.quantity.value++;
      totalAmount.value += item.book.precio;
      cartItems.refresh();
    } else {
      Get.snackbar(
        'Sin stock',
        'No hay más stock disponible de "${item.book.nombre}"',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
      totalAmount.value -= item.book.precio;
      cartItems.refresh();
    } else {
      removeItem(item);
    }
  }

  void removeItem(CartItem item) {
    totalAmount.value -= item.book.precio * item.quantity.value;
    cartItems.remove(item);
    if (selectedCartItem.value == item) {
      selectedCartItem.value = cartItems.isNotEmpty ? cartItems.first : null;
    }
  }

  void selectCartItem(CartItem item) {
    selectedCartItem.value = item;
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

  void startRemoveSelectedItem() {
    if (selectedCartItem.value != null) {
      confirmDialog(
        title: 'Eliminar libro',
        content:
            '¿Está seguro de eliminar "${selectedCartItem.value!.book.nombre}" del carrito?',
        confirmAction: () {
          removeItem(selectedCartItem.value!);
        },
      );
    }
  }

  void startClearCart() {
    if (cartItems.isEmpty) {
      Get.snackbar('Carrito vacío', 'No hay libros en el carrito');
      return;
    }

    confirmDialog(
      title: 'Vaciar carrito',
      content: '¿Está seguro de vaciar el carrito?',
      confirmAction: () {
        clearCart();
      },
    );
  }

  void clearCart() {
    cartItems.clear();
    totalAmount.value = 0.0;
    selectedCartItem.value = null;
    Get.snackbar('Carrito vaciado', 'Se eliminaron todos los libros');
  }

  Future<void> showSearchBookDialog() async {
    Book? foundBook = await searchBookDialog();
    if (foundBook != null) {
      addBook(foundBook);
    }
  }

  // Navegar a la vista de búsqueda
  void goToSearchView() {
    Get.toNamed(
      '/search-books',
      arguments: {
        'onBookSelected': (Book book) {
          addBook(book);
        }
      },
    );
  }

  void checkout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
          'Carrito vacío', 'Agregue libros antes de procesar la venta');
      return;
    }

    confirmDialog(
      title: 'Procesar venta',
      content:
          '¿Desea procesar la venta por \$${totalAmount.toStringAsFixed(2)}?',
      confirmAction: () {
        // Aquí podrías actualizar el inventario
        cartItems.clear();
        totalAmount.value = 0.0;
        selectedCartItem.value = null;
        Get.snackbar(
          'Venta procesada',
          'La venta se procesó correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.8),
          colorText: Get.theme.colorScheme.onPrimary,
        );
      },
    );
  }

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

    totalAmount.value -= item.book.precio * item.quantity.value;
    item.quantity.value = newQuantity;
    totalAmount.value += item.book.precio * item.quantity.value;
    cartItems.refresh();
  }

  @override
  void onClose() {
    // Limpiar el callback cuando se cierre el controlador
    cameraService.setBarcodeCallback((_) {});
    super.onClose();
  }
}
