import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/congregant_model.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/team_controller.dart';

class TeamView extends GetView<TeamController> {
  const TeamView({super.key});

  /// Crea un widget de estrella si el rol no es "Creyente"
  Widget? _buildStarWidget(Congregant item) {
    if (item.rolNivel.isNotEmpty && item.rolNivel != 'Creyente') {
      final color = item.rolColor.isNotEmpty
          ? _colorFromHex(item.rolColor)
          : Colors.amber;
      return Icon(
        Icons.star,
        size: 20,
        color: color,
      );
    }
    return null;
  }

  /// Convierte un color hex a Color
  Color _colorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('ff$hex', radix: 16));
    }
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.sinRegistro.isEmpty &&
                controller.marcador.isEmpty &&
                controller.noMarcador.isEmpty
            ? const LoadingWidget()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const TextTitleWidget('Cumbres de mi Equipo'),
                  const TextSubtitleWidget(
                      'No han capturado cumbres esta semana'),
                  for (var item in controller.sinRegistro)
                    ButtonWidget(
                      title: item.rolNivel.isNotEmpty ? item.rolNivel : null,
                      titleColor: item.rolColor.isNotEmpty ? _colorFromHex(item.rolColor) : null,
                      showTitleAsPill: item.rolNivel.isNotEmpty && item.rolNivel != 'Creyente',
                      text: item.nombre,
                      subtitle: item.nomCasaVida,
                      icon: Icons.person,
                      trailingWidget: _buildStarWidget(item),
                      onTap: () {
                        controller.toRpaIndex(item.codCongregant);
                      },
                      options: [
                        OptionWidget(
                          text: 'Llamar',
                          icon: Icons.phone,
                          onTap: () {},
                        ),
                        OptionWidget(
                          text: 'Mensaje',
                          icon: Icons.message,
                          onTap: () {},
                        ),
                      ],
                      isLast: item == controller.sinRegistro.last,
                    ),
                  const TextSubtitleWidget('No movieron el marcador'),
                  for (var item in controller.noMarcador)
                    ButtonWidget(
                      title: item.rolNivel.isNotEmpty ? item.rolNivel : null,
                      titleColor: item.rolColor.isNotEmpty ? _colorFromHex(item.rolColor) : null,
                      showTitleAsPill: item.rolNivel.isNotEmpty && item.rolNivel != 'Creyente',
                      text: item.nombre,
                      subtitle: item.nomCasaVida,
                      icon: Icons.person,
                      trailingWidget: _buildStarWidget(item),
                      options: [
                        OptionWidget(
                          text: 'Llamar',
                          icon: Icons.phone,
                          onTap: () {},
                        ),
                        OptionWidget(
                          text: 'Mensaje',
                          icon: Icons.message,
                          onTap: () {},
                        ),
                      ],
                      onTap: () {
                        controller.toRpaIndex(item.codCongregant);
                      },
                      isLast: item == controller.noMarcador.last,
                    ),
                  const TextSubtitleWidget('Si movieron el marcador'),
                  for (var item in controller.marcador)
                    ButtonWidget(
                      title: item.rolNivel.isNotEmpty ? item.rolNivel : null,
                      titleColor: item.rolColor.isNotEmpty ? _colorFromHex(item.rolColor) : null,
                      showTitleAsPill: item.rolNivel.isNotEmpty && item.rolNivel != 'Creyente',
                      text: item.nombre,
                      subtitle: item.nomCasaVida,
                      icon: Icons.person,
                      trailingWidget: _buildStarWidget(item),
                      options: [
                        OptionWidget(
                          text: 'Llamar',
                          icon: Icons.phone,
                          onTap: () {},
                        ),
                        OptionWidget(
                          text: 'Mensaje',
                          icon: Icons.message,
                          onTap: () {},
                        ),
                      ],
                      onTap: () {
                        controller.toRpaIndex(item.codCongregant);
                      },
                      isLast: item == controller.marcador.last,
                    ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
