import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/models/soldier_view.dart';
import '../../domain/services/leave_service.dart';
import '../../domain/services/pay_service.dart';
import '../../domain/services/roster_service.dart';
import '../../domain/services/service_service.dart';

/// Единственный экземпляр БД на всё приложение.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// «Сегодня» — вынесено в провайдер, чтобы упростить тестирование.
final todayProvider = Provider<DateTime>((ref) => DateTime.now());

/// Весь штат (53 должности с занимающими бойцами).
final rosterProvider = StreamProvider<List<SoldierView>>(
  (ref) => ref.watch(appDatabaseProvider).watchRoster(),
);

/// Вакантные должности — для перевода/назначения.
final vacantPositionsProvider = Provider<List<PositionRow>>((ref) {
  final roster = ref.watch(rosterProvider).value ?? const [];
  return roster.where((s) => s.isVacant).map((s) => s.position).toList();
});

final allLeavesProvider = StreamProvider<List<LeaveRow>>(
  (ref) => ref.watch(appDatabaseProvider).watchAllLeaves(),
);

final allTripsProvider = StreamProvider<List<TripRow>>(
  (ref) => ref.watch(appDatabaseProvider).watchAllTrips(),
);

final allWeaponsProvider = StreamProvider<List<WeaponRow>>(
  (ref) => ref.watch(appDatabaseProvider).watchAllWeapons(),
);

final archivedProvider = StreamProvider<List<PersonRow>>(
  (ref) => ref.watch(appDatabaseProvider).watchArchived(),
);

/// Штат с вычисленным эффективным статусом (учёт активных командировок/отпусков).
final effectiveRosterProvider =
    Provider<AsyncValue<List<EffectiveSoldier>>>((ref) {
  final roster = ref.watch(rosterProvider);
  final trips = ref.watch(allTripsProvider);
  final leaves = ref.watch(allLeavesProvider);
  final day = ref.watch(todayProvider);

  return roster.whenData(
    (r) => RosterService.resolve(
      roster: r,
      trips: trips.value ?? const [],
      leaves: leaves.value ?? const [],
      day: day,
    ),
  );
});

/// Сводка «Расход ЛС».
final rosterStatsProvider = Provider<AsyncValue<RosterStats>>(
  (ref) => ref.watch(effectiveRosterProvider).whenData(RosterStats.from),
);

/// Один боец по id (реактивно, из общего штата).
final soldierByPersonProvider =
    Provider.family<EffectiveSoldier?, int>((ref, personId) {
  final list = ref.watch(effectiveRosterProvider).value ?? const [];
  for (final es in list) {
    if (es.view.person?.id == personId) return es;
  }
  return null;
});

// ── Данные профиля (family по id бойца) ──────────────────────────────────
final awardsProvider = StreamProvider.family<List<AwardRow>, int>(
  (ref, personId) => ref.watch(appDatabaseProvider).watchAwards(personId),
);

final leavesForProvider = StreamProvider.family<List<LeaveRow>, int>(
  (ref, personId) => ref.watch(appDatabaseProvider).watchLeaves(personId),
);

final tripsForProvider = StreamProvider.family<List<TripRow>, int>(
  (ref, personId) => ref.watch(appDatabaseProvider).watchTrips(personId),
);

final weaponsForProvider = StreamProvider.family<List<WeaponRow>, int>(
  (ref, personId) => ref.watch(appDatabaseProvider).watchWeapons(personId),
);

/// Баланс отпусков бойца.
final leaveBalanceProvider =
    Provider.family<LeaveBalance?, int>((ref, personId) {
  final person = ref.watch(soldierByPersonProvider(personId))?.view.person;
  if (person == null) return null;
  final leaves = ref.watch(leavesForProvider(personId)).value ?? const [];
  return LeaveBalance.of(person, leaves);
});

/// Льготные периоды выслуги бойца.
final servicePeriodsForProvider =
    StreamProvider.family<List<ServicePeriodRow>, int>(
  (ref, personId) =>
      ref.watch(appDatabaseProvider).watchServicePeriods(personId),
);

/// Все льготные периоды, сгруппированные по бойцу (для списка «Состав»).
final servicePeriodsByPersonProvider =
    Provider<Map<int, List<ServicePeriodRow>>>((ref) {
  final all = ref.watch(allServicePeriodsProvider).value ?? const [];
  final map = <int, List<ServicePeriodRow>>{};
  for (final p in all) {
    (map[p.personnelId] ??= []).add(p);
  }
  return map;
});

final allServicePeriodsProvider = StreamProvider<List<ServicePeriodRow>>(
  (ref) => ref.watch(appDatabaseProvider).watchAllServicePeriods(),
);

/// Все командировки, сгруппированные по бойцу (для выслуги в «Составе»:
/// боевые командировки с коэффициентом дают льготную выслугу).
final tripsByPersonProvider = Provider<Map<int, List<TripRow>>>((ref) {
  final all = ref.watch(allTripsProvider).value ?? const [];
  final map = <int, List<TripRow>>{};
  for (final t in all) {
    (map[t.personnelId] ??= []).add(t);
  }
  return map;
});

/// Выслуга лет бойца (null — если дата начала службы не задана).
final lengthOfServiceProvider =
    Provider.family<LengthOfService?, int>((ref, personId) {
  final person = ref.watch(soldierByPersonProvider(personId))?.view.person;
  if (person == null) return null;
  final periods = ref.watch(servicePeriodsForProvider(personId)).value ?? const [];
  final trips = ref.watch(tripsForProvider(personId)).value ?? const [];
  final day = ref.watch(todayProvider);
  return LengthOfService.of(person, periods, trips: trips, now: day);
});

// ── Денежное довольствие ─────────────────────────────────────────────────
/// Справочник окладов (тарифные разряды + звания).
final payRatesProvider = StreamProvider<List<PayRateRow>>(
  (ref) => ref.watch(appDatabaseProvider).watchPayRates(),
);

/// Справочник окладов в виде готовой к расчёту таблицы.
final payScaleProvider = Provider<PayScale>((ref) {
  final rows = ref.watch(payRatesProvider).value ?? const [];
  return PayScale.from(rows);
});

/// Расчёт ДД бойца (null — если нет данных бойца/должности).
final payBreakdownProvider =
    Provider.family<PayBreakdown?, int>((ref, personId) {
  final es = ref.watch(soldierByPersonProvider(personId));
  if (es == null || es.view.person == null) return null;
  final scale = ref.watch(payScaleProvider);
  final los = ref.watch(lengthOfServiceProvider(personId));
  return PayBreakdown.of(
    es.view.person!,
    es.view.position,
    scale,
    serviceAllowancePercent: los?.allowancePercent ?? 0,
  );
});
