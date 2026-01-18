class Subinventario {
  final int id;
  final String? descripcion;
  final String fechaSubinventario;
  final String estado;
  final int totalLibros;
  final int totalUnidades;
  final List<LibroSubinventario>? libros;

  Subinventario({
    required this.id,
    this.descripcion,
    required this.fechaSubinventario,
    required this.estado,
    required this.totalLibros,
    required this.totalUnidades,
    this.libros,
  });

  factory Subinventario.fromJson(Map<String, dynamic> json) {
    // Helper para convertir de forma segura a int
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.parse(value);
      return 0;
    }

    List<LibroSubinventario>? librosList;

    if (json['libros'] != null) {
      librosList = (json['libros'] as List)
          .map((libro) => LibroSubinventario.fromJson(libro))
          .toList();
    }

    return Subinventario(
      id: toInt(json['id']),
      descripcion: json['descripcion'] as String?,
      fechaSubinventario: json['fecha_subinventario'] as String,
      estado: json['estado'] as String,
      totalLibros: toInt(json['total_libros']),
      totalUnidades: toInt(json['total_unidades']),
      libros: librosList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'fecha_subinventario': fechaSubinventario,
      'estado': estado,
      'total_libros': totalLibros,
      'total_unidades': totalUnidades,
      if (libros != null)
        'libros': libros!.map((libro) => libro.toJson()).toList(),
    };
  }

  String get nombreDisplay {
    if (descripcion != null && descripcion!.isNotEmpty) {
      return descripcion!;
    }
    return 'Subinventario #$id';
  }
}

class LibroSubinventario {
  final int id;
  final String nombre;
  final String? codigoBarras;
  final double precio;
  final int cantidadDisponible;

  LibroSubinventario({
    required this.id,
    required this.nombre,
    this.codigoBarras,
    required this.precio,
    required this.cantidadDisponible,
  });

  factory LibroSubinventario.fromJson(Map<String, dynamic> json) {
    // Helper para convertir de forma segura a int
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.parse(value);
      return 0;
    }

    // Helper para convertir de forma segura a double
    double toDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.parse(value);
      return 0.0;
    }

    return LibroSubinventario(
      id: toInt(json['id']),
      nombre: json['nombre'] as String,
      codigoBarras: json['codigo_barras'] as String?,
      precio: toDouble(json['precio']),
      cantidadDisponible: toInt(json['cantidad_disponible']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo_barras': codigoBarras,
      'precio': precio,
      'cantidad_disponible': cantidadDisponible,
    };
  }
}
