import 'package:pan_de_vida/app/data/models/event_model.dart';
import 'package:pan_de_vida/app/data/providers/api_provider.dart';

class EventService {
  static final FirebaseApiProvider fireProvider = FirebaseApiProvider(
    idProject: 'pandevida-td',
    model: 'event',
  );

  Future<Map> getAll() async {
    List<Event> events = [];
    Map<String, dynamic> data = await fireProvider.getAll();

    if (data['error']) {
      return data;
    } else {
      data['data'].forEach((key, value) {
        events.add(Event.fromJson(value));
      });
      return {'error': false, 'data': events};
    }
  }

  Future<Event> getById(String id) async {
    Map<String, dynamic> data = await fireProvider.get(id);
    return Event.fromJson(data);
  }

  Future<Map<String, dynamic>> add(Event event) async {
    try {
      return await fireProvider.add(event.toJson());
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> update(Event event) async {
    try {
      return await fireProvider.update(event.id, event.toJson());
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> delete(String id) async {
    return await fireProvider.delete(id);
  }

  String getDayOfWeek(String day, bool isRecurrence) {
    if (!isRecurrence) {
      return day;
    }
    DateTime date = DateTime.parse(day);

    switch (date.weekday) {
      case 1:
        return 'LUNES';
      case 2:
        return 'MARTES';
      case 3:
        return 'MIERCOLES';
      case 4:
        return 'JUEVES';
      case 5:
        return 'VIERNES';
      case 6:
        return 'SABADO';
      case 7:
        return 'DOMINGO';
      default:
        return 'DESCONOCIDO';
    }
  }
}
