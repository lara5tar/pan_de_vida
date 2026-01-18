import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/mycart_controller.dart';
import '../../../data/models/book_model.dart';
import '../../../data/services/books_service.dart';

Future<Book?> searchBookDialog({List<Book>? availableBooks}) async {
  // Obtenemos el controlador de carrito
  final mycartController = Get.find<MycartController>();

  // Establecemos que estamos en un diálogo para pausar la captura de eventos del scanner
  mycartController.inDialog.value = true;

  TextEditingController searchController = TextEditingController();
  FocusNode textFieldFocusNode = FocusNode();
  final BooksService booksService = BooksService();

  // Variable para almacenar los libros encontrados
  RxList<Book> foundBooks = <Book>[].obs;
  // Variable para controlar si estamos buscando
  RxBool isSearching = false.obs;
  // Variable para mostrar mensajes de error
  RxString errorMessage = ''.obs;

  Book? selectedBook;

  // Si hay libros disponibles del subinventario, mostrarlos al inicio
  if (availableBooks != null && availableBooks.isNotEmpty) {
    foundBooks.addAll(availableBooks);
  }

  await Get.dialog(
    barrierColor: Colors.black87,
    barrierDismissible: true,
    WillPopScope(
      // Interceptamos el botón de retroceso para asegurar que se restablezca el flag
      onWillPop: () async {
        mycartController.inDialog.value = false;
        return true;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width:
              Get.width * 0.9, // Usar ancho relativo al tamaño de la pantalla
          constraints:
              const BoxConstraints(maxWidth: 450), // Establecer un ancho máximo
          child: Obx(
            () => AlertDialog(
              insetPadding: EdgeInsets.zero, // Eliminar el padding interno
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              title: const Text(
                'Buscar Libro',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  // Asegurar que el TextField obtenga el foco después de renderizarse
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (textFieldFocusNode.canRequestFocus) {
                      FocusScope.of(context).requestFocus(textFieldFocusNode);
                    }
                  });

                  return Container(
                    constraints: BoxConstraints(
                      maxHeight: Get.height * 0.6, // Limitar la altura máxima
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          autofocus: true,
                          focusNode: textFieldFocusNode,
                          controller: searchController,
                          keyboardType: TextInputType.text,
                          onSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              await _searchBooks(
                                value,
                                booksService,
                                foundBooks,
                                isSearching,
                                errorMessage,
                                availableBooks: availableBooks,
                              );
                            }
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Ingrese código de barras o nombre del libro',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      searchController.clear();
                                      foundBooks.clear();
                                      errorMessage.value = '';
                                    },
                                  )
                                : null,
                            label: const Text('Buscar'),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Mostrar un indicador de carga mientras se busca
                        if (isSearching.value)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),

                        // Mostrar mensaje de error si existe
                        if (errorMessage.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              errorMessage.value,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        // Lista de libros encontrados
                        if (foundBooks.isNotEmpty && !isSearching.value)
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: foundBooks.length,
                              itemBuilder: (context, index) {
                                final book = foundBooks[index];
                                return ListTile(
                                  title: Text(
                                    book.nombre,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Precio: \$${book.precio.toStringAsFixed(2)} - Stock: ${book.cantidadEnStock}',
                                  ),
                                  trailing: const Icon(Icons.add_shopping_cart),
                                  onTap: () {
                                    selectedBook = book;
                                    mycartController.inDialog.value = false;
                                    Get.back();
                                  },
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                    iconColor: Colors.white,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                  ),
                  onPressed: () {
                    mycartController.inDialog.value = false;
                    Get.back();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[400],
                    iconColor: Colors.white,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                  ),
                  onPressed: () async {
                    if (searchController.text.isNotEmpty) {
                      await _searchBooks(
                        searchController.text,
                        booksService,
                        foundBooks,
                        isSearching,
                        errorMessage,
                        availableBooks: availableBooks,
                      );
                    }
                  },
                  child: const Text(
                    'Buscar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ).then((_) {
    // Asegurar que el flag se restaure cuando el diálogo se cierre por cualquier motivo
    mycartController.inDialog.value = false;
  });

  return selectedBook;
}

// Función para buscar libros por código de barras o por nombre
Future<void> _searchBooks(String searchTerm, BooksService booksService,
    RxList<Book> foundBooks, RxBool isSearching, RxString errorMessage,
    {List<Book>? availableBooks}) async {
  foundBooks.clear();
  errorMessage.value = '';
  isSearching.value = true;

  try {
    // Si tenemos libros disponibles (del subinventario), buscar solo en esos
    if (availableBooks != null && availableBooks.isNotEmpty) {
      final searchLower = searchTerm.toLowerCase();

      // Buscar por código de barras primero
      final byBarcode = availableBooks
          .where((book) => book.codigoBarras.toLowerCase() == searchLower)
          .toList();

      if (byBarcode.isNotEmpty) {
        foundBooks.addAll(byBarcode);
      } else {
        // Buscar por nombre si no encontró por código
        final byName = availableBooks
            .where((book) => book.nombre.toLowerCase().contains(searchLower))
            .toList();

        if (byName.isNotEmpty) {
          foundBooks.addAll(byName);
        } else {
          errorMessage.value =
              'No se encontró ningún libro con ese criterio en este punto de venta';
        }
      }
    } else {
      // Buscar en Firebase (comportamiento original)
      // Primero intentamos buscar por código de barras
      final barcodeResult = await booksService.findByBarcode(searchTerm);

      if (!barcodeResult['error']) {
        // Si encontramos por código de barras, añadimos ese libro
        foundBooks.add(barcodeResult['data']);
      } else {
        // Si no encontramos por código de barras, buscamos por similitud en el nombre
        final nameResult = await booksService.findByNameSimilarity(searchTerm);

        if (!nameResult['error']) {
          // Añadimos todos los libros encontrados por nombre
          foundBooks.addAll(nameResult['data']);
        } else {
          // Si no encontramos nada, mostramos el mensaje de error
          errorMessage.value = nameResult['message'];
        }
      }
    }
  } catch (e) {
    errorMessage.value = 'Error al buscar: ${e.toString()}';
  } finally {
    isSearching.value = false;
  }
}
