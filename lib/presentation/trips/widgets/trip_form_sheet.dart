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

/// Форма добавления/редактирования командировки. [trip] задан — режим правки.
Future<void> showTripForm(BuildContext context, int personId, {TripRow? trip}) {
  return showNSheet(
    context: context,
    expand: true,
    builder: (_) => _TripFormBody(personId: personId, trip: trip),
  );
}

class _TripFormBody extends ConsumerStatefulWidget {
  const _TripFormBody({required this.personId, this.trip});
  final int personId;
  final TripRow? trip;

  @override
  ConsumerState<_TripFormBody> createState() => _TripFormBodyState();
}

class _TripFormBodyState extends ConsumerState<_TripFormBody> {
  late final _dest = TextEditingController(text: widget.trip?.destination ?? '');
  late final _order = TextEditingController(text: widget.trip?.orderNumber ?? '');
  late DateTime? _start = widget.trip?.startDate;
  late DateTime? _end = widget.trip?.endDate;
  late double _coef = widget.trip?.serviceCoef ?? 1.0;

  static const _coefs = [1.0, 1.5, 2.0, 3.0];

  @override
  void dispose() {
    _dest.dispose();
    _order.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_dest.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Укажите пункт назначения')),
      );
      return;
    }
    if (_start != null && _end != null && _end!.isBefore(_start!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Дата прибытия раньше убытия')),
      );
      return;
    }
    // Статус по датам: нет дат или окно охватывает сегодня → в командировке;
    // начало в будущем → план; прибытие в прошлом → завершена.
    final now = DateTime.now();
    final TripStatus status;
    if (_start != null && _start!.isAfter(now)) {
      status = TripStatus.planned;
    } else if (_end != null && _end!.isBefore(now)) {
      status = TripStatus.completed;
    } else {
      status = TripStatus.active;
    }
    final order = _order.text.trim();
    final db = ref.read(appDatabaseProvider);
    if (widget.trip != null) {
      await db.updateTrip(
        widget.trip!.id,
        TripsCompanion(
          destination: Value(_dest.text.trim()),
          startDate: Value(_start),
          endDate: Value(_end),
          status: Value(status),
          orderNumber: Value(order.isEmpty ? null : order),
          serviceCoef: Value(_coef),
        ),
      );
    } else {
      await db.addTrip(
        TripsCompanion.insert(
          personnelId: widget.personId,
          destination: _dest.text.trim(),
          startDate: Value(_start),
          endDate: Value(_end),
          status: Value(status),
          orderNumber: Value(order.isEmpty ? null : order),
          serviceCoef: Value(_coef),
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.trip == null ? 'Новая командировка' : 'Командировка', style: AppTypography.title),
          ),
        ),
        Flexible(
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.lg),
            children: [
              NField(label: 'Пункт назначения', child: NTextInput(controller: _dest, hint: 'Москва')),
              const SizedBox(height: AppDimens.md),
              Text('Даты необязательны. Если указать «Прибытие» — в эту дату боец '
                  'вернётся в расход. Без дат — числится в командировке, пока не '
                  'сменишь статус.',
                  style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
              const SizedBox(height: AppDimens.sm),
              Row(
                children: [
                  Expanded(
                    child: NField(
                      label: 'Убытие',
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
                      label: 'Прибытие',
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
              NField(label: 'Номер приказа', child: NTextInput(controller: _order)),
              const SizedBox(height: AppDimens.md),
              NField(
                label: 'Выслуга за период',
                child: NChoiceChips<double>(
                  values: _coefs,
                  selected: _coefs.contains(_coef) ? _coef : 1.0,
                  labelOf: (c) => c == 1.0
                      ? 'обычная'
                      : c == 1.5
                          ? 'день за 1.5'
                          : c == 2.0
                              ? 'день за 2'
                              : 'день за 3',
                  onChanged: (c) => setState(() => _coef = c),
                ),
              ),
              const SizedBox(height: AppDimens.md),
            ],
          ),
        ),
        NSheetFooter(
          onSave: _save,
          saveLabel: widget.trip == null ? 'ДОБАВИТЬ' : 'СОХРАНИТЬ',
        ),
      ],
    );
  }
}
