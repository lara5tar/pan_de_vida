import 'package:get/get.dart';

import '../../../../core/utils/calendar_utils.dart';
import '../../../data/models/event_model.dart';
import '../../../data/services/event_service.dart';
import '../widgets/event_detail_dialog.dart'; // Importamos el nuevo archivo
import 'package:calendar_view/calendar_view.dart';

class EventsCalendarController extends GetxController {
  var isLoading = true.obs;
  var isLoadingCalendar = true.obs;
  var events = <Event>[].obs;
  var eventController = EventController<Event>();

  // Fecha actual para filtrar eventos
  final DateTime today = DateTime.now();

  @override
  void onInit() {
    getEvents();
    super.onInit();
  }

  // Navegar al detalle del evento seleccionado
  void onEventTap(Event event) {
    // Usamos la función extraída del diálogo
    showEventDetailDialog(event, formatDateHeader);
  }

  // Método para obtener todos los eventos
  void getEvents() async {
    EventService eventService = EventService();

    isLoading(true);
    try {
      var data = await eventService.getAll();
      if (!data['error']) {
        events.clear();
        events.addAll(getEventCalendar(data['data']));
        // Ordenar por fecha
        events.sort((a, b) => a.startDate.compareTo(b.startDate));
        eventController = EventController()
          ..addAll(convertCalendarEventData(events));
        isLoadingCalendar(false);
        isLoading(false);
      } else {
        // Handle error but keep isLoading true when there's no internet
        if (data['statusCode'] == -1) {
          // Keep isLoading true for network errors
          print('Sin acceso a internet - manteniendo estado de carga');
        } else {
          // For other errors, we can stop the loading state
          isLoadingCalendar(false);
          isLoading(false);
        }
      }
    } catch (e) {
      // Keep isLoading true for exceptions
      print(
          'Error al cargar eventos: ${e.toString()} - manteniendo estado de carga');
    }
  }

  // Método para filtrar eventos pasados
  List<Event> getFilteredEvents() {
    final DateTime todayDate = DateTime(today.year, today.month, today.day);

    return events.where((event) {
      // No mostrar eventos desactivados
      if (event.isDesactivated) {
        return false;
      }

      // Para eventos con fecha específica
      if (event.startDate.isNotEmpty) {
        final DateTime eventDate = DateTime.parse(event.startDate);
        // Mantener el evento si su fecha es hoy o futura
        return !eventDate.isBefore(todayDate);
      }

      // Para eventos recurrentes, siempre mostrarlos
      if (event.daysOfWeek.isNotEmpty) {
        return true;
      }

      // Si no tiene fecha ni es recurrente, mantenerlo por defecto
      return true;
    }).toList()
      // Ordenar por fecha
      ..sort((a, b) {
        // Si ambos tienen fecha de inicio, ordenar por fecha
        if (a.startDate.isNotEmpty && b.startDate.isNotEmpty) {
          return DateTime.parse(a.startDate)
              .compareTo(DateTime.parse(b.startDate));
        }
        // Si solo uno tiene fecha, ese va primero
        if (a.startDate.isNotEmpty) return -1;
        if (b.startDate.isNotEmpty) return 1;

        // Si ninguno tiene fecha, ordenar por título
        return a.title.compareTo(b.title);
      });
  }

  // Método para agrupar eventos por fecha
  Map<String, List<Event>> getGroupedEvents() {
    final filteredEvents = getFilteredEvents();
    final Map<String, List<Event>> groupedEvents = {};

    for (var event in filteredEvents) {
      final String dateKey = event.startDate.isNotEmpty
          ? event.startDate
          : (event.daysOfWeek.isNotEmpty
              ? "Recurrente: ${event.daysOfWeek}"
              : "Sin fecha");

      if (!groupedEvents.containsKey(dateKey)) {
        groupedEvents[dateKey] = [];
      }
      groupedEvents[dateKey]!.add(event);

      // Ordenar los eventos dentro de cada grupo de fechas
      groupedEvents[dateKey]!.sort((a, b) {
        // Si ambos son "todo el día" o ambos no son "todo el día", usar otros criterios
        if (a.isAllDay == b.isAllDay) {
          // Si no son "todo el día", ordenar por hora de inicio
          if (!a.isAllDay) {
            return a.startTime.compareTo(b.startTime);
          }
          // Si son "todo el día", ordenar por título
          return a.title.compareTo(b.title);
        }
        // Poner eventos "todo el día" al final
        return a.isAllDay ? 1 : -1;
      });
    }

    return groupedEvents;
  }

  // Método para formatear fechas para mostrar en la UI

  // Procesa los eventos para el calendario
  List<Event> getEventCalendar(List<Event> eventsAux) {
    List<Event> eventsList = [];
    for (var event in eventsAux) {
      // No incluir eventos desactivados
      if (event.isDesactivated) {
        continue;
      }

      if (event.isRecurrent) {
        //L, M ó V ó L, Mi, V
        if (event.daysOfWeek.contains(',')) {
          List<String> daysOfWeek = event.daysOfWeek.split(',');
          for (var day in daysOfWeek) {
            DateTime fecha = obtenerFechaDeDia(day.trim());
            eventsList.add(
              event.copyWith(
                startDate: fecha.toString().substring(0, 10),
              ),
            );
          }
        } else {
          DateTime fecha = obtenerFechaDeDia(event.daysOfWeek.trim());
          eventsList.add(
            event.copyWith(
              startDate: fecha.toString().substring(0, 10),
            ),
          );
        }
      } else {
        DateTime starDate = DateTime.parse(event.startDate);
        DateTime todayDate = DateTime(today.year, today.month, today.day);

        if (starDate.isAfter(todayDate) ||
            starDate.isAtSameMomentAs(todayDate)) {
          if (event.endDate.isEmpty) {
            eventsList.add(event);
          } else {
            DateTime endDate = DateTime.parse(event.endDate);
            for (var i = starDate;
                i.isBefore(endDate) || i.isAtSameMomentAs(endDate);
                i = i.add(const Duration(days: 1))) {
              if (i.isAfter(todayDate) || i.isAtSameMomentAs(todayDate)) {
                eventsList.add(
                  event.copyWith(
                    startDate: i.toString().substring(0, 10),
                  ),
                );
              }
            }
          }
        }
      }
    }

    return eventsList;
  }

  DateTime obtenerFechaDeDia(String diaAbreviado) {
    final Map<String, int> diasSemana = {
      'L': DateTime.monday,
      'M': DateTime.tuesday,
      'Mi': DateTime.wednesday,
      'J': DateTime.thursday,
      'V': DateTime.friday,
      'S': DateTime.saturday,
      'D': DateTime.sunday,
    };

    int diaSemana = diasSemana[diaAbreviado]!;

    DateTime ahora = DateTime.now();
    DateTime inicioSemana =
        ahora.subtract(Duration(days: ahora.weekday - DateTime.monday));

    return inicioSemana.add(Duration(days: diaSemana - DateTime.monday));
  }

  // Convierte los datos de eventos al formato requerido por el calendario
  List<CalendarEventData<Event>> convertCalendarEventData(
      List<Event> eventsAux) {
    List<CalendarEventData<Event>> eventsList = [];

    for (var event in eventsAux) {
      // No incluir eventos desactivados
      if (event.isDesactivated) {
        continue;
      }

      eventsList.add(
        CalendarEventData(
          event: event,
          startTime: DateTime.parse(event.startDate),
          endTime: event.endDate.isEmpty
              ? DateTime.parse(event.startDate)
              : DateTime.parse(event.endDate),
          title: event.title,
          date: DateTime.parse(event.startDate),
        ),
      );
    }

    return eventsList;
  }
}
