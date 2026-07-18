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
import '../../domain/entities/enums.dart';
import '../../data/models/soldier_view.dart';
import '../../domain/services/roster_service.dart';
import '../common/screen_header.dart';
import '../common/soldier_picker.dart';
import '../common/undo.dart';
import '../providers/app_providers.dart';
import 'widgets/trip_form_sheet.dart';

/// Экран «Командировки» — активные и запланированные.
class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  static DateTime _d(DateTime x) => DateTime(x.year, x.month, x.day);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(allTripsProvider).value ?? const [];
    final roster = ref.watch(effectiveRosterProvider).value ?? const [];
    final today = _d(ref.watch(todayProvider));

    final persons = {for (final s in roster) if (s.view.person != null) s.view.person!.id: s.view};

    final byPerson = <int, List<TripRow>>{};
    for (final t in trips) {
      byPerson.putIfAbsent(t.personnelId, () => []).add(t);
    }

    // Даты необязательны: нет начала — считаем начатой; нет конца — открытая.
    bool overlaps(TripRow t) =>
        t.status != TripStatus.completed &&
        (t.startDate == null || !today.isBefore(_d(t.startDate!))) &&
        (t.endDate == null || !today.isAfter(_d(t.endDate!)));
    bool planned(TripRow t) =>
        t.status != TripStatus.completed &&
        t.startDate != null &&
        _d(t.startDate!).isAfter(today);

    TripRow? activeTripFor(int pid) {
      for (final t in byPerson[pid] ?? const <TripRow>[]) {
        if (overlaps(t)) return t;
      }
      return null;
    }

    // Кто отмечен в «Составе» как «командировка».
    final onTrip = roster.where((s) => s.status == PersonnelStatus.trip).toList()
      ..sort((a, b) => a.view.position.slot.compareTo(b.view.position.slot));

    final plannedList = trips.where((t) => planned(t) && persons.containsKey(t.personnelId)).toList()
      ..sort((a, b) => (a.startDate ?? today).compareTo(b.startDate ?? today));

    // Полная сверка по штату: каждый боец/должность попадает ровно в одну
    // графу, сумма = штат.
    final total = roster.length; // по штату
    final vacant = roster.where((s) => s.isVacant).length;
    final inTripNow = onTrip.length; // уже в командировке (статус «командировка»)
    // Планируется убыть — уникальные бойцы с будущей командировкой, которые
    // СЕЙЧАС ещё не в командировке (убудут дополнительно).
    final plannedIds = plannedList.map((t) => t.personnelId).toSet();
    final plannedDepart = roster
        .where((s) =>
            !s.isVacant &&
            s.status != PersonnelStatus.trip &&
            plannedIds.contains(s.view.person?.id))
        .length;
    // Налицо (на месте), не считая тех, кто запланирован к убытию.
    final present = roster
        .where((s) =>
            s.status == PersonnelStatus.here &&
            !plannedIds.contains(s.view.person?.id))
        .length;
    // Прочие в ППД: больные, отпуск и вакантные должности (за вычетом уже
    // учтённых). Считается как остаток, поэтому сумма всегда сходится к штату.
    final other = total - inTripNow - plannedDepart - present;
    // Останется в ППД после убытия запланированных = налицо + прочие.
    final remainInPPD = present + other;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final person = await pickSoldier(context, ref, title: 'Кого в командировку');
          if (person != null && context.mounted) {
            await showTripForm(context, person.id);
          }
        },
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: AppColors.bgPage,
        icon: Icon(AppIcons.plus),
        label: Text('КОМАНД.', style: AppTypography.title.copyWith(fontSize: 12, color: AppColors.bgPage)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          const ScreenHeader(title: 'Командировки'),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
            child: Row(
              children: [
                _metric('В КОМАНД.', inTripNow, AppColors.statusTrip),
                const SizedBox(width: AppDimens.md),
                _metric('ПЛАН УБЫТИЯ', plannedDepart, AppColors.statusLeave),
                const SizedBox(width: AppDimens.md),
                _metric('В ППД', remainInPPD, AppColors.accentPrimary),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, 0),
            child: NPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(AppIcons.mapForward, size: 16, color: AppColors.statusTrip),
                      const SizedBox(width: AppDimens.sm),
                      Text('Сверка по штату', style: AppTypography.label),
                    ],
                  ),
                  const SizedBox(height: AppDimens.sm),
                  _forecastRow('По штату', total, AppColors.textPrimary),
                  const Divider(height: AppDimens.md, color: AppColors.stroke),
                  _forecastRow('В командировке', inTripNow, AppColors.statusTrip),
                  _forecastRow('Планируется убыть', plannedDepart, AppColors.statusLeave),
                  _forecastRow('Налицо (на месте)', present, AppColors.accentPrimary),
                  _forecastRow('Больные / отпуск / ваканты', other, AppColors.textSecondary),
                  const Divider(height: AppDimens.md, color: AppColors.stroke),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Останется в ППД (налицо + прочие)', style: AppTypography.caption),
                      ),
                      Text(Fmt.people(remainInPPD),
                          style: AppTypography.data.copyWith(
                              color: AppColors.accentPrimary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  if (vacant > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: AppDimens.xs),
                      child: Text('в т.ч. вакантных должностей: $vacant',
                          style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimens.xs),
                    child: Text('ППД — пункт постоянной дислокации',
                        style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
                  ),
                ],
              ),
            ),
          ),
          const NSectionHeader('В командировке', color: AppColors.accentPrimary),
          if (onTrip.isEmpty)
            _empty('Отметьте бойца «Командировка» в Составе — появится здесь')
          else
            for (final s in onTrip)
              _onTripCard(context, ref, s, activeTripFor(s.view.person!.id), today),
          const NSectionHeader('Запланированы'),
          if (plannedList.isEmpty)
            _empty('Запланированных нет')
          else
            for (final t in plannedList) _plannedTripCard(context, ref, persons[t.personnelId], t, today),
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

  Widget _forecastRow(String label, int value, Color color) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTypography.dataSmall.copyWith(color: AppColors.textSecondary))),
            Text('$value', style: AppTypography.data.copyWith(color: color)),
          ],
        ),
      );

  /// Действие свайпа: сменить статус бойца (вернуть из командировки).
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

  /// Боец, отмеченный «командировка»: с деталями или призывом заполнить.
  Widget _onTripCard(BuildContext context, WidgetRef ref, EffectiveSoldier s, TripRow? t, DateTime today) {
    final name = s.view.displayName;
    final personId = s.view.person!.id;
    void set(PersonnelStatus st) =>
        ref.read(appDatabaseProvider).returnFromTrip(personId, st, today);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, 0, AppDimens.lg, AppDimens.sm),
      child: Slidable(
        key: ValueKey('trip$personId'),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.72,
          children: [
            _swipeStatus(AppIcons.checkCircle, 'НАЛИЦО', AppColors.accentPrimary, () => set(PersonnelStatus.here)),
            _swipeStatus(AppIcons.umbrella, 'ОТПУСК', AppColors.statusLeave, () => set(PersonnelStatus.leave)),
            _swipeStatus(AppIcons.firstAid, 'БОЛЕН', AppColors.statusSick, () => set(PersonnelStatus.sick)),
          ],
        ),
        child: NPanel(
        border: AppColors.statusTrip,
        onTap: () => showTripForm(context, personId, trip: t),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusLed(AppColors.statusTrip),
                const SizedBox(width: AppDimens.sm),
                Expanded(child: Text(name, style: AppTypography.name)),
                if (t != null)
                  NTag('Активна', color: AppColors.statusTrip)
                else
                  NTag('нет данных', color: AppColors.statusSick),
              ],
            ),
            const SizedBox(height: 6),
            if (t != null) ...[
              Row(
                children: [
                  Icon(AppIcons.mapPin, size: 13, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text('${t.destination}${t.purpose.isNotEmpty ? ' · ${t.purpose}' : ''}',
                        style: AppTypography.caption),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(_dateRange(t.startDate, t.endDate), style: AppTypography.dataSmall),
              const SizedBox(height: 3),
              if (t.endDate != null)
                Text('осталось ${Fmt.days(_d(t.endDate!).difference(today).inDays)}',
                    style: AppTypography.data.copyWith(color: AppColors.accentPrimary))
              else
                Text('без даты возврата',
                    style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
            ] else
              Row(
                children: [
                  Icon(AppIcons.calendar, size: 14, color: AppColors.statusTrip),
                  const SizedBox(width: 6),
                  Text('Нажмите, чтобы указать место и сроки',
                      style: AppTypography.caption.copyWith(color: AppColors.statusTrip)),
                ],
              ),
          ],
        ),
        ),
      ),
    );
  }

  static String _dateRange(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 'даты не указаны';
    return '${a == null ? '…' : Fmt.short(a)} → ${b == null ? '…' : Fmt.short(b)}';
  }

  Widget _plannedTripCard(BuildContext context, WidgetRef ref, SoldierView? view, TripRow t, DateTime today) {
    final name = view?.displayName ?? '—';
    final untilStart = t.startDate == null ? null : _d(t.startDate!).difference(today).inDays;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, 0, AppDimens.lg, AppDimens.sm),
      child: Dismissible(
        key: ValueKey('ptrip${t.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) async {
          final db = ref.read(appDatabaseProvider);
          await db.deleteTrip(t.id);
          if (context.mounted) {
            showUndoSnackBar(context,
                label: 'Командировка убрана из запланированных',
                onUndo: () => db.restoreTrip(t));
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
        onTap: () => showTripForm(context, t.personnelId, trip: t),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(name, style: AppTypography.name)),
                NTag('План', color: AppColors.statusLeave),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(AppIcons.mapPin, size: 13, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text('${t.destination}${t.purpose.isNotEmpty ? ' · ${t.purpose}' : ''}',
                      style: AppTypography.caption),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(_dateRange(t.startDate, t.endDate), style: AppTypography.dataSmall),
            const SizedBox(height: 3),
            if (untilStart != null)
              Text('через ${Fmt.days(untilStart)}', style: AppTypography.data.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        ),
      ),
    );
  }
}
