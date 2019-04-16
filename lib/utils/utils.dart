import 'package:nugget/src/models/data_entry.dart';

class Utils {
  static String calculateSumForName(List<DataEntry> entries, String name) {
    if (entries == null || entries.isEmpty)
      return '0,00';

    List<DataEntry> filteredList =
        entries.where((entry) => entry.name == name).toList();

    double sum = 0.0;

    for (DataEntry entry in filteredList) {
      sum += entry.value;
    }

    return sum.toStringAsFixed(2).replaceAll('.', ',');
  }
}
