import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/dashboard/views/dashboard_view.dart';

import '../../../widgets/custom_scaffold.dart';
import '../controllers/congregants_controller.dart';

class CongregantsView extends GetView<CongregantsController> {
  const CongregantsView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Container(
        color: Colors.red,
        child: ListView(
          children: const [
            BannerWidget(),
          ],
        ),
      ),
    );
  }
}
