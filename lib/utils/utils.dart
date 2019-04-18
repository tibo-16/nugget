import 'package:flutter/material.dart';
import 'package:nugget/src/models/data_entry.dart';
import 'package:nugget/utils/app_colors.dart';

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

  static String getShortWeekDay(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mo';
      case DateTime.tuesday:
        return 'Di';
      case DateTime.wednesday:
        return 'Mi';
      case DateTime.thursday:
        return 'Do';
      case DateTime.friday:
        return 'Fr';
      case DateTime.saturday:
        return 'Sa';
      default:
        return 'So';
    }
  }

  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${getShortMonth(date.month)}.${date.year}';
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

  // 1: Einkauf, 2: Takeaway, 3: Restaurant, 4: Freizeit, 5: Bargeld
  static IconData getIconForCategory(int category) {
    switch (category) {
      case 1:
        return Icons.local_grocery_store;
      case 2:
        return Icons.fastfood;
      case 3:
        return Icons.local_dining;
      case 4:
        return Icons.movie;
      case 5:
        return Icons.attach_money;
      default:
        return Icons.loyalty;
    }
  }

  static Widget getGradientIcon(IconData icon) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (rect) {
        return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[AppColors.PURPLE, AppColors.BLUE],
                tileMode: TileMode.mirror)
            .createShader(rect);
      },
      child: Icon(icon),
    );
  }

  static String getEmojiForName(String name) {
    if (name.toLowerCase() == 'tobi') {
      return '🐻';
    } else {
      return '🦊';
    }
  }
}
