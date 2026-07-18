import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:narmb_ls/core/widgets/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/n_button.dart';
import '../../core/widgets/n_sheet.dart';
import '../../core/widgets/n_panel.dart';
import '../../core/widgets/n_indicators.dart';
import '../../data/database/app_database.dart';
import '../../domain/entities/enums.dart';
import '../../domain/services/roster_service.dart';
import '../../domain/services/service_service.dart';
import '../common/screen_header.dart';
import '../common/status_ui.dart';
import '../providers/app_providers.dart';
import '../settings/settings_controller.dart';
import 'widgets/person_edit_sheet.dart';
import 'widgets/personnel_card.dart';
import 'widgets/position_create_sheet.dart';
import 'widgets/quick_status_sheet.dart';
import 'widgets/transfer_sheet.dart';

/// Экран «Состав» — плоский список штата с фильтрами и свайп-действиями.
class PersonnelListScreen extends ConsumerStatefulWidget {
  const PersonnelListScreen({super.key});

  @override
  ConsumerState<PersonnelListScreen> createState() => _PersonnelListScreenState();
}

class _PersonnelListScreenState extends ConsumerState<PersonnelListScreen> {
  String? _subunit;
  Object? _statusFilter; // PersonnelStatus | 'vacant' | null
  String _query = '';
  bool _searching = false;

  /// id выбранных бойцов для массовых операций.
  final Set<int> _selected = {};
  bool get _selectionMode => _selected.isNotEmpty;

  void _toggle(int id) => setState(() {
        if (!_selected.remove(id)) _selected.add(id);
      });

  void _clearSelection() => setState(_selected.clear);

  bool _matches(EffectiveSoldier s) {
    if (_subunit != null && s.view.position.subunit != _subunit) return false;
    if (_statusFilter != null) {
      if (_statusFilter == 'vacant') {
        if (!s.isVacant) return false;
      } else if (s.isVacant || s.status != _statusFilter) {
        return false;
      }
    }
    if (_query.isNotEmpty) {
      final hay = '${s.view.fullName} ${s.view.position.title} ${s.view.position.subunit}'.toLowerCase();
      if (!hay.contains(_query.toLowerCase())) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final rosterAsync = ref.watch(effectiveRosterProvider);
    final stats = ref.watch(rosterStatsProvider).value;

    return Scaffold(
      floatingActionButton: _selectionMode
          ? null
          : FloatingActionButton(
              onPressed: _addToVacancy,
              backgroundColor: AppColors.accentPrimary,
              foregroundColor: AppColors.bgPage,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.rXl),
              ),
              child: Icon(AppIcons.plus),
            ).animate().scale(
                duration: 350.ms,
                curve: Curves.elasticOut,
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
              ),
      body: Column(
        children: [
          if (_selectionMode)
            _selectionHeader()
          else
            ScreenHeader(
              title: 'Состав',
              subtitle: stats == null
                  ? null
                  : 'штат ${stats.total} · список ${stats.list} · вакант ${stats.vacant}',
              trailing: IconButton(
                icon: Icon(
                  _searching ? Icons.close : AppIcons.magnifyingGlass,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() {
                  _searching = !_searching;
                  if (!_searching) _query = '';
                }),
              ),
            ),
          if (_searching && !_selectionMode) _searchBar(),
          _filters(),
          _demoHint(),
          Expanded(
            child: rosterAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.accentPrimary),
              ),
              error: (e, _) => Center(
                child: Text('Ошибка: $e', style: AppTypography.caption),
              ),
              data: (all) {
                if (all.isEmpty) {
                  return EmptyState(
                    icon: AppIcons.usersThree,
                    title: 'Штат пуст',
                    message: 'Нажмите «+», чтобы создать должность и добавить бойца',
                  );
                }
                final list = all.where(_matches).toList();
                if (list.isEmpty) {
                  return EmptyState(
                    icon: AppIcons.usersThree,
                    title: 'Никого не найдено',
                    message: 'Измените фильтр или запрос',
                  );
                }
                final periodsMap = ref.watch(servicePeriodsByPersonProvider);
                final tripsMap = ref.watch(tripsByPersonProvider);
                final day = ref.watch(todayProvider);
                return ListView.builder(
                  padding: const EdgeInsets.only(top: AppDimens.sm, bottom: 96),
                  itemCount: list.length,
                  itemBuilder: (_, i) =>
                      _buildCard(list[i], i, periodsMap, tripsMap, day),
                );
              },
            ),
          ),
          if (_selectionMode) _selectionActionBar(),
        ],
      ),
    );
  }

  /// Шапка режима выделения: закрыть, счётчик, выбрать всех видимых.
  Widget _selectionHeader() {
    final visible = (ref.watch(effectiveRosterProvider).value ?? const [])
        .where((s) => !s.isVacant && _matches(s))
        .map((s) => s.view.person!.id)
        .toList();
    final allSelected = visible.isNotEmpty && visible.every(_selected.contains);
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.sm, MediaQuery.of(context).padding.top + AppDimens.sm, AppDimens.md, AppDimens.sm),
      decoration: const BoxDecoration(
        color: AppColors.bgHeader,
        border: Border(bottom: BorderSide(color: AppColors.stroke)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: _clearSelection,
          ),
          Expanded(
            child: Text('Выбрано ${_selected.length}', style: AppTypography.title),
          ),
          TextButton(
            onPressed: () => setState(() {
              if (allSelected) {
                _selected.removeAll(visible);
              } else {
                _selected.addAll(visible);
              }
            }),
            child: Text(allSelected ? 'Снять' : 'Все',
                style: AppTypography.data.copyWith(color: AppColors.accentPrimary)),
          ),
        ],
      ),
    );
  }

  /// Нижняя панель действий над выбранными.
  Widget _selectionActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppDimens.md, AppDimens.sm, AppDimens.md, AppDimens.md),
      decoration: const BoxDecoration(
        color: AppColors.bgHeader,
        border: Border(top: BorderSide(color: AppColors.stroke)),
      ),
      child: Row(
        children: [
          Expanded(
            child: NButton(
              label: 'СМЕНИТЬ СТАТУС',
              icon: AppIcons.arrowsClockwise,
              onPressed: _selected.isEmpty ? null : _pickBatchStatus,
            ),
          ),
          const SizedBox(width: AppDimens.sm),
          NButton(
            label: 'ИСКЛ.',
            icon: AppIcons.userMinus,
            outline: true,
            onPressed: _selected.isEmpty ? null : _batchExclude,
          ),
        ],
      ),
    );
  }

  /// Подсказка о демо-данных: сид заполняет штат вымышленными фамилиями
  /// (Иванов, Петров…), и без предупреждения их можно принять за настоящие.
  /// Показываем, пока пользователь не закроет крестиком.
  Widget _demoHint() {
    final s = ref.watch(settingsProvider).value;
    if (s == null || s.demoHintDismissed) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.sm, AppDimens.lg, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: AppDimens.sm),
        decoration: BoxDecoration(
          color: AppColors.statusTrip.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppDimens.rMd),
          border: Border.all(color: AppColors.statusTrip.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: AppColors.statusTrip),
            const SizedBox(width: AppDimens.sm),
            Expanded(
              child: Text(
                'Фамилии в списке — примеры. Замените их своими: свайп по карточке → «Правка».',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close, size: 16, color: AppColors.textTertiary),
              onPressed: () => ref.read(settingsActionsProvider).dismissDemoHint(),
            ),
          ],
        ),
      ),
    );
  }

  /// «выслуга 5 лет 2 мес · льгот. 7 лет» — если задана дата начала службы.
  /// Командировки с коэффициентом тоже дают льготу — как в профиле бойца.
  String? _serviceLine(EffectiveSoldier s, Map<int, List<ServicePeriodRow>> periods,
      Map<int, List<TripRow>> trips, DateTime day) {
    final person = s.view.person;
    if (person == null || person.serviceStart == null) return null;
    final los = LengthOfService.of(person, periods[person.id] ?? const [],
        trips: trips[person.id] ?? const [], now: day);
    if (los == null) return null;
    final base = 'выслуга ${formatYmd(los.calendar)}';
    return los.hasBonus ? '$base · льгот. ${formatYmd(los.preferential)}' : base;
  }

  Widget _buildCard(EffectiveSoldier s, int index,
      Map<int, List<ServicePeriodRow>> periods,
      Map<int, List<TripRow>> trips, DateTime day) {
    final pid = s.view.person?.id;
    final selected = pid != null && _selected.contains(pid);
    final card = PersonnelCard(
      soldier: s,
      selectionMode: _selectionMode,
      selected: selected,
      serviceLine: _serviceLine(s, periods, trips, day),
      onLongPress: pid == null ? null : () => _toggle(pid),
      onTap: () {
        if (_selectionMode) {
          if (pid != null) _toggle(pid);
        } else {
          context.push('/soldier/${s.view.person!.id}');
        }
      },
      onStatus: () => showQuickStatus(context, ref, s.view.person!, s.view.position.title),
      onEdit: () => showPersonEdit(context, position: s.view.position, person: s.view.person),
      onTransfer: () => showTransfer(context, s.view.person!.id, s.view.fullName),
      onExclude: () => _excludeWithUndo(s),
      onAssign: () => showPersonEdit(context, position: s.view.position),
      onEditPosition: () => showCreatePosition(context, ref, position: s.view.position),
      onDeletePosition: () => _confirmDeletePosition(s),
    );
    // В режиме выбора анимацию входа отключаем, чтобы не мигало при тапах.
    if (index < 12 && !_selectionMode) {
      return card
          .animate()
          .fadeIn(delay: (30 * index).ms, duration: 260.ms)
          .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
    }
    return card;
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.md, AppDimens.sm, AppDimens.md, 0),
      child: TextField(
        autofocus: true,
        style: AppTypography.body,
        cursorColor: AppColors.accentPrimary,
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: 'Фамилия или должность',
          hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
          prefixIcon: Icon(AppIcons.magnifyingGlass, size: 18, color: AppColors.textTertiary),
          filled: true,
          fillColor: AppColors.bgLcd,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.rMd),
            borderSide: const BorderSide(color: AppColors.stroke),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.rMd),
            borderSide: const BorderSide(color: AppColors.stroke),
          ),
        ),
      ),
    );
  }

  Widget _filters() {
    final roster = ref.watch(effectiveRosterProvider).value ?? const [];
    final subunits = <String>{for (final s in roster) s.view.position.subunit}.toList()..sort();
    final hasActiveFilter = _subunit != null || _statusFilter != null;
    return Container(
      margin: const EdgeInsets.fromLTRB(AppDimens.md, AppDimens.sm, AppDimens.md, AppDimens.xs),
      padding: const EdgeInsets.only(bottom: AppDimens.sm),
      decoration: BoxDecoration(
        color: AppColors.bgLcd,
        borderRadius: BorderRadius.circular(AppDimens.rMd),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimens.md, AppDimens.sm, AppDimens.md, AppDimens.xs),
            child: Row(
              children: [
                Icon(AppIcons.magnifyingGlass, size: 12, color: AppColors.textTertiary),
                const SizedBox(width: 5),
                Text('ФИЛЬТРЫ', style: AppTypography.label),
                const Spacer(),
                if (hasActiveFilter)
                  GestureDetector(
                    onTap: () => setState(() {
                      _subunit = null;
                      _statusFilter = null;
                    }),
                    child: Text('сбросить',
                        style: AppTypography.dataSmall.copyWith(color: AppColors.accentPrimary)),
                  ),
              ],
            ),
          ),
          // Строка 1 — подразделения (динамически из штата).
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
              children: [
                _chip('Все', _subunit == null, () => setState(() => _subunit = null)),
                for (final su in subunits)
                  _chip(su, _subunit == su, () => setState(() => _subunit = su)),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          // Строка 2 — статусы.
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
              children: [
                _chip('Все статусы', _statusFilter == null, () => setState(() => _statusFilter = null)),
                for (final st in PersonnelStatus.values)
                  _chip(st.label, _statusFilter == st, () => setState(() => _statusFilter = st), accent: st.color),
                _chip('Вакант', _statusFilter == 'vacant', () => setState(() => _statusFilter = 'vacant'), accent: AppColors.statusVacant),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap, {Color? accent}) {
    final a = accent ?? AppColors.accentPrimary;
    return Padding(
      padding: const EdgeInsets.only(right: AppDimens.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: active ? a : AppColors.bgLcd,
            borderRadius: BorderRadius.circular(AppDimens.rSm),
            border: Border.all(color: active ? a : AppColors.stroke),
          ),
          child: Text(
            label.toUpperCase(),
            style: AppTypography.data.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: active ? AppColors.bgPage : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createPosition() async {
    final pos = await showCreatePosition(context, ref);
    if (pos != null && mounted) {
      await showPersonEdit(context, position: pos);
    }
  }

  Future<void> _addToVacancy() async {
    final vacancies = ref.read(vacantPositionsProvider);
    await showNSheet(
      context: context,
      expand: true,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(AppDimens.md),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.xs, vertical: AppDimens.sm),
            child: Text('Добавить в состав', style: AppTypography.title),
          ),
          NPanel(
            margin: const EdgeInsets.only(bottom: AppDimens.md),
            glow: true,
            onTap: () {
              Navigator.pop(context);
              _createPosition();
            },
            child: Row(
              children: [
                Icon(AppIcons.plusCircle, color: AppColors.accentPrimary, size: 22),
                const SizedBox(width: AppDimens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Создать новую должность', style: AppTypography.name),
                      Text('добавить свою должность и бойца', style: AppTypography.dataSmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (vacancies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.xs, vertical: AppDimens.sm),
              child: Text('ИЛИ ЗАПОЛНИТЬ ВАКАНТНУЮ', style: AppTypography.label),
            ),
          for (final pos in vacancies)
            NPanel(
              margin: const EdgeInsets.only(bottom: AppDimens.sm),
              onTap: () {
                Navigator.pop(context);
                showPersonEdit(context, position: pos);
              },
              child: IntrinsicHeight(
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CategoryBar(pos.category.color),
                  const SizedBox(width: AppDimens.md),
                  SizedBox(
                    width: 26,
                    child: Text(pos.slot.toString().padLeft(2, '0'),
                        style: AppTypography.data.copyWith(color: AppColors.textTertiary),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: AppDimens.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(pos.title, style: AppTypography.name),
                        const SizedBox(height: 2),
                        Text('${pos.subunit}${pos.crew != null ? ' · ${pos.crew}' : ''}',
                            style: AppTypography.caption),
                      ],
                    ),
                  ),
                  Icon(AppIcons.userPlus, size: 18, color: AppColors.accentPrimary),
                ],
              ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Массовые операции ──

  /// Выбор статуса для всех выделенных бойцов.
  Future<void> _pickBatchStatus() async {
    final status = await showNSheet<PersonnelStatus>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, AppDimens.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Статус для ${_selected.length} чел.', style: AppTypography.title),
            const SizedBox(height: AppDimens.md),
            for (final st in PersonnelStatus.values)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pop(context, st),
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppDimens.sm),
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: AppDimens.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.rMd),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: Row(
                    children: [
                      StatusLed(st.color),
                      const SizedBox(width: AppDimens.md),
                      Text(st.label, style: AppTypography.body),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    if (status != null) await _applyBatchStatus(status);
  }

  Future<void> _applyBatchStatus(PersonnelStatus status) async {
    final roster = ref.read(effectiveRosterProvider).value ?? const [];
    // Запоминаем прежние статусы для отмены (только по выбранным и занятым).
    final prev = <int, PersonnelStatus>{};
    for (final s in roster) {
      final p = s.view.person;
      if (p != null && _selected.contains(p.id)) prev[p.id] = p.status;
    }
    if (prev.isEmpty) return;
    final db = ref.read(appDatabaseProvider);
    await db.setStatusMap({for (final id in prev.keys) id: status});
    final n = prev.length;
    _clearSelection();
    if (!mounted) return;
    _showUndo('$n чел. → ${status.label}', () => db.setStatusMap(prev));
  }

  Future<void> _batchExclude() async {
    final roster = ref.read(effectiveRosterProvider).value ?? const [];
    // Для отмены нужно запомнить, на какой должности стоял каждый.
    final prevPos = <int, int>{};
    for (final s in roster) {
      final p = s.view.person;
      if (p != null && _selected.contains(p.id) && p.positionId != null) {
        prevPos[p.id] = p.positionId!;
      }
    }
    if (prevPos.isEmpty) return;
    final db = ref.read(appDatabaseProvider);
    for (final id in prevPos.keys) {
      await db.excludePerson(id);
    }
    final n = prevPos.length;
    _clearSelection();
    if (!mounted) return;
    _showUndo('Исключено: $n чел.', () async {
      for (final e in prevPos.entries) {
        await db.restorePerson(e.key, e.value);
      }
    });
  }

  Future<void> _excludeWithUndo(EffectiveSoldier s) async {
    final person = s.view.person!;
    final posId = person.positionId;
    final db = ref.read(appDatabaseProvider);
    await db.excludePerson(person.id);
    if (!mounted) return;
    _showUndo('${s.view.fullName} — исключён', () async {
      if (posId != null) await db.restorePerson(person.id, posId);
    });
  }

  void _showUndo(String message, Future<void> Function() undo) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: AppTypography.body),
          backgroundColor: AppColors.bgRaised,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'ОТМЕНИТЬ',
            textColor: AppColors.accentPrimary,
            onPressed: () => undo(),
          ),
        ),
      );
  }

  Future<void> _confirmDeletePosition(EffectiveSoldier s) async {
    final pos = s.view.position;
    final occupied = !s.view.isVacant;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.statusSick),
        ),
        title: Text('Удалить должность?', style: AppTypography.title.copyWith(color: AppColors.statusSick)),
        content: Text(
          occupied
              ? '«${pos.title}» и боец ${s.view.fullName} со всеми записями будут удалены. Штат уменьшится. Отменить нельзя.'
              : '«${pos.title}» будет удалена из штата. Штат уменьшится. Отменить нельзя.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Удалить', style: AppTypography.body.copyWith(color: AppColors.statusSick)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(appDatabaseProvider).deletePosition(pos.id);
    }
  }
}
