import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/n_fields.dart';
import '../../../core/widgets/n_sheet.dart';
import '../../../core/widgets/n_sheet_footer.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/entities/enums.dart';
import '../../providers/app_providers.dart';
import 'position_create_sheet.dart';

/// Форма добавления бойца на вакантную должность или редактирования профиля.
Future<void> showPersonEdit(
  BuildContext context, {
  required PositionRow position,
  PersonRow? person,
}) {
  return showNSheet(
    context: context,
    expand: true,
    builder: (_) => _PersonEditBody(position: position, person: person),
  );
}

class _PersonEditBody extends ConsumerStatefulWidget {
  const _PersonEditBody({required this.position, this.person});
  final PositionRow position;
  final PersonRow? person;

  @override
  ConsumerState<_PersonEditBody> createState() => _PersonEditBodyState();
}

class _PersonEditBodyState extends ConsumerState<_PersonEditBody> {
  late final _last = TextEditingController(text: widget.person?.lastName ?? '');
  late final _first = TextEditingController(text: widget.person?.firstName ?? '');
  late final _middle = TextEditingController(text: widget.person?.middleName ?? '');
  late final _rank = TextEditingController(text: widget.person?.rank ?? '');
  late final _pnum = TextEditingController(text: widget.person?.personalNumber ?? '');
  late final _phone = TextEditingController(text: widget.person?.phone ?? '');
  late final _address = TextEditingController(text: widget.person?.address ?? '');

  late MaritalStatus? _marital = widget.person?.maritalStatus;
  late int _children = widget.person?.childrenCount ?? 0;
  late DateTime? _birth = widget.person?.birthDate;
  late DateTime? _serviceStart = widget.person?.serviceStart;
  late DateTime? _contractStart = widget.person?.contractStart;
  late DateTime? _contractEnd = widget.person?.contractEnd;
  late String _qual = widget.person?.qualification ?? '';
  late DateTime? _qualDate = widget.person?.qualificationDate;
  late bool _veteran = widget.person?.isVeteran ?? false;
  late int _limMain = widget.person?.leaveLimitMain ?? 40;
  late int _limAdd = widget.person?.leaveLimitAdditional ?? 7;
  late int _limVet = widget.person?.leaveLimitVeteran ?? 0;

  // Надбавки для расчёта денежного довольствия.
  late int _special = widget.person?.allowanceSpecial ?? 0;
  late int _secrecy = widget.person?.allowanceSecrecy ?? 0;
  late int _risk = widget.person?.allowanceRisk ?? 0;
  late int _fizo = widget.person?.allowanceFizo ?? 0;
  late int _achieve = widget.person?.allowanceAchieve ?? 0;
  late double _region = widget.person?.regionalCoef ?? 1.0;
  late int _premium = widget.person?.premiumPercent ?? 0;

  static const _regions = [1.0, 1.15, 1.2, 1.3, 1.5, 2.0];

  static const _quals = ['', 'Мастер', '1 класс', '2 класс', '3 класс'];

  @override
  void dispose() {
    for (final c in [_last, _first, _middle, _rank, _pnum, _phone, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _pctRow(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(label, style: AppTypography.label)),
        NStepper(value: value, onChanged: onChanged, max: 100),
      ],
    );
  }

  Future<void> _save() async {
    if (_last.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Укажите фамилию')),
      );
      return;
    }
    String? nn(String s) => s.trim().isEmpty ? null : s.trim();
    final data = PersonnelCompanion(
      lastName: Value(_last.text.trim()),
      firstName: Value(_first.text.trim()),
      middleName: Value(_middle.text.trim()),
      rank: Value(_rank.text.trim()),
      personalNumber: Value(nn(_pnum.text)),
      phone: Value(nn(_phone.text)),
      address: Value(nn(_address.text)),
      maritalStatus: Value(_marital),
      childrenCount: Value(_children),
      birthDate: Value(_birth),
      serviceStart: Value(_serviceStart),
      contractStart: Value(_contractStart),
      contractEnd: Value(_contractEnd),
      qualification: Value(_qual.isEmpty ? null : _qual),
      qualificationDate: Value(_qualDate),
      isVeteran: Value(_veteran),
      leaveLimitMain: Value(_limMain),
      leaveLimitAdditional: Value(_limAdd),
      leaveLimitVeteran: Value(_veteran ? _limVet : 0),
      allowanceSpecial: Value(_special),
      allowanceSecrecy: Value(_secrecy),
      allowanceRisk: Value(_risk),
      allowanceFizo: Value(_fizo),
      allowanceAchieve: Value(_achieve),
      regionalCoef: Value(_region),
      premiumPercent: Value(_premium),
    );

    final db = ref.read(appDatabaseProvider);
    if (widget.person != null) {
      await db.updatePerson(widget.person!.id, data);
    } else {
      await db.insertPerson(
        data.copyWith(positionId: Value(widget.position.id)),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.person != null;
    final pos = widget.position;
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
                Text(editing ? 'Редактирование' : 'Новый боец',
                    style: AppTypography.title),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => showCreatePosition(context, ref, position: pos),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${pos.subunit} · ${pos.title}', style: AppTypography.caption),
                      const SizedBox(width: 6),
                      Icon(AppIcons.pencilSimple, size: 13, color: AppColors.accentPrimary),
                      const SizedBox(width: 2),
                      Text('должность', style: AppTypography.dataSmall.copyWith(color: AppColors.accentPrimary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.lg),
            children: [
              Row(
                children: [
                  Expanded(child: NField(label: 'Фамилия', child: NTextInput(controller: _last))),
                  const SizedBox(width: AppDimens.md),
                  Expanded(child: NField(label: 'Звание', child: NTextInput(controller: _rank, hint: 'сержант'))),
                ],
              ),
              const SizedBox(height: AppDimens.md),
              Row(
                children: [
                  Expanded(child: NField(label: 'Имя', child: NTextInput(controller: _first))),
                  const SizedBox(width: AppDimens.md),
                  Expanded(child: NField(label: 'Отчество', child: NTextInput(controller: _middle))),
                ],
              ),
              const SizedBox(height: AppDimens.md),
              NField(
                label: 'Личный номер',
                child: NTextInput(controller: _pnum, hint: 'ТА-000000'),
              ),
              const SizedBox(height: AppDimens.md),
              NField(label: 'Телефон', child: NTextInput(controller: _phone, keyboardType: TextInputType.phone, hint: '+7 900 000-00-00')),
              const SizedBox(height: AppDimens.md),
              NField(label: 'Адрес', child: NTextInput(controller: _address, maxLines: 2)),
              const SizedBox(height: AppDimens.md),
              NField(
                label: 'Семейное положение',
                child: NChoiceChips<MaritalStatus>(
                  values: MaritalStatus.values,
                  selected: _marital ?? MaritalStatus.single,
                  labelOf: (m) => m.label,
                  onChanged: (m) => setState(() => _marital = m),
                ),
              ),
              const SizedBox(height: AppDimens.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Детей', style: AppTypography.label),
                  NStepper(value: _children, onChanged: (v) => setState(() => _children = v), max: 20),
                ],
              ),
              const SizedBox(height: AppDimens.md),
              NField(
                label: 'Дата рождения',
                child: NDateField(
                  value: _birth,
                  onChanged: (d) => setState(() => _birth = d),
                  openYearFirst: true,
                  lastDate: DateTime.now(), // родиться в будущем нельзя
                ),
              ),
              const SizedBox(height: AppDimens.md),
              NField(
                label: 'Начало военной службы',
                child: NDateField(
                  value: _serviceStart,
                  onChanged: (d) => setState(() => _serviceStart = d),
                  openYearFirst: true,
                  lastDate: DateTime.now(),
                ),
              ),
              const SizedBox(height: AppDimens.md),
              Row(
                children: [
                  Expanded(
                    child: NField(
                      label: 'Контракт с',
                      child: NDateField(value: _contractStart, onChanged: (d) => setState(() => _contractStart = d)),
                    ),
                  ),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: NField(
                      label: 'Контракт по',
                      child: NDateField(value: _contractEnd, onChanged: (d) => setState(() => _contractEnd = d)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.md),
              NField(
                label: 'Квалификация',
                child: NChoiceChips<String>(
                  values: _quals,
                  selected: _qual,
                  labelOf: (q) => q.isEmpty ? 'нет' : q,
                  onChanged: (q) => setState(() => _qual = q),
                ),
              ),
              if (_qual.isNotEmpty) ...[
                const SizedBox(height: AppDimens.md),
                NField(
                  label: 'Дата присвоения',
                  child: NDateField(value: _qualDate, onChanged: (d) => setState(() => _qualDate = d)),
                ),
              ],
              const SizedBox(height: AppDimens.lg),
              NToggle(label: 'Ветеран (право на ветеранский отпуск)', value: _veteran, onChanged: (v) => setState(() => _veteran = v)),
              const SizedBox(height: AppDimens.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Лимит осн., сут.', style: AppTypography.label),
                  NStepper(value: _limMain, onChanged: (v) => setState(() => _limMain = v), max: 90),
                ],
              ),
              const SizedBox(height: AppDimens.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Лимит доп., сут.', style: AppTypography.label),
                  NStepper(value: _limAdd, onChanged: (v) => setState(() => _limAdd = v), max: 30),
                ],
              ),
              if (_veteran) ...[
                const SizedBox(height: AppDimens.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Лимит ветер., сут.', style: AppTypography.label),
                    NStepper(value: _limVet, onChanged: (v) => setState(() => _limVet = v), max: 60),
                  ],
                ),
              ],
              const SizedBox(height: AppDimens.lg),
              Text('ДЕНЕЖНОЕ ДОВОЛЬСТВИЕ · НАДБАВКИ', style: AppTypography.label),
              const SizedBox(height: 2),
              Text('Оклады — из справочника по разряду должности и званию. '
                  'Здесь — индивидуальные надбавки (справочно).',
                  style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
              const SizedBox(height: AppDimens.md),
              _pctRow('Особые условия, %', _special, (v) => setState(() => _special = v)),
              const SizedBox(height: AppDimens.md),
              _pctRow('Гостайна, %', _secrecy, (v) => setState(() => _secrecy = v)),
              const SizedBox(height: AppDimens.md),
              _pctRow('Риск для жизни, %', _risk, (v) => setState(() => _risk = v)),
              const SizedBox(height: AppDimens.md),
              _pctRow('Физподготовка, %', _fizo, (v) => setState(() => _fizo = v)),
              const SizedBox(height: AppDimens.md),
              _pctRow('Особые достижения, %', _achieve, (v) => setState(() => _achieve = v)),
              const SizedBox(height: AppDimens.md),
              _pctRow('Премия, %', _premium, (v) => setState(() => _premium = v)),
              const SizedBox(height: AppDimens.md),
              NField(
                label: 'Районный коэффициент',
                child: NChoiceChips<double>(
                  values: _regions,
                  selected: _regions.contains(_region) ? _region : 1.0,
                  labelOf: (c) => c == 1.0 ? 'нет' : '×$c',
                  onChanged: (c) => setState(() => _region = c),
                ),
              ),
              const SizedBox(height: AppDimens.md),
            ],
          ),
        ),
        NSheetFooter(
          onSave: _save,
          saveLabel: editing ? 'СОХРАНИТЬ' : 'ДОБАВИТЬ БОЙЦА',
        ),
      ],
    );
  }
}
