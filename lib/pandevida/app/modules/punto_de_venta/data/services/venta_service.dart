import 'dart:convert';
import 'package:http/http.dart' as http;

class VentaService {
  static const String baseUrl = 'https://inventario.sistemasdevida.com/api/v1/movil';

  /// Crear venta normal desde un subinventario específico
  Future<Map<String, dynamic>> crearVenta({
    required int subinventarioId,
    required String codCongregante,
    required String fechaVenta,
    required String tipoPago,
    required String usuario,
    required List<Map<String, dynamic>> libros,
    double? descuentoGlobal,
    String? observaciones,
  }) async {
    try {
      final body = {
        'subinventario_id': subinventarioId,
        'cod_congregante': codCongregante,
        'fecha_venta': fechaVenta,
        'tipo_pago': tipoPago,
        'usuario': usuario,
        'libros': libros,
        if (descuentoGlobal != null) 'descuento_global': descuentoGlobal,
        if (observaciones != null) 'observaciones': observaciones,
      };

      print('VentaService.crearVenta: $baseUrl/ventas');
      print('Body: ${json.encode(body)}');

      final response = await http.post(
        Uri.parse('$baseUrl/ventas'),
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
          'data': data['data'],
          'message': data['message'] ?? 'Venta registrada exitosamente',
        };
      } else {
        return {
          'error': true,
          'message': data['message'] ?? 'Error al registrar la venta',
        };
      }
    } catch (e) {
      print('Error en crearVenta: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Crear venta como ADMIN LIBRERIA (desde cualquier inventario)
  Future<Map<String, dynamic>> crearVentaAdmin({
    required List<Map<String, dynamic>> roles,
    required String tipoInventario, // 'general' o 'subinventario'
    int? subinventarioId, // Requerido si tipoInventario es 'subinventario'
    required String fechaVenta,
    required String tipoPago,
    required String usuario,
    required List<Map<String, dynamic>> libros,
    double? descuentoGlobal,
    String? observaciones,
  }) async {
    try {
      final body = {
        'tipo_inventario': tipoInventario,
        if (subinventarioId != null) 'subinventario_id': subinventarioId,
        'fecha_venta': fechaVenta,
        'tipo_pago': tipoPago,
        'usuario': usuario,
        'libros': libros,
        if (descuentoGlobal != null) 'descuento_global': descuentoGlobal,
        if (observaciones != null) 'observaciones': observaciones,
      };

      print('VentaService.crearVentaAdmin: $baseUrl/admin/ventas');
      print('Roles: ${json.encode(roles)}');
      print('Body: ${json.encode(body)}');

      final response = await http.post(
        Uri.parse('$baseUrl/admin/ventas'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Roles': json.encode(roles),
        },
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'error': false,
          'data': data['data'],
          'message': data['message'] ?? 'Venta registrada exitosamente',
        };
      } else {
        return {
          'error': true,
          'message': data['message'] ?? 'Error al registrar la venta',
        };
      }
    } catch (e) {
      print('Error en crearVentaAdmin: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Listar puntos de venta disponibles para admin
  Future<Map<String, dynamic>> listarPuntosVentaAdmin({
    required List<Map<String, dynamic>> roles,
  }) async {
    try {
      print('VentaService.listarPuntosVentaAdmin: $baseUrl/admin/puntos-venta');
      print('Roles: ${json.encode(roles)}');

      final response = await http.get(
        Uri.parse('$baseUrl/admin/puntos-venta'),
        headers: {
          'Accept': 'application/json',
          'X-Roles': json.encode(roles),
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'error': false,
          'data': data['data'],
          'message': 'Puntos de venta cargados exitosamente',
        };
      } else {
        return {
          'error': true,
          'message': data['message'] ?? 'Error al cargar puntos de venta',
        };
      }
    } catch (e) {
      print('Error en listarPuntosVentaAdmin: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}
