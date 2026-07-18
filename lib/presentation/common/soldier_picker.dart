import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/n_indicators.dart';
import '../../core/widgets/n_panel.dart';
import '../../core/widgets/n_sheet.dart';
import '../../data/database/app_database.dart';
import '../providers/app_providers.dart';
import 'status_ui.dart';

/// Выбор бойца из штата (для добавления отпуска/командировки).
Future<PersonRow?> pickSoldier(BuildContext context, WidgetRef ref, {String title = 'Выберите бойца'}) {
  return showNSheet<PersonRow>(
    context: context,
    expand: true,
    builder: (_) => _SoldierPicker(title: title),
  );
}

class _SoldierPicker extends ConsumerStatefulWidget {
  const _SoldierPicker({required this.title});
  final String title;

  @override
  ConsumerState<_SoldierPicker> createState() => _SoldierPickerState();
}

class _SoldierPickerState extends ConsumerState<_SoldierPicker> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final roster = ref.watch(effectiveRosterProvider).value ?? const [];
    final list = roster.where((s) {
      if (s.isVacant) return false;
      if (_q.isEmpty) return true;
      return s.view.fullName.toLowerCase().contains(_q.toLowerCase());
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, AppDimens.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: AppTypography.title),
              const SizedBox(height: AppDimens.md),
              TextField(
                autofocus: false,
                style: AppTypography.body,
                cursorColor: AppColors.accentPrimary,
                onChanged: (v) => setState(() => _q = v),
                decoration: InputDecoration(
                  hintText: 'Поиск по фамилии',
                  hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.bgLcd,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.rMd),
                    borderSide: const BorderSide(color: AppColors.stroke),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(AppDimens.md, 0, AppDimens.md, AppDimens.md),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final s = list[i];
              return NPanel(
                margin: const EdgeInsets.only(bottom: AppDimens.sm),
                onTap: () => Navigator.pop(context, s.view.person),
                child: Row(
                  children: [
                    StatusLed(s.status!.color),
                    const SizedBox(width: AppDimens.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.view.displayName, style: AppTypography.name),
                          const SizedBox(height: 2),
                          Text('${s.view.position.title} · ${s.view.position.subunit}',
                              style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
