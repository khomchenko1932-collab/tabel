import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// Шапка экрана: кикер «NARMB · LS», крупный заголовок, опциональные
/// подзаголовок и действие справа. Тёмный градиент с нижней границей.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.kicker = 'ТАБЕЛЬ · Л/С',
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String kicker;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.lg,
        MediaQuery.of(context).padding.top + AppDimens.md,
        AppDimens.lg,
        AppDimens.sm,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bgHeader, AppColors.bgPage],
        ),
        border: Border(bottom: BorderSide(color: AppColors.stroke, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(kicker, style: AppTypography.kicker),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: Text(title, style: AppTypography.display)),
              ?trailing,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(subtitle!, style: AppTypography.data),
          ],
        ],
      ),
    );
  }
}
