import 'package:get/get.dart';

import '../controllers/books_controller.dart';
import '../controllers/book_form_controller.dart';
import '../controllers/book_detail_controller.dart';

class BooksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BooksController>(() => BooksController());
    Get.lazyPut<BookFormController>(() => BookFormController());
    Get.lazyPut<BookDetailController>(() => BookDetailController());
  }
}
