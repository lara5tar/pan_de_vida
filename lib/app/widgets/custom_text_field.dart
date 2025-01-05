import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const CustomTextField(
    this.name, {
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      decoration: InputDecoration(
        labelText: name,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
