import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/book_model.dart';
import '../../../data/models/subinventario_model.dart';
import '../../../data/services/books_service.dart';
import '../../../data/services/subinventario_service.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../widgets/confirm_dialog.dart';

class SearchViewController extends GetxController {
  final BooksService booksService = BooksService();
  final SubinventarioService subinventarioService = SubinventarioService();

  // TextEditingController para el campo de búsqueda
  final TextEditingController searchController = TextEditingController();

  // Estados observables
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var books = <Book>[].obs;
  var searchQuery = ''.obs;
  var isInitialLoad = true; // Para evitar búsqueda duplicada en el init

  // Paginación
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalLibros = 0.obs;
  var perPage = 20.obs;

  // Resumen de la API (cuando se usa con subinventario)
  var totalPuedeVender = 0.obs;
  var totalNoPuedeVender = 0.obs;
  var totalLibrosEnSubinventario = 0.obs;
  var totalLibrosSistema = 0.obs;

  // Subinventario activo (si viene de POS con subinventario)
  Subinventario? subinventarioActivo;
  List<LibroSubinventario>? librosDisponibles;

  // Callback para devolver el libro seleccionado (usado desde POS)
  Function(Book)? onBookSelected;

  @override
  void onInit() {
    super.onInit();

    print('=== SearchViewController onInit ===');
    print('Get.arguments: ${Get.arguments}');

    // Obtener los argumentos
    if (Get.arguments != null) {
      if (Get.arguments['onBookSelected'] != null) {
        onBookSelected = Get.arguments['onBookSelected'];
        print('✓ Callback onBookSelected configurado');
      }
      if (Get.arguments['subinventario'] != null) {
        subinventarioActivo = Get.arguments['subinventario'];
        print(
            '✓ Subinventario: ${subinventarioActivo?.nombreDisplay} (ID: ${subinventarioActivo?.id})');
      }
      if (Get.arguments['librosDisponibles'] != null) {
        librosDisponibles = Get.arguments['librosDisponibles'];
        print(
            '✓ librosDisponibles recibidos: ${librosDisponibles?.length ?? 0}');
      }
    } else {
      print('⚠️ No se recibieron argumentos');
    }

    // Cargar libros usando la nueva API
    if (subinventarioActivo != null) {
      print('→ Cargando con nueva API de todos los libros...');
      cargarLibrosConAPI().then((_) {
        isInitialLoad = false; // Marcar que ya se hizo la carga inicial
      });
    } else {
      print('→ No hay subinventario, llamando getBooks()...');
      getBooks().then((_) {
        isInitialLoad = false;
      });
    }

    // Debounce para búsqueda (solo después de la carga inicial)
    debounce(
      searchQuery,
      (_) {
        if (!isInitialLoad) {
          print('→ Búsqueda cambiada: "${searchQuery.value}"');
          cargarLibrosConAPI();
        }
      },
      time: const Duration(milliseconds: 500),
    );
  }

  /// Cargar libros usando la API de testeo con vendibilidad
  Future<void> cargarLibrosConAPI({int? page}) async {
    if (subinventarioActivo == null) {
      getBooks();
      return;
    }

    isLoading(true);
    hasError(false);

    try {
      final codCongregante = AuthService.getCodCongregante();
      final pageToLoad = page ?? currentPage.value;

      print('=== Llamando API ===');
      print('SubinventarioId: ${subinventarioActivo!.id}');
      print('CodCongregante: $codCongregante');
      print('Buscar: ${searchQuery.value}');
      print('Página: $pageToLoad');

      final result =
          await subinventarioService.getTodosLosLibrosConVendibilidad(
        subinventarioId: subinventarioActivo!.id,
        codCongregante: codCongregante,
        buscar: searchQuery.value.isEmpty ? null : searchQuery.value,
        conStock: null, // Mostrar TODOS los libros, incluso sin stock
        perPage: perPage.value,
        page: pageToLoad,
      );

      print('=== Respuesta API ===');
      print('Error: ${result['error']}');
      print('Data length: ${(result['data'] as List?)?.length ?? 0}');

      if (!result['error']) {
        books.clear();

        // Convertir datos de la API a objetos Book
        final List<dynamic> data = result['data'] ?? [];
        for (var item in data) {
          books.add(Book.fromJson(item));
        }

        // Actualizar paginación
        final pagination = result['pagination'];
        if (pagination != null) {
          currentPage.value = pagination['current_page'] ?? 1;
          totalPages.value = pagination['last_page'] ?? 1;
          totalLibros.value = pagination['total'] ?? 0;
        }

        // Actualizar resumen
        final resumen = result['resumen'];
        if (resumen != null) {
          totalPuedeVender.value = resumen['total_puede_vender'] ?? 0;
          totalNoPuedeVender.value = resumen['total_no_puede_vender'] ?? 0;
          totalLibrosEnSubinventario.value =
              resumen['total_libros_en_subinventario'] ?? 0;
          totalLibrosSistema.value = resumen['total_libros_sistema'] ?? 0;
        }

        print('Libros cargados: ${books.length}');
        print('Página: $currentPage/$totalPages');
        print('Puede vender: $totalPuedeVender, No puede: $totalNoPuedeVender');
      } else {
        hasError(true);
        errorMessage.value = result['message'] ?? 'Error al cargar libros';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hasError(true);
      errorMessage.value = 'Error al cargar libros: $e';
      print('Error en cargarLibrosConAPI: $e');
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Ir a la página anterior
  void previousPage() {
    if (currentPage.value > 1) {
      cargarLibrosConAPI(page: currentPage.value - 1);
    }
  }

  /// Ir a la página siguiente
  void nextPage() {
    if (currentPage.value < totalPages.value) {
      cargarLibrosConAPI(page: currentPage.value + 1);
    }
  }

  /// Ir a una página específica
  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value) {
      cargarLibrosConAPI(page: page);
    }
  }

  // Buscar libros por nombre o código (solo para búsqueda local)
  List<Book> get filteredBooks {
    return books; // Ya viene filtrado de la API
  }

  // Busca un libro por código exacto (útil para escaneos de códigos de barras)
  void findBookByExactCode(String code) {
    if (code.isEmpty) return;

    // Primero buscamos coincidencia exacta con el ID
    final exactMatch = books.firstWhereOrNull(
        (book) => book.id.toLowerCase() == code.toLowerCase());

    // Si encontramos una coincidencia exacta
    if (exactMatch != null) {
      // Validar si puede vender
      if (!exactMatch.esVendible) {
        Get.snackbar(
          'No disponible',
          'Este libro no está en tu subinventario actual',
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Si hay un callback, llamarlo (para agregar al carrito desde POS)
      if (onBookSelected != null) {
        onBookSelected!(exactMatch);
        // Volver atrás después de seleccionar
        Get.back();

        // Mostrar mensaje después de cerrar
        Future.microtask(() => Get.snackbar(
              'Libro encontrado',
              'Se agregó: ${exactMatch.nombre}',
              backgroundColor: Colors.green.shade700,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            ));
      } else {
        // Solo mostrar mensaje si no hay callback
        Get.snackbar(
          'Libro encontrado',
          'Se encontró el libro: ${exactMatch.nombre}',
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } else {
      // Si no hay coincidencia exacta
      if (filteredBooks.isEmpty) {
        Get.snackbar(
          'Sin resultados',
          'No se encontró ningún libro con el código: $code',
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
        );
      }
    }
  }

  // Obtener todos los libros
  Future<void> getBooks() async {
    isLoading(true);
    hasError(false);

    try {
      var data = await booksService.getAll();
      if (!data['error']) {
        books.clear();
        books.addAll(data['data']);
      } else {
        hasError(true);
        errorMessage.value = 'No se pudieron cargar los libros';
      }
    } catch (e) {
      hasError(true);
      errorMessage.value = 'Error al cargar libros: ${e.toString()}';
    } finally {
      isLoading(false);
    }
  }

  // Seleccionar un libro
  void selectBook(Book book) {
    // Validar si puede vender este libro
    if (!book.esVendible) {
      Get.snackbar(
        'No disponible',
        'No puedes agregar "${book.nombre}" porque no está en tu subinventario actual.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (onBookSelected != null) {
      // Si hay un callback (desde POS), usarlo
      confirmDialog(
        title: '¿Agregar libro?',
        content:
            '¿Deseas agregar "${book.nombre}" al carrito?\n\nDisponibles: ${book.cantidadDisponible}',
        confirmAction: () {
          onBookSelected!(book);
          Get.back(); // Cerrar el diálogo de confirmación

          // Mostrar snackbar después de cerrar todo
          Future.microtask(() => Get.snackbar(
                'Libro agregado',
                '${book.nombre} agregado al carrito',
                backgroundColor: Colors.green.shade700,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              ));
        },
      );
    } else {
      // Si no hay callback, mostrar detalles
      goToBookDetail(book);
    }
  }

  // Navegar a los detalles del libro
  void goToBookDetail(Book book) {
    Get.toNamed(
      '/book-detail',
      arguments: {'book': book},
    );
  }

  // Limpiar búsqueda
  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
  }

  // Recargar libros
  Future<void> refresh() async {
    if (subinventarioActivo != null) {
      await cargarLibrosConAPI(page: 1);
    } else {
      await getBooks();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
