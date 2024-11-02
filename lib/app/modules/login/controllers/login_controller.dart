import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/routes/app_pages.dart';

import '../../../data/services/auth_service.dart';

class LoginController extends GetxController {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() {
    AuthService authService = AuthService();
    authService
        .login(userController.text, passwordController.text)
        .then((response) {
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
        Get.snackbar(
          'Bienvenido',
          'Ingreso exitoso',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        );
      }
    });
  }
}
