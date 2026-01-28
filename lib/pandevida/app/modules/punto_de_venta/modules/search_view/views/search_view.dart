import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../app/widgets/custom_scaffold.dart';
import '../../../../../../app/widgets/text_title_widget.dart';
import '../../../../../../app/widgets/text_subtitle_widget.dart';
import '../../../../../../app/widgets/search_field_widget.dart';
import '../../../../../../app/widgets/loading_widget.dart';
import '../../../../../../app/widgets/button_widget.dart';
import '../../../widgets/disponibilidad_dialog.dart';
import '../controllers/search_view_controller.dart';

class SearchView extends GetView<SearchViewController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () {
          // Mostrar loading
          if (controller.isLoading.value) {
            return const LoadingWidget();
          }

          // Mostrar error si hay
          if (controller.hasError.value) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar libros',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => controller.refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Mostrar contenido normal
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const TextTitleWidget('Buscar Libros'),

                // Mostrar info del subinventario si existe
                if (controller.subinventarioActivo != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF80CBC4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.store,
                          color: Color(0xFF00897B),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.subinventarioActivo!.nombreDisplay,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004D40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                // Campo de búsqueda
                SearchFieldWidget(
                  controller: controller.searchController,
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
                      final results = controller.filteredBooks;

                      if (results.isEmpty) {
                        return ListView(
                          padding: const EdgeInsets.all(0),
                          children: [
                            const TextSubtitleWidget('Sin resultados'),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(30),
                              decoration: const BoxDecoration(
                                color: Color(0xCCFFFFFF),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.search_off,
                                    size: 50,
                                    color: Color(0xFFBDBDBD),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No se encontraron libros',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF616161),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          // Título con contador
                          TextSubtitleWidget(
                            results.length == 1
                                ? '1 libro encontrado'
                                : '${results.length} libros encontrados',
                          ),
                          const SizedBox(height: 10),

                          // Lista de libros
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                final book = results[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ButtonWidget(
                                          text: book.nombre,
                                          subtitle: book.esVendible
                                              ? 'Stock: ${book.cantidadDisponible} • \$${book.precio.toStringAsFixed(2)}'
                                              : 'No disponible en tu inventario',
                                          trailing: book.esVendible
                                              ? '${book.cantidadDisponible}'
                                              : '✗',
                                          icon: book.esVendible
                                              ? Icons.book
                                              : Icons.block,
                                          colorIcon: book.esVendible
                                              ? const Color(0xFF1976D2)
                                              : const Color(0xFF9E9E9E),
                                          colorText: book.esVendible
                                              ? Colors.black
                                              : Colors.grey,
                                          onTap: () =>
                                              controller.selectBook(book),
                                          isLast: false,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4CAF50),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.info_outline),
                                          color: Colors.white,
                                          tooltip: 'Ver disponibilidad',
                                          onPressed: () {
                                            final libroId =
                                                int.tryParse(book.id);
                                            if (libroId != null) {
                                              showDisponibilidadDialog(
                                                libroId: libroId,
                                                libroNombre: book.nombre,
                                              );
                                            } else {
                                              Get.snackbar(
                                                'Error',
                                                'ID de libro inválido',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor:
                                                    Colors.red.shade700,
                                                colorText: Colors.white,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // Controles de paginación
                          if (controller.totalPages.value > 1)
                            _buildPaginationControls(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón anterior
            IconButton(
              onPressed: controller.currentPage.value > 1
                  ? controller.previousPage
                  : null,
              icon: const Icon(Icons.chevron_left),
              color: Colors.blue,
              disabledColor: Colors.grey,
            ),

            // Información de página
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Página ${controller.currentPage.value} de ${controller.totalPages.value}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total: ${controller.totalLibros.value} libros',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // Botón siguiente
            IconButton(
              onPressed:
                  controller.currentPage.value < controller.totalPages.value
                      ? controller.nextPage
                      : null,
              icon: const Icon(Icons.chevron_right),
              color: Colors.blue,
              disabledColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
