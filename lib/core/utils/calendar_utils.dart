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
