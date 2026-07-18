import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:narmb_ls/data/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

/// Регресс на баг миграции: пересоздание таблиц (TableMigration) конфликтовало
/// с последующим addColumn той же колонки → «duplicate column» / «no such
/// column» → БД не открывалась при обновлении. Проверяем реальные пути.

// v8-схема trips: даты уже nullable, но serviceCoef ещё НЕТ.
const _v8Trips = '''
CREATE TABLE trips (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  personnel_id INTEGER NOT NULL,
  destination TEXT NOT NULL,
  purpose TEXT NOT NULL DEFAULT '',
  status INTEGER NOT NULL DEFAULT 0,
  start_date INTEGER, end_date INTEGER, actual_return_date INTEGER,
  order_number TEXT, note TEXT
);''';

// v7-схема trips: даты NOT NULL, serviceCoef нет (до v8-пересоздания).
const _v7Trips = '''
CREATE TABLE trips (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  personnel_id INTEGER NOT NULL,
  destination TEXT NOT NULL,
  purpose TEXT NOT NULL DEFAULT '',
  status INTEGER NOT NULL DEFAULT 0,
  start_date INTEGER NOT NULL, end_date INTEGER NOT NULL,
  actual_return_date INTEGER, order_number TEXT, note TEXT
);''';

const _v7Leaves = '''
CREATE TABLE leaves (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  personnel_id INTEGER NOT NULL,
  type INTEGER NOT NULL, status INTEGER NOT NULL DEFAULT 0,
  days_granted INTEGER NOT NULL,
  includes_travel INTEGER NOT NULL DEFAULT 0, travel_days INTEGER NOT NULL DEFAULT 0,
  start_date INTEGER NOT NULL, end_date INTEGER NOT NULL,
  actual_return_date INTEGER, order_number TEXT, destination TEXT, note TEXT
);''';

void main() {
  test('миграция v8→v9: trips получает serviceCoef, строка цела', () async {
    final raw = sqlite3.openInMemory();
    raw.execute(_v8Trips);
    raw.execute("INSERT INTO trips (personnel_id, destination) VALUES (1, 'Москва');");
    raw.execute('PRAGMA user_version = 8;');

    final db = AppDatabase.forTesting(NativeDatabase.opened(raw));
    // Первый запрос запускает миграцию 8→9 (не должна упасть).
    final rows = await db.customSelect('SELECT service_coef FROM trips').get();
    expect(rows.length, 1);
    expect(rows.first.read<double>('service_coef'), 1.0);
    await db.close();
  });

  test('миграция v7→v9: пересоздание trips/leaves + serviceCoef, без падения', () async {
    final raw = sqlite3.openInMemory();
    raw.execute(_v7Trips);
    raw.execute(_v7Leaves);
    raw.execute('PRAGMA user_version = 7;');

    final db = AppDatabase.forTesting(NativeDatabase.opened(raw));
    // Миграция v7→v9: TableMigration(trips, newColumns:[serviceCoef]) +
    // TableMigration(leaves); addColumn serviceCoef НЕ дублируется.
    // Колонка появилась и НЕ задублирована; запрос запускает миграцию.
    await db.customSelect('SELECT service_coef FROM trips').get();
    // Проверяем итоговую схему trips: serviceCoef с дефолтом 1.0, даты nullable.
    final cols = await db.customSelect("PRAGMA table_info('trips')").get();
    final byName = {for (final c in cols) c.read<String>('name'): c};
    expect(byName.containsKey('service_coef'), isTrue);
    expect(byName['start_date']!.read<int>('notnull'), 0); // nullable
    await db.close();
  });

  test('чистая установка (onCreate) даёт актуальную схему v9', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.into(db.trips).insert(
        TripsCompanion.insert(personnelId: 1, destination: 'Y', serviceCoef: const Value(3.0)));
    final t = await db.select(db.trips).getSingle();
    expect(t.serviceCoef, 3.0);
    await db.close();
  });
}
