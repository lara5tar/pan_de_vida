import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CapturarPagoView extends GetView {
  const CapturarPagoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CapturarPagoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CapturarPagoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
