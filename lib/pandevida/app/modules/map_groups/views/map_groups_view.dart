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
              onTap: (LatLng latLng) {
                controller.bottomSheetVisible.value = false;
                controller.isSelectedMarker.value = false;
                controller.showGroupDialog.value = false;
              },
              //quita los controles de zoom
              zoomControlsEnabled: false,
              initialCameraPosition: const CameraPosition(
                target: LatLng(22.2767, -97.8322), // Coordenada inicial
                zoom: 12,
              ),
              markers: controller.markers,
              //mover las posiciones de los controles
              // mapToolbarEnabled: false,
              padding: const EdgeInsets.only(bottom: 100),
            ),
            // Tarjeta flotante con información del grupo seleccionado
            if (controller.showGroupDialog.value)
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.selectedGroupName.value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () =>
                                  controller.showGroupDialog.value = false,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.schedule,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                controller.selectedGroupSchedule.value,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.navigateToLocation(
                                controller.selectedGroupLat.value,
                                controller.selectedGroupLng.value,
                              );
                            },
                            icon: const Icon(Icons.navigation, size: 18),
                            label: const Text('Cómo llegar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
              bottom: 60,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  // borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Presiona la ubicación para ver mas información',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),
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
