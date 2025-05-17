import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/build_group_attendance.dart';
import '../../../widgets/build_school_attendance.dart';
import '../../../widgets/custom_scaffold.dart';
import '../controllers/congregant_attandance_controller.dart';

class CongregantAttandanceView extends GetView<CongregantAttandanceController> {
  const CongregantAttandanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
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
    );
  }
}
