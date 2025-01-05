class SchoolAttendace {
  final String ciclo;
  final String clase;
  final List<AttendanceDetail> asistencias;

  SchoolAttendace({
    required this.ciclo,
    required this.clase,
    required this.asistencias,
  });

  factory SchoolAttendace.fromJson(Map<String, dynamic> json) {
    return SchoolAttendace(
      ciclo: json['ciclo'] ?? '',
      clase: json['clase'] ?? '',
      asistencias: List<AttendanceDetail>.from(
        json['asistencias'].map(
          (x) => AttendanceDetail.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ciclo': ciclo,
      'clase': clase,
      'asistencias': List<dynamic>.from(asistencias.map((x) => x.toJson())),
    };
  }

  factory SchoolAttendace.empty() {
    return SchoolAttendace(
      ciclo: '',
      clase: '',
      asistencias: [],
    );
  }

  @override
  String toString() {
    return 'SchoolAttendace(ciclo: $ciclo, clase: $clase, asistencias: $asistencias)';
  }
}

class AttendanceDetail {
  final String idClase;
  final String fecha;
  final bool asistencia;
  final bool tarea;

  AttendanceDetail({
    required this.idClase,
    required this.fecha,
    required this.asistencia,
    required this.tarea,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDetail(
      idClase: json['NUMCLASE'] ?? '',
      fecha: json['FECHAASIS'] ?? '',
      asistencia: json['ASISTENCIA'] == 'ASISTENCIA' ? true : false,
      tarea: json['TAREA'] == '1' ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NUMCLASE': idClase,
      'FECHAASIS': fecha,
      'ASISTENCIA': asistencia,
      'TAREA': tarea,
    };
  }

  factory AttendanceDetail.empty() {
    return AttendanceDetail(
      idClase: '',
      fecha: '',
      asistencia: false,
      tarea: false,
    );
  }

  @override
  String toString() {
    return 'AttendanceDetail(idReunion: $idClase, fecha: $fecha, asistencia: $asistencia, tarea: $tarea)';
  }
}
