import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/n_panel.dart';
import '../../domain/services/pay_service.dart';
import '../../domain/services/roster_service.dart';
import '../common/soldier_picker.dart';
import '../providers/app_providers.dart';
import 'pay_person_editor.dart';
import 'pay_quick_calc.dart';
import 'pay_rates_screen.dart';

/// Калькулятор денежного довольствия: список бойцов с суммой ДД,
/// итоговый фонд подразделения, разбивка по каждому. Всё справочно.
class PayCalculatorScreen extends ConsumerStatefulWidget {
  const PayCalculatorScreen({super.key});

  @override
  ConsumerState<PayCalculatorScreen> createState() => _PayCalculatorScreenState();
}

class _PayCalculatorScreenState extends ConsumerState<PayCalculatorScreen> {
  int _mode = 0; // 0 — по подразделению, 1 — быстрый расчёт
  // По умолчанию — ПУСТОЙ свой список: командир сам добавляет бойцов.
  // null — режим «показать всех».
  Set<int>? _picked = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор ДД', style: AppTypography.title),
        leading: IconButton(
          icon: Icon(AppIcons.arrowLeft, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_mode == 0)
            IconButton(
              tooltip: 'Очистить данные ДД у всех',
              icon: Icon(AppIcons.trash, color: AppColors.statusSick),
              onPressed: _confirmClearAll,
            ),
          IconButton(
            tooltip: 'Справочник окладов',
            icon: Icon(AppIcons.coins, color: AppColors.textSecondary),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PayRatesScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _segmented(),
          Expanded(child: _mode == 0 ? _fundBody() : const PayQuickCalc()),
        ],
      ),
    );
  }

  Widget _segmented() {
    Widget seg(String label, int i) {
      final active = _mode == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _mode = i),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: AppDimens.sm),
            decoration: BoxDecoration(
              color: active ? AppColors.accentPrimary : AppColors.bgLcd,
              borderRadius: BorderRadius.circular(AppDimens.rSm),
              border: Border.all(color: active ? AppColors.accentPrimary : AppColors.stroke),
            ),
            child: Text(label.toUpperCase(),
                style: AppTypography.data.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.bgPage : AppColors.textSecondary,
                )),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, AppDimens.sm),
      child: Row(children: [
        seg('По подразделению', 0),
        const SizedBox(width: AppDimens.sm),
        seg('Быстрый расчёт', 1),
      ]),
    );
  }

  Widget _fundBody() {
    final roster = ref.watch(effectiveRosterProvider).value ?? const [];
    final scale = ref.watch(payScaleProvider);
    var occupied = roster.where((s) => s.view.person != null).toList();
    final custom = _picked != null;
    if (custom) {
      occupied = occupied.where((s) => _picked!.contains(s.view.person!.id)).toList();
    }

    final rows = <(EffectiveSoldier, PayBreakdown)>[];
    if (!scale.isEmpty) {
      for (final es in occupied) {
        final b = ref.watch(payBreakdownProvider(es.view.person!.id));
        if (b == null) continue;
        rows.add((es, b));
      }
    }

    if (scale.isEmpty) return _emptyScale(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, 0, AppDimens.lg, AppDimens.lg),
      children: [
        _disclaimer(),
        const SizedBox(height: AppDimens.sm),
        // Панель: свой список бойцов для расчёта.
        Row(
          children: [
            Expanded(
              child: Text(
                custom ? 'Свой список · ${rows.length}' : 'Все бойцы подразделения',
                style: AppTypography.label,
              ),
            ),
            TextButton(
              onPressed: _addToPicked,
              child: Text('+ добавить',
                  style: AppTypography.dataSmall.copyWith(color: AppColors.accentPrimary)),
            ),
            if (custom)
              TextButton(
                onPressed: () => setState(() => _picked = null),
                child: Text('все',
                    style: AppTypography.dataSmall.copyWith(color: AppColors.textSecondary)),
              )
            else
              TextButton(
                onPressed: () => setState(() => _picked = {}),
                child: Text('очистить',
                    style: AppTypography.dataSmall.copyWith(color: AppColors.textSecondary)),
              ),
          ],
        ),
        Text('Нажмите на бойца — задать надбавки. Суммы — оценка, до и после НДФЛ.',
            style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: AppDimens.sm),
        for (final r in rows) _personRow(context, r.$1, r.$2, custom),
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppDimens.xl),
            child: Text(
              custom
                  ? 'Список пуст. Нажмите «+ добавить», чтобы выбрать бойцов.'
                  : 'Нет данных для расчёта. Проставьте бойцам звания, '
                      'а должностям — тарифные разряды.',
              style: AppTypography.caption, textAlign: TextAlign.center),
          ),
      ],
    );
  }

  Future<void> _addToPicked() async {
    final person = await pickSoldier(context, ref, title: 'Добавить в расчёт ДД');
    if (person == null) return;
    setState(() => (_picked ??= {}).add(person.id));
  }

  Future<void> _confirmClearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.statusSick),
        ),
        title: Text('Очистить данные ДД?',
            style: AppTypography.title.copyWith(color: AppColors.statusSick)),
        content: Text(
          'У ВСЕХ бойцов обнулятся тарифные разряды, классность и все надбавки '
          '(премия, особые условия, гостайна, риск, физо, район). Звания '
          'останутся. Заполните заново вручную. Отменить нельзя.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Очистить', style: AppTypography.body.copyWith(color: AppColors.statusSick)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(appDatabaseProvider).clearAllPayData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Данные ДД очищены — заполните заново')),
        );
      }
    }
  }

  Widget _emptyScale(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmptyState(
                icon: AppIcons.coins,
                title: 'Справочник окладов пуст',
                message: 'Заполните оклады по разрядам и званиям — тогда '
                    'калькулятор сможет считать довольствие.',
              ),
              const SizedBox(height: AppDimens.md),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PayRatesScreen()),
                ),
                child: Text('Открыть справочник',
                    style: AppTypography.data.copyWith(color: AppColors.accentPrimary)),
              ),
            ],
          ),
        ),
      );

  Widget _disclaimer() => Container(
        padding: const EdgeInsets.all(AppDimens.md),
        decoration: BoxDecoration(
          color: AppColors.bgLcd,
          borderRadius: BorderRadius.circular(AppDimens.rMd),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Row(
          children: [
            Icon(AppIcons.warning, size: 16, color: AppColors.textTertiary),
            const SizedBox(width: AppDimens.sm),
            Expanded(
              child: Text(
                'Оценка, справочно. Официальный расчёт — финансовый орган. '
                'Оклады сверяйте с приказами (472/365).',
                style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary),
              ),
            ),
          ],
        ),
      );

  Widget _personRow(BuildContext context, EffectiveSoldier es, PayBreakdown b, bool removable) {
    final p = es.view.person!;
    final card = NPanel(
        onTap: () => showPayPersonEditor(context, p.id),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(es.view.displayName, style: AppTypography.name),
                  const SizedBox(height: 2),
                  Text(
                    '${p.rank.isEmpty ? '—' : p.rank} · ${es.view.position.title}',
                    style: AppTypography.dataSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.sm),
            if (b.hasSalary)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${formatRub(b.afterTax)} на руки',
                      style: AppTypography.data.copyWith(color: AppColors.accentPrimary)),
                  Text('без налога ${formatRub(b.monthly)}',
                      style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
                ],
              )
            else
              Text('нет оклада',
                  style: AppTypography.dataSmall.copyWith(color: AppColors.statusSick)),
          ],
        ),
      );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.sm),
      child: removable
          ? Dismissible(
              key: ValueKey('pay${p.id}'),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => setState(() => _picked?.remove(p.id)),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: AppDimens.lg),
                decoration: BoxDecoration(
                  color: AppColors.statusSick.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimens.rMd),
                ),
                child: Icon(AppIcons.trash, color: AppColors.statusSick, size: 20),
              ),
              child: card,
            )
          : card,
    );
  }
}
