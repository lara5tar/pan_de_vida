import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/modules/event/controllers/events_calendar_controller.dart';
import 'package:pan_de_vida/pandevida/app/widgets/custom_scaffold.dart';
import '../widgets/event_calendar_widget.dart';
import '../widgets/event_list_widget.dart';

class EventsCalendarView extends GetView<EventsCalendarController> {
  const EventsCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: "Eventos", icon: Icon(Icons.event_note)),
                Tab(text: "Calendario", icon: Icon(Icons.calendar_today)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Primera pestaña: Calendario expandido
                  EventListWidget(),
                  EventCalendarWidget(),

                  // Segunda pestaña: Lista de eventos
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
