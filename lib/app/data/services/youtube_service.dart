import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String apiKey = 'AIzaSyAqjfpAJDNs_24a0PbLxBTqseRJ1SU1Hbs';
  final String channelId = 'UC-y0wEvCxhzxm7pqWYQTXKQ';

  Future<List<Map<String, String>>> obtenerUltimosVideos() async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=15&order=date&type=video&key=$apiKey',
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
}
