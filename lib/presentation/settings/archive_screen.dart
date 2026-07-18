import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/n_indicators.dart';
import '../../core/widgets/n_panel.dart';
import '../../core/widgets/n_sheet.dart';
import '../../data/database/app_database.dart';
import '../common/status_ui.dart';
import '../providers/app_providers.dart';

/// Архив исключённых бойцов: восстановление на вакантную должность или удаление.
class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  String _name(PersonRow p) {
    final initials = [p.firstName, p.middleName].where((s) => s.isNotEmpty).join(' ');
    return initials.isEmpty ? p.lastName : '${p.lastName} $initials';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archived = ref.watch(archivedProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Архив', style: AppTypography.title),
        leading: IconButton(
          icon: Icon(AppIcons.arrowLeft, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: archived.isEmpty
          ? EmptyState(
              icon: AppIcons.userMinus,
              title: 'Архив пуст',
              message: 'Исключённые бойцы появятся здесь',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppDimens.lg),
              itemCount: archived.length,
              itemBuilder: (_, i) {
                final p = archived[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimens.sm),
                  child: NPanel(
                    child: Row(
                      children: [
                        Icon(AppIcons.userMinus, size: 18, color: AppColors.statusExcluded),
                        const SizedBox(width: AppDimens.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_name(p), style: AppTypography.name),
                              if (p.rank.isNotEmpty)
                                Text(p.rank, style: AppTypography.dataSmall),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => _restore(context, ref, p),
                          child: Text('Вернуть', style: AppTypography.data.copyWith(color: AppColors.accentPrimary)),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(AppIcons.trash, size: 16, color: AppColors.textTertiary),
                          onPressed: () => _delete(context, ref, p),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _restore(BuildContext context, WidgetRef ref, PersonRow p) async {
    final vacancies = ref.read(vacantPositionsProvider);
    if (vacancies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет вакантных должностей для восстановления')),
      );
      return;
    }
    await showNSheet(
      context: context,
      expand: true,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(AppDimens.md),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.sm),
            child: Text('Вернуть ${_name(p)} на должность', style: AppTypography.title),
          ),
          for (final pos in vacancies)
            NPanel(
              margin: const EdgeInsets.only(bottom: AppDimens.sm),
              onTap: () async {
                await ref.read(appDatabaseProvider).restorePerson(p.id, pos.id);
                if (context.mounted) Navigator.pop(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 34),
                  CategoryBar(pos.category.color),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(pos.title, style: AppTypography.name),
                        Text(pos.subunit, style: AppTypography.dataSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, PersonRow p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.statusSick),
        ),
        title: Text('Удалить из архива?', style: AppTypography.title.copyWith(color: AppColors.statusSick)),
        content: Text('${_name(p)} будет удалён безвозвратно со всеми записями.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Удалить', style: AppTypography.body.copyWith(color: AppColors.statusSick)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(appDatabaseProvider).deletePersonForever(p.id);
    }
  }
}
