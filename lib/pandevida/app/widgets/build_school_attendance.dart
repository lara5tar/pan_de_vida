import 'package:flutter/material.dart';
import '../data/models/school_attendace_model.dart';
import 'button_widget.dart';
import 'text_subtitle_widget.dart';
import 'text_title_widget.dart';

List<Widget> buildSchoolAttendance(SchoolAttendace schoolAttendance) {
  return [
    const TextTitleWidget('Escuela'),
    ButtonWidget(
      title: 'Ciclo',
      text: schoolAttendance.ciclo,
      icon: Icons.school_rounded,
    ),
    ButtonWidget(
      title: 'Clase',
      text: schoolAttendance.clase,
      icon: Icons.menu_book_outlined,
      isLast: true,
    ),
    const TextSubtitleWidget('Asistencias'),
    if (schoolAttendance.asistencias.isEmpty)
      const ButtonWidget(
        text: 'Sin asistencias',
        icon: Icons.close,
        isLast: true,
      ),
    for (var item in schoolAttendance.asistencias)
      ButtonWidget(
        text: item.fecha,
        icon: item.asistencia ? Icons.check : Icons.close,
        colorIcon: item.asistencia ? Colors.green : Colors.red,
        colorText: item.asistencia ? Colors.green : Colors.red,
        isLast: schoolAttendance.asistencias.last == item,
      ),
  ];
}
