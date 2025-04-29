import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custom_scaffold.dart';
import '../widgets/event_widget.dart';
import '../controllers/landing_controller.dart';
import '../widgets/youtube_carrusel_view.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      setBanner: false,
      setLeading: false,
      setNotificationBar: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // Ensure scrolling always works
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const EventWidget(),
                    // const SizedBox(height: 10),s
                    // Wrap the carousel in a fixed height container
                    SizedBox(
                      height: 240,
                      child: YouTubeCarouselWidget(),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Optimize GestureDetector with Inkwell for better touch feedback
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Get.toNamed(Routes.GRUPOS_DE_VIDA);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.3), // Reduced opacity
                                      spreadRadius: 2, // Reduced from 3
                                      blurRadius: 6, // Reduced from 10
                                      offset:
                                          const Offset(0, 2), // Reduced offset
                                    ),
                                  ],
                                ),
                                // Precache image and use a placeholder
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/grupos_button.jpeg',
                                    // Add a frame callback for better performance
                                    frameBuilder: (context, child, frame,
                                        wasSynchronouslyLoaded) {
                                      if (wasSynchronouslyLoaded) return child;
                                      return AnimatedOpacity(
                                        opacity: frame == null ? 0 : 1,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                        child: child,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Get.toNamed(Routes.LOGIN);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.3), // Reduced opacity
                                      spreadRadius: 2, // Reduced from 3
                                      blurRadius: 6, // Reduced from 10
                                      offset:
                                          const Offset(0, 2), // Reduced offset
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/login_button.jpeg',
                                    // Add a frame callback for better performance
                                    frameBuilder: (context, child, frame,
                                        wasSynchronouslyLoaded) {
                                      if (wasSynchronouslyLoaded) return child;
                                      return AnimatedOpacity(
                                        opacity: frame == null ? 0 : 1,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                        child: child,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () {
          Get.toNamed(Routes.PUNTODEVENTA);
        },
        icon: Icons.shopping_cart,
      ),
    );
  }
}
