// {IDMARCADOR: 193441, CODCONGREGANTE: 12918, MOVIMIENTO: ASISTENCIA GPOVDA # 2, FECREG: 2024-11-20, NOMBRE: Ana Hernàndez prueba, ISDESTACADO: }

class Marcador {
  String idmarcador;
  String codcongregante;
  String movimiento;
  String fecreg;
  String nombre;
  String isdestacado;

  Marcador({
    required this.idmarcador,
    required this.codcongregante,
    required this.movimiento,
    required this.fecreg,
    required this.nombre,
    required this.isdestacado,
  });

  factory Marcador.fromJson(Map<String, dynamic> json) => Marcador(
        idmarcador: json['IDMARCADOR'] ?? '',
        codcongregante: json['CODCONGREGANTE'] ?? '',
        movimiento: json['MOVIMIENTO'] ?? '',
        fecreg: json['FECREG'] ?? '',
        nombre: json['NOMBRE'] ?? '',
        isdestacado: json['ISDESTACADO'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'IDMARCADOR': idmarcador,
        'CODCONGREGANTE': codcongregante,
        'MOVIMIENTO': movimiento,
        'FECREG': fecreg,
        'NOMBRE': nombre,
        'ISDESTACADO': isdestacado,
      };

  factory Marcador.empty() => Marcador(
        idmarcador: '',
        codcongregante: '',
        movimiento: '',
        fecreg: '',
        nombre: '',
        isdestacado: '',
      );
}
