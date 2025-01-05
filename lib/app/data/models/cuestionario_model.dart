//  numClase: 3, idInscripcion: 8694, codCuestionario: {CODVIDEO: SER3CUES, ACTIVO: false}
import 'video_model.dart';

class CuestionarioModel {
  String numClase;
  String idInscripcion;
  String codVideo;
  bool activo;
  List<Video> videos;

  CuestionarioModel({
    required this.numClase,
    required this.idInscripcion,
    required this.codVideo,
    required this.activo,
    required this.videos,
  });

  factory CuestionarioModel.fromJson(Map<String, dynamic> json) =>
      CuestionarioModel(
        numClase: json['numClase'],
        idInscripcion: json['idInscripcion'],
        codVideo: json['codCuestionario']['CODVIDEO'],
        activo: json['codCuestionario']['ACTIVO'] == 'true',
        videos: List<Video>.from(
          json['videos'].map(
            (x) => Video.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        'numClase': numClase,
        'idInscripcion': idInscripcion,
        'codCuestionario': {
          'CODVIDEO': codVideo,
          'ACTIVO': activo,
        },
        'videos': List<dynamic>.from(
          videos.map(
            (x) => x.toJson(),
          ),
        ),
      };

  factory CuestionarioModel.empty() => CuestionarioModel(
        numClase: '',
        idInscripcion: '',
        codVideo: '',
        activo: false,
        videos: [],
      );

  @override
  String toString() {
    return 'CuestionarioModel(numClase: $numClase, idInscripcion: $idInscripcion, codVideo: $codVideo, activo: $activo, videos: $videos)';
  }
}
