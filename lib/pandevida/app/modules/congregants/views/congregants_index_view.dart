import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/congregants_index_controller.dart';

class CongregantsIndexView extends GetView<CongregantsIndexController> {
  const CongregantsIndexView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.getCongregants();
    return CustomScaffold(
      body: Obx(
        () => controller.isLoadning.value
            ? const LoadingWidget()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // GroupButton(
                    //   controller: controller.groupButtonController,
                    //   onSelected: (name, index, isSelected) =>
                    //       print('$index button is selected $isSelected'),
                    //   buttons: const [
                    //     'Mis 3',
                    //     'Los 3 de mis 3',
                    //   ],
                    //   options: const GroupButtonOptions(
                    //     selectedTextStyle: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //     selectedColor: Colors.blue,
                    //     unselectedColor: Colors.white,
                    //     unselectedBorderColor: Colors.blue,
                    //   ),
                    // ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(0),
                        children: [
                          const TextTitleWidget('Mis 3'),
                          if (controller.ovejas.isEmpty)
                            const TextSubtitleWidget('No hay congregantes'),
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
                          if (controller.nietos.isEmpty)
                            const TextSubtitleWidget('No hay congregantes'),
                          for (var congregant in controller.nietos)
                            ButtonWidget(
                              title: '(${congregant.mentor})',
                              text: congregant.nombre,
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
                  ],
                ),
              ),
      ),
    );
  }
}
