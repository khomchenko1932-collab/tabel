import 'package:flutter_test/flutter_test.dart';
import 'package:narmb_ls/data/database/app_database.dart';
import 'package:narmb_ls/domain/entities/enums.dart';
import 'package:narmb_ls/domain/services/leave_service.dart';

void main() {
  PersonRow person() => PersonRow(
        id: 1,
        lastName: 'Тест',
        firstName: '',
        middleName: '',
        rank: '',
        status: PersonnelStatus.here,
        childrenCount: 0,
        isVeteran: false,
        allowanceSpecial: 0,
        allowanceSecrecy: 0,
        allowanceRisk: 0,
        allowanceFizo: 0,
        allowanceAchieve: 0,
        regionalCoef: 1.0,
        premiumPercent: 0,
        leaveLimitMain: 40,
        leaveLimitAdditional: 7,
        leaveLimitVeteran: 0,
        isArchived: false,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

  LeaveRow leave(int id, DateTime? start, int days,
          {LeaveType type = LeaveType.main}) =>
      LeaveRow(
        id: id,
        personnelId: 1,
        type: type,
        status: LeaveStatus.completed,
        daysGranted: days,
        includesTravel: false,
        travelDays: 0,
        startDate: start,
        endDate: start?.add(Duration(days: days - 1)),
      );

  group('LeaveBalance — годовой сброс', () {
    final now = DateTime(2026, 7, 15);

    test('прошлогодний отпуск не съедает лимит текущего года', () {
      final b = LeaveBalance.of(
        person(),
        [leave(1, DateTime(2025, 6, 1), 40)], // весь лимит — но в 2025-м
        now: now,
      );
      expect(b.usedMain, 0);
      expect(b.remaining, 47);
      expect(b.exhausted, isFalse);
    });

    test('отпуск текущего года списывается', () {
      final b = LeaveBalance.of(
        person(),
        [
          leave(1, DateTime(2025, 6, 1), 40), // прошлый год — не считается
          leave(2, DateTime(2026, 3, 1), 15), // этот год — считается
        ],
        now: now,
      );
      expect(b.usedMain, 15);
      expect(b.remaining, 32);
    });

    test('отпуск без даты начала относится к текущему году', () {
      final b = LeaveBalance.of(person(), [leave(1, null, 10)], now: now);
      expect(b.usedMain, 10);
    });

    test('будущий отпуск этого года ещё не «отгулян»', () {
      final b = LeaveBalance.of(
          person(), [leave(1, DateTime(2026, 12, 1), 10)], now: now);
      expect(b.usedMain, 0);
    });

    test('явный year смотрит в прошлый год', () {
      final b = LeaveBalance.of(
        person(),
        [leave(1, DateTime(2025, 6, 1), 40)],
        now: now,
        year: 2025,
      );
      expect(b.usedMain, 40);
      expect(b.exhausted, isFalse); // остаток 7 доп. дней
    });
  });
}
