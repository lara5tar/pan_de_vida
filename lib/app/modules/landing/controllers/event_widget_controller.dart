import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/services/event_service.dart';

import '../../../data/models/event_model.dart';

class EventWidgetController extends GetxController {
  var isLoading = true.obs;
  var events = <Event>[].obs;
  final currentIndex = 0.obs; // New property to track current page

  @override
  void onInit() {
    getEvents();
    super.onInit();
  }

  void getEvents() async {
    EventService eventService = EventService();

    isLoading(true);
    var data = await eventService.getAll();
    if (!data['error']) {
      events.clear();
      events.addAll(data['data']);
    }
    isLoading(false);
  }
}
