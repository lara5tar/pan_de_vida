import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/subinventario_model.dart';
import '../models/disponibilidad_model.dart';

class SubinventarioService {
  static const String baseUrl = 'https://inventario.sistemasdevida.com/api/v1';
  static const String baseUrlMovil = 'https://inventario.sistemasdevida.com/api/v1/movil';

  /// Obtiene todos los puntos de venta (para ADMIN LIBRERIA)
  Future<Map<String, dynamic>> getTodosPuntosVenta(
      List<Map<String, dynamic>> roles) async {
    try {
      final url = Uri.parse('$baseUrlMovil/admin/puntos-venta');
      print('SubinventarioService.getTodosPuntosVenta: $url');
      print('Roles: ${json.encode(roles)}');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'X-Roles': json.encode(roles),
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('📦 Response data type: ${responseData.runtimeType}');
        
        List<Subinventario> subinventarios = [];

        if (responseData is Map<String, dynamic> && responseData['success'] == true) {
          final data = responseData['data'];
          print('📦 Data type: ${data.runtimeType}');
          
          // La respuesta tiene formato: {success: true, data: {inventario_general: {...}, subinventarios: [...]}}
          if (data is Map<String, dynamic>) {
            // Agregar inventario general si existe
            if (data['inventario_general'] != null) {
              try {
                final invGeneral = data['inventario_general'] as Map<String, dynamic>;
                subinventarios.add(Subinventario(
                  id: 0,
                  descripcion: invGeneral['nombre'] ?? 'Inventario General',
                  fechaSubinventario: DateTime.now().toString(),
                  estado: 'activo',
                  totalLibros: 0,
                  totalUnidades: 0,
                ));
                print('✅ Inventario general agregado');
              } catch (e) {
                print('⚠️ Error procesando inventario general: $e');
              }
            }

            // Agregar subinventarios
            if (data['subinventarios'] != null && data['subinventarios'] is List) {
              final subinvList = data['subinventarios'] as List<dynamic>;
              print('📋 Subinventarios encontrados: ${subinvList.length}');
              
              for (var item in subinvList) {
                try {
                  if (item is Map<String, dynamic>) {
                    subinventarios.add(Subinventario.fromJson(item));
                  }
                } catch (e) {
                  print('⚠️ Error procesando subinventario: $e');
                  print('⚠️ Item: $item');
                }
              }
            }
          }
        }

        print('✅ Total subinventarios: ${subinventarios.length}');

        return {
          'error': false,
          'data': subinventarios,
          'message': 'Puntos de venta cargados exitosamente',
        };
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en getTodosPuntosVenta: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Obtiene los subinventarios asignados a un usuario (cod_congregante)
  Future<Map<String, dynamic>> getMisSubinventarios(
      String codCongregante) async {
    try {
      final url = Uri.parse('$baseUrl/mis-subinventarios/$codCongregante');
      print('SubinventarioService.getMisSubinventarios: $url');

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          List<Subinventario> subinventarios = [];

          for (var item in data['data']) {
            subinventarios.add(Subinventario.fromJson(item));
          }

          return {
            'error': false,
            'data': subinventarios,
            'message': data['message'],
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'No se encontraron subinventarios',
          };
        }
      } else if (response.statusCode == 404) {
        return {
          'error': true,
          'message': 'No tienes subinventarios asignados',
        };
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en getMisSubinventarios: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Obtiene los libros de un subinventario específico
  Future<Map<String, dynamic>> getLibrosSubinventario(
    int subinventarioId, {
    String? codCongregante,
  }) async {
    try {
      var url = '$baseUrl/subinventarios/$subinventarioId/libros';
      if (codCongregante != null) {
        url += '?cod_congregante=$codCongregante';
      }

      final uri = Uri.parse(url);
      print('SubinventarioService.getLibrosSubinventario: $uri');

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return {
            'error': false,
            'data': data['data'],
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'No se pudieron cargar los libros',
          };
        }
      } else if (response.statusCode == 403) {
        return {
          'error': true,
          'message': 'No tienes acceso a este subinventario',
        };
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en getLibrosSubinventario: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Buscar libro por código de barras en la API
  Future<Map<String, dynamic>> buscarLibroPorCodigo(String codigo) async {
    try {
      final url = Uri.parse('$baseUrl/libros/buscar-codigo/$codigo');
      print('SubinventarioService.buscarLibroPorCodigo: $url');

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return {
            'error': false,
            'data': data['libro'],
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'Libro no encontrado',
          };
        }
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en buscarLibroPorCodigo: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Crear una venta en el sistema
  Future<Map<String, dynamic>> crearVenta({
    required int subinventarioId,
    required String codCongregante,
    required String fechaVenta,
    required String tipoPago, // 'contado', 'credito', 'mixto'
    required String usuario,
    required List<Map<String, dynamic>> libros,
    int? clienteId,
    double descuentoGlobal = 0,
    String? observaciones,
    bool tieneEnvio = false,
    double? costoEnvio,
    String? direccionEnvio,
    String? telefonoEnvio,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/ventas');
      print('SubinventarioService.crearVenta: $url');

      final body = {
        'subinventario_id': subinventarioId,
        'cod_congregante': codCongregante,
        'fecha_venta': fechaVenta,
        'tipo_pago': tipoPago,
        'usuario': usuario,
        'libros': libros,
        if (clienteId != null) 'cliente_id': clienteId,
        if (descuentoGlobal > 0) 'descuento_global': descuentoGlobal,
        if (observaciones != null && observaciones.isNotEmpty)
          'observaciones': observaciones,
        if (tieneEnvio) 'tiene_envio': true,
        if (tieneEnvio && costoEnvio != null) 'costo_envio': costoEnvio,
        if (tieneEnvio && direccionEnvio != null && direccionEnvio.isNotEmpty)
          'direccion_envio': direccionEnvio,
        if (tieneEnvio && telefonoEnvio != null && telefonoEnvio.isNotEmpty)
          'telefono_envio': telefonoEnvio,
      };

      print('Request body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return {
            'error': false,
            'data': data['data'],
            'message': data['message'] ?? 'Venta creada exitosamente',
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'Error al crear la venta',
          };
        }
      } else if (response.statusCode == 422) {
        final data = json.decode(response.body);
        return {
          'error': true,
          'message': data['message'] ?? 'Error de validación',
        };
      } else if (response.statusCode == 403) {
        final data = json.decode(response.body);
        return {
          'error': true,
          'message':
              data['message'] ?? 'No tienes acceso a este punto de venta',
        };
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
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

  /// Crear un apartado en el sistema
  Future<Map<String, dynamic>> crearApartado({
    required int subinventarioId,
    required String codCongregante,
    required int clienteId,
    required String fechaApartado,
    required double enganche,
    required String usuario,
    required List<Map<String, dynamic>> libros,
    String? fechaLimite,
    String? observaciones,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/apartados');
      print('SubinventarioService.crearApartado: $url');

      final body = {
        'subinventario_id': subinventarioId,
        'cod_congregante': codCongregante,
        'cliente_id': clienteId,
        'fecha_apartado': fechaApartado,
        'enganche': enganche,
        'usuario': usuario,
        'libros': libros,
        if (fechaLimite != null && fechaLimite.isNotEmpty)
          'fecha_limite': fechaLimite,
        if (observaciones != null && observaciones.isNotEmpty)
          'observaciones': observaciones,
      };

      print('Request body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return {
            'error': false,
            'data': data['data'],
            'message': data['message'] ?? 'Apartado creado exitosamente',
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'Error al crear el apartado',
          };
        }
      } else if (response.statusCode == 422) {
        final data = json.decode(response.body);
        return {
          'error': true,
          'message': data['message'] ?? 'Error de validación',
        };
      } else if (response.statusCode == 403) {
        final data = json.decode(response.body);
        return {
          'error': true,
          'message':
              data['message'] ?? 'No tienes acceso a este punto de venta',
        };
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en crearApartado: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Obtener disponibilidad de un libro en inventario general y subinventarios
  Future<Map<String, dynamic>> getDisponibilidadLibro(int libroId) async {
    try {
      final url = Uri.parse('$baseUrl/libros/$libroId/disponibilidad');
      print('SubinventarioService.getDisponibilidadLibro: $url');

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return {
            'error': false,
            'data': DisponibilidadLibro.fromJson(data['data']),
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'Error al consultar disponibilidad',
          };
        }
      } else if (response.statusCode == 404) {
        return {
          'error': true,
          'message': 'Libro no encontrado',
        };
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en getDisponibilidadLibro: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// Buscar TODOS los libros del sistema con info de vendibilidad
  /// Usa la API /api/v1/libros con cod_congregante para saber qué puede vender
  Future<Map<String, dynamic>> buscarTodosLosLibros({
    required String codCongregante,
    String? buscar,
    bool? conStock,
    double? precioMin,
    double? precioMax,
    String? ordenar,
    String? direccion,
    int? perPage,
    int? page,
  }) async {
    try {
      // Construir query parameters
      final queryParams = <String, String>{
        'cod_congregante': codCongregante,
      };

      if (buscar != null && buscar.isNotEmpty) {
        queryParams['buscar'] = buscar;
      }
      if (conStock != null) {
        queryParams['con_stock'] = conStock.toString();
      }
      if (precioMin != null) {
        queryParams['precio_min'] = precioMin.toString();
      }
      if (precioMax != null) {
        queryParams['precio_max'] = precioMax.toString();
      }
      if (ordenar != null) {
        queryParams['ordenar'] = ordenar;
      }
      if (direccion != null) {
        queryParams['direccion'] = direccion;
      }
      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }
      if (page != null) {
        queryParams['page'] = page.toString();
      }

      final url = Uri.parse('\$baseUrl/libros').replace(
        queryParameters: queryParams,
      );

      print('SubinventarioService.buscarTodosLosLibros: $url');

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return {
            'error': false,
            'data': data['data'],
            'pagination': data['pagination'],
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'Error al buscar libros',
          };
        }
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en buscarTodosLosLibros: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  /// API de Testeo - Obtiene TODOS los libros con vendibilidad por subinventario
  /// GET /api/v1/test/todos-los-libros
  Future<Map<String, dynamic>> getTodosLosLibrosConVendibilidad({
    required int subinventarioId,
    String? codCongregante,
    String? buscar,
    bool? conStock,
    double? precioMin,
    double? precioMax,
    String? ordenar,
    String? direccion,
    int? perPage,
    int? page,
  }) async {
    try {
      // Construir query parameters
      final queryParams = <String, String>{
        'subinventario_id': subinventarioId.toString(),
      };

      if (codCongregante != null && codCongregante.isNotEmpty) {
        queryParams['cod_congregante'] = codCongregante;
      }
      if (buscar != null && buscar.isNotEmpty) {
        queryParams['buscar'] = buscar;
      }
      if (conStock != null) {
        queryParams['con_stock'] = conStock.toString();
      }
      if (precioMin != null) {
        queryParams['precio_min'] = precioMin.toString();
      }
      if (precioMax != null) {
        queryParams['precio_max'] = precioMax.toString();
      }
      if (ordenar != null) {
        queryParams['ordenar'] = ordenar;
      }
      if (direccion != null) {
        queryParams['direccion'] = direccion;
      }
      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }
      if (page != null) {
        queryParams['page'] = page.toString();
      }

      final url = Uri.parse('$baseUrl/test/todos-los-libros').replace(
        queryParameters: queryParams,
      );

      print('SubinventarioService.getTodosLosLibrosConVendibilidad: $url');

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return {
            'error': false,
            'data': data['data'],
            'pagination': data['pagination'],
            'resumen': data['resumen'],
            'subinventario_actual': data['subinventario_actual'],
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'Error al buscar libros',
          };
        }
      } else if (response.statusCode == 403) {
        final data = json.decode(response.body);
        return {
          'error': true,
          'message': data['message'] ?? 'Acceso denegado',
        };
      } else {
        return {
          'error': true,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error en getTodosLosLibrosConVendibilidad: $e');
      return {
        'error': true,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}
