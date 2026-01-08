import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../app/widgets/custom_scaffold.dart';
import '../../../../../../app/widgets/text_title_widget.dart';
import '../../../../../../app/widgets/text_subtitle_widget.dart';
import '../../../../../../app/widgets/search_field_widget.dart';
import '../../../../../../app/widgets/loading_widget.dart';
import '../../../../../../app/widgets/button_widget.dart';
import '../controllers/search_view_controller.dart';

class SearchView extends GetView<SearchViewController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const TextTitleWidget('Buscar Libros'),
                    const SizedBox(height: 10),
                    
                    // Campo de búsqueda
                    SearchFieldWidget(
                      hintText: 'Buscar por nombre o código',
                      onChanged: (value) {
                        controller.searchQuery.value = value;
                      },
                    ),
                    
                    const SizedBox(height: 10),

                    // Resultados de búsqueda
                    Expanded(
                      child: Obx(
                        () {
                          if (controller.searchQuery.value.isEmpty) {
                            return ListView(
                              padding: const EdgeInsets.all(0),
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size: 50,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Busca por nombre del libro o por código',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }

                          final results = controller.filteredBooks;

                          if (results.isEmpty) {
                            return ListView(
                              padding: const EdgeInsets.all(0),
                              children: [
                                const TextSubtitleWidget('Sin resultados'),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 50,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No se encontraron libros',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }

                          return ListView(
                            padding: const EdgeInsets.all(0),
                            children: [
                              TextSubtitleWidget(
                                results.length == 1
                                    ? '1 libro encontrado'
                                    : '${results.length} libros encontrados',
                              ),
                              const SizedBox(height: 10),
                              for (var book in results)
                                ButtonWidget(
                                  text: book.nombre,
                                  subtitle: 'Código: ${book.id}',
                                  trailing: '\$${book.precio.toStringAsFixed(2)}',
                                  icon: Icons.book,
                                  colorIcon: Colors.blue.shade700,
                                  onTap: () => controller.selectBook(book),
                                  isLast: results.last == book,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
