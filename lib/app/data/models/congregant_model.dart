class Congregant {
  final String apellido;
  final String asisdisc;
  // final String asisgpoVida;
  final String asisgpoVidaF;
  final String calle;
  final String cel;
  final String ciudad;
  final String codCongregant;
  final String codMentor;
  final String codPostal;
  final String codStatus;
  final String colonia;
  final String edad;
  // final String edoCiv;
  final String edoCivF;
  final String entreCalles;
  final String estatus;
  final String fecAlta;
  // final String fecAltaF;
  // final String fecLibro1;
  // final String fecLibro1F;
  // final String fecLibro2;
  // final String fecLibro2F;
  // final String fecLibro3;
  // final String fecLibro3F;
  final String fecNac;
  final String fecNacF;
  final String horario;
  final String iglesia;
  final String mail;
  final String mentor;
  final String necesidad;
  final String nombre;
  final String nombreF;
  final String observaciones;
  final String otraIgl;
  final String otraIglF;
  final String plataforma;
  final String platAsignada;
  // final String sexo;
  final String sexoF;
  final String telCasa;
  final String verificador;
  final String via;
  final String viaF;

  Congregant({
    required this.apellido,
    required this.asisdisc,
    // required this.asisgpoVida,
    required this.asisgpoVidaF,
    required this.calle,
    required this.cel,
    required this.ciudad,
    required this.codCongregant,
    required this.codMentor,
    required this.codPostal,
    required this.codStatus,
    required this.colonia,
    required this.edad,
    // required this.edoCiv,
    required this.edoCivF,
    required this.entreCalles,
    required this.estatus,
    required this.fecAlta,
    // required this.fecAltaF,
    // required this.fecLibro1,
    // required this.fecLibro1F,
    // required this.fecLibro2,
    // required this.fecLibro2F,
    // required this.fecLibro3,
    // required this.fecLibro3F,
    required this.fecNac,
    required this.fecNacF,
    required this.horario,
    required this.iglesia,
    required this.mail,
    required this.mentor,
    required this.necesidad,
    required this.nombre,
    required this.nombreF,
    required this.observaciones,
    required this.otraIgl,
    required this.otraIglF,
    required this.plataforma,
    required this.platAsignada,
    // required this.sexo,
    required this.sexoF,
    required this.telCasa,
    required this.verificador,
    required this.via,
    required this.viaF,
  });

  factory Congregant.fromJson(Map<String, dynamic> json) {
    return Congregant(
      apellido: json['APELLIDO'] ?? '',
      asisdisc: json['ASISDISC'] ?? '',
      // asisgpoVida: json['ASISGPOVIDA'] ?? '',
      asisgpoVidaF: json['ASISGPOVIDAF'] ?? '',
      calle: json['CALLE'] ?? '',
      cel: json['CEL'] ?? '',
      ciudad: json['CIUDAD'] ?? '',
      codCongregant: json['CODCONGREGANTE'] ?? '',
      codMentor: json['CODMENTOR'] ?? '',
      codPostal: json['CODPOSTAL'] ?? '',
      codStatus: json['CODSTATUS'] ?? '',
      colonia: json['COLONIA'] ?? '',
      edad: json['EDAD'] ?? '',
      // edoCiv: json['EDOCIV'] ?? '',
      edoCivF: json['EDOCIVF'] ?? '',
      entreCalles: json['ENTRECALLES'] ?? '',
      estatus: json['ESTATUS'] ?? '',
      fecAlta: json['FECALTA'] ?? '',
      // fecAltaF: json['FECALTAF'] ?? '',
      // fecLibro1: json['FECLIBRO1'] ?? '',
      // fecLibro1F: json['FECLIBRO1F'] ?? '',
      // fecLibro2: json['FECLIBRO2'] ?? '',
      // fecLibro2F: json['FECLIBRO2F'] ?? '',
      // fecLibro3: json['FECLIBRO3'] ?? '',
      // fecLibro3F: json['FECLIBRO3F'] ?? '',
      fecNac: json['FECNAC'] ?? '',
      fecNacF: json['FECNACF'] ?? '',
      horario: json['HORARIO'] ?? '',
      iglesia: json['IGLESIA'] ?? '',
      mail: json['MAIL'] ?? '',
      mentor: json['MENTOR'] ?? '',
      necesidad: json['NECESIDAD'] ?? '',
      nombre: json['NOMBRE'] ?? '',
      nombreF: json['NOMBREF'] ?? '',
      observaciones: json['OBSERVACIONES'] ?? '',
      otraIgl: json['OTRAIGL'] ?? '',
      otraIglF: json['OTRAIGLF'] ?? '',
      plataforma: json['PLATAFORMA'] ?? '',
      platAsignada: json['PLATASIGNADA'] ?? '',
      // sexo: json['SEXO'] ?? '',
      sexoF: json['SEXOF'] ?? '',
      telCasa: json['TELCASA'] ?? '',
      verificador: json['VERIFICADOR'] ?? '',
      via: json['VIA'] ?? '',
      viaF: json['VIAF'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'APELLIDO': apellido,
      'ASISDISC': asisdisc,
      // 'ASISGPOVIDA': asisgpoVida,
      'ASISGPOVIDAF': asisgpoVidaF,
      'CALLE': calle,
      'CEL': cel,
      'CIUDAD': ciudad,
      'CODCONGREGANTE': codCongregant,
      'CODMENTOR': codMentor,
      'CODPOSTAL': codPostal,
      'CODSTATUS': codStatus,
      'COLONIA': colonia,
      'EDAD': edad,
      // 'EDOCIV': edoCiv,
      'EDOCIVF': edoCivF,
      'ENTRECALLES': entreCalles,
      'ESTATUS': estatus,
      'FECALTA': fecAlta,
      // 'FECALTAF': fecAltaF,
      // 'FECLIBRO1': fecLibro1,
      // 'FECLIBRO1F': fecLibro1F,
      // 'FECLIBRO2': fecLibro2,
      // 'FECLIBRO2F': fecLibro2F,
      // 'FECLIBRO3': fecLibro3,
      // 'FECLIBRO3F': fecLibro3F,
      'FECNAC': fecNac,
      'FECNACF': fecNacF,
      'HORARIO': horario,
      'IGLESIA': iglesia,
      'MAIL': mail,
      'MENTOR': mentor,
      'NECESIDAD': necesidad,
      'NOMBRE': nombre,
      'NOMBREF': nombreF,
      'OBSERVACIONES': observaciones,
      'OTRAIGL': otraIgl,
      'OTRAIGLF': otraIglF,
      'PLATAFORMA': plataforma,
      'PLATASIGNADA': platAsignada,
      // 'SEXO': sexo,
      'SEXOF': sexoF,
      'TELCASA': telCasa,
      'VERIFICADOR': verificador,
      'VIA': via,
      'VIAF': viaF,
    };
  }

  factory Congregant.empty() {
    return Congregant(
      apellido: '',
      asisdisc: '',
      // asisgpoVida: '',
      asisgpoVidaF: '',
      calle: '',
      cel: '',
      ciudad: '',
      codCongregant: '',
      codMentor: '',
      codPostal: '',
      codStatus: '',
      colonia: '',
      edad: '',
      // edoCiv: '',
      edoCivF: '',
      entreCalles: '',
      estatus: '',
      fecAlta: '',
      // fecAltaF: '',
      // fecLibro1: '',
      // fecLibro1F: '',
      // fecLibro2: '',
      // fecLibro2F: '',
      // fecLibro3: '',
      // fecLibro3F: '',
      fecNac: '',
      fecNacF: '',
      horario: '',
      iglesia: '',
      mail: '',
      mentor: '',
      necesidad: '',
      nombre: '',
      nombreF: '',
      observaciones: '',
      otraIgl: '',
      otraIglF: '',
      plataforma: '',
      platAsignada: '',
      // sexo: '',
      sexoF: '',
      telCasa: '',
      verificador: '',
      via: '',
      viaF: '',
    );
  }
}
