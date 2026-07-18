import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

/// Кнопка со скевоморфным нажатием (scale 0.97). Два вида: залитая и контурная.
class NButton extends StatefulWidget {
  const NButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.outline = false,
    this.color = AppColors.accentPrimary,
    this.expand = true,
    this.height = AppDimens.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outline;
  final Color color;
  final bool expand;
  final double height;

  @override
  State<NButton> createState() => _NButtonState();
}

class _NButtonState extends State<NButton> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onPressed != null) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final fg = widget.outline ? widget.color : AppColors.bgPage;

    final content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 18, color: fg),
          const SizedBox(width: AppDimens.sm),
        ],
        Text(
          widget.label,
          style: AppTypography.title.copyWith(
            fontSize: 13,
            letterSpacing: 0.8,
            color: fg,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: const Duration(milliseconds: 80),
        child: Opacity(
          opacity: enabled ? 1 : 0.4,
          child: Container(
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            alignment: Alignment.center,
            decoration: widget.outline
                ? BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDimens.rSm),
                    border: Border.all(color: widget.color, width: 1),
                  )
                : AppDecorations.accent(radius: AppDimens.rSm),
            child: content,
          ),
        ),
      ),
    );
  }
}
