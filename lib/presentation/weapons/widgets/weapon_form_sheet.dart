import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/n_button.dart';
import '../../../core/widgets/n_fields.dart';
import '../../../core/widgets/n_sheet.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/entities/enums.dart';
import '../../providers/app_providers.dart';

/// Форма добавления единицы вооружения/имущества бойцу.
Future<void> showWeaponForm(BuildContext context, int personId) {
  return showNSheet(
    context: context,
    expand: true,
    builder: (_) => _WeaponFormBody(personId: personId),
  );
}

class _WeaponFormBody extends ConsumerStatefulWidget {
  const _WeaponFormBody({required this.personId});
  final int personId;

  @override
  ConsumerState<_WeaponFormBody> createState() => _WeaponFormBodyState();
}

class _WeaponFormBodyState extends ConsumerState<_WeaponFormBody> {
  WeaponType _type = WeaponType.weapon;
  final _name = TextEditingController();
  final _serial = TextEditingController();
  final _inv = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _serial.dispose();
    _inv.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Укажите наименование')),
      );
      return;
    }
    String? nn(String s) => s.trim().isEmpty ? null : s.trim();
    await ref.read(appDatabaseProvider).addWeapon(
          WeaponsCompanion.insert(
            personnelId: widget.personId,
            name: _name.text.trim(),
            type: _type,
            serialNumber: Value(nn(_serial.text)),
            inventoryNumber: Value(nn(_inv.text)),
            assignedDate: Value(DateTime.now()),
          ),
        );
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
            child: Text('Закрепить вооружение', style: AppTypography.title),
          ),
        ),
        Flexible(
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.lg),
            children: [
              NField(
                label: 'Категория',
                child: NChoiceChips<WeaponType>(
                  values: WeaponType.values,
                  selected: _type,
                  labelOf: (t) => t.label,
                  onChanged: (t) => setState(() => _type = t),
                ),
              ),
              const SizedBox(height: AppDimens.md),
              NField(label: 'Наименование', child: NTextInput(controller: _name, hint: 'АК-74М')),
              const SizedBox(height: AppDimens.md),
              NField(label: 'Серийный номер', child: NTextInput(controller: _serial)),
              const SizedBox(height: AppDimens.md),
              NField(label: 'Инвентарный номер', child: NTextInput(controller: _inv)),
              const SizedBox(height: AppDimens.xl),
              NButton(label: 'ЗАКРЕПИТЬ', onPressed: _save),
              const SizedBox(height: AppDimens.sm),
            ],
          ),
        ),
      ],
    );
  }
}
