import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/group_attendance_model.dart';
import 'package:pan_de_vida/app/data/models/video_model.dart';
import 'package:pan_de_vida/app/data/services/afirmacion_service.dart';
import 'package:pan_de_vida/app/data/services/maps_service.dart';

class AffirmationVideosController extends GetxController {
  String codCongregante = Get.arguments;

  List<Video> videos = [];
  late GroupAttendace groupAttendance;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  initData() async {
    await getVideosAffirmation();
    await getAttendances();
    isLoading(false);
  }

  getVideosAffirmation() async {
    AfirmacionService afirmacionService = AfirmacionService();

    var result = await afirmacionService.getAfirmacionVideos(codCongregante);

    if (!result['error']) {
      videos = result['data'];
    }
  }

  getAttendances() async {
    AfirmacionService afirmacionService = AfirmacionService();
    var result = await afirmacionService.getAsistencia(codCongregante);

    if (!result['error']) {
      groupAttendance = result['data'];
    }
  }
}
