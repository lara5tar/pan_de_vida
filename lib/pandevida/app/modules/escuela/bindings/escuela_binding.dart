import 'package:get/get.dart';

import 'package:pan_de_vida/pandevida/app/modules/escuela/controllers/capturar_asistencia_controller.dart';
import 'package:pan_de_vida/pandevida/app/modules/escuela/controllers/capturar_pago_controller.dart';

class EscuelaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CapturarPagoController>(
      () => CapturarPagoController(),
    );
    Get.lazyPut<CapturarAsistenciaController>(
      () => CapturarAsistenciaController(),
    );
  }
}
