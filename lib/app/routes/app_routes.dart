// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const LANDING = _Paths.LANDING;
  static const LOGIN = _Paths.LOGIN;
  static const GRUPOS_DE_VIDA = _Paths.GRUPOS_DE_VIDA;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const MAP_GROUPS = _Paths.MAP_GROUPS;
  static const CONGREGANTS_INDEX = _Paths.CONGREGANTS_INDEX;
  static const CUMBRE_INDEX = _Paths.CUMBRE_INDEX;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const LANDING = '/landing';
  static const LOGIN = '/login';
  static const GRUPOS_DE_VIDA = '/grupos-de-vida';
  static const DASHBOARD = '/dashboard';
  static const MAP_GROUPS = '/map-groups';
  static const CONGREGANTS_INDEX = '/search-congregant';
  static const CUMBRE_INDEX = '/cumbres';
}

// List<String> opciones = [
//   'search-congregant',
//   'cumbre',
//   'hist-cumbre',
//   'list-cumbre-equipo',
//   'listProspecto',
//   'list-afirmacion',
//   'list-restauracion',
//   'escuela-asistencia',
//   'escuela-pago',
//   'grupoVida-asistencia-datos',
//   'grupoVida-hist-grupo',
//   'alertas',
//   'list-desarrollo',
// ];
