import '../../data/database/app_database.dart';
import '../entities/enums.dart';

/// Баланс отпусков бойца за год: лимиты, отгуляно, остаток.
/// Дни дороги в расход лимита не идут (учитывается только [daysGranted]).
class LeaveBalance {
  LeaveBalance({
    required this.limitMain,
    required this.limitAdditional,
    required this.limitVeteran,
    required this.usedMain,
    required this.usedAdditional,
    required this.usedVeteran,
  });

  final int limitMain;
  final int limitAdditional;
  final int limitVeteran;
  final int usedMain;
  final int usedAdditional;
  final int usedVeteran;

  int get totalLimit => limitMain + limitAdditional + limitVeteran;
  int get totalUsed => usedMain + usedAdditional + usedVeteran;
  int get remaining => (totalLimit - totalUsed).clamp(-9999, totalLimit);
  double get fraction => totalLimit == 0 ? 0 : (totalUsed / totalLimit).clamp(0, 1);
  bool get exhausted => remaining <= 0;

  /// Баланс за конкретный год [year] (по умолчанию — текущий). Лимит отпуска
  /// годовой: каждый календарный год расход обнуляется, поэтому считаем только
  /// отпуска этого года (по дате начала; без даты — относим к текущему году).
  static LeaveBalance of(PersonRow person, List<LeaveRow> leaves,
      {DateTime? now, int? year}) {
    final today = now ?? DateTime.now();
    final targetYear = year ?? today.year;
    var main = 0;
    var additional = 0;
    var veteran = 0;
    for (final l in leaves) {
      if (l.status == LeaveStatus.cancelled) continue;
      final s = l.startDate;
      // Отпуск относится к году своей даты начала. Без даты — к текущему году.
      final leaveYear = s?.year ?? today.year;
      if (leaveYear != targetYear) continue;
      // Будущие (ещё не начатые) отпуска не считаем «отгулянными».
      if (s != null && s.isAfter(DateTime(today.year, today.month, today.day))) {
        continue;
      }
      switch (l.type) {
        case LeaveType.main:
          main += l.daysGranted;
        case LeaveType.additional:
          additional += l.daysGranted;
        case LeaveType.veteran:
          veteran += l.daysGranted;
        case LeaveType.medical:
          break; // медицинский не списывается с лимитов
      }
    }
    return LeaveBalance(
      limitMain: person.leaveLimitMain,
      limitAdditional: person.leaveLimitAdditional,
      limitVeteran: person.leaveLimitVeteran,
      usedMain: main,
      usedAdditional: additional,
      usedVeteran: veteran,
    );
  }
}

/// Расчёт даты окончания отпуска: начало + дни + дорога − 1.
abstract final class LeaveCalc {
  static DateTime endDate({
    required DateTime start,
    required int daysGranted,
    required bool includesTravel,
    required int travelDays,
  }) {
    final total = daysGranted + (includesTravel ? travelDays : 0);
    return start.add(Duration(days: total - 1));
  }
}
