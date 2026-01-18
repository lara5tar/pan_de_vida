import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_title_widget.dart';
import '../../../../../widgets/text_subtitle_widget.dart';
import '../../../../../widgets/search_field_widget.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import '../controllers/abonos_controller.dart';
import '../../../data/models/apartado_model.dart';
import '../widgets/apartado_info_widget.dart';

class BuscarApartadoView extends GetView<AbonosController> {
  const BuscarApartadoView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextTitleWidget('Buscar Apartado'),
            const TextSubtitleWidget(
                'Busca por folio o nombre de cliente para registrar abonos'),
            
        
            // Pestañas para seleccionar tipo de búsqueda
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => GestureDetector(
                          onTap: () => controller.tipoBusqueda.value = 'folio',
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.tipoBusqueda.value == 'folio'
                                  ? Colors.blue
                                  : Colors.transparent,
                              // borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Por Folio',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: controller.tipoBusqueda.value == 'folio'
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    child: Obx(() => GestureDetector(
                          onTap: () =>
                              controller.tipoBusqueda.value = 'cliente',
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.tipoBusqueda.value == 'cliente'
                                  ? Colors.blue
                                  : Colors.transparent,
                              // borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Por Cliente',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    controller.tipoBusqueda.value == 'cliente'
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),),
                  ),
                ],
              ),
            ),
        
        
            // Campo de búsqueda con botón al lado
            Row(
              children: [
                Expanded(
                  child: Obx(() => SearchFieldWidget(
                        controller: controller.busquedaController,
                        hintText: controller.tipoBusqueda.value == 'folio'
                            ? 'Ej: APT-2025-001'
                            : 'Ej: Juan Pérez',
                        onChanged: (value) {},
                      )),
                ),
                Obx(
                  () => Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: controller.isLoading.value
                          ? Colors.grey
                          : Colors.blue,
                      // borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: controller.isLoading.value
                            ? null
                            : () => controller.buscarApartado(),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        
        
            // Resultados
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const LoadingWidget();
                }
        
                if (controller.apartadoEncontrado.value != null) {
                  return _buildApartadoInfo(
                      controller.apartadoEncontrado.value!);
                }
        
                if (controller.apartadosEncontrados.isNotEmpty) {
                  return _buildListaApartados();
                }
        
                return _buildEmptyState();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApartadoInfo(apartado) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const TextTitleWidget('Apartado Encontrado'),
          ApartadoInfoWidget(apartado: apartado),
          ButtonWidget(
            text: apartado.cliente.telefono,
            icon: Icons.phone,
            title: 'Teléfono',
            colorIcon: Colors.blue,
            isLast: false,
          ),
          ButtonWidget(
            text: apartado.fechaApartado,
            icon: Icons.calendar_today,
            title: 'Fecha de apartado',
            isLast: false,
          ),
          ButtonWidget(
            text: apartado.fechaLimite,
            icon: Icons.event,
            title: 'Fecha límite',
            colorIcon: Colors.orange,
            isLast: false,
          ),
          ButtonWidget(
            text: '${apartado.porcentajePagado.toStringAsFixed(1)}%',
            icon: Icons.percent,
            title: 'Progreso de pago',
            colorIcon: Colors.blue,
            isLast: false,
          ),
          ButtonWidget(
            text: 'Registrar Abono',
            icon: Icons.payment,
            colorIcon: Colors.green,
            colorText: Colors.green.shade700,
            onTap: () => controller.irARegistrarAbono(apartado),
            isLast: true,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildListaApartados() {
    return ListView.builder(
      padding: const EdgeInsets.only(),
      itemCount: controller.apartadosEncontrados.length,
      itemBuilder: (context, index) {
        final apartado = controller.apartadosEncontrados[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0) ...[
              const TextTitleWidget('Apartados Encontrados'),
            ],
            ButtonWidget(
              text: apartado.folio,
              icon: Icons.receipt_long,
              title: apartado.cliente.nombre,
              subtitle: 'Saldo: \$${apartado.saldoPendiente.toStringAsFixed(2)} - ${apartado.estado}',
              colorIcon: apartado.estado == 'activo' ? Colors.green : Colors.orange,
              isLast: index == controller.apartadosEncontrados.length - 1,
              onTap: () => controller.irARegistrarAbono(apartado),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No hay apartados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              controller.tipoBusqueda.value == 'folio'
                  ? 'Busca por folio o deja vacío para ver todos'
                  : 'Busca por nombre de cliente o deja vacío para ver todos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogApartados(ClienteConApartados cliente) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextTitleWidget('Selecciona un apartado'),
              const SizedBox(height: 16),
              ...cliente.apartados.map((apartado) {
                return ButtonWidget(
                  text: apartado.folio,
                  icon: Icons.receipt_long,
                  title:
                      'Pendiente: \$${apartado.saldoPendiente.toStringAsFixed(2)}',
                  subtitle:
                      'Total: \$${apartado.montoTotal.toStringAsFixed(2)}',
                  colorIcon: Colors.blue,
                  isLast: false,
                  onTap: () {
                    Get.back();
                    controller.irARegistrarAbono(apartado);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
