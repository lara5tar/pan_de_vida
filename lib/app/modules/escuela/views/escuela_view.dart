import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/escuela_controller.dart';

class EscuelaView extends GetView<EscuelaController> {
  const EscuelaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EscuelaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EscuelaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
