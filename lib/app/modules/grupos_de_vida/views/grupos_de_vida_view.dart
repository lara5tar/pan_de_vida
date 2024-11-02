import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/grupos_de_vida_controller.dart';

class GruposDeVidaView extends GetView<GruposDeVidaController> {
  const GruposDeVidaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GruposDeVidaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GruposDeVidaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
