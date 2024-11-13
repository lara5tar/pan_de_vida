// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Keys {
  static final String YOUTUBE_API_KEY = dotenv.env['YOUTUBE_API_KEY'] ?? '';
  static const String CHANNEL_ID = 'UC-y0wEvCxhzxm7pqWYQTXKQ';
  static final String URL_SERVICE = dotenv.env['URL_SERVICE'] ?? '';

  static const String LOGIN_KEY = 'login';
  static const String COD_CONGREGANTE_KEY = 'codCongregante';
  static const String COD_CASA_VIDA_KEY = 'codCasaVida';
  static const String COD_HOGAR_KEY = 'codHogar';
  static const String ROLES_KEY = 'roles';
}
