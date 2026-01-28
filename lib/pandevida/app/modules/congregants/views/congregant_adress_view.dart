import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/congregant_adress_controller.dart';

class CongregantAdressView extends GetView<CongregantAdressController> {
  const CongregantAdressView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextTitleWidget('Dirección'),
            ButtonWidget(
              icon: Icons.home,
              title: 'Calle',
              text: controller.congregant.calle,
            ),
            ButtonWidget(
              icon: Icons.directions,
              title: 'Entre Calles',
              text: controller.congregant.entreCalles,
            ),
            ButtonWidget(
              icon: Icons.apartment,
              title: 'Colonia',
              text: controller.congregant.colonia,
            ),
            ButtonWidget(
              icon: Icons.numbers_rounded,
              title: 'Codigo Postal',
              text: controller.congregant.codPostal,
            ),
            ButtonWidget(
              icon: Icons.location_on,
              title: 'Ciudad',
              text: controller.congregant.ciudad,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
