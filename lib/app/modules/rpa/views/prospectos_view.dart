import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';
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
        () => controller.isLoading.value
            ? const LoadingWidget()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const TextTitleWidget('Prospectos'),
                  if (controller.prospectos.isEmpty)
                    const TextSubtitleWidget('No hay prospectos'),
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
