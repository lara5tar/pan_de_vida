import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/team_controller.dart';

class TeamView extends GetView<TeamController> {
  const TeamView({super.key});

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
                      text: item.nombre,
                      subtitle: item.nomCasaVida,
                      icon: Icons.person,
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
                      text: item.nombre,
                      subtitle: item.nomCasaVida,
                      icon: Icons.person,
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
                      text: item.nombre,
                      subtitle: item.nomCasaVida,
                      icon: Icons.person,
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
