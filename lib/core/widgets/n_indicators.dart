import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../theme/app_typography.dart';

/// Светящийся статус-светодиод.
class StatusLed extends StatelessWidget {
  const StatusLed(this.color, {super.key, this.size = 9});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: AppDecorations.ledGlow(color),
        ),
      );
}

/// Тонкая цветная полоса категории (слева от карточки).
class CategoryBar extends StatelessWidget {
  const CategoryBar(this.color, {super.key, this.width = 3});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}

/// Компактный тег с контуром (звание, тип награды, статус отпуска).
class NTag extends StatelessWidget {
  const NTag(
    this.text, {
    super.key,
    this.color = AppColors.textSecondary,
    this.filled = false,
  });

  final String text;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color, width: 1),
        ),
        child: Text(
          text.toUpperCase(),
          style: AppTypography.data.copyWith(
            fontSize: 8,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
            color: filled ? AppColors.bgPage : color,
          ),
        ),
      );
}

/// Утопленный индикатор-полоса (прогресс/распределение).
class NProgressTrack extends StatelessWidget {
  const NProgressTrack({
    super.key,
    required this.fraction,
    required this.color,
    this.height = 9,
  });

  final double fraction;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.bgLcd,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: fraction.clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.6), color],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      );
}
