import 'package:get/get.dart';
import '../controllers/subinventario_selection_controller.dart';

class SubinventarioSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubinventarioSelectionController>(
      () => SubinventarioSelectionController(),
    );
  }
}
