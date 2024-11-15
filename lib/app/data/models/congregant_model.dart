import 'dart:convert';

class Congregant {
  final String id;
  final String registrationDate;
  final String name;
  final String email;
  final String mentor;

  Congregant({
    required this.id,
    required this.registrationDate,
    required this.name,
    required this.email,
    required this.mentor,
  });

  factory Congregant.fromJson(Map<String, dynamic> json) {
    return Congregant(
      id: json['CODCONGREGANTE'].toString(),
      registrationDate: json['FECALTA'].toString(),
      name: json['NOMBRE'].toString(),
      email: json['MAIL'].toString(),
      mentor: json['MENTOR'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CODCONGREGANTE': id,
      'FECALTA': registrationDate,
      'NOMBRE': name,
      'MAIL': email,
      'MENTOR': mentor,
    };
  }

  //serialized
  String toJsonString() {
    return json.encode(toJson());
  }

  //deserialized
  factory Congregant.fromJsonString(String json) {
    return Congregant.fromJson(jsonDecode(json));
  }
}
