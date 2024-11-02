import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/youtube_carrusel_controller.dart';

class YouTubeCarouselWidget extends GetView<YoutubeCarruselController> {
  const YouTubeCarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Obx(() {
        if (controller.videos.isEmpty) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            margin: const EdgeInsets.all(20),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return PageView.builder(
          pageSnapping: true,
          itemCount: controller.videos.length,
          itemBuilder: (context, index) {
            final video = controller.videos[index];
            return GestureDetector(
              onTap: () async {
                final Uri videoUrl = Uri.parse(
                    'https://www.youtube.com/watch?v=${video['videoId']}');
                if (await canLaunchUrl(videoUrl)) {
                  await launchUrl(videoUrl,
                      mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar('Error', 'No se pudo abrir el enlace.');
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          video['thumbnailUrl'] ?? '',
                          height: 280,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Positioned(
                      top: 165,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.blue.withOpacity(0.6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                video['title'] ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
