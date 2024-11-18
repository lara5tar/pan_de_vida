import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/congregants/controllers/congregant_adress_controller.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

class CongregantAdressView extends GetView<CongregantAdressController> {
  const CongregantAdressView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
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
