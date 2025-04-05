String getMonthInt(String month) {
  switch (month) {
    case 'Enero' || 'January':
      return '01';
    case 'Febrero' || 'February':
      return '02';
    case 'Marzo' || 'March':
      return '03';
    case 'Abril' || 'April':
      return '04';
    case 'Mayo' || 'May':
      return '05';
    case 'Junio' || 'June':
      return '06';
    case 'Julio' || 'July':
      return '07';
    case 'Agosto' || 'August':
      return '08';
    case 'Septiembre' || 'September':
      return '09';
    case 'Octubre' || 'October':
      return '10';
    case 'Noviembre' || 'November':
      return '11';
    case 'Diciembre' || 'December':
      return '12';
    default:
      return '01';
  }
}

String getMonthString(int month) {
  switch (month) {
    case 1:
      return 'Enero';
    case 2:
      return 'Febrero';
    case 3:
      return 'Marzo';
    case 4:
      return 'Abril';
    case 5:
      return 'Mayo';
    case 6:
      return 'Junio';
    case 7:
      return 'Julio';
    case 8:
      return 'Agosto';
    case 9:
      return 'Septiembre';
    case 10:
      return 'Octubre';
    case 11:
      return 'Noviembre';
    case 12:
      return 'Diciembre';
    default:
      return 'Mes invalido';
  }
}

String formatDateHeader(String dateString) {
  DateTime today = DateTime.now();
  if (dateString.startsWith("Recurrente")) {
    return dateString;
  } else if (dateString == "Sin fecha") {
    return "Sin fecha específica";
  } else {
    try {
      final date = DateTime.parse(dateString);
      final todayDate = DateTime(today.year, today.month, today.day);
      final eventDate = DateTime(date.year, date.month, date.day);

      // Obtener el nombre del día de la semana
      final diaSemana = obtenerNombreDiaSemana(date.weekday);

      if (eventDate.isAtSameMomentAs(todayDate)) {
        return "Hoy, $diaSemana ${date.day}/${date.month}/${date.year}";
      } else if (eventDate
          .isAtSameMomentAs(todayDate.add(const Duration(days: 1)))) {
        return "Mañana, $diaSemana ${date.day}/${date.month}/${date.year}";
      } else {
        return "$diaSemana ${date.day}/${date.month}/${date.year}";
      }
    } catch (e) {
      return dateString;
    }
  }
}

String obtenerNombreDiaSemana(int diaSemana) {
  switch (diaSemana) {
    case DateTime.monday:
      return "Lunes";
    case DateTime.tuesday:
      return "Martes";
    case DateTime.wednesday:
      return "Miércoles";
    case DateTime.thursday:
      return "Jueves";
    case DateTime.friday:
      return "Viernes";
    case DateTime.saturday:
      return "Sábado";
    case DateTime.sunday:
      return "Domingo";
    default:
      return "";
  }
}

String obtenerNombre(String diaSemana) {
  switch (diaSemana) {
    case 'L':
      return 'Lunes';
    case 'M':
      return 'Martes';
    case 'Mi':
      return 'Miércoles';
    case 'J':
      return 'Jueves';
    case 'V':
      return 'Viernes';
    case 'S':
      return 'Sábados';
    case 'D':
      return 'Domingos';
    default:
      return '';
  }
}
