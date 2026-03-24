class EscuelaHistorial {
  final String idInscripcion;
  final String curso;
  final String clase;
  final String ciclo;
  final String numClases;
  final String minClases;
  final String minTareas;
  final String asistencias;
  final String tareas;
  final String estado;

  EscuelaHistorial({
    required this.idInscripcion,
    required this.curso,
    required this.clase,
    required this.ciclo,
    required this.numClases,
    required this.minClases,
    required this.minTareas,
    required this.asistencias,
    required this.tareas,
    required this.estado,
  });

  factory EscuelaHistorial.fromJson(Map<String, dynamic> json) {
    return EscuelaHistorial(
      idInscripcion: json['IDINSCRIPCION']?.toString() ?? '',
      curso: json['CURSO']?.toString() ?? '',
      clase: json['CLASE']?.toString() ?? '',
      ciclo: json['CICLO']?.toString() ?? '',
      numClases: json['NUMCLASES']?.toString() ?? '0',
      minClases: json['MINCLASES']?.toString() ?? '0',
      minTareas: json['MINTAREAS']?.toString() ?? '0',
      asistencias: json['ASISTENCIAS']?.toString() ?? '0',
      tareas: json['TAREAS']?.toString() ?? '0',
      estado: json['ESTADO']?.toString() ?? '',
    );
  }

  bool get aprobado => estado == 'APROBADO';

  @override
  String toString() {
    return 'EscuelaHistorial(curso: $curso, clase: $clase, ciclo: $ciclo, estado: $estado)';
  }
}
