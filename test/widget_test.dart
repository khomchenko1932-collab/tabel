import 'package:flutter_test/flutter_test.dart';
import 'package:narmb_ls/core/utils/formatters.dart';
import 'package:narmb_ls/data/database/app_database.dart';
import 'package:narmb_ls/domain/entities/enums.dart';
import 'package:narmb_ls/domain/services/roster_service.dart';

void main() {
  group('Fmt.days — русское склонение', () {
    test('1 день', () => expect(Fmt.days(1), '1 день'));
    test('3 дня', () => expect(Fmt.days(3), '3 дня'));
    test('5 дней', () => expect(Fmt.days(5), '5 дней'));
    test('11 дней', () => expect(Fmt.days(11), '11 дней'));
    test('21 день', () => expect(Fmt.days(21), '21 день'));
  });

  group('RosterService.effectiveStatus', () {
    PersonRow person(int id) => PersonRow(
          id: id,
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
          premiumPercent: 25,
          leaveLimitMain: 20,
      leaveLimitAdditional: 7,
          leaveLimitVeteran: 0,
          isArchived: false,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        );

    test('активная командировка перекрывает статус', () {
      final day = DateTime(2026, 6, 17);
      final trip = TripRow(
        id: 1,
        personnelId: 1,
        destination: 'Москва',
        purpose: '',
        serviceCoef: 1.0,
        status: TripStatus.active,
        startDate: DateTime(2026, 6, 10),
        endDate: DateTime(2026, 6, 20),
      );
      final s = RosterService.effectiveStatus(person(1), [trip], const [], day);
      expect(s, PersonnelStatus.trip);
    });

    test('командировка приоритетнее отпуска', () {
      final day = DateTime(2026, 6, 17);
      final trip = TripRow(
        id: 1,
        personnelId: 1,
        destination: 'Москва',
        purpose: '',
        serviceCoef: 1.0,
        status: TripStatus.active,
        startDate: DateTime(2026, 6, 10),
        endDate: DateTime(2026, 6, 20),
      );
      final leave = LeaveRow(
        id: 1,
        personnelId: 1,
        type: LeaveType.main,
        status: LeaveStatus.active,
        daysGranted: 20,
        includesTravel: false,
        travelDays: 0,
        startDate: DateTime(2026, 6, 15),
        endDate: DateTime(2026, 7, 5),
      );
      final s = RosterService.effectiveStatus(person(1), [trip], [leave], day);
      expect(s, PersonnelStatus.trip);
    });

    test('командировка без даты возврата — активна (открытая)', () {
      final day = DateTime(2026, 6, 17);
      final trip = TripRow(
        id: 1,
        personnelId: 1,
        destination: 'Москва',
        purpose: '',
        serviceCoef: 1.0,
        status: TripStatus.active,
        startDate: DateTime(2026, 6, 10),
        endDate: null, // возврат неизвестен
      );
      expect(RosterService.effectiveStatus(person(1), [trip], const [], day),
          PersonnelStatus.trip);
    });

    test('командировка без дат — активна (числится в командировке)', () {
      final day = DateTime(2026, 6, 17);
      final trip = TripRow(
        id: 1, personnelId: 1, destination: 'Москва', purpose: '', serviceCoef: 1.0,
        status: TripStatus.active, startDate: null, endDate: null,
      );
      expect(RosterService.effectiveStatus(person(1), [trip], const [], day),
          PersonnelStatus.trip);
    });

    test('после даты возврата — уже не в командировке', () {
      final day = DateTime(2026, 6, 25);
      final trip = TripRow(
        id: 1, personnelId: 1, destination: 'Москва', purpose: '', serviceCoef: 1.0,
        status: TripStatus.active,
        startDate: DateTime(2026, 6, 10), endDate: DateTime(2026, 6, 20),
      );
      expect(RosterService.effectiveStatus(person(1), [trip], const [], day),
          PersonnelStatus.here);
    });
  });
}
