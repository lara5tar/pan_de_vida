import 'package:get/get.dart';
import '../../../data/services/camera_service.dart';
import '../controllers/pos_view_controller.dart';

class PosViewBinding extends Bindings {
  @override
  void dependencies() {
    // Inicializar CameraService si no existe
    if (!Get.isRegistered<CameraService>()) {
      Get.put<CameraService>(
        CameraService(),
      );
    }

    Get.lazyPut<PosViewController>(
      () => PosViewController(),
    );
  }
}
