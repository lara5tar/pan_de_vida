import 'package:get/get.dart';
import '../../../data/models/book_model.dart';
import '../../../data/services/books_service.dart';
import 'books_controller.dart';

class BookDetailController extends GetxController {
  final BooksService booksService = BooksService();

  var book = Rx<Book?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Verificar si se pasó un libro
    if (Get.arguments != null && Get.arguments is Book) {
      book.value = Get.arguments;
    } else if (Get.arguments != null && Get.arguments is String) {
      // Si solo se pasó el ID del libro, cargarlo
      loadBook(Get.arguments);
    }
  }

  // Cargar libro por ID
  Future<void> loadBook(String id) async {
    isLoading(true);

    try {
      Book loadedBook = await booksService.getById(id);
      book.value = loadedBook;
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar el libro: $e');
    } finally {
      isLoading(false);
    }
  }

  // Navegar al formulario de edición
  void editBook() {
    if (book.value != null) {
      Get.toNamed('/books/form', arguments: book.value);
    }
  }

  // Eliminar libro
  Future<void> deleteBook() async {
    if (book.value != null) {
      isLoading(true);

      try {
        final result = await booksService.delete(book.value!.id);
        if (result['error'] == false) {
          Get.snackbar('Éxito', 'Libro eliminado correctamente');
          // Volver a la lista y actualizarla
          Get.back();
          Get.find<BooksController>().getBooks();
        } else {
          Get.snackbar('Error', 'No se pudo eliminar el libro');
        }
      } catch (e) {
        Get.snackbar('Error', 'Error al eliminar: $e');
      } finally {
        isLoading(false);
      }
    }
  }
}
