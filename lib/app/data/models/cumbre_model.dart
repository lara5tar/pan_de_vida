// {CODCUMBRE: 44900, ACCION: SIN ACCIÓN, MOVIMIENTO: SIN MOVIMIENTO, ISDESTACADA: null, ISACCION: 0, ISMARCADOR: 0, ICONO: sad, COLOR: red, DIA: 05, MES: August}

import 'package:flutter/material.dart';

class Cumbre {
  final String codcumbre;
  final String accion;
  final String movimiento;
  final String isdestacada;
  final String isaccion;
  final String ismarcador;
  final String icono;
  final String color;
  final String dia;
  final String mes;

  Cumbre({
    required this.codcumbre,
    required this.accion,
    required this.movimiento,
    required this.isdestacada,
    required this.isaccion,
    required this.ismarcador,
    required this.icono,
    required this.color,
    required this.dia,
    required this.mes,
  });

  factory Cumbre.fromJson(Map<String, dynamic> json) {
    return Cumbre(
      codcumbre: json['CODCUMBRE'] ?? '',
      accion: json['ACCION'] ?? '',
      movimiento: json['MOVIMIENTO'] ?? '',
      isdestacada: json['ISDESTACADA'] ?? '',
      isaccion: json['ISACCION'] ?? '',
      ismarcador: json['ISMARCADOR'] ?? '',
      icono: json['ICONO'] ?? '',
      color: json['COLOR'] ?? '',
      dia: json['DIA'] ?? '',
      mes: json['MES'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CODCUMBRE': codcumbre,
      'ACCION': accion,
      'MOVIMIENTO': movimiento,
      'ISDESTACADA': isdestacada,
      'ISACCION': isaccion,
      'ISMARCADOR': ismarcador,
      'ICONO': icono,
      'COLOR': color,
      'DIA': dia,
      'MES': mes,
    };
  }

  factory Cumbre.empty() {
    return Cumbre(
      codcumbre: '',
      accion: '',
      movimiento: '',
      isdestacada: '',
      isaccion: '',
      ismarcador: '',
      icono: '',
      color: '',
      dia: '',
      mes: '',
    );
  }

  @override
  String toString() {
    return 'Cumbre(codcumbre: $codcumbre, accion: $accion, movimiento: $movimiento, isdestacada: $isdestacada, isaccion: $isaccion, ismarcador: $ismarcador, icono: $icono, color: $color, dia: $dia, mes: $mes)';
  }

  Color get colorC {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'gold':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'grey':
        return Colors.grey;
      case 'black':
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  IconData get iconoC {
    switch (icono) {
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'happy':
        return Icons.sentiment_satisfied_alt_rounded;
      case 'neutral':
        return Icons.sentiment_neutral;
      case 'checkmark-circle-outline':
        return Icons.check_circle_outline;
      case 'star':
        return Icons.star;
      default:
        return Icons.sentiment_neutral;
    }
  }
}
