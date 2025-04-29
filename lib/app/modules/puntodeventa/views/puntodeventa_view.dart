import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/puntodeventa_controller.dart';

class PuntodeventaView extends GetView<PuntodeventaController> {
  const PuntodeventaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PuntodeventaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PuntodeventaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
