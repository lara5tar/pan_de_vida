// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Keys {
  static final String YOUTUBE_API_KEY = dotenv.env['YOUTUBE_API_KEY'] ?? '';
  static const String CHANNEL_ID = 'UC-y0wEvCxhzxm7pqWYQTXKQ';
  static final String URL_SERVICE = dotenv.env['URL_SERVICE'] ?? '';
}
