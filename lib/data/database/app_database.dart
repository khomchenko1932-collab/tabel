import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../core/data/award_catalog.dart';
import '../../domain/entities/enums.dart';
import '../models/soldier_view.dart';
import 'pay_rates_seed.dart';
import 'seed_data.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Settings,
  Positions,
  Personnel,
  Awards,
  Leaves,
  Trips,
  Weapons,
  ServicePeriods,
  PayRates,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  /// Тестовый конструктор с произвольным исполнителем запросов.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seed();
          await _seedPayRates();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(personnel, personnel.birthDate);
            await m.addColumn(personnel, personnel.leaveLimitAdditional);
          }
          if (from < 3) {
            await m.createTable(settings);
          }
          if (from < 4) {
            // subunit: intEnum → свободный текст. positions.tariffRank добавлен
            // позже (v6) — помечаем как newColumns, чтобы пересоздание НЕ
            // пыталось скопировать несуществующую колонку из старой таблицы.
            // ignore: deprecated_member_use, experimental_member_use
            await m.alterTable(TableMigration(
              positions,
              columnTransformer: {
                positions.subunit: const CustomExpression<String>(
                  "CASE subunit "
                  "WHEN 0 THEN 'Управление батареи' "
                  "WHEN 1 THEN 'Взвод управления' "
                  "WHEN 2 THEN '1-й огневой взвод' "
                  "WHEN 3 THEN '2-й огневой взвод' "
                  "ELSE 'Подразделение' END",
                ),
              },
              newColumns: [positions.tariffRank],
            ));
          }
          if (from < 5) {
            await m.addColumn(personnel, personnel.serviceStart);
            await m.createTable(servicePeriods);
          }
          // tariffRank уже создан пересозданием при from < 4 — добавляем колонкой
          // только на путях v4/v5 (когда пересоздания не было).
          if (from >= 4 && from < 6) {
            await m.addColumn(positions, positions.tariffRank);
          }
          if (from < 6) {
            await m.addColumn(personnel, personnel.allowanceSpecial);
            await m.addColumn(personnel, personnel.allowanceSecrecy);
            await m.addColumn(personnel, personnel.allowanceRisk);
            await m.addColumn(personnel, personnel.regionalCoef);
            await m.addColumn(personnel, personnel.premiumPercent);
            await m.createTable(payRates);
            await _seedPayRates();
          }
          if (from < 7) {
            await m.addColumn(personnel, personnel.allowanceFizo);
            await m.addColumn(personnel, personnel.allowanceAchieve);
          }
          if (from < 8) {
            // Даты командировок и отпусков стали необязательными — пересоздаём
            // таблицы. trips.serviceCoef добавлен позже (v9) → newColumns, иначе
            // пересоздание попытается скопировать несуществующую колонку.
            // ignore: deprecated_member_use, experimental_member_use
            await m.alterTable(TableMigration(trips, newColumns: [trips.serviceCoef]));
            // ignore: deprecated_member_use, experimental_member_use
            await m.alterTable(TableMigration(leaves));
          }
          // serviceCoef уже создан пересозданием при from < 8 — добавляем колонкой
          // только на пути v8 (когда пересоздания не было).
          if (from >= 8 && from < 9) {
            await m.addColumn(trips, trips.serviceCoef);
          }
        },
        beforeOpen: (details) async {
          // В SQLite внешние ключи по умолчанию ВЫКЛЮЧЕНЫ, из-за чего
          // объявленные onDelete: cascade не срабатывают и после удаления
          // бойца остаются «осиротевшие» награды/отпуска/командировки/оружие.
          // Включаем их принудительно при каждом открытии соединения.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ══════════════════════════════ НАСТРОЙКИ ══════════════════════════════
  Stream<Map<String, String>> watchSettings() =>
      select(settings).watch().map((rows) => {for (final r in rows) r.key: r.value});

  Future<void> setSetting(String key, String value) => into(settings).insertOnConflictUpdate(
        SettingsCompanion.insert(key: key, value: value),
      );

  Future<String?> getSetting(String key) async {
    final row = await (select(settings)..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  /// Восстановление: очистка данных и повторный посев штата по умолчанию.
  Future<void> resetAll() async {
    await transaction(() async {
      await _wipe();
      await _seed();
    });
  }

  /// Полное удаление ВСЕГО (должности, бойцы, всё записанное) — пустой лист.
  Future<void> wipeAll() => transaction(_wipe);

  Future<void> _wipe() async {
    await delete(awards).go();
    await delete(leaves).go();
    await delete(trips).go();
    await delete(weapons).go();
    await delete(servicePeriods).go();
    await delete(personnel).go();
    await delete(positions).go();
  }

  /// Следующий свободный номер по штату.
  Future<int> nextSlot() async {
    final all = await select(positions).get();
    if (all.isEmpty) return 1;
    return all.map((p) => p.slot).reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<int> insertPosition(PositionsCompanion data) =>
      into(positions).insert(data);

  Future<void> updatePosition(int id, PositionsCompanion data) =>
      (update(positions)..where((t) => t.id.equals(id))).write(data);

  /// Удаление штатной должности вместе с занимающим её бойцом (если есть)
  /// и всеми его записями. Штат становится меньше.
  Future<void> deletePosition(int id) async {
    await transaction(() async {
      final occupants = await (select(personnel)
            ..where((t) => t.positionId.equals(id)))
          .get();
      for (final p in occupants) {
        await (delete(awards)..where((t) => t.personnelId.equals(p.id))).go();
        await (delete(leaves)..where((t) => t.personnelId.equals(p.id))).go();
        await (delete(trips)..where((t) => t.personnelId.equals(p.id))).go();
        await (delete(weapons)..where((t) => t.personnelId.equals(p.id))).go();
        await (delete(personnel)..where((t) => t.id.equals(p.id))).go();
      }
      await (delete(positions)..where((t) => t.id.equals(id))).go();
    });
  }

  // ══════════════════════════ ЭКСПОРТ / ИМПОРТ ДАННЫХ ════════════════════
  static int? _ms(DateTime? d) => d?.millisecondsSinceEpoch;
  static DateTime? _dt(Object? v) =>
      v == null ? null : DateTime.fromMillisecondsSinceEpoch(v as int);

  /// Полный снимок всех данных в JSON (для передачи на другое устройство).
  Future<String> exportJson() async {
    final pos = await select(positions).get();
    final per = await select(personnel).get();
    final awd = await select(awards).get();
    final lev = await select(leaves).get();
    final trp = await select(trips).get();
    final wpn = await select(weapons).get();
    final svc = await select(servicePeriods).get();
    final rates = await select(payRates).get();

    return jsonEncode({
      'app': 'tabel',
      'version': 5,
      'exportedAt': DateTime.now().toIso8601String(),
      'positions': [
        for (final p in pos)
          {'id': p.id, 'slot': p.slot, 'title': p.title, 'subunit': p.subunit, 'category': p.category.index, 'crew': p.crew, 'tariffRank': p.tariffRank},
      ],
      'personnel': [
        for (final p in per)
          {
            'id': p.id, 'positionId': p.positionId, 'lastName': p.lastName,
            'firstName': p.firstName, 'middleName': p.middleName, 'rank': p.rank,
            'status': p.status.index, 'personalNumber': p.personalNumber,
            'phone': p.phone, 'address': p.address, 'maritalStatus': p.maritalStatus?.index,
            'childrenCount': p.childrenCount, 'birthDate': _ms(p.birthDate),
            'contractStart': _ms(p.contractStart), 'contractEnd': _ms(p.contractEnd),
            'qualification': p.qualification, 'qualificationDate': _ms(p.qualificationDate),
            'serviceStart': _ms(p.serviceStart),
            'allowanceSpecial': p.allowanceSpecial, 'allowanceSecrecy': p.allowanceSecrecy,
            'allowanceRisk': p.allowanceRisk, 'regionalCoef': p.regionalCoef,
            'premiumPercent': p.premiumPercent,
            'allowanceFizo': p.allowanceFizo, 'allowanceAchieve': p.allowanceAchieve,
            'isVeteran': p.isVeteran, 'leaveLimitMain': p.leaveLimitMain,
            'leaveLimitAdditional': p.leaveLimitAdditional, 'leaveLimitVeteran': p.leaveLimitVeteran,
            'isArchived': p.isArchived, 'createdAt': _ms(p.createdAt), 'updatedAt': _ms(p.updatedAt),
          },
      ],
      'awards': [
        for (final a in awd)
          {'id': a.id, 'personnelId': a.personnelId, 'name': a.name, 'kind': a.kind.index, 'degree': a.degree, 'awardDate': _ms(a.awardDate), 'note': a.note},
      ],
      'leaves': [
        for (final l in lev)
          {
            'id': l.id, 'personnelId': l.personnelId, 'type': l.type.index, 'status': l.status.index,
            'daysGranted': l.daysGranted, 'includesTravel': l.includesTravel, 'travelDays': l.travelDays,
            'startDate': _ms(l.startDate), 'endDate': _ms(l.endDate), 'actualReturnDate': _ms(l.actualReturnDate),
            'orderNumber': l.orderNumber, 'destination': l.destination, 'note': l.note,
          },
      ],
      'trips': [
        for (final t in trp)
          {
            'id': t.id, 'personnelId': t.personnelId, 'destination': t.destination, 'purpose': t.purpose,
            'status': t.status.index, 'startDate': _ms(t.startDate), 'endDate': _ms(t.endDate),
            'actualReturnDate': _ms(t.actualReturnDate), 'orderNumber': t.orderNumber, 'note': t.note,
            'serviceCoef': t.serviceCoef,
          },
      ],
      'weapons': [
        for (final w in wpn)
          {'id': w.id, 'personnelId': w.personnelId, 'name': w.name, 'type': w.type.index, 'serialNumber': w.serialNumber, 'inventoryNumber': w.inventoryNumber, 'assignedDate': _ms(w.assignedDate), 'note': w.note},
      ],
      'servicePeriods': [
        for (final s in svc)
          {'id': s.id, 'personnelId': s.personnelId, 'startDate': _ms(s.startDate), 'endDate': _ms(s.endDate), 'coefficient': s.coefficient, 'note': s.note},
      ],
      'payRates': [
        for (final r in rates)
          {'id': r.id, 'kind': r.kind.index, 'code': r.code, 'amount': r.amount},
      ],
    });
  }

  /// Загрузка снимка: полностью заменяет текущие данные данными из JSON.
  /// Бросает [FormatException] при неверном формате.
  Future<void> importJson(String source) async {
    final Map<String, dynamic> data;
    try {
      data = jsonDecode(source) as Map<String, dynamic>;
    } catch (_) {
      throw const FormatException('Файл не распознан');
    }
    if (data['app'] != 'tabel') {
      throw const FormatException('Это не файл данных «Табель»');
    }
    if ((data['version'] as int? ?? 1) > 5) {
      throw const FormatException('Файл создан в более новой версии приложения');
    }

    List<Map<String, dynamic>> rows(String key) =>
        ((data[key] as List?) ?? const []).cast<Map<String, dynamic>>();

    try {
      await _importRows(rows);
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('Файл повреждён или имеет неверный формат');
    }
  }

  Future<void> _importRows(
      List<Map<String, dynamic>> Function(String) rows) async {
    await transaction(() async {
      await _wipe();
      for (final p in rows('positions')) {
        await into(positions).insert(PositionsCompanion.insert(
          slot: p['slot'] as int,
          title: p['title'] as String,
          subunit: Value((p['subunit'] as String?) ?? 'Подразделение'),
          category: RankCategory.values[p['category'] as int],
          crew: Value(p['crew'] as String?),
          tariffRank: Value(p['tariffRank'] as int?),
          id: Value(p['id'] as int),
        ));
      }
      for (final p in rows('personnel')) {
        await into(personnel).insert(PersonnelCompanion.insert(
          id: Value(p['id'] as int),
          positionId: Value(p['positionId'] as int?),
          lastName: p['lastName'] as String,
          firstName: Value(p['firstName'] as String? ?? ''),
          middleName: Value(p['middleName'] as String? ?? ''),
          rank: Value(p['rank'] as String? ?? ''),
          status: Value(PersonnelStatus.values[p['status'] as int? ?? 0]),
          personalNumber: Value(p['personalNumber'] as String?),
          phone: Value(p['phone'] as String?),
          address: Value(p['address'] as String?),
          maritalStatus: Value(p['maritalStatus'] == null ? null : MaritalStatus.values[p['maritalStatus'] as int]),
          childrenCount: Value(p['childrenCount'] as int? ?? 0),
          birthDate: Value(_dt(p['birthDate'])),
          contractStart: Value(_dt(p['contractStart'])),
          contractEnd: Value(_dt(p['contractEnd'])),
          qualification: Value(p['qualification'] as String?),
          qualificationDate: Value(_dt(p['qualificationDate'])),
          serviceStart: Value(_dt(p['serviceStart'])),
          allowanceSpecial: Value(p['allowanceSpecial'] as int? ?? 0),
          allowanceSecrecy: Value(p['allowanceSecrecy'] as int? ?? 0),
          allowanceRisk: Value(p['allowanceRisk'] as int? ?? 0),
          regionalCoef: Value((p['regionalCoef'] as num?)?.toDouble() ?? 1.0),
          premiumPercent: Value(p['premiumPercent'] as int? ?? 0),
          allowanceFizo: Value(p['allowanceFizo'] as int? ?? 0),
          allowanceAchieve: Value(p['allowanceAchieve'] as int? ?? 0),
          isVeteran: Value(p['isVeteran'] as bool? ?? false),
          leaveLimitMain: Value(p['leaveLimitMain'] as int? ?? 40),
          leaveLimitAdditional: Value(p['leaveLimitAdditional'] as int? ?? 7),
          leaveLimitVeteran: Value(p['leaveLimitVeteran'] as int? ?? 0),
          isArchived: Value(p['isArchived'] as bool? ?? false),
          createdAt: Value(_dt(p['createdAt']) ?? DateTime.now()),
          updatedAt: Value(_dt(p['updatedAt']) ?? DateTime.now()),
        ));
      }
      for (final a in rows('awards')) {
        await into(awards).insert(AwardsCompanion.insert(
          id: Value(a['id'] as int),
          personnelId: a['personnelId'] as int,
          name: a['name'] as String,
          kind: AwardKind.values[a['kind'] as int],
          degree: Value(a['degree'] as String?),
          awardDate: Value(_dt(a['awardDate'])),
          note: Value(a['note'] as String?),
        ));
      }
      for (final l in rows('leaves')) {
        await into(leaves).insert(LeavesCompanion.insert(
          id: Value(l['id'] as int),
          personnelId: l['personnelId'] as int,
          type: LeaveType.values[l['type'] as int],
          status: Value(LeaveStatus.values[l['status'] as int? ?? 0]),
          daysGranted: l['daysGranted'] as int,
          includesTravel: Value(l['includesTravel'] as bool? ?? false),
          travelDays: Value(l['travelDays'] as int? ?? 0),
          startDate: Value(_dt(l['startDate'])),
          endDate: Value(_dt(l['endDate'])),
          actualReturnDate: Value(_dt(l['actualReturnDate'])),
          orderNumber: Value(l['orderNumber'] as String?),
          destination: Value(l['destination'] as String?),
          note: Value(l['note'] as String?),
        ));
      }
      for (final t in rows('trips')) {
        await into(trips).insert(TripsCompanion.insert(
          id: Value(t['id'] as int),
          personnelId: t['personnelId'] as int,
          destination: t['destination'] as String,
          purpose: Value(t['purpose'] as String? ?? ''),
          status: Value(TripStatus.values[t['status'] as int? ?? 0]),
          startDate: Value(_dt(t['startDate'])),
          endDate: Value(_dt(t['endDate'])),
          actualReturnDate: Value(_dt(t['actualReturnDate'])),
          orderNumber: Value(t['orderNumber'] as String?),
          note: Value(t['note'] as String?),
          serviceCoef: Value((t['serviceCoef'] as num?)?.toDouble() ?? 1.0),
        ));
      }
      for (final w in rows('weapons')) {
        await into(weapons).insert(WeaponsCompanion.insert(
          id: Value(w['id'] as int),
          personnelId: w['personnelId'] as int,
          name: w['name'] as String,
          type: WeaponType.values[w['type'] as int],
          serialNumber: Value(w['serialNumber'] as String?),
          inventoryNumber: Value(w['inventoryNumber'] as String?),
          assignedDate: Value(_dt(w['assignedDate'])),
          note: Value(w['note'] as String?),
        ));
      }
      for (final s in rows('servicePeriods')) {
        await into(servicePeriods).insert(ServicePeriodsCompanion.insert(
          id: Value(s['id'] as int),
          personnelId: s['personnelId'] as int,
          startDate: _dt(s['startDate'])!,
          endDate: Value(_dt(s['endDate'])),
          coefficient: Value((s['coefficient'] as num?)?.toDouble() ?? 1.5),
          note: Value(s['note'] as String? ?? ''),
        ));
      }
      // Справочник окладов заменяем только если файл его содержит — иначе
      // старые файлы (без окладов) не должны стирать заполненный справочник.
      final rateRows = rows('payRates');
      if (rateRows.isNotEmpty) {
        await delete(payRates).go();
        for (final r in rateRows) {
          await into(payRates).insert(PayRatesCompanion.insert(
            id: Value(r['id'] as int),
            kind: PayRateKind.values[r['kind'] as int],
            code: r['code'] as String,
            amount: Value(r['amount'] as int? ?? 0),
          ));
        }
      }
    });
  }

  static QueryExecutor _open() => driftDatabase(
        name: 'narmb_ls',
        // Ассеты для веба лежат в web/ (см. drift_worker.js и sqlite3.wasm).
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      );

  /// Первичное заполнение штатом (53 должности + занимающие их бойцы).
  Future<void> _seed() async {
    for (final s in kRoster) {
      final posId = await into(positions).insert(
        PositionsCompanion.insert(
          slot: s.slot,
          title: s.title,
          subunit: Value(s.subunit),
          category: s.category,
          crew: Value(s.crew),
        ),
      );
      if (!s.isVacant) {
        await into(personnel).insert(
          PersonnelCompanion.insert(
            lastName: s.last!,
            firstName: Value(s.fi ?? ''),
            middleName: Value(s.mi ?? ''),
            rank: Value(s.rank),
            positionId: Value(posId),
          ),
        );
      }
    }
  }

  /// Предзаполнение справочника окладов (на 01.10.2025, справочно).
  Future<void> _seedPayRates() async {
    await batch((b) {
      for (final e in kTariffSalary2025.entries) {
        b.insert(payRates, PayRatesCompanion.insert(
          kind: PayRateKind.tariff, code: '${e.key}', amount: Value(e.value)));
      }
      for (final e in kRankSalary2025.entries) {
        b.insert(payRates, PayRatesCompanion.insert(
          kind: PayRateKind.rank, code: e.key, amount: Value(e.value)));
      }
    });
  }

  // ══════════════════════════ СПРАВОЧНИК ОКЛАДОВ ═════════════════════════
  Stream<List<PayRateRow>> watchPayRates() =>
      (select(payRates)..orderBy([(t) => OrderingTerm.asc(t.kind)])).watch();

  Future<List<PayRateRow>> allPayRates() => select(payRates).get();

  Future<void> upsertPayRate(PayRateKind kind, String code, int amount) async {
    final existing = await (select(payRates)
          ..where((t) => t.kind.equalsValue(kind) & t.code.equals(code)))
        .getSingleOrNull();
    if (existing == null) {
      await into(payRates).insert(
          PayRatesCompanion.insert(kind: kind, code: code, amount: Value(amount)));
    } else {
      await (update(payRates)..where((t) => t.id.equals(existing.id)))
          .write(PayRatesCompanion(amount: Value(amount)));
    }
  }

  Future<void> deletePayRate(int id) =>
      (delete(payRates)..where((t) => t.id.equals(id))).go();

  /// Восстановить удалённую строку справочника окладов (для Undo после свайпа).
  Future<void> restorePayRate(PayRateRow row) =>
      into(payRates).insert(row.toCompanion(true), mode: InsertMode.insertOrReplace);

  /// Полностью очистить справочник окладов (пользователь введёт свои).
  Future<void> clearPayRates() => delete(payRates).go();

  /// Обнулить у ВСЕХ бойцов данные для расчёта ДД, чтобы командир заполнил сам:
  /// надбавки, премия, районный коэффициент, классность (квалификация) и
  /// тарифные разряды должностей. Звание НЕ трогаем (это основные данные).
  Future<void> clearAllPayData() async {
    await transaction(() async {
      await update(personnel).write(const PersonnelCompanion(
        allowanceSpecial: Value(0),
        allowanceSecrecy: Value(0),
        allowanceRisk: Value(0),
        allowanceFizo: Value(0),
        allowanceAchieve: Value(0),
        premiumPercent: Value(0),
        regionalCoef: Value(1.0),
        qualification: Value(null),
      ));
      await update(positions).write(const PositionsCompanion(tariffRank: Value(null)));
    });
  }

  // ══════════════════════════════ ШТАТ / СОСТАВ ══════════════════════════
  /// Все 53 должности с занимающими их бойцами (вакансии — с person == null).
  Stream<List<SoldierView>> watchRoster() {
    final query = select(positions).join([
      leftOuterJoin(
        personnel,
        personnel.positionId.equalsExp(positions.id) &
            personnel.isArchived.equals(false),
      ),
    ])
      ..orderBy([OrderingTerm.asc(positions.slot)]);
    return query.watch().map(
          (rows) => rows
              .map((r) => SoldierView(
                    position: r.readTable(positions),
                    person: r.readTableOrNull(personnel),
                  ))
              .toList(),
        );
  }

  /// Разовое чтение штата (для экспорта/отчётов).
  Future<List<SoldierView>> getRoster() => watchRoster().first;

  Future<SoldierView?> soldierBySlot(int slot) async {
    final all = await getRoster();
    for (final s in all) {
      if (s.position.slot == slot) return s;
    }
    return null;
  }

  Future<SoldierView?> soldierByPersonId(int personId) async {
    final all = await getRoster();
    for (final s in all) {
      if (s.person?.id == personId) return s;
    }
    return null;
  }

  /// Свободные (вакантные) должности — для перевода/назначения.
  Future<List<PositionRow>> vacantPositions() async {
    final all = await getRoster();
    return all.where((s) => s.isVacant).map((s) => s.position).toList();
  }

  // ══════════════════════════════ БОЙЦЫ (CRUD) ═══════════════════════════
  Future<PersonRow?> personById(int id) =>
      (select(personnel)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertPerson(PersonnelCompanion data) =>
      into(personnel).insert(data);

  Future<void> updatePerson(int id, PersonnelCompanion data) =>
      (update(personnel)..where((t) => t.id.equals(id)))
          .write(data.copyWith(updatedAt: Value(DateTime.now())));

  Future<void> setStatus(int personId, PersonnelStatus status) =>
      updatePerson(personId, PersonnelCompanion(status: Value(status)));

  /// Быстрая смена статуса из вкладки «Командировки»: завершает активные
  /// (уже начавшиеся, не завершённые) командировки бойца и ставит новый статус.
  Future<void> returnFromTrip(int personId, PersonnelStatus status, DateTime day) async {
    await transaction(() async {
      await (update(trips)
            ..where((t) =>
                t.personnelId.equals(personId) &
                t.status.equals(TripStatus.completed.index).not() &
                (t.startDate.isNull() | t.startDate.isSmallerOrEqualValue(day))))
          .write(TripsCompanion(
              status: Value(TripStatus.completed), actualReturnDate: Value(day)));
      await setStatus(personId, status);
    });
  }

  /// Быстрая смена статуса из вкладки «Отпуска»: завершает активные отпуска
  /// бойца и ставит новый статус.
  Future<void> returnFromLeave(int personId, PersonnelStatus status, DateTime day) async {
    await transaction(() async {
      await (update(leaves)
            ..where((t) =>
                t.personnelId.equals(personId) &
                t.status.equals(LeaveStatus.completed.index).not() &
                t.status.equals(LeaveStatus.cancelled.index).not() &
                (t.startDate.isNull() | t.startDate.isSmallerOrEqualValue(day))))
          .write(LeavesCompanion(
              status: Value(LeaveStatus.completed), actualReturnDate: Value(day)));
      await setStatus(personId, status);
    });
  }

  /// Массовая установка статусов: id → статус. Используется и для применения
  /// (все в один статус), и для отмены (каждому — прежний статус).
  Future<void> setStatusMap(Map<int, PersonnelStatus> byId) async {
    await transaction(() async {
      final now = DateTime.now();
      for (final e in byId.entries) {
        await (update(personnel)..where((t) => t.id.equals(e.key)))
            .write(PersonnelCompanion(status: Value(e.value), updatedAt: Value(now)));
      }
    });
  }

  /// Перевод бойца на другую должность. Если она уже занята активным
  /// бойцом — перевод не выполняется (инвариант «один на должность»).
  Future<void> transferPerson(int personId, int newPositionId) async {
    final occupied = await (select(personnel)
          ..where((t) =>
              t.positionId.equals(newPositionId) &
              t.isArchived.equals(false) &
              t.id.equals(personId).not()))
        .getSingleOrNull();
    if (occupied != null) return;
    await updatePerson(
        personId, PersonnelCompanion(positionId: Value(newPositionId)));
  }

  /// Исключение бойца: уходит в архив, должность освобождается.
  Future<void> excludePerson(int personId) => updatePerson(
        personId,
        const PersonnelCompanion(
          isArchived: Value(true),
          positionId: Value(null),
        ),
      );

  /// Восстановление из архива на вакантную должность.
  Future<void> restorePerson(int personId, int positionId) => updatePerson(
        personId,
        PersonnelCompanion(
          isArchived: const Value(false),
          positionId: Value(positionId),
        ),
      );

  /// Полное удаление записи бойца (из архива).
  Future<void> deletePersonForever(int personId) =>
      (delete(personnel)..where((t) => t.id.equals(personId))).go();

  /// Архив исключённых бойцов.
  Stream<List<PersonRow>> watchArchived() =>
      (select(personnel)..where((t) => t.isArchived.equals(true))).watch();

  // ══════════════════════════════ НАГРАДЫ ════════════════════════════════
  Stream<List<AwardRow>> watchAwards(int personId) =>
      (select(awards)..where((t) => t.personnelId.equals(personId))).watch();

  Future<int> addAward(AwardsCompanion data) => into(awards).insert(data);

  Future<void> deleteAward(int id) =>
      (delete(awards)..where((t) => t.id.equals(id))).go();

  Future<List<AwardRow>> allAwards() => select(awards).get();

  // ══════════════════════════════ ОТПУСКА ════════════════════════════════
  Stream<List<LeaveRow>> watchLeaves(int personId) =>
      (select(leaves)..where((t) => t.personnelId.equals(personId))).watch();

  Stream<List<LeaveRow>> watchAllLeaves() =>
      (select(leaves)..orderBy([(t) => OrderingTerm.desc(t.startDate)])).watch();

  Future<List<LeaveRow>> personLeaves(int personId) =>
      (select(leaves)..where((t) => t.personnelId.equals(personId))).get();

  Future<int> addLeave(LeavesCompanion data) => into(leaves).insert(data);

  Future<void> updateLeave(int id, LeavesCompanion data) =>
      (update(leaves)..where((t) => t.id.equals(id))).write(data);

  Future<void> deleteLeave(int id) =>
      (delete(leaves)..where((t) => t.id.equals(id))).go();

  /// Восстановить удалённый отпуск целиком (для Undo после свайпа).
  Future<void> restoreLeave(LeaveRow row) =>
      into(leaves).insert(row.toCompanion(true), mode: InsertMode.insertOrReplace);

  // ══════════════════════════════ КОМАНДИРОВКИ ═══════════════════════════
  Stream<List<TripRow>> watchAllTrips() =>
      (select(trips)..orderBy([(t) => OrderingTerm.desc(t.startDate)])).watch();

  Stream<List<TripRow>> watchTrips(int personId) =>
      (select(trips)..where((t) => t.personnelId.equals(personId))).watch();

  Future<int> addTrip(TripsCompanion data) => into(trips).insert(data);

  Future<void> updateTrip(int id, TripsCompanion data) =>
      (update(trips)..where((t) => t.id.equals(id))).write(data);

  Future<void> deleteTrip(int id) =>
      (delete(trips)..where((t) => t.id.equals(id))).go();

  /// Восстановить удалённую командировку целиком (для Undo после свайпа).
  Future<void> restoreTrip(TripRow row) =>
      into(trips).insert(row.toCompanion(true), mode: InsertMode.insertOrReplace);

  // ══════════════════════════════ ВООРУЖЕНИЕ ═════════════════════════════
  Stream<List<WeaponRow>> watchAllWeapons() => select(weapons).watch();

  Stream<List<WeaponRow>> watchWeapons(int personId) =>
      (select(weapons)..where((t) => t.personnelId.equals(personId))).watch();

  Future<List<WeaponRow>> allWeapons() => select(weapons).get();

  Future<int> addWeapon(WeaponsCompanion data) => into(weapons).insert(data);

  Future<void> updateWeapon(int id, WeaponsCompanion data) =>
      (update(weapons)..where((t) => t.id.equals(id))).write(data);

  Future<void> deleteWeapon(int id) =>
      (delete(weapons)..where((t) => t.id.equals(id))).go();

  // ═══════════════════════ ЛЬГОТНЫЕ ПЕРИОДЫ (ВЫСЛУГА) ════════════════════
  Stream<List<ServicePeriodRow>> watchServicePeriods(int personId) =>
      (select(servicePeriods)
            ..where((t) => t.personnelId.equals(personId))
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .watch();

  /// Все льготные периоды (для показа выслуги в списке «Состав»).
  Stream<List<ServicePeriodRow>> watchAllServicePeriods() =>
      select(servicePeriods).watch();

  Future<int> addServicePeriod(ServicePeriodsCompanion data) =>
      into(servicePeriods).insert(data);

  Future<void> updateServicePeriod(int id, ServicePeriodsCompanion data) =>
      (update(servicePeriods)..where((t) => t.id.equals(id))).write(data);

  Future<void> deleteServicePeriod(int id) =>
      (delete(servicePeriods)..where((t) => t.id.equals(id))).go();
}
