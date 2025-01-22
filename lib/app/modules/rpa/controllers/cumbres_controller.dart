import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/accion_model.dart';
import '../../../data/models/cumbre_model.dart';
import '../../../data/models/marcador_model.dart';
import '../../../data/models/prospecto_model.dart';
import '../../../data/services/cumbres_services.dart';

class CumbresController extends GetxController {
  final accion = ''.obs;
  final marcador = ''.obs;
  final comprmisoAccion = ''.obs;
  final compromisoPerosna = ''.obs;

  Accion accionObject = Accion.empty();
  Marcador marcadorObject = Marcador.empty();
  Cumbre comprmisoAccionObject = Cumbre.empty();
  Prospecto compromisoPerosnaObject = Prospecto.empty();

  final listAcciones = <Accion>[].obs;
  final listMarcadores = <Marcador>[].obs;
  final listCompromisosAccion = <Cumbre>[].obs;
  final listCompromisosPersona = <Prospecto>[].obs;

  @override
  void onInit() {
    getAcciones();
    getCompromisos();
    super.onInit();
  }

  onSelectAccion(value) {
    marcador.value = '';
    accionObject = value;
    getMarcadores(accionObject.idaccion);
  }

  onSelectMarcador(value) {
    marcadorObject = value;
  }

  onSelectCompromiso(value) {
    compromisoPerosna.value = '';
    comprmisoAccionObject = value;

    getPersonas(comprmisoAccionObject.codcumbre);
  }

  onSelectedPersona(value) {
    compromisoPerosnaObject = value;
  }

  getAcciones() async {
    var result = await CumbresServices.getCumbreAcciones();

    if (!result['error']) {
      listAcciones.value = result['acciones'];
    }
  }

  getMarcadores(String idAccion) async {
    var result = await CumbresServices.getCumbreMarcadores(idAccion);

    if (!result['error']) {
      listMarcadores.value = result['marcadores'];
    }
  }

  getCompromisos() async {
    var result = await CumbresServices.getCumbreCompromisoAccion();

    if (!result['error']) {
      listCompromisosAccion.value = result['cumbres'];
    }
  }

  getPersonas(String codCumbre) async {
    compromisoPerosna.value = '';
    var result = await CumbresServices.getCumbreCompromisoPersona(codCumbre);

    if (!result['error']) {
      listCompromisosPersona.value = result['prospectos'];
    }
  }

  setCumbre() async {
    Get.dialog(const Center(child: CircularProgressIndicator()));

    var result = await CumbresServices.setCumbre(
      accionObject.idaccion,
      marcadorObject.idmarcador,
      comprmisoAccionObject.codcumbre,
      compromisoPerosnaObject.idProspecto,
    );

    Get.back();

    if (!result['error']) {
      Get.dialog(
        AlertDialog(
          title: const Text('Éxito'),
          content: const Text('Cumbre registrada con éxito'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Aceptar'),
            )
          ],
        ),
      );
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text('Ocurrió un error al registrar la cumbre'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Aceptar'),
            )
          ],
        ),
      );
    }
  }
}
