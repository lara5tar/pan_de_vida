import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/loading_widget.dart';
import 'package:pan_de_vida/app/widgets/text_subtitle_widget.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

import '../../../widgets/custom_scaffold.dart';
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
                padding: const EdgeInsets.all(0),
                children: [
                  const SizedBox(height: 20),
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
                    ),
                  const TextSubtitleWidget('No movieron el marcador'),
                  for (var item in controller.noMarcador)
                    ButtonWidget(
                      text: item.nombre,
                      subtitle: item.nomCasaVida,
                      icon: Icons.person,
                      onTap: () {
                        controller.toRpaIndex(item.codCongregant);
                      },
                    ),
                  const TextSubtitleWidget('Si movieron el marcador'),
                  for (var item in controller.marcador)
                    ButtonWidget(
                      text: item.nombre,
                      subtitle: item.nomCasaVida,
                      icon: Icons.person,
                      onTap: () {
                        controller.toRpaIndex(item.codCongregant);
                      },
                    ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
