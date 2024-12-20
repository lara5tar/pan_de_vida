import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/alertas_controller.dart';

class AlertasView extends GetView<AlertasController> {
  const AlertasView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlertasView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AlertasView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
