import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

/// Показать модальный лист в стиле приложения.
Future<T?> showNSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool expand = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => NSheet(expand: expand, child: builder(ctx)),
  );
}

/// Оболочка нижнего листа: тёмный фон, ручка, скругление сверху.
class NSheet extends StatelessWidget {
  const NSheet({super.key, required this.child, this.title, this.expand = false});

  final Widget child;
  final String? title;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * (expand ? 0.92 : 0.85),
        ),
        decoration: const BoxDecoration(
          color: AppColors.bgOverlay,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.rXl)),
          border: Border(top: BorderSide(color: AppColors.strokeStrong, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppDimens.sm),
            Container(
              width: 34,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.strokeStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (title != null) ...[
              const SizedBox(height: AppDimens.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(title!, style: AppTypography.title),
                ),
              ),
            ],
            Flexible(child: child),
            SizedBox(height: MediaQuery.of(context).padding.bottom + AppDimens.md),
          ],
        ),
      ),
    );
  }
}
