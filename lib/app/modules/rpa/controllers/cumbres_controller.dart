import 'package:get/get.dart';

import '../../../data/services/cumbres_services.dart';

class CumbresController extends GetxController {
  final accion = ''.obs;
  final marcador = ''.obs;
  final comprmisoAccion = ''.obs;
  final compromisoPerosna = ''.obs;

  final listAcciones = [].obs;
  final listMarcadores = [].obs;
  final listCompromisosAccion = [].obs;
  final listCompromisosPersona = [].obs;

  @override
  void onInit() {
    getCumbreAcciones();
    getCumbreCompromisoAccion();
    super.onInit();
  }

  getCumbreAcciones() async {
    var result = await CumbresServices().getCumbreAcciones();

    if (!result['error']) {
      listAcciones.value = result['acciones'];
    }
  }

  getCumbreMarcadores(String idAccion) async {
    var result = await CumbresServices().getCumbreMarcadores(idAccion);

    if (!result['error']) {
      listMarcadores.value = result['marcadores'];
    }
  }

  getCumbreCompromisoAccion() async {
    var result = await CumbresServices().getCumbreCompromisoAccion();

    if (!result['error']) {
      listCompromisosAccion.value = result['cumbres'];
    }
  }

  getCumbreComprosimoPersona(String codAccion) async {
    var result = await CumbresServices().getCumbreCompromisoPersona(codAccion);

    if (!result['error']) {
      listCompromisosPersona.value = result['prospectos'];
    }
  }

  setCumbre() {
    var result = CumbresServices().setCumbre(accion.value, marcador.value,
        comprmisoAccion.value, compromisoPerosna.value);

    if (!result['error']) {
      Get.snackbar('Éxito', 'Cumbre creada');
    } else {
      Get.snackbar('Error', result['message']);
    }
  }
}
