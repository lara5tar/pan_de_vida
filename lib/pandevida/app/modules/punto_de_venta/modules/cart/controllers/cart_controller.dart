import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../data/models/book_model.dart';
import '../../../data/services/books_service.dart';
import '../../../data/services/camera_service.dart';

// Clase para manejar la información de pagos a plazos
class InstallmentPlan {
  final String customerName;
  final String contactInfo;
  final String notes;

  InstallmentPlan({
    required this.customerName,
    required this.contactInfo,
    this.notes = '',
  });
}

class CartController extends GetxController {
  // Service para acceder a los libros de la base de datos
  final BooksService _booksService = BooksService();

  // Camera service para el escaneo de códigos
  late final CameraService cameraService;

  // Estado del escáner
  final RxBool isCameraActive = false.obs;

  // Observable list of items in cart
  final RxList<Book> items = <Book>[].obs;

  // Map para mantener la cantidad y controlador por cada libro
  final RxMap<String, int> quantities = <String, int>{}.obs;
  final Map<String, TextEditingController> quantityControllers = {};

  // Search related
  final searchController = TextEditingController();
  final RxList<Book> searchResults = <Book>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoading = false.obs;

  // User role - admin por defecto
  final RxBool isAdmin = true.obs;

  // Customer type and discount
  final RxBool isSupplier = false.obs;
  final RxDouble supplierDiscountPercentage =
      30.0.obs; // Default 10% discount for suppliers

  // Payment receipt
  final Rx<File?> paymentReceiptImage = Rx<File?>(null);

  // Variables para pagos a plazos
  final RxBool isInstallmentPayment = false.obs;
  final Rx<InstallmentPlan?> installmentPlan = Rx<InstallmentPlan?>(null);
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final Rx<DateTime> startDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    cameraService = Get.find<CameraService>();

    // Registramos la función para procesar códigos de barras
    cameraService.setBarcodeCallback((barcode) async {
      // Buscar el producto por código de barras
      final productFound = await searchByBarcode(barcode);

      if (productFound) {
        // Si se encontró el producto, lo agregamos automáticamente al carrito
        final foundProduct = searchResults.first;
        addToCart(foundProduct);

        // Mostramos mensaje de éxito
        Get.snackbar(
          '¡Producto agregado!',
          'Se agregó "${foundProduct.nombre}" al carrito',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withAlpha(230),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          icon: const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        );
      } else {
        // Si no se encontró, mostramos mensaje de error
        Get.snackbar(
          'Producto no encontrado',
          'El código de barras $barcode no existe en el inventario',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withAlpha(230),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
        );
      }
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    customerNameController.dispose();
    contactInfoController.dispose();
    notesController.dispose();

    // Dispose de los controladores de texto
    quantityControllers.forEach((_, controller) {
      controller.dispose();
    });
    super.onClose();
  }

  // Método para obtener todos los libros
  Future<void> getAllBooks() async {
    isLoading.value = true;
    try {
      final result = await _booksService.getAll();
      if (!result['error']) {
        // La búsqueda fue exitosa
        searchResults.assignAll(result['data']);
        isSearching.value = searchResults.isNotEmpty;
      } else {
        Get.snackbar(
          'Error',
          'No se pudieron obtener los libros: ${result['message']}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al buscar libros: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search books by title or barcode
  void searchBooks(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    isLoading.value = true;

    try {
      // Intentamos primero buscar por código de barras exacto
      final barcodeResult = await _booksService.findByBarcode(query);

      if (!barcodeResult['error']) {
        // Si encontramos el libro por código de barras
        searchResults.clear();
        searchResults.add(barcodeResult['data']);
      } else {
        // Si no encontramos por código de barras, buscamos por similitud en el nombre
        final nameResult = await _booksService.findByNameSimilarity(query);

        if (!nameResult['error']) {
          searchResults.assignAll(nameResult['data']);
        } else {
          searchResults.clear();
          Get.snackbar(
            'Resultado',
            'No se encontraron libros que coincidan con "$query"',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al buscar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Search book by barcode (for scanner)
  Future<bool> searchByBarcode(String barcode) async {
    isLoading.value = true;
    try {
      final result = await _booksService.findByBarcode(barcode);

      if (!result['error']) {
        // La búsqueda fue exitosa
        searchResults.clear();
        searchResults.add(result['data']);
        isSearching.value = true;
        return true;
      } else {
        // Eliminamos el mensaje de snackbar aquí para evitar duplicados
        // El mensaje lo mostrará la vista (CartView)
        searchResults.clear();
        isSearching.value = false;
        return false;
      }
    } catch (e) {
      // Mantenemos este snackbar para errores inesperados, no para "no encontrado"
      Get.snackbar(
        'Error',
        'Error al buscar por código de barras: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      searchResults.clear();
      isSearching.value = false;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Add book to cart
  void addToCart(Book book) {
    final existingIndex = items.indexWhere((item) => item.id == book.id);

    if (existingIndex >= 0) {
      // Book already in cart, increment quantity
      quantities[book.id] = (quantities[book.id] ?? 1) + 1;
      quantityControllers[book.id]?.text = quantities[book.id].toString();
      quantities.refresh();
    } else {
      // Add new book to cart
      items.add(book);
      quantities[book.id] = 1;

      // Crear un nuevo controlador para este libro
      final controller = TextEditingController(text: '1');
      quantityControllers[book.id] = controller;
    }

    // Clear search and show the cart
    searchController.clear();
    searchResults.clear();
    isSearching.value = false;
  }

  // Remove book from cart
  void removeFromCart(String id) {
    items.removeWhere((item) => item.id == id);
    quantities.remove(id);

    // Eliminar y disponer el controlador asociado
    final controller = quantityControllers[id];
    if (controller != null) {
      controller.dispose();
      quantityControllers.remove(id);
    }
  }

  // Increase book quantity
  void increaseQuantity(String id) {
    if (quantities.containsKey(id)) {
      quantities[id] = quantities[id]! + 1;
      quantityControllers[id]?.text = quantities[id].toString();
      quantities.refresh();
    }
  }

  // Decrease book quantity
  void decreaseQuantity(String id) {
    if (quantities.containsKey(id) && quantities[id]! > 1) {
      quantities[id] = quantities[id]! - 1;
      quantityControllers[id]?.text = quantities[id].toString();
      quantities.refresh();
    } else if (quantities.containsKey(id) && quantities[id]! == 1) {
      // If quantity becomes 0, remove the item
      removeFromCart(id);
    }
  }

  // Set specific quantity for a book
  void setQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeFromCart(id);
      return;
    }

    if (quantities.containsKey(id)) {
      quantities[id] = quantity;
      quantityControllers[id]?.text = quantity.toString();
      quantities.refresh();
    }
  }

  // Get quantity for a specific book
  int getQuantity(String id) {
    return quantities[id] ?? 1;
  }

  // Get total price for a specific book
  double getBookTotalPrice(Book book) {
    return book.precio * (quantities[book.id] ?? 1);
  }

  // Toggle customer type (regular/supplier)
  void toggleCustomerType() {
    isSupplier.toggle();
  }

  // Update supplier discount
  void updateSupplierDiscount(double percentage) {
    supplierDiscountPercentage.value = percentage;
  }

  // Calculate subtotal
  double get subtotal {
    double total = 0;
    for (var book in items) {
      total += book.precio * (quantities[book.id] ?? 1);
    }
    return total;
  }

  // Calculate discount amount
  double get discountAmount {
    return isSupplier.value
        ? (subtotal * supplierDiscountPercentage.value / 100)
        : 0;
  }

  // Calculate total
  double get total {
    return subtotal - discountAmount;
  }

  // Upload or take a photo of payment receipt
  Future<void> getPaymentReceipt(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      paymentReceiptImage.value = File(image.path);
    }
  }

  // Clear payment receipt
  void clearPaymentReceipt() {
    paymentReceiptImage.value = null;
  }

  // Crear plan de pagos por defecto (sin validaciones)
  void generateDefaultInstallmentPlan() {
    // Ya no asignaremos valores por defecto, solamente crearemos el plan
    // con los valores actuales (que pueden estar vacíos)
    installmentPlan.value = InstallmentPlan(
      customerName: customerNameController.text,
      contactInfo: contactInfoController.text,
      notes: notesController.text,
    );
  }

  // Crear plan de pagos simplificado
  void createInstallmentPlan() {
    // Solo crearemos el plan si hay datos básicos del cliente
    if (customerNameController.text.isNotEmpty &&
        contactInfoController.text.isNotEmpty) {
      installmentPlan.value = InstallmentPlan(
        customerName: customerNameController.text,
        contactInfo: contactInfoController.text,
        notes: notesController.text,
      );
    }
  }

  // Actualizar la fecha de inicio
  void updateStartDate(DateTime date) {
    startDate.value = date;
  }

  // Generar resumen de información del cliente
  String generateInstallmentSummary() {
    if (!isInstallmentPayment.value || installmentPlan.value == null) {
      return "No hay información del cliente registrada";
    }

    final plan = installmentPlan.value!;

    String summary = "";
    summary += "Cliente: ${plan.customerName}\n";
    summary += "Contacto: ${plan.contactInfo}";

    if (plan.notes.isNotEmpty) {
      summary += "\n\nNotas: ${plan.notes}";
    }

    return summary;
  }

  // Complete purchase
  Future<void> completePurchase() async {
    // Si es pago a plazos, validamos los campos requeridos
    if (isInstallmentPayment.value) {
      // Validar nombre del cliente
      if (customerNameController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'El nombre del cliente es obligatorio para compras a plazos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validar información de contacto
      if (contactInfoController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'La información de contacto es obligatoria para compras a plazos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Crear un plan simplificado si no existe
      if (installmentPlan.value == null) {
        installmentPlan.value = InstallmentPlan(
          customerName: customerNameController.text,
          contactInfo: contactInfoController.text,
          notes: notesController.text,
        );
      }
    }

    await Future.delayed(const Duration(seconds: 1));

    String message = 'La compra se ha completado con éxito';
    if (isInstallmentPayment.value && installmentPlan.value != null) {
      message +=
          '. Plan de pagos registrado para ${installmentPlan.value!.customerName}';
    }

    // Clear the cart after purchase
    items.clear();
    quantities.clear();

    // Limpiar y disponer los controladores
    quantityControllers.forEach((_, controller) {
      controller.dispose();
    });
    quantityControllers.clear();

    paymentReceiptImage.value = null;
    isSupplier.value = false;
    isInstallmentPayment.value = false;
    installmentPlan.value = null;
    customerNameController.clear();
    contactInfoController.clear();
    notesController.clear();

    Get.snackbar(
      'Compra Realizada',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
