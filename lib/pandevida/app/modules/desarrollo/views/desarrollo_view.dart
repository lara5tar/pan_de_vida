import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/discipulo_model.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/desarrollo_controller.dart';

class DesarrolloView extends GetView<DesarrolloController> {
  const DesarrolloView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: controller.loadDiscipulos,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (controller.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people_outline, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No hay discípulos disponibles',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: controller.loadDiscipulos,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadDiscipulos,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const TextTitleWidget('Mis Discípulos'),

              // ─── Sin captura esta semana ──────────────────────────────
              const TextSubtitleWidget('No han capturado esta semana'),
              if (controller.sinRegistro.isEmpty)
                const _EmptyGroup()
              else
                for (int i = 0; i < controller.sinRegistro.length; i++)
                  _DiscipuloButton(
                    discipulo: controller.sinRegistro[i],
                    isLast: i == controller.sinRegistro.length - 1,
                    onTap: () => controller.toPerfilDiscipulo(
                        controller.sinRegistro[i].codCongregante),
                  ),

              // ─── Capturaron pero sin marcador ─────────────────────────
              const TextSubtitleWidget('No movieron el marcador'),
              if (controller.noMarcador.isEmpty)
                const _EmptyGroup()
              else
                for (int i = 0; i < controller.noMarcador.length; i++)
                  _DiscipuloButton(
                    discipulo: controller.noMarcador[i],
                    isLast: i == controller.noMarcador.length - 1,
                    onTap: () => controller.toPerfilDiscipulo(
                        controller.noMarcador[i].codCongregante),
                  ),

              // ─── Sí movieron el marcador ──────────────────────────────
              const TextSubtitleWidget('Sí movieron el marcador'),
              if (controller.marcador.isEmpty)
                const _EmptyGroup()
              else
                for (int i = 0; i < controller.marcador.length; i++)
                  _DiscipuloButton(
                    discipulo: controller.marcador[i],
                    isLast: i == controller.marcador.length - 1,
                    onTap: () => controller.toPerfilDiscipulo(
                        controller.marcador[i].codCongregante),
                  ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}

// ── Botón individual de discípulo ────────────────────────────────────────────
class _DiscipuloButton extends StatelessWidget {
  const _DiscipuloButton({
    required this.discipulo,
    required this.isLast,
    required this.onTap,
  });

  final Discipulo discipulo;
  final bool isLast;
  final VoidCallback onTap;

  /// Convierte un color hex a Color
  Color _colorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('ff$hex', radix: 16));
    }
    return Colors.amber;
  }

  /// Construye el widget de la estrella si el rol no es "Creyente"
  Widget? _buildStarIcon() {
    // Si tiene rolNivel y no es "Creyente", mostrar estrella con color
    if (discipulo.rolNivel.isNotEmpty && discipulo.rolNivel != 'Creyente') {
      final color = discipulo.rolColor.isNotEmpty
          ? _colorFromHex(discipulo.rolColor)
          : Colors.amber;
      return Icon(Icons.star, size: 32, color: color);
    }
    return null;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      title: discipulo.rolNivel.isNotEmpty ? discipulo.rolNivel : null,
      titleColor: discipulo.rolColor.isNotEmpty ? _colorFromHex(discipulo.rolColor) : null,
      showTitleAsPill: discipulo.rolNivel.isNotEmpty && discipulo.rolNivel != 'Creyente',
      text: discipulo.nombreCompleto,
      subtitle: discipulo.grupoVida,
      icon: Icons.person,
      iconWidget: _buildStarIcon(),
      onTap: onTap,
      isLast: isLast,
    );
  }
}

// ── Placeholder cuando un grupo está vacío ───────────────────────────────────
class _EmptyGroup extends StatelessWidget {
  const _EmptyGroup();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xCCFFFFFF),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 60,
                child: Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: Color(0xFF616161),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Ninguno',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 60),
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }
}
