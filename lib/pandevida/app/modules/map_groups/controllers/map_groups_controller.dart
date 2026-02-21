import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pan_de_vida/pandevida/app/data/services/gps_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/services/maps_service.dart';

class MapGroupsController extends GetxController {
  RxSet<Marker> markers = <Marker>{}.obs;
  var nearbyMarkers = <Marker>[].obs;
  var bottomSheetVisible = false.obs;
  late GoogleMapController googleMapController;
  var isSelectedMarker = false.obs;
  
  // Variables para mostrar info del grupo seleccionado
  var selectedGroupName = ''.obs;
  var selectedGroupSchedule = ''.obs;
  var selectedGroupLat = 0.0.obs;
  var selectedGroupLng = 0.0.obs;
  var showGroupDialog = false.obs;

  final MapsService apiService = MapsService();

  @override
  void onInit() {
    super.onInit();

    loadMarkers().then((_) {
      getNearbyGroups();
    });
  }

  void goToMarker(Marker marker) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: marker.position,
          zoom: 15,
        ),
      ),
    );
    bottomSheetVisible.value = false;
    isSelectedMarker.value = true;
    googleMapController.showMarkerInfoWindow(marker.markerId);
  }

  Future<void> navigateToLocation(double lat, double lng) async {
    final Uri navigationUri = Uri.parse('google.navigation:q=$lat,$lng&mode=d');
    final Uri fallbackUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');

    try {
      if (await canLaunchUrl(navigationUri)) {
        await launchUrl(navigationUri);
      } else {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo abrir la navegación',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> openInMaps(double lat, double lng) async {
    final Uri mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    try {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo abrir Google Maps',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadMarkers() async {
    List<Group> groups = await apiService.getPoints();
    Set<Marker> newMarkers = {};

    for (var group in groups) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(group.name),
          position: LatLng(group.position.latitude, group.position.longitude),
          infoWindow: InfoWindow(
            title: group.name,
            snippet: group.schedule,
          ),
          onTap: () {
            // Guardar información del grupo seleccionado
            selectedGroupName.value = group.name;
            selectedGroupSchedule.value = group.schedule;
            selectedGroupLat.value = group.position.latitude;
            selectedGroupLng.value = group.position.longitude;
            showGroupDialog.value = true;
          },
          icon: getColorIcon(group.color),
        ),
      );
    }

    markers.assignAll(newMarkers);
  }

  Future<void> getNearbyGroups() async {
    GpsService gpsService = GpsService();
    nearbyMarkers.assignAll(await gpsService.getNearbyGroups(markers));

    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: nearbyMarkers[0].position,
          zoom: 10,
        ),
      ),
    );
    // print(nearbyMarkers.length);y
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
