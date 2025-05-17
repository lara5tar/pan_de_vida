import 'package:flutter/material.dart';
import 'package:pan_de_vida/pandevida/app/data/models/group_attendance_model.dart';
import 'button_widget.dart';
import 'text_subtitle_widget.dart';
import 'text_title_widget.dart';

List<Widget> buildGroupAttendance(GroupAttendace groupAttendance) {
  return [
    const TextTitleWidget('Grupo de Vida'),
    ButtonWidget(
      title: 'Red',
      text: groupAttendance.red,
      icon: Icons.public,
    ),
    ButtonWidget(
      title: 'Sub-Red',
      text: groupAttendance.subRed,
      icon: Icons.device_hub_rounded,
    ),
    ButtonWidget(
      title: 'Grupo de Vida',
      text: groupAttendance.gpoVida,
      icon: Icons.eco,
      isLast: true,
    ),
    const TextSubtitleWidget('Asistencias'),
    if (groupAttendance.asistencias.isEmpty)
      const ButtonWidget(
        text: 'Sin asistencias',
        icon: Icons.close,
        isLast: true,
      ),
    for (var item in groupAttendance.asistencias)
      ButtonWidget(
        text: item.fecha,
        icon: item.asistencia ? Icons.check : Icons.close,
        colorIcon: item.asistencia ? Colors.green : Colors.red,
        colorText: item.asistencia ? Colors.green : Colors.red,
        isLast: groupAttendance.asistencias.last == item,
      ),
  ];
}
