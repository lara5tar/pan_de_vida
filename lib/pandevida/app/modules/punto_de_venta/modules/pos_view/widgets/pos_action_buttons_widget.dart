import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pos_view_controller.dart';

class PosActionButtonsWidget extends GetView<PosViewController> {
  const PosActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Eliminar seleccionado
          _buildActionButton(
            icon: Icons.delete,
            label: 'Eliminar',
            color: Colors.red[400]!,
            onPressed: () {
              controller.startRemoveSelectedItem();
            },
          ),
          // Decrementar
          _buildActionButton(
            icon: Icons.remove_circle_outline,
            label: 'Menos',
            color: Colors.orange[600]!,
            onPressed: () {
              controller.selectedCarItemDecrement();
            },
          ),
          // Incrementar
          _buildActionButton(
            icon: Icons.add_circle_outline,
            label: 'Más',
            color: Colors.green[600]!,
            onPressed: () {
              controller.selectedCarItemIncrement();
            },
          ),
          // Buscar libro
          _buildActionButton(
            icon: Icons.search,
            label: 'Buscar',
            color: Colors.blue[700]!,
            onPressed: () {
              controller.goToSearchView();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            iconSize: 28,
            color: color,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
