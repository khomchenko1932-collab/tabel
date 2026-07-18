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

/// Создание/редактирование штатной должности. Возвращает должность.
/// [position] задан — режим правки существующей.
Future<PositionRow?> showCreatePosition(BuildContext context, WidgetRef ref,
    {PositionRow? position}) {
  return showNSheet<PositionRow>(
    context: context,
    expand: true,
    builder: (_) => _CreatePositionBody(position: position),
  );
}

class _CreatePositionBody extends ConsumerStatefulWidget {
  const _CreatePositionBody({this.position});
  final PositionRow? position;

  @override
  ConsumerState<_CreatePositionBody> createState() => _CreatePositionBodyState();
}

class _CreatePositionBodyState extends ConsumerState<_CreatePositionBody> {
  late RankCategory _cat = widget.position?.category ?? RankCategory.soldier;
  late final _title = TextEditingController(text: widget.position?.title ?? '');
  late final _crew = TextEditingController(text: widget.position?.crew ?? '');
  late final _subunit = TextEditingController(text: widget.position?.subunit ?? '');
  late int _tariff = widget.position?.tariffRank ?? 0; // 0 — разряд не задан

  @override
  void dispose() {
    _title.dispose();
    _crew.dispose();
    _subunit.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Укажите название должности')),
      );
      return;
    }
    final db = ref.read(appDatabaseProvider);
    final crew = _crew.text.trim();
    final crewVal = Value(crew.isEmpty ? null : crew);
    final sub = _subunit.text.trim().isEmpty ? 'Подразделение' : _subunit.text.trim();
    final tariffVal = Value(_tariff == 0 ? null : _tariff);
    final existing = widget.position;

    if (existing != null) {
      await db.updatePosition(
        existing.id,
        PositionsCompanion(
          title: Value(title),
          subunit: Value(sub),
          category: Value(_cat),
          crew: crewVal,
          tariffRank: tariffVal,
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, existing.copyWith(
        title: title, subunit: sub, category: _cat, crew: crewVal,
        tariffRank: tariffVal,
      ));
      return;
    }

    final slot = await db.nextSlot();
    final id = await db.insertPosition(
      PositionsCompanion.insert(
        slot: slot, title: title, subunit: Value(sub), category: _cat, crew: crewVal,
        tariffRank: tariffVal,
      ),
    );
    if (!mounted) return;
    Navigator.pop(context, PositionRow(
      id: id, slot: slot, title: title, subunit: sub, category: _cat,
      crew: crew.isEmpty ? null : crew,
      tariffRank: _tariff == 0 ? null : _tariff,
    ));
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
            child: Text(widget.position == null ? 'Новая должность' : 'Должность',
                style: AppTypography.title),
          ),
        ),
        Flexible(
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.lg),
            children: [
              NField(
                label: 'Подразделение / взвод',
                child: NTextInput(controller: _subunit, hint: '1-й взвод'),
              ),
              const SizedBox(height: AppDimens.sm),
              Wrap(
                spacing: AppDimens.sm,
                runSpacing: AppDimens.xs,
                children: [
                  for (final s in kSubunitSuggestions)
                    GestureDetector(
                      onTap: () => setState(() => _subunit.text = s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.bgLcd,
                          borderRadius: BorderRadius.circular(AppDimens.rSm),
                          border: Border.all(color: AppColors.stroke),
                        ),
                        child: Text(s, style: AppTypography.dataSmall),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimens.md),
              NField(label: 'Должность', child: NTextInput(controller: _title, hint: 'Наводчик')),
              const SizedBox(height: AppDimens.md),
              NField(label: 'Расчёт / примечание (необязательно)', child: NTextInput(controller: _crew)),
              const SizedBox(height: AppDimens.md),
              NField(
                label: 'Категория (штатная)',
                child: NChoiceChips<RankCategory>(
                  values: RankCategory.values,
                  selected: _cat,
                  labelOf: (c) => c.label,
                  onChanged: (c) => setState(() => _cat = c),
                ),
              ),
              const SizedBox(height: AppDimens.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text('Тарифный разряд (для оклада)', style: AppTypography.label),
                  ),
                  NStepper(value: _tariff, onChanged: (v) => setState(() => _tariff = v), max: 50),
                ],
              ),
              Text(_tariff == 0 ? 'не задан — оклад по должности не считается' : '$_tariff-й разряд',
                  style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
              const SizedBox(height: AppDimens.md),
            ],
          ),
        ),
        NSheetFooter(
          onSave: _save,
          saveLabel: widget.position == null ? 'СОЗДАТЬ И ЗАПОЛНИТЬ' : 'СОХРАНИТЬ',
        ),
      ],
    );
  }
}
