import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';
import 'package:pan_de_vida/app/widgets/text_title_widget.dart';

import '../controllers/prospectos_controller.dart';

class ProspectosView extends GetView<ProspectosController> {
  const ProspectosView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: const [
          SizedBox(height: 20),
          TextTitleWidget('Prospectos'),
          ButtonWidget(
            text: '',
            icon: Icons.person,
          )
        ],
      ),
    );
  }
}
