import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:narmb_ls/core/widgets/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/n_indicators.dart';
import '../../core/widgets/n_panel.dart';
import '../../core/widgets/n_section_header.dart';
import '../../core/widgets/rolling_counter.dart';
import '../../domain/entities/enums.dart';
import '../../domain/services/roster_service.dart';
import '../common/status_ui.dart';
import '../providers/app_providers.dart';
import '../reports/export_service.dart';
import '../pay/pay_calculator_screen.dart';
import '../pay/service_calc_screen.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_screen.dart';

/// Главный экран «Расход ЛС» — строевая записка с разбивкой по категориям.
class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  Object? _expanded; // PersonnelStatus либо 'vacant'

  String _unit() => ref.read(settingsProvider).value?.unitName ?? '';

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(rosterStatsProvider);
    final now = ref.watch(todayProvider);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppDimens.xl),
        children: [
          _tabelHeader(context, now),
          statsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(AppDimens.xxl),
              child: Center(child: CircularProgressIndicator(color: AppColors.accentPrimary)),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(AppDimens.xl),
              child: Text('Ошибка: $e', style: AppTypography.caption),
            ),
            data: (stats) => _content(stats, now),
          ),
          _birthdays(ref.watch(effectiveRosterProvider).value ?? const [], now),
        ],
      ),
    );
  }

  /// Шапка «Расхода» с крупным вордмарком «Табель».
  Widget _tabelHeader(BuildContext context, DateTime now) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.lg,
        MediaQuery.of(context).padding.top + AppDimens.md,
        AppDimens.lg,
        AppDimens.md,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bgHeader, AppColors.bgPage],
        ),
        border: Border(bottom: BorderSide(color: AppColors.stroke, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text('Табель', style: AppTypography.wordmark())),
              IconButton(
                tooltip: 'Калькулятор ДД',
                icon: Icon(AppIcons.wallet, color: AppColors.textSecondary),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PayCalculatorScreen()),
                ),
              ),
              IconButton(
                tooltip: 'Калькулятор выслуги',
                icon: Icon(AppIcons.hourglass, color: AppColors.textSecondary),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ServiceCalcScreen()),
                ),
              ),
              IconButton(
                icon: Icon(AppIcons.settings, color: AppColors.textSecondary),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text('Строевая записка · ${Fmt.stamp(now)}', style: AppTypography.data),
        ],
      ),
    );
  }

  /// Дни рождения в текущем месяце.
  Widget _birthdays(List<EffectiveSoldier> roster, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final items = <(String, DateTime, int)>[]; // имя, дата ДР, дней до
    for (final s in roster) {
      final p = s.view.person;
      final bd = p?.birthDate;
      if (bd == null || bd.month != now.month) continue;
      // 29 февраля в невисокосный год привязываем к последнему дню месяца.
      final lastDay = DateTime(now.year, bd.month + 1, 0).day;
      final thisYear = DateTime(now.year, bd.month, bd.day.clamp(1, lastDay));
      items.add((s.view.displayName, bd, thisYear.difference(today).inDays));
    }
    items.sort((a, b) => a.$2.day.compareTo(b.$2.day));

    return Column(
      children: [
        NSectionHeader('Дни рождения · ${Fmt.monthName(now)}', color: AppColors.accentPrimary),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: Text('В этом месяце нет', style: AppTypography.caption),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NPanel(
              padding: const EdgeInsets.symmetric(vertical: AppDimens.xs),
              child: Column(
                children: [
                  for (final it in items) _birthdayRow(it.$1, it.$2, it.$3),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _birthdayRow(String name, DateTime bd, int daysUntil) {
    final soon = daysUntil >= 0 && daysUntil <= 7;
    final today = daysUntil == 0;
    final color = today
        ? AppColors.accentBright
        : soon
            ? AppColors.statusTrip
            : AppColors.textSecondary;
    final note = today
        ? 'сегодня!'
        : daysUntil > 0
            ? 'через ${Fmt.days(daysUntil)}'
            : 'прошёл';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: 9),
      child: Row(
        children: [
          Icon(AppIcons.cake, size: 16, color: color),
          const SizedBox(width: AppDimens.md),
          SizedBox(
            width: 48,
            child: Text(Fmt.dayMonth(bd), style: AppTypography.data.copyWith(color: color)),
          ),
          const SizedBox(width: AppDimens.sm),
          Expanded(child: Text(name, style: AppTypography.name)),
          Text(note, style: AppTypography.dataSmall.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _content(RosterStats stats, DateTime now) {
    return Column(
      children: [
        // Три прибора.
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
          child: Row(
            children: [
              _gauge('ПО ШТАТУ', stats.total, AppColors.textPrimary),
              const SizedBox(width: AppDimens.md),
              _gauge('НАЛИЦО', stats.here, AppColors.accentBright, glow: true),
              const SizedBox(width: AppDimens.md),
              _gauge('ПО СПИСКУ', stats.list, AppColors.textPrimary),
            ],
          ),
        ),
        const NSectionHeader('Распределение', color: AppColors.accentPrimary),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
          child: NPanel(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.xs),
            child: Column(
              children: [
                for (final st in PersonnelStatus.values)
                  _statusRow(st, st.label, st.color, stats.count(st), stats.total,
                      stats.statusByCategory[st] ?? const {}),
                _statusRow('vacant', 'Вакант', AppColors.statusVacant, stats.vacant,
                    stats.total, stats.vacantByCategory,
                    dim: true),
              ],
            ),
          ),
        ),
        const NSectionHeader('Документы', color: AppColors.accentPrimary),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
          child: Row(
            children: [
              _docBtn(AppIcons.filePdf, 'СТРОЕВАЯ\nPDF', () async {
                final roster = await ref.read(appDatabaseProvider).getRoster();
                await ExportService.exportRosterPdf(roster, stats, now, unitName: _unit());
              }),
              const SizedBox(width: AppDimens.md),
              _docBtn(AppIcons.fileXls, 'СПИСОК\nXLS', () async {
                final roster = await ref.read(appDatabaseProvider).getRoster();
                await ExportService.exportRosterExcel(roster, now, unitName: _unit());
              }),
              const SizedBox(width: AppDimens.md),
              _docBtn(AppIcons.shareNetwork, 'ТЕКСТ\nВ ЧАТ', () => ExportService.shareStrevoyaText(stats, now, unitName: _unit())),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gauge(String label, int value, Color color, {bool glow = false}) {
    return Expanded(
      child: NPanel(
        glow: glow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.label),
            const SizedBox(height: 6),
            RollingCounter(value, style: AppTypography.counter.copyWith(color: color, fontSize: 36)),
          ],
        ),
      ),
    );
  }

  Widget _statusRow(Object key, String label, Color color, int count, int total,
      Map<RankCategory, int> byCat, {bool dim = false}) {
    final expanded = _expanded == key;
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = expanded ? null : key),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: AppDimens.md),
            child: Row(
              children: [
                StatusLed(color),
                const SizedBox(width: AppDimens.md),
                SizedBox(
                  width: 108,
                  child: Text(label,
                      style: AppTypography.data.copyWith(
                          color: dim ? AppColors.textSecondary : AppColors.textPrimary)),
                ),
                SizedBox(
                  width: 24,
                  child: Text('$count',
                      textAlign: TextAlign.right,
                      style: AppTypography.data.copyWith(color: color)),
                ),
                const SizedBox(width: AppDimens.md),
                Expanded(child: NProgressTrack(fraction: total == 0 ? 0 : count / total, color: color)),
                const SizedBox(width: AppDimens.sm),
                Icon(expanded ? AppIcons.caretUp : AppIcons.caretDown,
                    size: 14, color: expanded ? AppColors.accentPrimary : AppColors.textTertiary),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: _breakdown(byCat),
          secondChild: const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  Widget _breakdown(Map<RankCategory, int> byCat) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppDimens.md, 0, AppDimens.md, AppDimens.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: AppDimens.sm),
      decoration: BoxDecoration(
        color: AppColors.bgPage,
        borderRadius: BorderRadius.circular(AppDimens.rMd),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        children: [
          for (final c in RankCategory.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(c.plural, style: AppTypography.dataSmall.copyWith(color: c.color)),
                  Text('${byCat[c] ?? 0}',
                      style: AppTypography.data.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _docBtn(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: NPanel(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(vertical: AppDimens.md, horizontal: AppDimens.sm),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.accentPrimary),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: AppTypography.label.copyWith(color: AppColors.accentPrimary, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
