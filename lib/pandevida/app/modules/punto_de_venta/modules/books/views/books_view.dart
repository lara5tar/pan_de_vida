import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/books_controller.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/text_title_widget.dart';
import '../../../../../widgets/search_field_widget.dart';

class BooksView extends GetView<BooksController> {
  const BooksView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      setBanner: true,
      setLeading: true,
      setNotificationBar: true,
      floatingActionButton: FloatingButtonWidget(
        onPressed: () => controller.goToCreateBook(),
        icon: Icons.add,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextTitleWidget('Catálogo de Libros'),
            SearchFieldWidget(
              hintText: 'Buscar por nombre o ID',
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.currentPage.value =
                    0; // Reset a la primera página al buscar
              },
            ),
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.hasError.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.errorMessage.value,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: controller.refreshBooks,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  final books = controller.paginatedBooks;
                  if (controller.filteredBooks.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay libros disponibles',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            for (int index = 0; index < books.length; index++)
                              ButtonWidget(
                                text: books[index].nombre,
                                subtitle:
                                    'Stock: ${books[index].cantidadEnStock}',
                                // title:
                                //     'Precio: \$${books[index].precio.toStringAsFixed(2)}',
                                icon: Icons.book,
                                onTap: () =>
                                    controller.goToBookDetail(books[index]),
                                trailingWidget: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: Colors.blue.shade800,
                                          size: 18),
                                      onPressed: () =>
                                          controller.goToEditBook(books[index]),
                                    ),
                                  ],
                                ),
                                isLast: index == books.length - 1,
                              ),
                          ],
                        ),
                      ),
                      // Controles de paginación
                      if (controller.totalPages > 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                ),
                                onPressed: controller.currentPage.value > 0
                                    ? controller.previousPage
                                    : () {},
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      controller.currentPage.value > 0
                                          ? Colors.blue.shade800
                                          : Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade800,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Página ${controller.currentPage.value + 1} de ${controller.totalPages}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.chevron_right,
                                    color: Colors.white),
                                onPressed: controller.currentPage.value <
                                        controller.totalPages - 1
                                    ? controller.nextPage
                                    : () {},
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      controller.currentPage.value <
                                              controller.totalPages - 1
                                          ? Colors.blue.shade800
                                          : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Selector de número de página para listas largas
                      if (controller.totalPages > 3)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              controller.totalPages,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: InkWell(
                                  onTap: () => controller.goToPage(index),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          controller.currentPage.value == index
                                              ? Colors.blue.shade800
                                              : Colors.transparent,
                                      border: Border.all(
                                        color: Colors.blue.shade800,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: controller.currentPage.value ==
                                                index
                                            ? Colors.white
                                            : Colors.blue.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
