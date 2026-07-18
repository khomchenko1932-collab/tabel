import 'package:intl/intl.dart';

/// Форматирование дат и чисел в русской локали.
abstract final class Fmt {
  static final _full = DateFormat('dd MMMM yyyy', 'ru');
  static final _short = DateFormat('dd.MM.yyyy', 'ru');
  static final _dm = DateFormat('dd.MM', 'ru');
  static final _dt = DateFormat('dd.MM.yy · HH:mm', 'ru');
  static final _month = DateFormat('LLLL', 'ru');

  /// Название месяца в именительном падеже: «июль».
  static String monthName(DateTime d) => _month.format(d);

  /// «17 июня 2026».
  static String full(DateTime d) => _full.format(d);

  /// «17.06.2026».
  static String short(DateTime d) => _short.format(d);

  /// «17.06».
  static String dayMonth(DateTime d) => _dm.format(d);

  /// «17.06.26 · 09:47».
  static String stamp(DateTime d) => _dt.format(d);

  /// Склонение слова «день».
  static String days(int n) {
    final a = n.abs() % 100;
    final b = n.abs() % 10;
    if (a >= 11 && a <= 14) return '$n дней';
    if (b == 1) return '$n день';
    if (b >= 2 && b <= 4) return '$n дня';
    return '$n дней';
  }

  /// Склонение слова «человек».
  static String people(int n) {
    final a = n.abs() % 100;
    final b = n.abs() % 10;
    if (a >= 11 && a <= 14) return '$n человек';
    if (b == 1) return '$n человек';
    if (b >= 2 && b <= 4) return '$n человека';
    return '$n человек';
  }
}
