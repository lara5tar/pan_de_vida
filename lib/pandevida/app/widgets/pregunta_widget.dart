import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'text_title_widget.dart';

class PreguntaWidget extends StatelessWidget {
  final String pregunta;
  final List<OpcionItem> respuestas;
  final Function(dynamic) onChanged;

  PreguntaWidget({
    super.key,
    required this.pregunta,
    required this.respuestas,
    required this.onChanged,
  });

  var selectedValue = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextTitleWidget(pregunta),
        for (var i = 0; i < respuestas.length; i++)
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: selectedValue.value == respuestas[i].text
                  ? Colors.grey.shade200.withOpacity(0.8)
                  : Colors.white.withOpacity(0.8),
              child: RadioListTile(
                title: Text(
                    '${respuestas[i].text} ${kDebugMode ? respuestas[i].value.iscorrecta : ''}'),
                value: respuestas[i].text,
                groupValue: selectedValue.value,
                onChanged: (value) {
                  selectedValue.value = value!;
                  onChanged(respuestas[i].value);
                },
              ),
            ),
          ),
      ],
    );
  }
}

class OpcionItem {
  final String text;
  final dynamic value;

  OpcionItem({
    required this.text,
    required this.value,
  });
}
