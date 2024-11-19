import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/loading_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

import '../../../routes/app_pages.dart';
import '../controllers/prospectos_controller.dart';

class ProspectosView extends GetView<ProspectosController> {
  const ProspectosView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: FloatingButtonWidget(
        onPressed: () {
          Get.toNamed(Routes.NEW_PROSPECTO);
        },
        icon: Icons.person_add,
      ),
      body: Obx(
        () => controller.prospectos.isEmpty
            ? const LoadingWidget()
            : ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const SizedBox(height: 20),
                  const TextTitleWidget('Prospectos'),
                  for (var prospecto in controller.prospectos)
                    ButtonWidget(
                      text: prospecto.nombre,
                      icon: Icons.person,
                      isLast: controller.prospectos.last == prospecto,
                      onTap: () {
                        controller.toProspectoVideos(prospecto);
                      },
                      trailingWidget: IconButton(
                        onPressed: () {
                          controller.deleteProspecto(prospecto.idProspecto);
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
      ),
    );
  }
}
