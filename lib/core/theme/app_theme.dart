import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';

/// Тёмная тема «Тактический графит».
abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgPage,
      canvasColor: AppColors.bgPage,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.bgPage,
        primary: AppColors.accentPrimary,
        secondary: AppColors.accentDim,
        onPrimary: AppColors.bgPage,
        onSurface: AppColors.textPrimary,
        error: AppColors.statusSick,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: AppTypography.uiFamily,
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgHeader,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.title,
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.stroke,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgOverlay,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.rXl)),
        ),
      ),
      splashColor: AppColors.accentFaint,
      highlightColor: AppColors.accentFaint,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgRaised,
        contentTextStyle: AppTypography.body,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rMd),
          side: const BorderSide(color: AppColors.stroke),
        ),
      ),
    );
  }
}
