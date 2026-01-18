import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../data/models/subinventario_model.dart';
import '../../../data/services/subinventario_service.dart';

class SubinventarioSelectionController extends GetxController {
  final SubinventarioService _service = SubinventarioService();
  final GetStorage _storage = GetStorage('login');

  final RxList<Subinventario> subinventarios = <Subinventario>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Subinventario?> selectedSubinventario = Rx<Subinventario?>(null);
  final RxBool isAdminLibreria = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkIfAdminLibreria();
    cargarSubinventarios();
  }

  /// Verifica si el usuario tiene el rol ADMIN LIBRERIA
  void _checkIfAdminLibreria() {
    try {
      final roles = _getUserRoles();
      isAdminLibreria.value =
          roles.any((role) => role['ROL'] == 'ADMIN LIBRERIA');
      print('Usuario es ADMIN LIBRERIA: ${isAdminLibreria.value}');
    } catch (e) {
      print('Error verificando rol admin: $e');
      isAdminLibreria.value = false;
    }
  }

  /// Obtiene los roles del usuario desde GetStorage
  List<Map<String, dynamic>> _getUserRoles() {
    try {
      final rolesData = _storage.read('roles');
      if (rolesData != null && rolesData is List) {
        return List<Map<String, dynamic>>.from(
            rolesData.map((role) => Map<String, dynamic>.from(role)));
      }
    } catch (e) {
      print('Error obteniendo roles: $e');
    }
    return [];
  }

  Future<void> cargarSubinventarios() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      Map<String, dynamic> result;

      if (isAdminLibreria.value) {
        // Admin: obtener todos los puntos de venta
        print('Cargando todos los puntos de venta (ADMIN)');
        final roles = _getUserRoles();
        result = await _service.getTodosPuntosVenta(roles);
      } else {
        // Usuario normal: obtener solo sus subinventarios asignados
        final codCongregante = AuthService.getCodCongregante();

        if (codCongregante.isEmpty) {
          errorMessage.value = 'No se encontró el código de usuario';
          Future.microtask(() => Get.snackbar(
                'Error',
                'No se pudo obtener la información del usuario',
                snackPosition: SnackPosition.BOTTOM,
              ));
          return;
        }

        print('Cargando subinventarios para: $codCongregante');
        result = await _service.getMisSubinventarios(codCongregante);
      }

      if (result['error'] == false) {
        subinventarios.value = result['data'] as List<Subinventario>;

        print('Subinventarios cargados: ${subinventarios.length}');

        // Si solo hay uno, seleccionarlo automáticamente y navegar
        if (subinventarios.length == 1) {
          seleccionarSubinventario(subinventarios.first);
        }
      } else {
        errorMessage.value = result['message'];
        Future.microtask(() => Get.snackbar(
              'Información',
              result['message'],
              snackPosition: SnackPosition.BOTTOM,
            ));
      }
    } catch (e) {
      errorMessage.value = 'Error al cargar subinventarios: $e';
      print('Error en cargarSubinventarios: $e');
      Future.microtask(() => Get.snackbar(
            'Error',
            'No se pudieron cargar los subinventarios',
            snackPosition: SnackPosition.BOTTOM,
          ));
    } finally {
      isLoading.value = false;
    }
  }

  void seleccionarSubinventario(Subinventario subinventario) async {
    selectedSubinventario.value = subinventario;

    print(
        'Subinventario seleccionado: ${subinventario.id} - ${subinventario.nombreDisplay}');

    // Cargar los libros del subinventario antes de navegar
    isLoading.value = true;
    try {
      final codCongregante = AuthService.getCodCongregante();

      final result = await _service.getLibrosSubinventario(
        subinventario.id,
        codCongregante: codCongregante,
      );

      if (result['error'] == false) {
        final data = result['data'];

        // Crear nuevo subinventario con los libros cargados
        List<LibroSubinventario> libros = [];
        if (data['libros'] != null) {
          libros = (data['libros'] as List)
              .map((libro) => LibroSubinventario.fromJson(libro))
              .toList();
        }

        final subinventarioConLibros = Subinventario(
          id: subinventario.id,
          descripcion: subinventario.descripcion,
          fechaSubinventario: subinventario.fechaSubinventario,
          estado: subinventario.estado,
          totalLibros: data['total_libros'] ?? subinventario.totalLibros,
          totalUnidades: data['total_unidades'] ?? subinventario.totalUnidades,
          libros: libros,
        );

        // Navegar a la vista principal del punto de venta con el subinventario completo
        Get.toNamed(
          '/pos-view-main',
          arguments: {
            'subinventario': subinventarioConLibros,
          },
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'No se pudieron cargar los libros',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error al cargar libros: $e');
      Get.snackbar(
        'Error',
        'Error al cargar el inventario del punto de venta',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> recargar() async {
    await cargarSubinventarios();
  }
}
