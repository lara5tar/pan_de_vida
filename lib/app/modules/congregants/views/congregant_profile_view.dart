import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/congregants/controllers/congregant_profile_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../widgets/button_widget.dart';

class CongregantProfileView extends GetView<CongregantProfileController> {
  const CongregantProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: controller.congregant.id == 'N/A'
          ? Center(
              child: Text(
                'Hubo un error al cargar el perfil',
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
                    controller.congregant.name,
                    style: const TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                  title: 'Datos Personales',
                  icon: Icons.fingerprint,
                  onTap: () {
                    Get.toNamed(Routes.CONGREGANT_INFO);
                  },
                ),
                ButtonWidget(
                  title: 'Direccion',
                  icon: Icons.location_on,
                  onTap: () {
                    Get.toNamed(Routes.CONGREGANT_ADRESS);
                  },
                ),
                ButtonWidget(
                  title: 'Afirmacion',
                  icon: Icons.info,
                  onTap: () {
                    Get.toNamed(Routes.CONGREGANT_AFFIRMATION);
                  },
                ),
                ButtonWidget(
                  title: 'Asistencia',
                  icon: Icons.school,
                  onTap: () {
                    Get.toNamed(Routes.CONGREGANT_ATTENDANCE);
                  },
                  isLast: true,
                ),
              ],
            ),
    );
  }
}
