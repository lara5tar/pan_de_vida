import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/services/youtube_service.dart';

class YoutubeCarruselController extends GetxController {
  final videos = <Map<String, String>>[].obs;
  final YouTubeService youTubeService = YouTubeService();

  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadVideos();
  }

  Future<void> loadVideos() async {
    try {
      final fetchedVideos = await youTubeService.obtenerUltimosVideos();
      videos.assignAll(fetchedVideos);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e);
    }
  }

  Future<void> openVideo(String? videoId) async {
    if (videoId == null) return;
    final Uri videoUrl = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(videoUrl)) {
      await launchUrl(videoUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'No se pudo abrir el enlace.');
    }
  }
}
