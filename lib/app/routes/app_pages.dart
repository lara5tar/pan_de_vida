import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/reuniones/views/reunion_form_view.dart';

import '../modules/affirmation/bindings/affirmation_binding.dart';
import '../modules/affirmation/views/affirmation_index_view.dart';
import '../modules/affirmation/views/affirmation_videos_view.dart';
import '../modules/congregants/bindings/congregants_binding.dart';
import '../modules/congregants/views/congregant_adress_view.dart';
import '../modules/congregants/views/congregant_affirmation_view.dart';
import '../modules/congregants/views/congregant_attandance_view.dart';
import '../modules/congregants/views/congregant_info_view.dart';
import '../modules/congregants/views/congregant_profile_view.dart';
import '../modules/congregants/views/congregants_index_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
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
import '../modules/restauracion/bindings/restauracion_binding.dart';
import '../modules/restauracion/views/restauracion_congregante_view.dart';
import '../modules/restauracion/views/restauracion_view.dart';
import '../modules/reuniones/bindings/reuniones_binding.dart';
import '../modules/reuniones/views/reunion_form_edit_view.dart';
import '../modules/reuniones/views/reuniones_view.dart';
import '../modules/rpa/bindings/rpa_binding.dart';
import '../modules/rpa/views/cumbres_view.dart';
import '../modules/rpa/views/new_prospecto_view.dart';
import '../modules/rpa/views/prospectos_videos_view.dart';
import '../modules/rpa/views/prospectos_view.dart';
import '../modules/rpa/views/rpa_index_view.dart';
import '../modules/rpa/views/team_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LANDING;
  // static const INITIAL = Routes.ASISTENCIA;

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
    // GetPage(
    //   name: _Paths.ASISTENCIA,
    //   page: () => const AsistenciaView(),
    //   binding: AsistenciaBinding(),
    // ),
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
      name: _Paths.REUNION_FORM_EDIT,
      page: () => const ReunionFormEditView(),
      binding: ReunionesBinding(),
    ),
  ];
}
