import 'package:drift/drift.dart';

import '../../core/data/award_catalog.dart';
import '../../domain/entities/enums.dart';

/// Простое key-value хранилище настроек (безопасность, онбординг, экспорт).
@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Штатная должность батареи (фиксированные 53 слота, сгруппированы по взводам).
@DataClassName('PositionRow')
class Positions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Порядковый номер по штату.
  IntColumn get slot => integer()();
  TextColumn get title => text()();

  /// Подразделение/взвод — свободный текст (любая структура части).
  TextColumn get subunit => text().withDefault(const Constant('Подразделение'))();
  IntColumn get category => intEnum<RankCategory>()();

  /// Расчёт/машина внутри огневого взвода (напр. «КМ-1»), может быть пустым.
  TextColumn get crew => text().nullable()();

  /// Тарифный разряд должности (1–50) для расчёта оклада по должности (ОВД).
  IntColumn get tariffRank => integer().nullable()();
}

/// Боец. Занимает должность ([positionId]); исключённые попадают в архив
/// ([isArchived] = true, [positionId] = null), должность становится вакантной.
@DataClassName('PersonRow')
class Personnel extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get positionId =>
      integer().nullable().references(Positions, #id)();

  TextColumn get lastName => text()();
  TextColumn get firstName => text().withDefault(const Constant(''))();
  TextColumn get middleName => text().withDefault(const Constant(''))();
  TextColumn get rank => text().withDefault(const Constant(''))();
  IntColumn get status =>
      intEnum<PersonnelStatus>().withDefault(const Constant(0))();

  // ── Развёрнутые данные профиля ──
  TextColumn get personalNumber => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  IntColumn get maritalStatus => intEnum<MaritalStatus>().nullable()();
  IntColumn get childrenCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get birthDate => dateTime().nullable()();
  DateTimeColumn get contractStart => dateTime().nullable()();
  DateTimeColumn get contractEnd => dateTime().nullable()();
  TextColumn get qualification => text().nullable()();
  DateTimeColumn get qualificationDate => dateTime().nullable()();

  /// Дата начала военной службы — якорь для расчёта выслуги лет
  /// (не путать с [contractStart]: срочная/училище тоже входят).
  DateTimeColumn get serviceStart => dateTime().nullable()();

  BoolColumn get isVeteran => boolean().withDefault(const Constant(false))();

  // ── Надбавки для расчёта денежного довольствия (проценты/коэффициенты) ──
  /// Надбавка за особые условия военной службы, % от оклада по должности.
  IntColumn get allowanceSpecial => integer().withDefault(const Constant(0))();

  /// Надбавка за работу со сведениями, составляющими гостайну, % от ОВД.
  IntColumn get allowanceSecrecy => integer().withDefault(const Constant(0))();

  /// Надбавка за выполнение задач с риском для жизни, % от ОВД.
  IntColumn get allowanceRisk => integer().withDefault(const Constant(0))();

  /// Надбавка за физическую подготовленность, % от ОВД.
  IntColumn get allowanceFizo => integer().withDefault(const Constant(0))();

  /// Надбавка за особые достижения в службе, % от ОВД.
  IntColumn get allowanceAchieve => integer().withDefault(const Constant(0))();

  /// Районный коэффициент (1.0 — нет; 1.15, 1.5, 2.0 и т.п.).
  RealColumn get regionalCoef => real().withDefault(const Constant(1.0))();

  /// Ежемесячная премия, % от оклада месячного содержания (ОМДС).
  /// По умолчанию 0 — командир задаёт сам.
  IntColumn get premiumPercent => integer().withDefault(const Constant(0))();

  // ── Лимиты отпусков (редактируются вручную) ──
  IntColumn get leaveLimitMain => integer().withDefault(const Constant(40))();
  IntColumn get leaveLimitAdditional =>
      integer().withDefault(const Constant(7))();
  IntColumn get leaveLimitVeteran =>
      integer().withDefault(const Constant(0))();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Награда бойца.
@DataClassName('AwardRow')
class Awards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personnelId =>
      integer().references(Personnel, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get kind => intEnum<AwardKind>()();
  TextColumn get degree => text().nullable()();
  DateTimeColumn get awardDate => dateTime().nullable()();
  TextColumn get note => text().nullable()();
}

/// Отпуск.
@DataClassName('LeaveRow')
class Leaves extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personnelId =>
      integer().references(Personnel, #id, onDelete: KeyAction.cascade)();
  IntColumn get type => intEnum<LeaveType>()();
  IntColumn get status =>
      intEnum<LeaveStatus>().withDefault(const Constant(0))();
  IntColumn get daysGranted => integer()();
  BoolColumn get includesTravel => boolean().withDefault(const Constant(false))();
  IntColumn get travelDays => integer().withDefault(const Constant(0))();
  // Даты необязательны: можно знать только одну (напр. только дату выхода).
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get actualReturnDate => dateTime().nullable()();
  TextColumn get orderNumber => text().nullable()();
  TextColumn get destination => text().nullable()();
  TextColumn get note => text().nullable()();
}

/// Командировка.
@DataClassName('TripRow')
class Trips extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personnelId =>
      integer().references(Personnel, #id, onDelete: KeyAction.cascade)();
  TextColumn get destination => text()();
  TextColumn get purpose => text().withDefault(const Constant(''))();
  IntColumn get status =>
      intEnum<TripStatus>().withDefault(const Constant(0))();
  // Даты необязательны: можно знать только дату прибытия, или ни одной.
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get actualReturnDate => dateTime().nullable()();
  TextColumn get orderNumber => text().nullable()();
  TextColumn get note => text().nullable()();

  /// Коэффициент льготного исчисления выслуги (1.0 — обычная; 1.5/2/3 —
  /// боевые/особые). Командировки с коэф. > 1 идут в льготную выслугу.
  RealColumn get serviceCoef => real().withDefault(const Constant(1.0))();
}

/// Льготный период службы: время, засчитываемое в выслугу с коэффициентом
/// ([coefficient] = 1.5 / 2 / 3, «день за полтора/два/три»). Добавляет к
/// льготной выслуге сверх календарной `(coefficient - 1) × дни`. Обычная
/// служба (коэф. 1) отдельно не заводится — она уже в календарной.
@DataClassName('ServicePeriodRow')
class ServicePeriods extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personnelId =>
      integer().references(Personnel, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startDate => dateTime()();

  /// Конец периода; null — по настоящее время.
  DateTimeColumn get endDate => dateTime().nullable()();

  /// Коэффициент льготного исчисления (1.5, 2.0, 3.0).
  RealColumn get coefficient => real().withDefault(const Constant(1.5))();
  TextColumn get note => text().withDefault(const Constant(''))();
}

/// Справочник окладов (₽): по тарифным разрядам должностей ([kind]=0, [code]
/// = номер разряда «1»…«50») и по воинским званиям ([kind]=1, [code] = звание
/// в нижнем регистре). Редактируется командиром, обновляется при индексации.
@DataClassName('PayRateRow')
class PayRates extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 0 — тарифный разряд (должность), 1 — воинское звание.
  IntColumn get kind => intEnum<PayRateKind>()();

  /// Ключ: номер разряда или нормализованное звание.
  TextColumn get code => text()();

  /// Оклад в рублях (целые рубли).
  IntColumn get amount => integer().withDefault(const Constant(0))();
}

/// Вооружение / приборы / техника, закреплённые за бойцом.
@DataClassName('WeaponRow')
class Weapons extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personnelId =>
      integer().references(Personnel, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get type => intEnum<WeaponType>()();
  TextColumn get serialNumber => text().nullable()();
  TextColumn get inventoryNumber => text().nullable()();
  DateTimeColumn get assignedDate => dateTime().nullable()();
  TextColumn get note => text().nullable()();
}
