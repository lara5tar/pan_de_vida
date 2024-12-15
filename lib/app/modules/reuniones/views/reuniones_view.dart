import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reuniones_controller.dart';

class ReunionesView extends GetView<ReunionesController> {
  const ReunionesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReunionesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ReunionesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
