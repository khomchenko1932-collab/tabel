import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/n_fields.dart';
import '../../core/widgets/n_panel.dart';
import '../../core/widgets/n_sheet.dart';
import '../../domain/services/pay_service.dart';
import '../providers/app_providers.dart';

/// Интерактивный расчёт ДД: выбираешь разряд, звание, выслугу и надбавки —
/// получаешь примерную сумму. Оклады берутся из справочника.
class PayQuickCalc extends ConsumerStatefulWidget {
  const PayQuickCalc({super.key});

  @override
  ConsumerState<PayQuickCalc> createState() => _PayQuickCalcState();
}

class _PayQuickCalcState extends ConsumerState<PayQuickCalc> {
  int _tariff = 0; // 0 — не выбран
  String? _rank;
  int _service = 0;
  int _class = 0;
  int _special = 0;
  int _secrecy = 0;
  int _fizo = 0;
  int _risk = 0;
  int _achieve = 0;
  int _premium = 25;
  double _region = 1.0;

  @override
  Widget build(BuildContext context) {
    final scale = ref.watch(payScaleProvider);
    final ovd = scale.tariff[_tariff] ?? 0;
    final ovz = _rank == null ? 0 : (scale.rank[_rank] ?? 0);

    final b = PayBreakdown.ofInput(PayInput(
      ovd: ovd,
      ovz: ovz,
      ovdHint: _tariff == 0 ? 'разряд не выбран' : '$_tariff-й разряд',
      ovzHint: _rank ?? 'звание не выбрано',
      servicePct: _service,
      classPct: _class,
      specialPct: _special,
      secrecyPct: _secrecy,
      fizoPct: _fizo,
      riskPct: _risk,
      achievePct: _achieve,
      premiumPct: _premium,
      regionalCoef: _region,
    ));

    if (scale.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.xl),
          child: Text('Заполните справочник окладов — тогда расчёт заработает.',
              style: AppTypography.caption, textAlign: TextAlign.center),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppDimens.lg),
      children: [
        _resultCard(b),
        const SizedBox(height: AppDimens.md),

        _pickerRow('Тарифный разряд должности', _tariff == 0 ? 'выбрать' : '$_tariff-й · ${formatRub(ovd)}',
            () => _pickTariff(scale)),
        const SizedBox(height: AppDimens.md),
        _pickerRow('Воинское звание', _rank == null ? 'выбрать' : '$_rank · ${formatRub(ovz)}',
            () => _pickRank(scale)),

        const SizedBox(height: AppDimens.lg),
        _chips('Выслуга лет', PayOptions.serviceTiers.map((t) => (t.$2, t.$3)).toList(),
            _service, (v) => setState(() => _service = v)),
        const SizedBox(height: AppDimens.md),
        _chips('Классная квалификация', PayOptions.classQual, _class, (v) => setState(() => _class = v)),
        const SizedBox(height: AppDimens.md),
        _chips('Особые условия', PayOptions.special, _special, (v) => setState(() => _special = v)),
        const SizedBox(height: AppDimens.md),
        _chips('Гостайна', PayOptions.secrecy, _secrecy, (v) => setState(() => _secrecy = v)),
        const SizedBox(height: AppDimens.md),
        _chips('Физподготовка', PayOptions.fizo, _fizo, (v) => setState(() => _fizo = v)),
        const SizedBox(height: AppDimens.md),
        _stepperRow('Риск для жизни, %', _risk, (v) => setState(() => _risk = v)),
        const SizedBox(height: AppDimens.md),
        _stepperRow('Особые достижения, %', _achieve, (v) => setState(() => _achieve = v)),
        const SizedBox(height: AppDimens.md),
        _stepperRow('Премия, %', _premium, (v) => setState(() => _premium = v)),
        const SizedBox(height: AppDimens.md),
        NField(
          label: 'Районный коэффициент',
          child: NChoiceChips<double>(
            values: PayOptions.regional,
            selected: PayOptions.regional.contains(_region) ? _region : 1.0,
            labelOf: (c) => c == 1.0 ? 'нет' : '×$c',
            onChanged: (c) => setState(() => _region = c),
          ),
        ),
        const SizedBox(height: AppDimens.lg),
        Text('Оценка, справочно. Проценты и оклады сверяйте с приказами '
            'Росгвардии; итог не заменяет расчёт финансового органа.',
            style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: AppDimens.xl),
      ],
    );
  }

  Widget _resultCard(PayBreakdown b) => NPanel(
        glow: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('БЕЗ НАЛОГА · В МЕСЯЦ', style: AppTypography.label),
                      const SizedBox(height: 4),
                      Text(formatRub(b.monthly),
                          style: AppTypography.counter.copyWith(color: AppColors.textPrimary, fontSize: 24)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('НА РУКИ · НДФЛ 13%', style: AppTypography.label),
                      const SizedBox(height: 4),
                      Text(formatRub(b.afterTax),
                          style: AppTypography.counter.copyWith(color: AppColors.accentPrimary, fontSize: 24)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text('удержано ≈ ${formatRub(b.taxAmount)} · ОМДС ${formatRub(b.omds)} · матпомощь/год ${formatRub(b.matHelpAnnual)}',
                style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
            const SizedBox(height: 2),
            Text('ОМДС — оклад месячного денежного содержания (оклад по должности + по званию)',
                style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
            const Divider(height: AppDimens.lg, color: AppColors.stroke),
            for (final l in b.lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(child: Text(l.label, style: AppTypography.dataSmall.copyWith(color: AppColors.textSecondary))),
                    Text(formatRub(l.amount), style: AppTypography.dataSmall),
                  ],
                ),
              ),
          ],
        ),
      );

  Widget _pickerRow(String label, String value, VoidCallback onTap) => NPanel(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTypography.data)),
            Text(value, style: AppTypography.data.copyWith(color: AppColors.accentPrimary)),
            const SizedBox(width: AppDimens.sm),
            Icon(AppIcons.caretDown, size: 18, color: AppColors.textTertiary),
          ],
        ),
      );

  Widget _chips(String label, List<(int, String)> options, int value, ValueChanged<int> onChanged) {
    return NField(
      label: label,
      child: NChoiceChips<int>(
        values: options.map((o) => o.$1).toList(),
        selected: options.any((o) => o.$1 == value) ? value : 0,
        labelOf: (v) => options.firstWhere((o) => o.$1 == v).$2,
        onChanged: onChanged,
      ),
    );
  }

  Widget _stepperRow(String label, int value, ValueChanged<int> onChanged) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: AppTypography.label)),
          NStepper(value: value, onChanged: onChanged, max: 100),
        ],
      );

  Future<void> _pickTariff(PayScale scale) async {
    final keys = scale.tariff.keys.toList()..sort();
    final v = await showNSheet<int>(
      context: context,
      expand: true,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(AppDimens.md),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.sm),
            child: Text('Тарифный разряд', style: AppTypography.title),
          ),
          for (final k in keys)
            NPanel(
              margin: const EdgeInsets.only(bottom: AppDimens.xs),
              onTap: () => Navigator.pop(context, k),
              child: Row(
                children: [
                  Expanded(child: Text('$k-й разряд', style: AppTypography.data)),
                  Text(formatRub(scale.tariff[k]!),
                      style: AppTypography.data.copyWith(color: AppColors.accentPrimary)),
                ],
              ),
            ),
        ],
      ),
    );
    if (v != null) setState(() => _tariff = v);
  }

  Future<void> _pickRank(PayScale scale) async {
    final entries = scale.rank.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
    final v = await showNSheet<String>(
      context: context,
      expand: true,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(AppDimens.md),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.sm),
            child: Text('Воинское звание', style: AppTypography.title),
          ),
          for (final e in entries)
            NPanel(
              margin: const EdgeInsets.only(bottom: AppDimens.xs),
              onTap: () => Navigator.pop(context, e.key),
              child: Row(
                children: [
                  Expanded(child: Text(e.key, style: AppTypography.data)),
                  Text(formatRub(e.value),
                      style: AppTypography.data.copyWith(color: AppColors.accentPrimary)),
                ],
              ),
            ),
        ],
      ),
    );
    if (v != null) setState(() => _rank = v);
  }
}
