import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardController extends GetxController {
  List getMenu() {
    GetStorage box = GetStorage('login');

    for (var item in box.read('menu')) {
      for (var subItem in item['OPCIONES']) {
        print("\t" + subItem['URL']);
      }
    }

    return box.read('menu') ?? [];
  }
}
