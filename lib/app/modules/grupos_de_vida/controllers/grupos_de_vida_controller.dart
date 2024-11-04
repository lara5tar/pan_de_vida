import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../routes/app_pages.dart';

class GruposDeVidaController extends GetxController {
  late final WebViewController webViewController;

  @override
  Future<void> onInit() async {
    super.onInit();

    initWebViewController();
  }

  void initWebViewController() {
    const String videoUrl = 'https://www.youtube.com/embed/nOblARtr7AA';

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(videoUrl),
      );
  }

  void callButton() {}
  void webButton() {}
  void joinButton() {}

  void mapsButton() {
    Get.toNamed(Routes.MAP_GROUPS);
  }
}
