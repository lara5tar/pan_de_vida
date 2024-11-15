import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomScaffold extends StatelessWidget {
  final bool setAppBar;
  final bool setIconThemeWhite;
  final bool setBrightnessDark;
  final Widget? body;
  final String backgroundImage;
  final bool setBanner;

  const CustomScaffold({
    super.key,
    this.backgroundImage = 'assets/background_general.jpg',
    this.body,
    this.setAppBar = true,
    this.setIconThemeWhite = true,
    this.setBrightnessDark = true,
    this.setBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
        iconTheme: IconThemeData(
          color: setIconThemeWhite ? Colors.white : Colors.grey[900],
          size: 30,
        ),
        leadingWidth: 80,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              setBrightnessDark ? Brightness.dark : Brightness.light,
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (!setAppBar) const SizedBox(height: 100),
                if (setBanner) const SizedBox(height: 160),
                Expanded(
                  child: body ?? const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          if (setBanner)
            const Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: BannerWidget(),
            ),
        ],
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  const BannerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset('assets/banner.jpg'),
    );
  }
}
