import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/button_widget.dart';
import '../controllers/congregant_profile_controller.dart';

class CongregantProfileView extends GetView<CongregantProfileController> {
  const CongregantProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () {
          return controller.isLoading.value
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cargando...',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CircularProgressIndicator(
                        color: Colors.blue.shade900,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        controller.congregant.nombreF,
                        style: const TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                      text: 'Datos Personales',
                      icon: Icons.fingerprint,
                      onTap: controller.toCongregantInfo,
                    ),
                    ButtonWidget(
                      text: 'Direccion',
                      icon: Icons.location_on,
                      onTap: controller.toCongregantAdress,
                    ),
                    ButtonWidget(
                      text: 'Afirmacion',
                      icon: Icons.info,
                      onTap: controller.toCongregantAffirmations,
                    ),
                    ButtonWidget(
                      text: 'Asistencia',
                      icon: Icons.school,
                      onTap: controller.toCongrengatAttendance,
                      isLast: true,
                    ),
                  ],
                );
        },
      ),
    );
  }
}
