import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/apartado_model.dart';
import '../../../data/models/abono_model.dart';
import '../../../data/services/abonos_service.dart';

class AbonosController extends GetxController {
  final AbonosService _abonosService = AbonosService();

  // Estado de carga
  final isLoading = false.obs;

  // Tipo de búsqueda seleccionado
  final tipoBusqueda = 'folio'.obs;

  // Controladores de formularios
  final TextEditingController busquedaController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  final TextEditingController comprobanteController = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();

  // Método de pago seleccionado
  final metodoPagoSeleccionado = 'Efectivo'.obs;

  // Resultados de búsqueda
  final apartadoEncontrado = Rxn<Apartado>();
  final clientesConApartados = <ClienteConApartados>[].obs;
  final apartadosEncontrados = <Apartado>[].obs;

  // Apartado seleccionado para registrar abono
  final apartadoSeleccionado = Rxn<Apartado>();

  // Historial de abonos
  final historialAbonos = <Abono>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Cargar todos los apartados al iniciar
    cargarTodosLosApartados();
  }

  @override
  void onClose() {
    busquedaController.dispose();
    montoController.dispose();
    comprobanteController.dispose();
    observacionesController.dispose();
    super.onClose();
  }

  /// Busca apartado según el tipo de búsqueda seleccionado
  /// Si el campo está vacío, carga todos los apartados
  Future<void> buscarApartado() async {
    final busqueda = busquedaController.text.trim();

    isLoading.value = true;
    limpiarResultados();

    try {
      if (tipoBusqueda.value == 'folio') {
        await _buscarPorFolio(busqueda.isEmpty ? null : busqueda);
      } else {
        await _buscarPorCliente(busqueda.isEmpty ? null : busqueda);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Carga todos los apartados al iniciar la pantalla
  Future<void> cargarTodosLosApartados() async {
    print('🔄 Iniciando carga de apartados...');
    isLoading.value = true;
    limpiarResultados();

    try {
      // Por defecto cargar por folio (devuelve lista de todos)
      await _buscarPorFolio(null);
      print('✅ Carga completada. Clientes: ${clientesConApartados.length}');
    } catch (e) {
      print('❌ Error en carga: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Busca apartado por folio o devuelve todos
  Future<void> _buscarPorFolio(String? folio) async {
    print('🔍 Buscando por folio: ${folio ?? "TODOS"}');
    final resultado = await _abonosService.buscarPorFolio(folio);
    print('📦 Resultado success: ${resultado['success']}');

    if (resultado['success'] == true) {
      final data = resultado['data'];
      print('📊 Tipo de data: ${data.runtimeType}');
      
      // Si es una lista (sin folio), guardar lista de apartados
      if (data is List<Apartado>) {
        print('📋 Es lista con ${data.length} apartados');
        
        // Guardar lista de apartados individuales
        apartadosEncontrados.value = data;
        
        print('✅ apartadosEncontrados.length: ${apartadosEncontrados.length}');
        
        if (folio == null) {
          // Carga inicial silenciosa
          print('${data.length} apartados cargados');
        } else {
          Get.snackbar(
            'Resultados encontrados',
            'Se encontraron ${data.length} apartado(s)',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else if (data is Apartado) {
        print('📄 Es apartado individual');
        // Si es un objeto individual (con folio), ir directamente a registrar abono
        Get.snackbar(
          'Apartado encontrado',
          'Folio: ${data.folio}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
        // Ir directamente a registrar abono
        irARegistrarAbono(data);
      }
    } else {
      print('❌ Error: ${resultado['message']}');
      Get.snackbar(
        'No encontrado',
        resultado['message'] ?? 'No se encontró el apartado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Busca apartados por nombre de cliente o devuelve todos
  Future<void> _buscarPorCliente(String? nombre) async {
    final resultado = await _abonosService.buscarPorCliente(nombre);

    if (resultado['success'] == true) {
      final clientesData = resultado['data'] as List<ClienteConApartados>;
      
      // Desagrupar apartados para mostrarlos individualmente
      final List<Apartado> todosLosApartados = [];
      for (var cliente in clientesData) {
        todosLosApartados.addAll(cliente.apartados);
      }
      
      apartadosEncontrados.value = todosLosApartados;

      if (apartadosEncontrados.isEmpty) {
        Get.snackbar(
          'Sin resultados',
          nombre == null || nombre.isEmpty
              ? 'No hay apartados registrados'
              : 'No se encontraron apartados para "$nombre"',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        if (nombre != null && nombre.isNotEmpty) {
          Get.snackbar(
            'Resultados encontrados',
            'Se encontraron ${apartadosEncontrados.length} apartado(s)',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          // Carga inicial silenciosa
          print('${apartadosEncontrados.length} apartados cargados');
        }
      }
    } else {
      Get.snackbar(
        'Error',
        resultado['message'] ?? 'Error al buscar apartados',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Limpia los resultados de búsqueda
  void limpiarResultados() {
    apartadoEncontrado.value = null;
    clientesConApartados.clear();
    apartadosEncontrados.clear();
  }

  /// Navega a la vista de registrar abono
  void irARegistrarAbono(Apartado apartado) {
    apartadoSeleccionado.value = apartado;
    montoController.clear();
    comprobanteController.clear();
    observacionesController.clear();
    metodoPagoSeleccionado.value = 'Efectivo';

    Get.toNamed('/abonos/registrar');
  }

  /// Registra un nuevo abono
  Future<void> registrarAbono() async {
    final apartado = apartadoSeleccionado.value;
    if (apartado == null) {
      Get.snackbar(
        'Error',
        'No hay apartado seleccionado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validar monto
    final montoText = montoController.text.trim();
    if (montoText.isEmpty) {
      Get.snackbar(
        'Campo requerido',
        'Por favor ingresa el monto del abono',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final monto = double.tryParse(montoText);
    if (monto == null || monto <= 0) {
      Get.snackbar(
        'Monto inválido',
        'El monto debe ser un número mayor a 0',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (monto > apartado.saldoPendiente) {
      Get.snackbar(
        'Monto excede saldo',
        'El monto no puede ser mayor al saldo pendiente (\$${apartado.saldoPendiente.toStringAsFixed(2)})',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Confirmar acción
    final confirmar = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirmar abono'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apartado: ${apartado.folio}'),
            Text('Cliente: ${apartado.cliente.nombre}'),
            const Divider(),
            Text(
              'Monto: \$${monto.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
                'Método: ${_getMetodoPagoLabel(metodoPagoSeleccionado.value)}'),
            const Divider(),
            Text(
              'Nuevo saldo: \$${(apartado.saldoPendiente - monto).toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    // Registrar abono
    isLoading.value = true;

    try {
      // TODO: Obtener el usuario actual del sistema
      final usuario = 'usuario_actual'; // Cambiar por el usuario real

      final request = CrearAbonoRequest(
        apartadoId: apartado.id,
        monto: monto,
        metodoPago: _getMetodoPagoValue(metodoPagoSeleccionado.value),
        comprobante: comprobanteController.text.trim().isNotEmpty
            ? comprobanteController.text.trim()
            : null,
        observaciones: observacionesController.text.trim().isNotEmpty
            ? observacionesController.text.trim()
            : null,
        usuario: usuario,
      );

      final resultado = await _abonosService.registrarAbono(request);

      if (resultado['success'] == true) {
        final response = resultado['data'] as RegistroAbonoResponse;

        Get.snackbar(
          'Abono registrado',
          resultado['message'] ?? 'El abono se registró exitosamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Actualizar el apartado seleccionado con los nuevos datos
        final nuevoApartado = apartadoEncontrado.value?.copyWith(
          saldoPendiente: response.apartado.saldoPendiente,
          totalPagado: apartado.montoTotal - response.apartado.saldoPendiente,
          estado: response.apartado.estado,
        );

        if (nuevoApartado != null) {
          apartadoEncontrado.value = nuevoApartado;
          apartadoSeleccionado.value = nuevoApartado;
        }

        // Limpiar formulario
        montoController.clear();
        comprobanteController.clear();
        observacionesController.clear();

        // Regresar a la búsqueda si el apartado fue liquidado
        if (response.apartado.estado == 'liquidado') {
          Get.dialog(
            AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 32),
                  SizedBox(width: 8),
                  Text('¡Apartado Liquidado!'),
                ],
              ),
              content: const Text(
                'El apartado ha sido liquidado completamente.',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Cerrar el diálogo
                    Get.back(); // Volver a la búsqueda
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          resultado['message'] ?? 'Error al registrar el abono',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Ver historial de abonos del apartado seleccionado
  Future<void> verHistorialAbonos() async {
    final apartado = apartadoSeleccionado.value;
    if (apartado == null) return;

    isLoading.value = true;

    try {
      final resultado =
          await _abonosService.obtenerHistorialAbonos(apartado.id);

      if (resultado['success'] == true) {
        historialAbonos.value = resultado['abonos'] as List<Abono>;
        Get.toNamed('/abonos/historial');
      } else {
        Get.snackbar(
          'Error',
          resultado['message'] ?? 'Error al obtener el historial',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper para obtener el label del método de pago
  String _getMetodoPagoLabel(String metodo) {
    switch (metodo) {
      case 'efectivo':
        return 'Efectivo';
      case 'transferencia':
        return 'Transferencia';
      case 'tarjeta':
        return 'Tarjeta';
      case 'Efectivo':
        return 'Efectivo';
      case 'Transferencia':
        return 'Transferencia';
      case 'Tarjeta':
        return 'Tarjeta';
      default:
        return metodo;
    }
  }

  /// Convierte el texto del dropdown al valor esperado por el API
  String _getMetodoPagoValue(String texto) {
    switch (texto) {
      case 'Efectivo':
        return 'efectivo';
      case 'Transferencia':
        return 'transferencia';
      case 'Tarjeta':
        return 'tarjeta';
      default:
        return texto.toLowerCase();
    }
  }
}
