import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pan_de_vida/pandevida/core/values/keys.dart';

import '../../../data/models/affirmation_model.dart';
import '../../../data/models/group_attendance_model.dart';
import '../../../data/models/congregant_model.dart';
import '../../../data/models/school_attendace_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/congregante_service.dart';
import '../../../routes/app_pages.dart';

class CongregantProfileController extends GetxController {
  var isLoading = true.obs;

  var congregant = Congregant.empty();
  var groupAttendance = GroupAttendace.empty();
  var schoolAttendance = SchoolAttendace.empty();
  var affirmation = Affirmation.empty();

  // Elegidos
  var isElegido = false.obs;
  var isTogglingElegido = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getCongregant();
    await getGruopAttandace();
    await getSchoolAttandace();
    await getAffirmations();
    await checkIfElegido();
  }

  getCongregant() async {
    var parameters = Get.parameters;
    print(parameters);

    if (parameters['id'] != null) {
      var response =
          await CongregantService().getCongregant(parameters['id'].toString());
      print(response);

      if (!response['error']) {
        congregant = response['congregant'];
      }
    }
  }

  getGruopAttandace() async {
    var parameters = Get.parameters;

    if (parameters['id'] != null) {
      print('=== CongregantProfileController - GroupAttendance ===');
      print('ID enviado: ${parameters['id']}');
      print('URL: ${Keys.URL_SERVICE}/grupoVida/obtener_asistencia');
      print('Body: {codCongregante: ${parameters['id']}}');
      var response = await CongregantService()
          .getGroupAttendance(parameters['id'].toString());

      print('GroupAttendance response: $response');
      if (!response['error']) {
        groupAttendance = response['attendance'];
      }
    }
  }

  getSchoolAttandace() async {
    var parameters = Get.parameters;

    if (parameters['id'] != null) {
      print('=== CongregantProfileController - SchoolAttendance ===');
      print('ID enviado: ${parameters['id']}');
      print('URL: ${Keys.URL_SERVICE}/escuela/obtener_asistencia');
      print('Body: {codCongregante: ${parameters['id']}}');
      var response = await CongregantService()
          .getSchoolAttandance(parameters['id'].toString());

      print('SchoolAttendance response: $response');
      if (!response['error']) {
        schoolAttendance = response['attendance'];
      }
    }
    isLoading(false);
  }

  getAffirmations() async {
    var response =
        await CongregantService().getAffirmation(congregant.codCongregant);

    if (!response['error'] && response['data'] != null) {
      affirmation = response['data'];
    }
  }

  /// Verifica si el discípulo actual es un elegido del mentor logueado
  Future<void> checkIfElegido() async {
    try {
      final codMentor = AuthService.getCodCongregante();
      final response = await CongregantService().getElegidos(codMentor);

      if (response['error'] == false && response['elegidos'] != null) {
        final List elegidos = response['elegidos'] as List;
        isElegido.value = elegidos.any(
          (e) => e['CODCONGREGANTE']?.toString() == congregant.codCongregant,
        );
      }
    } catch (e) {
      print('Error checking elegido: $e');
    }
  }

  /// Alterna el estado de elegido del discípulo
  Future<void> toggleElegido() async {
    if (isTogglingElegido.value) return;
    isTogglingElegido.value = true;

    try {
      final codMentor = AuthService.getCodCongregante();
      final codDiscipulo = congregant.codCongregant;

      Map<String, dynamic> response;

      if (isElegido.value) {
        // Quitar elegido
        response =
            await CongregantService().quitarElegido(codMentor, codDiscipulo);
      } else {
        // Agregar elegido
        response =
            await CongregantService().elegirDiscipulo(codMentor, codDiscipulo);
      }

      if (response['error'] == false) {
        isElegido.value = !isElegido.value;
        Get.snackbar(
          isElegido.value ? '⭐ Elegido' : 'Elegido removido',
          response['mensaje'] ?? '',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: isElegido.value
              ? Colors.amber.withValues(alpha: 0.9)
              : Colors.grey.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          response['mensaje'] ?? 'No se pudo completar la acción',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isTogglingElegido.value = false;
    }
  }

  toCongregantInfo() {
    Get.toNamed(Routes.CONGREGANT_INFO);
  }

  toCongregantAdress() {
    Get.toNamed(Routes.CONGREGANT_ADRESS);
  }

  toCongregantAffirmations() {
    Get.toNamed(Routes.CONGREGANT_AFFIRMATION);
  }

  toCongrengatAttendance() {
    Get.toNamed(Routes.CONGREGANT_ATTENDANCE);
  }

  toWhatsApp() async {
    String url =
        "https://wa.me/${congregant.cel}?text=${Uri.encodeComponent('Hola, ${congregant.nombre}')}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {}
  }

  toCall() async {
    final tel = Uri.parse('tel:${congregant.cel}');
    if (await canLaunchUrl(tel)) {
      await launchUrl(tel);
    }
  }
}
