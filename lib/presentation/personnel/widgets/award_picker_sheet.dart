import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:narmb_ls/core/widgets/app_icons.dart';

import '../../../core/data/award_catalog.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/n_indicators.dart';
import '../../../core/widgets/n_section_header.dart';
import '../../../core/widgets/n_sheet.dart';
import '../../../data/database/app_database.dart';
import '../../providers/app_providers.dart';

/// Выплывающий выбор награды из справочника (гос. + ведомственные Росгвардии).
Future<void> showAwardPicker(BuildContext context, WidgetRef ref, int personId) {
  return showNSheet(
    context: context,
    expand: true,
    builder: (_) => _AwardPickerBody(ref: ref, personId: personId),
  );
}

class _AwardPickerBody extends StatelessWidget {
  const _AwardPickerBody({required this.ref, required this.personId});
  final WidgetRef ref;
  final int personId;

  Future<void> _select(BuildContext context, AwardTemplate t) async {
    String? degree;
    if (t.hasDegrees) {
      degree = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => NSheet(
          title: 'Степень',
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.lg),
            child: Wrap(
              spacing: AppDimens.sm,
              children: [
                for (final d in t.degrees)
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx, d),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.bgLcd,
                        borderRadius: BorderRadius.circular(AppDimens.rMd),
                        border: Border.all(color: AppColors.accentDim),
                      ),
                      child: Text('$d ст.', style: AppTypography.lcd.copyWith(color: AppColors.accentPrimary)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      if (degree == null) return; // отмена выбора степени
    }

    if (!context.mounted) return;
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      locale: const Locale('ru'),
      helpText: 'Дата награждения (можно пропустить)',
    );

    await ref.read(appDatabaseProvider).addAward(
          AwardsCompanion.insert(
            personnelId: personId,
            name: t.name,
            kind: t.kind,
            degree: Value(degree),
            awardDate: Value(date),
          ),
        );
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: AppDimens.sm)),
        _section(context, 'Государственные', AwardCatalog.state),
        _section(context, 'Ведомственные · Росгвардия', AwardCatalog.rosgvardia),
        const SliverToBoxAdapter(child: SizedBox(height: AppDimens.lg)),
      ],
    );
  }

  Widget _section(BuildContext context, String title, List<AwardTemplate> items) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: NSectionHeader(title, color: AppColors.accentPrimary)),
        SliverList.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final t = items[i];
            return InkWell(
              onTap: () => _select(context, t),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg, vertical: AppDimens.md),
                child: Row(
                  children: [
                    Icon(AppIcons.medal,
                        size: 18,
                        color: t.kind == AwardKind.state
                            ? AppColors.statusTrip
                            : AppColors.textSecondary),
                    const SizedBox(width: AppDimens.md),
                    Expanded(child: Text(t.name, style: AppTypography.body)),
                    if (t.hasDegrees)
                      Text(t.degrees.join('/'),
                          style: AppTypography.dataSmall)
                    else
                      NTag(t.kind.short,
                          color: t.kind == AwardKind.state
                              ? AppColors.statusTrip
                              : AppColors.textTertiary),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
