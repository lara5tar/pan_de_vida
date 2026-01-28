import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/custom_text_field_underline.dart';
import '../../../../../widgets/text_title_widget.dart';
import '../../../../../widgets/text_subtitle_widget.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../data/services/cliente_service.dart';
import '../../../data/models/cliente_model.dart';

class CrearClienteView extends StatefulWidget {
  const CrearClienteView({super.key});

  @override
  State<CrearClienteView> createState() => _CrearClienteViewState();
}

class _CrearClienteViewState extends State<CrearClienteView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _clienteService = ClienteService();
  
  bool _isLoading = false;

  Future<void> _crearCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final resultado = await _clienteService.crearCliente(
        nombre: _nombreController.text,
        telefono: _telefonoController.text.isEmpty 
            ? null 
            : _telefonoController.text,
      );

      setState(() => _isLoading = false);

      if (resultado['error'] == false) {
        final cliente = resultado['data'] as Cliente;
        final esNuevo = resultado['es_nuevo'] ?? true;

        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    esNuevo ? Icons.check_circle : Icons.info,
                    color: esNuevo ? Colors.green : Colors.blue,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    esNuevo ? 'Cliente Creado' : 'Cliente Existente',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    esNuevo
                        ? 'El cliente se ha creado exitosamente.'
                        : 'Este cliente ya existe en el sistema.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID: ${cliente.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Nombre: ${cliente.nombre}'),
                        if (cliente.telefono != null && cliente.telefono!.isNotEmpty)
                          Text('Teléfono: ${cliente.telefono}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back(); // Cerrar diálogo
                          Get.back(result: cliente); // Regresar con el cliente
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (resultado['errors'] != null) {
        // Errores de validación
        String mensajesError = '';
        final errors = resultado['errors'] as Map<String, dynamic>;
        errors.forEach((campo, errores) {
          if (errores is List && errores.isNotEmpty) {
            mensajesError += '• ${errores[0]}\n';
          }
        });
        _mostrarError(mensajesError);
      } else {
        _mostrarError(resultado['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _mostrarError('Error inesperado: $e');
    }
  }

  void _mostrarError(String mensaje) {
    Get.snackbar(
      'Error',
      mensaje,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: _isLoading
          ? const LoadingWidget()
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const TextTitleWidget('Crear Cliente'),
                      const TextSubtitleWidget(
                          'Registra un nuevo cliente para apartados'),
                      const SizedBox(height: 32),

                      // Icono central
                      Center(
                        child: Icon(
                          Icons.person_add,
                          size: 80,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Campo nombre
                      CustomTextFieldUnderline(
                        label: 'Nombre del Cliente',
                        hintText: 'Ej: Juan Pérez',
                        typefield: TypeField.TEXT,
                        info: _nombreController,
                      ),
                      const SizedBox(height: 20),

                      // Campo teléfono
                      CustomTextFieldUnderline(
                        label: 'Teléfono (opcional)',
                        hintText: 'Ej: 555-1234',
                        typefield: TypeField.TEXT,
                        info: _telefonoController,
                      ),
                      const SizedBox(height: 16),

                      // Nota informativa
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Si el cliente ya existe, se mostrará su información.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botón crear
                      ButtonWidget(
                        text: 'Crear Cliente',
                        icon: Icons.save,
                        colorIcon: Colors.green,
                        colorText: Colors.green.shade700,
                        onTap: _crearCliente,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}
