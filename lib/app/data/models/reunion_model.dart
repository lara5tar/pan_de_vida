// {IDREUNION: 37632, CODCASAVIDA: 1, DIA: 02, MES: December, TEMA: Discipulado, PREDICADOR: Pastor Natan, INICIO: 7, FIN: 8, OFRENDA: 0, TOTAL: 25}
class Reunion {
  String idReunion;
  String codCasaVida;
  String dia;
  String mes;
  String tema;
  String predicador;
  String inicio;
  String fin;
  String ofrenda;
  String total;

  Reunion({
    required this.idReunion,
    required this.codCasaVida,
    required this.dia,
    required this.mes,
    required this.tema,
    required this.predicador,
    required this.inicio,
    required this.fin,
    required this.ofrenda,
    required this.total,
  });

  factory Reunion.fromJson(Map<String, dynamic> json) {
    return Reunion(
      idReunion: json['IDREUNION'],
      codCasaVida: json['CODCASAVIDA'],
      dia: json['DIA'],
      mes: json['MES'],
      tema: json['TEMA'],
      predicador: json['PREDICADOR'],
      inicio: json['INICIO'],
      fin: json['FIN'],
      ofrenda: json['OFRENDA'],
      total: json['TOTAL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IDREUNION': idReunion,
      'CODCASAVIDA': codCasaVida,
      'DIA': dia,
      'MES': mes,
      'TEMA': tema,
      'PREDICADOR': predicador,
      'INICIO': inicio,
      'FIN': fin,
      'OFRENDA': ofrenda,
      'TOTAL': total,
    };
  }

  @override
  String toString() {
    return 'Reunion(idReunion: $idReunion, codCasaVida: $codCasaVida, dia: $dia, mes: $mes, tema: $tema, predicador: $predicador, inicio: $inicio, fin: $fin, ofrenda: $ofrenda, total: $total)';
  }
}
