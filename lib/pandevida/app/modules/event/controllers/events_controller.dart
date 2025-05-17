import 'package:get/get.dart';

import '../../../data/models/event_model.dart';
import '../../../data/services/event_service.dart';

class EventsController extends GetxController {
  var futureEvents = <Event>[].obs;
  var pastEvents = <Event>[].obs;
  var recurringEvents = <Event>[].obs; // New list for recurring events
  var desactivatedEvents = <Event>[].obs;

  var isLoading = true.obs;
  var eventService = EventService();

  @override
  void onInit() {
    eventService.getAll().then((data) {
      if (!data['error']) {
        Map eventos = ordenarEventos(data['data']);
        futureEvents.value = eventos['future'];
        pastEvents.value = eventos['past'];
        recurringEvents.value = eventos['recurring']; // Add recurring events
      }
      isLoading(false);
    });
    super.onInit();
  }

  DateTime _parseDateTime(String dateStr, String timeStr) {
    DateTime date = DateTime.parse(dateStr);

    // Parse time in format like "01:00 AM" or "02:30 PM"
    bool isPM = timeStr.toLowerCase().contains('pm');
    List<String> timeParts =
        timeStr.replaceAll(RegExp(r'[APMapm]'), '').trim().split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Convert to 24-hour format if PM
    if (isPM && hour < 12) {
      hour += 12;
    }
    // Convert 12 AM to 0 hours
    if (!isPM && hour == 12) {
      hour = 0;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String getEventSubtitle(Event event) {
    String dateRange = '';
    if (event.isRecurrent) {
      dateRange = event.daysOfWeek;
    } else {
      dateRange =
          '${event.startDate}${event.endDate.isEmpty ? '' : ' al ${event.endDate}'}';
    }
    final timeRange = event.isAllDay
        ? 'Todo el día'
        : '${event.startTime} - ${event.endTime}';

    return '$dateRange\n$timeRange';
  }

  Map ordenarEventos(List<Event> eventos) {
    List<Event> eventosFuturos = [];
    List<Event> eventosPasados = [];
    List<Event> eventosRecurrentes = []; // New list for recurring events
    DateTime now = DateTime.now();

    for (Event evento in eventos) {
      // Check if event is recurring - adjust this condition based on how recurring events are identified
      if (evento.isDesactivated == true) {
        desactivatedEvents.add(evento);
        continue;
      }
      if (evento.isRecurrent == true) {
        eventosRecurrentes.add(evento);
        continue;
      }

      // Parse start date and time
      DateTime startDateTime =
          _parseDateTime(evento.startDate, evento.startTime);

      if (evento.endDate.isEmpty) {
        // Event has only start date
        if (startDateTime.isAfter(now) || startDateTime.isAtSameMomentAs(now)) {
          eventosFuturos.add(evento);
        } else {
          eventosPasados.add(evento);
        }
      } else {
        // Event has both start and end dates
        DateTime endDateTime = _parseDateTime(evento.endDate, evento.endTime);

        // Calculate days between start and end date

        if (endDateTime.isAfter(now) || endDateTime.isAtSameMomentAs(now)) {
          eventosFuturos.add(evento);
        } else {
          eventosPasados.add(evento);
        }
      }
    }

    // Sort future events by start date (closest first)
    eventosFuturos.sort((a, b) {
      DateTime aDate = _parseDateTime(a.startDate, a.startTime);
      DateTime bDate = _parseDateTime(b.startDate, b.startTime);
      return aDate.compareTo(bDate);
    });

    // Sort past events by start date (most recent first)
    eventosPasados.sort((a, b) {
      DateTime aDate = _parseDateTime(a.startDate, a.startTime);
      DateTime bDate = _parseDateTime(b.startDate, b.startTime);
      return bDate.compareTo(aDate);
    });

    //sort recurring events by day of week
    eventosRecurrentes.sort((a, b) {
      return a.daysOfWeek.compareTo(b.daysOfWeek);
    });

    //sort desactivated events
    desactivatedEvents.sort((a, b) {
      return a.startDate.compareTo(b.startDate);
    });

    return {
      'future': eventosFuturos,
      'past': eventosPasados,
      'recurring': eventosRecurrentes,
      'desactivated': desactivatedEvents
    };
  }
}
