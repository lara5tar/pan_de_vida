import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/values/keys.dart';

class YouTubeService {
  static Future<List<Map<String, String>>> getLastVideos() async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=${Keys.CHANNEL_ID}&maxResults=15&order=date&type=video&key=${Keys.YOUTUBE_API_KEY}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['items'] as List).map((video) {
        return {
          "title": video['snippet']['title'].toString(),
          "thumbnailUrl":
              video['snippet']['thumbnails']['high']['url'].toString(),
          "videoId": video['id']['videoId'].toString(),
        };
      }).toList();
    } else {
      throw Exception('Error al cargar los videos: ${response.reasonPhrase}');
    }
  }

  static WebViewController getWebViewController(String videoUrl) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(videoUrl),
      );
  }
}
