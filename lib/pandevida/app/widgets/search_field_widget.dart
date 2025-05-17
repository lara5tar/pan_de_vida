import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  /// La función que se llama cuando cambia el texto.
  final Function(String) onChanged;

  /// El texto de placeholder que se muestra cuando el campo está vacío.
  final String hintText;

  /// Icono personalizado para el campo de búsqueda.
  final IconData? icon;

  /// Permite controlar el texto del campo.
  final TextEditingController? controller;

  /// Si es verdadero, el campo tendrá enfoque automáticamente al mostrarse.
  final bool autofocus;

  /// Constructor para el widget SearchFieldWidget.
  const SearchFieldWidget({
    super.key,
    required this.onChanged,
    this.hintText = 'Buscar',
    this.icon = Icons.search,
    this.controller,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
