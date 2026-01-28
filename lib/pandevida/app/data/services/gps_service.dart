import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GpsService {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  bool isNearby(Position position, Marker marker) {
    return Geolocator.distanceBetween(position.latitude, position.longitude,
            marker.position.latitude, marker.position.longitude) <=
        1000;
  }

  Future<List<Marker>> getNearbyGroups(
    Set<Marker> markers,
  ) async {
    Position position = await _determinePosition();
    List<Marker> nearbyMarkers = [];

    //ordena del mas cercano al mas lejano

    nearbyMarkers.addAll(markers.toList());

    nearbyMarkers.sort((a, b) {
      return Geolocator.distanceBetween(position.latitude, position.longitude,
              a.position.latitude, a.position.longitude)
          .compareTo(Geolocator.distanceBetween(position.latitude,
              position.longitude, b.position.latitude, b.position.longitude));
    });

    return nearbyMarkers;
  }
}
