/// Справочник наград для выплывающего выбора в профиле бойца.
///
/// Ведомственные награды Росгвардии — по Приказу Федеральной службы войск
/// национальной гвардии РФ от 14 февраля 2017 г. № 50 «О ведомственных наградах
/// Федеральной службы войск национальной гвардии Российской Федерации»
/// (источник: rosguard.gov.ru).
/// Государственные награды — основной военный блок наградной системы РФ.
library;

/// Тип награды.
enum AwardKind {
  state('Государственная', 'ГОС'),
  departmental('Ведомственная', 'ВЕД');

  const AwardKind(this.label, this.short);
  final String label;
  final String short;
}

/// Шаблон награды из справочника. [degrees] — список степеней (I/II/III),
/// пустой если у награды степеней нет.
class AwardTemplate {
  const AwardTemplate(this.name, this.kind, [this.degrees = const []]);

  final String name;
  final AwardKind kind;
  final List<String> degrees;

  bool get hasDegrees => degrees.isNotEmpty;

  /// Полное отображаемое имя с учётом выбранной степени.
  String fullName([String? degree]) =>
      degree == null ? name : '$name ($degree ст.)';
}

abstract final class AwardCatalog {
  /// Ведомственные знаки отличия Росгвардии (Приказ № 50 от 14.02.2017).
  static const List<AwardTemplate> rosgvardia = [
    // ── Медали ──
    AwardTemplate('Медаль «За боевое отличие»', AwardKind.departmental),
    AwardTemplate('Медаль «За проявленную доблесть»', AwardKind.departmental,
        ['I', 'II', 'III']),
    AwardTemplate('Медаль «За разминирование»', AwardKind.departmental),
    AwardTemplate('Медаль «За спасение»', AwardKind.departmental),
    AwardTemplate('Медаль «За боевое содружество»', AwardKind.departmental),
    AwardTemplate(
        'Медаль «За заслуги в укреплении правопорядка»', AwardKind.departmental),
    AwardTemplate('Медаль «За заслуги в труде»', AwardKind.departmental),
    AwardTemplate('Медаль «За отличие в службе»', AwardKind.departmental,
        ['I', 'II', 'III']),
    AwardTemplate('Медаль «За особые достижения в учебе»', AwardKind.departmental),
    AwardTemplate('Медаль «За содействие»', AwardKind.departmental),
    AwardTemplate('Медаль «Ветеран службы»', AwardKind.departmental),
    // ── Нагрудные знаки ──
    AwardTemplate('Знак «За отличие в службе в особых условиях»',
        AwardKind.departmental),
    AwardTemplate(
        'Знак «За отличие в службе»', AwardKind.departmental, ['I', 'II']),
    AwardTemplate('Знак «Участник боевых действий»', AwardKind.departmental),
    // ── Почётное звание / документы ──
    AwardTemplate('Почётное звание «Почётный сотрудник Росгвардии»',
        AwardKind.departmental),
    AwardTemplate('Почётная грамота Росгвардии', AwardKind.departmental),
    AwardTemplate('Благодарность директора Росгвардии', AwardKind.departmental),
  ];

  /// Основные государственные награды РФ (военный блок).
  static const List<AwardTemplate> state = [
    // ── Высшее звание ──
    AwardTemplate('Медаль «Золотая Звезда» (Герой РФ)', AwardKind.state),
    // ── Ордена ──
    AwardTemplate('Орден Святого Георгия', AwardKind.state,
        ['I', 'II', 'III', 'IV']),
    AwardTemplate('Орден «За заслуги перед Отечеством»', AwardKind.state,
        ['I', 'II', 'III', 'IV']),
    AwardTemplate('Орден Мужества', AwardKind.state),
    AwardTemplate('Орден «За военные заслуги»', AwardKind.state),
    AwardTemplate('Орден Жукова', AwardKind.state),
    AwardTemplate('Орден Суворова', AwardKind.state),
    AwardTemplate('Орден Кутузова', AwardKind.state),
    AwardTemplate('Орден Александра Невского', AwardKind.state),
    AwardTemplate('Орден Ушакова', AwardKind.state),
    AwardTemplate('Орден Нахимова', AwardKind.state),
    AwardTemplate('Орден Почёта', AwardKind.state),
    AwardTemplate('Орден Дружбы', AwardKind.state),
    // ── Знаки отличия ──
    AwardTemplate('Знак отличия — Георгиевский Крест', AwardKind.state,
        ['I', 'II', 'III', 'IV']),
    AwardTemplate('Знак отличия «За безупречную службу»', AwardKind.state),
    // ── Медали ──
    AwardTemplate('Медаль ордена «За заслуги перед Отечеством»',
        AwardKind.state, ['I', 'II']),
    AwardTemplate('Медаль «За отвагу»', AwardKind.state),
    AwardTemplate('Медаль Суворова', AwardKind.state),
    AwardTemplate('Медаль Жукова', AwardKind.state),
    AwardTemplate('Медаль Ушакова', AwardKind.state),
    AwardTemplate('Медаль Нестерова', AwardKind.state),
    AwardTemplate('Медаль «За спасение погибавших»', AwardKind.state),
    AwardTemplate(
        'Медаль «За отличие в охране общественного порядка»', AwardKind.state),
  ];

  /// Обе группы вместе — для единого выплывающего списка.
  static List<AwardTemplate> get all => [...state, ...rosgvardia];
}
