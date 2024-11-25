// {IDACCION: 115221, CODACCION: AS6, ACCION: AS6 A Ana Hernàndez prueba Ana Hernàndez prueba, IDPROSPECTO: null, CODCON: 12918, ISDESTACADA: , FECREG: 24/11/2024, ICONO: null, COLOR: black}
class Accion {
  String idaccion;
  String codaccion;
  String accion;
  String idprospecto;
  String codcon;
  String isdestacada;
  String fecreg;
  String icono;
  String color;

  Accion({
    required this.idaccion,
    required this.codaccion,
    required this.accion,
    required this.idprospecto,
    required this.codcon,
    required this.isdestacada,
    required this.fecreg,
    required this.icono,
    required this.color,
  });

  factory Accion.fromJson(Map<String, dynamic> json) => Accion(
        idaccion: json['IDACCION'] ?? '',
        codaccion: json['CODACCION'] ?? '',
        accion: json['ACCION'] ?? '',
        idprospecto: json['IDPROSPECTO'] ?? '',
        codcon: json['CODCON'] ?? '',
        isdestacada: json['ISDESTACADA'] ?? '',
        fecreg: json['FECREG'] ?? '',
        icono: json['ICONO'] ?? '',
        color: json['COLOR'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'IDACCION': idaccion,
        'CODACCION': codaccion,
        'ACCION': accion,
        'IDPROSPECTO': idprospecto,
        'CODCON': codcon,
        'ISDESTACADA': isdestacada,
        'FECREG': fecreg,
        'ICONO': icono,
        'COLOR': color,
      };

  factory Accion.empty() => Accion(
        idaccion: '',
        codaccion: '',
        accion: '',
        idprospecto: '',
        codcon: '',
        isdestacada: '',
        fecreg: '',
        icono: '',
        color: '',
      );
}
