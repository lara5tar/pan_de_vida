import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cliente_model.dart';
import '../../../data/services/cliente_service.dart';

/// Resultado del diálogo de opciones de venta/apartado
class TransaccionOptions {
  final TipoTransaccion tipo;
  final TipoPago tipoPago;
  final Cliente? cliente;
  final double descuentoGlobal;
  final String? observaciones;
  final bool tieneEnvio;
  final double? costoEnvio;
  final String? direccionEnvio;
  final String? telefonoEnvio;
  final double? enganche; // Solo para apartados
  final DateTime? fechaLimite; // Solo para apartados

  TransaccionOptions({
    required this.tipo,
    required this.tipoPago,
    this.cliente,
    this.descuentoGlobal = 0,
    this.observaciones,
    this.tieneEnvio = false,
    this.costoEnvio,
    this.direccionEnvio,
    this.telefonoEnvio,
    this.enganche,
    this.fechaLimite,
  });
}

enum TipoTransaccion { venta, apartado }

enum TipoPago { contado, credito, mixto }

/// Diálogo para seleccionar opciones de venta o apartado
Future<TransaccionOptions?> showTransaccionOptionsDialog({
  required double totalCarrito,
}) async {
  return await Get.dialog<TransaccionOptions>(
    TransaccionOptionsDialog(totalCarrito: totalCarrito),
    barrierDismissible: false,
  );
}

class TransaccionOptionsDialog extends StatefulWidget {
  final double totalCarrito;

  const TransaccionOptionsDialog({
    super.key,
    required this.totalCarrito,
  });

  @override
  State<TransaccionOptionsDialog> createState() =>
      _TransaccionOptionsDialogState();
}

class _TransaccionOptionsDialogState extends State<TransaccionOptionsDialog> {
  final clienteService = ClienteService();

  TipoTransaccion tipoTransaccion = TipoTransaccion.venta;
  TipoPago tipoPago = TipoPago.contado;
  Cliente? clienteSeleccionado;
  List<Cliente> clientes = [];
  List<Cliente> clientesFiltrados = [];
  bool loadingClientes = false;

  final descuentoController = TextEditingController(text: '0');
  final observacionesController = TextEditingController();
  final searchClienteController = TextEditingController();

  bool tieneEnvio = false;
  final costoEnvioController = TextEditingController(text: '0');
  final direccionEnvioController = TextEditingController();
  final telefonoEnvioController = TextEditingController();

  final engancheController = TextEditingController(text: '0');
  DateTime? fechaLimite;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
    searchClienteController.addListener(_filtrarClientes);
  }

  @override
  void dispose() {
    descuentoController.dispose();
    observacionesController.dispose();
    searchClienteController.dispose();
    costoEnvioController.dispose();
    direccionEnvioController.dispose();
    telefonoEnvioController.dispose();
    engancheController.dispose();
    super.dispose();
  }

  Future<void> _cargarClientes() async {
    setState(() => loadingClientes = true);
    try {
      final result = await clienteService.getClientes();
      if (result['error'] == false) {
        setState(() {
          clientes = result['data'] as List<Cliente>;
          clientesFiltrados = clientes;
        });
      }
    } catch (e) {
      print('Error al cargar clientes: $e');
    } finally {
      setState(() => loadingClientes = false);
    }
  }

  void _filtrarClientes() {
    final query = searchClienteController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        clientesFiltrados = clientes;
      } else {
        clientesFiltrados = clientes.where((cliente) {
          final nombre = cliente.nombre.toLowerCase();
          final telefono = cliente.telefono?.toLowerCase() ?? '';
          return nombre.contains(query) || telefono.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _buscarClientesEnServidor(String query) async {
    if (query.isEmpty) {
      await _cargarClientes();
      return;
    }

    setState(() => loadingClientes = true);
    try {
      final result = await clienteService.buscarClientes(query);
      if (result['error'] == false) {
        setState(() {
          clientes = result['data'] as List<Cliente>;
          clientesFiltrados = clientes;
        });
      }
    } catch (e) {
      print('Error al buscar clientes: $e');
    } finally {
      setState(() => loadingClientes = false);
    }
  }

  bool _validarFormulario() {
    // Validar cliente para crédito
    if (tipoPago == TipoPago.credito && clienteSeleccionado == null) {
      Get.snackbar(
        'Error',
        'Las ventas a crédito requieren seleccionar un cliente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Validar cliente para apartados
    if (tipoTransaccion == TipoTransaccion.apartado &&
        clienteSeleccionado == null) {
      Get.snackbar(
        'Error',
        'Los apartados requieren seleccionar un cliente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Validar enganche en apartados
    if (tipoTransaccion == TipoTransaccion.apartado) {
      final enganche = double.tryParse(engancheController.text) ?? 0;
      if (enganche < 0) {
        Get.snackbar(
          'Error',
          'El enganche no puede ser negativo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
      if (enganche > widget.totalCarrito) {
        Get.snackbar(
          'Error',
          'El enganche no puede ser mayor al total del apartado',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }

    // Validar datos de envío si está activado
    if (tieneEnvio) {
      if (direccionEnvioController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Debe ingresar una dirección de envío',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
      if (telefonoEnvioController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Debe ingresar un teléfono de contacto para el envío',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }

    return true;
  }

  void _confirmar() {
    if (!_validarFormulario()) return;

    final descuento = double.tryParse(descuentoController.text) ?? 0;
    final costoEnvio =
        tieneEnvio ? (double.tryParse(costoEnvioController.text) ?? 0) : null;
    final enganche = tipoTransaccion == TipoTransaccion.apartado
        ? (double.tryParse(engancheController.text) ?? 0)
        : null;

    final options = TransaccionOptions(
      tipo: tipoTransaccion,
      tipoPago: tipoPago,
      cliente: clienteSeleccionado,
      descuentoGlobal: descuento,
      observaciones: observacionesController.text.trim().isNotEmpty
          ? observacionesController.text.trim()
          : null,
      tieneEnvio: tieneEnvio,
      costoEnvio: costoEnvio,
      direccionEnvio: tieneEnvio ? direccionEnvioController.text.trim() : null,
      telefonoEnvio: tieneEnvio ? telefonoEnvioController.text.trim() : null,
      enganche: enganche,
      fechaLimite: fechaLimite,
    );

    Get.back(result: options);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título
                Row(
                  children: [
                    Icon(Icons.point_of_sale,
                        color: Theme.of(context).primaryColor, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Opciones de Transacción',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Total del carrito
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${widget.totalCarrito.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tipo de transacción
                const Text('Tipo de Transacción',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<TipoTransaccion>(
                        title: const Text('💰 Venta'),
                        subtitle: const Text('Pago completo'),
                        value: TipoTransaccion.venta,
                        groupValue: tipoTransaccion,
                        onChanged: (value) {
                          setState(() {
                            tipoTransaccion = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<TipoTransaccion>(
                        title: const Text('📦 Apartado'),
                        subtitle: const Text('Con enganche'),
                        value: TipoTransaccion.apartado,
                        groupValue: tipoTransaccion,
                        onChanged: (value) {
                          setState(() {
                            tipoTransaccion = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tipo de pago (solo para ventas)
                if (tipoTransaccion == TipoTransaccion.venta) ...[
                  const Text('Tipo de Pago',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Contado'),
                        selected: tipoPago == TipoPago.contado,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => tipoPago = TipoPago.contado);
                          }
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Crédito'),
                        selected: tipoPago == TipoPago.credito,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => tipoPago = TipoPago.credito);
                          }
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Mixto'),
                        selected: tipoPago == TipoPago.mixto,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => tipoPago = TipoPago.mixto);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // Cliente (obligatorio para crédito y apartado)
                if (tipoPago == TipoPago.credito ||
                    tipoTransaccion == TipoTransaccion.apartado) ...[
                  Row(
                    children: [
                      const Text('Cliente',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Text('*', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Campo de búsqueda
                  TextField(
                    controller: searchClienteController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Buscar por nombre o teléfono...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchClienteController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchClienteController.clear();
                                _filtrarClientes();
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lista de clientes
                  if (loadingClientes)
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ))
                  else if (clientesFiltrados.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'No se encontraron clientes',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: clientesFiltrados.length,
                        itemBuilder: (context, index) {
                          final cliente = clientesFiltrados[index];
                          final isSelected =
                              clienteSeleccionado?.id == cliente.id;
                          return ListTile(
                            selected: isSelected,
                            selectedTileColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            leading: CircleAvatar(
                              backgroundColor: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade300,
                              child: Text(
                                cliente.nombre[0].toUpperCase(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              cliente.nombre,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : null,
                              ),
                            ),
                            subtitle: cliente.telefono != null
                                ? Text(cliente.telefono!)
                                : null,
                            trailing: isSelected
                                ? Icon(Icons.check_circle,
                                    color: Theme.of(context).primaryColor)
                                : null,
                            onTap: () {
                              setState(() {
                                clienteSeleccionado = cliente;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  if (clienteSeleccionado != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Seleccionado: ${clienteSeleccionado!.nombre}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                if (clienteSeleccionado!.telefono != null)
                                  Text(
                                    clienteSeleccionado!.telefono!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                clienteSeleccionado = null;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],

                // Enganche (solo para apartados)
                if (tipoTransaccion == TipoTransaccion.apartado) ...[
                  const Text('Enganche (Anticipo)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: engancheController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixText: '\$',
                      hintText: '0.00',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 20),

                  // Fecha límite
                  const Text('Fecha Límite (Opcional)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().add(const Duration(days: 7)),
                        firstDate: DateTime.now().add(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => fechaLimite = date);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        fechaLimite != null
                            ? '${fechaLimite!.day}/${fechaLimite!.month}/${fechaLimite!.year}'
                            : 'Sin fecha límite',
                        style: TextStyle(
                          color: fechaLimite != null ? null : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Descuento global
                const Text('Descuento Global (%)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: descuentoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixText: '%',
                    hintText: '0',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),

                // Envío
                CheckboxListTile(
                  title: const Text('Incluir envío'),
                  value: tieneEnvio,
                  onChanged: (value) {
                    setState(() => tieneEnvio = value ?? false);
                  },
                ),
                if (tieneEnvio) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: costoEnvioController,
                    decoration: const InputDecoration(
                      labelText: 'Costo de envío',
                      border: OutlineInputBorder(),
                      prefixText: '\$',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: direccionEnvioController,
                    decoration: const InputDecoration(
                      labelText: 'Dirección de envío *',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: telefonoEnvioController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono de contacto *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                ],

                // Observaciones
                const Text('Observaciones (Opcional)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: observacionesController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Notas adicionales...',
                  ),
                  maxLines: 3,
                  maxLength: 500,
                ),
                const SizedBox(height: 20),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _confirmar,
                        child: Text(
                          tipoTransaccion == TipoTransaccion.venta
                              ? 'Procesar Venta'
                              : 'Crear Apartado',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
