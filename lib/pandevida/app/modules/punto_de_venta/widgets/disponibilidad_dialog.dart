import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/disponibilidad_model.dart';
import '../data/services/subinventario_service.dart';

/// Diálogo para consultar disponibilidad de un libro en otros lugares
Future<void> showDisponibilidadDialog({
  required int libroId,
  required String libroNombre,
}) async {
  await Get.dialog(
    DisponibilidadDialog(
      libroId: libroId,
      libroNombre: libroNombre,
    ),
    barrierDismissible: true,
  );
}

class DisponibilidadDialog extends StatefulWidget {
  final int libroId;
  final String libroNombre;

  const DisponibilidadDialog({
    super.key,
    required this.libroId,
    required this.libroNombre,
  });

  @override
  State<DisponibilidadDialog> createState() => _DisponibilidadDialogState();
}

class _DisponibilidadDialogState extends State<DisponibilidadDialog> {
  final subinventarioService = SubinventarioService();
  bool isLoading = true;
  String? errorMessage;
  DisponibilidadLibro? disponibilidad;

  @override
  void initState() {
    super.initState();
    _cargarDisponibilidad();
  }

  Future<void> _cargarDisponibilidad() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result =
          await subinventarioService.getDisponibilidadLibro(widget.libroId);

      if (result['error'] == false) {
        setState(() {
          disponibilidad = result['data'] as DisponibilidadLibro;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = result['message'] ?? 'Error al consultar';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white.withOpacity(0.95),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 650),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header - Estilo similar a TextTitleWidget
            Container(
              color: Colors.white.withOpacity(0.8),
              padding: const EdgeInsets.only(
                  left: 20, right: 10, top: 20, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Disponibilidad del Libro',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.libroNombre,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.grey[600],
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.blue[900],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Consultando disponibilidad...',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: _cargarDisponibilidad,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[900],
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _buildDisponibilidadContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisponibilidadContent() {
    if (disponibilidad == null) {
      return const Center(child: Text('No hay datos disponibles'));
    }

    final disp = disponibilidad!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Información del libro - Estilo ButtonWidget
          _buildButtonItem(
            icon: Icons.menu_book,
            title:
                'Código: ${disp.libro.codigoBarras ?? "Sin código de barras"}',
            text: disp.libro.nombre,
            subtitle: 'Precio: \$${disp.libro.precio.toStringAsFixed(2)}',
            trailing: '${disp.totalDisponible}',
            trailingColor:
                disp.tieneStock ? Colors.blue[900]! : Colors.grey[600]!,
            isLast: false,
          ),

          // Inventario General - Estilo ButtonWidget
          _buildButtonItem(
            icon: Icons.warehouse,
            title: 'INVENTARIO GENERAL',
            text: disp.inventarioGeneral.disponible
                ? 'Disponible'
                : 'No disponible',
            trailing: '${disp.inventarioGeneral.cantidad}',
            trailingColor: disp.inventarioGeneral.disponible
                ? Colors.blue[900]!
                : Colors.grey[600]!,
            isLast: disp.subinventarios.isEmpty,
          ),

          // Subinventarios - Estilo ButtonWidget
          if (disp.subinventarios.isEmpty)
            Container(
              color: const Color(0xCCFFFFFF),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'No hay stock en otros puntos de venta',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            ...disp.subinventarios.asMap().entries.map((entry) {
              final index = entry.key;
              final sub = entry.value;
              final isLast = index == disp.subinventarios.length - 1;

              return _buildButtonItem(
                icon: Icons.store,
                title: 'ID: ${sub.subinventarioId}',
                text: sub.descripcion,
                subtitle: sub.fechaSubinventario,
                trailing: '${sub.cantidadDisponible}',
                trailingColor: Colors.blue[900]!,
                isLast: isLast,
              );
            }),
        ],
      ),
    );
  }

  Widget _buildButtonItem({
    required IconData icon,
    String? title,
    required String text,
    String? subtitle,
    required String trailing,
    required Color trailingColor,
    required bool isLast,
  }) {
    return Column(
      children: [
        Container(
          color: const Color(0xCCFFFFFF),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 60,
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF616161),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        text.isEmpty ? 'Sin datos' : text,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                child: Center(
                  child: Text(
                    trailing,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: trailingColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 60),
            Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: isLast ? Colors.transparent : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
