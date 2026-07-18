import '../../data/database/app_database.dart';

/// Разложение промежутка на лет / месяцев / дней (календарное, с «заёмом»).
class Ymd {
  const Ymd(this.years, this.months, this.days);
  final int years;
  final int months;
  final int days;

  bool get isZero => years == 0 && months == 0 && days == 0;
}

/// Пороги процентной надбавки за выслугу лет (по календарной выслуге).
/// СПРАВОЧНО: сверять с действующим Постановлением Правительства РФ № 992.
/// Пары «полных лет ≥ / процент», по убыванию.
const List<(int, int)> kAllowanceTiers = [
  (25, 40),
  (20, 30),
  (15, 25),
  (10, 20),
  (5, 15),
  (2, 10),
];

/// Выслуга лет военнослужащего на дату [asOf].
///
/// - Календарная — фактический промежуток от [start] до [asOf].
/// - Льготная — календарная плюс [bonusDays] за льготные периоды
///   (день за 1.5/2/3): `bonus = Σ (коэф − 1) × дни`.
/// Право на пенсию (20 лет) считается по льготной; надбавка — по календарной.
class LengthOfService {
  const LengthOfService({
    required this.start,
    required this.asOf,
    required this.bonusDays,
  });

  final DateTime start;
  final DateTime asOf;
  final int bonusDays;

  /// Календарная выслуга (лет/мес/дн).
  Ymd get calendar => _decompose(start, asOf);

  /// «Виртуальное» начало для льготного исчисления (раньше на [bonusDays]).
  DateTime get _preferentialAnchor =>
      start.subtract(Duration(days: bonusDays));

  /// Льготная выслуга (лет/мес/дн).
  Ymd get preferential => _decompose(_preferentialAnchor, asOf);

  bool get hasBonus => bonusDays > 0;

  int get calendarYears => calendar.years;

  /// Процентная надбавка за выслугу лет (по календарной выслуге), справочно.
  int get allowancePercent {
    for (final t in kAllowanceTiers) {
      if (calendarYears >= t.$1) return t.$2;
    }
    return 0;
  }

  /// Дата достижения 20 лет выслуги (по льготной) — право на пенсию.
  DateTime get pensionDate => DateTime(
        _preferentialAnchor.year + 20,
        _preferentialAnchor.month,
        _preferentialAnchor.day,
      );

  bool get pensionReached => !pensionDate.isAfter(asOf);

  /// Разложение остатка до пенсии (0/0/0 — уже достигнута).
  Ymd get toPension =>
      pensionReached ? const Ymd(0, 0, 0) : _decompose(asOf, pensionDate);

  /// Собрать выслугу по бойцу: ручные льготные периоды + командировки с
  /// коэффициентом > 1 (боевые «день за три» и т.п.). При перекрытии берётся
  /// высший коэффициент. Возвращает null, если дата начала службы не задана.
  static LengthOfService? of(
    PersonRow person,
    List<ServicePeriodRow> periods, {
    List<TripRow> trips = const [],
    DateTime? now,
  }) {
    final rawStart = person.serviceStart;
    if (rawStart == null) return null;
    final asOf = now ?? DateTime.now();
    // Дата начала в будущем — выслуги ещё нет.
    final start = rawStart.isAfter(asOf) ? asOf : rawStart;

    final recs = <({DateTime start, DateTime? end, double coef})>[
      for (final p in periods)
        (start: p.startDate, end: p.endDate, coef: p.coefficient),
      // Командировки с льготным коэффициентом — как периоды.
      for (final t in trips)
        if (t.serviceCoef > 1.0 && t.startDate != null)
          (start: t.startDate!, end: t.endDate ?? t.actualReturnDate, coef: t.serviceCoef),
    ];
    return LengthOfService(
        start: start, asOf: asOf, bonusDays: _bonusDays(start, asOf, recs));
  }

  /// Бонусные дни за льготное исчисление. Ключевое: за каждый день берётся
  /// НАИБОЛЕЕ ВЫГОДНЫЙ (высший) коэффициент из перекрывающих его периодов —
  /// не суммируем (день не может считаться и за 1.5, и за 3 одновременно).
  static int _bonusDays(
    DateTime start,
    DateTime asOf,
    List<({DateTime start, DateTime? end, double coef})> periods,
  ) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(asOf.year, asOf.month, asOf.day);
    final total = e.difference(s).inDays;
    if (total <= 0 || periods.isEmpty) return 0;
    // Границы периодов в днях (в РФ нет перехода на летнее время — сутки ровные).
    final bounds = [
      for (final p in periods)
        (
          from: DateTime(p.start.year, p.start.month, p.start.day),
          to: p.end == null ? e : DateTime(p.end!.year, p.end!.month, p.end!.day),
          coef: p.coef,
        ),
    ];
    var bonus = 0.0;
    for (var i = 0; i < total; i++) {
      final d = s.add(Duration(days: i));
      var best = 1.0;
      for (final b in bounds) {
        if (b.coef > best && !d.isBefore(b.from) && !d.isAfter(b.to)) best = b.coef;
      }
      bonus += best - 1.0;
    }
    return bonus.round();
  }

  /// Расчёт по произвольным данным (для интерактивного калькулятора выслуги):
  /// дата начала службы + список льготных периодов (начало, конец?, коэф.).
  static LengthOfService fromParts(
    DateTime start,
    List<({DateTime start, DateTime? end, double coef})> periods, {
    DateTime? now,
  }) {
    final asOf = now ?? DateTime.now();
    final s = start.isAfter(asOf) ? asOf : start;
    return LengthOfService(
        start: s, asOf: asOf, bonusDays: _bonusDays(s, asOf, periods));
  }

  static Ymd _decompose(DateTime from, DateTime to) {
    if (!to.isAfter(from)) return const Ymd(0, 0, 0);
    var y = to.year - from.year;
    var m = to.month - from.month;
    var d = to.day - from.day;
    if (d < 0) {
      m -= 1;
      // День 0 месяца `to` = последний день предыдущего месяца.
      d += DateTime(to.year, to.month, 0).day;
    }
    if (m < 0) {
      y -= 1;
      m += 12;
    }
    return Ymd(y, m, d);
  }
}

/// «5 лет 3 мес 12 дн» с русским склонением и опущением нулевых частей.
String formatYmd(Ymd v) {
  if (v.isZero) return '0 дн';
  final parts = <String>[];
  if (v.years > 0) parts.add('${v.years} ${_plural(v.years, 'год', 'года', 'лет')}');
  if (v.months > 0) parts.add('${v.months} мес');
  if (v.days > 0) parts.add('${v.days} дн');
  return parts.join(' ');
}

String _plural(int n, String one, String few, String many) {
  final mod100 = n % 100;
  final mod10 = n % 10;
  if (mod100 >= 11 && mod100 <= 14) return many;
  if (mod10 == 1) return one;
  if (mod10 >= 2 && mod10 <= 4) return few;
  return many;
}
