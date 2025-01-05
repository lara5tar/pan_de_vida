// {TITULO: TIENES UN NUEVO AFIRMADO, DETALLE: VICTOR, FECREG: 31/03/2021, NOMBRE: JULIO CESAR GARCIA PINEIRO, CODCONGREGANTE: 2, CEL: 8332892634}

class Alerta {
  String titulo;
  String detalle;
  String fecreg;
  String nombre;
  String codcongregante;
  String cel;

  Alerta({
    required this.titulo,
    required this.detalle,
    required this.fecreg,
    required this.nombre,
    required this.codcongregante,
    required this.cel,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) => Alerta(
        titulo: json["TITULO"],
        detalle: json["DETALLE"],
        fecreg: json["FECREG"],
        nombre: json["NOMBRE"],
        codcongregante: json["CODCONGREGANTE"],
        cel: json["CEL"],
      );

  Map<String, dynamic> toJson() => {
        "TITULO": titulo,
        "DETALLE": detalle,
        "FECREG": fecreg,
        "NOMBRE": nombre,
        "CODCONGREGANTE": codcongregante,
        "CEL": cel,
      };

  @override
  String toString() {
    return 'Alerta(titulo: $titulo, detalle: $detalle, fecreg: $fecreg, nombre: $nombre, codcongregante: $codcongregante, cel: $cel)';
  }
}
