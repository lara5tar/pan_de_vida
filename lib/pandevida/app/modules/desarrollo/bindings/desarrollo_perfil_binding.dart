import 'package:get/get.dart';

import '../../congregants/controllers/congregant_profile_controller.dart';

/// Binding específico para la ruta DESARROLLO_PERFIL.
/// Usa [fenix: true] para que GetX siempre cree una nueva instancia del
/// [CongregantProfileController] al navegar a esta ruta, en lugar de
/// reutilizar la instancia que puede haber quedado de [CONGREGANT_PROFILE].
class DesarrolloPerfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CongregantProfileController>(
      () => CongregantProfileController(),
      fenix: true,
    );
  }
}
