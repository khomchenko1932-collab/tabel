import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/n_button.dart';
import '../../../core/widgets/n_fields.dart';
import '../../../core/widgets/n_panel.dart';
import '../../../core/widgets/n_sheet.dart';
import '../../../core/widgets/n_sheet_footer.dart';
import '../../../data/database/app_database.dart';
import '../../providers/app_providers.dart';

/// Понятное название коэффициента льготного исчисления.
String coefLabel(double c) {
  if (c == 1.5) return 'день за полтора';
  if (c == 2.0) return 'день за два';
  if (c == 3.0) return 'день за три';
  return '×$c';
}

/// Управление льготными периодами выслуги бойца (день за 1.5/2/3).
Future<void> showServicePeriods(BuildContext context, WidgetRef ref, int personId) {
  return showNSheet(
    context: context,
    expand: true,
    builder: (_) => _ServicePeriodsBody(personId: personId),
  );
}

class _ServicePeriodsBody extends ConsumerWidget {
  const _ServicePeriodsBody({required this.personId});
  final int personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(servicePeriodsForProvider(personId)).value ?? const [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Льготная выслуга', style: AppTypography.title),
                const SizedBox(height: 4),
                Text('Периоды, засчитываемые день за полтора/два/три '
                    '(СВО/боевые, отдельные местности).',
                    style: AppTypography.caption),
              ],
            ),
          ),
        ),
        Flexible(
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.lg),
            children: [
              if (periods.isEmpty)
                NPanel(
                  child: Column(
                    children: [
                      Icon(AppIcons.calendar, size: 28, color: AppColors.textTertiary),
                      const SizedBox(height: AppDimens.sm),
                      Text('Льготных периодов нет', style: AppTypography.caption),
                      const SizedBox(height: 4),
                      Text('Без них выслуга считается календарно (день за день).',
                          style: AppTypography.dataSmall, textAlign: TextAlign.center),
                    ],
                  ),
                )
              else
                for (final p in periods)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppDimens.sm),
                    child: NPanel(
                      onTap: () => _edit(context, ref, period: p),
                      child: Row(
                        children: [
                          Icon(AppIcons.calendar, size: 18, color: AppColors.statusTrip),
                          const SizedBox(width: AppDimens.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(coefLabel(p.coefficient), style: AppTypography.name),
                                const SizedBox(height: 2),
                                Text(
                                  '${Fmt.short(p.startDate)} — '
                                  '${p.endDate == null ? 'по н.в.' : Fmt.short(p.endDate!)}'
                                  '${p.note.isEmpty ? '' : ' · ${p.note}'}',
                                  style: AppTypography.dataSmall,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: Icon(AppIcons.trash, size: 16, color: AppColors.textTertiary),
                            onPressed: () =>
                                ref.read(appDatabaseProvider).deleteServicePeriod(p.id),
                          ),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: AppDimens.sm),
              NButton(
                label: 'ДОБАВИТЬ ПЕРИОД',
                icon: AppIcons.plus,
                outline: true,
                onPressed: () => _edit(context, ref),
              ),
              const SizedBox(height: AppDimens.sm),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, {ServicePeriodRow? period}) {
    return showNSheet(
      context: context,
      expand: true,
      builder: (_) => _PeriodForm(personId: personId, period: period),
    );
  }
}

class _PeriodForm extends ConsumerStatefulWidget {
  const _PeriodForm({required this.personId, this.period});
  final int personId;
  final ServicePeriodRow? period;

  @override
  ConsumerState<_PeriodForm> createState() => _PeriodFormState();
}

class _PeriodFormState extends ConsumerState<_PeriodForm> {
  late DateTime? _start = widget.period?.startDate;
  late DateTime? _end = widget.period?.endDate;
  late bool _ongoing = widget.period?.endDate == null;
  late double _coef = widget.period?.coefficient ?? 1.5;
  late final _note = TextEditingController(text: widget.period?.note ?? '');

  static const _coefs = [1.5, 2.0, 3.0];

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_start == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Укажите начало периода')),
      );
      return;
    }
    final end = _ongoing ? null : _end;
    if (end != null && end.isBefore(_start!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Конец периода раньше начала')),
      );
      return;
    }
    final db = ref.read(appDatabaseProvider);
    if (widget.period != null) {
      await db.updateServicePeriod(
        widget.period!.id,
        ServicePeriodsCompanion(
          startDate: Value(_start!),
          endDate: Value(end),
          coefficient: Value(_coef),
          note: Value(_note.text.trim()),
        ),
      );
    } else {
      await db.addServicePeriod(ServicePeriodsCompanion.insert(
        personnelId: widget.personId,
        startDate: _start!,
        endDate: Value(end),
        coefficient: Value(_coef),
        note: Value(_note.text.trim()),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.lg),
            children: [
          Text(widget.period == null ? 'Новый период' : 'Период', style: AppTypography.title),
          const SizedBox(height: AppDimens.lg),
          NField(
            label: 'Коэффициент',
            child: NChoiceChips<double>(
              values: _coefs,
              selected: _coef,
              labelOf: coefLabel,
              onChanged: (c) => setState(() => _coef = c),
            ),
          ),
          const SizedBox(height: AppDimens.md),
          Row(
            children: [
              Expanded(
                child: NField(
                  label: 'Начало',
                  child: NDateField(value: _start, onChanged: (d) => setState(() => _start = d)),
                ),
              ),
              const SizedBox(width: AppDimens.md),
              Expanded(
                child: NField(
                  label: 'Окончание',
                  child: _ongoing
                      ? Container(
                          height: 44,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
                          child: Text('по н.в.', style: AppTypography.data.copyWith(color: AppColors.textTertiary)),
                        )
                      : NDateField(value: _end, onChanged: (d) => setState(() => _end = d)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.sm),
          NToggle(
            label: 'Период продолжается (по настоящее время)',
            value: _ongoing,
            onChanged: (v) => setState(() => _ongoing = v),
          ),
          const SizedBox(height: AppDimens.md),
          NField(
            label: 'Примечание',
            child: NTextInput(controller: _note, hint: 'напр. СВО, Крайний Север'),
          ),
          const SizedBox(height: AppDimens.md),
            ],
          ),
        ),
        NSheetFooter(onSave: _save, saveLabel: 'СОХРАНИТЬ'),
      ],
    );
  }
}
