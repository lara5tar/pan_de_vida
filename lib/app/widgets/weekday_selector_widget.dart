import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeekdaySelector extends StatelessWidget {
  final RxList<bool> selectedDays;
  final Function(int index, bool value) onDaySelected;
  final String label;

  const WeekdaySelector({
    super.key,
    required this.selectedDays,
    required this.onDaySelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> weekdays = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    label,
                    style: const TextStyle(
                      // color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    children: List.generate(
                      7,
                      (index) => GestureDetector(
                        onTap: () => onDaySelected(index, !selectedDays[index]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: selectedDays[index]
                                ? Colors.blue
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            weekdays[index],
                            style: TextStyle(
                              color: selectedDays[index]
                                  ? Colors.white
                                  : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
