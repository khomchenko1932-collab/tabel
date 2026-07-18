import '../../data/database/app_database.dart';
import '../../data/models/soldier_view.dart';
import '../entities/enums.dart';

/// Боец с вычисленным «эффективным» статусом (с учётом активных
/// командировок и отпусков). Для вакансии [status] == null.
class EffectiveSoldier {
  const EffectiveSoldier(this.view, this.status);

  final SoldierView view;
  final PersonnelStatus? status;

  bool get isVacant => view.isVacant;
}

/// Сводка строевой записки: по штату / по списку / по статусам,
/// с разбивкой каждого статуса по категориям.
class RosterStats {
  RosterStats({
    required this.total,
    required this.list,
    required this.vacant,
    required this.statusCounts,
    required this.statusByCategory,
    required this.vacantByCategory,
  });

  /// По штату (всего должностей).
  final int total;

  /// По списку (занятых должностей).
  final int list;

  /// Вакантных должностей.
  final int vacant;

  final Map<PersonnelStatus, int> statusCounts;
  final Map<PersonnelStatus, Map<RankCategory, int>> statusByCategory;
  final Map<RankCategory, int> vacantByCategory;

  int get here => statusCounts[PersonnelStatus.here] ?? 0;

  int count(PersonnelStatus s) => statusCounts[s] ?? 0;

  static RosterStats from(List<EffectiveSoldier> soldiers) {
    final statusCounts = <PersonnelStatus, int>{
      for (final s in PersonnelStatus.values) s: 0,
    };
    final statusByCategory = <PersonnelStatus, Map<RankCategory, int>>{
      for (final s in PersonnelStatus.values)
        s: {for (final c in RankCategory.values) c: 0},
    };
    final vacantByCategory = <RankCategory, int>{
      for (final c in RankCategory.values) c: 0,
    };

    var vacant = 0;
    for (final es in soldiers) {
      final cat = es.view.category;
      if (es.isVacant || es.status == null) {
        vacant++;
        vacantByCategory[cat] = (vacantByCategory[cat] ?? 0) + 1;
      } else {
        final st = es.status!;
        statusCounts[st] = (statusCounts[st] ?? 0) + 1;
        statusByCategory[st]![cat] = (statusByCategory[st]![cat] ?? 0) + 1;
      }
    }

    final total = soldiers.length;
    return RosterStats(
      total: total,
      list: total - vacant,
      vacant: vacant,
      statusCounts: statusCounts,
      statusByCategory: statusByCategory,
      vacantByCategory: vacantByCategory,
    );
  }
}

/// Бизнес-правила расчёта эффективного статуса и сводки.
abstract final class RosterService {
  /// Возвращает true, если запись [row] активна на дату [day]
  /// (по статусу «активна» или по попаданию даты в интервал).
  static bool _tripActive(TripRow t, DateTime day) {
    if (t.status == TripStatus.completed) return false;
    // Даты необязательны: нет начала — считаем, что уже началось; нет конца —
    // открытая командировка (активна, пока не завершат вручную).
    final afterStart = t.startDate == null || !day.isBefore(_d(t.startDate!));
    final beforeEnd = t.endDate == null || !day.isAfter(_d(t.endDate!));
    return afterStart && beforeEnd;
  }

  static bool _leaveActive(LeaveRow l, DateTime day) {
    if (l.status == LeaveStatus.completed ||
        l.status == LeaveStatus.cancelled) {
      return false;
    }
    final afterStart = l.startDate == null || !day.isBefore(_d(l.startDate!));
    final beforeEnd = l.endDate == null || !day.isAfter(_d(l.endDate!));
    return afterStart && beforeEnd;
  }

  static DateTime _d(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  /// Эффективный статус бойца. Приоритет: командировка > отпуск > сохранённый.
  static PersonnelStatus effectiveStatus(
    PersonRow person,
    List<TripRow> trips,
    List<LeaveRow> leaves,
    DateTime day,
  ) {
    final today = _d(day);
    if (trips.any((t) => t.personnelId == person.id && _tripActive(t, today))) {
      return PersonnelStatus.trip;
    }
    if (leaves
        .any((l) => l.personnelId == person.id && _leaveActive(l, today))) {
      return PersonnelStatus.leave;
    }
    return person.status;
  }

  /// Совмещает штат с активными командировками/отпусками.
  static List<EffectiveSoldier> resolve({
    required List<SoldierView> roster,
    required List<TripRow> trips,
    required List<LeaveRow> leaves,
    required DateTime day,
  }) {
    return roster.map((v) {
      final p = v.person;
      if (p == null) return EffectiveSoldier(v, null);
      return EffectiveSoldier(v, effectiveStatus(p, trips, leaves, day));
    }).toList();
  }
}
