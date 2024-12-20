import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/services/reuniones_service.dart';
import 'package:pan_de_vida/core/utils/calendar_utils.dart';

class ReunionFormController extends GetxController {
  String? idReunion;
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
      idReunion = reunion['IDREUNION'].toString();
      String fechaReunion =
          '${reunion['DIA']}/${getMonthInt(reunion['MES'])}/${reunion['ANIO']}';

      fecha.text = fechaReunion;
      tema.text = reunion['TEMA'];
      predicador.text = reunion['PREDICADOR'];
      horaInicio.text = reunion['INICIO'];
      horaFin.text = reunion['FIN'];
      ofrenda.text = reunion['OFRENDA'];
      totalCongregantes.text = reunion['TOTAL'];
    }
  }

  guardar() {
    if (idReunion == null) {
      setReunion();
    } else {
      updateReunion();
    }
  }

  setReunion() async {
    var result = await ReunionesService().setReunion(
      fecha.text,
      tema.text,
      predicador.text,
      horaInicio.text,
      horaFin.text,
      ofrenda.text,
      totalCongregantes.text,
    );

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
    }
  }

  updateReunion() async {
    var result = await ReunionesService().updateReunion(
      idReunion!,
      fecha.text,
      tema.text,
      predicador.text,
      horaInicio.text,
      horaFin.text,
      ofrenda.text,
      totalCongregantes.text,
    );

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
    }
  }
}
