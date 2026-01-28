class Abono {
  final int id;
  final String fechaAbono;
  final double monto;
  final double saldoAnterior;
  final double saldoNuevo;
  final String metodoPago;
  final String metodoPagoLabel;
  final String? comprobante;
  final String? observaciones;
  final String usuario;

  Abono({
    required this.id,
    required this.fechaAbono,
    required this.monto,
    required this.saldoAnterior,
    required this.saldoNuevo,
    required this.metodoPago,
    required this.metodoPagoLabel,
    this.comprobante,
    this.observaciones,
    required this.usuario,
  });

  factory Abono.fromJson(Map<String, dynamic> json) {
    return Abono(
      id: json['id'] ?? 0,
      fechaAbono: json['fecha_abono'] ?? '',
      monto: _toDouble(json['monto']),
      saldoAnterior: _toDouble(json['saldo_anterior']),
      saldoNuevo: _toDouble(json['saldo_nuevo']),
      metodoPago: json['metodo_pago'] ?? '',
      metodoPagoLabel: json['metodo_pago_label'] ?? '',
      comprobante: json['comprobante'],
      observaciones: json['observaciones'],
      usuario: json['usuario'] ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_abono': fechaAbono,
      'monto': monto,
      'saldo_anterior': saldoAnterior,
      'saldo_nuevo': saldoNuevo,
      'metodo_pago': metodoPago,
      'metodo_pago_label': metodoPagoLabel,
      'comprobante': comprobante,
      'observaciones': observaciones,
      'usuario': usuario,
    };
  }
}

// Modelo para la respuesta de registro de abono
class RegistroAbonoResponse {
  final Abono abono;
  final ApartadoAbono apartado;

  RegistroAbonoResponse({
    required this.abono,
    required this.apartado,
  });

  factory RegistroAbonoResponse.fromJson(Map<String, dynamic> json) {
    return RegistroAbonoResponse(
      abono: Abono.fromJson(json['abono'] ?? {}),
      apartado: ApartadoAbono.fromJson(json['apartado'] ?? {}),
    );
  }
}

// Modelo simplificado del apartado en la respuesta de abono
class ApartadoAbono {
  final int id;
  final String folio;
  final String nombreCliente;
  final double montoTotal;
  final double saldoPendiente;
  final String estado;

  ApartadoAbono({
    required this.id,
    required this.folio,
    required this.nombreCliente,
    required this.montoTotal,
    required this.saldoPendiente,
    required this.estado,
  });

  factory ApartadoAbono.fromJson(Map<String, dynamic> json) {
    return ApartadoAbono(
      id: json['id'] ?? 0,
      folio: json['folio'] ?? '',
      nombreCliente: json['cliente']?['nombre'] ?? '',
      montoTotal: _toDouble(json['monto_total']),
      saldoPendiente: _toDouble(json['saldo_pendiente']),
      estado: json['estado'] ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

// Request para crear un abono
class CrearAbonoRequest {
  final int apartadoId;
  final double monto;
  final String metodoPago;
  final String? comprobante;
  final String? observaciones;
  final String usuario;

  CrearAbonoRequest({
    required this.apartadoId,
    required this.monto,
    required this.metodoPago,
    this.comprobante,
    this.observaciones,
    required this.usuario,
  });

  Map<String, dynamic> toJson() {
    return {
      'apartado_id': apartadoId,
      'monto': monto,
      'metodo_pago': metodoPago,
      if (comprobante != null) 'comprobante': comprobante,
      if (observaciones != null) 'observaciones': observaciones,
      'usuario': usuario,
    };
  }
}
