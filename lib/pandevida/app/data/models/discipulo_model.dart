class Discipulo {
  final String codCongregante;
  final String nombreCompleto;
  final String grupoVida;
  final String red;
  final String cel;
  final bool esElegido;
  final String rolNivel;
  final String rolColor;

  Discipulo({
    required this.codCongregante,
    required this.nombreCompleto,
    required this.grupoVida,
    required this.red,
    required this.cel,
    required this.esElegido,
    this.rolNivel = '',
    this.rolColor = '',
  });

  factory Discipulo.fromJson(Map<String, dynamic> json) {
    return Discipulo(
      codCongregante: json['CODCONGREGANTE']?.toString() ?? '',
      nombreCompleto: json['NOMBRE_COMPLETO']?.toString() ?? '',
      grupoVida: json['GRUPO_VIDA']?.toString() ?? '',
      red: json['RED']?.toString() ?? '',
      cel: json['CEL']?.toString() ?? '',
      esElegido: json['ES_ELEGIDO']?.toString() == '1',
      rolNivel: json['ROL_NIVEL']?.toString() ?? '',
      rolColor: json['ROL_COLOR']?.toString() ?? '',
    );
  }
}

