import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/values/keys.dart';

class MapsService {
  Future<List<Group>> getPoints() async {
    final url = Uri.parse('${Keys.URL_SERVICE}/app/groups');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        List<Group> groups = [];

        for (var groupData in result['groups']) {
          double? longitude = _parseCoordinate(groupData['LONGITUD']);
          double? latitude = _parseCoordinate(groupData['LATITUD']);

          if (longitude != null && latitude != null) {
            Position position = Position(longitude, latitude);
            Group group = Group(
              groupData['NOMCASAVIDA'],
              groupData['HORARIO'],
              groupData['COLOR'],
              position,
            );
            groups.add(group);
          }
        }

        return groups;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  double? _parseCoordinate(dynamic coord) {
    try {
      if (coord is String) {
        return double.parse(coord);
      } else if (coord is num) {
        return coord.toDouble();
      }
    } catch (e) {
      // print('Error al convertir la coordenada: $e');
    }
    return null;
  }
}

class Position {
  final double longitude;
  final double latitude;

  Position(this.longitude, this.latitude);

  @override
  String toString() {
    return 'Position: {longitude: $longitude, latitude: $latitude}';
  }
}

class Group {
  final String name;
  final String schedule;
  final String color;
  final Position position;

  Group(this.name, this.schedule, this.color, this.position);

  @override
  String toString() {
    return 'Group: {name: $name, schedule: $schedule, color: $color, position: $position}';
  }
}
