class GroupAttendace {
  final String idRed;
  final String red;
  final String idSubRed;
  final String subRed;
  final String idGpoVida;
  final String gpoVida;
  final List<AttendanceDetail> asistencias;

  GroupAttendace({
    required this.idRed,
    required this.red,
    required this.idSubRed,
    required this.subRed,
    required this.idGpoVida,
    required this.gpoVida,
    required this.asistencias,
  });

  factory GroupAttendace.fromJson(Map<String, dynamic> json) {
    return GroupAttendace(
      idRed: json['idRed'] ?? '',
      red: json['red'] ?? '',
      idSubRed: json['idSubred'] ?? '',
      subRed: json['subred'] ?? '',
      idGpoVida: json['idGpoVida'] ?? '',
      gpoVida: json['gpoVida'] ?? '',
      asistencias: List<AttendanceDetail>.from(
        json['asistencias'].map(
          (x) => AttendanceDetail.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idRed': idRed,
      'red': red,
      'idSubred': idSubRed,
      'subred': subRed,
      'idGpoVida': idGpoVida,
      'gpoVida': gpoVida,
      'asistencias': List<dynamic>.from(asistencias.map((x) => x.toJson())),
    };
  }

  factory GroupAttendace.empty() {
    return GroupAttendace(
      idRed: '',
      red: '',
      idSubRed: '',
      subRed: '',
      idGpoVida: '',
      gpoVida: '',
      asistencias: [],
    );
  }

  @override
  String toString() {
    return 'GroupAttendace(idRed: $idRed, red: $red, idSubRed: $idSubRed, subRed: $subRed, idGpoVida: $idGpoVida, gpoVida: $gpoVida, asistencia: $asistencias)';
  }
}

class AttendanceDetail {
  final String idReunion;
  final String fecha;
  final bool asistencia;

  AttendanceDetail({
    required this.idReunion,
    required this.fecha,
    required this.asistencia,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDetail(
      idReunion: json['IDREUNION'] ?? '',
      fecha: json['fecha'] ?? '',
      asistencia: json['asistencia'] == 'ASISTENCIA' ? true : false,
      // json['asistencia'] == 'FALTA'
      //     ? false
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IDREUNION': idReunion,
      'fecha': fecha,
      'asistencia': asistencia,
    };
  }

  factory AttendanceDetail.empty() {
    return AttendanceDetail(
      idReunion: '',
      fecha: '',
      asistencia: false,
    );
  }

  @override
  String toString() {
    return 'AttendanceDetail(idReunion: $idReunion, fecha: $fecha, asistencia: $asistencia)';
  }
}
