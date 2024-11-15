import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../controllers/congregants_controller.dart';

class CongregantsView extends GetView<CongregantsController> {
  const CongregantsView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: const [],
      ),
    );
  }
}
