import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => ListView(
          children: [
            for (var item in controller.menu)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(item['MENU']),
                    for (var subItem in item['OPCIONES'])
                      ListTile(
                        title: Text(subItem['OPCION']),
                        subtitle: Text(subItem['URL']),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
