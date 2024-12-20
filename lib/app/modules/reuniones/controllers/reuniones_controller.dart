import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/reunion_model.dart';
import 'package:pan_de_vida/app/data/services/reuniones_service.dart';

class ReunionesController extends GetxController {
  var reuniones = <Reunion>[].obs;

  @override
  void onInit() {
    getReuniones();
    super.onInit();
  }

  getReuniones() async {
    var result = await ReunionesService().getReuniones();
    print(result);

    if (!result['error']) {
      reuniones.value = result['data'];
    } else {
      Get.snackbar('Error', result['mensaje']);
    }
  }
}
