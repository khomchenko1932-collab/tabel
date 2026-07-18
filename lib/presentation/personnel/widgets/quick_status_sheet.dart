import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/n_indicators.dart';
import '../../../core/widgets/n_sheet.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/entities/enums.dart';
import '../../common/status_ui.dart';
import '../../providers/app_providers.dart';

/// Быстрая смена статуса бойца (по долгому нажатию на карточку).
Future<void> showQuickStatus(
  BuildContext context,
  WidgetRef ref,
  PersonRow person,
  String subtitle,
) {
  return showNSheet(
    context: context,
    builder: (_) => _QuickStatusBody(person: person, subtitle: subtitle),
  );
}

class _QuickStatusBody extends ConsumerStatefulWidget {
  const _QuickStatusBody({required this.person, required this.subtitle});
  final PersonRow person;
  final String subtitle;

  @override
  ConsumerState<_QuickStatusBody> createState() => _QuickStatusBodyState();
}

class _QuickStatusBodyState extends ConsumerState<_QuickStatusBody> {
  late final PersonnelStatus _selected = widget.person.status;

  @override
  Widget build(BuildContext context) {
    final name = [widget.person.lastName, widget.person.firstName, widget.person.middleName]
        .where((s) => s.isNotEmpty)
        .join(' ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name.toUpperCase(), style: AppTypography.title),
          const SizedBox(height: 2),
          Text(widget.subtitle, style: AppTypography.caption),
          const SizedBox(height: AppDimens.lg),
          for (final s in PersonnelStatus.values) _option(s),
          const SizedBox(height: AppDimens.sm),
        ],
      ),
    );
  }

  Future<void> _apply(PersonnelStatus s) async {
    await ref.read(appDatabaseProvider).setStatus(widget.person.id, s);
    if (mounted) Navigator.pop(context);
  }

  Widget _option(PersonnelStatus s) {
    final active = s == _selected;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _apply(s),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimens.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: AppDimens.md),
        decoration: BoxDecoration(
          color: active ? AppColors.accentFaint : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.rMd),
          border: Border.all(
            color: active ? s.color : AppColors.stroke,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            StatusLed(s.color),
            const SizedBox(width: AppDimens.md),
            Expanded(
              child: Text(
                s.label,
                style: AppTypography.body.copyWith(
                  color: active ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
            Icon(
              active ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: active ? s.color : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
