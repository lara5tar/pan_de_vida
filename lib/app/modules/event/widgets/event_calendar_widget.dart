import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:pan_de_vida/app/modules/event/controllers/events_calendar_controller.dart';

class EventCalendarWidget extends GetWidget<EventsCalendarController> {
  const EventCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => controller.isLoadingCalendar.value
                ? const Center(child: CircularProgressIndicator())
                : MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: MonthView(
                      controller: controller.eventController,
                      onEventTap: (event, date) {
                        if (event.event != null) {
                          controller.onEventTap(event.event!);
                        }
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}