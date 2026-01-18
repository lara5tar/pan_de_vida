import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente_model.dart';

class ClienteService {
  static const String baseUrl = 'https://inventario.sistemasdevida.com/api/v1/movil';

  /// Obtiene la lista de todos los clientes sin paginación
  Future<Map<String, dynamic>> getClientes({String? search}) async {
    try {
      // Construir URL con parámetros
      var url = '$baseUrl/clientes?sin_paginacion=1';
      if (search != null && search.isNotEmpty) {
        url += '&search=${Uri.encodeComponent(search)}';
      }

      final uri = Uri.parse(url);
      print('ClienteService.getClientes: $uri');

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          List<Cliente> clientes = [];

          for (var item in data['data']) {
            clientes.add(Cliente.fromJson(item));
          }

          return {
            'error': false,
            'data': clientes,
            'total': data['total'] ?? clientes.length,
            'message': 'Clientes cargados exitosamente',
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'No se encontraron clientes',
          };
        }
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en getClientes: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Buscar clientes por nombre o teléfono
  Future<Map<String, dynamic>> buscarClientes(String query) async {
    if (query.isEmpty) {
      return getClientes();
    }
    return getClientes(search: query);
  }

  /// Crear un nuevo cliente
  Future<Map<String, dynamic>> crearCliente({
    required String nombre,
    String? telefono,
  }) async {
    try {
      final body = {
        'nombre': nombre.trim(),
      };
      
      if (telefono != null && telefono.trim().isNotEmpty) {
        body['telefono'] = telefono.trim();
      }

      print('ClienteService.crearCliente: $baseUrl/clientes');
      print('Body: ${json.encode(body)}');

      final response = await http.post(
        Uri.parse('$baseUrl/clientes'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'error': false,
          'data': Cliente.fromJson(data['data']),
          'message': data['message'],
          'es_nuevo': data['data']['es_nuevo'] ?? true,
        };
      } else if (response.statusCode == 422) {
        // Errores de validación
        return {
          'error': true,
          'errors': data['errors'],
          'message': data['message'] ?? 'Errores de validación',
        };
      } else {
        return {
          'error': true,
          'message': data['message'] ?? 'Error al crear cliente',
        };
      }
    } catch (e) {
      print('Error en crearCliente: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}
