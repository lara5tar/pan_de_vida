import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../controllers/quiero_asistir_controller.dart';

class QuieroAsistirView extends GetView<QuieroAsistirController> {
  const QuieroAsistirView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImage: 'assets/background_login.jpg',
      setBrightnessDark: false,
      setBanner: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/pandevida_logo.png',
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Envíanos tu información y nos pondremos en contácto contigo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                // fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) => controller.nombre.value = value,
                    decoration: const InputDecoration(
                      prefixIcon: Text('Nombre: '),
                      hintText: 'Ej. Juan Pérez',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 70,
                      ),
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) => controller.email.value = value,
                    decoration: const InputDecoration(
                      prefixIcon: Text('Email: '),
                      hintText: 'Ej. correo@contacto.com',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 70,
                      ),
                    ),
                  ),
                  TextField(
                    onChanged: (value) => controller.telefono.value = value,
                    decoration: const InputDecoration(
                      prefixIcon: Text('Teléfono: '),
                      hintText: 'Ej. 833-123-4567',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 70,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButtonWidget(
              text: 'Enviar',
              onPressed: () {
                controller.enviar();
              },
            ),
          ],
        ),
      ),
    );
  }
}
