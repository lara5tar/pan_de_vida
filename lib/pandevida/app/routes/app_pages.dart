import 'package:get/get.dart';

import '../modules/affirmation/bindings/affirmation_binding.dart';
import '../modules/affirmation/views/affirmation_index_view.dart';
import '../modules/affirmation/views/affirmation_videos_view.dart';
import '../modules/alertas/bindings/alertas_binding.dart';
import '../modules/alertas/views/alertas_view.dart';
import '../modules/clases/bindings/clases_binding.dart';
import '../modules/clases/views/clase_cuestionario_video_view.dart';
import '../modules/clases/views/clase_cuestionario_view.dart';
import '../modules/clases/views/clase_videos_view.dart';
import '../modules/clases/views/clases_view.dart';
import '../modules/congregants/bindings/congregants_binding.dart';
import '../modules/congregants/views/congregant_adress_view.dart';
import '../modules/congregants/views/congregant_affirmation_view.dart';
import '../modules/congregants/views/congregant_attandance_view.dart';
import '../modules/congregants/views/congregant_info_view.dart';
import '../modules/congregants/views/congregant_profile_view.dart';
import '../modules/congregants/views/congregants_index_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/escuela/bindings/escuela_binding.dart';
import '../modules/escuela/views/capturar_asistencia_view.dart';
import '../modules/escuela/views/capturar_pago_view.dart';
import '../modules/event/bindings/event_binding.dart';
import '../modules/event/views/event_form_view.dart';
import '../modules/event/views/event_view.dart';
import '../modules/event/views/events_calendar_view.dart';
import '../modules/event/views/events_view.dart';
import '../modules/grupos_de_vida/bindings/grupos_de_vida_binding.dart';
import '../modules/grupos_de_vida/bindings/quiero_asistir_binding.dart';
import '../modules/grupos_de_vida/views/grupos_de_vida_view.dart';
import '../modules/grupos_de_vida/views/quiero_asistir_view.dart';
import '../modules/landing/bindings/landing_binding.dart';
import '../modules/landing/views/landing_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/map_groups/bindings/map_groups_binding.dart';
import '../modules/map_groups/views/map_groups_view.dart';
import '../modules/punto_de_venta/modules/cart/bindings/cart_binding.dart';
import '../modules/punto_de_venta/modules/cart/views/cart_view.dart';
import '../modules/punto_de_venta/modules/mycart/bindings/mycart_binding.dart';
import '../modules/punto_de_venta/modules/mycart/views/mycart_view.dart';
import '../modules/punto_de_venta/modules/books/bindings/books_binding.dart';
import '../modules/punto_de_venta/modules/books/views/books_view.dart';
import '../modules/punto_de_venta/modules/books/views/book_form_view.dart';
import '../modules/punto_de_venta/modules/books/views/book_detail_view.dart';
import '../modules/punto_de_venta/modules/pos_view/bindings/pos_view_binding.dart';
import '../modules/punto_de_venta/modules/pos_view/views/pos_view.dart';
import '../modules/punto_de_venta/modules/search_view/bindings/search_view_binding.dart';
import '../modules/punto_de_venta/modules/search_view/views/search_view.dart';
import '../modules/punto_de_venta/modules/subinventario_selection/bindings/subinventario_selection_binding.dart';
import '../modules/punto_de_venta/modules/subinventario_selection/views/subinventario_selection_view.dart';
import '../modules/punto_de_venta/modules/abonos/bindings/abonos_binding.dart';
import '../modules/punto_de_venta/modules/abonos/views/buscar_apartado_view.dart';
import '../modules/punto_de_venta/modules/abonos/views/registrar_abono_view.dart';
import '../modules/punto_de_venta/modules/abonos/views/historial_abonos_view.dart';
import '../modules/punto_de_venta/modules/cart/views/crear_cliente_view.dart';
import '../modules/restauracion/bindings/restauracion_binding.dart';
import '../modules/restauracion/views/restauracion_congregante_view.dart';
import '../modules/restauracion/views/restauracion_view.dart';
import '../modules/reuniones/bindings/reuniones_binding.dart';
import '../modules/reuniones/views/reunion_asistencia_view.dart';
import '../modules/reuniones/views/reunion_form_view.dart';
import '../modules/reuniones/views/reuniones_view.dart';
import '../modules/rpa/bindings/rpa_binding.dart';
import '../modules/rpa/views/cumbres_view.dart';
import '../modules/rpa/views/new_prospecto_view.dart';
import '../modules/rpa/views/prospectos_videos_view.dart';
import '../modules/rpa/views/prospectos_view.dart';
import '../modules/rpa/views/rpa_index_view.dart';
import '../modules/rpa/views/team_view.dart';
import '../modules/test_ministerio/bindings/test_ministerio_binding.dart';
import '../modules/test_ministerio/views/test_ministerio_list_view.dart';
import '../modules/test_ministerio/views/test_ministerio_preguntas_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LANDING;

  static final routes = [
    GetPage(
      name: _Paths.LANDING,
      page: () => const LandingView(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.GRUPOS_DE_VIDA,
      page: () => const GruposDeVidaView(),
      binding: GruposDeVidaBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.MAP_GROUPS,
      page: () => const MapGroupsView(),
      binding: MapGroupsBinding(),
    ),
    GetPage(
      name: _Paths.CONGREGANTS_INDEX,
      page: () => const CongregantsIndexView(),
      binding: CongregantsBinding(),
    ),
    GetPage(
      name: _Paths.CONGREGANT_PROFILE,
      page: () => const CongregantProfileView(),
      binding: CongregantsBinding(),
    ),
    GetPage(
      name: _Paths.CONGREGANT_INFO,
      page: () => const CongregantInfoView(),
      binding: CongregantsBinding(),
    ),
    GetPage(
      name: _Paths.CONGREGANT_ADRESS,
      page: () => const CongregantAdressView(),
      binding: CongregantsBinding(),
    ),
    GetPage(
      name: _Paths.CONGREGANT_AFFIRMATION,
      page: () => const CongregantAffirmationView(),
      binding: CongregantsBinding(),
    ),
    GetPage(
      name: _Paths.CONGREGANT_ATTENDANCE,
      page: () => const CongregantAttandanceView(),
      binding: CongregantsBinding(),
    ),
    GetPage(
      name: _Paths.CUMBRE_INDEX,
      page: () => const CumbresView(),
      binding: RpaBinding(),
    ),
    GetPage(
      name: _Paths.RPA_INDEX,
      page: () => const RpaIndexView(),
      binding: RpaBinding(),
    ),
    GetPage(
      name: _Paths.TEAM,
      page: () => const TeamView(),
      binding: RpaBinding(),
    ),
    GetPage(
      name: _Paths.PROSPECTOS,
      page: () => const ProspectosView(),
      binding: RpaBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PROSPECTO,
      page: () => const NewProspectoView(),
      binding: RpaBinding(),
    ),
    GetPage(
      name: _Paths.PROSPECTO_VIDEOS,
      page: () => const ProspectosVideosView(),
      binding: RpaBinding(),
    ),
    GetPage(
      name: _Paths.AFFIRMATION_INDEX,
      page: () => const AffirmationIndexView(),
      binding: AffirmationBinding(),
    ),
    GetPage(
      name: _Paths.AFFIRMATION_VIDEOS,
      page: () => const AffirmationVideosView(),
      binding: AffirmationBinding(),
    ),
    GetPage(
      name: _Paths.JOIN_GROUP,
      page: () => const QuieroAsistirView(),
      binding: QuieroAsistirBinding(),
    ),
    GetPage(
      name: _Paths.RESTAURACION,
      page: () => const RestauracionView(),
      binding: RestauracionBinding(),
    ),
    GetPage(
      name: _Paths.RESTAURACION_CONGREGANTES,
      page: () => const RestauracionCongreganteView(),
      binding: RestauracionBinding(),
    ),
    GetPage(
      name: _Paths.REUNIONES,
      page: () => const ReunionesView(),
      binding: ReunionesBinding(),
    ),
    GetPage(
      name: _Paths.REUNION_FORM,
      page: () => const ReunionFormView(),
      binding: ReunionesBinding(),
    ),
    GetPage(
      name: _Paths.REUNION_ASISTENCIA,
      page: () => const ReunionAsistenciaView(),
      binding: ReunionesBinding(),
    ),
    GetPage(
      name: _Paths.ALERTAS,
      page: () => const AlertasView(),
      binding: AlertasBinding(),
    ),
    GetPage(
      name: _Paths.CAPTURAR_ASISTENCIA,
      page: () => const CapturarAsistenciaView(),
      binding: EscuelaBinding(),
    ),
    GetPage(
      name: _Paths.CAPTURAR_PAGO,
      page: () => const CapturarPagoView(),
      binding: EscuelaBinding(),
    ),
    GetPage(
      name: _Paths.CLASES,
      page: () => const ClasesView(),
      binding: ClasesBinding(),
    ),
    GetPage(
      name: _Paths.CLASE_VIDEOS,
      page: () => const ClaseVideosView(),
      binding: ClasesBinding(),
    ),
    GetPage(
      name: _Paths.CLASE_CUESTIONARIO,
      page: () => const ClaseCuestionarioView(),
      binding: ClasesBinding(),
    ),
    GetPage(
      name: _Paths.CLASE_CUESTIONARIO_VIDEO,
      page: () => const ClaseCuestionarioVideoView(),
      binding: ClasesBinding(),
    ),
    GetPage(
      name: _Paths.TEST_MINISTERIO,
      page: () => const TestMinisterioListView(),
      binding: TestMinisterioBinding(),
    ),
    GetPage(
      name: _Paths.TEST_MINISTERIO_PREGUNTAS,
      page: () => const TestMinisterioPreguntasView(),
      binding: TestMinisterioBinding(),
    ),
    GetPage(
      name: _Paths.EVENTS,
      page: () => const EventsView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_FORM,
      page: () => const EventFormView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: _Paths.EVENT,
      page: () => const EventView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_CALENDAR,
      page: () => const EventsCalendarView(),
      binding: EventBinding(),
    ),
    GetPage(
        name: _Paths.PUNTODEVENTA,
        page: () => const MycartView(),
        binding: MycartBinding()),
    GetPage(
        name: _Paths.BOOKS,
        page: () => const BooksView(),
        binding: BooksBinding()),
    GetPage(
        name: _Paths.BOOK_FORM,
        page: () => const BookFormView(),
        binding: BooksBinding()),
    GetPage(
        name: _Paths.BOOK_DETAIL,
        page: () => const BookDetailView(),
        binding: BooksBinding()),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    // Punto de Venta - Primero muestra selección de subinventario
    GetPage(
      name: _Paths.POS_VIEW,
      page: () => const SubinventarioSelectionView(),
      binding: SubinventarioSelectionBinding(),
    ),
    // Vista principal del punto de venta con cámara
    GetPage(
      name: _Paths.POS_VIEW_MAIN,
      page: () => const PosView(),
      binding: PosViewBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_VIEW,
      page: () => const SearchView(),
      binding: SearchViewBinding(),
    ),
    // Mantener esta ruta para compatibilidad pero usar POS_VIEW
    GetPage(
      name: _Paths.SUBINVENTARIO_SELECTION,
      page: () => const SubinventarioSelectionView(),
      binding: SubinventarioSelectionBinding(),
    ),
    // Rutas para el módulo de abonos
    GetPage(
      name: _Paths.ABONOS_BUSCAR,
      page: () => const BuscarApartadoView(),
      binding: AbonosBinding(),
    ),
    GetPage(
      name: _Paths.ABONOS_REGISTRAR,
      page: () => const RegistrarAbonoView(),
      binding: AbonosBinding(),
    ),
    GetPage(
      name: _Paths.ABONOS_HISTORIAL,
      page: () => const HistorialAbonosView(),
      binding: AbonosBinding(),
    ),
    // Ruta para crear cliente
    GetPage(
      name: _Paths.CREAR_CLIENTE,
      page: () => const CrearClienteView(),
    ),
  ];
}
