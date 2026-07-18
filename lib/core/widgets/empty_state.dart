import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

/// Пустое состояние: иконка + заголовок + пояснение.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
  });

  final IconData icon;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.textTertiary),
            const SizedBox(height: AppDimens.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(color: AppColors.textSecondary),
            ),
            if (message != null) ...[
              const SizedBox(height: AppDimens.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
