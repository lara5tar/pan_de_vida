import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ReunionFormEditView extends GetView {
  const ReunionFormEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReunionFormEditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ReunionFormEditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
