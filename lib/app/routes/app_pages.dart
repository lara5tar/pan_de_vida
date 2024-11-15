import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/congregants/views/congregant_info_view.dart';
import 'package:pan_de_vida/app/modules/congregants/views/congregant_profile_view.dart';

import '../modules/congregants/bindings/congregants_binding.dart';
import '../modules/congregants/views/congregants_index_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/grupos_de_vida/bindings/grupos_de_vida_binding.dart';
import '../modules/grupos_de_vida/views/grupos_de_vida_view.dart';
import '../modules/landing/bindings/landing_binding.dart';
import '../modules/landing/views/landing_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/map_groups/bindings/map_groups_binding.dart';
import '../modules/map_groups/views/map_groups_view.dart';

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
      page: () => const CongregantInfoView(),
      binding: CongregantsBinding(),
    ),
    GetPage(
      name: _Paths.CONGREGANT_AFFIRMATION,
      page: () => const CongregantInfoView(),
      binding: CongregantsBinding(),
    ),
    GetPage(
      name: _Paths.CONGREGANT_ATTENDANCE,
      page: () => const CongregantInfoView(),
      binding: CongregantsBinding(),
    ),
  ];
}
