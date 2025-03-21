import 'package:get/get.dart';
import 'package:pan_de_vida/app/data/models/event_model.dart';
import 'package:pan_de_vida/app/data/services/event_service.dart';

class LandingController extends GetxController {
  test() {
    EventService e = EventService();
    e.add(Event(
      id: '1',
      title: 'Evento de prueba',
      description: 'Este es un evento de prueba',
      date: DateTime.now().toString(),
      time: '12:00',
      location: 'Casa de prueba',
      image: '1.webp',
    ));

    e.add(Event(
      id: '2',
      title: 'Evento de prueba 2',
      description: 'Este es un evento de prueba 2',
      date: DateTime.now().toString(),
      time: '12:00',
      location: 'Casa de prueba',
      image: '2.webp',
    ));

    e.add(Event(
      id: '3',
      title: 'Evento de prueba 3',
      description: 'Este es un evento de prueba 3',
      date: DateTime.now().toString(),
      time: '12:00',
      location: 'Casa de prueba',
      image: '3.webp',
    ));

    e.add(Event(
      id: '4',
      title: 'Evento de prueba 4',
      description: 'Este es un evento de prueba 4',
      date: DateTime.now().toString(),
      time: '12:00',
      location: 'Casa de prueba',
      image: '4.webp',
    ));

    e.add(Event(
      id: '5',
      title: 'Evento de prueba 5',
      description: 'Este es un evento de prueba 5',
      date: DateTime.now().toString(),
      time: '12:00',
      location: 'Casa de prueba',
      image: '5.webp',
    ));

    e.add(Event(
      id: '6',
      title: 'Evento de prueba 6',
      description: 'Este es un evento de prueba 6',
      date: DateTime.now().toString(),
      time: '12:00',
      location: 'Casa de prueba',
      image: '6.webp',
    ));
  }
}
