import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomScaffold extends StatelessWidget {
  final bool setBrightnessDark;
  final Widget? body;
  final String backgroundImage;
  final bool setBanner;
  final Widget? leading;
  final bool setLeading;
  final FloatingButtonWidget? floatingActionButton;
  final Widget? bottomSheet;
  final bool setNotificationBar;

  const CustomScaffold({
    super.key,
    this.backgroundImage = 'assets/background_general.jpg',
    this.body,
    this.setBrightnessDark = true,
    this.setBanner = true,
    this.leading,
    this.setLeading = true,
    this.floatingActionButton,
    this.bottomSheet,
    this.setNotificationBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 40,
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
        leading: Container(),

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
              crossAxisAlignment: setBanner
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // if (setNotificationBar)
                SizedBox(height: MediaQuery.of(Get.context!).padding.top),
                if (setBanner)
                  Stack(
                    children: [
                      const BannerWidget(),
                      if (leading != null)
                        Positioned(bottom: 5, child: leading!)
                      else if (setLeading)
                        Positioned(
                          bottom: 5,
                          child: CustomLeadingButton(
                            style: ButtonStyle(
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.only(
                                    left: 6, top: 8, right: 10, bottom: 8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                    ],
                  )
                else if (setLeading && leading != null)
                  leading!
                else if (setLeading)
                  CustomLeadingButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.only(
                            left: 6, top: 8, right: 10, bottom: 8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                Expanded(
                  child: body ?? const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomSheet: bottomSheet,
    );
  }
}

class CustomLeadingButton extends StatelessWidget {
  final IconData icon;
  final ButtonStyle? style;
  final Function()? onPressed;
  const CustomLeadingButton({
    super.key,
    this.icon = Icons.arrow_back_ios_new_rounded,
    this.style,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: IconButton(
        style: style != null
            ? style?.copyWith(
                shape: WidgetStateProperty.all<CircleBorder>(
                  const CircleBorder(
                    side: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.blue.shade800.withOpacity(0.5),
                ),
              )
            : ButtonStyle(
                shape: WidgetStateProperty.all<CircleBorder>(
                  const CircleBorder(
                    side: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.blue.shade800.withOpacity(0.5),
                ),
              ),
        icon: Icon(
          icon,
          color: Colors.white,
          size: 35,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class FloatingButtonWidget extends StatelessWidget {
  const FloatingButtonWidget({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.blue.shade900,
      child: Icon(
        icon,
        color: Colors.white,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('assets/banner.jpg'),
      ),
    );
  }
}
