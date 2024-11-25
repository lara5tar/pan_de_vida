import 'package:get/get.dart';

import '../../../../core/utils/copy_clip_board.dart';
import '../../../data/models/video_model.dart';
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
    copyClipBoardUtil('e', url, codVideo, idProspecto);
  }
}
