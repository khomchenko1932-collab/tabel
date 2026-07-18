import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:narmb_ls/data/database/app_database.dart';
import 'package:narmb_ls/data/models/soldier_view.dart';
import 'package:narmb_ls/domain/entities/enums.dart';
import 'package:narmb_ls/domain/services/roster_service.dart';
import 'package:narmb_ls/presentation/expense/expense_screen.dart';
import 'package:narmb_ls/presentation/pay/pay_calculator_screen.dart';
import 'package:narmb_ls/presentation/pay/pay_quick_calc.dart';
import 'package:narmb_ls/presentation/pay/service_calc_screen.dart';
import 'package:narmb_ls/presentation/leaves/leaves_screen.dart';
import 'package:narmb_ls/presentation/onboarding/onboarding_screen.dart';
import 'package:narmb_ls/presentation/personnel/personnel_list_screen.dart';
import 'package:narmb_ls/presentation/providers/app_providers.dart';
import 'package:narmb_ls/presentation/security/lock_screen.dart';
import 'package:narmb_ls/presentation/settings/settings_controller.dart';
import 'package:narmb_ls/presentation/settings/settings_screen.dart';
import 'package:narmb_ls/presentation/trips/trips_screen.dart';
import 'package:narmb_ls/presentation/weapons/weapons_screen.dart';

PersonRow _person(int id, int slot, PersonnelStatus st) => PersonRow(
      id: id,
      positionId: slot,
      lastName: 'Боец$id',
      firstName: 'И',
      middleName: 'И',
      rank: 'рядовой',
      status: st,
      childrenCount: 0,
      isVeteran: false,
      allowanceSpecial: 0,
      allowanceSecrecy: 0,
      allowanceRisk: 0,
      allowanceFizo: 0,
      allowanceAchieve: 0,
      regionalCoef: 1.0,
      premiumPercent: 25,
      leaveLimitMain: 20,
      leaveLimitAdditional: 7,
      leaveLimitVeteran: 0,
      isArchived: false,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

PositionRow _pos(int slot, RankCategory cat, {String? crew}) => PositionRow(
      id: slot,
      slot: slot,
      title: 'Номер расчёта',
      subunit: '1-й огневой взвод',
      category: cat,
      crew: crew,
    );

List<EffectiveSoldier> _roster() => [
      EffectiveSoldier(
        SoldierView(position: _pos(1, RankCategory.officer), person: _person(1, 1, PersonnelStatus.here)),
        PersonnelStatus.here,
      ),
      EffectiveSoldier(
        SoldierView(position: _pos(2, RankCategory.sergeant), person: _person(2, 2, PersonnelStatus.leave)),
        PersonnelStatus.leave,
      ),
      EffectiveSoldier(
        SoldierView(position: _pos(3, RankCategory.soldier, crew: 'КМ-1'), person: _person(3, 3, PersonnelStatus.trip)),
        PersonnelStatus.trip,
      ),
      // вакансия
      EffectiveSoldier(SoldierView(position: _pos(4, RankCategory.soldier, crew: 'КМ-1')), null),
    ];

Widget _wrap(Widget home) => ProviderScope(
      overrides: [
        effectiveRosterProvider.overrideWithValue(AsyncData(_roster())),
        allLeavesProvider.overrideWith((ref) => Stream.value(<LeaveRow>[])),
        allTripsProvider.overrideWith((ref) => Stream.value(<TripRow>[])),
        allWeaponsProvider.overrideWith((ref) => Stream.value(<WeaponRow>[])),
        payRatesProvider.overrideWith((ref) => Stream.value(<PayRateRow>[
              PayRateRow(id: 1, kind: PayRateKind.rank, code: 'рядовой', amount: 7166),
            ])),
        servicePeriodsForProvider
            .overrideWith((ref, id) => Stream.value(<ServicePeriodRow>[])),
        allServicePeriodsProvider
            .overrideWith((ref) => Stream.value(<ServicePeriodRow>[])),
        settingsProvider.overrideWithValue(
          const AsyncData(AppSettings(
            onboardingDone: true,
            lockEnabled: false,
            pinHash: null,
            pinSalt: null,
            unitName: 'Тест',
          )),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ru')],
        home: home,
      ),
    );

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  Future<void> pumpOk(WidgetTester tester, Widget screen) async {
    await tester.pumpWidget(_wrap(screen));
    await tester.pump();
    expect(tester.takeException(), isNull);
    // Прокрутить анимации (flutter_animate) до конца, чтобы не осталось таймеров.
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
  }

  testWidgets('Расход рендерится', (t) => pumpOk(t, const ExpenseScreen()));
  testWidgets('Состав рендерится', (t) => pumpOk(t, const PersonnelListScreen()));
  testWidgets('Отпуска рендерится', (t) => pumpOk(t, const LeavesScreen()));
  testWidgets('Командировки рендерится', (t) => pumpOk(t, const TripsScreen()));
  testWidgets('Вооружение рендерится', (t) => pumpOk(t, const WeaponsScreen()));
  testWidgets('Онбординг рендерится', (t) => pumpOk(t, const OnboardingScreen()));
  testWidgets('Блокировка рендерится', (t) => pumpOk(t, const LockScreen()));
  testWidgets('Настройки рендерится', (t) => pumpOk(t, const SettingsScreen()));
  testWidgets('Калькулятор ДД рендерится', (t) => pumpOk(t, const PayCalculatorScreen()));
  testWidgets('Быстрый расчёт рендерится', (t) => pumpOk(t, const Scaffold(body: PayQuickCalc())));
  testWidgets('Калькулятор выслуги рендерится', (t) => pumpOk(t, const ServiceCalcScreen()));
}
