import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/services/youtube_service.dart';

class YoutubeCarruselController extends GetxController {
  final videos = <Map<String, String>>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Cargar videos inmediatamente
    loadVideos();
  }

  Future<void> loadVideos() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      // Obtener videos del servicio actualizado
      final fetchedVideos = await YouTubeService.getVideos();

      // Actualizar la lista observable
      videos.assignAll(fetchedVideos);
    } catch (e) {
      debugPrint('Error al cargar videos: $e');
      hasError.value = true;
      errorMessage.value =
          'No se pudieron cargar los vídeos. Intente más tarde.';
    } finally {
      // Siempre cambiar el estado de carga a falso
      isLoading.value = false;
    }
  }

  Future<void> refreshVideos() async {
    if (!isLoading.value) {
      await loadVideos();
    }
  }

  Future<void> openVideo(String? videoId) async {
    if (videoId == null || videoId.isEmpty) return;

    try {
      // Intentar abrir el video con diferentes formatos de URL
      String videoUrl = YouTubeService.getVideoUrl(videoId);

      if (!(await _tryLaunchUrl(videoUrl))) {
        // Intentar formato alternativo con youtu.be
        videoUrl = 'https://youtu.be/$videoId';

        if (!(await _tryLaunchUrl(videoUrl))) {
          // Intentar abrir directamente en la app de YouTube
          videoUrl = 'youtube://watch?v=$videoId';

          if (!(await _tryLaunchUrl(videoUrl))) {
            Get.snackbar(
              'Error',
              'No se pudo abrir el video. Intenta más tarde.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error al abrir video: $e');
      Get.snackbar(
        'Error',
        'No se pudo abrir el vídeo',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Método para abrir el canal de YouTube completo
  Future<void> openYouTubeChannel() async {
    try {
      // Usar URL universal de YouTube que funciona en más dispositivos
      String youtubeUrl = 'https://www.youtube.com/c/NatándelosReyes';

      // Intentar URL alternativa si la personalizada falla
      if (!(await _tryLaunchUrl(youtubeUrl))) {
        // Probar con la URL de canal basada en ID
        youtubeUrl = 'https://youtube.com/channel/${YouTubeService.channelId}';

        if (!(await _tryLaunchUrl(youtubeUrl))) {
          // Si ambas fallan, intentar abrir la app de YouTube directamente
          youtubeUrl = 'youtube://';

          if (!(await _tryLaunchUrl(youtubeUrl))) {
            // Como último recurso, abrir YouTube web
            youtubeUrl = 'https://youtube.com';
            if (!(await _tryLaunchUrl(youtubeUrl))) {
              _showErrorSnackbar();
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error al abrir canal de YouTube: $e');
      _showErrorSnackbar();
    }
  }

  Future<bool> _tryLaunchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      debugPrint('Intentando abrir URL: $urlString');

      // Intentar lanzar sin verificar primero
      final result = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      debugPrint('Resultado de lanzamiento: $result');
      return result;
    } catch (e) {
      debugPrint('Error al intentar lanzar $urlString: $e');
      return false;
    }
  }

  void _showErrorSnackbar() {
    Get.snackbar(
      'Error',
      'No se pudo abrir YouTube. Intenta más tarde o busca "Pan de Vida" en YouTube.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
    );
  }
}
