import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/reunion_model.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';
import 'package:pan_de_vida/core/utils/print_debug.dart';

import '../../../routes/app_pages.dart';
import '../controllers/reuniones_controller.dart';

class ReunionesView extends GetView<ReunionesController> {
  const ReunionesView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const TextTitleWidget('Reuniones'),
              for (Reunion reunion in controller.reuniones)
                ButtonWidget(
                  text: reunion.tema,
                  subtitle: '${reunion.predicador} - ${reunion.total}',
                  trailing: '${reunion.dia} ${reunion.mes}',
                  trailingWidget: IconButton(
                    icon:
                        Icon(Icons.edit_outlined, color: Colors.blue.shade900),
                    onPressed: () {
                      printD(reunion.toJson());
                      Get.toNamed(
                        Routes.REUNION_FORM,
                        arguments: reunion.toJson(),
                      );
                    },
                  ),
                  icon: Icons.calendar_month,
                  colorIcon: Colors.blue.shade900,
                  onTap: () {},
                  isLast: controller.reuniones.last == reunion,
                ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () {
          Get.toNamed(Routes.REUNION_FORM);
        },
        icon: Icons.add,
      ),
    );
  }
}
