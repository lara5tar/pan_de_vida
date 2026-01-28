import 'package:get/get.dart';
import '../controllers/search_view_controller.dart';

class SearchViewBinding extends Bindings {
  @override
  void dependencies() {
    // Registrar el controlador de búsqueda
    Get.lazyPut<SearchViewController>(
      () => SearchViewController(),
    );
  }
}
