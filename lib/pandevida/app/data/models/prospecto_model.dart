class Prospecto {
  final String idProspecto;
  final String nombre;
  final String cel;
  final String fecreg;
  final String codStatus;

  Prospecto({
    required this.idProspecto,
    required this.nombre,
    required this.cel,
    required this.fecreg,
    required this.codStatus,
  });

  factory Prospecto.fromJson(Map<String, dynamic> json) {
    return Prospecto(
      idProspecto: json['IDPROSPECTO'] ?? '',
      nombre: json['NOMBRE'] ?? '',
      cel: json['CEL'] ?? '',
      fecreg: json['FECREG'] ?? '',
      codStatus: json['CODSTATUS'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IDPROSPECTO': idProspecto,
      'NOMBRE': nombre,
      'CEL': cel,
      'FECREG': fecreg,
      'CODSTATUS': codStatus,
    };
  }

  factory Prospecto.empty() {
    return Prospecto(
      idProspecto: '',
      nombre: '',
      cel: '',
      fecreg: '',
      codStatus: '',
    );
  }

  @override
  String toString() {
    return 'Prospecto(idProspecto: $idProspecto, nombre: $nombre, cel: $cel, fecreg: $fecreg, codStatus: $codStatus)';
  }
}
