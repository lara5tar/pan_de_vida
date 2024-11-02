import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/youtube_carrusel_controller.dart';

class YouTubeCarouselWidget extends GetView<YoutubeCarruselController> {
  YouTubeCarouselWidget({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Obx(
        () {
          if (controller.videos.isEmpty) {
            return _buildLoadingIndicator();
          }
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: controller.videos.length + 1,
                  onPageChanged: (index) {
                    controller.currentIndex.value = index;

                    if (index == controller.videos.length) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      });
                    }
                  },
                  itemBuilder: (context, index) {
                    if (index == controller.videos.length) {
                      return const SizedBox.shrink();
                    }
                    final video = controller.videos[index];
                    return GestureDetector(
                      onTap: () => controller.openVideo(video['videoId']),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildVideoCard(video),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              _buildPageIndicator(controller.videos.length),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVideoCard(Map<String, String?> video) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10), // Espacio para sombra
      decoration: BoxDecoration(
        color: const Color(0xff08244c),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          _buildThumbnail(video['thumbnailUrl']),
          _buildVideoTitleOverlay(video['title']),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String? thumbnailUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        thumbnailUrl ?? '',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 100,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildVideoTitleOverlay(String? title) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff08244c).withOpacity(0.7),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Text(
          title ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Obx(() {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.currentIndex.value == index
                  ? const Color(0xff0f4c75)
                  : Colors.grey,
            ),
          );
        });
      }),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff08244c),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
