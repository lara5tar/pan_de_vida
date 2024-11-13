import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomScaffold extends StatelessWidget {
  final bool setAppBar;
  final Widget? body;
  final String backgroundImage;
  const CustomScaffold({
    super.key,
    this.backgroundImage = 'assets/background_general.jpg',
    this.body,
    this.setAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
        iconTheme: IconThemeData(
          color: !setAppBar ? Colors.white : Colors.grey[900],
          size: 30,
        ),
        leadingWidth: 80,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              !setAppBar ? Brightness.light : Brightness.dark,
          systemStatusBarContrastEnforced: false,
        ),
        forceMaterialTransparency: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          // Contenido de la pantalla
          Positioned.fill(
            child: Column(
              children: [
                if (!setAppBar) const SizedBox(height: 80),
                Expanded(
                  child: body ?? const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
