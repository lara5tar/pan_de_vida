import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/services/congregante_service.dart';
import 'package:pan_de_vida/app/routes/app_pages.dart';

import '../../../data/services/auth_service.dart';

class LoginController extends GetxController {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    AuthService authService = AuthService();

    Get.dialog(
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Text('Iniciando sesión...'),
          ],
        ),
      ),
    );

    var response = await authService.login(
      userController.text,
      passwordController.text,
    );

    if (response['error'] == true) {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text('${response['message']}'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } else {
      CongreganteService congreganteService = CongreganteService();
      response = await congreganteService.getMenu();

      Get.back();

      if (response['error'] == true) {
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: Text('${response['message']}'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      } else {
        Get.toNamed(Routes.DASHBOARD);
      }
    }
  }
}
