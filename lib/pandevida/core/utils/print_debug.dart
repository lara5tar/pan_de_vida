import 'package:flutter/foundation.dart';

printD(message) {
  if (kDebugMode) {
    print('DEBUG: ${message.toString()}');
  }
}
