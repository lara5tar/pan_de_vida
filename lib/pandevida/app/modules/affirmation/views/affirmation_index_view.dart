import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/pandevida/app/widgets/loading_widget.dart';
import 'package:pan_de_vida/pandevida/app/widgets/text_subtitle_widget.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/affirmation_index_controller.dart';

class AffirmationIndexView extends GetView<AffirmationIndexController> {
  const AffirmationIndexView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const TextTitleWidget('Mis Ovejas'),
                  if (controller.afirmaciones.isEmpty)
                    const TextSubtitleWidget('No hay afirmados'),
                  for (var congregant in controller.afirmaciones)
                    ButtonWidget(
                      text: congregant.nombre,
                      subtitle: congregant.fecAlta,
                      icon: Icons.person,
                      onTap: () {
                        controller
                            .toAffirmationVideos(congregant.codCongregant);
                      },
                      isLast: controller.afirmaciones.last == congregant,
                    ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
