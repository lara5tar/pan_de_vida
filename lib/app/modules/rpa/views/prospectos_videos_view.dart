import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/prospectos_videos_controller.dart';

class ProspectosVideosView extends GetView<ProspectosVideosController> {
  const ProspectosVideosView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.videos.isEmpty
            ? const LoadingWidget()
            : Column(
                children: [
                  const SizedBox(height: 20),
                  const TextTitleWidget('Videos'),
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
                ],
              ),
      ),
    );
  }
}
