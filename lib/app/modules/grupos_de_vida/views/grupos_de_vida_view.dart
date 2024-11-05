import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../widgets/custom_scaffold.dart';
import '../controllers/grupos_de_vida_controller.dart';

class GruposDeVidaView extends GetView<GruposDeVidaController> {
  const GruposDeVidaView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImage: 'assets/background_login.jpg',
      setAppBar: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/pandevida_logo.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150, // Ajusta el tamaño del contenedor para el video
                child: WebViewWidget(
                  controller: controller.webViewController,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Unete a uno de nuestros grupos en Casa',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 20,
                runSpacing: 40,
                children: [
                  CustomIconButton(
                    title: 'LLamar',
                    icon: Icons.phone,
                    onPressed: controller.callButton,
                  ),
                  CustomIconButton(
                    title: 'WWW',
                    icon: Icons.public,
                    onPressed: controller.webButton,
                  ),
                  CustomIconButton(
                    title: 'Desea asistir a uno',
                    icon: Icons.back_hand_rounded,
                    onPressed: controller.joinButton,
                  ),
                  CustomIconButton(
                    title: 'Ubicaciones',
                    icon: Icons.location_on,
                    onPressed: controller.mapsButton,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
