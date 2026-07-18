import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/n_fields.dart';
import '../../../core/widgets/n_sheet.dart';
import '../../../core/widgets/n_sheet_footer.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/entities/enums.dart';
import '../../providers/app_providers.dart';

/// Форма добавления/редактирования отпуска. [leave] задан — режим правки.
Future<void> showLeaveForm(BuildContext context, int personId, {LeaveRow? leave}) {
  return showNSheet(
    context: context,
    expand: true,
    builder: (_) => _LeaveFormBody(personId: personId, leave: leave),
  );
}

class _LeaveFormBody extends ConsumerStatefulWidget {
  const _LeaveFormBody({required this.personId, this.leave});
  final int personId;
  final LeaveRow? leave;

  @override
  ConsumerState<_LeaveFormBody> createState() => _LeaveFormBodyState();
}

class _LeaveFormBodyState extends ConsumerState<_LeaveFormBody> {
  late LeaveType _type = widget.leave?.type ?? LeaveType.main;
  late int _days = widget.leave?.daysGranted ?? 20;
  late bool _travel = widget.leave?.includesTravel ?? false;
  late int _travelDays = widget.leave?.travelDays ?? 2;
  late DateTime? _start = widget.leave?.startDate;
  late DateTime? _end = widget.leave?.endDate;
  late final _dest = TextEditingController(text: widget.leave?.destination ?? '');
  late final _order = TextEditingController(text: widget.leave?.orderNumber ?? '');

  @override
  void dispose() {
    _dest.dispose();
    _order.dispose();
    super.dispose();
  }

  int get _total => _days + (_travel ? _travelDays : 0);

  Future<void> _save() async {
    if (_start != null && _end != null && _end!.isBefore(_start!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Дата выхода раньше начала')),
      );
      return;
    }
    final now = DateTime.now();
    final LeaveStatus status;
    if (_start != null && _start!.isAfter(now)) {
      status = LeaveStatus.planned;
    } else if (_end != null && _end!.isBefore(now)) {
      status = LeaveStatus.completed;
    } else {
      status = LeaveStatus.active;
    }
    final dest = _dest.text.trim();
    final order = _order.text.trim();
    final db = ref.read(appDatabaseProvider);
    if (widget.leave != null) {
      await db.updateLeave(
        widget.leave!.id,
        LeavesCompanion(
          type: Value(_type),
          daysGranted: Value(_days),
          startDate: Value(_start),
          endDate: Value(_end),
          status: Value(status),
          includesTravel: Value(_travel),
          travelDays: Value(_travel ? _travelDays : 0),
          destination: Value(dest.isEmpty ? null : dest),
          orderNumber: Value(order.isEmpty ? null : order),
        ),
      );
    } else {
      await db.addLeave(
        LeavesCompanion.insert(
          personnelId: widget.personId,
          type: _type,
          daysGranted: _days,
          startDate: Value(_start),
          endDate: Value(_end),
          status: Value(status),
          includesTravel: Value(_travel),
          travelDays: Value(_travel ? _travelDays : 0),
          destination: Value(dest.isEmpty ? null : dest),
          orderNumber: Value(order.isEmpty ? null : order),
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isVeteran =
        ref.watch(soldierByPersonProvider(widget.personId))?.view.person?.isVeteran ?? false;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.leave == null ? 'Новый отпуск' : 'Отпуск', style: AppTypography.title),
          ),
        ),
        Flexible(
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.lg),
            children: [
              NField(
                label: 'Тип отпуска',
                child: NChoiceChips<LeaveType>(
                  values: [
                    for (final t in LeaveType.values)
                      if (t != LeaveType.veteran || isVeteran) t,
                  ],
                  selected: _type,
                  labelOf: (t) => t.label,
                  onChanged: (t) => setState(() {
                    _type = t;
                    _days = switch (t) {
                      LeaveType.main => 20,
                      LeaveType.veteran => 15,
                      _ => _days,
                    };
                  }),
                ),
              ),
              const SizedBox(height: AppDimens.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Дней предоставлено', style: AppTypography.label),
                  NStepper(value: _days, min: 1, max: 90, onChanged: (v) => setState(() => _days = v)),
                ],
              ),
              const SizedBox(height: AppDimens.md),
              NToggle(label: 'С учётом дороги', value: _travel, onChanged: (v) => setState(() => _travel = v)),
              if (_travel) ...[
                const SizedBox(height: AppDimens.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Дней на дорогу', style: AppTypography.label),
                    NStepper(value: _travelDays, min: 1, max: 15, onChanged: (v) => setState(() => _travelDays = v)),
                  ],
                ),
              ],
              const SizedBox(height: AppDimens.md),
              Text('Итого $_total дн. Даты необязательны: укажешь дату — в неё '
                  'статус и расход изменятся автоматически.',
                  style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
              const SizedBox(height: AppDimens.sm),
              Row(
                children: [
                  Expanded(
                    child: NField(
                      label: 'Начало',
                      child: NDateField(
                        value: _start,
                        onChanged: (d) => setState(() => _start = d),
                        onCleared: () => setState(() => _start = null),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: NField(
                      label: 'Выход (возврат)',
                      child: NDateField(
                        value: _end,
                        onChanged: (d) => setState(() => _end = d),
                        onCleared: () => setState(() => _end = null),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.md),
              NField(label: 'Место отдыха', child: NTextInput(controller: _dest)),
              const SizedBox(height: AppDimens.md),
              NField(label: 'Номер приказа', child: NTextInput(controller: _order)),
              const SizedBox(height: AppDimens.md),
            ],
          ),
        ),
        NSheetFooter(
          onSave: _save,
          saveLabel: widget.leave == null ? 'ДОБАВИТЬ' : 'СОХРАНИТЬ',
        ),
      ],
    );
  }
}
