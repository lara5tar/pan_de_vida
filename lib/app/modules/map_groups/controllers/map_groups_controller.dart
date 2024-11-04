import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pan_de_vida/app/data/services/maps_service.dart';

class MapGroupsController extends GetxController {
  RxSet<Marker> markers = <Marker>{}.obs;

  final MapsService apiService = MapsService();

  @override
  void onInit() {
    super.onInit();
    loadMarkers();
  }

  Future<void> loadMarkers() async {
    List<Group> groups = await apiService.getPoints();
    Set<Marker> newMarkers = {};

    for (var group in groups) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(group.name),
          position: LatLng(group.position.latitude, group.position.longitude),
          infoWindow: InfoWindow(title: group.name, snippet: group.schedule),
          icon: getColorIcon(group.color),
        ),
      );
    }

    markers.assignAll(newMarkers);
  }

  BitmapDescriptor getColorIcon(String color) {
    color = color.toLowerCase();
    //red o rojo, green , orange, purple, gris, azul, yellow, blanco
    switch (color) {
      case 'red' || 'rojo':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'green' || 'verde':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'orange' || 'naranja':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      case 'purple' || 'morado':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      case 'gray' || 'gris':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
      case 'blue' || 'azul':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'yellow' || 'amarillo':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      case 'white' || 'blanco':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }
}
