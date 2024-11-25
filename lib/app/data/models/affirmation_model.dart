// {CODCONGREGANTE: 2, NOMBRE: JULIO CESAR GARCIA PINEIRO, FECLIBRO1: 07/01/2018, FECLIBRO2: 07/01/2018, FECLIBRO3: 07/01/2018, AFIRMADOR: NATAN DE LOS REYES, FECREPO1: null, VISITA1: null, OBSERVACIONES1: null, FECREPO2: null, VISITA2: null, OBSERVACIONES2: null, FECREPO3: null, VISITA3: null, OBSERVACIONES3: null, AFIRMADO: null}
class Affirmation {
  final String codCongregant;
  final String nombre;
  final String fecLibro1;
  final String fecLibro2;
  final String fecLibro3;
  final String afirmador;
  final String fecRepo1;
  final String visita1;
  final String observaciones1;
  final String fecRepo2;
  final String visita2;
  final String observaciones2;
  final String fecRepo3;
  final String visita3;
  final String observaciones3;
  final String afirmado;

  Affirmation({
    required this.codCongregant,
    required this.nombre,
    required this.fecLibro1,
    required this.fecLibro2,
    required this.fecLibro3,
    required this.afirmador,
    required this.fecRepo1,
    required this.visita1,
    required this.observaciones1,
    required this.fecRepo2,
    required this.visita2,
    required this.observaciones2,
    required this.fecRepo3,
    required this.visita3,
    required this.observaciones3,
    required this.afirmado,
  });

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    return Affirmation(
      codCongregant: json['CODCONGREGANTE'] ?? '',
      nombre: json['NOMBRE'] ?? '',
      fecLibro1: json['FECLIBRO1'] ?? '',
      fecLibro2: json['FECLIBRO2'] ?? '',
      fecLibro3: json['FECLIBRO3'] ?? '',
      afirmador: json['AFIRMADOR'] ?? '',
      fecRepo1: json['FECREPO1'] ?? '',
      visita1: json['VISITA1'] ?? '',
      observaciones1: json['OBSERVACIONES1'] ?? '',
      fecRepo2: json['FECREPO2'] ?? '',
      visita2: json['VISITA2'] ?? '',
      observaciones2: json['OBSERVACIONES2'] ?? '',
      fecRepo3: json['FECREPO3'] ?? '',
      visita3: json['VISITA3'] ?? '',
      observaciones3: json['OBSERVACIONES3'] ?? '',
      afirmado: json['AFIRMADO'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CODCONGREGANTE': codCongregant,
      'NOMBRE': nombre,
      'FECLIBRO1': fecLibro1,
      'FECLIBRO2': fecLibro2,
      'FECLIBRO3': fecLibro3,
      'AFIRMADOR': afirmador,
      'FECREPO1': fecRepo1,
      'VISITA1': visita1,
      'OBSERVACIONES1': observaciones1,
      'FECREPO2': fecRepo2,
      'VISITA2': visita2,
      'OBSERVACIONES2': observaciones2,
      'FECREPO3': fecRepo3,
      'VISITA3': visita3,
      'OBSERVACIONES3': observaciones3,
      'AFIRMADO': afirmado,
    };
  }

  factory Affirmation.empty() {
    return Affirmation(
      codCongregant: '',
      nombre: '',
      fecLibro1: '',
      fecLibro2: '',
      fecLibro3: '',
      afirmador: '',
      fecRepo1: '',
      visita1: '',
      observaciones1: '',
      fecRepo2: '',
      visita2: '',
      observaciones2: '',
      fecRepo3: '',
      visita3: '',
      observaciones3: '',
      afirmado: '',
    );
  }
}
