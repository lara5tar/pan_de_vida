import 'package:get/get.dart';

import 'package:pan_de_vida/app/modules/event/controllers/event_form_controller.dart';
import 'package:pan_de_vida/app/modules/event/controllers/events_controller.dart';

import '../controllers/event_controller.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventsController>(
      () => EventsController(),
    );
    Get.lazyPut<EventFormController>(
      () => EventFormController(),
    );
    Get.lazyPut<EventController>(
      () => EventController(),
    );
  }
}
