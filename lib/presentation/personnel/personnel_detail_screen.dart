import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/award_catalog.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/n_button.dart';
import '../../core/widgets/n_indicators.dart';
import '../../core/widgets/n_panel.dart';
import '../../core/widgets/n_section_header.dart';
import '../../data/database/app_database.dart';
import '../../domain/entities/enums.dart';
import '../../domain/services/contract_service.dart';
import '../../domain/services/leave_service.dart';
import '../../domain/services/service_service.dart';
import '../leaves/widgets/leave_form_sheet.dart';
import '../trips/trip_journal_screen.dart';
import '../trips/widgets/trip_form_sheet.dart';
import '../weapons/widgets/weapon_form_sheet.dart';
import '../common/status_ui.dart';
import '../common/undo.dart';
import '../providers/app_providers.dart';
import 'widgets/award_picker_sheet.dart';
import 'widgets/person_edit_sheet.dart';
import 'widgets/service_periods_sheet.dart';

/// Диапазон дат с учётом необязательных значений («…» вместо пустой даты).
String _dateRange(DateTime? a, DateTime? b) {
  if (a == null && b == null) return 'даты не указаны';
  return '${a == null ? '…' : Fmt.short(a)} → ${b == null ? '…' : Fmt.short(b)}';
}

/// Детальный профиль бойца — вся информация одним экраном (без вкладок).
class PersonnelDetailScreen extends ConsumerWidget {
  const PersonnelDetailScreen({super.key, required this.personId});

  final int personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soldier = ref.watch(soldierByPersonProvider(personId));
    if (soldier == null || soldier.view.person == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Боец не найден', style: AppTypography.caption)),
      );
    }
    final view = soldier.view;
    final person = view.person!;
    final pos = view.position;

    return Scaffold(
      body: Column(
        children: [
          _appBar(context, view, pos, person),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppDimens.xxl),
              children: [
                _topPanels(person, soldier.status!),
                _contractPanel(person),
                _serviceSection(context, ref, person, pos),
                _dataSection(person, pos),
                _awardsSection(context, ref),
                _leavesSection(context, ref, person),
                _tripsSection(context, ref),
                _weaponsSection(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Шапка ──
  Widget _appBar(BuildContext context, view, PositionRow pos, PersonRow person) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.md,
        MediaQuery.of(context).padding.top + AppDimens.sm,
        AppDimens.md,
        AppDimens.md,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bgHeader, AppColors.bgPage],
        ),
        border: Border(bottom: BorderSide(color: AppColors.stroke)),
      ),
      child: Row(
        children: [
          _iconBtn(AppIcons.arrowLeft, () => context.pop()),
          const SizedBox(width: AppDimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(view.displayName, style: AppTypography.title),
                Text('${pos.subunit} · ${pos.title}', style: AppTypography.caption),
              ],
            ),
          ),
          _iconBtn(
            AppIcons.pencilSimple,
            () => showPersonEdit(context, position: pos, person: person),
            color: AppColors.accentPrimary,
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, {Color color = AppColors.textSecondary}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.rMd),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: AppDecorationsRef.iconBtn,
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  // ── Личный номер + статус ──
  Widget _topPanels(PersonRow person, PersonnelStatus status) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, 0),
      child: IntrinsicHeight(
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: NPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(AppIcons.idCard, size: 13, color: AppColors.accentDim),
                      const SizedBox(width: 5),
                      Text('ЛИЧНЫЙ НОМЕР', style: AppTypography.label),
                    ],
                  ),
                  const SizedBox(height: 8),
                  NLcd(child: Text(person.personalNumber ?? '—', style: AppTypography.lcd)),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppDimens.md),
          Expanded(
            child: NPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('СТАТУС', style: AppTypography.label),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      StatusLed(status.color),
                      const SizedBox(width: AppDimens.sm),
                      Text(status.label, style: AppTypography.data.copyWith(color: status.color)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(AppIcons.rank, size: 12, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(person.rank.isEmpty ? '—' : person.rank, style: AppTypography.dataSmall),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  // ── Контракт ──
  Widget _contractPanel(PersonRow person) {
    final state = ContractService.state(person.contractEnd);
    final days = ContractService.daysLeft(person.contractEnd);
    final hasHighlight = state == ContractState.soon || state == ContractState.expired;
    final color = state.color;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, 0),
      child: NPanel(
        padding: EdgeInsets.zero,
        clip: true,
        border: hasHighlight ? color : null,
        glow: hasHighlight,
        glowColor: color,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.md, AppDimens.sm, AppDimens.md, 0),
              child: Row(
                children: [
                  Icon(AppIcons.contract, size: 13, color: hasHighlight ? color : AppColors.accentDim),
                  const SizedBox(width: 5),
                  Text('КОНТРАКТ', style: AppTypography.label.copyWith(color: hasHighlight ? color : AppColors.textSecondary)),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(child: _contractCell('НАЧАЛО', person.contractStart, AppColors.textPrimary)),
                  Container(width: 1, color: AppColors.stroke),
                  Expanded(child: _contractCell('ОКОНЧАНИЕ', person.contractEnd, hasHighlight ? color : AppColors.textPrimary)),
                ],
              ),
            ),
            if (hasHighlight)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: AppDimens.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  border: const Border(top: BorderSide(color: AppColors.stroke)),
                ),
                child: Row(
                  children: [
                    Icon(AppIcons.warning, size: 15, color: color),
                    const SizedBox(width: AppDimens.sm),
                    Text(
                      state == ContractState.expired
                          ? 'Контракт истёк ${Fmt.days(days!.abs())} назад'
                          : 'Истекает через ${Fmt.days(days!)}',
                      style: AppTypography.caption.copyWith(color: color, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _contractCell(String label, DateTime? date, Color color) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label),
          const SizedBox(height: 5),
          Text(date == null ? 'не задана' : Fmt.short(date), style: AppTypography.data.copyWith(color: color)),
        ],
      ),
    );
  }

  // ── Выслуга лет ──
  Widget _serviceSection(
      BuildContext context, WidgetRef ref, PersonRow person, PositionRow pos) {
    final los = ref.watch(lengthOfServiceProvider(personId));
    final periods = ref.watch(servicePeriodsForProvider(personId)).value ?? const [];
    return Column(
      children: [
        const NSectionHeader('Выслуга лет'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
          child: NPanel(
            child: los == null
                ? InkWell(
                    onTap: () => showPersonEdit(context, position: pos, person: person),
                    child: Row(
                      children: [
                        Icon(AppIcons.calendar, size: 18, color: AppColors.textTertiary),
                        const SizedBox(width: AppDimens.md),
                        Expanded(
                          child: Text('Дата начала службы не указана',
                              style: AppTypography.caption),
                        ),
                        Text('заполнить',
                            style: AppTypography.dataSmall.copyWith(color: AppColors.accentPrimary)),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _losRow('Календарная', formatYmd(los.calendar), AppColors.textPrimary),
                      if (los.hasBonus) ...[
                        const SizedBox(height: 6),
                        _losRow('Льготная', formatYmd(los.preferential), AppColors.statusTrip),
                      ],
                      const Divider(height: AppDimens.lg, color: AppColors.stroke),
                      _losRow('Надбавка за выслугу', '${los.allowancePercent}%', AppColors.accentPrimary),
                      const SizedBox(height: 2),
                      Text('справочно, по календарной (свериться с приказом)',
                          style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
                      const SizedBox(height: AppDimens.sm),
                      Row(
                        children: [
                          Icon(los.pensionReached ? AppIcons.shield : AppIcons.calendar,
                              size: 14,
                              color: los.pensionReached ? AppColors.accentPrimary : AppColors.textSecondary),
                          const SizedBox(width: AppDimens.sm),
                          Expanded(
                            child: Text(
                              los.pensionReached
                                  ? 'Право на пенсию (20 лет) — есть'
                                  : 'До 20 лет выслуги: ${formatYmd(los.toPension)}',
                              style: AppTypography.dataSmall.copyWith(
                                  color: los.pensionReached ? AppColors.accentPrimary : AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.sm, AppDimens.lg, 0),
          child: NPanel(
            onTap: () => showServicePeriods(context, ref, personId),
            child: Row(
              children: [
                Icon(AppIcons.calendar, size: 16, color: AppColors.statusTrip),
                const SizedBox(width: AppDimens.md),
                Expanded(child: Text('Льготные периоды', style: AppTypography.data)),
                Text('${periods.length}',
                    style: AppTypography.data.copyWith(color: AppColors.textSecondary)),
                const SizedBox(width: AppDimens.sm),
                Icon(AppIcons.pencilSimple, size: 14, color: AppColors.accentPrimary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _losRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.caption),
        Text(value, style: AppTypography.data.copyWith(color: color)),
      ],
    );
  }

  // ── Данные ──
  Widget _dataSection(PersonRow person, PositionRow pos) {
    return Column(
      children: [
        const NSectionHeader('Личные данные'),
        _kvPanel([
          _kv(AppIcons.rank, 'Звание', person.rank.isEmpty ? '—' : person.rank),
          _kv(AppIcons.phone, 'Телефон', person.phone ?? '—'),
          _kv(AppIcons.mapPin, 'Адрес', person.address ?? '—'),
          _kv(AppIcons.heart, 'Семейное положение', person.maritalStatus?.label ?? '—'),
          _kv(AppIcons.baby, 'Детей', person.childrenCount.toString()),
          _kv(AppIcons.calendar, 'Дата рождения',
              person.birthDate == null ? '—' : Fmt.short(person.birthDate!)),
          _kv(AppIcons.medal, 'Квалификация',
              '${person.qualification ?? 'нет'}'
              '${person.qualificationDate != null ? ' · ${Fmt.short(person.qualificationDate!)}' : ''}'),
          if (person.isVeteran) _kv(AppIcons.shieldStar, 'Статус', 'Ветеран'),
        ]),
      ],
    );
  }

  Widget _kvPanel(List<Widget> rows) {
    final children = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      if (i > 0) children.add(const Divider(height: 1));
      children.add(rows[i]);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
      child: NPanel(padding: EdgeInsets.zero, clip: true, child: Column(children: children)),
    );
  }

  Widget _kv(IconData icon, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: AppDimens.md),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.accentDim),
          const SizedBox(width: AppDimens.md),
          Expanded(child: Text(key, style: AppTypography.caption)),
          const SizedBox(width: AppDimens.sm),
          Flexible(
            child: Text(value, textAlign: TextAlign.right, style: AppTypography.data.copyWith(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  // ── Награды ──
  Widget _awardsSection(BuildContext context, WidgetRef ref) {
    final awards = ref.watch(awardsProvider(personId)).value ?? const [];
    return Column(
      children: [
        NSectionHeader('Награды · ${awards.length}', color: AppColors.accentPrimary),
        if (awards.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NPanel(
              child: Column(
                children: [
                  Icon(AppIcons.medal, size: 30, color: AppColors.textTertiary),
                  const SizedBox(height: AppDimens.sm),
                  Text('Наград нет', style: AppTypography.caption),
                  const SizedBox(height: AppDimens.md),
                  NButton(
                    label: 'ВЫБРАТЬ НАГРАДУ',
                    icon: AppIcons.plus,
                    onPressed: () => showAwardPicker(context, ref, personId),
                  ),
                ],
              ),
            ),
          )
        else ...[
          for (final a in awards)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.lg, 0, AppDimens.lg, AppDimens.sm),
              child: NPanel(
                child: Row(
                  children: [
                    Icon(AppIcons.medal, size: 22,
                        color: a.kind == AwardKind.state ? AppColors.statusTrip : AppColors.accentPrimary),
                    const SizedBox(width: AppDimens.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.degree == null ? a.name : '${a.name} (${a.degree} ст.)', style: AppTypography.name),
                          const SizedBox(height: 2),
                          Text(
                            '${a.kind == AwardKind.state ? 'государственная' : 'ведомственная'}'
                            '${a.awardDate != null ? ' · ${Fmt.short(a.awardDate!)}' : ''}',
                            style: AppTypography.dataSmall,
                          ),
                        ],
                      ),
                    ),
                    NTag(a.kind.short, color: a.kind == AwardKind.state ? AppColors.statusTrip : AppColors.textTertiary),
                    _deleteBtn(context, 'награду', () => ref.read(appDatabaseProvider).deleteAward(a.id)),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.xs, AppDimens.lg, 0),
            child: NButton(
              label: 'ДОБАВИТЬ НАГРАДУ',
              icon: AppIcons.plus,
              outline: true,
              onPressed: () => showAwardPicker(context, ref, personId),
            ),
          ),
        ],
      ],
    );
  }

  // ── Отпуска ──
  Widget _leavesSection(BuildContext context, WidgetRef ref, PersonRow person) {
    final leaves = ref.watch(leavesForProvider(personId)).value ?? const [];
    final balance = LeaveBalance.of(person, leaves);
    return Column(
      children: [
        const NSectionHeader('Баланс отпусков'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
          child: NPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Отгуляно ${balance.totalUsed} из ${balance.totalLimit}', style: AppTypography.caption),
                    Text('${Fmt.days(balance.remaining)} остаток',
                        style: AppTypography.data.copyWith(
                            color: balance.exhausted ? AppColors.statusSick : AppColors.accentPrimary)),
                  ],
                ),
                const SizedBox(height: AppDimens.sm),
                NProgressTrack(fraction: balance.fraction, color: AppColors.statusLeave),
                const SizedBox(height: AppDimens.sm),
                Wrap(
                  spacing: AppDimens.md,
                  children: [
                    Text('осн. ${balance.usedMain}/${balance.limitMain}', style: AppTypography.dataSmall),
                    if (balance.limitAdditional > 0)
                      Text('доп. ${balance.usedAdditional}/${balance.limitAdditional}', style: AppTypography.dataSmall),
                    if (balance.limitVeteran > 0)
                      Text('ветер. ${balance.usedVeteran}/${balance.limitVeteran}', style: AppTypography.dataSmall),
                  ],
                ),
              ],
            ),
          ),
        ),
        NSectionHeader(
          'Отпуска · ${leaves.length}',
          color: AppColors.accentPrimary,
          trailing: _addBtn(() => showLeaveForm(context, personId)),
        ),
        if (leaves.isEmpty)
          _hint('Отпусков нет')
        else
          for (final l in leaves)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.lg, 0, AppDimens.lg, AppDimens.sm),
              child: NPanel(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(l.type.label, style: AppTypography.name),
                              const SizedBox(width: AppDimens.sm),
                              NTag(l.status.label, color: l.status.color),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text('${_dateRange(l.startDate, l.endDate)} · ${Fmt.days(l.daysGranted)}',
                              style: AppTypography.dataSmall),
                        ],
                      ),
                    ),
                    _deleteBtn(context, 'отпуск', () => ref.read(appDatabaseProvider).deleteLeave(l.id)),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  // ── Секция командировок ──
  Widget _tripsSection(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsForProvider(personId)).value ?? const [];
    return Column(
      children: [
        NSectionHeader(
          'Командировки · ${trips.length}',
          color: AppColors.accentPrimary,
          trailing: _addBtn(() => showTripForm(context, personId)),
        ),
        if (trips.isEmpty)
          _hint('Командировок нет')
        else ...[
          for (final t in trips)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.lg, 0, AppDimens.lg, AppDimens.sm),
              child: NPanel(
                onTap: () => showTripForm(context, personId, trip: t),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${t.destination}${t.purpose.isNotEmpty ? ' · ${t.purpose}' : ''}',
                              style: AppTypography.name),
                          const SizedBox(height: 3),
                          Text(_dateRange(t.startDate, t.endDate),
                              style: AppTypography.dataSmall),
                        ],
                      ),
                    ),
                    _deleteBtn(context, 'командировку', () => ref.read(appDatabaseProvider).deleteTrip(t.id)),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.xs, AppDimens.lg, 0),
            child: NPanel(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TripJournalScreen(personId: personId)),
              ),
              child: Row(
                children: [
                  Icon(AppIcons.airplaneTilt, size: 16, color: AppColors.accentPrimary),
                  const SizedBox(width: AppDimens.md),
                  Expanded(child: Text('Весь журнал командировок', style: AppTypography.data)),
                  Icon(AppIcons.caretDown, size: 16, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── Вооружение ──
  Widget _weaponsSection(BuildContext context, WidgetRef ref) {
    final weapons = ref.watch(weaponsForProvider(personId)).value ?? const [];
    return Column(
      children: [
        NSectionHeader(
          'Вооружение · ${weapons.length}',
          color: AppColors.accentPrimary,
          trailing: _addBtn(() => showWeaponForm(context, personId)),
        ),
        if (weapons.isEmpty)
          _hint('Ничего не закреплено')
        else
          for (final w in weapons)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.lg, 0, AppDimens.lg, AppDimens.sm),
              child: NPanel(
                child: IntrinsicHeight(
                  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CategoryBar(AppColors.accentDim),
                    const SizedBox(width: AppDimens.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(w.name, style: AppTypography.name),
                          const SizedBox(height: 2),
                          Text('${w.type.label}${w.serialNumber != null ? ' · № ${w.serialNumber}' : ''}',
                              style: AppTypography.dataSmall),
                        ],
                      ),
                    ),
                    _deleteBtn(context, 'оружие', () => ref.read(appDatabaseProvider).deleteWeapon(w.id)),
                  ],
                ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _hint(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
        child: Text(text, style: AppTypography.caption),
      );

  Widget _addBtn(VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Icon(AppIcons.plusCircle, size: 22, color: AppColors.accentPrimary),
      );

  Widget _deleteBtn(BuildContext context, String what, VoidCallback onTap) => IconButton(
        visualDensity: VisualDensity.compact,
        icon: Icon(AppIcons.trash, size: 16, color: AppColors.textTertiary),
        onPressed: () async {
          if (await confirmDelete(context, what: what)) onTap();
        },
      );
}

/// Небольшой набор общих декораций для этого экрана.
abstract final class AppDecorationsRef {
  static BoxDecoration get iconBtn => BoxDecoration(
        gradient: AppColors.panelGradient,
        borderRadius: BorderRadius.circular(AppDimens.rMd),
        border: Border.all(color: AppColors.stroke),
      );
}
