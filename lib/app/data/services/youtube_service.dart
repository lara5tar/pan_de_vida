import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/values/keys.dart';

class YouTubeService {
  static const String channelId = 'UC-y0wEvCxhzxm7pqWYQTXKQ';

  // Información real del canal (reemplazar con datos reales)
  static final List<Map<String, String>> _channelVideos = [
    {
      "title": "Pan de Vida con Natán de los Reyes",
      "thumbnailUrl": "https://img.youtube.com/vi/NIb-vmTtCgw/hqdefault.jpg",
      "videoId": "NIb-vmTtCgw",
    },
    {
      "title": "Pan de Vida con Natán de los Reyes",
      "thumbnailUrl": "https://img.youtube.com/vi/xLLQA43u-Ts/hqdefault.jpg",
      "videoId": "xLLQA43u-Ts",
    },
    {
      "title": "Pan de Vida | Natán de los Reyes",
      "thumbnailUrl": "https://img.youtube.com/vi/IJSloxoQ_yw/hqdefault.jpg",
      "videoId": "IJSloxoQ_yw",
    },
    {
      "title": "Pastor Natán de los Reyes | Pan de Vida",
      "thumbnailUrl": "https://img.youtube.com/vi/5Ammb-CexI8/hqdefault.jpg",
      "videoId": "5Ammb-CexI8",
    },
  ];

  // Método principal para obtener los videos
  static Future<List<Map<String, String>>> getVideos() async {
    try {
      // Primero, intentar cargar desde la API
      final apiVideos = await _fetchFromApi();
      if (apiVideos.isNotEmpty) {
        debugPrint('Cargados ${apiVideos.length} videos desde la API');
        return apiVideos;
      }

      // Si falla la API, usar videos del canal predefinidos
      debugPrint('Usando videos del canal predefinidos');
      return _channelVideos;
    } catch (e) {
      debugPrint('Error al cargar videos: $e');
      // En caso de cualquier error, devolver los videos del canal predefinidos
      return _channelVideos;
    }
  }

  // Intenta obtener videos desde la API
  static Future<List<Map<String, String>>> _fetchFromApi() async {
    if (Keys.YOUTUBE_API_KEY.isEmpty) {
      return [];
    }

    try {
      final url = Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=10&order=date&type=video&key=${Keys.YOUTUBE_API_KEY}',
      );

      final response = await http.get(url).timeout(
            const Duration(seconds: 8),
            onTimeout: () =>
                throw Exception('La solicitud ha tardado demasiado tiempo.'),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] == null || (data['items'] as List).isEmpty) {
          return [];
        }

        return (data['items'] as List).map((video) {
          return {
            "title": video['snippet']['title'].toString(),
            "thumbnailUrl":
                video['snippet']['thumbnails']['high']['url'].toString(),
            "videoId": video['id']['videoId'].toString(),
          };
        }).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error en API: $e');
      return [];
    }
  }

  static WebViewController getWebViewController(String videoUrl) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(videoUrl));
  }

  // URL directa del video de YouTube
  static String getVideoUrl(String videoId) {
    return 'https://www.youtube.com/watch?v=$videoId';
  }

  // URL directa de la miniatura de YouTube (alta calidad)
  static String getThumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
}
