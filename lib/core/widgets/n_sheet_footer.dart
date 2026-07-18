import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'app_icons.dart';

/// Нижняя панель форм: «← Назад» и «Сохранить». Закреплена внизу окна ввода.
class NSheetFooter extends StatelessWidget {
  const NSheetFooter({
    super.key,
    required this.onSave,
    this.saveLabel = 'СОХРАНИТЬ',
    this.onBack,
  });

  final VoidCallback? onSave;
  final String saveLabel;

  /// По умолчанию — закрыть окно (Navigator.pop).
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.lg,
        AppDimens.sm,
        AppDimens.lg,
        AppDimens.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgRaised,
        border: Border(top: BorderSide(color: AppColors.stroke)),
      ),
      child: Row(
        children: [
          _backButton(context),
          const SizedBox(width: AppDimens.md),
          Expanded(child: _saveButton()),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: onBack ?? () => Navigator.of(context).maybePop(),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.bgLcd,
          borderRadius: BorderRadius.circular(AppDimens.rMd),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.arrowLeft, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text('НАЗАД',
                style: AppTypography.data.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return GestureDetector(
      onTap: onSave,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onSave == null ? AppColors.stroke : AppColors.accentPrimary,
          borderRadius: BorderRadius.circular(AppDimens.rMd),
        ),
        child: Text(saveLabel,
            style: AppTypography.data.copyWith(
                fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.bgPage)),
      ),
    );
  }
}
