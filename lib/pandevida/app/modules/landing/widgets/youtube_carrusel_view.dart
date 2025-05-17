import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/youtube_carrusel_controller.dart';

class YouTubeCarouselWidget extends GetView<YoutubeCarruselController> {
  YouTubeCarouselWidget({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Mostrar indicador de carga mientras se obtienen los videos
      if (controller.isLoading.value) {
        return _buildLoadingIndicator();
      }

      // Mostrar mensaje de error si hay un problema
      if (controller.hasError.value) {
        return _buildErrorWidget();
      }

      // Mostrar mensaje si no hay videos
      if (controller.videos.isEmpty) {
        return _buildEmptyWidget();
      }

      // Mostrar carrusel de videos con diseño similar a EventWidget
      return Column(
        children: [
          _buildTitleBar(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: controller.videos.length,
              onPageChanged: (index) {
                controller.currentIndex.value = index;
              },
              itemBuilder: (context, index) {
                final video = controller.videos[index];
                return _buildVideoCard(video);
              },
            ),
          ),
          // Indicador de página
          if (controller.videos.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildPageIndicator(),
            ),
        ],
      );
    });
  }

  Widget _buildTitleBar() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 20, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Videos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30,
            child: TextButton(
              onPressed: () {
                // Aquí podrías navegar a una página con más videos
                controller.openYouTubeChannel();
              },
              child: const Text(
                'Ver más',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Map<String, String?> video) {
    return GestureDetector(
      onTap: () => controller.openVideo(video['videoId']),
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Imagen del video
            _buildThumbnail(video['thumbnailUrl']),

            // Gradient overlay for better text readability
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF072F49),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topCenter,
                ),
              ),
            ),

            // Video title and play button
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Título del video
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            video['title'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Botón de reproducción estilo YouTube
                    Container(
                      height: 50,
                      width: 70,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
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
  }

  Widget _buildThumbnail(String? thumbnailUrl) {
    return CachedNetworkImage(
      imageUrl: thumbnailUrl ?? '',
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[800],
        child: const Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[800],
        child: const Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 48,
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.videos.length,
        (index) => Obx(() {
          bool isActive = controller.currentIndex.value == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 8,
            width: isActive ? 16 : 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.blue[700] : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.refreshVideos,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.videocam_off,
              color: Colors.grey,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'No hay videos disponibles',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
