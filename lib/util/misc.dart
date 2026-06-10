import 'dart:math';
import 'package:intl/intl.dart';

class Misc {
  DateTime parseDueDateTime(DateTime? date, String? time) {
    if (date == null || time == null) return DateTime(2100);

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final combined = '$dateStr $time'; // e.g., "2025-07-05 07:30 PM"
      final formatter = time.contains(RegExp(r'[a-zA-Z]'))
          ? DateFormat('yyyy-MM-dd hh:mm a')
          : DateFormat('yyyy-MM-dd HH:mm');
      return formatter.parse(combined);
    } catch (e) {
      print('❌ Failed to parse due datetime: $e');
      return DateTime(2100);
    }
  }

  int taskFormula(
    int difficulty,
    int timeIntensity, {
    double multiplier = 1.5,
  }) {
    final mathed =
        ((pow(difficulty, 1.2) + pow(timeIntensity, 1.2)) * multiplier).floor();
    return mathed;
  }
}
