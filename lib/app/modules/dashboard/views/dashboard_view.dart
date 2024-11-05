import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/banner.jpg'),
            ),
          ),
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
                    Container(
                      color: Colors.blueGrey.withOpacity(0.7),
                      child: ListTile(
                        title: Text(
                          subItem['OPCION'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // subtitle: Text(subItem['URL']),
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
