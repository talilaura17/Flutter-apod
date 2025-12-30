String formatDate(DateTime datetime) {
  return '${datetime.year}-${datetime.month < 10 ? '0${datetime.month}' : datetime.month}-${datetime.day < 10 ? '0${datetime.day}' : datetime.day}';
}