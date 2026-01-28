// {PREGUNTA: {CODPREGUNTA: SER3VID1PRG8, CODVIDEO: SER3VID1, NUMPREGUNTA: 8, PREGUNTA: ¿Qué historia se encuentra en Lucas 4: 39?}, RESPUESTAS: [{CODVIDEO: SER3VID1, CODPREGUNTA: SER3VID1PRG8, NUMRESPUESTA: 1, RESPUESTA: La de la alimentación de la multitud, ISCORRECTA: 0}, {CODVIDEO: SER3VID1, CODPREGUNTA: SER3VID1PRG8, NUMRESPUESTA: 2, RESPUESTA: La de la suegra de Pedro, ISCORRECTA: 1}, {CODVIDEO: SER3VID1, CODPREGUNTA: SER3VID1PRG8, NUMRESPUESTA: 3, RESPUESTA: La de las bienaventuranzas, ISCORRECTA: 0}]}
class Pregunta {
  String codpregunta;
  String codvideo;
  String numpregunta;
  String pregunta;
  List<Respuesta> respuestas;

  Pregunta({
    required this.codpregunta,
    required this.codvideo,
    required this.numpregunta,
    required this.pregunta,
    required this.respuestas,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      codpregunta: json['PREGUNTA']['CODPREGUNTA'] ?? '',
      codvideo: json['PREGUNTA']['CODVIDEO'] ?? '',
      numpregunta: json['PREGUNTA']['NUMPREGUNTA'] ?? '',
      pregunta: json['PREGUNTA']['PREGUNTA'] ?? '',
      respuestas: List<Respuesta>.from(
        json['RESPUESTAS']?.map(
          (x) => Respuesta.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PREGUNTA': {
        'CODPREGUNTA': codpregunta,
        'CODVIDEO': codvideo,
        'NUMPREGUNTA': numpregunta,
        'PREGUNTA': pregunta,
      },
      'RESPUESTAS': List<dynamic>.from(
        respuestas.map(
          (x) => x.toJson(),
        ),
      ),
    };
  }

  factory Pregunta.empty() {
    return Pregunta(
      codpregunta: '',
      codvideo: '',
      numpregunta: '',
      pregunta: '',
      respuestas: [],
    );
  }

  @override
  String toString() {
    return 'Pregunta{codpregunta: $codpregunta, codvideo: $codvideo, numpregunta: $numpregunta, pregunta: $pregunta, respuestas: $respuestas}';
  }
}

// {CODVIDEO: SER3VID1, CODPREGUNTA: SER3VID1PRG9, NUMRESPUESTA: 1, RESPUESTA: Porque primero es la restauración de tu vida para luego, por agradecimiento, servirle, ISCORRECTA: 1}
class Respuesta {
  String codvideo;
  String codpregunta;
  String numrespuesta;
  String respuesta;
  bool iscorrecta;

  Respuesta({
    required this.codvideo,
    required this.codpregunta,
    required this.numrespuesta,
    required this.respuesta,
    required this.iscorrecta,
  });

  factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(
      codvideo: json['CODVIDEO'] ?? '',
      codpregunta: json['CODPREGUNTA'] ?? '',
      numrespuesta: json['NUMRESPUESTA'] ?? '',
      respuesta: json['RESPUESTA'] ?? '',
      iscorrecta: json['ISCORRECTA'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CODVIDEO': codvideo,
      'CODPREGUNTA': codpregunta,
      'NUMRESPUESTA': numrespuesta,
      'RESPUESTA': respuesta,
      'ISCORRECTA': iscorrecta ? '1' : '0',
    };
  }

  factory Respuesta.empty() {
    return Respuesta(
      codvideo: '',
      codpregunta: '',
      numrespuesta: '',
      respuesta: '',
      iscorrecta: false,
    );
  }

  @override
  String toString() {
    return 'Respuesta{codvideo: $codvideo, codpregunta: $codpregunta, numrespuesta: $numrespuesta, respuesta: $respuesta, iscorrecta: $iscorrecta}';
  }
}
