import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:narmb_ls/core/widgets/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/n_indicators.dart';
import '../../core/widgets/n_panel.dart';
import '../../core/widgets/n_section_header.dart';
import '../../data/database/app_database.dart';
import '../../data/models/soldier_view.dart';
import '../../domain/entities/enums.dart';
import '../../domain/services/leave_service.dart';
import '../../domain/services/roster_service.dart';
import '../common/screen_header.dart';
import '../common/soldier_picker.dart';
import '../common/undo.dart';
import '../providers/app_providers.dart';
import 'widgets/leave_form_sheet.dart';

/// Экран «Отпуска». «Сейчас в отпуске» тянется из отметок в «Составе»
/// (статус = отпуск), даты правятся здесь.
class LeavesScreen extends ConsumerWidget {
  const LeavesScreen({super.key});

  static DateTime _d(DateTime x) => DateTime(x.year, x.month, x.day);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaves = ref.watch(allLeavesProvider).value ?? const [];
    final roster = ref.watch(effectiveRosterProvider).value ?? const [];
    final today = _d(ref.watch(todayProvider));

    // Отпуска по бойцам.
    final byPerson = <int, List<LeaveRow>>{};
    for (final l in leaves) {
      byPerson.putIfAbsent(l.personnelId, () => []).add(l);
    }

    bool overlaps(LeaveRow l) =>
        l.status != LeaveStatus.cancelled &&
        (l.startDate == null || !today.isBefore(_d(l.startDate!))) &&
        (l.endDate == null || !today.isAfter(_d(l.endDate!)));
    bool planned(LeaveRow l) =>
        l.status != LeaveStatus.cancelled &&
        l.status != LeaveStatus.completed &&
        l.startDate != null &&
        _d(l.startDate!).isAfter(today);

    LeaveRow? activeLeaveFor(int pid) {
      for (final l in byPerson[pid] ?? const <LeaveRow>[]) {
        if (overlaps(l)) return l;
      }
      return null;
    }

    // Кто отмечен в «Составе» как «отпуск».
    final onLeave = roster.where((s) => s.status == PersonnelStatus.leave).toList()
      ..sort((a, b) => a.view.position.slot.compareTo(b.view.position.slot));

    final persons = {for (final s in roster) if (s.view.person != null) s.view.person!.id: s.view};
    // Только записи бойцов в активном штате (исключённые не протекают в счётчики).
    final plannedList = leaves.where((l) => planned(l) && persons.containsKey(l.personnelId)).toList()
      ..sort((a, b) => (a.startDate ?? today).compareTo(b.startDate ?? today));

    var exhausted = 0;
    for (final s in roster) {
      final p = s.view.person;
      if (p == null) continue;
      if (LeaveBalance.of(p, byPerson[p.id] ?? const []).exhausted) exhausted++;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final person = await pickSoldier(context, ref, title: 'Кому оформить отпуск');
          if (person != null && context.mounted) {
            await showLeaveForm(context, person.id);
          }
        },
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: AppColors.bgPage,
        icon: Icon(AppIcons.plus),
        label: Text('ОТПУСК', style: AppTypography.title.copyWith(fontSize: 12, color: AppColors.bgPage)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          const ScreenHeader(title: 'Отпуска'),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
            child: Row(
              children: [
                _metric('СЕЙЧАС', onLeave.length, AppColors.statusLeave),
                const SizedBox(width: AppDimens.md),
                _metric('ПЛАН', plannedList.length, AppColors.textPrimary),
                const SizedBox(width: AppDimens.md),
                _metric('ИСЧЕРПАЛИ', exhausted, AppColors.statusSick),
              ],
            ),
          ),
          const NSectionHeader('В отпуске сейчас', color: AppColors.accentPrimary),
          if (onLeave.isEmpty)
            _empty('Отметьте бойца «Отпуск» в Составе — появится здесь')
          else
            for (final s in onLeave)
              _onLeaveCard(context, ref, s, activeLeaveFor(s.view.person!.id), today),
          const NSectionHeader('Запланированы'),
          if (plannedList.isEmpty)
            _empty('Запланированных отпусков нет')
          else
            for (final l in plannedList) _plannedCard(context, ref, persons[l.personnelId], l, today),
        ],
      ),
    );
  }

  Widget _metric(String label, int value, Color color) {
    return Expanded(
      child: NPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$value', style: AppTypography.counter.copyWith(fontSize: 26, color: color)),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.label),
          ],
        ),
      ),
    );
  }

  Widget _empty(String text) => Padding(
        padding: const EdgeInsets.all(AppDimens.xl),
        child: Text(text, textAlign: TextAlign.center, style: AppTypography.caption),
      );

  /// Карточка бойца «в отпуске»: с датами (если заведён отпуск) или призывом
  /// заполнить. Тап открывает форму (правка/создание).
  Widget _swipeStatus(IconData icon, String label, Color color, VoidCallback cb) {
    return CustomSlidableAction(
      onPressed: (_) => cb(),
      backgroundColor: AppColors.bgRaised,
      foregroundColor: color,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.navLabel.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _onLeaveCard(BuildContext context, WidgetRef ref, EffectiveSoldier s, LeaveRow? leave, DateTime today) {
    final name = s.view.displayName;
    final personId = s.view.person!.id;
    void set(PersonnelStatus st) =>
        ref.read(appDatabaseProvider).returnFromLeave(personId, st, today);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, 0, AppDimens.lg, AppDimens.sm),
      child: Slidable(
        key: ValueKey('leave$personId'),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.72,
          children: [
            _swipeStatus(AppIcons.checkCircle, 'НАЛИЦО', AppColors.accentPrimary, () => set(PersonnelStatus.here)),
            _swipeStatus(AppIcons.airplaneTilt, 'КОМАНД.', AppColors.statusTrip, () => set(PersonnelStatus.trip)),
            _swipeStatus(AppIcons.firstAid, 'БОЛЕН', AppColors.statusSick, () => set(PersonnelStatus.sick)),
          ],
        ),
        child: NPanel(
        border: AppColors.statusLeave,
        onTap: () => showLeaveForm(context, personId, leave: leave),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusLed(AppColors.statusLeave),
                const SizedBox(width: AppDimens.sm),
                Expanded(child: Text(name, style: AppTypography.name)),
                if (leave != null)
                  NTag(leave.type.label, color: AppColors.statusLeave)
                else
                  NTag('нет дат', color: AppColors.statusSick),
              ],
            ),
            const SizedBox(height: 6),
            if (leave != null) ...[
              Text('${_range(leave.startDate, leave.endDate)} · ${Fmt.days(leave.daysGranted)}',
                  style: AppTypography.dataSmall),
              const SizedBox(height: 3),
              if (leave.endDate != null)
                Text('осталось ${Fmt.days(_d(leave.endDate!).difference(today).inDays)}',
                    style: AppTypography.data.copyWith(color: AppColors.accentPrimary))
              else
                Text('без даты возврата',
                    style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
            ] else
              Row(
                children: [
                  Icon(AppIcons.calendar, size: 14, color: AppColors.statusTrip),
                  const SizedBox(width: 6),
                  Text('Нажмите, чтобы указать даты отпуска',
                      style: AppTypography.caption.copyWith(color: AppColors.statusTrip)),
                ],
              ),
          ],
        ),
        ),
      ),
    );
  }

  static String _range(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 'даты не указаны';
    return '${a == null ? '…' : Fmt.short(a)} → ${b == null ? '…' : Fmt.short(b)}';
  }

  Widget _plannedCard(BuildContext context, WidgetRef ref, SoldierView? view, LeaveRow l, DateTime today) {
    final name = view?.displayName ?? '—';
    final untilStart = l.startDate == null ? null : _d(l.startDate!).difference(today).inDays;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, 0, AppDimens.lg, AppDimens.sm),
      child: Dismissible(
        key: ValueKey('pleave${l.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) async {
          final db = ref.read(appDatabaseProvider);
          await db.deleteLeave(l.id);
          if (context.mounted) {
            showUndoSnackBar(context,
                label: 'Отпуск убран из запланированных',
                onUndo: () => db.restoreLeave(l));
          }
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppDimens.lg),
          decoration: BoxDecoration(
            color: AppColors.statusSick.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppDimens.rMd),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Icon(AppIcons.trash, color: AppColors.statusSick, size: 18),
            const SizedBox(width: 6),
            Text('убрать', style: AppTypography.navLabel.copyWith(color: AppColors.statusSick)),
          ]),
        ),
        child: NPanel(
        onTap: () => showLeaveForm(context, l.personnelId, leave: l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(name, style: AppTypography.name)),
                NTag(l.type.label, color: AppColors.statusLeave),
              ],
            ),
            const SizedBox(height: 5),
            Text('${_range(l.startDate, l.endDate)} · ${Fmt.days(l.daysGranted)}',
                style: AppTypography.dataSmall),
            const SizedBox(height: 3),
            if (untilStart != null)
              Text('через ${Fmt.days(untilStart)}',
                  style: AppTypography.data.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        ),
      ),
    );
  }
}
