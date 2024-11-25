import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pan_de_vida/app/data/models/video_model.dart';

import '../../../../core/values/keys.dart';
import '../../../data/services/cumbres_services.dart';

class ProspectosVideosController extends GetxController {
  var videos = <Video>[].obs;
  String idProspecto = '';

  @override
  void onInit() {
    getProspectoVideos();
    super.onInit();
  }

  getProspectoVideos() async {
    if (Get.arguments != null) {
      idProspecto = Get.arguments;
    }

    var result = await CumbresServices.getProspectoVideos(idProspecto);

    if (!result['error']) {
      videos.value = result['videos'];
    }
  }

  copyClipBoard(String url, String codVideo) {
    Get.snackbar(
      'Copiado',
      'Texto copiado al portapapeles',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
    );
    String idCogregante =
        GetStorage(Keys.LOGIN_KEY).read(Keys.COD_CONGREGANTE_KEY);

    String link =
        'http://www.sarmientos.net/#/video/e/$url/$idProspecto/$codVideo/$idCogregante';

    Clipboard.setData(ClipboardData(text: link));
  }
}
