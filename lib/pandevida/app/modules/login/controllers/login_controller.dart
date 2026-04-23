import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import '../../../../core/values/keys.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/congregante_service.dart';
import '../../../data/services/test_ministerio_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService authService = AuthService();

  var isLogged = false.obs;
  String? get user => authService.getUser;

  @override
  void onInit() {
    isLogged.value = authService.isLogged;
    super.onInit();
  }

  Future<void> logout() async {
    authService.logout();
    isLogged.value = false;
  }

  Future<void> login() async {
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

    if (authService.isLogged) {
      var response = await authService.checkPassword(passwordController.text);

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
        Get.offAllNamed(Routes.DASHBOARD);
      }

      return;
    }

    var response = await authService.login(
      userController.text,
      passwordController.text,
    );

    if (response['error'] == true) {
      Get.back();
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
      CongregantService congreganteService = CongregantService();
      response = await congreganteService.getMenu();

      Get.back();

      if (response['error'] == false) {
        final testResponse =
            await TestMinisterioService.verificarAsignacion();
        if (!testResponse['error'] &&
            testResponse['mostrar_boton'] == true) {
          final box = GetStorage(Keys.LOGIN_KEY);
          List menu = box.read('menu') ?? [];
          menu.add({
            'MENU': 'TEST DE MINISTERIOS',
            'OPCIONES': [
              {
                'OPCION': 'CONTESTAR TEST',
                'URL': Routes.TEST_MINISTERIO,
              }
            ]
          });
          await box.write('menu', menu);
          await box.write(
              'test_ministerio_estado', testResponse['estado']);
        }
      }

      if (response['error'] == true) {
        Get.back();
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
