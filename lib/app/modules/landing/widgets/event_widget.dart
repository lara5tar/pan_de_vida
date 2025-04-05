import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/event/widgets/event_detail_dialog.dart';
import 'package:pan_de_vida/app/routes/app_pages.dart';
import 'package:pan_de_vida/core/utils/calendar_utils.dart';

import '../controllers/event_widget_controller.dart';

class EventWidget extends GetView<EventWidgetController> {
  const EventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? Container(
              height: 200,
              margin: const EdgeInsets.all(20),
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                //ver mas
                const SizedBox(height: 20),
                verMasBar(),
                InkWell(
                  onTap: () {
                    //
                    showEventDetailDialog(
                      controller.events[controller.currentIndex.value],
                      formatDateHeader,
                    );
                  },
                  child: SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: controller.events.length,
                      onPageChanged: (index) {
                        controller.currentIndex.value = index;
                      },
                      itemBuilder: (context, index) {
                        final event = controller.events[index];
                        return Container(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          // padding: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(0, 5),
                              ),
                            ],
                            image: DecorationImage(
                              alignment: Alignment.topCenter,
                              image: NetworkImage(
                                event.urlImage,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF072F49),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        event.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // const SizedBox(height: 10),
                                      Text(
                                        event.isAllDay
                                            ? 'Todo el día'
                                            : '${event.startTime} - ${event.endTime}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade700,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          controller.getMonth(event),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 70,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            controller.getEventDate(event),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            controller.obtenerDiaDeFecha(
                                              event.startDate,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _buildPageIndicator(),
              ],
            ),
    );
  }

  Container verMasBar() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Eventos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30,
            child: TextButton(
              onPressed: () {
                Get.toNamed(Routes.EVENT_CALENDAR);
              },
              child: const Text(
                'Ver más',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(controller.events.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.currentIndex.value == index
                  ? const Color(0xff0f4c75)
                  : Colors.grey,
            ),
          );
        }),
      ),
    );
  }
}
