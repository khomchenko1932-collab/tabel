import '../../data/database/app_database.dart';
import '../entities/enums.dart';

/// Ставка НДФЛ для оценки «после удержания» (упрощённо).
const double kNdflRate = 0.13;

/// Справочник окладов в удобном для расчёта виде.
class PayScale {
  const PayScale(this.tariff, this.rank);

  /// Тарифный разряд (1–50) → оклад по должности (ОВД), ₽.
  final Map<int, int> tariff;

  /// Нормализованное звание → оклад по званию (ОВЗ), ₽.
  final Map<String, int> rank;

  factory PayScale.from(List<PayRateRow> rows) {
    final t = <int, int>{};
    final r = <String, int>{};
    for (final row in rows) {
      if (row.kind == PayRateKind.tariff) {
        final n = int.tryParse(row.code);
        if (n != null) t[n] = row.amount;
      } else {
        r[row.code.trim().toLowerCase()] = row.amount;
      }
    }
    return PayScale(t, r);
  }

  int dutyFor(int? tariffRank) => tariffRank == null ? 0 : (tariff[tariffRank] ?? 0);
  int rankFor(String rankName) => rank[rankName.trim().toLowerCase()] ?? 0;

  bool get isEmpty => tariff.isEmpty && rank.isEmpty;
}

/// Строка в разбивке денежного довольствия.
class PayLine {
  const PayLine(this.label, this.amount, {this.hint});
  final String label;
  final int amount; // ₽
  final String? hint;
}

/// Варианты надбавок для интерактивного калькулятора (проценты от ОВД, если
/// не указано иное). Значения СПРАВОЧНЫЕ — сверять с приказами Росгвардии.
abstract final class PayOptions {
  /// Классная квалификация: (%, подпись). % от ОВД.
  static const List<(int, String)> classQual = [
    (0, 'нет'), (5, '3 класс'), (10, '2 класс'), (20, '1 класс'), (30, 'мастер'),
  ];

  /// Гостайна: % от ОВД (ст. секретности).
  static const List<(int, String)> secrecy = [
    (0, 'нет'), (10, 'секретно'), (20, 'сов. секретно'), (25, 'особой важности'),
  ];

  /// Физподготовка: % от ОВД (уровни и спортивные разряды).
  static const List<(int, String)> fizo = [
    (0, 'нет'), (15, '2 уровень'), (30, '1 уровень'), (70, 'высший'),
    (80, '1 разряд'), (90, 'КМС'), (100, 'МС/МСМК'),
  ];

  /// Особые условия — типовые быстрые значения, % от ОВД (суммарно до 100).
  static const List<(int, String)> special = [
    (0, 'нет'), (5, '5%'), (15, '15%'), (20, '20%'), (30, '30%'), (50, '50%'), (100, '100%'),
  ];

  /// Районный коэффициент (множитель ко всему довольствию).
  static const List<double> regional = [1.0, 1.15, 1.2, 1.3, 1.5, 2.0];

  /// Ежемесячная надбавка за выслугу по годам (для выбора в калькуляторе).
  /// (полных лет ≥, %, подпись диапазона). % от ОДС.
  static const List<(int, int, String)> serviceTiers = [
    (0, 0, 'до 2 лет'), (2, 10, '2–5 лет'), (5, 15, '5–10 лет'),
    (10, 20, '10–15 лет'), (15, 25, '15–20 лет'),
    (20, 30, '20–25 лет'), (25, 40, '25+ лет'),
  ];
}

/// Входные значения для расчёта ДД «по выбору» (интерактивный калькулятор).
class PayInput {
  const PayInput({
    required this.ovd,
    required this.ovz,
    this.ovdHint,
    this.ovzHint,
    this.servicePct = 0,
    this.classPct = 0,
    this.specialPct = 0,
    this.secrecyPct = 0,
    this.riskPct = 0,
    this.fizoPct = 0,
    this.achievePct = 0,
    this.premiumPct = 0,
    this.regionalCoef = 1.0,
  });

  final int ovd;
  final int ovz;
  final String? ovdHint;
  final String? ovzHint;
  final int servicePct; // выслуга (от ОДС)
  final int classPct; // классность (от ОВД)
  final int specialPct; // особые условия (от ОВД)
  final int secrecyPct; // гостайна (от ОВД)
  final int riskPct; // риск (от ОВД)
  final int fizoPct; // физподготовка (от ОВД)
  final int achievePct; // особые достижения (от ОВД)
  final int premiumPct; // премия (от ОДС)
  final double regionalCoef;
}

/// Расчёт денежного довольствия бойца за месяц (СПРАВОЧНО — не официальный
/// расчёт; официально ДД считает финансовый орган).
class PayBreakdown {
  PayBreakdown({
    required this.ovd,
    required this.ovz,
    required this.lines,
    required this.monthly,
    required this.matHelpAnnual,
  });

  final int ovd; // оклад по должности
  final int ovz; // оклад по званию
  final List<PayLine> lines; // все слагаемые (включая ОВД/ОВЗ)
  final int monthly; // итог за месяц ДО налога, ₽
  final int matHelpAnnual; // матпомощь за год (1 ОМДС), ₽

  int get omds => ovd + ovz;
  bool get hasSalary => omds > 0;

  /// Итог после удержания НДФЛ (упрощённо 13%; часть выплат может не
  /// облагаться — это оценка).
  int get afterTax => (monthly * (1 - kNdflRate)).round();
  int get taxAmount => monthly - afterTax;

  static int _pct(int base, int percent) => (base * percent / 100).round();

  /// Ядро расчёта — по явным значениям (используется и профилем, и
  /// интерактивным калькулятором).
  static PayBreakdown ofInput(PayInput i) {
    final omds = i.ovd + i.ovz;
    final lines = <PayLine>[
      PayLine('Оклад по должности', i.ovd, hint: i.ovdHint),
      PayLine('Оклад по званию', i.ovz, hint: i.ovzHint),
      if (i.servicePct > 0)
        PayLine('Надбавка за выслугу · ${i.servicePct}%', _pct(omds, i.servicePct)),
      if (i.classPct > 0)
        PayLine('За классность · ${i.classPct}%', _pct(i.ovd, i.classPct)),
      if (i.specialPct > 0)
        PayLine('Особые условия · ${i.specialPct}%', _pct(i.ovd, i.specialPct)),
      if (i.secrecyPct > 0)
        PayLine('Гостайна · ${i.secrecyPct}%', _pct(i.ovd, i.secrecyPct)),
      if (i.riskPct > 0)
        PayLine('Риск для жизни · ${i.riskPct}%', _pct(i.ovd, i.riskPct)),
      if (i.fizoPct > 0)
        PayLine('Физподготовка · ${i.fizoPct}%', _pct(i.ovd, i.fizoPct)),
      if (i.achievePct > 0)
        PayLine('Особые достижения · ${i.achievePct}%', _pct(i.ovd, i.achievePct)),
      if (i.premiumPct > 0)
        PayLine('Премия · ${i.premiumPct}%', _pct(omds, i.premiumPct)),
    ];

    var subtotal = lines.fold<int>(0, (s, l) => s + l.amount);
    if (i.regionalCoef > 1.0) {
      final bonus = (subtotal * (i.regionalCoef - 1.0)).round();
      lines.add(PayLine('Районный коэффициент · ×${i.regionalCoef}', bonus));
      subtotal += bonus;
    }

    return PayBreakdown(
      ovd: i.ovd,
      ovz: i.ovz,
      lines: lines,
      monthly: subtotal,
      matHelpAnnual: omds, // матпомощь — не менее 1 ОМДС в год
    );
  }

  /// Расчёт по бойцу. [serviceAllowancePercent] — надбавка за выслугу (%),
  /// приходит из модуля выслуги (по календарной).
  static PayBreakdown of(
    PersonRow person,
    PositionRow position,
    PayScale scale, {
    required int serviceAllowancePercent,
  }) {
    return ofInput(PayInput(
      ovd: scale.dutyFor(position.tariffRank),
      ovz: scale.rankFor(person.rank),
      ovdHint: position.tariffRank == null ? 'разряд не задан' : '${position.tariffRank}-й т.р.',
      ovzHint: person.rank.isEmpty ? 'звание не указано' : person.rank,
      servicePct: serviceAllowancePercent,
      classPct: classQualPercent(person.qualification),
      specialPct: person.allowanceSpecial,
      secrecyPct: person.allowanceSecrecy,
      riskPct: person.allowanceRisk,
      fizoPct: person.allowanceFizo,
      achievePct: person.allowanceAchieve,
      premiumPct: person.premiumPercent,
      regionalCoef: person.regionalCoef,
    ));
  }
}

/// «64 473 ₽» — разряды тысяч разделены неразрывным пробелом.
String formatRub(int amount) {
  final s = amount.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return '${amount < 0 ? '−' : ''}$buf ₽';
}
