class Cliente {
  final int id;
  final String nombre;
  final String? telefono;
  final String? email;
  final String? direccion;
  final double limiteCredito;
  final double saldoPendiente;

  Cliente({
    required this.id,
    required this.nombre,
    this.telefono,
    this.email,
    this.direccion,
    required this.limiteCredito,
    required this.saldoPendiente,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      direccion: json['direccion'] as String?,
      limiteCredito: _toDouble(json['limite_credito']),
      saldoPendiente: _toDouble(json['saldo_pendiente']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'limite_credito': limiteCredito,
      'saldo_pendiente': saldoPendiente,
    };
  }

  String get nombreDisplay => nombre;

  String get infoDisplay {
    List<String> info = [];
    if (telefono != null) info.add(telefono!);
    if (email != null) info.add(email!);
    return info.join(' · ');
  }

  double get creditoDisponible => limiteCredito - saldoPendiente;

  bool get tieneCredito => creditoDisponible > 0;

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
