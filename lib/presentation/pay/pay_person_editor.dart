import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/n_fields.dart';
import '../../core/widgets/n_sheet_footer.dart';
import '../../core/widgets/n_panel.dart';
import '../../core/widgets/n_sheet.dart';
import '../../data/database/app_database.dart';
import '../../domain/entities/enums.dart';
import '../../domain/services/pay_service.dart';
import '../providers/app_providers.dart';

/// Редактор надбавок ДД конкретного бойца (открывается из «Калькулятор ДД →
/// По подразделению»). Сохраняет надбавки в профиль, показывает до/после НДФЛ.
Future<void> showPayPersonEditor(BuildContext context, int personId) {
  return showNSheet(
    context: context,
    expand: true,
    builder: (_) => _PayPersonEditor(personId: personId),
  );
}

class _PayPersonEditor extends ConsumerStatefulWidget {
  const _PayPersonEditor({required this.personId});
  final int personId;

  @override
  ConsumerState<_PayPersonEditor> createState() => _PayPersonEditorState();
}

class _PayPersonEditorState extends ConsumerState<_PayPersonEditor> {
  int _special = 0, _secrecy = 0, _risk = 0, _fizo = 0, _achieve = 0, _premium = 25;
  double _region = 1.0;
  bool _loaded = false;

  void _load(PersonRow p) {
    _special = p.allowanceSpecial;
    _secrecy = p.allowanceSecrecy;
    _risk = p.allowanceRisk;
    _fizo = p.allowanceFizo;
    _achieve = p.allowanceAchieve;
    _premium = p.premiumPercent;
    _region = p.regionalCoef;
    _loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    final es = ref.watch(soldierByPersonProvider(widget.personId));
    if (es == null || es.view.person == null) {
      return const SizedBox(height: 200, child: Center(child: Text('—')));
    }
    if (!_loaded) _load(es.view.person!);

    final scale = ref.watch(payScaleProvider);
    final los = ref.watch(lengthOfServiceProvider(widget.personId));
    final person = es.view.person!;
    final pos = es.view.position;
    final classPct = classQualPercent(person.qualification);
    final servicePct = los?.allowancePercent ?? 0;

    final b = PayBreakdown.ofInput(PayInput(
      ovd: scale.dutyFor(pos.tariffRank),
      ovz: scale.rankFor(person.rank),
      ovdHint: pos.tariffRank == null ? 'разряд не задан' : '${pos.tariffRank}-й т.р.',
      ovzHint: person.rank.isEmpty ? 'звание не указано' : person.rank,
      servicePct: servicePct,
      classPct: classPct,
      specialPct: _special,
      secrecyPct: _secrecy,
      riskPct: _risk,
      fizoPct: _fizo,
      achievePct: _achieve,
      premiumPct: _premium,
      regionalCoef: _region,
    ));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(es.view.displayName.toUpperCase(), style: AppTypography.title),
          ),
        ),
        Flexible(
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.lg),
            children: [
              _resultCard(b),
              const SizedBox(height: AppDimens.md),
              // Оклады: выбрать тарифный разряд должности и звание прямо здесь.
              _pickerRow('Тарифный разряд должности',
                  pos.tariffRank == null ? 'выбрать' : '${pos.tariffRank}-й · ${formatRub(b.ovd)}',
                  () => _pickTariff(scale, pos)),
              const SizedBox(height: AppDimens.sm),
              _pickerRow('Воинское звание',
                  person.rank.isEmpty ? 'выбрать' : '${person.rank} · ${formatRub(b.ovz)}',
                  () => _pickRank(scale, person)),
              if (pos.tariffRank != null && b.ovd == 0)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.xs),
                  child: Text('Для этого разряда нет оклада в справочнике — добавьте его.',
                      style: AppTypography.dataSmall.copyWith(color: AppColors.statusSick)),
                ),
              if (person.rank.isNotEmpty && b.ovz == 0)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.xs),
                  child: Text('Для этого звания нет оклада в справочнике — выберите из списка.',
                      style: AppTypography.dataSmall.copyWith(color: AppColors.statusSick)),
                ),
              const SizedBox(height: AppDimens.md),
              _auto('Выслуга', servicePct),
              _auto('Классность', classPct),
              const SizedBox(height: AppDimens.sm),
              _chips('Особые условия', PayOptions.special, _special, (v) => setState(() => _special = v)),
              const SizedBox(height: AppDimens.md),
              _chips('Гостайна', PayOptions.secrecy, _secrecy, (v) => setState(() => _secrecy = v)),
              const SizedBox(height: AppDimens.md),
              _chips('Физподготовка', PayOptions.fizo, _fizo, (v) => setState(() => _fizo = v)),
              const SizedBox(height: AppDimens.md),
              _stepper('Риск для жизни, %', _risk, (v) => setState(() => _risk = v)),
              const SizedBox(height: AppDimens.md),
              _stepper('Особые достижения, %', _achieve, (v) => setState(() => _achieve = v)),
              const SizedBox(height: AppDimens.md),
              _stepper('Премия, %', _premium, (v) => setState(() => _premium = v)),
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
              const SizedBox(height: AppDimens.md),
            ],
          ),
        ),
        NSheetFooter(onSave: _save, saveLabel: 'СОХРАНИТЬ НАДБАВКИ'),
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
                      Text('БЕЗ НАЛОГА', style: AppTypography.label),
                      const SizedBox(height: 4),
                      Text(formatRub(b.monthly),
                          style: AppTypography.counter.copyWith(color: AppColors.textPrimary, fontSize: 22)),
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
                          style: AppTypography.counter.copyWith(color: AppColors.accentPrimary, fontSize: 22)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('удержано ≈ ${formatRub(b.taxAmount)} · ОМДС ${formatRub(b.omds)}',
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

  Widget _auto(String label, int pct) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text('$label (авто)', style: AppTypography.label),
            const Spacer(),
            Text(pct > 0 ? '$pct%' : 'нет',
                style: AppTypography.data.copyWith(
                    color: pct > 0 ? AppColors.accentPrimary : AppColors.textTertiary)),
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

  Widget _stepper(String label, int value, ValueChanged<int> onChanged) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: AppTypography.label)),
          NStepper(value: value, onChanged: onChanged, max: 100),
        ],
      );

  Widget _pickerRow(String label, String value, VoidCallback onTap) => NPanel(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTypography.data)),
            Flexible(
              child: Text(value,
                  style: AppTypography.data.copyWith(color: AppColors.accentPrimary),
                  textAlign: TextAlign.right, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: AppDimens.sm),
            Icon(AppIcons.caretDown, size: 18, color: AppColors.textTertiary),
          ],
        ),
      );

  Future<void> _pickTariff(PayScale scale, PositionRow pos) async {
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
    if (v != null) {
      await ref.read(appDatabaseProvider)
          .updatePosition(pos.id, PositionsCompanion(tariffRank: Value(v)));
    }
  }

  Future<void> _pickRank(PayScale scale, PersonRow person) async {
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
    if (v != null) {
      await ref.read(appDatabaseProvider)
          .updatePerson(person.id, PersonnelCompanion(rank: Value(v)));
    }
  }

  Future<void> _save() async {
    await ref.read(appDatabaseProvider).updatePerson(
          widget.personId,
          PersonnelCompanion(
            allowanceSpecial: Value(_special),
            allowanceSecrecy: Value(_secrecy),
            allowanceRisk: Value(_risk),
            allowanceFizo: Value(_fizo),
            allowanceAchieve: Value(_achieve),
            premiumPercent: Value(_premium),
            regionalCoef: Value(_region),
          ),
        );
    if (mounted) Navigator.pop(context);
  }
}
