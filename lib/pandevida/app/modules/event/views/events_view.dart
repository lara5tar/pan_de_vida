import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/pandevida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/pandevida/app/widgets/text_subtitle_widget.dart';
import 'package:pan_de_vida/pandevida/app/widgets/text_title_widget.dart';

import '../../../data/models/event_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/events_controller.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 20),
                  const TextTitleWidget('Eventos'),
                  const TextSubtitleWidget('Próximos eventos'),
                  ..._buildEvents(controller.futureEvents),
                  const TextSubtitleWidget('Eventos pasados'),
                  ..._buildEvents(controller.pastEvents),
                  const TextSubtitleWidget('Eventos recurrentes'),
                  ..._buildEvents(controller.recurringEvents),
                  const TextSubtitleWidget('Eventos desactivados'),
                  ..._buildEvents(controller.desactivatedEvents),
                ],
              ),
      ),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () {
          Get.toNamed(Routes.EVENT_FORM);
        },
        icon: Icons.add,
      ),
    );
  }

  List<Widget> _buildEvents(List<Event> events) {
    return events.isEmpty
        ? [
            ButtonWidget(
              text: 'No hay eventos',
              icon: Icons.event_busy,
              colorIcon: Colors.blue.shade800,
              isLast: true,
            ),
          ]
        : events
            .map(
              (event) => ButtonWidget(
                text: event.title,
                icon: Icons.event,
                subtitle: controller.getEventSubtitle(event),
                colorIcon: Colors.blue.shade800,
                trailingWidget: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  color: Colors.blue.shade800,
                  onPressed: () {
                    Get.toNamed(Routes.EVENT_FORM, arguments: event);
                  },
                ),
                // trailingWidget: Container(
                //   color: Colors.black,
                //   height: 80,
                //   child: Image.network(event.urlImage, fit: BoxFit.cover),
                // ),
                isLast: events.indexOf(event) == events.length - 1,
              ),
            )
            .toList();
  }
}
