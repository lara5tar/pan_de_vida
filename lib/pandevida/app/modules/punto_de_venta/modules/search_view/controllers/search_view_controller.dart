import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/book_model.dart';
import '../../../data/services/books_service.dart';
import '../../../widgets/confirm_dialog.dart';

class SearchViewController extends GetxController {
  final BooksService booksService = BooksService();

  // Estados observables
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var books = <Book>[].obs;
  var searchQuery = ''.obs;

  // Callback para devolver el libro seleccionado (usado desde POS)
  Function(Book)? onBookSelected;

  @override
  void onInit() {
    super.onInit();
    
    // Obtener el callback si fue pasado como argumento
    if (Get.arguments != null && Get.arguments['onBookSelected'] != null) {
      onBookSelected = Get.arguments['onBookSelected'];
    }
    
    getBooks();
  }

  // Buscar libros por nombre o código
  List<Book> get filteredBooks {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      return books;
    }
    return books
        .where((book) =>
            book.nombre.toLowerCase().contains(query) ||
            book.id.toLowerCase().contains(query) ||
            book.codigoBarras.toLowerCase().contains(query))
        .toList();
  }

  // Busca un libro por código exacto (útil para escaneos de códigos de barras)
  void findBookByExactCode(String code) {
    if (code.isEmpty) return;

    // Primero buscamos coincidencia exacta con el ID
    final exactMatch = books.firstWhereOrNull(
        (book) => book.id.toLowerCase() == code.toLowerCase());

    // Si encontramos una coincidencia exacta
    if (exactMatch != null) {
      // Mostrar un mensaje de éxito
      Get.snackbar(
        'Libro encontrado',
        'Se encontró el libro: ${exactMatch.nombre}',
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Si hay un callback, llamarlo (para agregar al carrito desde POS)
      if (onBookSelected != null) {
        onBookSelected!(exactMatch);
        // Volver atrás después de seleccionar
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.back();
        });
      }
    } else {
      // Si no hay coincidencia exacta
      if (filteredBooks.isEmpty) {
        Get.snackbar(
          'Sin resultados',
          'No se encontró ningún libro con el código: $code',
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
        );
      }
    }
  }

  // Obtener todos los libros
  Future<void> getBooks() async {
    isLoading(true);
    hasError(false);

    try {
      var data = await booksService.getAll();
      if (!data['error']) {
        books.clear();
        books.addAll(data['data']);
      } else {
        hasError(true);
        errorMessage.value = 'No se pudieron cargar los libros';
      }
    } catch (e) {
      hasError(true);
      errorMessage.value = 'Error al cargar libros: ${e.toString()}';
    } finally {
      isLoading(false);
    }
  }

  // Seleccionar un libro
  void selectBook(Book book) {
    if (onBookSelected != null) {
      // Si hay un callback (desde POS), usarlo
      confirmDialog(
        title: '¿Agregar libro?',
        content: '¿Deseas agregar "${book.nombre}" al carrito?',
        confirmAction: () {
          onBookSelected!(book);
          Get.back(); // Cerrar el diálogo
          Get.back(); // Volver al POS
          
          Get.snackbar(
            'Libro agregado',
            '${book.nombre} agregado al carrito',
            backgroundColor: Colors.green.shade700,
            colorText: Colors.white,
          );
        },
      );
    } else {
      // Si no hay callback, mostrar detalles
      goToBookDetail(book);
    }
  }

  // Navegar a los detalles del libro
  void goToBookDetail(Book book) {
    Get.toNamed(
      '/book-detail',
      arguments: {'book': book},
    );
  }

  // Limpiar búsqueda
  void clearSearch() {
    searchQuery.value = '';
  }

  // Recargar libros
  Future<void> refresh() async {
    await getBooks();
  }
}
