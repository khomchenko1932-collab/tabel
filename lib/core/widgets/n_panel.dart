import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../theme/app_dimens.dart';

/// Матовая графитовая панель с фаской — базовая поверхность интерфейса.
class NPanel extends StatelessWidget {
  const NPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimens.md),
    this.margin,
    this.radius = AppDimens.rLg,
    this.border,
    this.glow = false,
    this.glowColor = AppColors.accentPrimary,
    this.onTap,
    this.onLongPress,
    this.clip = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final Color? border;
  final bool glow;
  final Color glowColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Обрезать содержимое по скруглению (для панелей со строками-разделителями).
  final bool clip;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding,
      decoration: AppDecorations.panel(
        radius: radius,
        border: border,
        glow: glow,
        glowColor: glowColor,
      ),
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      child: child,
    );

    if (onTap != null || onLongPress != null) {
      content = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          splashColor: AppColors.accentFaint,
          highlightColor: AppColors.accentFaint.withValues(alpha: 0.4),
          child: content,
        ),
      );
    }

    if (margin != null) {
      return Padding(padding: margin!, child: content);
    }
    return content;
  }
}

/// Утопленный «экран» (LCD) под цифры/данные.
class NLcd extends StatelessWidget {
  const NLcd({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.radius = AppDimens.rMd,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: AppDecorations.lcd(radius: radius),
        child: child,
      );
}
