import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../../data/services/camera_service.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(
      () => CartController(),
    );
    // Registrar el CameraService para que esté disponible en CartView
    Get.lazyPut<CameraService>(
      () => CameraService(),
    );
  }
}
