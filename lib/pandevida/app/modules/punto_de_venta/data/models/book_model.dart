import 'package:get/get.dart';

class Book {
  final String id;
  final String nombre;
  final double precio;
  final int cantidadEnStock;
  final String codigoBarras;
  
  // Nuevos campos de la API /api/v1/libros
  final int stock; // Stock en inventario general
  final int stockSubinventario; // Total en todos los subinventarios
  final int stockApartado; // Total en apartados
  final bool? puedeVender; // ¿Este vendedor puede vender este libro?
  final int? cantidadDisponibleParaMi; // Cantidad en MIS subinventarios

  Book({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.cantidadEnStock,
    this.codigoBarras = '',
    this.stock = 0,
    this.stockSubinventario = 0,
    this.stockApartado = 0,
    this.puedeVender,
    this.cantidadDisponibleParaMi,
  });

  // Helper para saber si el libro es vendible
  bool get esVendible => puedeVender ?? true;
  
  // Helper para obtener la cantidad disponible
  int get cantidadDisponible => cantidadDisponibleParaMi ?? cantidadEnStock;

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre'] ?? '',
      precio: _toDouble(json['precio']),
      cantidadEnStock: json['cantidadEnStock'] ?? json['cantidad_disponible'] ?? 0,
      codigoBarras: json['codigoBarras'] ?? json['codigo_barras'] ?? '',
      stock: json['stock'] ?? 0,
      stockSubinventario: json['stock_subinventario'] ?? 0,
      stockApartado: json['stock_apartado'] ?? 0,
      puedeVender: json['puede_vender'],
      cantidadDisponibleParaMi: json['cantidad_disponible_para_mi'],
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
      'nombre': nombre,
      'precio': precio,
      'cantidadEnStock': cantidadEnStock,
      'codigoBarras': codigoBarras,
    };
  }

  Book copyWith({
    String? id,
    String? nombre,
    double? precio,
    int? cantidadEnStock,
    String? codigoBarras,
    int? stock,
    int? stockSubinventario,
    int? stockApartado,
    bool? puedeVender,
    int? cantidadDisponibleParaMi,
  }) {
    return Book(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      cantidadEnStock: cantidadEnStock ?? this.cantidadEnStock,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      stock: stock ?? this.stock,
      stockSubinventario: stockSubinventario ?? this.stockSubinventario,
      stockApartado: stockApartado ?? this.stockApartado,
      puedeVender: puedeVender ?? this.puedeVender,
      cantidadDisponibleParaMi: cantidadDisponibleParaMi ?? this.cantidadDisponibleParaMi,
    );
  }
}

class CartItem {
  Book book;
  var quantity = 1.obs;
  var isSelected = false.obs;

  CartItem(this.book);
}
