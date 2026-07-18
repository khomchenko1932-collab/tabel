import 'package:flutter_test/flutter_test.dart';
import 'package:narmb_ls/data/database/app_database.dart';
import 'package:narmb_ls/domain/entities/enums.dart';
import 'package:narmb_ls/domain/services/service_service.dart';

PersonRow _person(DateTime? serviceStart) => PersonRow(
      id: 1,
      lastName: 'Иванов',
      firstName: 'И',
      middleName: 'И',
      rank: 'рядовой',
      status: PersonnelStatus.here,
      childrenCount: 0,
      isVeteran: false,
      allowanceSpecial: 0,
      allowanceSecrecy: 0,
      allowanceRisk: 0,
      allowanceFizo: 0,
      allowanceAchieve: 0,
      regionalCoef: 1.0,
      premiumPercent: 25,
      leaveLimitMain: 40,
      leaveLimitAdditional: 7,
      leaveLimitVeteran: 0,
      serviceStart: serviceStart,
      isArchived: false,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

ServicePeriodRow _period(DateTime start, DateTime? end, double coef) =>
    ServicePeriodRow(
      id: 1,
      personnelId: 1,
      startDate: start,
      endDate: end,
      coefficient: coef,
      note: '',
    );

void main() {
  final now = DateTime(2026, 7, 11);

  group('LengthOfService — календарная', () {
    test('нет даты начала → null', () {
      expect(LengthOfService.of(_person(null), const [], now: now), isNull);
    });

    test('ровно 5 лет 0 мес 0 дн', () {
      final los = LengthOfService.of(_person(DateTime(2021, 7, 11)), const [], now: now)!;
      expect(los.calendar.years, 5);
      expect(los.calendar.months, 0);
      expect(los.calendar.days, 0);
    });

    test('раскладка с заёмом дней/месяцев', () {
      final los = LengthOfService.of(_person(DateTime(2020, 8, 20)), const [], now: now)!;
      expect(los.calendar.years, 5);
      expect(los.calendar.months, 10);
      expect(los.calendar.days, 21); // с 20.08.2020 по 11.07.2026
    });

    test('дата начала в будущем → выслуга 0', () {
      final los = LengthOfService.of(_person(DateTime(2030)), const [], now: now)!;
      expect(los.calendar.isZero, isTrue);
    });
  });

  group('Надбавка за выслугу (по календарной, справочно)', () {
    int pct(int fullYears) => LengthOfService(
          start: DateTime(now.year - fullYears, now.month, now.day),
          asOf: now,
          bonusDays: 0,
        ).allowancePercent;

    test('менее 2 лет → 0%', () => expect(pct(1), 0));
    test('2 года → 10%', () => expect(pct(2), 10));
    test('5 лет → 15%', () => expect(pct(5), 15));
    test('10 лет → 20%', () => expect(pct(10), 20));
    test('15 лет → 25%', () => expect(pct(15), 25));
    test('20 лет → 30%', () => expect(pct(20), 30));
    test('25 лет → 40%', () => expect(pct(25), 40));
  });

  group('Льготная выслуга и пенсия', () {
    test('период «день за три» добавляет 2× дней сверх календаря', () {
      // Один календарный год службы (365 дн), весь — коэффициент 3.
      final start = DateTime(2025, 7, 11);
      final period = _period(DateTime(2025, 7, 11), DateTime(2026, 7, 11), 3.0);
      final los = LengthOfService.of(_person(start), [period], now: now)!;
      expect(los.calendar.years, 1);
      expect(los.hasBonus, isTrue);
      expect(los.bonusDays, 730); // (3−1) × 365
      // Льготная ≈ 3 года (день-в-день из-за месяцев/високоса — 2 г 11 мес 30 дн).
      expect(los.preferential.years, greaterThanOrEqualTo(2));
    });

    test('коэффициент не выходит за рамки службы', () {
      // Период начинается раньше службы — учитывается только пересечение
      // [11.01.2026 … 11.07.2026] = 181 дн.
      final start = DateTime(2026, 1, 11);
      final period = _period(DateTime(2020, 1, 1), DateTime(2026, 7, 11), 2.0);
      final los = LengthOfService.of(_person(start), [period], now: now)!;
      expect(los.calendar.years, 0);
      expect(los.bonusDays, 181); // (2−1) × 181, а не за 6 лет периода
    });

    test('перекрытие периодов: берётся ВЫСШИЙ коэффициент, а не сумма', () {
      // Весь 2020 год — «день за полтора», внутри 30 дней командировки «за три».
      final start = DateTime(2020, 1, 1);
      final end = DateTime(2020, 12, 31);
      final blanket = _period(DateTime(2020, 1, 1), DateTime(2020, 12, 31), 1.5);
      final cmd = _period(DateTime(2020, 6, 1), DateTime(2020, 6, 30), 3.0);
      final losBase = LengthOfService.of(_person(start), [blanket], now: end)!;
      final losBoth = LengthOfService.of(_person(start), [blanket, cmd], now: end)!;
      // 30 дней апгрейд 1.5→3 добавляют по (3−1)−(1.5−1)=1.5 дн/день = 45,
      // а НЕ 2×30=60 (это был бы двойной учёт).
      expect(losBoth.bonusDays - losBase.bonusDays, 45);
    });

    test('командировка с коэф. > 1 идёт в льготную выслугу', () {
      final start = DateTime(2025, 7, 11);
      final trip = TripRow(
        id: 1, personnelId: 1, destination: 'зона', purpose: '', serviceCoef: 3.0,
        status: TripStatus.completed,
        startDate: DateTime(2025, 7, 11), endDate: DateTime(2026, 7, 11),
      );
      final los = LengthOfService.of(_person(start), const [], trips: [trip], now: now)!;
      expect(los.hasBonus, isTrue);
      expect(los.bonusDays, 730); // (3−1)×365, как ручной период
    });

    test('20 лет льготной → право на пенсию достигнуто', () {
      final los = LengthOfService.of(
          _person(DateTime(2006, 7, 11)), const [], now: now)!;
      expect(los.calendar.years, 20);
      expect(los.pensionReached, isTrue);
    });

    test('15 лет календарной без льгот → пенсия не достигнута', () {
      final los = LengthOfService.of(
          _person(DateTime(2011, 7, 11)), const [], now: now)!;
      expect(los.pensionReached, isFalse);
      expect(los.toPension.years, 5);
    });
  });

  group('formatYmd', () {
    test('склонение лет', () {
      expect(formatYmd(const Ymd(1, 0, 0)), '1 год');
      expect(formatYmd(const Ymd(2, 0, 0)), '2 года');
      expect(formatYmd(const Ymd(5, 0, 0)), '5 лет');
      expect(formatYmd(const Ymd(11, 0, 0)), '11 лет');
    });

    test('опускает нулевые части', () {
      expect(formatYmd(const Ymd(3, 0, 12)), '3 года 12 дн');
      expect(formatYmd(const Ymd(0, 0, 0)), '0 дн');
    });
  });
}
