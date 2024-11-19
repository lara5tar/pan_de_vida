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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    CustomTextField(
                      'Usuario',
                      controller: controller.userController,
                    ),
                    const SizedBox(height: 20),
                    PasswordField(
                      controller: controller.passwordController,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButtonWidget(
                      text: 'Ingresar al sistema',
                      onPressed: () {
                        controller.login();
                      },
                    ),
                    const SizedBox(height: 40),
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
