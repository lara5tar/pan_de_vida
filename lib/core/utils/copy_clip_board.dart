import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../values/keys.dart';

copyClipBoardUtil(
    String tipo, String url, String codVideo, String idProspecto) {
  Get.snackbar(
    'Copiado',
    'Texto copiado al portapapeles',
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
  );

  String idCogregante =
      GetStorage(Keys.LOGIN_KEY).read(Keys.COD_CONGREGANTE_KEY);

  String link =
      'http://www.sarmientos.net/#/video/$tipo/$url/$idProspecto/$codVideo/$idCogregante';

  Clipboard.setData(ClipboardData(text: link));
}
