import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

/// Скевоморфные декорации «тактического графита»: матовые панели с фаской,
/// утопленные LCD-табло и подсвеченные акцентные поверхности.
abstract final class AppDecorations {
  /// Матовая графитовая панель: градиент + светлый кант сверху + тень снизу.
  static BoxDecoration panel({
    double radius = AppDimens.rLg,
    Color? border,
    bool glow = false,
    Color glowColor = AppColors.accentPrimary,
  }) =>
      BoxDecoration(
        gradient: AppColors.panelGradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border ?? AppColors.stroke, width: 1),
        boxShadow: [
          // глубокая тень-опора снизу
          const BoxShadow(
            color: AppColors.bevelDark,
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: -2,
          ),
          // тонкий светлый кант сверху (эмбоссинг)
          const BoxShadow(
            color: AppColors.bevelLight,
            offset: Offset(0, -1),
            blurRadius: 0,
            spreadRadius: -1,
          ),
          if (glow)
            BoxShadow(
              color: glowColor.withValues(alpha: 0.28),
              blurRadius: 16,
            ),
        ],
      );

  /// Утопленный экран (LCD) под цифры/данные — внутренняя тень.
  static BoxDecoration lcd({double radius = AppDimens.rMd}) => BoxDecoration(
        color: AppColors.bgLcd,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0xCC000000),
            offset: Offset(0, 2),
            blurRadius: 6,
            spreadRadius: -1,
          ),
        ],
      );

  /// Подсвеченная акцентная поверхность (кнопка, активный чип).
  static BoxDecoration accent({
    double radius = AppDimens.rSm,
    bool glow = true,
  }) =>
      BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.accentBright, width: 1),
        boxShadow: [
          if (glow)
            BoxShadow(
              color: AppColors.accentPrimary.withValues(alpha: 0.40),
              blurRadius: 8,
            ),
        ],
      );

  /// Верхняя фаска (тонкий светлый кант) — накладывается поверх панели.
  static Border get topBevel => const Border(
        top: BorderSide(color: AppColors.bevelLight, width: 1),
      );

  /// Свечение статус-светодиода.
  static List<BoxShadow> ledGlow(Color color) => [
        BoxShadow(color: color, blurRadius: 7),
      ];
}
