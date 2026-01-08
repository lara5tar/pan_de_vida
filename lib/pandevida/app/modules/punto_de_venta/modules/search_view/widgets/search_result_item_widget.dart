import 'package:flutter/material.dart';
import '../../../data/models/book_model.dart';

class SearchResultItemWidget extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final String searchQuery;

  const SearchResultItemWidget({
    super.key,
    required this.book,
    required this.onTap,
    required this.searchQuery,
  });

  // Resalta el texto que coincide con la búsqueda
  TextSpan _highlightMatch(String text, String query) {
    if (query.isEmpty) {
      return TextSpan(text: text);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matches = <TextSpan>[];
    int start = 0;

    while (start < text.length) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        matches.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        matches.add(TextSpan(text: text.substring(start, index)));
      }

      matches.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          backgroundColor: Colors.yellow.shade300,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = index + query.length;
    }

    return TextSpan(children: matches);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono del libro
                Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.shade200,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.book,
                    size: 32,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 16),

                // Información del libro
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre del libro (con highlight)
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                          children: [_highlightMatch(book.nombre, searchQuery)],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Código del libro (con highlight)
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          children: [
                            const TextSpan(text: 'Código: '),
                            _highlightMatch(book.id, searchQuery),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Precio
                      Text(
                        '\$${book.precio.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),

                      // Stock
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: book.cantidadEnStock > 0
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          book.cantidadEnStock > 0
                              ? 'Stock: ${book.cantidadEnStock}'
                              : 'Sin stock',
                          style: TextStyle(
                            fontSize: 12,
                            color: book.cantidadEnStock > 0
                                ? Colors.green.shade900
                                : Colors.red.shade900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Icono de flecha
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
