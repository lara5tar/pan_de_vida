class TestMinisterio {
  String id;
  String titulo;
  String descripcion;
  bool completado;
  List<PreguntaMinisterio> preguntas;

  TestMinisterio({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.completado = false,
    required this.preguntas,
  });

  factory TestMinisterio.fromJson(Map<String, dynamic> json) {
    // Soporta tanto formato API (IDTEST/NOMBRE_TEST) como JSON local (id/titulo)
    final preguntas = json['preguntas'] as List<dynamic>?;
    return TestMinisterio(
      id: (json['IDTEST'] ?? json['id'] ?? '').toString(),
      titulo: json['NOMBRE_TEST'] ?? json['TITULO'] ?? json['titulo'] ?? '',
      descripcion: json['DESCRIPCION'] ?? json['descripcion'] ?? '',
      completado: json['COMPLETADO'] == true ||
          json['COMPLETADO'] == 1 ||
          json['COMPLETADO'] == 'true' ||
          json['completado'] == true,
      preguntas:
          preguntas?.map((x) => PreguntaMinisterio.fromJson(x)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'completado': completado,
      'preguntas': preguntas.map((x) => x.toJson()).toList(),
    };
  }

  factory TestMinisterio.empty() {
    return TestMinisterio(
      id: '',
      titulo: '',
      descripcion: '',
      completado: false,
      preguntas: [],
    );
  }
}

class PreguntaMinisterio {
  String id;
  String pregunta;
  List<OpcionMinisterio> opciones;

  PreguntaMinisterio({
    required this.id,
    required this.pregunta,
    required this.opciones,
  });

  factory PreguntaMinisterio.fromJson(Map<String, dynamic> json) {
    return PreguntaMinisterio(
      // Soporta formato API (IDPREGUNTA, PREGUNTA, opciones)
      // y formato JSON local (id, pregunta, opciones)
      id: (json['IDPREGUNTA'] ?? json['id'] ?? '').toString(),
      pregunta: json['PREGUNTA'] ?? json['pregunta'] ?? '',
      opciones: (json['opciones'] as List<dynamic>?)
              ?.map((x) => OpcionMinisterio.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pregunta': pregunta,
      'opciones': opciones.map((x) => x.toJson()).toList(),
    };
  }
}

class OpcionMinisterio {
  String id;
  String texto;
  bool iscorrecta;

  OpcionMinisterio({
    required this.id,
    required this.texto,
    required this.iscorrecta,
  });

  factory OpcionMinisterio.fromJson(Map<String, dynamic> json) {
    return OpcionMinisterio(
      // Soporta formato API (IDOPCION, TEXTO)
      // y formato JSON local (id, texto, iscorrecta)
      id: (json['IDOPCION'] ?? json['id'] ?? '').toString(),
      texto: json['TEXTO'] ?? json['texto'] ?? '',
      iscorrecta: json['iscorrecta'] == true ||
          json['iscorrecta'] == 'true' ||
          json['iscorrecta'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'texto': texto,
      'iscorrecta': iscorrecta,
    };
  }
}
