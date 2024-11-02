import 'package:get/get.dart';
import '../../../data/services/youtube_service.dart';

class YoutubeCarruselController extends GetxController {
  final videos = <Map<String, String>>[].obs;
  final YouTubeService youTubeService = YouTubeService();

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
}
