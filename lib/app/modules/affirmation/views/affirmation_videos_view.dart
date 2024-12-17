import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/build_group_attendance.dart';
import '../../../widgets/build_list_videos.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/affirmation_videos_controller.dart';

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
                  ...buildListVideo(
                    controller.videos,
                    controller.copyClipBoard,
                  ),
                  const SizedBox(height: 20),
                  ...buildGroupAttendance(controller.groupAttendance),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
