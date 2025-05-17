class Video {
  final String codvideo;
  final String tipo;
  final String numvideo;
  final String predecesor;
  final String url;
  final String codaccion;
  final String status;
  final String activo;
  final bool adjunto;
  final String numClase;

  Video({
    required this.codvideo,
    required this.tipo,
    required this.numvideo,
    required this.predecesor,
    required this.url,
    required this.codaccion,
    required this.status,
    required this.activo,
    required this.adjunto,
    required this.numClase,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      codvideo: json['CODVIDEO'] ?? json['codVideo'] ?? '',
      tipo: json['TIPO'] ?? '',
      numvideo: json['NUMVIDEO'] ?? json['numVideo'] ?? '',
      predecesor: json['PREDECESOR'] ?? '',
      url: json['URL'] ?? json['url'] ?? '',
      codaccion: json['CODACCION'] ?? '',
      status: json['STATUS'] ?? '',
      activo: json['ACTIVO'] ?? '',
      adjunto: json['ADJUNTO'] != null,
      numClase: json['numClase'] ?? '',
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
      'ADJUNTO': adjunto,
      'numClase': numClase,
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
      adjunto: false,
      numClase: '',
    );
  }

  @override
  String toString() {
    return 'Video(codvideo: $codvideo, tipo: $tipo, numvideo: $numvideo, predecesor: $predecesor, url: $url, codaccion: $codaccion, status: $status, activo: $activo, adjunto: $adjunto, numClase: $numClase)';
  }
}
