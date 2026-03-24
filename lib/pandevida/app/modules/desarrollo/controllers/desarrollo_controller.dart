import 'package:get/get.dart';

import '../../../data/models/discipulo_model.dart';
import '../../../data/services/discipulos_service.dart';
import '../../../routes/app_pages.dart';

class DesarrolloController extends GetxController {
  final sinRegistro = <Discipulo>[].obs;
  final noMarcador = <Discipulo>[].obs;
  final marcador = <Discipulo>[].obs;

  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDiscipulos();
  }

  Future<void> loadDiscipulos() async {
    isLoading.value = true;
    errorMessage.value = '';
    sinRegistro.clear();
    noMarcador.clear();
    marcador.clear();

    try {
      final response = await DiscipulosService.getDiscipulos();

      if (response['error'] == false) {
        sinRegistro.assignAll(response['sinRegistro'] as List<Discipulo>);
        noMarcador.assignAll(response['noMarcador'] as List<Discipulo>);
        marcador.assignAll(response['marcador'] as List<Discipulo>);
      } else {
        errorMessage.value =
            response['message'] ?? 'Error al cargar los discípulos';
      }
    } catch (e) {
      errorMessage.value = 'Error inesperado: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void toPerfilDiscipulo(String codCongregante) {
    Get.toNamed(
      Routes.DESARROLLO_PERFIL,
      parameters: {'id': codCongregante, 'gen': '1'},
    );
  }

  bool get isEmpty =>
      sinRegistro.isEmpty && noMarcador.isEmpty && marcador.isEmpty;
}
