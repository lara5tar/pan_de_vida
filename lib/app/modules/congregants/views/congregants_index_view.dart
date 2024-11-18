import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/routes/app_pages.dart';

import '../../../widgets/custom_scaffold.dart';
import '../controllers/congregants_index_controller.dart';

class CongregantsIndexView extends GetView<CongregantsIndexController> {
  const CongregantsIndexView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.getCongregants();
    return CustomScaffold(
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Mis 3'),
                  ),
                  for (var congregant in controller.ovejas)
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(congregant.nombre),
                        subtitle: Text(congregant.fecAlta),
                        onTap: () {
                          Get.toNamed(
                            Routes.CONGREGANT_PROFILE,
                            parameters: {'id': congregant.codCongregant},
                          );
                        },
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Los 3 de mis 3'),
                  ),
                  for (var congregant in controller.nietos)
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                            "${congregant.nombre}\n(${congregant.mentor})"),
                        subtitle: Text(congregant.fecAlta),
                        tileColor: Colors.red,
                        onTap: () {
                          Get.toNamed(Routes.CONGREGANT_PROFILE, parameters: {
                            'id': congregant.codCongregant,
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
