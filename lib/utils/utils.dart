import 'package:nugget/src/models/data_entry.dart';

class Utils {
  static String getShortMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mär';
      case 4:
        return 'Apr';
      case 5:
        return 'Mai';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Okt';
      case 11:
        return 'Nov';
      default:
        return 'Dez';
    }
  }

  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${getShortMonth(date.month)}.${date.year} | ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} Uhr';
  }

  static String formatValue(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',') + ' €';
  }

  static double calculateSumForName(List<DataEntry> entries, String name) {
    if (entries == null || entries.isEmpty) return 0.0;

    List<DataEntry> filteredList =
        entries.where((entry) => entry.name == name).toList();

    double sum = 0.0;

    for (DataEntry entry in filteredList) {
      sum += entry.value;
    }

    return sum;
  }
}
