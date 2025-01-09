import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/congregant_model.dart';
import 'package:pan_de_vida/app/data/services/afirmacion_service.dart';
import 'package:pan_de_vida/app/routes/app_pages.dart';

class AffirmationIndexController extends GetxController {
  var afirmaciones = <Congregant>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getAfirmaciones();
  }

  getAfirmaciones() async {
    AfirmacionService afirmacionService = AfirmacionService();

    var result = await afirmacionService.getAfirmacionCongregantes();

    if (!result['error']) {
      afirmaciones.value = result['data'];
    }
    isLoading.value = false;
  }

  toAffirmationVideos(String codCongregante) async {
    Get.toNamed(Routes.AFFIRMATION_VIDEOS, arguments: codCongregante);
  }
}
