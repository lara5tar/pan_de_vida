import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/routes/app_pages.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

import '../../../widgets/custom_scaffold.dart';
import '../controllers/congregants_index_controller.dart';

class CongregantsIndexView extends GetView<CongregantsIndexController> {
  const CongregantsIndexView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.getCongregants();
    return CustomScaffold(
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const SizedBox(height: 20),
            const TextTitleWidget('Mis 3'),
            for (var congregant in controller.ovejas)
              ButtonWidget(
                text: congregant.nombre,
                subtitle: congregant.fecAlta,
                icon: Icons.person,
                onTap: () {
                  Get.toNamed(
                    Routes.CONGREGANT_PROFILE,
                    parameters: {'id': congregant.codCongregant},
                  );
                },
                isLast: controller.ovejas.last == congregant,
              ),
            const SizedBox(height: 20),
            const TextTitleWidget('Los 3 de mis 3'),
            for (var congregant in controller.nietos)
              ButtonWidget(
                text: '${congregant.nombre}\n(${congregant.mentor})',
                subtitle: congregant.fecAlta,
                icon: Icons.person,
                onTap: () {
                  Get.toNamed(
                    Routes.CONGREGANT_PROFILE,
                    parameters: {'id': congregant.codCongregant},
                  );
                },
                isLast: controller.nietos.last == congregant,
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
