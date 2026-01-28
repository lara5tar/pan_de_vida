import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardController extends GetxController {
  List getMenu() {
    GetStorage box = GetStorage('login');

    return box.read('menu') ?? [];
  }
}
