import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSwitchWidget extends StatelessWidget {
  final String label;
  final RxBool value;
  final Function(bool)? onChanged;

  const CustomSwitchWidget({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Obx(
            () => Switch(
              value: value.value,
              onChanged: (val) {
                value.value = val;
                if (onChanged != null) {
                  onChanged!(val);
                }
              },
              activeColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
