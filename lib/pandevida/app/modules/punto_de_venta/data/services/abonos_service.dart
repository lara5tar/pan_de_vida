import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apartado_model.dart';
import '../models/abono_model.dart';

class AbonosService {
  // URL base del servidor de inventario - RUTA MÓVIL
  static const String baseUrl = 'https://inventario.sistemasdevida.com/api/v1/movil';

  /// Obtiene todos los apartados o busca uno específico por folio
  ///
  /// Si [folio] es null o vacío, devuelve todos los apartados
  /// Returns: Map con estructura {'success': bool, 'data': dynamic, 'message': String}
  /// - Si hay folio: 'data' es un Apartado
  /// - Si no hay folio: 'data' es List<Apartado>
  Future<Map<String, dynamic>> buscarPorFolio([String? folio]) async {
    try {
      final url = (folio == null || folio.isEmpty)
          ? '$baseUrl/apartados/buscar-folio'
          : '$baseUrl/apartados/buscar-folio/$folio';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      // Verificar si el servidor devolvió HTML (error 404 o ruta no implementada)
      if (response.headers['content-type']?.contains('text/html') == true) {
        return {
          'success': false,
          'message':
              'La funcionalidad de abonos no está implementada en el servidor. Contacta al administrador.',
        };
      }

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Si data es una lista (sin folio), convertir a lista de Apartados
        if (data['data'] is List) {
          final List<Apartado> apartados = (data['data'] as List)
              .map((e) => Apartado.fromJson(e))
              .toList();
          return {
            'success': true,
            'data': apartados,
          };
        } else {
          // Si data es un objeto (con folio), devolver un solo Apartado
          return {
            'success': true,
            'data': Apartado.fromJson(data['data']),
          };
        }
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al buscar el apartado',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Busca apartados por nombre de cliente o devuelve todos
  ///
  /// Si [nombre] es null o vacío, devuelve todos los clientes con apartados
  /// Returns: Map con estructura {'success': bool, 'data': List<ClienteConApartados>, 'message': String}
  Future<Map<String, dynamic>> buscarPorCliente([String? nombre]) async {
    try {
      final url = (nombre == null || nombre.isEmpty)
          ? '$baseUrl/apartados/buscar-cliente'
          : '$baseUrl/apartados/buscar-cliente?nombre=$nombre';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      // Verificar si el servidor devolvió HTML (error 404 o ruta no implementada)
      if (response.headers['content-type']?.contains('text/html') == true) {
        return {
          'success': false,
          'message':
              'La funcionalidad de abonos no está implementada en el servidor. Contacta al administrador.',
        };
      }

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List<ClienteConApartados> clientes = (data['data'] as List)
            .map((e) => ClienteConApartados.fromJson(e))
            .toList();

        return {
          'success': true,
          'data': clientes,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'No se encontraron apartados',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Registra un nuevo abono en un apartado
  ///
  /// Returns: Map con estructura {'success': bool, 'data': RegistroAbonoResponse, 'message': String}
  Future<Map<String, dynamic>> registrarAbono(CrearAbonoRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/abonos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      // Verificar si el servidor devolvió HTML (error 404 o ruta no implementada)
      if (response.headers['content-type']?.contains('text/html') == true) {
        return {
          'success': false,
          'message':
              'La funcionalidad de abonos no está implementada en el servidor. Contacta al administrador.',
        };
      }

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'data': RegistroAbonoResponse.fromJson(data['data']),
          'message': data['message'] ?? 'Abono registrado exitosamente',
        };
      } else {
        // Manejar errores de validación (422) o de negocio (400)
        return {
          'success': false,
          'message': data['message'] ?? 'Error al registrar el abono',
          'errors': data['errors'], // Errores de validación
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Obtiene el historial de abonos de un apartado
  ///
  /// Returns: Map con estructura {'success': bool, 'apartado': Map, 'abonos': List<Abono>, 'message': String}
  Future<Map<String, dynamic>> obtenerHistorialAbonos(int apartadoId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/apartados/$apartadoId/abonos'),
        headers: {'Content-Type': 'application/json'},
      );

      // Verificar si el servidor devolvió HTML (error 404 o ruta no implementada)
      if (response.headers['content-type']?.contains('text/html') == true) {
        return {
          'success': false,
          'message':
              'La funcionalidad de abonos no está implementada en el servidor. Contacta al administrador.',
        };
      }

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List<Abono> abonos = (data['data']['abonos'] as List)
            .map((e) => Abono.fromJson(e))
            .toList();

        return {
          'success': true,
          'apartado': data['data']['apartado'],
          'abonos': abonos,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al obtener historial de abonos',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}
