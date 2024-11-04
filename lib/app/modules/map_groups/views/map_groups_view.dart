import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';

import '../controllers/map_groups_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapGroupsView extends GetView<MapGroupsController> {
  const MapGroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () {
          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(22.2767, -97.8322), // Coordenada inicial
              zoom: 10,
            ),
            markers: controller.markers,
          );
        },
      ),
    );
  }
}
