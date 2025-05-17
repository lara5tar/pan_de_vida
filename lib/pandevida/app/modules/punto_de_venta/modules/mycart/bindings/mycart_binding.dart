import 'package:get/get.dart';

import '../../../data/repositories/product_repository.dart';
import '../../../data/services/camera_service.dart';
import '../../../data/services/product_service.dart';
import '../controllers/mycart_controller.dart';

class MycartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MycartController>(
      () => MycartController(),
    );
    Get.put<CameraService>(
      CameraService(),
    );
    Get.lazyPut<ProductService>(
      () => ProductService(),
    );
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(),
    );
  }
}
