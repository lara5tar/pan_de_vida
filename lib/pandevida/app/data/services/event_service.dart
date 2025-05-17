import 'package:pan_de_vida/pandevida/app/data/models/event_model.dart';
import 'package:pan_de_vida/pandevida/app/data/providers/api_provider.dart';

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
      print('EventServie.getAll');
      data['data'].forEach((key, value) {
        // print('Key: $key');
        // print('Value: $value');
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
}
