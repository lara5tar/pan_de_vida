/// Modelo para la respuesta de verificación de asignación de tests
class TestMinisterioVerificacion {
  final bool error;
  final CongreganteInfo congregante;
  final bool tieneAsignacion;
  final ResumenTests resumen;
  final List<TestAsignado> testsPendientes;
  final List<TestCompletado> testsCompletados;
  final List<TestDisponible> testsDisponibles;

  TestMinisterioVerificacion({
    required this.error,
    required this.congregante,
    required this.tieneAsignacion,
    required this.resumen,
    required this.testsPendientes,
    required this.testsCompletados,
    required this.testsDisponibles,
  });

  factory TestMinisterioVerificacion.fromJson(Map<String, dynamic> json) {
    return TestMinisterioVerificacion(
      error: json['error'] ?? false,
      congregante: CongreganteInfo.fromJson(json['congregante'] ?? {}),
      tieneAsignacion: json['tiene_asignacion'] ?? false,
      resumen: ResumenTests.fromJson(json['resumen'] ?? {}),
      testsPendientes: (json['tests_pendientes'] as List<dynamic>?)
              ?.map((x) => TestAsignado.fromJson(x))
              .toList() ??
          [],
      testsCompletados: (json['tests_completados'] as List<dynamic>?)
              ?.map((x) => TestCompletado.fromJson(x))
              .toList() ??
          [],
      testsDisponibles: (json['tests_disponibles'] as List<dynamic>?)
              ?.map((x) => TestDisponible.fromJson(x))
              .toList() ??
          [],
    );
  }

  factory TestMinisterioVerificacion.empty() {
    return TestMinisterioVerificacion(
      error: true,
      congregante: CongreganteInfo.empty(),
      tieneAsignacion: false,
      resumen: ResumenTests.empty(),
      testsPendientes: [],
      testsCompletados: [],
      testsDisponibles: [],
    );
  }
}

/// Información básica del congregante
class CongreganteInfo {
  final String codCongregante;
  final String nombreCompleto;

  CongreganteInfo({
    required this.codCongregante,
    required this.nombreCompleto,
  });

  factory CongreganteInfo.fromJson(Map<String, dynamic> json) {
    return CongreganteInfo(
      codCongregante: json['CODCONGREGANTE']?.toString() ?? '',
      nombreCompleto: json['NOMBRE_COMPLETO']?.toString() ?? '',
    );
  }

  factory CongreganteInfo.empty() {
    return CongreganteInfo(
      codCongregante: '',
      nombreCompleto: '',
    );
  }
}

/// Resumen de tests
class ResumenTests {
  final int pendientes;
  final int completados;
  final int disponibles;

  ResumenTests({
    required this.pendientes,
    required this.completados,
    required this.disponibles,
  });

  factory ResumenTests.fromJson(Map<String, dynamic> json) {
    return ResumenTests(
      pendientes: json['pendientes'] ?? 0,
      completados: json['completados'] ?? 0,
      disponibles: json['disponibles'] ?? 0,
    );
  }

  factory ResumenTests.empty() {
    return ResumenTests(
      pendientes: 0,
      completados: 0,
      disponibles: 0,
    );
  }
}

/// Test asignado pendiente de completar
class TestAsignado {
  final int idResultado;
  final int idTest;
  final String nombreTest;
  final String descripcion;
  final String version;
  final String estadoAsignacion;
  final String fechaAsignacion;
  final int horasDesdeAsignacion;

  TestAsignado({
    required this.idResultado,
    required this.idTest,
    required this.nombreTest,
    required this.descripcion,
    required this.version,
    required this.estadoAsignacion,
    required this.fechaAsignacion,
    required this.horasDesdeAsignacion,
  });

  factory TestAsignado.fromJson(Map<String, dynamic> json) {
    return TestAsignado(
      idResultado: json['IDRESULTADO'] ?? 0,
      idTest: json['IDTEST'] ?? 0,
      nombreTest: json['NOMBRE_TEST']?.toString() ?? '',
      descripcion: json['DESCRIPCION']?.toString() ?? '',
      version: json['VERSION']?.toString() ?? '',
      estadoAsignacion: json['ESTADO_ASIGNACION']?.toString() ?? '',
      fechaAsignacion: json['FECHA_ASIGNACION']?.toString() ?? '',
      horasDesdeAsignacion: json['HORAS_DESDE_ASIGNACION'] ?? 0,
    );
  }
}

/// Test completado por el congregante
class TestCompletado {
  final int idResultado;
  final int idTest;
  final String nombreTest;
  final String version;
  final String estadoAsignacion;
  final String fechaCompletado;
  final String ministerioPrincipal;
  final double puntajePrincipal;

  TestCompletado({
    required this.idResultado,
    required this.idTest,
    required this.nombreTest,
    required this.version,
    required this.estadoAsignacion,
    required this.fechaCompletado,
    required this.ministerioPrincipal,
    required this.puntajePrincipal,
  });

  factory TestCompletado.fromJson(Map<String, dynamic> json) {
    return TestCompletado(
      idResultado: json['IDRESULTADO'] ?? 0,
      idTest: json['IDTEST'] ?? 0,
      nombreTest: json['NOMBRE_TEST']?.toString() ?? '',
      version: json['VERSION']?.toString() ?? '',
      estadoAsignacion: json['ESTADO_ASIGNACION']?.toString() ?? '',
      fechaCompletado: json['FECHA_COMPLETADO']?.toString() ?? '',
      ministerioPrincipal: json['MINISTERIO_PRINCIPAL']?.toString() ?? '',
      puntajePrincipal: (json['PUNTAJE_PRINCIPAL'] ?? 0.0).toDouble(),
    );
  }
}

/// Test disponible (no asignado)
class TestDisponible {
  final int idTest;
  final String nombreTest;
  final String descripcion;
  final String version;
  final int totalPreguntas;

  TestDisponible({
    required this.idTest,
    required this.nombreTest,
    required this.descripcion,
    required this.version,
    required this.totalPreguntas,
  });

  factory TestDisponible.fromJson(Map<String, dynamic> json) {
    return TestDisponible(
      idTest: json['IDTEST'] ?? 0,
      nombreTest: json['NOMBRE_TEST']?.toString() ?? '',
      descripcion: json['DESCRIPCION']?.toString() ?? '',
      version: json['VERSION']?.toString() ?? '',
      totalPreguntas: json['TOTAL_PREGUNTAS'] ?? 0,
    );
  }
}
