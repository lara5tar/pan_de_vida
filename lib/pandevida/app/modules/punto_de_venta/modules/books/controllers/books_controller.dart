import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/services/books_service.dart';
import '../../../data/models/book_model.dart';

class BooksController extends GetxController {
  final BooksService booksService = BooksService();

  // Estados observables
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var books = <Book>[].obs;
  var searchQuery = ''.obs;

  // Variables para paginación
  var currentPage = 0.obs;
  final int booksPerPage = 10;

  @override
  void onInit() {
    getBooks();
    super.onInit();
  }

  // Buscar libros por nombre
  List<Book> get filteredBooks {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      return books;
    }
    return books
        .where((book) =>
            book.nombre.toLowerCase().contains(query) ||
            book.id.toLowerCase().contains(query))
        .toList();
  }

  // Libros de la página actual
  List<Book> get paginatedBooks {
    final filtered = filteredBooks;
    final startIndex = currentPage.value * booksPerPage;

    if (filtered.isEmpty) {
      return [];
    }

    if (startIndex >= filtered.length) {
      // Si el índice de inicio está fuera de rango, volver a la primera página
      currentPage.value = 0;
      return paginatedBooks;
    }

    final endIndex = (startIndex + booksPerPage <= filtered.length)
        ? startIndex + booksPerPage
        : filtered.length;

    return filtered.sublist(startIndex, endIndex);
  }

  // Número total de páginas
  int get totalPages => (filteredBooks.length / booksPerPage).ceil();

  // Ir a la página anterior
  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  // Ir a la página siguiente
  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
    }
  }

  // Ir a una página específica
  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      currentPage.value = page;
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
        currentPage.value =
            0; // Resetear a la primera página al cargar nuevos datos
      } else {
        hasError(true);
        errorMessage.value = 'No se pudieron cargar los libros';
      }
    } catch (e) {
      hasError(true);
      errorMessage.value = 'Error al cargar libros: $e';
      debugPrint('Error al cargar libros: $e');
    } finally {
      isLoading(false);
    }
  }

  // Eliminar un libro
  Future<void> deleteBook(String id) async {
    try {
      final result = await booksService.delete(id);
      if (result['error'] == false) {
        books.removeWhere((book) => book.id == id);
        Get.snackbar(
          'Éxito',
          'Libro eliminado correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el libro',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al eliminar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Navegar al formulario de edición
  void goToEditBook(Book book) {
    Get.toNamed('/books/form', arguments: book);
  }

  // Navegar al formulario de creación
  void goToCreateBook() {
    Get.toNamed('/books/form');
  }

  // Navegar al detalle de un libro
  void goToBookDetail(Book book) {
    Get.toNamed('/books/detail', arguments: book);
  }

  // Refrescar la lista de libros
  Future<void> refreshBooks() async {
    return await getBooks();
  }

  // Función de prueba para agregar libros predeterminados
  Future<void> addTestBooks() async {
    isLoading(true);
    hasError(false);

    try {
      // Lista de libros a agregar
      final testBooks = [
        Book(id: 'SCC-001', nombre: 'SCC', precio: 200.0, cantidadEnStock: 10),
        Book(
            id: 'AFI-001',
            nombre: 'Afirmadores',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'RYS-001',
            nombre: 'Reyes y Sacerdotes',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'INC-001',
            nombre: 'Incursionando',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'RDG-001',
            nombre: 'Reino de Dios o reino de h',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'RAI-001',
            nombre: 'Raíces',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'EDM-001',
            nombre: 'Escuela de maestros',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'STK-001',
            nombre: 'Stickers',
            precio: 50.0,
            cantidadEnStock: 20),
        Book(
            id: 'CDC-001',
            nombre: 'Caracter de conquistador',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'ETV-001',
            nombre: 'Equilibra tu vida',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'PEC-001',
            nombre: 'Preparando el camino',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'ARR-001',
            nombre: 'Arrebatando el reino',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'MAF-001',
            nombre: 'Mujer afirma tu fe',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'MAS-001',
            nombre: 'M atrapa tus sueños',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'MCE-001',
            nombre: 'M camina en equilibrio',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'CDD-001',
            nombre: 'Cambio de domicilio',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'RRA-001',
            nombre: 'Reforma, reino y avivamiento',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'RRL-001',
            nombre: 'Reforma, reino y libertad',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'EPG-001',
            nombre: 'Entrenándonos para gobernar',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'RDY-001', nombre: 'Ready', precio: 200.0, cantidadEnStock: 10),
        Book(
            id: 'MET-001',
            nombre: 'Metamorfosis',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'SAE-001',
            nombre: 'Saetas',
            precio: 200.0,
            cantidadEnStock: 10),
        Book(
            id: 'RST-001',
            nombre: 'Restaurando',
            precio: 200.0,
            cantidadEnStock: 10),
      ];

      int successCount = 0;
      int errorCount = 0;

      // Agregar cada libro
      for (var book in testBooks) {
        try {
          final result = await booksService.add(book);
          if (result['error'] == false) {
            successCount++;
          } else {
            errorCount++;
            debugPrint(
                'Error al agregar libro ${book.nombre}: ${result['message']}');
          }
        } catch (e) {
          errorCount++;
          debugPrint('Error al agregar libro ${book.nombre}: $e');
        }
      }
      // Mostrar resultado
      Get.snackbar(
        'Proceso completado',
        'Se agregaron $successCount libros correctamente. Errores: $errorCount',
        backgroundColor: successCount > 0 ? Colors.green : Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      // Refrescar la lista de libros
      await getBooks();
    } catch (e) {
      hasError(true);
      errorMessage.value = 'Error al agregar libros: $e';
      debugPrint('Error al agregar libros de prueba: $e');
      Get.snackbar(
        'Error',
        'Error al agregar libros: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
