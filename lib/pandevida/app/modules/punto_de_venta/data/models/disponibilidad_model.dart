class DisponibilidadLibro {
  final LibroInfo libro;
  final InventarioGeneral inventarioGeneral;
  final List<SubinventarioDisponibilidad> subinventarios;
  final int totalDisponible;
  final bool tieneStock;

  DisponibilidadLibro({
    required this.libro,
    required this.inventarioGeneral,
    required this.subinventarios,
    required this.totalDisponible,
    required this.tieneStock,
  });

  factory DisponibilidadLibro.fromJson(Map<String, dynamic> json) {
    return DisponibilidadLibro(
      libro: LibroInfo.fromJson(json['libro']),
      inventarioGeneral: InventarioGeneral.fromJson(json['inventario_general']),
      subinventarios: (json['subinventarios'] as List)
          .map((s) => SubinventarioDisponibilidad.fromJson(s))
          .toList(),
      totalDisponible: _toInt(json['total_disponible']),
      tieneStock: json['tiene_stock'] as bool,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}

class LibroInfo {
  final int id;
  final String nombre;
  final String? codigoBarras;
  final double precio;

  LibroInfo({
    required this.id,
    required this.nombre,
    this.codigoBarras,
    required this.precio,
  });

  factory LibroInfo.fromJson(Map<String, dynamic> json) {
    return LibroInfo(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      codigoBarras: json['codigo_barras'] as String?,
      precio: _toDouble(json['precio']),
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

class InventarioGeneral {
  final bool disponible;
  final int cantidad;

  InventarioGeneral({
    required this.disponible,
    required this.cantidad,
  });

  factory InventarioGeneral.fromJson(Map<String, dynamic> json) {
    return InventarioGeneral(
      disponible: json['disponible'] as bool,
      cantidad: _toInt(json['cantidad']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}

class SubinventarioDisponibilidad {
  final int subinventarioId;
  final String descripcion;
  final String fechaSubinventario;
  final int cantidadDisponible;

  SubinventarioDisponibilidad({
    required this.subinventarioId,
    required this.descripcion,
    required this.fechaSubinventario,
    required this.cantidadDisponible,
  });

  factory SubinventarioDisponibilidad.fromJson(Map<String, dynamic> json) {
    return SubinventarioDisponibilidad(
      subinventarioId: json['subinventario_id'] as int,
      descripcion: json['descripcion'] as String,
      fechaSubinventario: json['fecha_subinventario'] as String,
      cantidadDisponible: _toInt(json['cantidad_disponible']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}
