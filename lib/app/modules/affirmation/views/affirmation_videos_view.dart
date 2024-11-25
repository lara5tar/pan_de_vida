import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/affirmation/controllers/affirmation_videos_controller.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/loading_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

import '../../../widgets/text_subtitle_widget.dart';

class AffirmationVideosView extends GetView<AffirmationVideosController> {
  const AffirmationVideosView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const SizedBox(height: 20),
                  for (var video in controller.videos)
                    ButtonWidget(
                      title: 'Video #${video.numvideo}',
                      text: video.status,
                      icon: Icons.play_arrow,
                      colorIcon: video.status == 'TERMINADO'
                          ? Colors.green
                          : Colors.red,
                      onTap: () {
                        controller.copyClipBoard(video.url, video.codvideo);
                      },
                      isLast: controller.videos.last == video,
                    ),
                  const SizedBox(height: 20),
                  const TextTitleWidget('Grupo de Vida'),
                  ButtonWidget(
                    title: 'Red',
                    text: controller.groupAttendance.red,
                    icon: Icons.public,
                  ),
                  ButtonWidget(
                    title: 'Sub-Red',
                    text: controller.groupAttendance.subRed,
                    icon: Icons.device_hub_rounded,
                  ),
                  ButtonWidget(
                    title: 'Grupo de Vida',
                    text: controller.groupAttendance.gpoVida,
                    icon: Icons.eco,
                    isLast: true,
                  ),
                  const TextSubtitleWidget('Asistencias'),
                  if (controller.groupAttendance.asistencias.isEmpty)
                    const ButtonWidget(
                      text: 'Sin asistencias',
                      icon: Icons.close,
                      isLast: true,
                    ),
                  for (var item in controller.groupAttendance.asistencias)
                    ButtonWidget(
                      text: item.fecha,
                      icon: item.asistencia ? Icons.check : Icons.close,
                      colorIcon: item.asistencia ? Colors.green : Colors.red,
                      colorText: item.asistencia ? Colors.green : Colors.red,
                      isLast:
                          controller.groupAttendance.asistencias.last == item,
                    ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
