import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:pan_de_vida/pandevida/core/values/keys.dart';
import '../../../data/models/group_attendance_model.dart';
import '../../../data/models/school_attendace_model.dart';
import '../../../data/services/congregante_service.dart';

class DesarrolloAsistenciasController extends GetxController {
  var isLoading = true.obs;
  var groupAttendance = GroupAttendace.empty();
  var schoolAttendance = SchoolAttendace.empty();

  @override
  Future<void> onInit() async {
    super.onInit();

    final parameters = Get.parameters;
    final id = parameters['id'];

    print('=== DesarrolloAsistenciasController ===');
    print('ID recibido: $id');
    print('Todos los parámetros: $parameters');

    if (id != null) {
      await _loadGroupAttendance(id);
      await _loadSchoolAttendance(id);
    } else {
      print('ERROR: id es null, no se pueden cargar asistencias');
    }

    isLoading.value = false;
  }

  Future<void> _loadGroupAttendance(String id) async {
    try {
      final response = await CongregantService().getGroupAttendance(id);
      print('GroupAttendance response: $response');
      if (!response['error']) {
        groupAttendance = response['attendance'];
      }
    } catch (e) {
      print('Error loading group attendance: $e');
    }
  }

  Future<void> _loadSchoolAttendance(String id) async {
    // Llamada directa para ver el status code real
    final String url = '${Keys.URL_SERVICE}/escuela/obtener_asistencia';
    final body = jsonEncode({Keys.COD_CONGREGANTE_KEY: id});

    print('=== SchoolAttendance DEBUG ===');
    print('URL: $url');
    print('Body enviado: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        schoolAttendance = SchoolAttendace.fromJson(jsonDecode(response.body));
      } else {
        print('ERROR: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading school attendance: $e');
    }
  }
}
