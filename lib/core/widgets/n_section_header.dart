import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

/// Заголовок секции: «── МЕТКА ──────────» с линией и опциональным хвостом.
class NSectionHeader extends StatelessWidget {
  const NSectionHeader(
    this.label, {
    super.key,
    this.color = AppColors.textSecondary,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(
      AppDimens.lg,
      AppDimens.lg,
      AppDimens.lg,
      AppDimens.sm,
    ),
  });

  final String label;
  final Color color;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Text(label.toUpperCase(), style: AppTypography.label.copyWith(color: color)),
          const SizedBox(width: AppDimens.sm),
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.strokeStrong, Colors.transparent],
                ),
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppDimens.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}
