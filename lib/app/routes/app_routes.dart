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
  static const CONGREGANT_PROFILE = _Paths.CONGREGANT_PROFILE;
  static const CONGREGANT_INFO = _Paths.CONGREGANT_INFO;
  static const CONGREGANT_ADRESS = _Paths.CONGREGANT_ADRESS;
  static const CONGREGANT_AFFIRMATION = _Paths.CONGREGANT_AFFIRMATION;
  static const CONGREGANT_ATTENDANCE = _Paths.CONGREGANT_ATTENDANCE;
  static const RPA_INDEX = _Paths.RPA_INDEX;
  static const TEAM = _Paths.TEAM;
  static const PROSPECTOS = _Paths.PROSPECTOS;
  static const NEW_PROSPECTO = _Paths.NEW_PROSPECTO;
  static const PROSPECTO_VIDEOS = _Paths.PROSPECTO_VIDEOS;
  static const AFFIRMATION_INDEX = _Paths.AFFIRMATION_INDEX;
  static const AFFIRMATION_VIDEOS = _Paths.AFFIRMATION_VIDEOS;
  static const JOIN_GROUP = _Paths.JOIN_GROUP;
  static const RESTAURACION = _Paths.RESTAURACION;
  static const RESTAURACION_CONGREGANTES = _Paths.RESTAURACION_CONGREGANTES;
  static const REUNIONES = _Paths.REUNIONES;
  static const REUNION_FORM = _Paths.REUNION_FORM;
  static const REUNION_FORM_EDIT = _Paths.REUNION_FORM_EDIT;
  static const REUNION_ASISTENCIA = _Paths.REUNION_ASISTENCIA;
  static const CAPTURAR_ASISTENCIA = _Paths.CAPTURAR_ASISTENCIA;
  static const CAPTURAR_PAGO = _Paths.CAPTURAR_PAGO;
  static const ALERTAS = _Paths.ALERTAS;
  static const CLASES = _Paths.CLASES;
  static const CLASE_VIDEOS = _Paths.CLASE_VIDEOS;
  static const CLASE_CUESTIONARIO = _Paths.CLASE_CUESTIONARIO;
  static const CLASE_CUESTIONARIO_VIDEO = _Paths.CLASE_CUESTIONARIO_VIDEO;
  static const EVENTS = _Paths.EVENTS;
  static const EVENT_FORM = _Paths.EVENT_FORM;
  static const EVENT = _Paths.EVENT;
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
  static const CONGREGANT = '/congregant';
  static const CONGREGANT_PROFILE = '$CONGREGANT/profile';
  static const CONGREGANT_INFO = '$CONGREGANT/info';
  static const CONGREGANT_ADRESS = '$CONGREGANT/adress';
  static const CONGREGANT_AFFIRMATION = '$CONGREGANT/affirmation';
  static const CONGREGANT_ATTENDANCE = '$CONGREGANT/attendance';
  static const RPA_INDEX = '/hist-cumbre';
  static const TEAM = '/list-cumbre-equipo';
  static const PROSPECTOS = '/listProspecto';
  static const NEW_PROSPECTO = '/new-prospecto';
  static const PROSPECTO_VIDEOS = '/prospecto-videos';
  static const CUMBRE_INDEX = '/cumbre';
  static const AFFIRMATION_INDEX = '/list-afirmacion';
  static const AFFIRMATION_VIDEOS = '/affirmation/videos';

  static const JOIN_GROUP = '/grupos-de-vida/join';
  static const RESTAURACION = '/list-restauracion';
  static const RESTAURACION_CONGREGANTES = '$RESTAURACION/congregantes';

  static const REUNIONES = '/grupoVida-hist-grupo';
  static const REUNION_FORM = '/grupoVida-asistencia-datos';
  static const REUNION_ASISTENCIA = '$REUNION_FORM/personas';

  static const REUNION_FORM_EDIT = '/reunion-form-edit';
  static const CAPTURAR_ASISTENCIA = '/escuela-asistencia';
  static const CAPTURAR_PAGO = '/escuela-pago';

  static const ALERTAS = '/alertas';

  static const CLASES = '/asistencias';
  static const CLASE_VIDEOS = '$CLASES/CLASE_VIDEOS';
  static const CLASE_CUESTIONARIO = '$CLASES/CLASE_CUESTIONARIO';
  static const CLASE_CUESTIONARIO_VIDEO = '$CLASES/CLASE_CUESTIONARIO_VIDEO';
  static const EVENTS = '/events';
  static const EVENT_FORM = '$EVENTS/form';
  static const EVENT = '$EVENTS/event';
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
