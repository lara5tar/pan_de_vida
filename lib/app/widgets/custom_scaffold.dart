import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomScaffold extends StatelessWidget {
  final bool setBrightnessDark;
  final Widget? body;
  final String backgroundImage;
  final bool setBanner;
  final Widget? leading;
  final bool setLeading;

  const CustomScaffold({
    super.key,
    this.backgroundImage = 'assets/background_general.jpg',
    this.body,
    this.setBrightnessDark = true,
    this.setBanner = true,
    this.leading,
    this.setLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 170,
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra

        leading: Column(
          children: [
            const SizedBox(height: 80),
            leading != null || setLeading
                ? leading ??
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                : const SizedBox.shrink(),
          ],
        ),
        leadingWidth: 90,
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
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
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
