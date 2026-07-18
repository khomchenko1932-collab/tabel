import '../../domain/entities/enums.dart';

/// Одна строка штатного расписания для первичного заполнения БД.
class SeedSlot {
  const SeedSlot(
    this.slot,
    this.title,
    this.subunit,
    this.category, {
    this.crew,
    this.last,
    this.fi,
    this.mi,
    this.rank = '',
  });

  final int slot;
  final String title;
  final String subunit;
  final RankCategory category; // штатная категория должности (для вакансии)
  final String? crew;
  final String rank;

  /// Фамилия и инициалы; если [last] == null — должность вакантна.
  final String? last;
  final String? fi;
  final String? mi;

  bool get isVacant => last == null;
}

/// ДЕМОНСТРАЦИОННЫЙ штат подразделения (53 должности) для первого запуска.
/// Фамилии условные (не реальные) — приложение офлайн, свои данные вводит
/// пользователь или переносит .tbl-файлом. Структура/звания — для примера.
///
/// SAFE-DEMO-SEED — метка публичной версии без реальных ПДн. НЕ УДАЛЯТЬ:
/// скрипт публикации проверяет её и не выложит на GitHub сид без этой метки
/// (защита от случайной публикации реального штата).
const List<SeedSlot> kRoster = [
  // ── Управление ──
  SeedSlot(1, 'Командир', 'Управление', RankCategory.officer,
      last: 'Иванов', fi: 'И.', mi: 'И.', rank: 'майор'),
  SeedSlot(2, 'Заместитель командира', 'Управление', RankCategory.officer,
      last: 'Петров', fi: 'П.', mi: 'С.', rank: 'капитан'),
  SeedSlot(3, 'Старшина', 'Управление', RankCategory.warrant,
      last: 'Сидоров', fi: 'А.', mi: 'В.', rank: 'ст. прапорщик'),
  SeedSlot(4, 'Ст. техник', 'Управление', RankCategory.warrant,
      last: 'Смирнов', fi: 'М.', mi: 'Н.', rank: 'ст. прапорщик'),
  SeedSlot(5, 'Санинструктор', 'Управление', RankCategory.sergeant,
      last: 'Кузнецов', fi: 'С.', mi: 'И.', rank: 'ст. сержант'),
  // ── Взвод управления ──
  SeedSlot(6, 'Командир взвода', 'Взвод управления', RankCategory.officer,
      last: 'Попов', fi: 'М.', mi: 'И.', rank: 'лейтенант'),
  SeedSlot(7, 'Ст. специалист', 'Взвод управления', RankCategory.warrant,
      last: 'Васильев', fi: 'А.', mi: 'А.', rank: 'ст. прапорщик'),
  SeedSlot(8, 'Специалист', 'Взвод управления', RankCategory.warrant,
      last: 'Соколов', fi: 'Е.', mi: 'О.', rank: 'прапорщик'),
  SeedSlot(9, 'Специалист', 'Взвод управления', RankCategory.warrant,
      last: 'Михайлов', fi: 'В.', mi: 'М.', rank: 'прапорщик'),
  SeedSlot(10, 'Командир отделения', 'Взвод управления', RankCategory.sergeant,
      last: 'Новиков', fi: 'Л.', mi: 'В.', rank: 'сержант'),
  SeedSlot(11, 'Ст. связист', 'Взвод управления', RankCategory.sergeant,
      last: 'Фёдоров', fi: 'И.', mi: 'В.', rank: 'мл. сержант'),
  SeedSlot(12, 'Связист', 'Взвод управления', RankCategory.soldier,
      last: 'Морозов', fi: 'Д.', mi: 'Н.', rank: 'ефрейтор'),
  SeedSlot(13, 'Связист', 'Взвод управления', RankCategory.soldier,
      last: 'Волков', fi: 'М.', mi: 'А.', rank: 'рядовой'),
  SeedSlot(14, 'Вычислитель', 'Взвод управления', RankCategory.soldier,
      last: 'Алексеев', fi: 'П.', mi: 'В.', rank: 'рядовой'),
  SeedSlot(15, 'Водитель', 'Взвод управления', RankCategory.soldier,
      last: 'Лебедев', fi: 'В.', mi: 'А.', rank: 'рядовой'),
  // ── 1-й взвод ──
  SeedSlot(16, 'Командир взвода', '1-й взвод', RankCategory.officer,
      last: 'Семёнов', fi: 'В.', mi: 'В.', rank: 'капитан'),
  SeedSlot(17, 'Зам. командира взвода', '1-й взвод', RankCategory.sergeant,
      last: 'Егоров', fi: 'Д.', mi: 'А.', rank: 'сержант'),
  SeedSlot(18, 'Ст. водитель', '1-й взвод', RankCategory.soldier,
      last: 'Павлов', fi: 'Ф.', mi: 'Н.', rank: 'ефрейтор'),
  SeedSlot(19, 'Наводчик', '1-й взвод', RankCategory.soldier,
      last: 'Козлов', fi: 'И.', mi: 'В.', rank: 'рядовой'),
  SeedSlot(20, 'Номер расчёта', '1-й взвод', RankCategory.soldier,
      last: 'Степанов', fi: 'И.', mi: 'М.', rank: 'рядовой'),
  SeedSlot(21, 'Номер расчёта', '1-й взвод', RankCategory.soldier),
  SeedSlot(22, 'Номер расчёта', '1-й взвод', RankCategory.soldier,
      last: 'Николаев', fi: 'А.', mi: 'В.', rank: 'рядовой'),
  SeedSlot(23, 'Командир расчёта', '1-й взвод', RankCategory.sergeant,
      last: 'Орлов', fi: 'Г.', mi: 'П.', rank: 'мл. сержант'),
  SeedSlot(24, 'Водитель', '1-й взвод', RankCategory.soldier,
      last: 'Андреев', fi: 'В.', mi: 'Н.', rank: 'рядовой'),
  SeedSlot(25, 'Наводчик', '1-й взвод', RankCategory.soldier,
      last: 'Макаров', fi: 'М.', mi: 'А.', rank: 'рядовой'),
  SeedSlot(26, 'Номер расчёта', '1-й взвод', RankCategory.soldier),
  SeedSlot(27, 'Номер расчёта', '1-й взвод', RankCategory.soldier,
      last: 'Никитин', fi: 'Н.', mi: 'А.', rank: 'рядовой'),
  SeedSlot(28, 'Номер расчёта', '1-й взвод', RankCategory.soldier,
      last: 'Захаров', fi: 'И.', mi: 'П.', rank: 'рядовой'),
  SeedSlot(29, 'Командир расчёта', '1-й взвод', RankCategory.sergeant,
      last: 'Зайцев', fi: 'С.', mi: 'Е.', rank: 'сержант'),
  SeedSlot(30, 'Водитель', '1-й взвод', RankCategory.soldier,
      last: 'Соловьёв', fi: 'С.', mi: 'В.', rank: 'рядовой'),
  SeedSlot(31, 'Наводчик', '1-й взвод', RankCategory.soldier,
      last: 'Борисов', fi: 'М.', mi: 'С.', rank: 'рядовой'),
  SeedSlot(32, 'Номер расчёта', '1-й взвод', RankCategory.soldier,
      last: 'Яковлев', fi: 'А.', mi: 'Е.', rank: 'рядовой'),
  SeedSlot(33, 'Номер расчёта', '1-й взвод', RankCategory.soldier,
      last: 'Григорьев', fi: 'С.', mi: 'В.', rank: 'рядовой'),
  SeedSlot(34, 'Номер расчёта', '1-й взвод', RankCategory.soldier,
      last: 'Романов', fi: 'В.', mi: 'С.', rank: 'рядовой'),
  // ── 2-й взвод ──
  SeedSlot(35, 'Командир взвода', '2-й взвод', RankCategory.officer,
      last: 'Воробьёв', fi: 'В.', mi: 'И.', rank: 'лейтенант'),
  SeedSlot(36, 'Зам. командира взвода', '2-й взвод', RankCategory.sergeant,
      last: 'Сергеев', fi: 'В.', mi: 'С.', rank: 'сержант'),
  SeedSlot(37, 'Водитель', '2-й взвод', RankCategory.soldier,
      last: 'Фролов', fi: 'А.', mi: 'С.', rank: 'рядовой'),
  SeedSlot(38, 'Наводчик', '2-й взвод', RankCategory.soldier,
      last: 'Александров', fi: 'И.', mi: 'Ю.', rank: 'ефрейтор'),
  SeedSlot(39, 'Номер расчёта', '2-й взвод', RankCategory.soldier,
      last: 'Дмитриев', fi: 'А.', mi: 'З.', rank: 'рядовой'),
  SeedSlot(40, 'Номер расчёта', '2-й взвод', RankCategory.soldier,
      last: 'Королёв', fi: 'А.', mi: 'Ю.', rank: 'рядовой'),
  SeedSlot(41, 'Номер расчёта', '2-й взвод', RankCategory.soldier,
      last: 'Гусев', fi: 'В.', mi: 'В.', rank: 'рядовой'),
  SeedSlot(42, 'Командир расчёта', '2-й взвод', RankCategory.sergeant,
      last: 'Киселёв', fi: 'С.', mi: 'В.', rank: 'мл. сержант'),
  SeedSlot(43, 'Водитель', '2-й взвод', RankCategory.soldier,
      last: 'Ильин', fi: 'С.', mi: 'Н.', rank: 'рядовой'),
  SeedSlot(44, 'Наводчик', '2-й взвод', RankCategory.soldier,
      last: 'Максимов', fi: 'С.', mi: 'Н.', rank: 'рядовой'),
  SeedSlot(45, 'Номер расчёта', '2-й взвод', RankCategory.soldier),
  SeedSlot(46, 'Номер расчёта', '2-й взвод', RankCategory.soldier,
      last: 'Сорокин', fi: 'А.', mi: 'С.', rank: 'рядовой'),
  SeedSlot(47, 'Номер расчёта', '2-й взвод', RankCategory.soldier,
      last: 'Виноградов', fi: 'А.', mi: 'А.', rank: 'рядовой'),
  SeedSlot(48, 'Командир расчёта', '2-й взвод', RankCategory.sergeant,
      last: 'Ковалёв', fi: 'В.', mi: 'В.', rank: 'сержант'),
  SeedSlot(49, 'Водитель', '2-й взвод', RankCategory.soldier,
      last: 'Белов', fi: 'М.', mi: 'С.', rank: 'рядовой'),
  SeedSlot(50, 'Наводчик', '2-й взвод', RankCategory.soldier,
      last: 'Медведев', fi: 'Л.', mi: 'П.', rank: 'рядовой'),
  SeedSlot(51, 'Номер расчёта', '2-й взвод', RankCategory.soldier,
      last: 'Антонов', fi: 'А.', mi: 'О.', rank: 'рядовой'),
  SeedSlot(52, 'Номер расчёта', '2-й взвод', RankCategory.soldier,
      last: 'Тарасов', fi: 'И.', mi: 'М.', rank: 'рядовой'),
  SeedSlot(53, 'Номер расчёта', '2-й взвод', RankCategory.soldier,
      last: 'Жуков', fi: 'А.', mi: 'Н.', rank: 'рядовой'),
];
