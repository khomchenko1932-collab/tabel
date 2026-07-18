import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/n_indicators.dart';
import '../../../core/widgets/n_panel.dart';
import '../../../core/widgets/n_sheet.dart';
import '../../common/status_ui.dart';
import '../../providers/app_providers.dart';

/// Перевод бойца на вакантную должность.
Future<void> showTransfer(BuildContext context, int personId, String name) {
  return showNSheet(
    context: context,
    expand: true,
    builder: (_) => _TransferBody(personId: personId, name: name),
  );
}

class _TransferBody extends ConsumerWidget {
  const _TransferBody({required this.personId, required this.name});
  final int personId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vacancies = ref.watch(vacantPositionsProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, AppDimens.md),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Перевод', style: AppTypography.title),
                const SizedBox(height: 2),
                Text('$name → выберите вакантную должность', style: AppTypography.caption),
              ],
            ),
          ),
        ),
        if (vacancies.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppDimens.xl),
            child: Text('Нет свободных должностей', style: AppTypography.caption),
          )
        else
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(AppDimens.md, 0, AppDimens.md, AppDimens.md),
              itemCount: vacancies.length,
              itemBuilder: (_, i) {
                final pos = vacancies[i];
                return NPanel(
                  margin: const EdgeInsets.only(bottom: AppDimens.sm),
                  onTap: () async {
                    await ref.read(appDatabaseProvider).transferPerson(personId, pos.id);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: IntrinsicHeight(
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CategoryBar(pos.category.color, width: 3),
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
                          children: [
                            Text(pos.title, style: AppTypography.name),
                            const SizedBox(height: 2),
                            Text(
                              '${pos.subunit}${pos.crew != null ? ' · ${pos.crew}' : ''} · ${pos.category.label}',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward, size: 16, color: AppColors.accentPrimary),
                    ],
                  ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
