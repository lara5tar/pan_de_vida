import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  const CustomTextField(
    this.name, {
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: name,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
