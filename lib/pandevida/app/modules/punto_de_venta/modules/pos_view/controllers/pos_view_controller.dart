import 'package:get/get.dart';
import '../../../data/models/book_model.dart';
import '../../../data/models/subinventario_model.dart';
import '../../../data/services/books_service.dart';
import '../../../data/services/camera_service.dart';
import '../../../data/services/subinventario_service.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../mycart/widgets/search_book_dialog.dart';
import '../widgets/transaccion_options_dialog.dart';

class PosViewController extends GetxController {
  var cameraService = Get.find<CameraService>();
  var booksService = BooksService();
  var subinventarioService = SubinventarioService();

  // Subinventario seleccionado
  final Rx<Subinventario?> subinventarioActivo = Rx<Subinventario?>(null);
  final RxList<LibroSubinventario> librosDisponibles =
      <LibroSubinventario>[].obs;

  var selectedCartItem = Rx<CartItem?>(null);
  var cartItems = <CartItem>[].obs;
  var totalAmount = 0.0.obs;
  var isCameraActive = true.obs; // La cámara está activa por defecto
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Obtener el subinventario de los argumentos
    final args = Get.arguments;
    if (args != null && args['subinventario'] != null) {
      subinventarioActivo.value = args['subinventario'] as Subinventario;
      cargarLibrosSubinventario();
    }

    // Configurar el callback para el escaneo de códigos de barras
    cameraService.setBarcodeCallback((code) {
      addBookByCode(code);
    });
  }

  /// Cargar libros del subinventario activo
  Future<void> cargarLibrosSubinventario() async {
    if (subinventarioActivo.value == null) return;

    // Si el subinventario ya tiene libros cargados, usarlos
    if (subinventarioActivo.value!.libros != null &&
        subinventarioActivo.value!.libros!.isNotEmpty) {
      librosDisponibles.value = subinventarioActivo.value!.libros!;
      print(
          'Libros cargados desde el subinventario: ${librosDisponibles.length}');
      return;
    }

    // Si no, cargarlos desde la API
    isLoading.value = true;
    try {
      final result = await subinventarioService.getLibrosSubinventario(
        subinventarioActivo.value!.id,
      );

      if (result['error'] == false) {
        final data = result['data'];
        if (data['libros'] != null) {
          librosDisponibles.value = (data['libros'] as List)
              .map((libro) => LibroSubinventario.fromJson(libro))
              .toList();
          print('Libros cargados desde API: ${librosDisponibles.length}');
        }
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error al cargar libros del subinventario: $e');
      Get.snackbar(
        'Error',
        'No se pudieron cargar los libros del punto de venta',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addBookByCode(String code) async {
    await findBookByBarcode(code);
  }

  Future<void> findBookByBarcode(String barcode) async {
    if (subinventarioActivo.value == null) {
      Get.snackbar(
        'Error',
        'No hay un subinventario activo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Buscar en la API del subinventario
      final result = await subinventarioService.buscarLibroPorCodigo(barcode);

      if (!result['error']) {
        final libroData = result['data'];

        // Verificar que el libro esté en el subinventario activo
        final libroEnSubinventario = librosDisponibles.firstWhereOrNull(
          (libro) => libro.id == libroData['id'],
        );

        if (libroEnSubinventario == null) {
          Get.snackbar(
            'No disponible',
            'Este libro no está disponible en tu punto de venta',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
            colorText: Get.theme.colorScheme.onError,
          );
          return;
        }

        // Convertir LibroSubinventario a Book para mantener compatibilidad
        Book book = Book(
          id: libroEnSubinventario.id.toString(),
          nombre: libroEnSubinventario.nombre,
          codigoBarras: libroEnSubinventario.codigoBarras ?? '',
          precio: libroEnSubinventario.precio,
          cantidadEnStock: libroEnSubinventario.cantidadDisponible,
        );

        addBook(book);
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      print('Error en findBookByBarcode: $e');
      Get.snackbar(
        'Error',
        'No se encontró ningún libro con ese código',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addBook(Book book) {
    // Validar si puede vender este libro
    if (!book.esVendible) {
      Get.snackbar(
        'No disponible',
        'No puedes vender "${book.nombre}" porque no está en tu subinventario actual.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    CartItem? existingItem = findBookInCart(book);

    if (existingItem != null) {
      incrementQuantity(existingItem);
    } else {
      var newItem = CartItem(book);
      cartItems.insert(0, newItem);
      totalAmount.value += book.precio;
    }

    selectedCartItem.value = existingItem ?? cartItems[0];
    Get.snackbar(
      'Libro agregado',
      '${book.nombre} - \$${book.precio.toStringAsFixed(2)}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.8),
      colorText: Get.theme.colorScheme.onPrimary,
      duration: const Duration(seconds: 2),
    );
  }

  CartItem? findBookInCart(Book book) => cartItems.firstWhereOrNull(
        (element) => element.book.id == book.id,
      );

  void incrementQuantity(CartItem item) {
    // Verificar stock del subinventario
    final libroEnSubinventario = librosDisponibles.firstWhereOrNull(
      (libro) => libro.id.toString() == item.book.id,
    );

    final stockDisponible =
        libroEnSubinventario?.cantidadDisponible ?? item.book.cantidadEnStock;

    if (item.quantity.value < stockDisponible) {
      item.quantity.value++;
      totalAmount.value += item.book.precio;
      cartItems.refresh();
    } else {
      Get.snackbar(
        'Sin stock',
        'No hay más stock disponible de "${item.book.nombre}" en este punto de venta',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
      totalAmount.value -= item.book.precio;
      cartItems.refresh();
    } else {
      removeItem(item);
    }
  }

  void removeItem(CartItem item) {
    totalAmount.value -= item.book.precio * item.quantity.value;
    cartItems.remove(item);
    if (selectedCartItem.value == item) {
      selectedCartItem.value = cartItems.isNotEmpty ? cartItems.first : null;
    }
  }

  void selectCartItem(CartItem item) {
    selectedCartItem.value = item;
  }

  void selectedCarItemIncrement() {
    if (selectedCartItem.value != null) {
      incrementQuantity(selectedCartItem.value!);
    }
  }

  void selectedCarItemDecrement() {
    if (selectedCartItem.value != null) {
      decrementQuantity(selectedCartItem.value!);
    }
  }

  void startRemoveSelectedItem() {
    if (selectedCartItem.value != null) {
      confirmDialog(
        title: 'Eliminar libro',
        content:
            '¿Está seguro de eliminar "${selectedCartItem.value!.book.nombre}" del carrito?',
        confirmAction: () {
          removeItem(selectedCartItem.value!);
        },
      );
    }
  }

  void startClearCart() {
    if (cartItems.isEmpty) {
      Get.snackbar('Carrito vacío', 'No hay libros en el carrito');
      return;
    }

    confirmDialog(
      title: 'Vaciar carrito',
      content: '¿Está seguro de vaciar el carrito?',
      confirmAction: () {
        clearCart();
      },
    );
  }

  void clearCart() {
    cartItems.clear();
    totalAmount.value = 0.0;
    selectedCartItem.value = null;
    Get.snackbar('Carrito vaciado', 'Se eliminaron todos los libros');
  }

  Future<void> showSearchBookDialog() async {
    if (subinventarioActivo.value == null || librosDisponibles.isEmpty) {
      Get.snackbar(
        'Error',
        'No hay libros disponibles en este punto de venta',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Convertir libros del subinventario a Books para el diálogo
    List<Book> booksParaBusqueda = librosDisponibles.map((libro) {
      return Book(
        id: libro.id.toString(),
        nombre: libro.nombre,
        codigoBarras: libro.codigoBarras ?? '',
        precio: libro.precio,
        cantidadEnStock: libro.cantidadDisponible,
      );
    }).toList();

    // Usar el diálogo de búsqueda existente pero con los libros del subinventario
    Book? foundBook = await searchBookDialog(availableBooks: booksParaBusqueda);
    if (foundBook != null) {
      addBook(foundBook);
    }
  }

  // Navegar a la vista de búsqueda
  void goToSearchView() {
    if (subinventarioActivo.value == null) {
      Get.snackbar(
        'Error',
        'No hay subinventario activo',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    print('=== goToSearchView ===');
    print('Subinventario: ${subinventarioActivo.value?.nombreDisplay}');
    print('Libros disponibles: ${librosDisponibles.length}');

    // Convertir RxList a List normal para pasar como argumento
    final librosParaBusqueda = List<LibroSubinventario>.from(librosDisponibles);
    print('Libros a pasar: ${librosParaBusqueda.length}');

    Get.toNamed(
      '/search-books',
      arguments: {
        'subinventario': subinventarioActivo.value,
        'librosDisponibles': librosParaBusqueda,
        'onBookSelected': (Book book) {
          addBook(book);
        }
      },
    );
  }

  void checkout() async {
    if (cartItems.isEmpty) {
      Get.snackbar(
          'Carrito vacío', 'Agregue libros antes de procesar la venta');
      return;
    }

    if (subinventarioActivo.value == null) {
      Get.snackbar(
        'Error',
        'No hay un punto de venta activo',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Mostrar diálogo de opciones
    final options = await showTransaccionOptionsDialog(
      totalCarrito: totalAmount.value,
    );

    if (options == null) return; // Usuario canceló

    // Procesar según el tipo de transacción
    if (options.tipo == TipoTransaccion.venta) {
      await _procesarVenta(options);
    } else {
      await _procesarApartado(options);
    }
  }

  Future<void> _procesarVenta(TransaccionOptions options) async {
    try {
      isLoading.value = true;

      // Obtener datos del usuario
      final codCongregante = AuthService.getCodCongregante();

      // Intentar obtener el servicio de auth, si no existe usar valor por defecto
      AuthService? authService;
      try {
        authService = Get.find<AuthService>();
      } catch (e) {
        print('AuthService no encontrado: $e');
      }

      final username = authService?.getUser ?? 'Usuario';

      // Preparar lista de libros para la venta
      final List<Map<String, dynamic>> librosVenta = [];
      for (var item in cartItems) {
        final libroId = int.tryParse(item.book.id);
        if (libroId == null) {
          throw Exception('ID de libro inválido: ${item.book.id}');
        }
        librosVenta.add({
          'libro_id': libroId,
          'cantidad': item.quantity.value,
          'descuento': 0,
        });
      }

      // Mapear tipo de pago a string
      String tipoPagoStr;
      switch (options.tipoPago) {
        case TipoPago.contado:
          tipoPagoStr = 'contado';
          break;
        case TipoPago.credito:
          tipoPagoStr = 'credito';
          break;
        case TipoPago.mixto:
          tipoPagoStr = 'mixto';
          break;
      }

      // Crear la venta con todos los parámetros
      final result = await subinventarioService.crearVenta(
        subinventarioId: subinventarioActivo.value!.id,
        codCongregante: codCongregante,
        fechaVenta: DateTime.now().toIso8601String().split('T')[0],
        tipoPago: tipoPagoStr,
        usuario: username,
        libros: librosVenta,
        clienteId: options.cliente?.id,
        descuentoGlobal: options.descuentoGlobal,
        observaciones: options.observaciones,
        tieneEnvio: options.tieneEnvio,
        costoEnvio: options.costoEnvio,
        direccionEnvio: options.direccionEnvio,
        telefonoEnvio: options.telefonoEnvio,
      );

      if (result['error'] == false) {
        final ventaData = result['data'];

        // Limpiar carrito
        cartItems.clear();
        totalAmount.value = 0.0;
        selectedCartItem.value = null;

        // Recargar inventario del subinventario
        await cargarLibrosSubinventario();

        Get.snackbar(
          '¡Venta exitosa!',
          'Venta #${ventaData['venta_id']}\n'
              'Subtotal: \$${ventaData['subtotal']}\n'
              '${ventaData['descuento'] != '0.00' ? 'Descuento: -\$${ventaData['descuento']}\n' : ''}'
              '${options.tieneEnvio ? 'Envío: +\$${ventaData['costo_envio']}\n' : ''}'
              'Total: \$${ventaData['total']}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error al procesar venta',
          result['message'] ?? 'No se pudo completar la venta',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Error en _procesarVenta: $e');
      Get.snackbar(
        'Error',
        'Error al procesar la venta: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _procesarApartado(TransaccionOptions options) async {
    try {
      isLoading.value = true;

      // Obtener datos del usuario
      final codCongregante = AuthService.getCodCongregante();

      // Intentar obtener el servicio de auth, si no existe usar valor por defecto
      AuthService? authService;
      try {
        authService = Get.find<AuthService>();
      } catch (e) {
        print('AuthService no encontrado: $e');
      }

      final username = authService?.getUser ?? 'Usuario';

      // Preparar lista de libros para el apartado
      // Para apartados se requiere precio_unitario en cada libro
      final List<Map<String, dynamic>> librosApartado = [];
      for (var item in cartItems) {
        final libroId = int.tryParse(item.book.id);
        if (libroId == null) {
          throw Exception('ID de libro inválido: ${item.book.id}');
        }
        librosApartado.add({
          'libro_id': libroId,
          'cantidad': item.quantity.value,
          'precio_unitario': item.book.precio,
          'descuento': 0,
        });
      }

      // Formatear fecha límite si existe
      String? fechaLimiteStr;
      if (options.fechaLimite != null) {
        fechaLimiteStr = options.fechaLimite!.toIso8601String().split('T')[0];
      }

      // Crear el apartado
      final result = await subinventarioService.crearApartado(
        subinventarioId: subinventarioActivo.value!.id,
        codCongregante: codCongregante,
        clienteId: options.cliente!.id, // Siempre requerido en apartados
        fechaApartado: DateTime.now().toIso8601String().split('T')[0],
        enganche: options.enganche ?? 0,
        usuario: username,
        libros: librosApartado,
        fechaLimite: fechaLimiteStr,
        observaciones: options.observaciones,
      );

      if (result['error'] == false) {
        final apartadoData = result['data'];

        // Limpiar carrito
        cartItems.clear();
        totalAmount.value = 0.0;
        selectedCartItem.value = null;

        // Recargar inventario del subinventario
        await cargarLibrosSubinventario();

        Get.snackbar(
          '¡Apartado creado!',
          'Folio: ${apartadoData['folio']}\n'
              'Total: \$${apartadoData['monto_total']}\n'
              'Enganche: \$${apartadoData['enganche']}\n'
              'Saldo pendiente: \$${apartadoData['saldo_pendiente']}\n'
              '${apartadoData['fecha_limite'] != null ? 'Límite: ${apartadoData['fecha_limite']}' : ''}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error al crear apartado',
          result['message'] ?? 'No se pudo completar el apartado',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Error en _procesarApartado: $e');
      Get.snackbar(
        'Error',
        'Error al crear el apartado: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateQuantityByInput(int newQuantity) {
    if (selectedCartItem.value == null) {
      Get.snackbar('Error', 'No hay ningún libro seleccionado');
      return;
    }
    if (newQuantity <= 0) {
      Get.snackbar('Error', 'La cantidad debe ser mayor que cero');
      return;
    }

    CartItem item = selectedCartItem.value!;

    // Verificar stock del subinventario
    final libroEnSubinventario = librosDisponibles.firstWhereOrNull(
      (libro) => libro.id.toString() == item.book.id,
    );

    final stockDisponible =
        libroEnSubinventario?.cantidadDisponible ?? item.book.cantidadEnStock;

    if (newQuantity > stockDisponible) {
      Get.snackbar(
        'Sin stock',
        'No hay suficiente stock en este punto de venta. Disponible: $stockDisponible',
      );
      return;
    }

    totalAmount.value -= item.book.precio * item.quantity.value;
    item.quantity.value = newQuantity;
    totalAmount.value += item.book.precio * item.quantity.value;
    cartItems.refresh();
  }

  @override
  void onClose() {
    // Limpiar el callback cuando se cierre el controlador
    cameraService.setBarcodeCallback((_) {});
    super.onClose();
  }
}
