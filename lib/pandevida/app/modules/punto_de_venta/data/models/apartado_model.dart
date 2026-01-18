class Apartado {
  final int id;
  final String folio;
  final ClienteApartado cliente;
  final String fechaApartado;
  final String fechaLimite;
  final double montoTotal;
  final double enganche;
  final double saldoPendiente;
  final double totalPagado;
  final double porcentajePagado;
  final String estado;
  final String? observaciones;
  final List<LibroApartado> libros;
  final int totalAbonos;
  final UltimoAbono? ultimoAbono;

  Apartado({
    required this.id,
    required this.folio,
    required this.cliente,
    required this.fechaApartado,
    required this.fechaLimite,
    required this.montoTotal,
    required this.enganche,
    required this.saldoPendiente,
    required this.totalPagado,
    required this.porcentajePagado,
    required this.estado,
    this.observaciones,
    required this.libros,
    required this.totalAbonos,
    this.ultimoAbono,
  });

  factory Apartado.fromJson(Map<String, dynamic> json) {
    return Apartado(
      id: json['id'] ?? 0,
      folio: json['folio'] ?? '',
      cliente: ClienteApartado.fromJson(json['cliente'] ?? {}),
      fechaApartado: json['fecha_apartado'] ?? '',
      fechaLimite: json['fecha_limite'] ?? '',
      montoTotal: _toDouble(json['monto_total']),
      enganche: _toDouble(json['enganche']),
      saldoPendiente: _toDouble(json['saldo_pendiente']),
      totalPagado: _toDouble(json['total_pagado']),
      porcentajePagado: _toDouble(json['porcentaje_pagado']),
      estado: json['estado'] ?? '',
      observaciones: json['observaciones'],
      libros: (json['libros'] as List?)
              ?.map((e) => LibroApartado.fromJson(e))
              .toList() ??
          [],
      totalAbonos: json['total_abonos'] ?? 0,
      ultimoAbono: json['ultimo_abono'] != null
          ? UltimoAbono.fromJson(json['ultimo_abono'])
          : null,
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
      'folio': folio,
      'cliente': cliente.toJson(),
      'fecha_apartado': fechaApartado,
      'fecha_limite': fechaLimite,
      'monto_total': montoTotal,
      'enganche': enganche,
      'saldo_pendiente': saldoPendiente,
      'total_pagado': totalPagado,
      'porcentaje_pagado': porcentajePagado,
      'estado': estado,
      'observaciones': observaciones,
      'libros': libros.map((e) => e.toJson()).toList(),
      'total_abonos': totalAbonos,
      'ultimo_abono': ultimoAbono?.toJson(),
    };
  }

  Apartado copyWith({
    int? id,
    String? folio,
    ClienteApartado? cliente,
    String? fechaApartado,
    String? fechaLimite,
    double? montoTotal,
    double? enganche,
    double? saldoPendiente,
    double? totalPagado,
    double? porcentajePagado,
    String? estado,
    String? observaciones,
    List<LibroApartado>? libros,
    int? totalAbonos,
    UltimoAbono? ultimoAbono,
  }) {
    return Apartado(
      id: id ?? this.id,
      folio: folio ?? this.folio,
      cliente: cliente ?? this.cliente,
      fechaApartado: fechaApartado ?? this.fechaApartado,
      fechaLimite: fechaLimite ?? this.fechaLimite,
      montoTotal: montoTotal ?? this.montoTotal,
      enganche: enganche ?? this.enganche,
      saldoPendiente: saldoPendiente ?? this.saldoPendiente,
      totalPagado: totalPagado ?? this.totalPagado,
      porcentajePagado: porcentajePagado ?? this.porcentajePagado,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
      libros: libros ?? this.libros,
      totalAbonos: totalAbonos ?? this.totalAbonos,
      ultimoAbono: ultimoAbono ?? this.ultimoAbono,
    );
  }
}

class ClienteApartado {
  final int id;
  final String nombre;
  final String telefono;

  ClienteApartado({
    required this.id,
    required this.nombre,
    required this.telefono,
  });

  factory ClienteApartado.fromJson(Map<String, dynamic> json) {
    return ClienteApartado(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
    };
  }
}

class LibroApartado {
  final String codigo;
  final String titulo;
  final double precioUnitario;
  final int cantidad;
  final double subtotal;

  LibroApartado({
    required this.codigo,
    required this.titulo,
    required this.precioUnitario,
    required this.cantidad,
    required this.subtotal,
  });

  factory LibroApartado.fromJson(Map<String, dynamic> json) {
    return LibroApartado(
      codigo: json['codigo'] ?? '',
      titulo: json['titulo'] ?? '',
      precioUnitario: _toDouble(json['precio_unitario']),
      cantidad: json['cantidad'] ?? 0,
      subtotal: _toDouble(json['subtotal']),
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
      'codigo': codigo,
      'titulo': titulo,
      'precio_unitario': precioUnitario,
      'cantidad': cantidad,
      'subtotal': subtotal,
    };
  }
}

class UltimoAbono {
  final String fecha;
  final double monto;

  UltimoAbono({
    required this.fecha,
    required this.monto,
  });

  factory UltimoAbono.fromJson(Map<String, dynamic> json) {
    return UltimoAbono(
      fecha: json['fecha'] ?? '',
      monto: _toDouble(json['monto']),
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
      'fecha': fecha,
      'monto': monto,
    };
  }
}

// Modelo para agrupar apartados por cliente
class ClienteConApartados {
  final int clienteId;
  final String nombreCliente;
  final String telefonoCliente;
  final List<Apartado> apartados;

  ClienteConApartados({
    required this.clienteId,
    required this.nombreCliente,
    required this.telefonoCliente,
    required this.apartados,
  });

  factory ClienteConApartados.fromJson(Map<String, dynamic> json) {
    return ClienteConApartados(
      clienteId: json['cliente_id'] ?? 0,
      nombreCliente: json['nombre_cliente'] ?? '',
      telefonoCliente: json['telefono_cliente'] ?? '',
      apartados: (json['apartados'] as List?)
              ?.map((e) => Apartado.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cliente_id': clienteId,
      'nombre_cliente': nombreCliente,
      'telefono_cliente': telefonoCliente,
      'apartados': apartados.map((e) => e.toJson()).toList(),
    };
  }
}
