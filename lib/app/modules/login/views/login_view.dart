import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/password_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImage: 'assets/background_login.jpg',
      setBrightnessDark: false,
      setBanner: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/pandevida_logo.png',
              height: 200,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              margin: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Obx(
                () => Column(
                  children: [
                    if (controller.isLogged.value) ...[
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Bienvenido, ${controller.user}...',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 40),
                      CustomTextField(
                        'Usuario',
                        controller: controller.userController,
                      ),
                    ],
                    const SizedBox(height: 20),
                    PasswordField(
                      controller: controller.passwordController,
                      onEditingComplete: () {
                        controller.login();
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButtonWidget(
                      text: 'Ingresar al sistema',
                      onPressed: () {
                        controller.login();
                      },
                    ),
                    const SizedBox(height: 10),
                    if (controller.isLogged.value) ...[
                      TextButton(
                        onPressed: () {
                          controller.logout();
                        },
                        child: Text(
                          'Cerrar sessión',
                          style: TextStyle(color: Colors.blue.shade800),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ] else
                      const SizedBox(height: 30),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
