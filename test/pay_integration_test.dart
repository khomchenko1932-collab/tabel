import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:narmb_ls/data/database/app_database.dart';
import 'package:narmb_ls/domain/entities/enums.dart';
import 'package:narmb_ls/domain/services/pay_service.dart';

/// Сквозная проверка: реальная БД (onCreate сеет справочник окладов) →
/// PayScale из БД → PayBreakdown. Ловит расхождения сида, схемы и движка.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  test('справочник окладов засеян (50 разрядов + звания)', () async {
    final rates = await db.allPayRates();
    final tariffs = rates.where((r) => r.kind == PayRateKind.tariff).length;
    final ranks = rates.where((r) => r.kind == PayRateKind.rank).length;
    expect(tariffs, 50);
    expect(ranks, greaterThanOrEqualTo(15));
  });

  test('расчёт ДД капитана на 20-м разряде совпадает с сидом', () async {
    await db.wipeAll(); // очистить засеянный штат, справочник окладов остаётся
    // Должность с тарифным разрядом 20 + боец-капитан.
    final posId = await db.insertPosition(PositionsCompanion.insert(
      slot: 1,
      title: 'Командир взвода',
      category: RankCategory.officer,
      tariffRank: const Value(20),
    ));
    await db.insertPerson(PersonnelCompanion.insert(
      lastName: 'Петров',
      rank: const Value('капитан'),
      positionId: Value(posId),
      premiumPercent: const Value(25),
    ));

    final scale = PayScale.from(await db.allPayRates());
    final roster = await db.getRoster();
    final view = roster.firstWhere((s) => s.person != null);

    final b = PayBreakdown.of(
      view.person!,
      view.position,
      scale,
      serviceAllowancePercent: 0,
    );

    // Сид на 01.10.2025: ОВД(20)=35819, ОВЗ(капитан)=15761.
    expect(b.ovd, 35819);
    expect(b.ovz, 15761);
    expect(b.omds, 51580);
    // Премия по умолчанию 25% от ОМДС = 12895 → итог 64475.
    expect(b.monthly, 64475);
  });

  test('экспорт → импорт сохраняет оклады и надбавки (round-trip v3)', () async {
    await db.wipeAll();
    final posId = await db.insertPosition(PositionsCompanion.insert(
      slot: 1, title: 'Наводчик', category: RankCategory.soldier,
      tariffRank: const Value(15),
    ));
    await db.insertPerson(PersonnelCompanion.insert(
      lastName: 'Сидоров', rank: const Value('сержант'), positionId: Value(posId),
      allowanceSpecial: const Value(30), regionalCoef: const Value(1.5),
    ));

    final json = await db.exportJson();

    final db2 = AppDatabase.forTesting(NativeDatabase.memory());
    await db2.importJson(json);
    final roster = await db2.getRoster();
    final v = roster.firstWhere((s) => s.person != null);
    expect(v.position.tariffRank, 15);
    expect(v.person!.allowanceSpecial, 30);
    expect(v.person!.regionalCoef, 1.5);
    // Справочник окладов тоже перенёсся.
    expect((await db2.allPayRates()).length, greaterThan(60));
    await db2.close();
  });
}
