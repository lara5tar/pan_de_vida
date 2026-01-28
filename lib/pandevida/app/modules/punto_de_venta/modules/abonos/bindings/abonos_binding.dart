import 'package:get/get.dart';
import '../controllers/abonos_controller.dart';

class AbonosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbonosController>(() => AbonosController());
  }
}
