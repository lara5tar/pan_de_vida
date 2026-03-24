import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/build_group_attendance.dart';
import '../../../widgets/build_school_attendance.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/desarrollo_asistencias_controller.dart';

class DesarrolloAsistenciasView
    extends GetView<DesarrolloAsistenciasController> {
  const DesarrolloAsistenciasView({super.key});

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
                    ...buildGroupAttendance(controller.groupAttendance),
                    const SizedBox(height: 20),
                    ...buildSchoolAttendance(controller.schoolAttendance),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
