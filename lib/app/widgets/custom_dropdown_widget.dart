import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final RxString selectedItem;
  final String hint;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(
        0.8,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Obx(
        () => DropdownButtonFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            label: Text(hint),
          ),
          isExpanded: true,
          hint: Text(
            hint,
          ),
          value: selectedItem.value.isEmpty ? null : selectedItem.value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (value) {
            selectedItem.value = value.toString();
          },
        ),
      ),
    );
  }
}
