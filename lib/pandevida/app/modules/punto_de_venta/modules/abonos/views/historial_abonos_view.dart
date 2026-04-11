import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_title_widget.dart';
import '../../../../../widgets/text_subtitle_widget.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import '../controllers/abonos_controller.dart';
import '../widgets/apartado_info_widget.dart';

class HistorialAbonosView extends GetView<AbonosController> {
  const HistorialAbonosView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        final apartado = controller.apartadoSeleccionado.value;
        final abonos = controller.historialAbonos;

        if (apartado == null) {
          return const Center(
            child: TextSubtitleWidget('No se ha seleccionado un apartado'),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              children: [
                const TextTitleWidget('Historial de Abonos'),
                const TextSubtitleWidget('Información del apartado'),

                // Header con información del apartado
                ApartadoInfoWidget(apartado: apartado),

                TextSubtitleWidget('Abonos realizados: ${abonos.length}'),

                // Lista de abonos
                if (abonos.isEmpty)
                  _buildEmptyState()
                else
                  Column(
                    children: [
                      for (int index = 0; index < abonos.length; index++)
                        _buildAbonoItem(abonos[index], index, abonos.length),
                    ],
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const TextTitleWidget('Sin abonos registrados'),
          const SizedBox(height: 8),
          const TextSubtitleWidget('Aún no hay abonos para este apartado'),
        ],
      ),
    );
  }

  Widget _buildAbonoItem(final abono, int index, int total) {
    final saldoInfo =
        '\$${abono.saldoAnterior.toStringAsFixed(2)} → \$${abono.saldoNuevo.toStringAsFixed(2)}';
    return ButtonWidget(
      text: '\$${abono.monto.toStringAsFixed(2)}',
      icon: Icons.payment,
      title: '${abono.fechaAbono} - ${abono.metodoPagoLabel}',
      subtitle: abono.observaciones != null
          ? '${abono.observaciones}\nSaldo: $saldoInfo'
          : 'Saldo: $saldoInfo',
      colorIcon: Colors.green,
      isLast: index == total - 1,
    );
  }
}
