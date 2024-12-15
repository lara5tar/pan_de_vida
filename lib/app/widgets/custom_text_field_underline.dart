import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wheel_picker/wheel_picker.dart';

class CustomTextFieldUnderline extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController info;
  final TypeField typefield;
  const CustomTextFieldUnderline({
    super.key,
    required this.info,
    required this.label,
    required this.hintText,
    required this.typefield,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 26.0, height: 1.5);
    final wheelStyle = WheelPickerStyle(
      itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
      squeeze: 1.25,
      diameterRatio: .8,
      surroundingOpacity: .25,
      magnification: 1.2,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      color: Colors.white,
      child: TextField(
        controller: info,
        inputFormatters: [
          //chulada
          typefield == TypeField.MONEY
              ? FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}'),
                )
              : FilteringTextInputFormatter.singleLineFormatter,
        ],

        //
        // [Don't use this line]
        // onChanged: (value) => info.value = value,
        // because controllerEditingController(text: info.value) is used
        // to set the value of the textfield
        // and the Obx is used to update the value of the textfield
        // when the value of the variable changes
        //
        onTap: typefield == TypeField.DATE
            ? () {
                showDatePicker(
                  context: context,
                  locale: const Locale('es', 'es_MX'),
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((value) {
                  if (value != null) {
                    info.text = DateFormat('dd/MM/yyyy').format(value);
                  }
                });
              }
            : typefield == TypeField.TIME
                ? () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        int hora = 1, minutos = 0;
                        bool am = true;
                        return AlertDialog(
                          title: const Text('Selecciona la hora'),
                          content: SizedBox(
                            height: 300,
                            width: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  child: WheelPicker(
                                    itemCount: 12, // 12 horas
                                    looping: false,
                                    builder: (context, index) {
                                      return Text(
                                        '${index + 1}',
                                        style: const TextStyle(fontSize: 24),
                                      ); // Horas de 1 a 12
                                    },
                                    onIndexChanged: (index) {
                                      hora = index + 1;
                                    },
                                    style: wheelStyle.copyWith(
                                      shiftAnimationStyle:
                                          const WheelShiftAnimationStyle(
                                        duration: Duration(seconds: 1),
                                        curve: Curves.bounceOut,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: WheelPicker(
                                    itemCount: 60, // 60 minutos
                                    onIndexChanged: (index) {
                                      minutos = index;
                                    },
                                    builder: (context, index) {
                                      return Text(
                                        index.toString().padLeft(2, '0'),
                                        style: const TextStyle(fontSize: 24),
                                      ); // Minutos 00-59
                                    },
                                    style: wheelStyle.copyWith(
                                      shiftAnimationStyle:
                                          const WheelShiftAnimationStyle(
                                        duration: Duration(seconds: 1),
                                        curve: Curves.bounceOut,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: WheelPicker(
                                    itemCount: 2, // AM y PM
                                    looping: false,
                                    onIndexChanged: (index) {
                                      am = index == 0;
                                    },
                                    builder: (context, index) {
                                      return Text(
                                        index == 0 ? 'AM' : 'PM',
                                        style: const TextStyle(fontSize: 24),
                                      );
                                    },
                                    style: wheelStyle.copyWith(
                                      shiftAnimationStyle:
                                          const WheelShiftAnimationStyle(
                                        duration: Duration(seconds: 1),
                                        curve: Curves.bounceOut,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('CANCELAR'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                info.text =
                                    '${hora.toString().padLeft(2, '0')}:'
                                    '${minutos.toString().padLeft(2, '0')} '
                                    '${am ? 'AM' : 'PM'}';
                              },
                              child: const Text('ACEPTAR'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                : null,
        readOnly: typefield == TypeField.DATE,
        keyboardType: typefield == TypeField.MONEY
            ? TextInputType.number
            : TextInputType.text,

        decoration: InputDecoration(
          prefixIcon: Text(
            '$label: ${typefield == TypeField.MONEY ? '\$' : ''}',
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 80,
          ),
          contentPadding: const EdgeInsets.all(0),
          suffixIcon: typefield == TypeField.DATE
              ? const Icon(
                  Icons.calendar_today,
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 50,
          ),
        ),
      ),
    );
  }
}

enum TypeField {
  DATE,
  TEXT,
  TIME,
  MONEY,
}
