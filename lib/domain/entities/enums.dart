/// Перечисления предметной области. Чистый Dart без Flutter —
/// цвета/иконки задаются в слое представления (см. presentation/common).
library;

/// Статус бойца (для занятой должности).
enum PersonnelStatus {
  here('Налицо'),
  trip('Командировка'),
  leave('Отпуск'),
  sick('Болен');

  const PersonnelStatus(this.label);
  final String label;
}

/// Подсказки подразделений при создании должности (не жёсткий список —
/// подразделение хранится как свободный текст, подходит любой части).
const List<String> kSubunitSuggestions = [
  'Управление',
  '1-й взвод',
  '2-й взвод',
  '3-й взвод',
];

/// Категория по званию.
enum RankCategory {
  officer('Офицер', 'Офицеры'),
  warrant('Прапорщик', 'Прапорщики'),
  sergeant('Сержант', 'Сержанты'),
  soldier('Рядовой', 'Рядовые');

  const RankCategory(this.label, this.plural);
  final String label;
  final String plural;

  /// Категория выводится из звания — при смене звания меняется автоматически.
  static RankCategory fromRank(String rank) {
    final r = rank.toLowerCase();
    if (r.contains('генерал') ||
        r.contains('полковник') ||
        r.contains('майор') ||
        r.contains('капитан') ||
        r.contains('лейтенант')) {
      return RankCategory.officer;
    }
    if (r.contains('прапорщик')) return RankCategory.warrant;
    if (r.contains('сержант') || r.contains('старшина')) {
      return RankCategory.sergeant;
    }
    return RankCategory.soldier; // рядовой, ефрейтор, пусто
  }
}

/// Тип отпуска.
enum LeaveType {
  main('Основной'),
  veteran('Ветеранский'),
  additional('Дополнительный'),
  medical('По болезни');

  const LeaveType(this.label);
  final String label;
}

/// Статус отпуска.
enum LeaveStatus {
  planned('План'),
  active('В отпуске'),
  completed('Завершён'),
  cancelled('Отменён');

  const LeaveStatus(this.label);
  final String label;
}

/// Статус командировки.
enum TripStatus {
  planned('План'),
  active('Активна'),
  completed('Завершена');

  const TripStatus(this.label);
  final String label;
}

/// Вид оклада в справочнике: по тарифному разряду (должность) или по званию.
enum PayRateKind {
  tariff('Тарифный разряд'),
  rank('Воинское звание');

  const PayRateKind(this.label);
  final String label;
}

/// Надбавка за классную квалификацию — процент от оклада по должности.
/// Значения по квалификации из формы (мастер/1/2/3 класс). Справочно.
int classQualPercent(String? qualification) {
  final q = (qualification ?? '').toLowerCase();
  if (q.contains('мастер')) return 30;
  if (q.contains('1')) return 20;
  if (q.contains('2')) return 10;
  if (q.contains('3')) return 5;
  return 0;
}

/// Тип единицы вооружения/имущества.
enum WeaponType {
  weapon('Оружие'),
  device('Приборы'),
  equipment('Техника');

  const WeaponType(this.label);
  final String label;
}

/// Семейное положение.
enum MaritalStatus {
  single('Холост'),
  married('Женат'),
  divorced('Разведён'),
  widowed('Вдовец');

  const MaritalStatus(this.label);
  final String label;
}
