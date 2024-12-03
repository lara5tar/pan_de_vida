import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../../data/services/youtube_service.dart';
import '../../../routes/app_pages.dart';

class GruposDeVidaController extends GetxController {
  late final WebViewController webViewController;

  @override
  Future<void> onInit() async {
    super.onInit();

    initWebViewController();
  }

  void initWebViewController() {
    webViewController = YouTubeService.getWebViewController(
      'https://www.youtube.com/embed/nOblARtr7AA',
    );
  }

  Future<void> callButton() async {
    await FlutterPhoneDirectCaller.callNumber('8331259913');
  }

  void webButton() {}
  void joinButton() {}

  void mapsButton() {
    Get.toNamed(Routes.MAP_GROUPS);
  }
}
