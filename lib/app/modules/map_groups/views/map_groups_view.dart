import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../controllers/map_groups_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapGroupsView extends GetView<MapGroupsController> {
  const MapGroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScaffold(
        setBanner: false,
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController googleMapController) {
                controller.googleMapController = googleMapController;
              },
              //quita los controles de zoom
              zoomControlsEnabled: false,
              initialCameraPosition: const CameraPosition(
                target: LatLng(22.2767, -97.8322), // Coordenada inicial
                zoom: 12,
              ),
              markers: controller.markers,
            ),
            if (controller.bottomSheetVisible.value)
              Positioned.fill(
                child: InkWell(
                  onTap: () {
                    controller.bottomSheetVisible.value =
                        !controller.bottomSheetVisible.value;
                  },
                ),
              ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                height: 50,
                width: Get.width,
                child: IconButton(
                  style: ButtonStyle(
                    //pon shape para tener borderradius top left y top right
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    controller.bottomSheetVisible.value =
                        !controller.bottomSheetVisible.value;
                  },
                  icon: const Icon(
                    Icons.arrow_drop_up,
                  ),
                ),
              ),
            )
          ],
        ),
        bottomSheet: controller.bottomSheetVisible.value
            ? Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                height: 350,
                width: Get.width,
                child: controller.nearbyMarkers.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              controller.bottomSheetVisible.value =
                                  !controller.bottomSheetVisible.value;
                            },
                            icon: const Icon(
                              Icons.arrow_drop_down,
                            ),
                          ),
                          const Text(
                            'Grupos cercanos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                ...controller.nearbyMarkers.map((marker) {
                                  return ListTile(
                                    onTap: () {
                                      controller.goToMarker(marker);
                                    },
                                    title: Text(marker.infoWindow.title ?? ''),
                                    subtitle:
                                        Text(marker.infoWindow.snippet ?? ''),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
              )
            : null,
      ),
    );
  }
}
