import 'package:flutter_test/flutter_test.dart';
import 'package:narmb_ls/data/database/app_database.dart';
import 'package:narmb_ls/domain/entities/enums.dart';
import 'package:narmb_ls/domain/services/pay_service.dart';

PersonRow _person({
  String rank = 'капитан',
  String? qual,
  int special = 0,
  int secrecy = 0,
  int risk = 0,
  double region = 1.0,
  int premium = 0,
}) =>
    PersonRow(
      id: 1,
      lastName: 'Иванов',
      firstName: 'И',
      middleName: 'И',
      rank: rank,
      status: PersonnelStatus.here,
      qualification: qual,
      childrenCount: 0,
      isVeteran: false,
      allowanceSpecial: special,
      allowanceSecrecy: secrecy,
      allowanceRisk: risk,
      allowanceFizo: 0,
      allowanceAchieve: 0,
      regionalCoef: region,
      premiumPercent: premium,
      leaveLimitMain: 40,
      leaveLimitAdditional: 7,
      leaveLimitVeteran: 0,
      isArchived: false,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

PositionRow _pos({int? tariff}) => PositionRow(
      id: 1,
      slot: 1,
      title: 'Командир',
      subunit: 'Батарея',
      category: RankCategory.officer,
      tariffRank: tariff,
    );

// ОВД 15-го разряда = 32 000, ОВЗ капитана = 15 000 — круглые для проверки.
final _scale = PayScale({15: 32000}, {'капитан': 15000});

void main() {
  group('PayBreakdown', () {
    test('ОМДС = ОВД + ОВЗ', () {
      final b = PayBreakdown.of(_person(), _pos(tariff: 15), _scale, serviceAllowancePercent: 0);
      expect(b.ovd, 32000);
      expect(b.ovz, 15000);
      expect(b.omds, 47000);
    });

    test('надбавка за выслугу считается от ОМДС', () {
      final b = PayBreakdown.of(_person(), _pos(tariff: 15), _scale, serviceAllowancePercent: 30);
      // 30% от 47000 = 14100; итог без прочих надбавок = 47000 + 14100.
      expect(b.monthly, 47000 + 14100);
    });

    test('классность и особые условия — от ОВД', () {
      final b = PayBreakdown.of(
        _person(qual: '1 класс', special: 20),
        _pos(tariff: 15),
        _scale,
        serviceAllowancePercent: 0,
      );
      // 1 класс = 20% от ОВД(32000)=6400; особые 20% от 32000=6400.
      expect(b.monthly, 47000 + 6400 + 6400);
    });

    test('премия — от ОМДС', () {
      final b = PayBreakdown.of(_person(premium: 25), _pos(tariff: 15), _scale, serviceAllowancePercent: 0);
      expect(b.monthly, 47000 + 11750); // 25% от 47000
    });

    test('районный коэффициент множит всё довольствие', () {
      final b = PayBreakdown.of(_person(region: 1.5), _pos(tariff: 15), _scale, serviceAllowancePercent: 0);
      expect(b.monthly, (47000 * 1.5).round());
    });

    test('нет разряда/звания → оклад 0, но не падает', () {
      final b = PayBreakdown.of(_person(rank: 'нет'), _pos(), _scale, serviceAllowancePercent: 10);
      expect(b.omds, 0);
      expect(b.hasSalary, isFalse);
      expect(b.monthly, 0);
    });

    test('матпомощь за год = 1 ОМДС', () {
      final b = PayBreakdown.of(_person(), _pos(tariff: 15), _scale, serviceAllowancePercent: 0);
      expect(b.matHelpAnnual, 47000);
    });
  });

  group('PayBreakdown.ofInput (интерактивный калькулятор)', () {
    test('суммирует надбавки от нужной базы', () {
      final b = PayBreakdown.ofInput(const PayInput(
        ovd: 30000, ovz: 15000,
        servicePct: 20, // от ОМДС(45000)=9000
        classPct: 10, // от ОВД(30000)=3000
        secrecyPct: 20, // от ОВД=6000
        fizoPct: 30, // от ОВД=9000
        premiumPct: 25, // от ОМДС=11250
      ));
      expect(b.omds, 45000);
      expect(b.monthly, 45000 + 9000 + 3000 + 6000 + 9000 + 11250);
    });

    test('районный коэффициент множит итог', () {
      final b = PayBreakdown.ofInput(const PayInput(ovd: 20000, ovz: 10000, regionalCoef: 1.5));
      expect(b.monthly, (30000 * 1.5).round());
    });

    test('пустые оклады → 0, не падает', () {
      final b = PayBreakdown.ofInput(const PayInput(ovd: 0, ovz: 0, riskPct: 50));
      expect(b.monthly, 0);
    });
  });

  group('НДФЛ (до/после удержания)', () {
    test('после НДФЛ = 87% от суммы', () {
      final b = PayBreakdown.ofInput(const PayInput(ovd: 40000, ovz: 20000));
      expect(b.monthly, 60000);
      expect(b.afterTax, (60000 * 0.87).round());
      expect(b.taxAmount, 60000 - b.afterTax);
    });
  });

  group('classQualPercent', () {
    test('мастер 30, 1 класс 20, 2 класс 10, 3 класс 5, нет 0', () {
      expect(classQualPercent('Мастер'), 30);
      expect(classQualPercent('1 класс'), 20);
      expect(classQualPercent('2 класс'), 10);
      expect(classQualPercent('3 класс'), 5);
      expect(classQualPercent(null), 0);
    });
  });

  group('formatRub', () {
    test('разделяет тысячи неразрывным пробелом', () {
      const n = ' ';
      expect(formatRub(64473), '64${n}473$n₽');
      expect(formatRub(7166), '7${n}166$n₽');
      expect(formatRub(0), '0$n₽');
    });
  });
}
