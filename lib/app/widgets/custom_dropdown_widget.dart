import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  final List<DropDownItem> items;
  final RxString selectedItem;
  final String hint;
  final Function(dynamic)? onChanged;
  final Function()? onTap;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.hint,
    this.onChanged,
    this.onTap,
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
        () => InkWell(
          onTap: () {
            if (items.isEmpty) {
              Get.snackbar(
                'Error',
                'No hay opciones disponibles',
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            }
          },
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              label: Text(hint),
            ),
            isExpanded: true,
            value: selectedItem.value.isEmpty ? null : selectedItem.value,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item.text,
                    child: Text(item.text),
                    onTap: () {
                      if (onChanged != null) {
                        onChanged!(item.value);
                      }
                    },
                  ),
                )
                .toList(),
            onChanged: (value) {
              selectedItem.value = value.toString();
            },
          ),
        ),
      ),
    );
  }
}

class DropDownItem {
  final String text;
  final dynamic value;

  DropDownItem({
    required this.text,
    required this.value,
  });
}
