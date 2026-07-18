import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// Диалог подтверждения удаления. Возвращает true, если пользователь подтвердил.
/// Для необратимых удалений по одиночному тапу (награда, оружие и т. п.).
Future<bool> confirmDelete(BuildContext context, {required String what}) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.bgRaised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.rLg),
        side: const BorderSide(color: AppColors.stroke),
      ),
      title: Text('Удалить $what?',
          style: AppTypography.title.copyWith(color: AppColors.statusSick)),
      content: Text('Отменить нельзя.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text('Отмена',
              style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text('Удалить',
              style: AppTypography.body.copyWith(color: AppColors.statusSick)),
        ),
      ],
    ),
  );
  return res == true;
}

/// Показывает SnackBar «удалено · Отмена» после свайп-удаления.
/// [onUndo] возвращает элемент обратно, если пользователь нажал «Отмена».
///
/// Удаление уже выполнено к моменту вызова — SnackBar лишь предлагает откат,
/// чтобы случайный свайп не приводил к безвозвратной потере данных.
void showUndoSnackBar(
  BuildContext context, {
  required String label,
  required Future<void> Function() onUndo,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(label),
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Отмена',
        textColor: AppColors.accentPrimary,
        onPressed: () => onUndo(),
      ),
    ),
  );
}
