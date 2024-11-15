import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/congregant_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../controllers/congregants_controller.dart';

class CongregantProfileView extends GetView<CongregantsController> {
  const CongregantProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    var parameters = Get.parameters;
    Congregant congregant =
        Congregant.fromJsonString(parameters['congregant'].toString());
    return CustomScaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          const BannerWidget(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              congregant.name,
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

class ButtonWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final bool isLast;
  const ButtonWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(icon, size: 20),
                  ),
                  Text(title),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 20),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                  const SizedBox(width: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
