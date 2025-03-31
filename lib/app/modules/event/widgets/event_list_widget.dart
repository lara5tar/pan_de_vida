import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/event/controllers/events_calendar_controller.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';
import 'package:pan_de_vida/core/utils/calendar_utils.dart';

class EventListWidget extends GetWidget<EventsCalendarController> {
  const EventListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  const TextTitleWidget('Eventos del día'),
                  ...buildEventWidgets(),
                ],
              ),
      ),
    );
  }

  List<Widget> buildEventWidgets() {
    if (controller.events.isEmpty) {
      return [
        const SizedBox(height: 20),
        const Center(child: Text('No hay eventos para mostrar')),
        const SizedBox(height: 20),
      ];
    }

    final groupedEvents = controller.getGroupedEvents();

    if (groupedEvents.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Center(
            child: Text(
              'No hay eventos próximos',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      ];
    }

    return groupedEvents.entries.expand((entry) {
      final dateHeader = buildDateHeader(entry.key);
      final eventWidgets = entry.value.map((event) {
        return ButtonWidget(
            text: event.title,
            subtitle: event.isAllDay
                ? 'Todo el día'
                : '${event.startTime} - ${event.endTime}',
            icon: Icons.event,
            trailingWidget: event.urlImage.isNotEmpty
                ? Container(
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(event.urlImage),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : const Icon(Icons.event),
            isLast: event == entry.value.last,
            onTap: () {
              controller.onEventTap(event);
            });
      }).toList();

      return [dateHeader, ...eventWidgets];
    }).toList();
  }

  // Widget para mostrar la cabecera de fecha
  Widget buildDateHeader(String dateString) {
    // Usar el método del controlador para formatear la fecha
    final displayText = formatDateHeader(dateString);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xff0f4c75).withOpacity(0.1),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16, color: Color(0xff0f4c75)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff0f4c75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
