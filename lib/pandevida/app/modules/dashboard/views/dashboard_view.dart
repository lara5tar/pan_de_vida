import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custom_scaffold.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: CustomLeadingButton(
        icon: Icons.power_settings_new_outlined,
        onPressed: () {
          Get.offAllNamed(Routes.LANDING);
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 20),
          for (var item in controller.getMenu())
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    color: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Text(
                          item['MENU'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (var subItem in item['OPCIONES'])
                    InkWell(
                      onTap: () {
                        final rawUrl = subItem['URL'].toString();
                        final route =
                            '/${rawUrl.replaceAll(RegExp(r'^/+'), '')}';
                        Get.toNamed(route);
                      },
                      child: Container(
                        color: Colors.blueGrey.withOpacity(0.7),
                        child: ListTile(
                          title: Text(
                            subItem['OPCION'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
