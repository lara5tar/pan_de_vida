class Video {
  final String codvideo;
  final String tipo;
  final String numvideo;
  final String predecesor;
  final String url;
  final String codaccion;
  final String status;
  final String activo;

  Video({
    required this.codvideo,
    required this.tipo,
    required this.numvideo,
    required this.predecesor,
    required this.url,
    required this.codaccion,
    required this.status,
    required this.activo,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      codvideo: json['CODVIDEO'] ?? '' ?? '',
      tipo: json['TIPO'] ?? '',
      numvideo: json['NUMVIDEO'] ?? '',
      predecesor: json['PREDECESOR'] ?? '',
      url: json['URL'] ?? '',
      codaccion: json['CODACCION'] ?? '',
      status: json['STATUS'] ?? '',
      activo: json['ACTIVO'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CODVIDEO': codvideo,
      'TIPO': tipo,
      'NUMVIDEO': numvideo,
      'PREDECESOR': predecesor,
      'URL': url,
      'CODACCION': codaccion,
      'STATUS': status,
      'ACTIVO': activo,
    };
  }

  factory Video.empty() {
    return Video(
      codvideo: '',
      tipo: '',
      numvideo: '',
      predecesor: '',
      url: '',
      codaccion: '',
      status: '',
      activo: '',
    );
  }

  @override
  String toString() {
    return 'Video(codvideo: $codvideo, tipo: $tipo, numvideo: $numvideo, predecesor: $predecesor, url: $url, codaccion: $codaccion, status: $status, activo: $activo)';
  }
}
