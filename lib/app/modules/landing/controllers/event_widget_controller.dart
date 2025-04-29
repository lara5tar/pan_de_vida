import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:pan_de_vida/core/utils/calendar_utils.dart';

import '../../../data/models/event_model.dart';

class EventWidgetController extends GetxController {
  var isLoading = true.obs;
  var hasError = false.obs; // Agregando propiedad hasError
  var errorMessage = ''.obs; // Mensaje de error
  var events = <Event>[].obs;
  final currentIndex = 0.obs;

  // Fecha actual para filtrar eventos
  final DateTime today = DateTime.now();

  @override
  void onInit() {
    getEvents();
    super.onInit();
  }

  // Método para refrescar los eventos (usado por el botón reintentar)
  Future<void> refreshEvents() async {
    if (!isLoading.value) {
      await getEvents();
    }
  }

  Future<void> getEvents() async {
    EventService eventService = EventService();

    isLoading(true);
    hasError(false); // Resetear el estado de error

    try {
      var data = await eventService.getAll();
      if (!data['error']) {
        events.clear();

        // Procesa los eventos recurrentes para obtener sus fechas actuales
        List<Event> processedEvents = getEventCalendar(data['data']);

        // Filtrar eventos por fecha y limitar a 10
        List<Event> filteredEvents = filterAndSortEvents(processedEvents);
        events.addAll(filteredEvents);

        // Precargar imágenes antes de finalizar la carga
        await precacheEventImage();
      } else {
        hasError(true);
        errorMessage.value = 'No se pudieron cargar los eventos';
      }
    } catch (e) {
      hasError(true);
      errorMessage.value = 'Error al cargar eventos: $e';
      debugPrint('Error al cargar eventos: $e');
    } finally {
      isLoading(false);
    }
  }

  // Método para filtrar eventos por fecha y limitar a 10
  List<Event> filterAndSortEvents(List<Event> allEvents) {
    final DateTime todayDate = DateTime(today.year, today.month, today.day);

    // Filtrar eventos pasados y desactivados
    List<Event> futureEvents = allEvents.where((event) {
      // No mostrar eventos desactivados
      if (event.isDesactivated) {
        return false;
      }

      if (event.startDate.isNotEmpty) {
        final DateTime eventDate = DateTime.parse(event.startDate);
        // Mantener el evento si su fecha es hoy o futura
        return !eventDate.isBefore(todayDate);
      }

      // Para eventos sin fecha específica, incluirlos por defecto
      return true;
    }).toList();

    // Ordenar eventos
    futureEvents.sort((a, b) {
      // Ordenar primero por fecha
      if (a.startDate.isNotEmpty && b.startDate.isNotEmpty) {
        int dateCompare =
            DateTime.parse(a.startDate).compareTo(DateTime.parse(b.startDate));
        if (dateCompare != 0) return dateCompare;
      } else if (a.startDate.isNotEmpty) {
        return -1;
      } else if (b.startDate.isNotEmpty) {
        return 1;
      }

      // Si están en la misma fecha o no tienen fecha, los que tienen hora específica van primero
      if (a.isAllDay != b.isAllDay) {
        return a.isAllDay
            ? 1
            : -1; // Invertido para que los que NO son todo el día vayan primero
      }

      // Si ambos son del mismo tipo (con horario o todo el día), ordenar por hora de inicio
      return a.startTime.compareTo(b.startTime);
    });

    // Limitar a 10 eventos
    return futureEvents.take(10).toList();
  }

  // Procesa los eventos para el calendario (Similar a EventsCalendarController)
  List<Event> getEventCalendar(List<Event> eventsAux) {
    List<Event> eventsList = [];
    for (var event in eventsAux) {
      if (event.isRecurrent) {
        // Eventos recurrentes: L, M, Mi, J, V, S, D
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

  String obtenerDiaDeFecha(String date) {
    DateTime fecha = DateTime.parse(date);
    final Map<int, String> diasSemana = {
      DateTime.monday: 'LUN',
      DateTime.tuesday: 'MAR',
      DateTime.wednesday: 'MIE',
      DateTime.thursday: 'JUE',
      DateTime.friday: 'VIE',
      DateTime.saturday: 'SAB',
      DateTime.sunday: 'DOM',
    };

    return diasSemana[fecha.weekday]!;
  }

  Future<void> precacheEventImage() async {
    // Solo precargar la primera imagen si hay eventos disponibles
    if (events.isNotEmpty && events[0].urlImage.isNotEmpty) {
      try {
        await precacheImage(NetworkImage(events[0].urlImage), Get.context!);
      } catch (e) {
        print('Error precargando primera imagen: $e');
      }
    }
  }

  String getEventDate(Event event) {
    DateTime startDate = DateTime.parse(event.startDate);
    // DateTime? endDate;
    // if (event.startDate.isNotEmpty) {
    //   startDate = DateTime.parse(event.startDate);
    //   if (event.endDate.isNotEmpty) {
    //     endDate = DateTime.parse(event.endDate);
    //     date = '${startDate.day} - ${endDate.day}';
    //   } else {
    //     date = startDate.day.toString();
    //   }
    // } else {
    //   date = event.daysOfWeek;
    // }

    return startDate.day.toString();
  }

  String getMonth(Event event) {
    if (event.startDate.isEmpty) {
      return getMonthString(DateTime.now().month).substring(0, 3).toUpperCase();
    }
    DateTime startDate = DateTime.parse(event.startDate);

    return getMonthString(startDate.month).substring(0, 3).toUpperCase();
  }
}
