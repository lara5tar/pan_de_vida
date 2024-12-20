import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CapturarAsistenciaView extends GetView {
  const CapturarAsistenciaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CapturarAsistenciaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CapturarAsistenciaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
