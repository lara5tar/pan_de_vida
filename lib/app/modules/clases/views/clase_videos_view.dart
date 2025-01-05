import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/clases/controllers/clase_videos_controller.dart';

import '../../../widgets/build_list_videos.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_title_widget.dart';

class ClaseVideosView extends GetView<ClaseVideosController> {
  const ClaseVideosView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextTitleWidget(
                        'Clase #${controller.cuestionario.numClase}'),
                    ...buildListVideo(
                      controller.cuestionario.videos,
                      onTap: controller.toCuestionarioVideo,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButtonWidget(
                      onPressed: controller.toCuestionario,
                      text: 'Contestar cuestionario',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
