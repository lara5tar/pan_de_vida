import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../data/services/books_service.dart';
import '../../../data/models/book_model.dart';
import 'books_controller.dart';

class BookFormController extends GetxController {
  final BooksService booksService = BooksService();

  // Controladores de texto para el formulario
  late TextEditingController
      idController; // Solo para edición, no para nuevos libros
  late TextEditingController nombreController;
  late TextEditingController precioController;
  late TextEditingController cantidadController;
  late TextEditingController
      codigoBarrasController; // Nuevo controlador para código de barras

  // Estados observables
  var isLoading = false.obs;
  var isEditing = false.obs;
  var currentBook = Rx<Book?>(null);
  var isScanning = false.obs;

  @override
  void onInit() {
    super.onInit();

    idController = TextEditingController();
    nombreController = TextEditingController();
    precioController = TextEditingController();
    cantidadController = TextEditingController();
    codigoBarrasController =
        TextEditingController(); // Inicializar controlador de código de barras

    // Verificar si se pasó un libro para editar
    if (Get.arguments != null && Get.arguments is Book) {
      currentBook.value = Get.arguments as Book;
      isEditing.value = true;

      // Cargar datos del libro en los controladores
      idController.text = currentBook.value!.id;
      nombreController.text = currentBook.value!.nombre;
      precioController.text = currentBook.value!.precio.toString();
      cantidadController.text = currentBook.value!.cantidadEnStock.toString();
      codigoBarrasController.text =
          currentBook.value!.codigoBarras; // Cargar código de barras
    }
  }

  @override
  void onClose() {
    idController.dispose();
    nombreController.dispose();
    precioController.dispose();
    cantidadController.dispose();
    codigoBarrasController
        .dispose(); // Liberar el controlador de código de barras
    super.onClose();
  }

  // Guardar o actualizar un libro
  Future<void> saveBook() async {
    if (nombreController.text.isEmpty ||
        precioController.text.isEmpty ||
        cantidadController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Los campos nombre, precio y cantidad son obligatorios',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      // Crear un objeto libro con los datos del formulario
      final book = Book(
        // El ID solo se utiliza en modo edición, para nuevos libros será generado por Firebase
        id: isEditing.value ? idController.text.trim() : '',
        nombre: nombreController.text.trim(),
        precio: double.parse(precioController.text.trim()),
        cantidadEnStock: int.parse(cantidadController.text.trim()),
        codigoBarras:
            codigoBarrasController.text.trim(), // Guardar código de barras
      );

      Map<String, dynamic> result;

      if (isEditing.value) {
        // Actualizar libro existente
        result = await booksService.update(book);
      } else {
        // Crear nuevo libro con ID automático
        result = await booksService.add(book);
      }

      if (result['error'] == false) {
        Get.back();
        Get.snackbar(
          'Éxito',
          isEditing.value
              ? 'Libro actualizado correctamente'
              : 'Libro creado correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Volver a la lista y actualizar

        Get.find<BooksController>().getBooks();
      } else {
        Get.snackbar(
          'Error',
          'No se pudo ${isEditing.value ? 'actualizar' : 'crear'} el libro',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Eliminar libro
  Future<void> deleteBook() async {
    if (currentBook.value == null) {
      Get.snackbar(
        'Error',
        'No se puede eliminar un libro que no existe',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      final String bookId = currentBook.value!.id;
      final result = await booksService.delete(bookId);

      if (result['error'] == false) {
        Get.back();
        Get.snackbar(
          'Éxito',
          'Libro eliminado correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Volver a la lista y actualizar

        Get.find<BooksController>().getBooks();
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el libro: ${result['message'] ?? "Error desconocido"}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al eliminar el libro: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Iniciar escaneo de código QR o de barras
  void startScanning() {
    isScanning(true);
  }

  // Detener escaneo
  void stopScanning() {
    isScanning(false);
  }

  // Manejar código detectado
  void onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty &&
        capture.barcodes.first.rawValue != null) {
      final code = capture.barcodes.first.rawValue!;
      codigoBarrasController.text =
          code; // Ahora asigna al código de barras en vez del ID
      stopScanning();
      Get.back();

      Get.snackbar(
        'Código detectado',
        'Código de barras: $code',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
}
