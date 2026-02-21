class TestMinisterio {
  String id;
  String titulo;
  String descripcion;
  List<PreguntaMinisterio> preguntas;

  TestMinisterio({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.preguntas,
  });

  factory TestMinisterio.fromJson(Map<String, dynamic> json) {
    return TestMinisterio(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      preguntas: (json['preguntas'] as List<dynamic>?)
              ?.map((x) => PreguntaMinisterio.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'preguntas': preguntas.map((x) => x.toJson()).toList(),
    };
  }

  factory TestMinisterio.empty() {
    return TestMinisterio(
      id: '',
      titulo: '',
      descripcion: '',
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
      id: json['id'] ?? '',
      pregunta: json['pregunta'] ?? '',
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
      id: json['id'] ?? '',
      texto: json['texto'] ?? '',
      iscorrecta: json['iscorrecta'] == true || json['iscorrecta'] == 'true' || json['iscorrecta'] == 1,
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
