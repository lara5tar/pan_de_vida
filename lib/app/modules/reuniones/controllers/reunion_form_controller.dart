import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/services/reuniones_service.dart';
import 'package:pan_de_vida/app/routes/app_pages.dart';
import 'package:pan_de_vida/core/utils/calendar_utils.dart';

class ReunionFormController extends GetxController {
  int? idReunion;
  final fecha = TextEditingController();
  final tema = TextEditingController();
  final predicador = TextEditingController();
  final horaInicio = TextEditingController();
  final horaFin = TextEditingController();
  final ofrenda = TextEditingController();
  final totalCongregantes = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      var reunion = Get.arguments;
      idReunion = int.parse(reunion['IDREUNION']);
      String fechaReunion =
          '${reunion['ANIO']}-${getMonthInt(reunion['MES'])}-${reunion['DIA']}';

      fecha.text = fechaReunion;
      tema.text = reunion['TEMA'];
      predicador.text = reunion['PREDICADOR'];
      horaInicio.text = reunion['INICIO'];
      horaFin.text = reunion['FIN'];
      ofrenda.text = reunion['OFRENDA'];
      totalCongregantes.text = reunion['TOTAL'];
    }
  }

  guardar() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (fecha.text.isEmpty ||
        tema.text.isEmpty ||
        predicador.text.isEmpty ||
        horaInicio.text.isEmpty ||
        horaFin.text.isEmpty ||
        ofrenda.text.isEmpty ||
        totalCongregantes.text.isEmpty) {
      Get.back();

      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text('Todos los campos son requeridos'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }

    var result = {};

    if (idReunion == null) {
      result = await ReunionesService().setReunion(
        fecha.text,
        tema.text,
        predicador.text,
        horaInicio.text,
        horaFin.text,
        ofrenda.text,
        totalCongregantes.text,
      );
    } else {
      result = await ReunionesService().updateReunion(
        idReunion!,
        fecha.text,
        tema.text,
        predicador.text,
        horaInicio.text,
        horaFin.text,
        ofrenda.text,
        totalCongregantes.text,
      );
    }

    if (result['error']) {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(result['message']),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } else {
      Get.back();
      Get.toNamed(Routes.REUNION_ASISTENCIA, arguments: {
        'idReunion': result['idReunion'] ?? idReunion,
        'isUpdate': Get.arguments != null,
      });
    }
  }

  editarAsistentes() {
    Get.toNamed(Routes.REUNION_ASISTENCIA, arguments: {
      'idReunion': idReunion,
      'isUpdate': Get.arguments != null,
    });
  }
}
