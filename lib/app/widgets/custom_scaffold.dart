import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomScaffold extends StatelessWidget {
  final bool setBrightnessDark;
  final Widget? body;
  final String backgroundImage;
  final bool setBanner;
  final Widget? leading;
  final bool setLeading;
  final FloatingButtonWidget? floatingActionButton;
  final Widget? bottomSheet;

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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
        leading: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              leading != null || setLeading
                  ? leading ??
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
                      )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        leadingWidth: 105,
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
              child: Stack(
                children: [
                  BannerWidget(),
                  // if (leading != null)
                  //   Positioned(top: 65, left: 5, child: leading!),
                  // if (leading == null || setLeading)
                  //   Positioned(
                  //     top: 65,
                  //     left: 5,
                  //     child: CustomLeadingButton(
                  //       style: ButtonStyle(
                  //         padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  //           const EdgeInsets.only(
                  //               left: 6, top: 8, right: 10, bottom: 8),
                  //         ),
                  //       ),
                  //       onPressed: () {
                  //         Navigator.of(context).pop();
                  //       },
                  //     ),
                  //   ),
                ],
              ),
            )
          // else if (leading != null && setLeading)
          //   Positioned(
          //     top: 40,
          //     left: 20,
          //     right: 20,
          //     child: leading!,
          //   )
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
    return IconButton(
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset('assets/banner.jpg'),
    );
  }
}
