import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/n_panel.dart';
import '../../core/widgets/n_section_header.dart';
import '../../data/database/app_database.dart';
import '../../domain/entities/enums.dart';
import '../../domain/services/pay_service.dart';
import '../common/undo.dart';
import '../providers/app_providers.dart';

/// Справочник окладов: суммы по тарифным разрядам и воинским званиям.
/// Редактируется командиром, обновляется при индексации (приказ 365 и т.п.).
class PayRatesScreen extends ConsumerWidget {
  const PayRatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rates = ref.watch(payRatesProvider).value ?? const [];
    final ranks = rates.where((r) => r.kind == PayRateKind.rank).toList();
    final tariffs = rates.where((r) => r.kind == PayRateKind.tariff).toList()
      ..sort((a, b) => (int.tryParse(a.code) ?? 0).compareTo(int.tryParse(b.code) ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: Text('Справочник окладов', style: AppTypography.title),
        leading: IconButton(
          icon: Icon(AppIcons.arrowLeft, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (rates.isNotEmpty)
            IconButton(
              tooltip: 'Очистить справочник',
              icon: Icon(AppIcons.trash, color: AppColors.statusSick),
              onPressed: () => _confirmClear(context, ref),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppDimens.xxl),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.lg),
            child: Text(
              'Суммы предзаполнены на 01.10.2025 из открытых источников — '
              'СВЕРЬТЕ с приказами Росгвардии. Нажмите на строку, чтобы изменить '
              'оклад; смахните влево, чтобы удалить. «Очистить справочник» вверху '
              'обнулит всё — тогда введёте свои значения.',
              style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary),
            ),
          ),
          if (rates.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppDimens.xl),
              child: Text('Справочник пуст. Добавьте оклады по званиям и разрядам.',
                  style: AppTypography.caption, textAlign: TextAlign.center),
            ),
          NSectionHeader('Оклады по званию · ${ranks.length}'),
          for (final r in ranks) _row(context, ref, r, r.code),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.xs, AppDimens.lg, AppDimens.md),
            child: _addBtn('Добавить звание', () => _addRank(context, ref)),
          ),
          NSectionHeader('Оклады по тарифным разрядам · ${tariffs.length}'),
          for (final r in tariffs) _row(context, ref, r, '${r.code}-й разряд'),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.xs, AppDimens.lg, AppDimens.md),
            child: _addBtn('Добавить разряд', () => _addTariff(context, ref)),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, WidgetRef ref, PayRateRow r, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, 0, AppDimens.lg, AppDimens.xs),
      child: Dismissible(
        key: ValueKey('rate${r.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) async {
          final db = ref.read(appDatabaseProvider);
          await db.deletePayRate(r.id);
          if (context.mounted) {
            showUndoSnackBar(context,
                label: 'Оклад удалён из справочника',
                onUndo: () => db.restorePayRate(r));
          }
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppDimens.lg),
          decoration: BoxDecoration(
            color: AppColors.statusSick.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppDimens.rMd),
          ),
          child: Icon(AppIcons.trash, color: AppColors.statusSick, size: 20),
        ),
        child: NPanel(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: AppDimens.sm),
          onTap: () => _editAmount(context, ref, r, title),
          child: Row(
            children: [
              Expanded(child: Text(title, style: AppTypography.data)),
              Text(formatRub(r.amount),
                  style: AppTypography.data.copyWith(color: AppColors.accentPrimary)),
              const SizedBox(width: AppDimens.sm),
              Icon(AppIcons.pencilSimple, size: 14, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.statusSick),
        ),
        title: Text('Очистить справочник?',
            style: AppTypography.title.copyWith(color: AppColors.statusSick)),
        content: Text('Все оклады по званиям и разрядам будут удалены. '
            'Введёте свои значения вручную. Отменить нельзя.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
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
    if (ok == true) await ref.read(appDatabaseProvider).clearPayRates();
  }

  Widget _addBtn(String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(AppIcons.plus, size: 16, color: AppColors.accentPrimary),
            const SizedBox(width: 6),
            Text(label, style: AppTypography.data.copyWith(color: AppColors.accentPrimary)),
          ],
        ),
      );

  Future<void> _editAmount(
      BuildContext context, WidgetRef ref, PayRateRow r, String title) async {
    final amount = await _askAmount(context, title, r.amount);
    if (amount == null) return;
    await ref.read(appDatabaseProvider).upsertPayRate(r.kind, r.code, amount);
  }

  Future<void> _addRank(BuildContext context, WidgetRef ref) async {
    final name = await _askText(context, 'Новое звание', 'напр. старший сержант');
    if (name == null || name.trim().isEmpty) return;
    if (!context.mounted) return;
    final amount = await _askAmount(context, name, 0);
    if (amount == null) return;
    await ref.read(appDatabaseProvider)
        .upsertPayRate(PayRateKind.rank, name.trim().toLowerCase(), amount);
  }

  Future<void> _addTariff(BuildContext context, WidgetRef ref) async {
    final num = await _askText(context, 'Номер разряда', '1–50', digitsOnly: true);
    if (num == null || num.trim().isEmpty) return;
    if (!context.mounted) return;
    final amount = await _askAmount(context, '$num-й разряд', 0);
    if (amount == null) return;
    await ref.read(appDatabaseProvider)
        .upsertPayRate(PayRateKind.tariff, num.trim(), amount);
  }

  Future<int?> _askAmount(BuildContext context, String title, int initial) {
    final ctrl = TextEditingController(text: initial == 0 ? '' : '$initial');
    return showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.stroke),
        ),
        title: Text(title, style: AppTypography.title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTypography.data.copyWith(color: AppColors.textPrimary),
          decoration: const InputDecoration(suffixText: '₽'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, int.tryParse(ctrl.text.trim()) ?? 0),
            child: Text('Сохранить', style: AppTypography.body.copyWith(color: AppColors.accentPrimary)),
          ),
        ],
      ),
    );
  }

  Future<String?> _askText(BuildContext context, String title, String hint,
      {bool digitsOnly = false}) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.stroke),
        ),
        title: Text(title, style: AppTypography.title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: digitsOnly ? TextInputType.number : TextInputType.text,
          inputFormatters: digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
          style: AppTypography.data.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: Text('Далее', style: AppTypography.body.copyWith(color: AppColors.accentPrimary)),
          ),
        ],
      ),
    );
  }
}
