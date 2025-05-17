import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTestWidget extends StatelessWidget {
  final RxString label;
  const CustomTestWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text('My Text: ${label.value}'),
    );
  }
}
