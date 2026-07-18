import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Типографика в стиле Nothing: Space Grotesk для UI, JetBrains Mono для данных.
///
/// Шрифты забандлены в assets/fonts/ui (pubspec `fonts:`) — приложение
/// офлайн, из сети ничего не тянем. Кириллицы в Space Grotesk нет — для неё
/// системный fallback (как и было при google_fonts).
abstract final class AppTypography {
  static const String uiFamily = 'SpaceGrotesk';
  static const String monoFamily = 'JetBrainsMono';
  static const String wordmarkFamily = 'RussoOne';

  static TextStyle _sg({
    required double size,
    FontWeight weight = FontWeight.w400,
    double spacing = 0,
    Color color = AppColors.textPrimary,
    double? height,
  }) =>
      TextStyle(
        fontFamily: uiFamily,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: spacing,
        color: color,
        height: height,
      );

  static TextStyle _jb({
    required double size,
    FontWeight weight = FontWeight.w400,
    double spacing = 0.5,
    Color color = AppColors.textSecondary,
    double? height,
  }) =>
      TextStyle(
        fontFamily: monoFamily,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: spacing,
        color: color,
        height: height,
      );

  // ── UI (Space Grotesk) ──────────────────────────────────────────────
  /// Заголовок экрана.
  static TextStyle get display =>
      _sg(size: 24, weight: FontWeight.w700, spacing: -0.4);

  /// Крупный заголовок карточки/секции.
  static TextStyle get title =>
      _sg(size: 16, weight: FontWeight.w700, spacing: -0.2);

  /// Имя бойца в списке.
  static TextStyle get name => _sg(size: 14, weight: FontWeight.w500);

  /// Основной текст.
  static TextStyle get body => _sg(size: 14, spacing: 0.1);

  /// Подпись должности/пояснение.
  static TextStyle get caption =>
      _sg(size: 11, color: AppColors.textSecondary, spacing: 0.1);

  /// UPPERCASE-метка секции.
  static TextStyle get label => _sg(
        size: 9,
        weight: FontWeight.w500,
        spacing: 2,
        color: AppColors.textSecondary,
      );

  // ── Данные (JetBrains Mono) ─────────────────────────────────────────
  /// Числа, номера, серийники.
  static TextStyle get data => _jb(size: 12);

  /// Мелкие данные (даты в подписи).
  static TextStyle get dataSmall => _jb(size: 9, color: AppColors.textTertiary);

  /// Табло-цифры на LCD.
  static TextStyle get lcd => _jb(
        size: 13,
        weight: FontWeight.w700,
        spacing: 1.5,
        color: AppColors.accentBright,
      );

  /// Большой счётчик строевой записки.
  static TextStyle get counter => _jb(
        size: 40,
        weight: FontWeight.w700,
        spacing: -1,
        height: 1,
        color: AppColors.accentBright,
      );

  /// Подпись вкладки в навигации.
  static TextStyle get navLabel => _jb(size: 7.5, spacing: 0.5);

  /// Логотип-кикер «ТАБЕЛЬ · Л/С».
  static TextStyle get kicker => _jb(
        size: 9,
        weight: FontWeight.w500,
        spacing: 2,
        color: AppColors.accentPrimary,
      );

  /// Крупный вордмарк «Табель» — геометрический шрифт Russo One со свечением.
  static TextStyle wordmark({double size = 34}) => TextStyle(
        fontFamily: wordmarkFamily,
        fontSize: size,
        letterSpacing: 1.5,
        color: AppColors.accentBright,
        shadows: [
          const Shadow(color: AppColors.accentPrimary, blurRadius: 18),
        ],
      );
}
