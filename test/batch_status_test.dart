import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:narmb_ls/data/database/app_database.dart';
import 'package:narmb_ls/domain/entities/enums.dart';

/// Проверка массовой смены статуса и отмены (setStatusMap).
void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() async => db.close());

  Future<int> addPerson(String name, PersonnelStatus st) async {
    final pos = await db.insertPosition(PositionsCompanion.insert(
        slot: DateTime.now().microsecond, title: name, category: RankCategory.soldier));
    return db.insertPerson(PersonnelCompanion.insert(
        lastName: name, status: Value(st), positionId: Value(pos)));
  }

  test('массовая смена статуса + откат прежних', () async {
    await db.wipeAll();
    final a = await addPerson('А', PersonnelStatus.here);
    final b = await addPerson('Б', PersonnelStatus.sick);

    // Применяем всем «командировка», запомнив прежние.
    final prev = {a: PersonnelStatus.here, b: PersonnelStatus.sick};
    await db.setStatusMap({a: PersonnelStatus.trip, b: PersonnelStatus.trip});

    expect((await db.personById(a))!.status, PersonnelStatus.trip);
    expect((await db.personById(b))!.status, PersonnelStatus.trip);

    // Отмена — возвращаем прежние.
    await db.setStatusMap(prev);
    expect((await db.personById(a))!.status, PersonnelStatus.here);
    expect((await db.personById(b))!.status, PersonnelStatus.sick);
  });
}
