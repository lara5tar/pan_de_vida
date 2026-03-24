import 'package:flutter/material.dart';

/// Modelo para las RPAs (cumbres del ciclo actual) de un congregante.
/// Corresponde al endpoint /cumbres/obtener_rpa_congregante
class CumbreCiclo {
  final String codCumbre;
  final String nomAccPass; // Acción (a quién se realizó)
  final String indAccion; // Indicador de acción (0/1)
  final String indMarcador; // Indicador de marcador (0/1)
  final String nomAccSig; // Siguiente acción
  final String dia;
  final String mes;
  final String anio;

  CumbreCiclo({
    required this.codCumbre,
    required this.nomAccPass,
    required this.indAccion,
    required this.indMarcador,
    required this.nomAccSig,
    required this.dia,
    required this.mes,
    required this.anio,
  });

  factory CumbreCiclo.fromJson(Map<String, dynamic> json) {
    return CumbreCiclo(
      codCumbre: (json['CODCUMBRE'] ?? '').toString(),
      nomAccPass: (json['NOMACCPASS'] ?? 'SIN ACCIÓN').toString(),
      indAccion: (json['INDACCION'] ?? '0').toString(),
      indMarcador: (json['INDMARCADOR'] ?? '0').toString(),
      nomAccSig: (json['NOMACCSIG'] ?? 'SIN MOVIMIENTO').toString(),
      dia: (json['DIA'] ?? '').toString(),
      mes: (json['MES'] ?? '').toString(),
      anio: (json['ANIO'] ?? '').toString(),
    );
  }

  /// Color del icono según si hay acción y/o marcador.
  Color get colorC {
    final tieneAccion = indAccion == '1';
    final tieneMarcador = indMarcador == '1';
    if (tieneAccion && tieneMarcador) return Colors.blue;
    if (tieneAccion) return Colors.green;
    if (tieneMarcador) return Colors.orange;
    return Colors.red;
  }

  /// Icono según estado.
  IconData get iconoC {
    final tieneAccion = indAccion == '1';
    final tieneMarcador = indMarcador == '1';
    if (tieneAccion && tieneMarcador) return Icons.check_circle_outline;
    if (tieneAccion) return Icons.sentiment_satisfied_alt_rounded;
    if (tieneMarcador) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }
}

/// Modelo para agrupar las RPAs por año
class CumbreAnio {
  final String anio;
  final List<CumbreCiclo> movimientos;

  CumbreAnio({
    required this.anio,
    required this.movimientos,
  });

  factory CumbreAnio.fromJson(Map<String, dynamic> json) {
    return CumbreAnio(
      anio: (json['anio'] ?? '').toString(),
      movimientos: List<CumbreCiclo>.from(
        (json['movimientos'] ?? []).map((e) => CumbreCiclo.fromJson(e)),
      ),
    );
  }
}
