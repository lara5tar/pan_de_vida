import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
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
          return controller.congregant.value.codCongregant.isEmpty
              ? Center(
                  child: Text(
                    'Cargando...',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        controller.congregant.value.nombreF,
                        style: const TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                      text: 'Datos Personales',
                      icon: Icons.fingerprint,
                      onTap: () {
                        Get.toNamed(Routes.CONGREGANT_INFO);
                      },
                    ),
                    ButtonWidget(
                      text: 'Direccion',
                      icon: Icons.location_on,
                      onTap: () {
                        Get.toNamed(Routes.CONGREGANT_ADRESS);
                      },
                    ),
                    ButtonWidget(
                      text: 'Afirmacion',
                      icon: Icons.info,
                      onTap: () {
                        Get.toNamed(Routes.CONGREGANT_AFFIRMATION);
                      },
                    ),
                    ButtonWidget(
                      text: 'Asistencia',
                      icon: Icons.school,
                      onTap: () {
                        Get.toNamed(Routes.CONGREGANT_ATTENDANCE);
                      },
                      isLast: true,
                    ),
                  ],
                );
        },
      ),
    );
  }
}
