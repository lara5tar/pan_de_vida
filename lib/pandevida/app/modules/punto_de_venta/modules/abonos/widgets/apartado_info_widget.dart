import 'package:flutter/material.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../data/models/apartado_model.dart';

/// Widget reutilizable que muestra la información de un apartado
class ApartadoInfoWidget extends StatelessWidget {
  final Apartado apartado;
  final bool showTitle;

  const ApartadoInfoWidget({
    super.key,
    required this.apartado,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonWidget(
          text: apartado.folio,
          icon: Icons.receipt_long,
          title: 'Folio',
          colorIcon: Colors.blue,
          isLast: false,
        ),
        ButtonWidget(
          text: apartado.cliente.nombre,
          icon: Icons.person,
          title: 'Cliente',
          isLast: false,
        ),
        ButtonWidget(
          text: '\$${apartado.montoTotal.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          title: 'Total',
          colorIcon: Colors.grey,
          isLast: false,
        ),
        ButtonWidget(
          text: '\$${apartado.totalPagado.toStringAsFixed(2)}',
          icon: Icons.paid,
          title: 'Pagado',
          colorIcon: Colors.green,
          isLast: false,
        ),
        ButtonWidget(
          text: '\$${apartado.saldoPendiente.toStringAsFixed(2)}',
          icon: Icons.money_off,
          title: 'Saldo Pendiente',
          colorIcon: Colors.red,
          isLast: false,
        ),
      ],
    );
  }
}
