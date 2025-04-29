import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/restauracion/controllers/restauracion_congregante_controller.dart';
import 'package:pan_de_vida/app/widgets/build_school_attendance.dart';

import '../../../widgets/custom_scaffold.dart';

class RestauracionCongreganteView
    extends GetView<RestauracionCongreganteController> {
  const RestauracionCongreganteView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ...buildSchoolAttendance(controller.schoolAttendance.value),
                  ],
                ),
              ),
      ),
    );
  }
}
