import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:narmb_ls/data/database/app_database.dart';
import 'package:narmb_ls/data/models/soldier_view.dart';
import 'package:narmb_ls/domain/entities/enums.dart';
import 'package:narmb_ls/domain/services/roster_service.dart';
import 'package:narmb_ls/presentation/personnel/personnel_detail_screen.dart';
import 'package:narmb_ls/presentation/providers/app_providers.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  testWidgets('PersonnelDetailScreen рендерит данные и кнопку награды',
      (tester) async {
    final person = PersonRow(
      id: 1,
      positionId: 16,
      lastName: 'Иванов',
      firstName: 'Иван',
      middleName: 'Иванович',
      rank: 'капитан',
      status: PersonnelStatus.here,
      personalNumber: 'АА-000000',
      phone: '+7 900 000-00-00',
      address: 'г. Пример',
      maritalStatus: MaritalStatus.married,
      childrenCount: 2,
      contractStart: DateTime(2023, 8, 1),
      contractEnd: DateTime(2029, 7, 31),
      qualification: '1 класс',
      qualificationDate: DateTime(2024, 3, 15),
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
    const pos = PositionRow(
      id: 16,
      slot: 16,
      title: 'СОБ КВ-1',
      subunit: '1-й огневой взвод',
      category: RankCategory.officer,
    );
    final es = EffectiveSoldier(
      const SoldierView(position: pos).copyWith(person: person),
      PersonnelStatus.here,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          soldierByPersonProvider.overrideWith((ref, id) => es),
          awardsProvider.overrideWith((ref, id) => Stream.value(<AwardRow>[])),
          leavesForProvider.overrideWith((ref, id) => Stream.value(<LeaveRow>[])),
          tripsForProvider.overrideWith((ref, id) => Stream.value(<TripRow>[])),
          weaponsForProvider.overrideWith((ref, id) => Stream.value(<WeaponRow>[])),
          servicePeriodsForProvider
              .overrideWith((ref, id) => Stream.value(<ServicePeriodRow>[])),
        ],
        child: const MaterialApp(
          locale: Locale('ru'),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('ru')],
          home: PersonnelDetailScreen(personId: 1),
        ),
      ),
    );
    await tester.pump();

    // Личный номер — в верхней части, отрисован сразу.
    expect(find.text('АА-000000'), findsOneWidget);

    // Ниже по списку — прокручиваем ленивый ListView до нужных элементов.
    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
        find.textContaining('Пример'), 250, scrollable: scrollable);
    expect(find.textContaining('Пример'), findsOneWidget);

    await tester.scrollUntilVisible(
        find.text('ВЫБРАТЬ НАГРАДУ'), 250, scrollable: scrollable);
    expect(find.text('ВЫБРАТЬ НАГРАДУ'), findsOneWidget);
  });
}

/// Хелпер: SoldierView не имеет copyWith — добавим через расширение для теста.
extension on SoldierView {
  SoldierView copyWith({PersonRow? person}) =>
      SoldierView(position: position, person: person ?? this.person);
}
